Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3F4B1F16
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347598AbiBKHNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347593AbiBKHNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:11 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A9D10EA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:10 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrRaP018514
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=DgvDXN9XBlObkLmDDnSGd2RQgPd6++UhlTWkwCnDYGw=;
 b=nfVCSjrojoOR+8JKaOc3eipBHeGkUTnEMycqDcpYruwpFEx4lQspRjnwfCS98fT9GO+p
 pw1F2WWsq3yWkbHwFn2u/ldvk5YrfZOEYeQkINfg5SqQUmKQdQKOwKXpZ8yybBUhsGj1
 hOquHbBb1AK4qr8/f2ugUVo2H+tfiCExshI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5866v2ye-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:10 -0800
Received: from twshared6457.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:09 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B82616C75A26; Thu, 10 Feb 2022 23:13:03 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 5/8] bpf: Keep the (rcv) timestamp behavior for the existing tc-bpf@ingress
Date:   Thu, 10 Feb 2022 23:13:03 -0800
Message-ID: <20220211071303.890169-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Mh_4PREj25pFdEWt-DN0oqGihBjbogch
X-Proofpoint-ORIG-GUID: Mh_4PREj25pFdEWt-DN0oqGihBjbogch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110040
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
as a (rcv) timestamp.  This patch is to backward compatible with the
(rcv) timestamp expectation when the skb->tstamp has a mono delivery_time=
.

If needed, the patch first saves the mono delivery_time.  Depending on
the static key "netstamp_needed_key", it then resets the skb->tstamp to
either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
been changed, it will restore the earlier saved mono delivery_time.

The current logic to run tc-bpf@ingress is refactored to a new
bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf=
.
The above new delivery_time save/restore logic is also done together in
this function.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/filter.h | 28 ++++++++++++++++++++++++++++
 net/sched/act_bpf.c    |  5 +----
 net/sched/cls_bpf.c    |  6 +-----
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index d23e999dc032..e43e1701a80e 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct =
sk_buff *skb)
 	cb->data_end  =3D skb->data + skb_headlen(skb);
 }
=20
+static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog=
 *prog,
+						   struct sk_buff *skb)
+{
+	ktime_t tstamp, saved_mono_dtime =3D 0;
+	int filter_res;
+
+	if (unlikely(skb->mono_delivery_time)) {
+		saved_mono_dtime =3D skb->tstamp;
+		skb->mono_delivery_time =3D 0;
+		if (static_branch_unlikely(&netstamp_needed_key))
+			skb->tstamp =3D tstamp =3D ktime_get_real();
+		else
+			skb->tstamp =3D tstamp =3D 0;
+	}
+
+	/* It is safe to push/pull even if skb_shared() */
+	__skb_push(skb, skb->mac_len);
+	bpf_compute_data_pointers(skb);
+	filter_res =3D bpf_prog_run(prog, skb);
+	__skb_pull(skb, skb->mac_len);
+
+	/* __sk_buff->tstamp was not changed, restore the delivery_time */
+	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) =3D=3D tstamp)
+		skb_set_delivery_time(skb, saved_mono_dtime, true);
+
+	return filter_res;
+}
+
 /* Similar to bpf_compute_data_pointers(), except that save orginal
  * data in cb->data and cb->meta_data for restore.
  */
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index a77d8908e737..14c3bd0a5088 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -45,10 +45,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const stru=
ct tc_action *act,
=20
 	filter =3D rcu_dereference(prog->filter);
 	if (at_ingress) {
-		__skb_push(skb, skb->mac_len);
-		bpf_compute_data_pointers(skb);
-		filter_res =3D bpf_prog_run(filter, skb);
-		__skb_pull(skb, skb->mac_len);
+		filter_res =3D bpf_prog_run_at_ingress(filter, skb);
 	} else {
 		bpf_compute_data_pointers(skb);
 		filter_res =3D bpf_prog_run(filter, skb);
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index df19a847829e..036b2e1f74af 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -93,11 +93,7 @@ static int cls_bpf_classify(struct sk_buff *skb, const=
 struct tcf_proto *tp,
 		if (tc_skip_sw(prog->gen_flags)) {
 			filter_res =3D prog->exts_integrated ? TC_ACT_UNSPEC : 0;
 		} else if (at_ingress) {
-			/* It is safe to push/pull even if skb_shared() */
-			__skb_push(skb, skb->mac_len);
-			bpf_compute_data_pointers(skb);
-			filter_res =3D bpf_prog_run(prog->filter, skb);
-			__skb_pull(skb, skb->mac_len);
+			filter_res =3D bpf_prog_run_at_ingress(prog->filter, skb);
 		} else {
 			bpf_compute_data_pointers(skb);
 			filter_res =3D bpf_prog_run(prog->filter, skb);
--=20
2.30.2

