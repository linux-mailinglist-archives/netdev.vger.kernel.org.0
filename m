Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DFA29E58A
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732695AbgJ2H5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgJ2HYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A78C08EA76;
        Thu, 29 Oct 2020 00:06:57 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f38so1596336pgm.2;
        Thu, 29 Oct 2020 00:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=x6lAVern+X5xe+q+jqABjgJ0kf11vtaWmT1ufEQ9BJk=;
        b=Z8/QfyOoVL8m2yuTqr6CQKcpTX9Hl62pvbdNzLwKyyqU7v5N19wY/BbMZpQEakLh+L
         JwY7f/y7qc0KQuoImlPNk4wGb0QwTHYShT6h0m5I11SvVgPhWPjw9IXt7AxX4nSS5cvO
         RWU1IJKeGIXnxrwulxAJye8vJHOx1Tc5ab5hwqAZRQIZT7pUOSvs+Zh35D3KjxbqQWv+
         XyLUVk1h3/Wpn+Sjz3wO5+N1zupLGgry8ulG3/yDts85/o2WSHSGGnXTc94ZFhmdB8TA
         79YyrM0kTdWC14VFSD9/fS4lO1pBXHaMtERQkV2vZknHoBSvVQKaURrlGujfVCwl5NxU
         g22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=x6lAVern+X5xe+q+jqABjgJ0kf11vtaWmT1ufEQ9BJk=;
        b=YsxH9ZHINFvoWtV/ZUnmvvuJ54iXZ0oa31kaskwxxOoPaQqZXa53fVRdXdxfX7JRjl
         sizJJYXGFzNtoSROn8CtHJMKTJ6LxRzQnJFunKWuQvT4fEj30hevvlSNsyK/KSl2KPAY
         SrL1Zpl7w5Os9pG/rfNOpEVCLv7cqvszBOfMDocjOVvdWaThKIckUCWu3xLoGRousL2f
         g4xKhfSNH4ImgqwtThtQsY7VWcy25KzyTqw606CS5QCy42HVEyHZWye/8iowl3OgmC7P
         eM3yIbfOd4a5NfbnEOxG7BjFmacn0qFKOYfBmsC2mKi0vZB5k8u8O01LBDbn1UALRTAu
         RJVw==
X-Gm-Message-State: AOAM532kzFBTeMtTmUuWzinrZLTO7c68auX2RFbDjjGzOAOidNqVqmmD
        7cdn9RjNVPzBWUQlQqVd3U0eiWETM/k=
X-Google-Smtp-Source: ABdhPJzy7sV4Y65tfscSsukLCKcinT2ET3HuNsSbItfm0Wv1PGHRNsBql2HRSRe/C9Oq9jHvl2grxQ==
X-Received: by 2002:a17:90a:6b0d:: with SMTP id v13mr2925152pjj.206.1603955216770;
        Thu, 29 Oct 2020 00:06:56 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v12sm1412491pgr.4.2020.10.29.00.06.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 00:06:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com
Subject: [PATCHv5 net-next 12/16] sctp: support for sending packet over udp4 sock
Date:   Thu, 29 Oct 2020 15:05:06 +0800
Message-Id: <88a89930e9ab2d1b2300ca81d7023feaaa818727.1603955041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
 <48053c3bf48a46899bc0130dc43adca1e6925581.1603955040.git.lucien.xin@gmail.com>
 <4f439ed717442a649ba78dc0efc6f121208a9995.1603955040.git.lucien.xin@gmail.com>
 <e7575f9fea2b867bf0c7c3e8541e8a6101610055.1603955040.git.lucien.xin@gmail.com>
 <1cfd9ca0154d35389b25f68457ea2943a19e7da2.1603955040.git.lucien.xin@gmail.com>
 <3c26801d36575d0e9c9bd260e6c1f1b67e4b721e.1603955040.git.lucien.xin@gmail.com>
 <279d266bc34ebc439114f39da983dc08845ea37a.1603955040.git.lucien.xin@gmail.com>
 <066bbdcf83188bbc62b6c458f2a0fd8f06f41640.1603955040.git.lucien.xin@gmail.com>
 <e72ab91d56df2ced82efb0c9d26d29f47d0747f7.1603955040.git.lucien.xin@gmail.com>
 <2b2703eb6a2cc84b7762ee7484a9a57408db162b.1603955040.git.lucien.xin@gmail.com>
 <1032fd094f807a870ca965e8355daf0be068008d.1603955041.git.lucien.xin@gmail.com>
 <e23bd6fddaea6641348e2115877afec5a4e2cf19.1603955041.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603955040.git.lucien.xin@gmail.com>
References: <cover.1603955040.git.lucien.xin@gmail.com>
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
index f3de8c0..41f287a 100644
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

