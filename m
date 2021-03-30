Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCDA34E575
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhC3KaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231561AbhC3K37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 06:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617100198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/LD+mAZ3VFbsPPePJY+RbUIwv9p3TD2p7Dhot6SljA=;
        b=PQDlEWH+0pr0sTPzhTbxr062/Zme6hEK59heU3T7Rd8BihfSY0quhjWDffTi6nTqiYzV1g
        e3kryRBdVXWk6EyHIWQqaIosPI7yV1nvQA0IgAg8YW+e+nXHOV8TVB/dUedWgoUyDcp9M1
        FN8AXDHo3B+/d/A1vImJxOdzi9mfWOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-GAAPQ8M9PUSntJZ7kFeYeQ-1; Tue, 30 Mar 2021 06:29:54 -0400
X-MC-Unique: GAAPQ8M9PUSntJZ7kFeYeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E94E87A826;
        Tue, 30 Mar 2021 10:29:53 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-56.ams2.redhat.com [10.36.115.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD9AA19C45;
        Tue, 30 Mar 2021 10:29:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next v3 4/8] udp: never accept GSO_FRAGLIST packets
Date:   Tue, 30 Mar 2021 12:28:52 +0200
Message-Id: <4dc90e5bc0f6d7152e6b6dcde4bb409fd4c6d2ea.1617099959.git.pabeni@redhat.com>
In-Reply-To: <cover.1617099959.git.pabeni@redhat.com>
References: <cover.1617099959.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

