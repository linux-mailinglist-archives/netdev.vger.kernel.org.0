Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF3292749
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgJSM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727666AbgJSM1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:27:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B8FC0613CE;
        Mon, 19 Oct 2020 05:27:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y1so4894928plp.6;
        Mon, 19 Oct 2020 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=Cwqe1kdLF1BpI/Lbtq3e9NcGf1oL7Z7RjOQGe3mliTg=;
        b=gVxTGHOFsOU2ls+0582qM5I6qKd0g/0I8qTS5fcOfm3iJ5DImKz6WNt9lpj+78/V7G
         dwlifgnoMjAOTdOqZZSc6yiJjkoGUDz1sFpskM9ojGIhFkR03Z40L7GxdoLN/Z+yj6Kt
         pmZ7SpSHUqtNIN2lDXm7g5XmfrRmyv6lvKKf2DFu0JE7ksAOjCx/nBkCRUoXRryf1e8z
         6A/7LXkrfvA6WesE83MobUmgdShM0Q2nkciy2dpjmcu1XQWnG6N/jUxjvS8Wxe8vSWtj
         V+ZPldp27/xn2rk4yUru9YNJZRDc6na/ZFJSKB89IbHLgjBg0We2s0ZbXyh1bqN3v2wp
         8ynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=Cwqe1kdLF1BpI/Lbtq3e9NcGf1oL7Z7RjOQGe3mliTg=;
        b=avmtX5nRbAoHSUALBsuZhQVIIH9Wk5uV9xJTIPjssQfaouTxzHJbE32cwyw/2AFJ4z
         IeC/8UQtvh+fXj3zW1j+wppVaO08EQ7JSGOM+TuOdsBHl4tbYKY1doz0rVLTxKDPUUwO
         le8QeIcAngoTd/pvU9xsDoqgoPdf41qYL5+4BZyDpRvEetbtegvPgL8435m7C0lNSw5k
         Ey3ESWIqYoCVhsVnVpr26tPwYNUbjYAYH6CctHZEl6TGJJxCNX1Boskmy3XKyJ1nAE1W
         L0LevfWy9hyS8rarDsDuj+QyJjbYCJQASzSpZLqUJtVHLAiOlKX0BU7TosU0tFYSnPU7
         ZUsg==
X-Gm-Message-State: AOAM5311H5AXNIrkhJxCeMR/G15acGs3R/R4+o8YmlJ0+RSFZHUJBu8Z
        EhY6pcgb9t7C0cjvOsO9t85Sa/TQTZg=
X-Google-Smtp-Source: ABdhPJwaI6WzNVqztOkdCGWO78/at1kdHl9TYC189kmboEhvRCa30Ycr0XjNEmLUPG8KLsQwcidSWA==
X-Received: by 2002:a17:90a:474b:: with SMTP id y11mr16955981pjg.114.1603110432679;
        Mon, 19 Oct 2020 05:27:12 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm10936040pgv.58.2020.10.19.05.27.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:27:12 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 12/16] sctp: support for sending packet over udp4 sock
Date:   Mon, 19 Oct 2020 20:25:29 +0800
Message-Id: <2cac0eaff47574dbc07a4a074500f5e0300cff3e.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
 <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
 <5f06ac649f4b63fc5a254812a963cada3183f136.1603110316.git.lucien.xin@gmail.com>
 <e99845af51be8fdaa53a2575e8967b8c3c8d423a.1603110316.git.lucien.xin@gmail.com>
 <7a2f5792c1a428c16962fff08b7bcfedc21bd5e2.1603110316.git.lucien.xin@gmail.com>
 <7cfd72e42b8b1cde268ad4062c96c08a56c4b14f.1603110316.git.lucien.xin@gmail.com>
 <d55a0eaefa4b8a671e54535a1899ea4c00bc2de8.1603110316.git.lucien.xin@gmail.com>
 <25013493737f5b488ce48c38667a077ca6573dd5.1603110316.git.lucien.xin@gmail.com>
 <fe0630fd48830058df1bfdd53a9e6b9fbf83b498.1603110316.git.lucien.xin@gmail.com>
 <8547ef8c7056072bdeca8f5e9eb0d7fec5cdb210.1603110316.git.lucien.xin@gmail.com>
 <e8d627d45c604460c57959a124b21aaeddfb3808.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
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
index 36f471d..c8de327 100644
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

