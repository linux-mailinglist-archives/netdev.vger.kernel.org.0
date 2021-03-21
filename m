Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6CF343393
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhCURCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26785 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230160AbhCURB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616346115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHqiTJtJld6FwbE1kXjCrkouGBXlsmxf64Tdd5AdhB8=;
        b=O9lMVPzj8R37f314DBdJkQpy12aMj8SVP2qMYrYrurViwevBUQCDr/dGUqKWfksAwn8v+7
        ucDtyUO5Be4MjV2c03bOiAH30Yi6+jGWu9n8iwLe4JEvrLm452FYHdKHgwObUUNBcgAJwW
        uVF17Je6zsXZxcuFL8lF7uF4S8FaCIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-SDbHGGSlMPia-SY86ErBSQ-1; Sun, 21 Mar 2021 13:01:51 -0400
X-MC-Unique: SDbHGGSlMPia-SY86ErBSQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C664101371B;
        Sun, 21 Mar 2021 17:01:50 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB6776267B;
        Sun, 21 Mar 2021 17:01:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 4/8] udp: never accept GSO_FRAGLIST packets
Date:   Sun, 21 Mar 2021 18:01:15 +0100
Message-Id: <c77bb9511c1c10193cc05651ed785506d6aee3e8.1616345643.git.pabeni@redhat.com>
In-Reply-To: <cover.1616345643.git.pabeni@redhat.com>
References: <cover.1616345643.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the UDP protocol delivers GSO_FRAGLIST packets to
the sockets without the expected segmentation.

This change addresses the issue introducing and maintaining
a per socket bitmask of GSO types requiring segmentation.
Enabling GSO removes SKB_GSO_UDP_L4 from such mask, while
GSO_FRAGLIST packets are never accepted

Note: this also updates the 'unused' field size to really
fit the otherwise existing hole. It's size become incorrect
after commit bec1f6f69736 ("udp: generate gso with UDP_SEGMENT").

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/udp.h | 10 ++++++----
 net/ipv4/udp.c      | 12 +++++++++++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index aa84597bdc33c..6da342f15f351 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -51,7 +51,7 @@ struct udp_sock {
 					   * different encapsulation layer set
 					   * this
 					   */
-			 gro_enabled:1;	/* Can accept GRO packets */
+			 gro_enabled:1;	/* Request GRO aggregation */
 	/*
 	 * Following member retains the information to create a UDP header
 	 * when the socket is uncorked.
@@ -68,7 +68,10 @@ struct udp_sock {
 #define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
 #define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
 	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
-	__u8		 unused[3];
+	__u8		 unused[1];
+	unsigned int	 unexpected_gso;/* GSO types this socket can't accept,
+					 * any of SKB_GSO_UDP_L4 or SKB_GSO_FRAGLIST
+					 */
 	/*
 	 * For encapsulation sockets.
 	 */
@@ -131,8 +134,7 @@ static inline void udp_cmsg_recv(struct msghdr *msg, struct sock *sk,
 
 static inline bool udp_unexpected_gso(struct sock *sk, struct sk_buff *skb)
 {
-	return !udp_sk(sk)->gro_enabled && skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4;
+	return skb_is_gso(skb) && skb_shinfo(skb)->gso_type & udp_sk(sk)->unexpected_gso;
 }
 
 #define udp_portaddr_for_each_entry(__sk, list) \
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index ff54135c51ffa..1ba6d153c2f0a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1600,8 +1600,13 @@ EXPORT_SYMBOL_GPL(udp_destruct_sock);
 
 int udp_init_sock(struct sock *sk)
 {
-	skb_queue_head_init(&udp_sk(sk)->reader_queue);
+	struct udp_sock *up = udp_sk(sk);
+
+	skb_queue_head_init(&up->reader_queue);
 	sk->sk_destruct = udp_destruct_sock;
+
+	/* do not accept any GSO packet by default */
+	up->unexpected_gso = SKB_GSO_FRAGLIST | SKB_GSO_UDP_L4;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(udp_init_sock);
@@ -2674,8 +2679,13 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 
 	case UDP_GRO:
 		lock_sock(sk);
+
+		/* when enabling GRO, accept the related GSO packet type */
+		up->unexpected_gso = SKB_GSO_FRAGLIST;
 		if (valbool)
 			udp_tunnel_encap_enable(sk->sk_socket);
+		else
+			up->unexpected_gso |= SKB_GSO_UDP_L4;
 		up->gro_enabled = valbool;
 		release_sock(sk);
 		break;
-- 
2.26.2

