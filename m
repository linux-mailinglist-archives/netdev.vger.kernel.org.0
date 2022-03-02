Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6DA4CAF2F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242585AbiCBT5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbiCBT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:57:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9777DA84E
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:56:20 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMnHr011047
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 11:56:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dYmfrbOh/lEFzF9JAZtCjftFPCmiiD0gqSESwxwPk54=;
 b=OuhlswW+v6d63fj/O9nNiRXxXwTAWnXXrHdRHREXd93Ls8Saka69OpMKGm/i7D/XjBQ6
 FO5VaC4O3O/0QWVPeaF4jAVUQaufI32ntIJHCHoMHlkcV1JXpoNi31F/FfMXOLAGqRQq
 +2epPXvAdWv4lzrdc2mg36sK13noTTiTa74= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ejaqwtagk-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:56:20 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:56:15 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A7D267BD36ED; Wed,  2 Mar 2022 11:56:09 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v6 net-next 08/13] net: ipv6: Get rcv timestamp if needed when handling hop-by-hop IOAM option
Date:   Wed, 2 Mar 2022 11:56:09 -0800
Message-ID: <20220302195609.3483112-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
References: <20220302195519.3479274-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: goW3w70k6eSyF0qrfW3AcQgae3feBaNG
X-Proofpoint-ORIG-GUID: goW3w70k6eSyF0qrfW3AcQgae3feBaNG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 priorityscore=1501 bulkscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020085
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOAM is a hop-by-hop option with a temporary iana allocation (49).
Since it is hop-by-hop, it is done before the input routing decision.
One of the traced data field is the (rcv) timestamp.

When the locally generated skb is looping from egress to ingress over
a virtual interface (e.g. veth, loopback...), skb->tstamp may have the
delivery time before it is known that it will be delivered locally
and received by another sk.

Like handling the network tapping (tcpdump) in the earlier patch,
this patch gets the timestamp if needed without over-writing the
delivery_time in the skb->tstamp.  skb_tstamp_cond() is added to do the
ktime_get_real() with an extra cond arg to check on top of the
netstamp_needed_key static key.  skb_tstamp_cond() will also be used in
a latter patch and it needs the netstamp_needed_key check.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 11 +++++++++++
 net/ipv6/ioam6.c       | 19 +++++++++----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0f5fd53059cd..4b5b926a81f2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4028,6 +4028,17 @@ static inline ktime_t skb_tstamp(const struct sk_b=
uff *skb)
 	return skb->tstamp;
 }
=20
+static inline ktime_t skb_tstamp_cond(const struct sk_buff *skb, bool co=
nd)
+{
+	if (!skb->mono_delivery_time && skb->tstamp)
+		return skb->tstamp;
+
+	if (static_branch_unlikely(&netstamp_needed_key) || cond)
+		return ktime_get_real();
+
+	return 0;
+}
+
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index e159eb4328a8..1098131ed90c 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -635,7 +635,8 @@ static void __ioam6_fill_trace_data(struct sk_buff *s=
kb,
 				    struct ioam6_schema *sc,
 				    u8 sclen, bool is_input)
 {
-	struct __kernel_sock_timeval ts;
+	struct timespec64 ts;
+	ktime_t tstamp;
 	u64 raw64;
 	u32 raw32;
 	u16 raw16;
@@ -680,10 +681,9 @@ static void __ioam6_fill_trace_data(struct sk_buff *=
skb,
 		if (!skb->dev) {
 			*(__be32 *)data =3D cpu_to_be32(IOAM6_U32_UNAVAILABLE);
 		} else {
-			if (!skb->tstamp)
-				__net_timestamp(skb);
+			tstamp =3D skb_tstamp_cond(skb, true);
+			ts =3D ktime_to_timespec64(tstamp);
=20
-			skb_get_new_timestamp(skb, &ts);
 			*(__be32 *)data =3D cpu_to_be32((u32)ts.tv_sec);
 		}
 		data +=3D sizeof(__be32);
@@ -694,13 +694,12 @@ static void __ioam6_fill_trace_data(struct sk_buff =
*skb,
 		if (!skb->dev) {
 			*(__be32 *)data =3D cpu_to_be32(IOAM6_U32_UNAVAILABLE);
 		} else {
-			if (!skb->tstamp)
-				__net_timestamp(skb);
+			if (!trace->type.bit2) {
+				tstamp =3D skb_tstamp_cond(skb, true);
+				ts =3D ktime_to_timespec64(tstamp);
+			}
=20
-			if (!trace->type.bit2)
-				skb_get_new_timestamp(skb, &ts);
-
-			*(__be32 *)data =3D cpu_to_be32((u32)ts.tv_usec);
+			*(__be32 *)data =3D cpu_to_be32((u32)(ts.tv_nsec / NSEC_PER_USEC));
 		}
 		data +=3D sizeof(__be32);
 	}
--=20
2.30.2

