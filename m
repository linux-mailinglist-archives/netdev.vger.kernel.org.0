Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E54D037A23D
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhEKIgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:36:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230126AbhEKIgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:36:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620722143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=61MS3Y4w0JQptx9KJ6w8U1V0xBFEqQ1A+uVtPHLuWG8=;
        b=KwryFn5ntHoZ/eLYsT3K/3+jNlSquUov8cKZWawzq3m990tjUcnoyAzsjxvalKIaL5cGHf
        WPNrkjqTgXN1O8GLX+47oc7BjgZMWVfnY5ax/fmoYR5w4JLAeVEvtlc+Sm5F70wF03biBZ
        o60y9GEOChItnFh2Nres8P0695bgqW4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-A_iIi4ltOBOHUVo8TVImuA-1; Tue, 11 May 2021 04:35:39 -0400
X-MC-Unique: A_iIi4ltOBOHUVo8TVImuA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBA5980ED8E;
        Tue, 11 May 2021 08:35:38 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-64.ams2.redhat.com [10.36.115.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D487D60843;
        Tue, 11 May 2021 08:35:37 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] net: really orphan skbs tied to closing sk
Date:   Tue, 11 May 2021 10:35:21 +0200
Message-Id: <b634d7aa85404b892a6199542c396b8ce4f94221.1620722065.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the owing socket is shutting down - e.g. the sock reference
count already dropped to 0 and only sk_wmem_alloc is keeping
the sock alive, skb_orphan_partial() becomes a no-op.

When forwarding packets over veth with GRO enabled, the above
causes refcount errors.

This change addresses the issue with a plain skb_orphan() call
in the critical scenario.

Fixes: 9adc89af724f ("net: let skb_orphan_partial wake-up waiters.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/sock.h | 4 +++-
 net/core/sock.c    | 8 ++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 42bc5e1a627f..0e962d8bc73b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2231,13 +2231,15 @@ static inline void skb_set_owner_r(struct sk_buff *skb, struct sock *sk)
 	sk_mem_charge(sk, skb->truesize);
 }
 
-static inline void skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
+static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struct sock *sk)
 {
 	if (sk && refcount_inc_not_zero(&sk->sk_refcnt)) {
 		skb_orphan(skb);
 		skb->destructor = sock_efree;
 		skb->sk = sk;
+		return true;
 	}
+	return false;
 }
 
 void sk_reset_timer(struct sock *sk, struct timer_list *timer,
diff --git a/net/core/sock.c b/net/core/sock.c
index c761c4a0b66b..958614ea16ed 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2132,10 +2132,10 @@ void skb_orphan_partial(struct sk_buff *skb)
 	if (skb_is_tcp_pure_ack(skb))
 		return;
 
-	if (can_skb_orphan_partial(skb))
-		skb_set_owner_sk_safe(skb, skb->sk);
-	else
-		skb_orphan(skb);
+	if (can_skb_orphan_partial(skb) && skb_set_owner_sk_safe(skb, skb->sk))
+		return;
+
+	skb_orphan(skb);
 }
 EXPORT_SYMBOL(skb_orphan_partial);
 
-- 
2.26.2

