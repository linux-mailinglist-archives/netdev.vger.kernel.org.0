Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D1446B063
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhLGCEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:04:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhLGCEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:04:40 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B71mJou012435
        for <netdev@vger.kernel.org>; Mon, 6 Dec 2021 18:01:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=1lYfETVjBf+2WPdaUjlrwXWukejz4oKezUlnkmf/kj0=;
 b=eg43ulETnGv0CKaZAtqBWparvtVUaAtGa0UBzpukAgIevNffKboinKHpbfwrqlimW5Tt
 +gTMMxW8S01dMBmL4TphuR2izrWbleN97EEi6+gzyGK+8ryVIeQsm5hROVwbqj6PnfgP
 74nrZw0W5wzJRiSMHdXRs2Ffqe3hZPl5uQY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3csx8yr1su-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 18:01:11 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 18:01:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 2DB1737EEE1C; Mon,  6 Dec 2021 18:01:02 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH net-next 1/2] net: Use mono clock in RX timestamp
Date:   Mon, 6 Dec 2021 18:01:02 -0800
Message-ID: <20211207020102.3690724-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: WM7vrhIYPgSug6fe-n8R_RsCzFFMdPiC
X-Proofpoint-ORIG-GUID: WM7vrhIYPgSug6fe-n8R_RsCzFFMdPiC
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 impostorscore=0
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112070012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TX skb->skb_mstamp_ns is used as the EDT (Earliest Department Time)
in TCP.  skb->skb_mstamp_ns is an union member of skb->tstamp.
Mono clock is used in EDT.  The EDT will be lost when the
packet is forwarded.  For example, the tcp sender is in its own
netns and its packet will eventually be sent out from the host
eth0 like this:

                                                                      (skb-=
>tstamp =3D 0)
                                                                      vv
tcp-sender =3D> veth@netns =3D> veth@hostns(rx: skb->tstamp =3D real_clock)=
 =3D> fq@eth0
                         ^^
                         (skb->tstamp =3D 0)

veth@netns forward to veth@hostns:
  (a) skb->tstamp is reset to 0
RX in veth@hostns:
  (b) skb->tstamp is stamped with real clock if skb->tstamp is 0.
      Thus, the earlier skb->tstamp reset to 0 is needed in (a).
veth@hostns forward to fq@eth0:
  (c) skb->tstamp is reset back to 0 again because fq is using
      mono clock.

Resetting the skb->skb_mstamp_ns marked by the tcp-sender@netns
leads to unstable TCP throughput issue described by Daniel in [0].

We also have a use case that a bpf runs at ingress@veth@hostns
to set EDT in skb->tstamp to limit the bandwidth usage
of a particular netns.  This EDT (set by the bpf@ingress@veth@hostns)
currently also gets reset in step (c) as described above.

This patch tries to use mono clock instead of real clock in the
RX timestamp.  Before exposing the RX timestamp to the
userspace, skb_get_ktime() is used to convert the mono
clock to real clock.

When forwarding a packet, instead of always resetting skb->tstamp,
this patch only resets when the skb->tstamp is marked by
userspace (by testing sock_flag(skb->sk, SOCK_TXTIME)).
It is done in a new helper skb_scrub_tstamp().

Not all RX real clock usages in skb->tstamp have been audited
and changed, so under RFC.  The RX timestamp has been in real
clock for a long time and it is likely I missed some of
the reasons, so it will be useful to get feedback
before converting the remaining RX usages.

[0] (slide 22): https://linuxplumbersconf.org/event/11/contributions/953/at=
tachments/867/1658/LPC_2021_BPF_Datapath_Extensions.pdf

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h      | 23 +++++++++++------------
 include/linux/timekeeping.h |  5 +++++
 include/net/pkt_sched.h     |  2 +-
 include/net/sock.h          |  4 ++--
 include/net/tcp.h           |  8 ++++----
 net/bridge/br_forward.c     |  2 +-
 net/core/filter.c           |  6 +++---
 net/core/skbuff.c           | 12 ++++++++++--
 net/ipv4/ip_forward.c       |  2 +-
 net/ipv4/tcp.c              |  6 +++---
 net/ipv4/tcp_output.c       | 16 ++++++++--------
 net/ipv6/ip6_output.c       |  2 +-
 net/socket.c                |  2 +-
 net/sunrpc/svcsock.c        |  9 +++------
 14 files changed, 54 insertions(+), 45 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dd262bd8ddbe..b609bdc5398b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -753,10 +753,8 @@ struct sk_buff {
 		int			ip_defrag_offset;
 	};
=20
-	union {
-		ktime_t		tstamp;
-		u64		skb_mstamp_ns; /* earliest departure time */
-	};
+	ktime_t		tstamp;
+
 	/*
 	 * This is the control buffer. It is free to use for every
 	 * layer. Please put your private variables there. If you
@@ -3694,6 +3692,7 @@ int skb_zerocopy(struct sk_buff *to, struct sk_buff *=
from,
 		 int len, int hlen);
 void skb_split(struct sk_buff *skb, struct sk_buff *skb1, const u32 len);
 int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen);
+void skb_scrub_tstamp(struct sk_buff *skb);
 void skb_scrub_packet(struct sk_buff *skb, bool xnet);
 bool skb_gso_validate_network_len(const struct sk_buff *skb, unsigned int =
mtu);
 bool skb_gso_validate_mac_len(const struct sk_buff *skb, unsigned int len);
@@ -3810,7 +3809,7 @@ void skb_init(void);
=20
 static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
 {
-	return skb->tstamp;
+	return ktime_mono_to_real_cond(skb->tstamp);
 }
=20
 /**
@@ -3825,13 +3824,13 @@ static inline ktime_t skb_get_ktime(const struct sk=
_buff *skb)
 static inline void skb_get_timestamp(const struct sk_buff *skb,
 				     struct __kernel_old_timeval *stamp)
 {
-	*stamp =3D ns_to_kernel_old_timeval(skb->tstamp);
+	*stamp =3D ns_to_kernel_old_timeval(skb_get_ktime(skb));
 }
=20
 static inline void skb_get_new_timestamp(const struct sk_buff *skb,
 					 struct __kernel_sock_timeval *stamp)
 {
-	struct timespec64 ts =3D ktime_to_timespec64(skb->tstamp);
+	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
=20
 	stamp->tv_sec =3D ts.tv_sec;
 	stamp->tv_usec =3D ts.tv_nsec / 1000;
@@ -3840,7 +3839,7 @@ static inline void skb_get_new_timestamp(const struct=
 sk_buff *skb,
 static inline void skb_get_timestampns(const struct sk_buff *skb,
 				       struct __kernel_old_timespec *stamp)
 {
-	struct timespec64 ts =3D ktime_to_timespec64(skb->tstamp);
+	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
=20
 	stamp->tv_sec =3D ts.tv_sec;
 	stamp->tv_nsec =3D ts.tv_nsec;
@@ -3849,7 +3848,7 @@ static inline void skb_get_timestampns(const struct s=
k_buff *skb,
 static inline void skb_get_new_timestampns(const struct sk_buff *skb,
 					   struct __kernel_timespec *stamp)
 {
-	struct timespec64 ts =3D ktime_to_timespec64(skb->tstamp);
+	struct timespec64 ts =3D ktime_to_timespec64(skb_get_ktime(skb));
=20
 	stamp->tv_sec =3D ts.tv_sec;
 	stamp->tv_nsec =3D ts.tv_nsec;
@@ -3857,12 +3856,12 @@ static inline void skb_get_new_timestampns(const st=
ruct sk_buff *skb,
=20
 static inline void __net_timestamp(struct sk_buff *skb)
 {
-	skb->tstamp =3D ktime_get_real();
+	skb->tstamp =3D ktime_get_ns();
 }
=20
 static inline ktime_t net_timedelta(ktime_t t)
 {
-	return ktime_sub(ktime_get_real(), t);
+	return ktime_sub(ktime_get_ns(), t);
 }
=20
 static inline ktime_t net_invalid_timestamp(void)
@@ -4726,7 +4725,7 @@ static inline void skb_set_redirected(struct sk_buff =
*skb, bool from_ingress)
 #ifdef CONFIG_NET_REDIRECT
 	skb->from_ingress =3D from_ingress;
 	if (skb->from_ingress)
-		skb->tstamp =3D 0;
+		skb_scrub_tstamp(skb);
 #endif
 }
=20
diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 78a98bdff76d..575938469b10 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -149,6 +149,11 @@ static inline ktime_t ktime_mono_to_real(ktime_t mono)
 	return ktime_mono_to_any(mono, TK_OFFS_REAL);
 }
=20
+static inline ktime_t ktime_mono_to_real_cond(ktime_t mono)
+{
+	return mono ? ktime_mono_to_any(mono, TK_OFFS_REAL) : 0;
+}
+
 static inline u64 ktime_get_ns(void)
 {
 	return ktime_to_ns(ktime_get());
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index bf79f3a890af..fbe885150f00 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -184,7 +184,7 @@ struct tc_taprio_qopt_offload *taprio_offload_get(struc=
t tc_taprio_qopt_offload
 						  *offload);
 void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
=20
-/* Ensure skb_mstamp_ns, which might have been populated with the txtime, =
is
+/* Ensure tstamp, which might have been populated with the txtime, is
  * not mistaken for a software timestamp, because this will otherwise prev=
ent
  * the dispatch of hardware timestamps to the socket.
  */
diff --git a/include/net/sock.h b/include/net/sock.h
index ae61cd0b650d..96f70087ae7a 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2603,7 +2603,7 @@ void __sock_recv_wifi_status(struct msghdr *msg, stru=
ct sock *sk,
 static inline void
 sock_recv_timestamp(struct msghdr *msg, struct sock *sk, struct sk_buff *s=
kb)
 {
-	ktime_t kt =3D skb->tstamp;
+	ktime_t kt =3D skb_get_ktime(skb);
 	struct skb_shared_hwtstamps *hwtstamps =3D skb_hwtstamps(skb);
=20
 	/*
@@ -2640,7 +2640,7 @@ static inline void sock_recv_ts_and_drops(struct msgh=
dr *msg, struct sock *sk,
 	if (sk->sk_flags & FLAGS_TS_OR_DROPS || sk->sk_tsflags & TSFLAGS_ANY)
 		__sock_recv_ts_and_drops(msg, sk, skb);
 	else if (unlikely(sock_flag(sk, SOCK_TIMESTAMP)))
-		sock_write_timestamp(sk, skb->tstamp);
+		sock_write_timestamp(sk, skb_get_ktime(skb));
 	else if (unlikely(sk->sk_stamp =3D=3D SK_DEFAULT_STAMP))
 		sock_write_timestamp(sk, 0);
 }
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 44e442bf23f9..5f5c5910a985 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -810,13 +810,13 @@ static inline u32 tcp_stamp_us_delta(u64 t1, u64 t0)
=20
 static inline u32 tcp_skb_timestamp(const struct sk_buff *skb)
 {
-	return tcp_ns_to_ts(skb->skb_mstamp_ns);
+	return tcp_ns_to_ts(skb->tstamp);
 }
=20
 /* provide the departure time in us unit */
 static inline u64 tcp_skb_timestamp_us(const struct sk_buff *skb)
 {
-	return div_u64(skb->skb_mstamp_ns, NSEC_PER_USEC);
+	return div_u64(skb->tstamp, NSEC_PER_USEC);
 }
=20
=20
@@ -862,7 +862,7 @@ struct tcp_skb_cb {
 #define TCPCB_SACKED_RETRANS	0x02	/* SKB retransmitted		*/
 #define TCPCB_LOST		0x04	/* SKB is lost			*/
 #define TCPCB_TAGBITS		0x07	/* All tag bits			*/
-#define TCPCB_REPAIRED		0x10	/* SKB repaired (no skb_mstamp_ns)	*/
+#define TCPCB_REPAIRED		0x10	/* SKB repaired (no tstamp)	*/
 #define TCPCB_EVER_RETRANS	0x80	/* Ever retransmitted frame	*/
 #define TCPCB_RETRANS		(TCPCB_SACKED_RETRANS|TCPCB_EVER_RETRANS| \
 				TCPCB_REPAIRED)
@@ -2395,7 +2395,7 @@ static inline void tcp_add_tx_delay(struct sk_buff *s=
kb,
 				    const struct tcp_sock *tp)
 {
 	if (static_branch_unlikely(&tcp_tx_delay_enabled))
-		skb->skb_mstamp_ns +=3D (u64)tp->tcp_tx_delay * NSEC_PER_USEC;
+		skb->tstamp +=3D (u64)tp->tcp_tx_delay * NSEC_PER_USEC;
 }
=20
 /* Compute Earliest Departure Time for some control packets
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 8271624a19aa..17bf90f49c64 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2108,7 +2108,7 @@ static inline int __bpf_tx_skb(struct net_device *dev=
, struct sk_buff *skb)
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
=20
 	dev_xmit_recursion_inc();
 	ret =3D dev_queue_xmit(skb);
@@ -2177,7 +2177,7 @@ static int bpf_out_neigh_v6(struct net *net, struct s=
k_buff *skb,
 	}
=20
 	skb->dev =3D dev;
-	skb->tstamp =3D 0;
+	skb_scrub_tstamp(skb);
=20
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb =3D skb_expand_head(skb, hh_len);
@@ -2275,7 +2275,7 @@ static int bpf_out_neigh_v4(struct net *net, struct s=
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
index a33247fdb8f5..f091c7807a9e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4794,7 +4794,7 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 	if (hwtstamps)
 		*skb_hwtstamps(skb) =3D *hwtstamps;
 	else
-		skb->tstamp =3D ktime_get_real();
+		__net_timestamp(skb);
=20
 	__skb_complete_tx_timestamp(skb, sk, tstype, opt_stats);
 }
@@ -5291,6 +5291,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_=
buff *from,
 }
 EXPORT_SYMBOL(skb_try_coalesce);
=20
+void skb_scrub_tstamp(struct sk_buff *skb)
+{
+	struct sock *sk =3D skb->sk;
+
+	if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
+		skb->tstamp =3D 0;
+}
+
 /**
  * skb_scrub_packet - scrub an skb
  *
@@ -5324,7 +5332,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
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
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6ab82e1a1d41..6b5feadc766e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1289,7 +1289,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr=
 *msg, size_t size)
 			copy =3D size_goal;
=20
 			/* All packets are restored as if they have
-			 * already been sent. skb_mstamp_ns isn't set to
+			 * already been sent. skb->tstamp isn't set to
 			 * avoid wrong rtt estimation.
 			 */
 			if (tp->repair)
@@ -1754,7 +1754,7 @@ void tcp_update_recv_tstamps(struct sk_buff *skb,
 			     struct scm_timestamping_internal *tss)
 {
 	if (skb->tstamp)
-		tss->ts[0] =3D ktime_to_timespec64(skb->tstamp);
+		tss->ts[0] =3D ktime_to_timespec64(skb_get_ktime(skb));
 	else
 		tss->ts[0] =3D (struct timespec64) {0};
=20
@@ -3928,7 +3928,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const =
struct sock *sk,
 	nla_put_u16(stats, TCP_NLA_TIMEOUT_REHASH, tp->timeout_rehash);
 	nla_put_u32(stats, TCP_NLA_BYTES_NOTSENT,
 		    max_t(int, 0, tp->write_seq - tp->snd_nxt));
-	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->skb_mstamp_ns,
+	nla_put_u64_64bit(stats, TCP_NLA_EDT, orig_skb->tstamp,
 			  TCP_NLA_PAD);
 	if (ack_skb)
 		nla_put_u8(stats, TCP_NLA_TTL,
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 5079832af5c1..5da076f4cf84 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1253,7 +1253,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct=
 sk_buff *skb,
 	tp =3D tcp_sk(sk);
 	prior_wstamp =3D tp->tcp_wstamp_ns;
 	tp->tcp_wstamp_ns =3D max(tp->tcp_wstamp_ns, tp->tcp_clock_cache);
-	skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns;
+	skb->tstamp =3D tp->tcp_wstamp_ns;
 	if (clone_it) {
 		oskb =3D skb;
=20
@@ -1391,7 +1391,7 @@ static int __tcp_transmit_skb(struct sock *sk, struct=
 sk_buff *skb,
 	skb_shinfo(skb)->gso_segs =3D tcp_skb_pcount(skb);
 	skb_shinfo(skb)->gso_size =3D tcp_skb_mss(skb);
=20
-	/* Leave earliest departure time in skb->tstamp (skb->skb_mstamp_ns) */
+	/* Leave earliest departure time in skb->tstamp */
=20
 	/* Cleanup our debris for IP stacks */
 	memset(skb->cb, 0, max(sizeof(struct inet_skb_parm),
@@ -2615,8 +2615,8 @@ static bool tcp_write_xmit(struct sock *sk, unsigned =
int mss_now, int nonagle,
 		unsigned int limit;
=20
 		if (unlikely(tp->repair) && tp->repair_queue =3D=3D TCP_SEND_QUEUE) {
-			/* "skb_mstamp_ns" is used as a start point for the retransmit timer */
-			skb->skb_mstamp_ns =3D tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
+			/* "skb->tstamp" is used as a start point for the retransmit timer */
+			skb->tstamp =3D tp->tcp_wstamp_ns =3D tp->tcp_clock_cache;
 			list_move_tail(&skb->tcp_tsorted_anchor, &tp->tsorted_sent_queue);
 			tcp_init_tso_segs(skb, mss_now);
 			goto repair; /* Skip network transmission */
@@ -3541,11 +3541,11 @@ struct sk_buff *tcp_make_synack(const struct sock *=
sk, struct dst_entry *dst,
 	now =3D tcp_clock_ns();
 #ifdef CONFIG_SYN_COOKIES
 	if (unlikely(synack_type =3D=3D TCP_SYNACK_COOKIE && ireq->tstamp_ok))
-		skb->skb_mstamp_ns =3D cookie_init_timestamp(req, now);
+		skb->tstamp =3D cookie_init_timestamp(req, now);
 	else
 #endif
 	{
-		skb->skb_mstamp_ns =3D now;
+		skb->tstamp =3D now;
 		if (!tcp_rsk(req)->snt_synack) /* Timestamp first SYNACK */
 			tcp_rsk(req)->snt_synack =3D tcp_skb_timestamp_us(skb);
 	}
@@ -3594,7 +3594,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk=
, struct dst_entry *dst,
 	bpf_skops_write_hdr_opt((struct sock *)sk, skb, req, syn_skb,
 				synack_type, &opts);
=20
-	skb->skb_mstamp_ns =3D now;
+	skb->tstamp =3D now;
 	tcp_add_tx_delay(skb, tp);
=20
 	return skb;
@@ -3771,7 +3771,7 @@ static int tcp_send_syn_data(struct sock *sk, struct =
sk_buff *syn)
=20
 	err =3D tcp_transmit_skb(sk, syn_data, 1, sk->sk_allocation);
=20
-	syn->skb_mstamp_ns =3D syn_data->skb_mstamp_ns;
+	syn->tstamp =3D syn_data->tstamp;
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
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..6f3f54746737 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -871,7 +871,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct s=
ock *sk,
=20
 	memset(&tss, 0, sizeof(tss));
 	if ((sk->sk_tsflags & SOF_TIMESTAMPING_SOFTWARE) &&
-	    ktime_to_timespec64_cond(skb->tstamp, tss.ts + 0))
+	    ktime_to_timespec64_cond(skb_get_ktime(skb), tss.ts + 0))
 		empty =3D 0;
 	if (shhwtstamps &&
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 478f857cdaed..32f6935d3f5f 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -470,12 +470,9 @@ static int svc_udp_recvfrom(struct svc_rqst *rqstp)
=20
 	len =3D svc_addr_len(svc_addr(rqstp));
 	rqstp->rq_addrlen =3D len;
-	if (skb->tstamp =3D=3D 0) {
-		skb->tstamp =3D ktime_get_real();
-		/* Don't enable netstamp, sunrpc doesn't
-		   need that much accuracy */
-	}
-	sock_write_timestamp(svsk->sk_sk, skb->tstamp);
+	if (skb->tstamp =3D=3D 0)
+		__net_timestamp(skb);
+	sock_write_timestamp(svsk->sk_sk, skb_get_ktime(skb));
 	set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags); /* there may be more data...=
 */
=20
 	len =3D skb->len;
--=20
2.30.2

