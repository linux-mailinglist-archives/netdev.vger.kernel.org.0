Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF21BD1A6
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgD2BVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:21:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgD2BVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:21:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T1IQWj019965
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hSM//RcgUuriiaYix4PUyF1dQLzWxdjRus3M6YckzYE=;
 b=fKBUNvZ6oYXO/z41uC/FEGUY4zFFPr/0XnqZ/Rtm+QJXoCmLeSqTFMCrqgQ8yhw+u5xA
 WGDENtO+AFqKXYXVTKfU4p2ppkS9z1BtXJNbK8ylKR8N6a/07S4F+Kvp8/GclwP9Pf8d
 sUcpoYu+4PbjAGxvYE78A3eq5+9BnfdnDPQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30n54ek7nw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:21:34 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 18:21:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 80ECB2EC30E4; Tue, 28 Apr 2020 18:21:30 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, KP Singh <kpsingh@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 08/11] libbpf: fix huge memory leak in libbpf_find_vmlinux_btf_id()
Date:   Tue, 28 Apr 2020 18:21:08 -0700
Message-ID: <20200429012111.277390-9-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200429012111.277390-1-andriin@fb.com>
References: <20200429012111.277390-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 suspectscore=25 spamscore=0 impostorscore=0
 mlxlogscore=920 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1015 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BTF object wasn't freed.

Cc: KP Singh <kpsingh@google.com>
Fixes: a6ed02cac690 ("libbpf: Load btf_vmlinux only once per object.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8e1dc6980fac..a0f943e6b7bb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6672,6 +6672,7 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 			       enum bpf_attach_type attach_type)
 {
 	struct btf *btf;
+	int err;
=20
 	btf =3D libbpf_find_kernel_btf();
 	if (IS_ERR(btf)) {
@@ -6679,7 +6680,9 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 		return -EINVAL;
 	}
=20
-	return __find_vmlinux_btf_id(btf, name, attach_type);
+	err =3D __find_vmlinux_btf_id(btf, name, attach_type);
+	btf__free(btf);
+	return err;
 }
=20
 static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_f=
d)
--=20
2.24.1

