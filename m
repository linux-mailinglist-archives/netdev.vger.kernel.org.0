Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3158F4762D5
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234941AbhLOUMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:12:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57098 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235026AbhLOUME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:12:04 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 1BFIA5vl030176
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:12:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=Z/qT55To4Odk9SiHTAxxrsF29Xyhy8GgoikkFgifY8E=;
 b=aNphvMTiC3zftLI5Ll0RZOC3fmTMsZ3JVKsIhDVBGexHUt2/u6EAoi6KVLMxyz/+atvw
 sDfRRor36vriIXLXBGYwyRo0XNn34AT6Q5QLru7atTuEk2OeFBUJbWe/2fqolwp4Br2C
 7bXxZntZD5Z1p7WtDcyxXdCWyZEBMN57urc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3cy9rcnxx1-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:12:03 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 12:12:01 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1FF0C3F237B6; Wed, 15 Dec 2021 12:11:58 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v2 net-next] net: Preserve skb delivery time during forward
Date:   Wed, 15 Dec 2021 12:11:58 -0800
Message-ID: <20211215201158.271976-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 8vxgNZo3Uj0riouToHhkOD-VuafPgv6n
X-Proofpoint-ORIG-GUID: 8vxgNZo3Uj0riouToHhkOD-VuafPgv6n
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_12,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1015
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112150112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb->skb_mstamp_ns is used as the EDT (Earliest Department Time)
in TCP.  skb->skb_mstamp_ns is a union member of skb->tstamp.

When the skb traveling veth and being forwarded like below, the skb->tstamp
is reset to 0 at multiple points.

                                                                        (c:=
 skb->tstamp =3D 0)
                                                                         vv
tcp-sender =3D> veth@netns =3D> veth@hostns(b: rx: skb->tstamp =3D real_clo=
ck) =3D> fq@eth0
                         ^^
                        (a: skb->tstamp =3D 0)

(a) veth@netns TX to veth@hostns:
    skb->tstamp (mono clock) is a EDT and it is in future time.
    Reset to 0 so that it won't skip the net_timestamp_check at the
    RX side in (b).
(b) RX (netif_rx) in veth@hostns:
    net_timestamp_check puts a current time (real clock) in skb->tstamp.
(c) veth@hostns forward to fq@eth0:
    skb->tstamp is reset back to 0 again because fq is using
    mono clock.

This leads to an unstable TCP throughput issue described by Daniel in [0].

We also have a use case that a bpf runs at ingress@veth@hostns
to set EDT in skb->tstamp to limit the bandwidth usage
of a particular netns.  This EDT currently also gets
reset in step (c) as described above.

Unlike RFC v1 trying to migrate rx tstamp to mono first,
this patch is to preserve the EDT in skb->skb_mstamp_ns during forward.

The idea is to temporarily store skb->skb_mstamp_ns during forward.
skb_shinfo(skb)->hwtstamps is used as a temporary store and
it is union-ed with the newly added "u64 tx_delivery_tstamp".
hwtstamps should only be used when a packet is received or
sent out of a hw device.

During forward, skb->tstamp will be temporarily stored in
skb_shinfo(skb)->tx_delivery_tstamp and a new bit
(SKBTX_DELIVERY_TSTAMP) in skb_shinfo(skb)->tx_flags
will also be set to tell tx_delivery_tstamp is in use.
hwtstamps is accessed through the skb_hwtstamps() getter,
so unlikely(tx_flags & SKBTX_DELIVERY_TSTAMP) can
be tested in there and reset tx_delivery_tstamp to 0
before hwtstamps is used.

After moving the skb->tstamp to skb_shinfo(skb)->tx_delivery_tstamp,
the skb->tstamp will still be reset to 0 during forward.  Thus,
on the RX side (__netif_receive_skb_core), all existing code paths
will still get the received time in real clock and will work as-is.

When this skb finally xmit-ing out in __dev_queue_xmit(),
it will check the SKBTX_DELIVERY_TSTAMP bit in skb_shinfo(skb)->tx_flags
and restore the skb->tstamp from skb_shinfo(skb)->tx_delivery_tstamp
if needed.  This bit test is done immediately after another existing
bit test 'skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP'.

Another bit SKBTX_DELIVERY_TSTAMP_ALLOW_FWD is added
to skb_shinfo(skb)->tx_flags.  It is used to specify
the skb->tstamp is set as a delivery time and can be
temporarily stored during forward.  This bit is now set
when EDT is stored in skb->skb_mstamp_ns in tcp_output.c
This will avoid packet received from a NIC with real-clock
in skb->tstamp being forwarded without reset.

The change in af_packet.c is to avoid it calling skb_hwtstamps()
which will reset the skb_shinfo(skb)->tx_delivery_tstamp.
af_packet.c only wants to read the hwtstamps instead of
storing a time in it, so a new read only getter skb_hwtstamps_ktime()
is added.  Otherwise, a tcpdump will trigger this code path
and unnecessarily reset the EDT stored in tx_delivery_tstamp.

[Note: not all skb->tstamp=3D0 reset has been changed in this RFC yet]

[0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/at=
tachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h  | 52 ++++++++++++++++++++++++++++++++++++++++-
 net/bridge/br_forward.c |  2 +-
 net/core/dev.c          |  1 +
 net/core/filter.c       |  6 ++---
 net/core/skbuff.c       |  2 +-
 net/ipv4/ip_forward.c   |  2 +-
 net/ipv4/tcp_output.c   | 21 +++++++++++------
 net/ipv6/ip6_output.c   |  2 +-
 net/packet/af_packet.c  |  8 +++----
 9 files changed, 77 insertions(+), 19 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6535294f6a48..9bf0a1e2a1bd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -435,9 +435,17 @@ enum {
 	/* device driver is going to provide hardware time stamp */
 	SKBTX_IN_PROGRESS =3D 1 << 2,
=20
+	/* shinfo stores a future tx_delivery_tstamp instead of hwtstamps */
+	SKBTX_DELIVERY_TSTAMP =3D 1 << 3,
+
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS =3D 1 << 4,
=20
+	/* skb->tstamp stored a future delivery time which
+	 * was set by a local sk and it can be fowarded.
+	 */
+	SKBTX_DELIVERY_TSTAMP_ALLOW_FWD =3D 1 << 5,
+
 	/* generate software time stamp when entering packet scheduling */
 	SKBTX_SCHED_TSTAMP =3D 1 << 6,
 };
@@ -530,7 +538,14 @@ struct skb_shared_info {
 	/* Warning: this field is not always filled in (UFO)! */
 	unsigned short	gso_segs;
 	struct sk_buff	*frag_list;
-	struct skb_shared_hwtstamps hwtstamps;
+	union {
+		/* If SKBTX_DELIVERY_TSTAMP is set in tx_flags,
+		 * tx_delivery_tstamp is stored instead of
+		 * hwtstamps.
+		 */
+		struct skb_shared_hwtstamps hwtstamps;
+		u64 tx_delivery_tstamp;
+	};
 	unsigned int	gso_type;
 	u32		tskey;
=20
@@ -1463,9 +1478,44 @@ static inline unsigned int skb_end_offset(const stru=
ct sk_buff *skb)
=20
 static inline struct skb_shared_hwtstamps *skb_hwtstamps(struct sk_buff *s=
kb)
 {
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
+		skb_shinfo(skb)->tx_flags &=3D ~SKBTX_DELIVERY_TSTAMP;
+		skb_shinfo(skb)->tx_delivery_tstamp =3D 0;
+	}
 	return &skb_shinfo(skb)->hwtstamps;
 }
=20
+/* Caller only needs to read the hwtstamps as ktime.
+ * To update hwtstamps,  HW device driver should call the writable
+ * version skb_hwtstamps() that returns a pointer.
+ */
+static inline ktime_t skb_hwtstamps_ktime(const struct sk_buff *skb)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP))
+		return 0;
+	return skb_shinfo(skb)->hwtstamps.hwtstamp;
+}
+
+static inline void skb_scrub_tstamp(struct sk_buff *skb)
+{
+	if (skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP_ALLOW_FWD) {
+		skb_shinfo(skb)->tx_delivery_tstamp =3D skb->tstamp;
+		skb_shinfo(skb)->tx_flags |=3D SKBTX_DELIVERY_TSTAMP;
+		skb_shinfo(skb)->tx_flags &=3D ~SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
+	}
+	skb->tstamp =3D 0;
+}
+
+static inline void skb_restore_delivery_time(struct sk_buff *skb)
+{
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_DELIVERY_TSTAMP)) {
+		skb->tstamp =3D skb_shinfo(skb)->tx_delivery_tstamp;
+		skb_shinfo(skb)->tx_delivery_tstamp =3D 0;
+		skb_shinfo(skb)->tx_flags &=3D ~SKBTX_DELIVERY_TSTAMP;
+		skb_shinfo(skb)->tx_flags |=3D SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
+	}
+}
+
 static inline struct ubuf_info *skb_zcopy(struct sk_buff *skb)
 {
 	bool is_zcopy =3D skb && skb_shinfo(skb)->flags & SKBFL_ZEROCOPY_ENABLE;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ec646656dbf1..a3ba6195f2e3 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(br_dev_queue_push_xmit);
=20
 int br_forward_finish(struct net *net, struct sock *sk, struct sk_buff *sk=
b)
 {
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
 	return NF_HOOK(NFPROTO_BRIDGE, NF_BR_POST_ROUTING,
 		       net, sk, skb, NULL, skb->dev,
 		       br_dev_queue_push_xmit);
diff --git a/net/core/dev.c b/net/core/dev.c
index a855e41bbe39..e9e7de758cba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4039,6 +4039,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, stru=
ct net_device *sb_dev)
=20
 	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
 		__skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
+	skb_restore_delivery_time(skb);
=20
 	/* Disable soft irqs for various locks below. Also
 	 * stops preemption for RCU.
diff --git a/net/core/filter.c b/net/core/filter.c
index e4cc3aff5bf7..7c3c6abc25a9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2107,7 +2107,7 @@ static inline int __bpf_tx_skb(struct net_device *dev=
, struct sk_buff *skb)
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
=20
 	dev_xmit_recursion_inc();
 	ret =3D dev_queue_xmit(skb);
@@ -2176,7 +2176,7 @@ static int bpf_out_neigh_v6(struct net *net, struct s=
k_buff *skb,
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
=20
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb =3D skb_expand_head(skb, hh_len);
@@ -2274,7 +2274,7 @@ static int bpf_out_neigh_v4(struct net *net, struct s=
k_buff *skb,
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
=20
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb =3D skb_expand_head(skb, hh_len);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a33247fdb8f5..a53ca773afb5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5324,7 +5324,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
=20
 	ipvs_reset(skb);
 	skb->mark =3D 0;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
 }
 EXPORT_SYMBOL_GPL(skb_scrub_packet);
=20
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 00ec819f949b..f216fc97c6ce 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -79,7 +79,7 @@ static int ip_forward_finish(struct net *net, struct sock=
 *sk, struct sk_buff *s
 	if (unlikely(opt->optlen))
 		ip_forward_options(skb);
=20
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
 	return dst_output(net, sk, skb);
 }
=20
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..d5524ea5fcfa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1223,6 +1223,12 @@ INDIRECT_CALLABLE_DECLARE(int ip_queue_xmit(struct s=
ock *sk, struct sk_buff *skb
 INDIRECT_CALLABLE_DECLARE(int inet6_csk_xmit(struct sock *sk, struct sk_bu=
ff *skb, struct flowi *fl));
 INDIRECT_CALLABLE_DECLARE(void tcp_v4_send_check(struct sock *sk, struct s=
k_buff *skb));
=20
+static void tcp_set_skb_edt(struct sk_buff *skb, u64 edt)
+{
+	skb->skb_mstamp_ns =3D edt;
+	skb_shinfo(skb)->tx_flags |=3D SKBTX_DELIVERY_TSTAMP_ALLOW_FWD;
+}
+
 /* This routine actually transmits TCP packets queued in by
  * tcp_do_sendmsg().  This is used by both the initial
  * transmission and possible later retransmissions.
@@ -1253,7 +1259,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct=
 sk_buff *skb,
 	tp =3D tcp_sk(sk);
 	prior_wstamp =3D tp->tcp_wstamp_ns;
 	tp->tcp_wstamp_ns =3D max(tp->tcp_wstamp_ns, tp->tcp_clock_cache);
-	skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns;
+	tcp_set_skb_edt(skb, tp->tcp_wstamp_ns);
 	if (clone_it) {
 		oskb =3D skb;
=20
@@ -1589,7 +1595,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_=
queue,
=20
 	skb_split(skb, buff, len);
=20
-	buff->tstamp =3D skb->tstamp;
+	tcp_set_skb_edt(buff, skb->skb_mstamp_ns);
 	tcp_fragment_tstamp(skb, buff);
=20
 	old_factor =3D tcp_skb_pcount(skb);
@@ -2616,7 +2622,8 @@ static bool tcp_write_xmit(struct sock *sk, unsigned =
int mss_now, int nonagle,
=20
 		if (unlikely(tp->repair) && tp->repair_queue =3D=3D TCP_SEND_QUEUE) {
 			/* "skb_mstamp_ns" is used as a start point for the retransmit timer */
-			skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
+			tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
+			tcp_set_skb_edt(skb, tp->tcp_wstamp_ns);
 			list_move_tail(&skb->tcp_tsorted_anchor, &tp->tsorted_sent_queue);
 			tcp_init_tso_segs(skb, mss_now);
 			goto repair; /* Skip network transmission */
@@ -3541,11 +3548,11 @@ struct sk_buff *tcp_make_synack(const struct sock *=
sk, struct dst_entry *dst,
 	now =3D tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(synack_type =3D=3D TCP_SYNACK_COOKIE && ireq->tstamp_ok))
-		skb->skb_mstamp_ns =3D cookie_init_timestamp(req, now);
+		tcp_set_skb_edt(skb, cookie_init_timestamp(req, now));
 	else
 #endif
 	{
-		skb->skb_mstamp_ns =3D now;
+		tcp_set_skb_edt(skb, now);
 		if (!tcp_rsk(req)->snt_synack) /* Timestamp first SYNACK */
 			tcp_rsk(req)->snt_synack =3D tcp_skb_timestamp_us(skb);
 	}
@@ -3594,7 +3601,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk=
, struct dst_entry *dst,
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
=20
-	skb->skb_mstamp_ns =3D now;
+	tcp_set_skb_edt(skb, now);
 	tcp_add_tx_delay(skb, tp);
=20
 	return skb;
@@ -3771,7 +3778,7 @@ static int tcp_send_syn_data(struct sock *sk, struct =
sk_buff *syn)
=20
 	err =3D tcp_transmit_skb(sk, syn_data, 1, sk->sk_allocation);
=20
-	syn->skb_mstamp_ns =3D syn_data->skb_mstamp_ns;
+	tcp_set_skb_edt(syn, syn_data->skb_mstamp_ns);
=20
 	/* Now full SYN+DATA was cloned and sent (or not),
 	 * remove the SYN from the original skb (syn_data)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 2995f8d89e7e..f5436afdafc7 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -440,7 +440,7 @@ static inline int ip6_forward_finish(struct net *net, s=
truct sock *sk,
 	}
 #endif
=20
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
 	return dst_output(net, sk, skb);
 }
=20
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index a1ffdb48cc47..79a57836853a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -451,12 +451,12 @@ static int __packet_get_status(const struct packet_so=
ck *po, void *frame)
 static __u32 tpacket_get_timestamp(struct sk_buff *skb, struct timespec64 =
*ts,
 				   unsigned int flags)
 {
-	struct skb_shared_hwtstamps *shhwtstamps =3D skb_hwtstamps(skb);
+	ktime_t hwtstamp =3D skb_hwtstamps_ktime(skb);
=20
-	if (shhwtstamps &&
-	    (flags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
-	    ktime_to_timespec64_cond(shhwtstamps->hwtstamp, ts))
+	if (hwtstamp && (flags & SOF_TIMESTAMPING_RAW_HARDWARE)) {
+		*ts =3D ktime_to_timespec64(hwtstamp);
 		return TP_STATUS_TS_RAW_HARDWARE;
+	}
=20
 	if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
 	    ktime_to_timespec64_cond(skb->tstamp, ts))
--=20
2.30.2

