Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B17B35A1F4
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhDIPZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232855AbhDIPZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:25:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617981931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mniviHRvr3mz7YItFoEKm0V1YWwElkhgkxr0HEio9RQ=;
        b=PpsCL09ea7SA2m4/gZf0dkPsEw5ubWWZghFgqAwUeWDt5gQl5lLcPTWtCsS8ExTZYgIJCS
        cAPBtCdjScV4voIEo186A5w/YqCvNBS7D4Ok79XtIpHb23wu0y+YhRi+ceUIP/1lawCmgr
        u43W9G7U5pjlPBCcbipSvpN4xtWTkWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32--3GLvTVWN3a_SXyZvI-waQ-1; Fri, 09 Apr 2021 11:25:28 -0400
X-MC-Unique: -3GLvTVWN3a_SXyZvI-waQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71A7018BA281;
        Fri,  9 Apr 2021 15:25:27 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0A0560BE5;
        Fri,  9 Apr 2021 15:25:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>
Subject: [PATCH net v2] net: fix hangup on napi_disable for threaded napi
Date:   Fri,  9 Apr 2021 17:24:17 +0200
Message-Id: <883923fa22745a9589e8610962b7dc59df09fb1f.1617981844.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_disable() is subject to an hangup, when the threaded
mode is enabled and the napi is under heavy traffic.

If the relevant napi has been scheduled and the napi_disable()
kicks in before the next napi_threaded_wait() completes - so
that the latter quits due to the napi_disable_pending() condition,
the existing code leaves the NAPI_STATE_SCHED bit set and the
napi_disable() loop waiting for such bit will hang.

This patch addresses the issue by dropping the NAPI_STATE_DISABLE
bit test in napi_thread_wait(). The later napi_threaded_poll()
iteration will take care of clearing the NAPI_STATE_SCHED.

This also addresses a related problem reported by Jakub:
before this patch a napi_disable()/napi_enable() pair killed
the napi thread, effectively disabling the threaded mode.
On the patched kernel napi_disable() simply stops scheduling
the relevant thread.

v1 -> v2:
  - let the main napi_thread_poll() loop clear the SCHED bit

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0f72ff5d34ba..af8c1ea040b9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6992,7 +6992,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
+	while (!kthread_should_stop()) {
 		/* Testing SCHED_THREADED bit here to make sure the current
 		 * kthread owns this napi and could poll on this napi.
 		 * Testing SCHED bit is not enough because SCHED bit might be
@@ -7010,6 +7010,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
+
 	return -1;
 }
 
-- 
2.26.2

