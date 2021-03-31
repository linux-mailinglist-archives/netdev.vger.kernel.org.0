Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D25C350A76
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCaWrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:47:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhCaWrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 18:47:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617230826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qoU3TPLBHuNIxYnpAF4zRHyqNQICs2C1L3gVH1zCGfA=;
        b=cXvqfokmUjgHj+MIdPwGDzoG+brnx+81srFLbpFJHIWnF7ZNhURDm4MFKajjKEPunGxv2U
        H8Gof6Catpgmy56wiYcHjN8QsXRgbeLRswpMGFGhO4q+snU5GZPuLj8qltJHf3xMI8ALgm
        dvMTHZSCdV+kvqSZCcZAuTo3tqdU/tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-9ZI0Vbe9MdapCp9HyW5I5g-1; Wed, 31 Mar 2021 18:47:03 -0400
X-MC-Unique: 9ZI0Vbe9MdapCp9HyW5I5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EF56800D62;
        Wed, 31 Mar 2021 22:47:02 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-93.ams2.redhat.com [10.36.112.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88A145D72F;
        Wed, 31 Mar 2021 22:47:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: fix hangup on napi_disable for threaded napi
Date:   Thu,  1 Apr 2021 00:46:18 +0200
Message-Id: <996c4bb33166b5cf8d881871ea8b61e54ad4da24.1617230551.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I hit an hangup on napi_disable(), when the threaded
mode is enabled and the napi is under heavy traffic.

If the relevant napi has been scheduled and the napi_disable()
kicks in before the next napi_threaded_wait() completes - so
that the latter quits due to the napi_disable_pending() condition,
the existing code leaves the NAPI_STATE_SCHED bit set and the
napi_disable() loop waiting for such bit will hang.

Address the issue explicitly clearing the SCHED_BIT on napi_thread
termination, if the thread is owns the napi.

Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b4c67a5be606d..e2e716ba027b8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7059,6 +7059,14 @@ static int napi_thread_wait(struct napi_struct *napi)
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
+
+	/* if the thread owns this napi, and the napi itself has been disabled
+	 * in-between napi_schedule() and the above napi_disable_pending()
+	 * check, we need to clear the SCHED bit here, or napi_disable
+	 * will hang waiting for such bit being cleared
+	 */
+	if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) || woken)
+		clear_bit(NAPI_STATE_SCHED, &napi->state);
 	return -1;
 }
 
-- 
2.26.2

