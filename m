Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B411AB1A3
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407043AbgDOT2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:28:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406898AbgDOT2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:06 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJPWtt012507
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Bp1JvAoneQFgmc/ToLghy03QvBN5qs0mDU8YKzOglBY=;
 b=qS8AqqA4x2KzflYge7Puz3EY/7rJozAgERnYEmCZKXaRqVe+Lb5F5EjtZzklk9oLFzvG
 gIylMoxLzJ9zFm0o9cUW/rnApWAmaQqYzATnnrN6+Wpu+TrsRlZFMQaXZFWguG1jambj
 lKDvP5aB1oNjNaB0ybizq+/bkE+AUgcAupY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn82qtc1-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:06 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:55 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 276A73700AF5; Wed, 15 Apr 2020 12:27:53 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 11/17] bpf: support variable length array in tracing programs
Date:   Wed, 15 Apr 2020 12:27:53 -0700
Message-ID: <20200415192753.4083637-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=736
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In /proc/net/ipv6_route, we have
  struct fib6_info {
    struct fib6_table *fib6_table;
    ...
    struct fib6_nh fib6_nh[0];
  }
  struct fib6_nh {
    struct fib_nh_common nh_common;
    struct rt6_info **rt6i_pcpu;
    struct rt6_exception_bucket *rt6i_exception_bucket;
  };
  struct fib_nh_common {
    ...
    u8 nhc_gw_family;
    ...
  }

The access:
  struct fib6_nh *fib6_nh =3D &rt->fib6_nh;
  ... fib6_nh->nh_common.nhc_gw_family ...

This patch ensures such an access is handled properly.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/btf.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2c098e6b1acc..dcee5ca0d501 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3840,6 +3840,31 @@ int btf_struct_access(struct bpf_verifier_log *log=
,
 	}
=20
 	if (off + size > t->size) {
+		/* If the last element is a variable size array, we may
+		 * need to relax the rule.
+		 */
+		struct btf_array *array_elem;
+		u32 vlen =3D btf_type_vlen(t);
+		u32 last_member_type;
+
+		member =3D btf_type_member(t);
+		last_member_type =3D member[vlen - 1].type;
+		mtype =3D btf_type_by_id(btf_vmlinux, last_member_type);
+		if (!btf_type_is_array(mtype))
+			goto error;
+
+		array_elem =3D (struct btf_array *)(mtype + 1);
+		if (array_elem->nelems !=3D 0)
+			goto error;
+
+		elem_type =3D btf_type_by_id(btf_vmlinux, array_elem->type);
+		if (!btf_type_is_struct(elem_type))
+			goto error;
+
+		off =3D (off - t->size) % elem_type->size;
+		return btf_struct_access(log, elem_type, off, size, atype, next_btf_id=
);
+
+error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
 			tname, off, size);
 		return -EACCES;
--=20
2.24.1

