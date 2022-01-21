Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD0495ABF
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348967AbiAUHd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:33:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239626AbiAUHd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:33:28 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L04s57004060
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:33:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zGcLKfg+7a+bE612doocqIiqggKz3lrLWiGk1EO+Ufs=;
 b=Yf0DXlF8nDAih2OzArtZgPLZbxiMORyGcz9XGFmCIQlZ0Ti5UukMaJ8cytBalUQSq7NV
 AGeTflGrtdx38MLuOP+Aod5mQacSzLR9BUS2E/+uL/WsTfKkpiyT9KM/gnud+dIu2qzd
 lqZ/yqWr5LIWXi0RVacehFGOtN2t1zp0a9I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqhycsp3a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:33:27 -0800
Received: from twshared12416.02.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 23:33:26 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 745C55BDEC00; Thu, 20 Jan 2022 23:30:32 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v3 net-next 1/4] net: Add skb->mono_delivery_time to distinguish mono delivery_time from (rcv) timestamp
Date:   Thu, 20 Jan 2022 23:30:32 -0800
Message-ID: <20220121073032.4176877-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121073026.4173996-1-kafai@fb.com>
References: <20220121073026.4173996-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Q2MGA1yOR7iVOr8MtNFNm0jPOoPvwLOj
X-Proofpoint-GUID: Q2MGA1yOR7iVOr8MtNFNm0jPOoPvwLOj
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->tstamp was first used as the (rcv) timestamp in real time clock base.
The major usage is to report it to the user (e.g. SO_TIMESTAMP).

Later, skb->tstamp is also set as the (future) delivery_time (e.g. EDT in T=
CP)
during egress and used by the qdisc (e.g. sch_fq) to make decision on when
the skb can be passed to the dev.

Currently, there is no way to tell skb->tstamp having the (rcv) timestamp
or the delivery_time, so it is always reset to 0 whenever forwarded
between egress and ingress.

While it makes sense to always clear the (rcv) timestamp in skb->tstamp
to avoid confusing sch_fq that expects the delivery_time, it is a
performance issue [0] to clear the delivery_time if the skb finally
egress to a fq@phy-dev.  For example, when forwarding from egress to
ingress and then finally back to egress:

            tcp-sender =3D> veth@netns =3D> veth@hostns =3D> fq@eth0@hostns
                                     ^              ^
                                     reset          rest

[0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/at=
tachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf

This patch adds one bit skb->mono_delivery_time to flag the skb->tstamp
is storing the mono delivery_time instead of the (rcv) timestamp.

The current use case is to keep the TCP mono delivery_time (EDT) and
to be used with sch_fq.  The later patch will also allow tc-bpf to read
and change the mono delivery_time.

In the future, another bit (e.g. skb->user_delivery_time) can be added
for the SCM_TXTIME where the clock base is tracked by sk->sk_clockid.

[ This patch is a prep work.  The following patch will
  get the other parts of the stack ready first.  Then another patch
  after that will finally set the skb->mono_delivery_time. ]

skb_set_delivery_time() function is added.  It is used by the tcp_output.c
and during ip[6] fragmentation to assign the delivery_time to
the skb->tstamp and also set the skb->mono_delivery_time.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h                     | 13 +++++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c |  5 +++--
 net/ipv4/ip_output.c                       |  5 +++--
 net/ipv4/tcp_output.c                      | 16 +++++++++-------
 net/ipv6/ip6_output.c                      |  5 +++--
 net/ipv6/netfilter.c                       |  5 +++--
 6 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..b9e20187242a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -720,6 +720,10 @@ typedef unsigned char *sk_buff_data_t;
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
+ *	@mono_delivery_time: When set, skb->tstamap has the
+ *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
+ *		skb->tstamp has the (rcv) timestamp at ingress and
+ *		delivery_time at egress.
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -890,6 +894,7 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
+	__u8			mono_delivery_time:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -3903,6 +3908,14 @@ static inline ktime_t net_invalid_timestamp(void)
 	return 0;
 }
=20
+static inline void skb_set_delivery_time(struct sk_buff *skb, ktime_t kt,
+					 bool mono)
+{
+	skb->tstamp =3D kt;
+	/* Setting mono_delivery_time will be enabled later */
+	/* skb->mono_delivery_time =3D kt && mono; */
+}
+
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfil=
ter/nf_conntrack_bridge.c
index fdbed3158555..ebfb2a5c59e4 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -32,6 +32,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock=
 *sk,
 					   struct sk_buff *))
 {
 	int frag_max_size =3D BR_INPUT_SKB_CB(skb)->frag_max_size;
+	bool mono_delivery_time =3D skb->mono_delivery_time;
 	unsigned int hlen, ll_rs, mtu;
 	ktime_t tstamp =3D skb->tstamp;
 	struct ip_frag_state state;
@@ -81,7 +82,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock=
 *sk,
 			if (iter.frag)
 				ip_fraglist_prepare(skb, &iter);
=20
-			skb->tstamp =3D tstamp;
+			skb_set_delivery_time(skb, tstamp, mono_delivery_time);
 			err =3D output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -112,7 +113,7 @@ static int nf_br_ip_fragment(struct net *net, struct so=
ck *sk,
 			goto blackhole;
 		}
=20
-		skb2->tstamp =3D tstamp;
+		skb_set_delivery_time(skb2, tstamp, mono_delivery_time);
 		err =3D output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 57c1d8431386..6ba08d9bdf8e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -754,6 +754,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 {
 	struct iphdr *iph;
 	struct sk_buff *skb2;
+	bool mono_delivery_time =3D skb->mono_delivery_time;
 	struct rtable *rt =3D skb_rtable(skb);
 	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
@@ -836,7 +837,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 				ip_fraglist_prepare(skb, &iter);
 			}
=20
-			skb->tstamp =3D tstamp;
+			skb_set_delivery_time(skb, tstamp, mono_delivery_time);
 			err =3D output(net, sk, skb);
=20
 			if (!err)
@@ -892,7 +893,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
-		skb2->tstamp =3D tstamp;
+		skb_set_delivery_time(skb2, tstamp, mono_delivery_time);
 		err =3D output(net, sk, skb2);
 		if (err)
 			goto fail;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..261e9584f81e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1253,7 +1253,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct=
 sk_buff *skb,
 	tp =3D tcp_sk(sk);
 	prior_wstamp =3D tp->tcp_wstamp_ns;
 	tp->tcp_wstamp_ns =3D max(tp->tcp_wstamp_ns, tp->tcp_clock_cache);
-	skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns;
+	skb_set_delivery_time(skb, tp->tcp_wstamp_ns, true);
 	if (clone_it) {
 		oskb =3D skb;
=20
@@ -1589,7 +1589,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_=
queue,
=20
 	skb_split(skb, buff, len);
=20
-	buff->tstamp =3D skb->tstamp;
+	skb_set_delivery_time(buff, skb->tstamp, true);
 	tcp_fragment_tstamp(skb, buff);
=20
 	old_factor =3D tcp_skb_pcount(skb);
@@ -2616,7 +2616,8 @@ static bool tcp_write_xmit(struct sock *sk, unsigned =
int mss_now, int nonagle,
=20
 		if (unlikely(tp->repair) && tp->repair_queue =3D=3D TCP_SEND_QUEUE) {
 			/* "skb_mstamp_ns" is used as a start point for the retransmit timer */
-			skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
+			tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
+			skb_set_delivery_time(skb, tp->tcp_wstamp_ns, true);
 			list_move_tail(&skb->tcp_tsorted_anchor, &tp->tsorted_sent_queue);
 			tcp_init_tso_segs(skb, mss_now);
 			goto repair; /* Skip network transmission */
@@ -3541,11 +3542,12 @@ struct sk_buff *tcp_make_synack(const struct sock *=
sk, struct dst_entry *dst,
 	now =3D tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(synack_type =3D=3D TCP_SYNACK_COOKIE && ireq->tstamp_ok))
-		skb->skb_mstamp_ns =3D cookie_init_timestamp(req, now);
+		skb_set_delivery_time(skb, cookie_init_timestamp(req, now),
+				      true);
 	else
 #endif
 	{
-		skb->skb_mstamp_ns =3D now;
+		skb_set_delivery_time(skb, now, true);
 		if (!tcp_rsk(req)->snt_synack) /* Timestamp first SYNACK */
 			tcp_rsk(req)->snt_synack =3D tcp_skb_timestamp_us(skb);
 	}
@@ -3594,7 +3596,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk=
, struct dst_entry *dst,
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
=20
-	skb->skb_mstamp_ns =3D now;
+	skb_set_delivery_time(skb, now, true);
 	tcp_add_tx_delay(skb, tp);
=20
 	return skb;
@@ -3771,7 +3773,7 @@ static int tcp_send_syn_data(struct sock *sk, struct =
sk_buff *syn)
=20
 	err =3D tcp_transmit_skb(sk, syn_data, 1, sk->sk_allocation);
=20
-	syn->skb_mstamp_ns =3D syn_data->skb_mstamp_ns;
+	skb_set_delivery_time(syn, syn_data->skb_mstamp_ns, true);
=20
 	/* Now full SYN+DATA was cloned and sent (or not),
 	 * remove the SYN from the original skb (syn_data)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e..4b873413edc2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -813,6 +813,7 @@ int ip6_fragment(struct net *net, struct sock *sk, stru=
ct sk_buff *skb,
 	struct rt6_info *rt =3D (struct rt6_info *)skb_dst(skb);
 	struct ipv6_pinfo *np =3D skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
+	bool mono_delivery_time =3D skb->mono_delivery_time;
 	struct ip6_frag_state state;
 	unsigned int mtu, hlen, nexthdr_offset;
 	ktime_t tstamp =3D skb->tstamp;
@@ -903,7 +904,7 @@ int ip6_fragment(struct net *net, struct sock *sk, stru=
ct sk_buff *skb,
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
=20
-			skb->tstamp =3D tstamp;
+			skb_set_delivery_time(skb, tstamp, mono_delivery_time);
 			err =3D output(net, sk, skb);
 			if (!err)
 				IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
@@ -962,7 +963,7 @@ int ip6_fragment(struct net *net, struct sock *sk, stru=
ct sk_buff *skb,
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
-		frag->tstamp =3D tstamp;
+		skb_set_delivery_time(frag, tstamp, mono_delivery_time);
 		err =3D output(net, sk, frag);
 		if (err)
 			goto fail;
diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
index 6ab710b5a1a8..1da332450d98 100644
--- a/net/ipv6/netfilter.c
+++ b/net/ipv6/netfilter.c
@@ -121,6 +121,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, s=
truct sk_buff *skb,
 				  struct sk_buff *))
 {
 	int frag_max_size =3D BR_INPUT_SKB_CB(skb)->frag_max_size;
+	bool mono_delivery_time =3D skb->mono_delivery_time;
 	ktime_t tstamp =3D skb->tstamp;
 	struct ip6_frag_state state;
 	u8 *prevhdr, nexthdr =3D 0;
@@ -186,7 +187,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, s=
truct sk_buff *skb,
 			if (iter.frag)
 				ip6_fraglist_prepare(skb, &iter);
=20
-			skb->tstamp =3D tstamp;
+			skb_set_delivery_time(skb, tstamp, mono_delivery_time);
 			err =3D output(net, sk, data, skb);
 			if (err || !iter.frag)
 				break;
@@ -219,7 +220,7 @@ int br_ip6_fragment(struct net *net, struct sock *sk, s=
truct sk_buff *skb,
 			goto blackhole;
 		}
=20
-		skb2->tstamp =3D tstamp;
+		skb_set_delivery_time(skb2, tstamp, mono_delivery_time);
 		err =3D output(net, sk, data, skb2);
 		if (err)
 			goto blackhole;
--=20
2.30.2

