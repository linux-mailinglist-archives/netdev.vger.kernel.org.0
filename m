Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A1B2DB772
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgLPABV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:01:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53870 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgLOXh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 18:37:59 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFNZEkK019623
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Pvz7Me3uWv3Bgg8leBWmu6W1S9zf+6E28CBDJrJbUcI=;
 b=bOBucWjz0A1rB82AxfYWp/bWVld011AkOXyeuedjjkw9JXMfSuk5Fc8rzjf0cDfNUi2y
 lm4qNbhuXZe1VqoXp5jInoRMGMau8iwvqnI6Wsi0dOSw6A5A8feNLESqG1RywTC2lxyI
 HLyBWuMou4ATf470GL53oncCvoDm3bdOa+Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35eypsjxts-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 15:37:18 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Dec 2020 15:37:12 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 55B0F62E56FB; Tue, 15 Dec 2020 15:37:11 -0800 (PST)
From:   Song Liu <songliubraving@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH v2 bpf-next 3/4] libbpf: introduce section "iter.s/" for sleepable bpf_iter program
Date:   Tue, 15 Dec 2020 15:37:01 -0800
Message-ID: <20201215233702.3301881-4-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201215233702.3301881-1-songliubraving@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_13:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 mlxlogscore=809
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleepable iterator program have access to helper functions like bpf_d_pat=
h.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f6ea118..12ad4593a91cb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8541,6 +8541,11 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
 		.expected_attach_type =3D BPF_TRACE_ITER,
 		.is_attach_btf =3D true,
 		.attach_fn =3D attach_iter),
+	SEC_DEF("iter.s/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_ITER,
+		.is_attach_btf =3D true,
+		.is_sleepable =3D true,
+		.attach_fn =3D attach_iter),
 	BPF_EAPROG_SEC("xdp_devmap/",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
 	BPF_EAPROG_SEC("xdp_cpumap/",		BPF_PROG_TYPE_XDP,
--=20
2.24.1

