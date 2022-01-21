Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770D4495AB3
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378984AbiAUHay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:30:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11822 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378996AbiAUHax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:30:53 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L06frF010885
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ZjLc9/FhMWqSpoW30pSI3qdHvYoyCOCVI3xsBFk/tvU=;
 b=JRMX6SzZ/CxLdz7hFQuYaj8PGoFHbQf7YI/uG1xpk0OeT9DswddncYdBw7umBaP1q7GY
 Lgi4F1/wG+lf69UVHFzrRf1sIfyeynFsMXwGwPiE46oeNaGAzUw1tlv+mW30f8WRHUWy
 arIhKEF4O0A9moZOOBSamfR3UTCB8v6a2HA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0ghncy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 23:30:53 -0800
Received: from twshared3205.02.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 20 Jan 2022 23:30:52 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1F3615BDEC49; Thu, 20 Jan 2022 23:30:45 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH v3 net-next 3/4] net: Set skb->mono_delivery_time and clear it when delivering locally
Date:   Thu, 20 Jan 2022 23:30:45 -0800
Message-ID: <20220121073045.4179438-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220121073026.4173996-1-kafai@fb.com>
References: <20220121073026.4173996-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lS2YRcsb6841knl9KA-6XQXUibBOOC5x
X-Proofpoint-GUID: lS2YRcsb6841knl9KA-6XQXUibBOOC5x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210047
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets the skb->mono_delivery_time to flag the skb->tstamp
is used as the mono delivery_time (EDT) instead of the (rcv) timestamp.

skb_clear_delivery_time() is added to clear the delivery_time and set
back to the (rcv) timestamp if needed when the skb is being delivered
locally (to a sk).  skb_clear_delivery_time() is called in
ip_local_deliver() and ip6_input().  In most of the regular ingress
cases, the skb->tstamp should already have the (rcv) timestamp.
For the egress loop back to ingress cases, the marking of the (rcv)
timestamp is postponed from dev.c to ip_local_deliver() and
ip6_input().

Another case needs to clear the delivery_time is the network
tapping (e.g. af_packet by tcpdump).  Regardless of tapping at the ingres=
s
or egress,  the tapped skb is received by the af_packet socket, so
it is ingress to the af_packet socket and it expects
the (rcv) timestamp.

When tapping at egress, dev_queue_xmit_nit() is used.  It has already
expected skb->tstamp may have delivery_time,  so it does
skb_clone()+net_timestamp_set() to ensure the cloned skb has
the (rcv) timestamp before passing to the af_packet sk.
This patch only adds to clear the skb->mono_delivery_time
bit in net_timestamp_set().

When tapping at ingress, it currently expects the skb->tstamp is either 0
or has the (rcv) timestamp.  Meaning, the tapping at ingress path
has already expected the skb->tstamp could be 0 and it will get
the (rcv) timestamp by ktime_get_real() when needed.

There are two cases for tapping at ingress:

One case is af_packet queues the skb to its sk_receive_queue.  The skb
is either not shared or new clone created.  The skb_clear_delivery_time()
is called to clear the delivery_time (if any) before it is queued to the
sk_receive_queue.

Another case, the ingress skb is directly copied to the rx_ring
and tpacket_get_timestamp() is used to get the (rcv) timestamp.
skb_tstamp() is used in tpacket_get_timestamp() to check
the skb->mono_delivery_time bit before returning skb->tstamp.
As mentioned earlier, the tapping@ingress has already expected
the skb may not have the (rcv) timestamp (because no sk has asked
for it) and has handled this case by directly calling ktime_get_real().

In __skb_tstamp_tx, it clones the egress skb and queues the clone to the
sk_error_queue.  The outgoing skb may have the mono delivery_time while
the (rcv) timestamp is expected for the clone, so the
skb->mono_delivery_time bit is also cleared from the clone.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 27 +++++++++++++++++++++++++--
 net/core/dev.c         |  4 +++-
 net/core/skbuff.c      |  6 ++++--
 net/ipv4/ip_input.c    |  1 +
 net/ipv6/ip6_input.c   |  1 +
 net/packet/af_packet.c |  4 +++-
 6 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8de555513b94..4677bb6c7279 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3912,8 +3912,23 @@ static inline void skb_set_delivery_time(struct sk=
_buff *skb, ktime_t kt,
 					 bool mono)
 {
 	skb->tstamp =3D kt;
-	/* Setting mono_delivery_time will be enabled later */
-	/* skb->mono_delivery_time =3D kt && mono; */
+	skb->mono_delivery_time =3D kt && mono;
+}
+
+DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
+
+/* skb is delivering locally.  If needed, set it to the (rcv) timestamp.
+ * Otherwise, clear the delivery time.
+ */
+static inline void skb_clear_delivery_time(struct sk_buff *skb)
+{
+	if (unlikely(skb->mono_delivery_time)) {
+		skb->mono_delivery_time =3D 0;
+		if (static_branch_unlikely(&netstamp_needed_key))
+			skb->tstamp =3D ktime_get_real();
+		else
+			skb->tstamp =3D 0;
+	}
 }
=20
 static inline void skb_clear_tstamp(struct sk_buff *skb)
@@ -3924,6 +3939,14 @@ static inline void skb_clear_tstamp(struct sk_buff=
 *skb)
 	skb->tstamp =3D 0;
 }
=20
+static inline ktime_t skb_tstamp(const struct sk_buff *skb)
+{
+	if (unlikely(skb->mono_delivery_time))
+		return 0;
+
+	return skb->tstamp;
+}
+
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
diff --git a/net/core/dev.c b/net/core/dev.c
index 84a0d9542fe9..b4b392f5ef9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2000,7 +2000,8 @@ void net_dec_egress_queue(void)
 EXPORT_SYMBOL_GPL(net_dec_egress_queue);
 #endif
=20
-static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
+DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
+EXPORT_SYMBOL(netstamp_needed_key);
 #ifdef CONFIG_JUMP_LABEL
 static atomic_t netstamp_needed_deferred;
 static atomic_t netstamp_wanted;
@@ -2061,6 +2062,7 @@ EXPORT_SYMBOL(net_disable_timestamp);
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp =3D 0;
+	skb->mono_delivery_time =3D 0;
 	if (static_branch_unlikely(&netstamp_needed_key))
 		__net_timestamp(skb);
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 3e3da8fdf8f5..93dc763da8cb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4817,10 +4817,12 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
 		skb_shinfo(skb)->tskey =3D skb_shinfo(orig_skb)->tskey;
 	}
=20
-	if (hwtstamps)
+	if (hwtstamps) {
 		*skb_hwtstamps(skb) =3D *hwtstamps;
-	else
+	} else {
 		skb->tstamp =3D ktime_get_real();
+		skb->mono_delivery_time =3D 0;
+	}
=20
 	__skb_complete_tx_timestamp(skb, sk, tstype, opt_stats);
 }
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..35311ca75496 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -244,6 +244,7 @@ int ip_local_deliver(struct sk_buff *skb)
 	 */
 	struct net *net =3D dev_net(skb->dev);
=20
+	skb_clear_delivery_time(skb);
 	if (ip_is_fragment(ip_hdr(skb))) {
 		if (ip_defrag(net, skb, IP_DEFRAG_LOCAL_DELIVER))
 			return 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..84f93864b774 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -469,6 +469,7 @@ static int ip6_input_finish(struct net *net, struct s=
ock *sk, struct sk_buff *sk
=20
 int ip6_input(struct sk_buff *skb)
 {
+	skb_clear_delivery_time(skb);
 	return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
 		       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
 		       ip6_input_finish);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5bd409ab4cc2..ab55adff3500 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -460,7 +460,7 @@ static __u32 tpacket_get_timestamp(struct sk_buff *sk=
b, struct timespec64 *ts,
 		return TP_STATUS_TS_RAW_HARDWARE;
=20
 	if ((flags & SOF_TIMESTAMPING_SOFTWARE) &&
-	    ktime_to_timespec64_cond(skb->tstamp, ts))
+	    ktime_to_timespec64_cond(skb_tstamp(skb), ts))
 		return TP_STATUS_TS_SOFTWARE;
=20
 	return 0;
@@ -2195,6 +2195,7 @@ static int packet_rcv(struct sk_buff *skb, struct n=
et_device *dev,
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.stats1.tp_packets++;
 	sock_skb_set_dropcount(sk, skb);
+	skb_clear_delivery_time(skb);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	spin_unlock(&sk->sk_receive_queue.lock);
 	sk->sk_data_ready(sk);
@@ -2373,6 +2374,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct =
net_device *dev,
 	po->stats.stats1.tp_packets++;
 	if (copy_skb) {
 		status |=3D TP_STATUS_COPY;
+		skb_clear_delivery_time(copy_skb);
 		__skb_queue_tail(&sk->sk_receive_queue, copy_skb);
 	}
 	spin_unlock(&sk->sk_receive_queue.lock);
--=20
2.30.2

