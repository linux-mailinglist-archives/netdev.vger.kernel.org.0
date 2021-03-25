Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC243497E1
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 18:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCYRYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 13:24:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhCYRYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 13:24:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616693075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/LD+mAZ3VFbsPPePJY+RbUIwv9p3TD2p7Dhot6SljA=;
        b=HitFFFnJF7jEO5tOS63BBjBOu8UkBnRXR6MFUO2AGuMFb82RludW0jDVyTmMZ269yKhVUM
        HZEmfIZQ5Pd+HKg9tOFilaegOXMYUnCMTvTNGCmBHxhP89gEZ0VQD8LlIUhrtJf3MOXpr6
        FYT/M2SzmYbVv1C9HZSgW1MD29CEYnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-MITZJK-kMQatVD8rfBHzsg-1; Thu, 25 Mar 2021 13:24:31 -0400
X-MC-Unique: MITZJK-kMQatVD8rfBHzsg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF0CF1006C93;
        Thu, 25 Mar 2021 17:24:29 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-211.ams2.redhat.com [10.36.113.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDD67755E;
        Thu, 25 Mar 2021 17:24:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v2 4/8] udp: never accept GSO_FRAGLIST packets
Date:   Thu, 25 Mar 2021 18:24:03 +0100
Message-Id: <7fa75957409a3f5d14198261a7eddb2bf1bff8e1.1616692794.git.pabeni@redhat.com>
In-Reply-To: <cover.1616692794.git.pabeni@redhat.com>
References: <cover.1616692794.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the UDP protocol delivers GSO_FRAGLIST packets to
the sockets without the expected segmentation.

This change addresses the issue introducing and maintaining
a couple of new fields to explicitly accept SKB_GSO_UDP_L4
or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
accordingly.

UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
zeroed.

v1 -> v2:
 - use 2 bits instead of a whole GSO bitmask (Willem)

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/udp.h | 16 +++++++++++++---
 net/ipv4/udp.c      |  3 +++
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33c..ae58ff3b6b5b8 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -51,7 +51,9 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1;	/* Can accept GRO packets */
+			 gro_enabled:1,	/* Request GRO aggregation */
+			 accept_udp_l4:1,
+			 accept_udp_fraglist:1;
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
@@ -131,8 +133,16 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
-	return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
+	if (!skb_is_gso(skb))
+		return false;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4 && !udp_sk(sk)->accept_udp_l4)
+		return true;
+
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST && !udp_sk(sk)->accept_udp_fraglist)
+		return true;
+
+	return false;
 }
 
 #define udp_portaddr_for_each_entry(__sk, list) \
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index fe85dcf8c0087..c0695ce42dc53 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2666,9 +2666,12 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 
 	case UDP_GRO:
 		lock_sock(sk);
+
+		/* when enabling GRO, accept the related GSO packet type */
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
 		up->gro_enabled = valbool;
+		up->accept_udp_l4 = valbool;
 		release_sock(sk);
 		break;
 
-- 
2.26.2

