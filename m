Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A2127CFEA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbgI2NvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbgI2NvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:51:14 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D50C061755;
        Tue, 29 Sep 2020 06:51:14 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id m34so3923537pgl.9;
        Tue, 29 Sep 2020 06:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=LWCnKF/kWpp/dptz5TkNnN2Y7xpvkvQgK3bz/gbHONU=;
        b=RZpXdv70OdevhnZIg65FmoEr6pmi0oNt8Khu/oMjTdz3ZbHztPAxgE8Oc+GfboE1V1
         fFjhjtBSoHEKkQu0wHALC0W3X6GSsv8gdAcexju8uyxWj3hVPhsWc1vYJtRfnTB3Tzhx
         uc+WEn+fe+MdJUiFaa7trOQE1n/nwNtkPCy/24ZcXclBRCVL+av/EZCQfK+aEa8j7ykI
         34e3N5vN8032yn4NX5jlFL6lz9yE2zrIuJ6fWESH6j80aYyrDpIFxsH9TQGa04zXZgf4
         WTa1s2sEyohunXSCmdVggK8X0ujkv87T5SUDNJXpwbS0PAPKBHvazGSZ0nHLBNy4ltV1
         KEbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=LWCnKF/kWpp/dptz5TkNnN2Y7xpvkvQgK3bz/gbHONU=;
        b=WHnCqs7DI4mO3Hn6Gyek5rH/qP40y4UvO+q8WTvNGN8qR3Ud3mRH+SEoDIa9jLWh/x
         p3y+TYR25rZ/YfvLBmjq+BMB1MZT01eKSV1oV/T1k3pRNSARpqwXNhJ/TGNNSvzXdPY8
         6J4ai6QWktc3eiMlrrN59Ko+HU+FP59BsyaXkblTKHPsWmOupOFWJKcsaJ3Nx90VdZMI
         JNxp4LQFyK4yCOiX8EDWx62Y4CiiveePxbuGWiizOEZbZIfvIm/5PrwKpMaET5ay1pIN
         Dy6K7RnJyEj9KHsH+1BeAF0MnrHufGpz9FNTs3ot3eoLLrLkK3gvjUAmv0XQo/ml2PKA
         1eCg==
X-Gm-Message-State: AOAM532Qx1xRhFSKX7FHQcZmNmaE+2wYEG1h+wrfHSuKC0ez/M9UdNi4
        6Kzihye0XIu1wNDGsX2nLC85vJJjRq0=
X-Google-Smtp-Source: ABdhPJzNRN4v98sXKwBQOXXSprZmPsID3kxRLkiQkVclNe3YSAKxJ6/kCoaAv2qvRXHPy9NNtYxLCw==
X-Received: by 2002:a62:b40c:0:b029:142:6a8f:c2f8 with SMTP id h12-20020a62b40c0000b02901426a8fc2f8mr4274873pfn.32.1601387473158;
        Tue, 29 Sep 2020 06:51:13 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 137sm5726474pfb.183.2020.09.29.06.51.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:51:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 13/15] sctp: support for sending packet over udp4 sock
Date:   Tue, 29 Sep 2020 21:49:05 +0800
Message-Id: <82b358f40c81cfdecbfc394113be40fd1f682043.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
 <7ff312f910ada8893fa4db57d341c628d1122640.1601387231.git.lucien.xin@gmail.com>
 <3716fc0699dc1d5557574b5227524e80b7fd76b8.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch does what the rfc6951#section-5.3 says for ipv4:

  "Within the UDP header, the source port MUST be the local UDP
   encapsulation port number of the SCTP stack, and the destination port
   MUST be the remote UDP encapsulation port number maintained for the
   association and the destination address to which the packet is sent
   (see Section 5.1).

   Because the SCTP packet is the UDP payload, the length of the UDP
   packet MUST be the length of the SCTP packet plus the size of the UDP
   header.

   The SCTP checksum MUST be computed for IPv4 and IPv6, and the UDP
   checksum SHOULD be computed for IPv4 and IPv6."

Some places need to be adjusted in sctp_packet_transmit():

  1. For non-gso packets, when transport's encap_port is set, sctp
     checksum has to be done in sctp_packet_pack(), as the outer
     udp will use ip_summed = CHECKSUM_PARTIAL to do the offload
     setting for checksum.

  2. Delay calling dst_clone() and skb_dst_set() for non-udp packets
     until sctp_v4_xmit(), as for udp packets, skb_dst_set() is not
     needed before calling udp_tunnel_xmit_skb().

then in sctp_v4_xmit():

  1. Go to udp_tunnel_xmit_skb() only when transport->encap_port and
     net->sctp.udp_port both are set, as these are one for dst port
     and another for src port.

  2. For gso packet, SKB_GSO_UDP_TUNNEL_CSUM is set for gso_type, and
     with this udp checksum can be done in __skb_udp_tunnel_segment()
     for each segments after the sctp gso.

  3. inner_mac_header and inner_transport_header are set, as these
     will be needed in __skb_udp_tunnel_segment() to find the right
     headers.

  4. df and ttl are calculated, as these are the required params by
     udp_tunnel_xmit_skb().

  5. nocheck param has to be false, as "the UDP checksum SHOULD be
     computed for IPv4 and IPv6", says in rfc6951#section-5.3.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c   |  9 +++------
 net/sctp/protocol.c | 44 +++++++++++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/net/sctp/output.c b/net/sctp/output.c
index fb16500..6614c9f 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -514,8 +514,8 @@ static int sctp_packet_pack(struct sctp_packet *packet,
 	if (sctp_checksum_disable)
 		return 1;
 
-	if (!(skb_dst(head)->dev->features & NETIF_F_SCTP_CRC) ||
-	    dst_xfrm(skb_dst(head)) || packet->ipfragok) {
+	if (!(tp->dst->dev->features & NETIF_F_SCTP_CRC) ||
+	    dst_xfrm(tp->dst) || packet->ipfragok || tp->encap_port) {
 		struct sctphdr *sh =
 			(struct sctphdr *)skb_transport_header(head);
 
@@ -542,7 +542,6 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	struct sctp_association *asoc = tp->asoc;
 	struct sctp_chunk *chunk, *tmp;
 	int pkt_count, gso = 0;
-	struct dst_entry *dst;
 	struct sk_buff *head;
 	struct sctphdr *sh;
 	struct sock *sk;
@@ -579,13 +578,11 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
 	sh->checksum = 0;
 
 	/* drop packet if no dst */
-	dst = dst_clone(tp->dst);
-	if (!dst) {
+	if (!tp->dst) {
 		IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		kfree_skb(head);
 		goto out;
 	}
-	skb_dst_set(head, dst);
 
 	rcu_read_lock();
 	if (__sk_dst_get(sk) != tp->dst) {
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index c73fd5f..6606a63 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -44,6 +44,7 @@
 #include <net/addrconf.h>
 #include <net/inet_common.h>
 #include <net/inet_ecn.h>
+#include <net/udp_tunnel.h>
 
 #define MAX_SCTP_PORT_HASH_ENTRIES (64 * 1024)
 
@@ -1053,25 +1054,46 @@ static int sctp_inet_supported_addrs(const struct sctp_sock *opt,
 }
 
 /* Wrapper routine that calls the ip transmit routine. */
-static inline int sctp_v4_xmit(struct sk_buff *skb,
-			       struct sctp_transport *transport)
+static inline int sctp_v4_xmit(struct sk_buff *skb, struct sctp_transport *t)
 {
-	struct inet_sock *inet = inet_sk(skb->sk);
+	struct dst_entry *dst = dst_clone(t->dst);
+	struct flowi4 *fl4 = &t->fl.u.ip4;
+	struct sock *sk = skb->sk;
+	struct inet_sock *inet = inet_sk(sk);
+	struct net *net = sock_net(sk);
 	__u8 dscp = inet->tos;
+	__be16 df = 0;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI4, dst:%pI4\n", __func__, skb,
-		 skb->len, &transport->fl.u.ip4.saddr,
-		 &transport->fl.u.ip4.daddr);
+		 skb->len, &fl4->saddr, &fl4->daddr);
+
+	if (t->dscp & SCTP_DSCP_SET_MASK)
+		dscp = t->dscp & SCTP_DSCP_VAL_MASK;
 
-	if (transport->dscp & SCTP_DSCP_SET_MASK)
-		dscp = transport->dscp & SCTP_DSCP_VAL_MASK;
+	inet->pmtudisc = t->param_flags & SPP_PMTUD_ENABLE ? IP_PMTUDISC_DO
+							   : IP_PMTUDISC_DONT;
+	SCTP_INC_STATS(net, SCTP_MIB_OUTSCTPPACKS);
 
-	inet->pmtudisc = transport->param_flags & SPP_PMTUD_ENABLE ?
-			 IP_PMTUDISC_DO : IP_PMTUDISC_DONT;
+	if (!t->encap_port || !net->sctp.udp_port) {
+		skb_dst_set(skb, dst);
+		return __ip_queue_xmit(sk, skb, &t->fl, dscp);
+	}
+
+	if (skb_is_gso(skb))
+		skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
 
-	SCTP_INC_STATS(sock_net(&inet->sk), SCTP_MIB_OUTSCTPPACKS);
+	if (ip_dont_fragment(sk, dst) && !skb->ignore_df)
+		df = htons(IP_DF);
 
-	return __ip_queue_xmit(&inet->sk, skb, &transport->fl, dscp);
+	skb->encapsulation = 1;
+	skb_reset_inner_mac_header(skb);
+	skb_reset_inner_transport_header(skb);
+	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr,
+			    fl4->daddr, dscp, ip4_dst_hoplimit(dst), df,
+			    htons(net->sctp.udp_port), htons(t->encap_port),
+			    false, false);
+	return 0;
 }
 
 static struct sctp_af sctp_af_inet;
-- 
2.1.0

