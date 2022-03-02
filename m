Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA554CAF29
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiCBT47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242517AbiCBT45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:56:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1B8D95ED
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:56:12 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 222JMmG9000702
        for <netdev@vger.kernel.org>; Wed, 2 Mar 2022 11:56:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WYhiMgtL0PnkSBux1VzTdoO6AF6lDNDcFeOTE4ROfcg=;
 b=CAFWzqa3XniyGAnNQ+3fjTa/NJOx5xYszXYAARqXoD70aPWHi21T2aKmoW+hCJ1JhsXg
 6w1ePDl7vZkxI/SHz2C6U6MHxs9ZADQ8BdTn/pwYtY7HUCmgbjZ0TD0WRAECIlN6vXyd
 M0vtVuCXRqNEpYr3lnyUXv4BST/kVIu41js= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ej7jgvghh-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 11:56:11 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 11:56:09 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B140C7BD35AA; Wed,  2 Mar 2022 11:55:50 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v6 net-next 05/13] net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()
Date:   Wed, 2 Mar 2022 11:55:50 -0800
Message-ID: <20220302195550.3481122-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220302195519.3479274-1-kafai@fb.com>
References: <20220302195519.3479274-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Ba1gEdxlUqM6CWHRZ1serACKFqlmy2_J
X-Proofpoint-ORIG-GUID: Ba1gEdxlUqM6CWHRZ1serACKFqlmy2_J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2203020085
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

The previous patches handled the delivery_time before sch_handle_ingress(=
).

This patch can now set the skb->mono_delivery_time to flag the skb->tstam=
p
is used as the mono delivery_time (EDT) instead of the (rcv) timestamp
and also clear it with skb_clear_delivery_time() after
sch_handle_ingress().  This will make the bpf_redirect_*()
to keep the mono delivery_time and used by a qdisc (fq) of
the egress-ing interface.

A latter patch will postpone the skb_clear_delivery_time() until the
stack learns that the skb is being delivered locally and that will
make other kernel forwarding paths (ip[6]_forward) able to keep
the delivery_time also.  Thus, like the previous patches on using
the skb->mono_delivery_time bit, calling skb_clear_delivery_time()
is not limited within the CONFIG_NET_INGRESS to avoid too many code
churns among this set.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/skbuff.h | 3 +--
 net/core/dev.c         | 8 ++++++--
 net/ipv4/ip_output.c   | 3 +--
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8e8a4af4f9e2..0f5fd53059cd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3993,8 +3993,7 @@ static inline void skb_set_delivery_time(struct sk_=
buff *skb, ktime_t kt,
 					 bool mono)
 {
 	skb->tstamp =3D kt;
-	/* Setting mono_delivery_time will be enabled later */
-	skb->mono_delivery_time =3D 0;
+	skb->mono_delivery_time =3D kt && mono;
 }
=20
 DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3ff686cc8c84..0fc02cf32476 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5193,8 +5193,10 @@ static int __netif_receive_skb_core(struct sk_buff=
 **pskb, bool pfmemalloc,
 			goto out;
 	}
=20
-	if (skb_skip_tc_classify(skb))
+	if (skb_skip_tc_classify(skb)) {
+		skb_clear_delivery_time(skb);
 		goto skip_classify;
+	}
=20
 	if (pfmemalloc)
 		goto skip_taps;
@@ -5223,12 +5225,14 @@ static int __netif_receive_skb_core(struct sk_buf=
f **pskb, bool pfmemalloc,
 			goto another_round;
 		if (!skb)
 			goto out;
+		skb_clear_delivery_time(skb);
=20
 		nf_skip_egress(skb, false);
 		if (nf_ingress(skb, &pt_prev, &ret, orig_dev) < 0)
 			goto out;
-	}
+	} else
 #endif
+		skb_clear_delivery_time(skb);
 	skb_reset_redirect(skb);
 skip_classify:
 	if (pfmemalloc && !skb_pfmemalloc_protocol(skb))
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index a9588e0c82c5..00b4bf26fd93 100644
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
--=20
2.30.2

