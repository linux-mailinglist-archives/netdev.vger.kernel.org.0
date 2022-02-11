Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6A4B1F15
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347591AbiBKHNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiBKHNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:05 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515B51156
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:03 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrJOQ013600
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=wf2YkDyqpkLJmezwybTz4VHJZySTcf25JSmYTP2ZY0U=;
 b=gk3s4M76SUl7WJY3GugdbfQOL2vGlyY+GykJsDpOIO2Bx+h+2Fr8oOBMSHl5oUtmHR8j
 swsqcuPZEPdVHbJCSZnVBBRJ4STWiWecl9M0Cea3UMO7LcHNsJvtYWeLK5HwWA5tMPSR
 hnjCEX8dKlkphsE7YMrGb9q6zQEZcHKKup4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e58e1kxhw-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:02 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:01 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 32B266C757E3; Thu, 10 Feb 2022 23:12:51 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 3/8] net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()
Date:   Thu, 10 Feb 2022 23:12:51 -0800
Message-ID: <20220211071251.887078-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zNx-Alf1VoBtrTVSmfFi4YYAUf7bf4nY
X-Proofpoint-ORIG-GUID: zNx-Alf1VoBtrTVSmfFi4YYAUf7bf4nY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110039
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

This patch sets the skb->mono_delivery_time to flag the skb->tstamp
is used as the mono delivery_time (EDT) instead of the (rcv) timestamp.

skb_clear_delivery_time() is added to clear the delivery_time and set
back to the (rcv) timestamp after sch_handle_ingress() such that
the tc-bpf prog can use bpf_redirect_*() to forward it to the egress
of another iface and keep the EDT delivery_time.

The next patch will postpone the skb_clear_delivery_time() until the
stack learns that the skb is being delivered locally and that will
make other kernel forwarding paths (ip[6]_forward) able to keep
the delivery_time also.  Thus, like the previous patches on using
the skb->mono_delivery_time bit, calling skb_clear_delivery_time()
is not done within the CONFIG_NET_INGRESS to avoid too many code
churns among this set.

Before sch_handle_ingress(), another case needs to clear the delivery_tim=
e
is the network tapping (e.g. af_packet by tcpdump).  Regardless of tappin=
g
at the ingress or egress,  the tapped skb is received by the af_packet
socket, so it is ingress to the af_packet socket and it expects
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
 net/core/dev.c         |  5 ++++-
 net/core/skbuff.c      |  6 ++++--
 net/ipv4/ip_output.c   |  3 +--
 net/packet/af_packet.c |  4 +++-
 5 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 07e618f8b41a..0e09e75fa787 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3934,8 +3934,23 @@ static inline void skb_set_delivery_time(struct sk=
_buff *skb, ktime_t kt,
 					 bool mono)
 {
 	skb->tstamp =3D kt;
-	/* Setting mono_delivery_time will be enabled later */
-	skb->mono_delivery_time =3D 0;
+	skb->mono_delivery_time =3D kt && mono;
+}
+
+DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
+
+/* It is used in the ingress path to clear the delivery_time.
+ * If needed, set the skb->tstamp to the (rcv) timestamp.
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
@@ -3946,6 +3961,14 @@ static inline void skb_clear_tstamp(struct sk_buff=
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
index f5ef51601081..f41707ab2fb9 100644
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
@@ -5220,6 +5222,7 @@ static int __netif_receive_skb_core(struct sk_buff =
**pskb, bool pfmemalloc,
 			goto out;
 	}
 #endif
+	skb_clear_delivery_time(skb);
 	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
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
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 7af5d1849bc9..bfe08feb5d82 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1728,8 +1728,7 @@ void ip_send_unicast_reply(struct sock *sk, struct =
sk_buff *skb,
 			  arg->csumoffset) =3D csum_fold(csum_add(nskb->csum,
 								arg->csum));
 		nskb->ip_summed =3D CHECKSUM_NONE;
-		/* Setting mono_delivery_time will be enabled later */
-		nskb->mono_delivery_time =3D 0;
+		nskb->mono_delivery_time =3D !!transmit_time;
 		ip_push_pending_frames(sk, &fl4);
 	}
 out:
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ab87f22cc7ec..1b93ce1a5600 100644
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
@@ -2199,6 +2199,7 @@ static int packet_rcv(struct sk_buff *skb, struct n=
et_device *dev,
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.stats1.tp_packets++;
 	sock_skb_set_dropcount(sk, skb);
+	skb_clear_delivery_time(skb);
 	__skb_queue_tail(&sk->sk_receive_queue, skb);
 	spin_unlock(&sk->sk_receive_queue.lock);
 	sk->sk_data_ready(sk);
@@ -2377,6 +2378,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct =
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

