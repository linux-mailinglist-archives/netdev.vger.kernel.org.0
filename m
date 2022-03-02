Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E914CAF23
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbiCBT4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:56:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242488AbiCBT4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:56:33 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91ABAD95ED
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:55:49 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMhA0012035
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 11:55:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WRkKvD9Ln1BF31cy79ItEby3Tja1SmNRAJaXQh89H7E=;
 b=juK52Pb/G4C8+8pUTVsaGSjz9BdnTQZOfKJjCBHheBDho5ZO6aC4OFXxv+1Xrc8DzP0v
 feFc4/YcgwUx9W7Uruf3nJG95Dh6NkKmoPAyz5SatOt5UAXuTugV6hHWqSfceFoSnp0S
 XRHjLujcXb8ems5WRGKfUJibcAwHgzOXc2U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ehyr6r9g4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:55:49 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:55:46 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 204E67BD3595; Wed,  2 Mar 2022 11:55:38 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v6 net-next 03/13] net: Handle delivery_time in skb->tstamp during network tapping with af_packet
Date:   Wed, 2 Mar 2022 11:55:38 -0800
Message-ID: <20220302195538.3480753-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
References: <20220302195519.3479274-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: yMSgFZF7lrJX2LpyGaIzm5UfdeOYrR4v
X-Proofpoint-ORIG-GUID: yMSgFZF7lrJX2LpyGaIzm5UfdeOYrR4v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 phishscore=0 adultscore=0
 impostorscore=0 malwarescore=0 suspectscore=0 mlxlogscore=968 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020084
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A latter patch will set the skb->mono_delivery_time to flag the skb->tsta=
mp
is used as the mono delivery_time (EDT) instead of the (rcv) timestamp.
skb_clear_tstamp() will then keep this delivery_time during forwarding.

This patch is to make the network tapping (with af_packet) to handle
the delivery_time stored in skb->tstamp.

Regardless of tapping at the ingress or egress,  the tapped skb is
received by the af_packet socket, so it is ingress to the af_packet
socket and it expects the (rcv) timestamp.

When tapping at egress, dev_queue_xmit_nit() is used.  It has already
expected skb->tstamp may have delivery_time,  so it does
skb_clone()+net_timestamp_set() to ensure the cloned skb has
the (rcv) timestamp before passing to the af_packet sk.
This patch only adds to clear the skb->mono_delivery_time
bit in net_timestamp_set().

When tapping at ingress, it currently expects the skb->tstamp is either 0
or the (rcv) timestamp.  Meaning, the tapping at ingress path
has already expected the skb->tstamp could be 0 and it will get
the (rcv) timestamp by ktime_get_real() when needed.

There are two cases for tapping at ingress:

One case is af_packet queues the skb to its sk_receive_queue.
The skb is either not shared or new clone created.  The newly
added skb_clear_delivery_time() is called to clear the
delivery_time (if any) and set the (rcv) timestamp if
needed before the skb is queued to the sk_receive_queue.

Another case, the ingress skb is directly copied to the rx_ring
and tpacket_get_timestamp() is used to get the (rcv) timestamp.
The newly added skb_tstamp() is used in tpacket_get_timestamp()
to check the skb->mono_delivery_time bit before returning skb->tstamp.
As mentioned earlier, the tapping@ingress has already expected
the skb may not have the (rcv) timestamp (because no sk has asked
for it) and has handled this case by directly calling ktime_get_real().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 24 ++++++++++++++++++++++++
 net/core/dev.c         |  4 +++-
 net/packet/af_packet.c |  4 +++-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 27a28920e7b3..7e2d796ece80 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3996,6 +3996,22 @@ static inline void skb_set_delivery_time(struct sk=
_buff *skb, ktime_t kt,
 	skb->mono_delivery_time =3D 0;
 }
=20
+DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
+
+/* It is used in the ingress path to clear the delivery_time.
+ * If needed, set the skb->tstamp to the (rcv) timestamp.
+ */
+static inline void skb_clear_delivery_time(struct sk_buff *skb)
+{
+	if (skb->mono_delivery_time) {
+		skb->mono_delivery_time =3D 0;
+		if (static_branch_unlikely(&netstamp_needed_key))
+			skb->tstamp =3D ktime_get_real();
+		else
+			skb->tstamp =3D 0;
+	}
+}
+
 static inline void skb_clear_tstamp(struct sk_buff *skb)
 {
 	if (skb->mono_delivery_time)
@@ -4004,6 +4020,14 @@ static inline void skb_clear_tstamp(struct sk_buff=
 *skb)
 	skb->tstamp =3D 0;
 }
=20
+static inline ktime_t skb_tstamp(const struct sk_buff *skb)
+{
+	if (skb->mono_delivery_time)
+		return 0;
+
+	return skb->tstamp;
+}
+
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
diff --git a/net/core/dev.c b/net/core/dev.c
index 2d6771075720..6d81b5a7ef3f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2020,7 +2020,8 @@ void net_dec_egress_queue(void)
 EXPORT_SYMBOL_GPL(net_dec_egress_queue);
 #endif
=20
-static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
+DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
+EXPORT_SYMBOL(netstamp_needed_key);
 #ifdef CONFIG_JUMP_LABEL
 static atomic_t netstamp_needed_deferred;
 static atomic_t netstamp_wanted;
@@ -2081,6 +2082,7 @@ EXPORT_SYMBOL(net_disable_timestamp);
 static inline void net_timestamp_set(struct sk_buff *skb)
 {
 	skb->tstamp =3D 0;
+	skb->mono_delivery_time =3D 0;
 	if (static_branch_unlikely(&netstamp_needed_key))
 		__net_timestamp(skb);
 }
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

