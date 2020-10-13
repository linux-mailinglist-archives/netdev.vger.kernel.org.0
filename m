Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EECE28C952
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390259AbgJMH3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390040AbgJMH3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:29:21 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942F3C0613D0;
        Tue, 13 Oct 2020 00:29:21 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id e10so16203925pfj.1;
        Tue, 13 Oct 2020 00:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=vxgUs2t02Y6T7ju2jCDcB1sbv2HoOE9Ilv7QfTc5UB0=;
        b=cFTcAUozYLI7Z+VWMW26GGAHbCGKgt9MQyfSZy5bCLDLRtiXlrbzL0ss9UfNV26UHR
         HvPsSMRCIKUwPEWDdWKmhbiefdi+oaz1dXf73fPICuQlfu38MJrbjhwPND3wL/KhobUB
         y51AWaFY3eeiV4rI1qMj9wpe5NEh0aekz3JRB5VImJw98aSK8PHlWd5Erje2tUSSx+y3
         SeC0Cmatg3meqQtYlgSp9BpoPglsVjJG+BzWM7xJZzB+t/F2KEToxPo3D1Gjqol4o1LK
         5LBq01/ABZpf2vF/TJ2ZoW/Fw8S5F0fwjjSFsQ7y6UpfyL0u9rT1D59N52T4gKdMgyqf
         ODig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=vxgUs2t02Y6T7ju2jCDcB1sbv2HoOE9Ilv7QfTc5UB0=;
        b=T3xu/0puo629kk5pXMBpopIhH3nY9g5kECGdfAXorpN17zDQHC7eZlr536cwBkHCL9
         qOB3DqVOMzqZp6kgADIGNPPFKNM7zOhm4BdTsdari3NGvxsQ+golgkzgJmX2+xgSzQcA
         5fvKZav/gc2eLEdd2aUOwE4Ka1q7K7NYDf9YwaAPbOeUHQ1fQioJMEAZoNOZ28YmZDt+
         vKaP57Ok0MRwctZNlq8/3aP6gMFeBBTIM6hVThc2DX2P8lmBqXM/vkn0I26X+tie8MqS
         ICVG2f6kHeL0YiYD7nPmiT5kijWnIzgFnlDeZt+XV+mop+1HU2zxVSJZOKFTWX/X162h
         FaoA==
X-Gm-Message-State: AOAM532xwrlLdrJ6BLIik+fI18cbId3bt37pmv+eaCMb5hEJXIeequQJ
        HV6PVOBIjKQw/VhHTjQJMbsTbVQuixI=
X-Google-Smtp-Source: ABdhPJzw6KYgizsP2NaIDEfVwFDPQYpsvS4G/0W595JOfRPAbV50ZBJ5T0Pb/MGaKWOKRnCzGP0wqg==
X-Received: by 2002:aa7:96ce:0:b029:155:8c02:e74a with SMTP id h14-20020aa796ce0000b02901558c02e74amr18389734pfq.32.1602574160756;
        Tue, 13 Oct 2020 00:29:20 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y13sm21175630pfl.166.2020.10.13.00.29.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:29:20 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 12/16] sctp: support for sending packet over udp4 sock
Date:   Tue, 13 Oct 2020 15:27:37 +0800
Message-Id: <46f33eb9331b7e1e688a7f125201ad600ae83fbd.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
 <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
 <dbad21ff524e119f83ae4444d1ae393ab165fa7c.1602574012.git.lucien.xin@gmail.com>
 <7159fb58f44f9ff00ca5b3b8a26ee3aa2fd1bf8a.1602574012.git.lucien.xin@gmail.com>
 <b9f0bfa27c5be3bbf27a7325c73f16205286df38.1602574012.git.lucien.xin@gmail.com>
 <c9c1d019287792f71863c89758d179b133fe1200.1602574012.git.lucien.xin@gmail.com>
 <37e9f70ffb9dea1572025b8e1c4b1f1c6e6b3da5.1602574012.git.lucien.xin@gmail.com>
 <08854ecf72eee34d3e98e30def6940d94f97fdef.1602574012.git.lucien.xin@gmail.com>
 <732baa9aef67a1b0d0b4d69f47149b41a49bbd76.1602574012.git.lucien.xin@gmail.com>
 <4885b112360b734e25714499346e6dc22246a87d.1602574012.git.lucien.xin@gmail.com>
 <c97b738ae89c59f14afbbca22d0294dc24eca30f.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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

v1->v2:
  - Use sp->udp_port instead in sctp_v4_xmit(), which is more safe.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/output.c   |  9 +++------
 net/sctp/protocol.c | 41 ++++++++++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 17 deletions(-)

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
index 0d16e5e..be002b7 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1059,25 +1059,44 @@ static int sctp_inet_supported_addrs(const struct sctp_sock *opt,
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
+	SCTP_INC_STATS(sock_net(sk), SCTP_MIB_OUTSCTPPACKS);
 
-	inet->pmtudisc = transport->param_flags & SPP_PMTUD_ENABLE ?
-			 IP_PMTUDISC_DO : IP_PMTUDISC_DONT;
+	if (!t->encap_port || !sctp_sk(sk)->udp_port) {
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
+			    sctp_sk(sk)->udp_port, t->encap_port, false, false);
+	return 0;
 }
 
 static struct sctp_af sctp_af_inet;
-- 
2.1.0

