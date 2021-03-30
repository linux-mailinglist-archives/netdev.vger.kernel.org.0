Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1618B34EA5D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3OZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232007AbhC3OZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 10:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617114327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=n3dNVHiWBC4xlQvP2H8lTHJSJJJXJtLrEWAbhonoIUw=;
        b=IhuXBTERDClE8BRUmNMV6Iv02ccOtGyLuAbuQ/Z2qP+CnGugiJS/QRPX82H18qjtXkXYhv
        V4WDYQ5K7s5V3ir5xLmkVgfMH21rRluVB5b564K28MJOYEmt2f+UsXijepXiC1BqDFeoNi
        cKHz8Os/s5O/NhgUymxiBcxYb0JfHYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-B5LIaVR1M_WEJY-FjN8ygA-1; Tue, 30 Mar 2021 10:25:24 -0400
X-MC-Unique: B5LIaVR1M_WEJY-FjN8ygA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA1D1019624;
        Tue, 30 Mar 2021 14:25:23 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 126CD19C44;
        Tue, 30 Mar 2021 14:25:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] net: let skb_orphan_partial wake-up waiters.
Date:   Tue, 30 Mar 2021 16:24:32 +0200
Message-Id: <880d627b79b24c0f92a47203193ed11f48c3031e.1617113947.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the mentioned helper can end-up freeing the socket wmem
without waking-up any processes waiting for more write memory.

If the partially orphaned skb is attached to an UDP (or raw) socket,
the lack of wake-up can hang the user-space.

Address the issue invoking the write_space callback after
releasing the memory, if the old skb destructor requires that.

Fixes: f6ba8d33cfbb ("netem: fix skb_orphan_partial()")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/sock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0ed98f20448a2..7a38332d748e7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2137,6 +2137,8 @@ void skb_orphan_partial(struct sk_buff *skb)
 
 		if (refcount_inc_not_zero(&sk->sk_refcnt)) {
 			WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
+			if (skb->destructor == sock_wfree)
+				sk->sk_write_space(sk);
 			skb->destructor = sock_efree;
 		}
 	} else {
-- 
2.26.2

