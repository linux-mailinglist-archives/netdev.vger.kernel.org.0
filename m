Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908F5217CCA
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728988AbgGHBxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgGHBxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:25 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681r61K023176
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=K+Oo9hwlKMkvex1M4HMNzYaLyUtmW78Tyf9o//cHJi0=;
 b=Qw/3CscqsR++LppbmDFGAdpxAuC4dvxu1yNNej9yf6d/NP0+/qKPWtpDaAm2S5hQC78L
 a+VCCDOl05ViiNJfZApND0hGHUr+POgYe8NBZvx3fTsR7soz5T+BMRTVYdkAAyf7ME7r
 kiEVuNB2h+U6EXh/fwl+pikBC4d6mHhvtX4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3239rs4xdu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:24 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AE16F2EC39F5; Tue,  7 Jul 2020 18:53:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/6] libbpf: make BTF finalization strict
Date:   Tue, 7 Jul 2020 18:53:13 -0700
Message-ID: <20200708015318.3827358-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=625
 mlxscore=0 suspectscore=25 clxscore=1015 impostorscore=0 adultscore=0
 malwarescore=0 cotscore=-2147483648 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With valid ELF and valid BTF, there is no reason (apart from bugs) why BT=
F
finalization should fail. So make it strict and return error if it fails.=
 This
makes CO-RE relocation more reliable, as they are not going to be just
silently skipped, if BTF finalization failed.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4ea7f4f1a691..f4a1cf7f4873 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2473,19 +2473,11 @@ static int bpf_object__finalize_btf(struct bpf_ob=
ject *obj)
 		return 0;
=20
 	err =3D btf__finalize_data(obj, obj->btf);
-	if (!err)
-		return 0;
-
-	pr_warn("Error finalizing %s: %d.\n", BTF_ELF_SEC, err);
-	btf__free(obj->btf);
-	obj->btf =3D NULL;
-	btf_ext__free(obj->btf_ext);
-	obj->btf_ext =3D NULL;
-
-	if (libbpf_needs_btf(obj)) {
-		pr_warn("BTF is required, but is missing or corrupted.\n");
-		return -ENOENT;
+	if (err) {
+		pr_warn("Error finalizing %s: %d.\n", BTF_ELF_SEC, err);
+		return err;
 	}
+
 	return 0;
 }
=20
--=20
2.24.1

