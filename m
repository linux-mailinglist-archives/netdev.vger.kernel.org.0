Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D45D273C12
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgIVHfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:35:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14524 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729751AbgIVHfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:35:23 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M70jx1006658
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Dd/2Hfiqw8Es3nvsXohjRD7d2Fck8HutBWsOamimOIw=;
 b=BCDXfcermkEukLKW/56Oaplv28efYdJc6sQzfmGRgvjzmzCIEUiSosDloeFg04t2TmAC
 /e5iXfK7KzY+IUQsSpAq8aZLgpu948DZnMfokQWtsj8hEFr8lMrQwVFOU/bq1NaCQHtF
 n4/6E4OMYZGZOXPg0sVXixfzMoSF+VU2CuM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33nfqu4294-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:50 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:04:49 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1AC2A294641C; Tue, 22 Sep 2020 00:04:47 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 06/11] bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
Date:   Tue, 22 Sep 2020 00:04:47 -0700
Message-ID: <20200922070447.1920932-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 adultscore=0 mlxlogscore=881 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=13 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the bpf_sk_assign() to take
ARG_PTR_TO_BTF_ID_SOCK_COMMON such that they will work with the pointer
returned by the bpf_skc_to_*() helpers also.

The bpf_sk_lookup_assign() is taking ARG_PTR_TO_SOCKET_"OR_NULL".  Meanin=
g
it specifically takes a scalar NULL.  ARG_PTR_TO_BTF_ID_SOCK_COMMON
does not allow a scalar NULL, so another ARG type is required
for this purpose and another folllow-up patch can be used if
there is such need.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6ab12d8cdd85..063aba8a81e6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6221,7 +6221,7 @@ static const struct bpf_func_proto bpf_tcp_gen_sync=
ookie_proto =3D {
=20
 BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64,=
 flags)
 {
-	if (flags !=3D 0)
+	if (!sk || flags !=3D 0)
 		return -EINVAL;
 	if (!skb_at_tc_ingress(skb))
 		return -EOPNOTSUPP;
@@ -6245,7 +6245,8 @@ static const struct bpf_func_proto bpf_sk_assign_pr=
oto =3D {
 	.gpl_only	=3D false,
 	.ret_type	=3D RET_INTEGER,
 	.arg1_type      =3D ARG_PTR_TO_CTX,
-	.arg2_type      =3D ARG_PTR_TO_SOCK_COMMON,
+	.arg2_type      =3D ARG_PTR_TO_BTF_ID_SOCK_COMMON,
+	.arg2_btf_id	=3D &btf_sock_ids[BTF_SOCK_TYPE_SOCK_COMMON],
 	.arg3_type	=3D ARG_ANYTHING,
 };
=20
--=20
2.24.1

