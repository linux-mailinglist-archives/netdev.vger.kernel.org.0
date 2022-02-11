Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AAA4B1F0F
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbiBKHNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347594AbiBKHM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:12:57 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93B8710BE
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:56 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrYmP018278
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vgpYGO1YkEQ34WOQoYqpLWFVMysT+QGf6gsCwqC096M=;
 b=HGSpabQa6/1NuCUEOn62l6jmuJVoCU7QRlQQzDbPFYm2klhs/9PFuzG3Rn54gxCaCzS2
 i6cSa3YXMovcehb/iFpAKP/JxyT9FNtOh+Pm9MAyoK8dBnRuqLTHzpSgUMAQONJpMmon
 GvW8yvO/wBNz8BRC/iqJONyVwfO7d4dIbE8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e592ukfrk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:12:55 -0800
Received: from twshared0983.05.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:12:43 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 973146C756E9; Thu, 10 Feb 2022 23:12:38 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 1/8] net: Add skb->mono_delivery_time to distinguish mono delivery_time from (rcv) timestamp
Date:   Thu, 10 Feb 2022 23:12:38 -0800
Message-ID: <20220211071238.885669-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: K0e099wPFfQbYOKnggL8W-pDysOAj84T
X-Proofpoint-ORIG-GUID: K0e099wPFfQbYOKnggL8W-pDysOAj84T
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->tstamp was first used as the (rcv) timestamp.
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

This patch adds one bit skb->mono_delivery_time to flag the skb->tstamp
is storing the mono delivery_time (EDT) instead of the (rcv) timestamp.

The current use case is to keep the TCP mono delivery_time (EDT) and
to be used with sch_fq.  A later patch will also allow tc-bpf@ingress
to read and change the mono delivery_time.

In the future, another bit (e.g. skb->user_delivery_time) can be added
for the SCM_TXTIME where the clock base is tracked by sk->sk_clockid.

[ This patch is a prep work.  The following patch will
  get the other parts of the stack ready first.  Then another patch
  after that will finally set the skb->mono_delivery_time. ]

skb_set_delivery_time() function is added.  It is used by the tcp_output.c
and during ip[6] fragmentation to assign the delivery_time to
the skb->tstamp and also set the skb->mono_delivery_time.

A note on the change in ip_send_unicast_reply() in ip_output.c.
It is only used by TCP to send reset/ack out of a ctl_sk.
Like the new skb_set_delivery_time(), this patch sets
the skb->mono_delivery_time to 0 for now as a place
holder.  It will be enabled in a later patch.
A similar case in tcp_ipv6 can be done with
skb_set_delivery_time() in tcp_v6_send_response().

[0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/at=
tachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h                     | 13 +++++++++++++
 net/bridge/netfilter/nf_conntrack_bridge.c |  5 +++--
 net/ipv4/ip_output.c                       |  7 +++++--
 net/ipv4/tcp_output.c                      | 16 +++++++++-------
 net/ipv6/ip6_output.c                      |  5 +++--
 net/ipv6/netfilter.c                       |  5 +++--
 net/ipv6/tcp_ipv6.c                        |  2 +-
 7 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6b51e8..32c793de3801 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -747,6 +747,10 @@ typedef unsigned char *sk_buff_data_t;
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
+ *	@mono_delivery_time: When set, skb->tstamp has the
+ *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
+ *		skb->tstamp has the (rcv) timestamp at ingress and
+ *		delivery_time at egress.
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
  *	@secmark: security marking
@@ -917,6 +921,7 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
+	__u8			mono_delivery_time:1;
=20
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
@@ -3925,6 +3930,14 @@ static inline ktime_t net_timedelta(ktime_t t)
 	return ktime_sub(ktime_get_real(), t);
 }
=20
+static inline void skb_set_delivery_time(struct sk_buff *skb, ktime_t kt,
+					 bool mono)
+{
+	skb->tstamp =3D kt;
+	/* Setting mono_delivery_time will be enabled later */
+	skb->mono_delivery_time =3D 0;
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
index 0c0574eb5f5b..7af5d1849bc9 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -761,6 +761,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 {
 	struct iphdr *iph;
 	struct sk_buff *skb2;
+	bool mono_delivery_time =3D skb->mono_delivery_time;
 	struct rtable *rt =3D skb_rtable(skb);
 	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
@@ -852,7 +853,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 				}
 			}
=20
-			skb->tstamp =3D tstamp;
+			skb_set_delivery_time(skb, tstamp, mono_delivery_time);
 			err =3D output(net, sk, skb);
=20
 			if (!err)
@@ -908,7 +909,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 		/*
 		 *	Put this fragment into the sending queue.
 		 */
-		skb2->tstamp =3D tstamp;
+		skb_set_delivery_time(skb2, tstamp, mono_delivery_time);
 		err =3D output(net, sk, skb2);
 		if (err)
 			goto fail;
@@ -1727,6 +1728,8 @@ void ip_send_unicast_reply(struct sock *sk, struct sk=
_buff *skb,
 			  arg->csumoffset) =3D csum_fold(csum_add(nskb->csum,
 								arg->csum));
 		nskb->ip_summed =3D CHECKSUM_NONE;
+		/* Setting mono_delivery_time will be enabled later */
+		nskb->mono_delivery_time =3D 0;
 		ip_push_pending_frames(sk, &fl4);
 	}
 out:
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e76bf1e9251e..2319531267c6 100644
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
index 0c6c971ce0a5..55665f3f7a77 100644
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
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0c648bf07f39..d4fc6641afa4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -992,7 +992,7 @@ static void tcp_v6_send_response(const struct sock *sk,=
 struct sk_buff *skb, u32
 		} else {
 			mark =3D sk->sk_mark;
 		}
-		buff->tstamp =3D tcp_transmit_time(sk);
+		skb_set_delivery_time(buff, tcp_transmit_time(sk), true);
 	}
 	fl6.flowi6_mark =3D IP6_REPLY_MARK(net, skb->mark) ?: mark;
 	fl6.fl6_dport =3D t1->dest;
--=20
2.30.2

