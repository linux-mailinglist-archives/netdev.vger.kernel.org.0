Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01E04B1F17
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347594AbiBKHNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:13:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347617AbiBKHNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:13:15 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6772F110E
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:14 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21ANrRRS025901
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EVTUWhfTh9Xw+oE/92HMbTSBKTlmpsbLoRRswODvVV0=;
 b=rTOGxSa5gt1HExPduCmJy/ErfM0blQ5dgfZVlzN1+UxmRYUq/OR0hjrySp7tJzqsvdGT
 UZSpndqFdLf5FF7q36DYetg/eBKv49Njdv1JIjHMdjE5/p9r8Frd1PF45rVpueHxtcP9
 C5uu1nP3BD1DkUTp2utvb64nbGt/AFMYmpE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e59rpu6tx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:13:14 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 23:13:12 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 06CE86C75AEE; Thu, 10 Feb 2022 23:13:10 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 net-next 6/8] bpf: Clear skb->mono_delivery_time bit if needed after running tc-bpf@egress
Date:   Thu, 10 Feb 2022 23:13:10 -0800
Message-ID: <20220211071310.892007-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220211071232.885225-1-kafai@fb.com>
References: <20220211071232.885225-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: QE6Bu_TU9jJA-5bPPTSdAffRNpDo3RL4
X-Proofpoint-GUID: QE6Bu_TU9jJA-5bPPTSdAffRNpDo3RL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_02,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 spamscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
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

The tc-bpf@egress reads and writes the skb->tstamp as delivery_time.
If tc-bpf@egress sets skb->tstamp to 0, skb->mono_delivery_time should
also be cleared.  It is done in cls_bpf.c and act_bpf.c after
running the tc-bpf@egress.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/sched/act_bpf.c | 2 ++
 net/sched/cls_bpf.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index 14c3bd0a5088..d89470976500 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -49,6 +49,8 @@ static int tcf_bpf_act(struct sk_buff *skb, const struc=
t tc_action *act,
 	} else {
 		bpf_compute_data_pointers(skb);
 		filter_res =3D bpf_prog_run(filter, skb);
+		if (unlikely(skb->mono_delivery_time && !skb->tstamp))
+			skb->mono_delivery_time =3D 0;
 	}
 	if (skb_sk_is_prefetched(skb) && filter_res !=3D TC_ACT_OK)
 		skb_orphan(skb);
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 036b2e1f74af..c251d1df1fa3 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -97,6 +97,8 @@ static int cls_bpf_classify(struct sk_buff *skb, const =
struct tcf_proto *tp,
 		} else {
 			bpf_compute_data_pointers(skb);
 			filter_res =3D bpf_prog_run(prog->filter, skb);
+			if (unlikely(skb->mono_delivery_time && !skb->tstamp))
+				skb->mono_delivery_time =3D 0;
 		}
=20
 		if (prog->exts_integrated) {
--=20
2.30.2

