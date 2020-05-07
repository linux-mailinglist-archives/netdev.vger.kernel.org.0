Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5031C81AB
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgEGFjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:39:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEGFjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:39 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0475YwBM005375
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=okZAREpPDBxGX+fNKJ3E0+UyoJI29Z9iieFwApU22Rk=;
 b=Yf4DN0zjedmcRLACOikarT3izSYySklssoyhh4qMkpvyrZGbIzpRqgoUY2tF8G4hV689
 Vg1jo2jfnyFCO8COABpWlNcdJnMLTbTi7uiVl0pSMJZdjwhgBiSG3VkiblqM7ec0ifR8
 kyAs6Y1pnd7azbD0HhP/oN4Sonsj5nhmZKI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30v07ykm3c-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:38 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:37 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 04A1B3701B99; Wed,  6 May 2020 22:39:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 15/21] bpf: support variable length array in tracing programs
Date:   Wed, 6 May 2020 22:39:32 -0700
Message-ID: <20200507053932.1544820-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxlogscore=719
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070043
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/btf.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c490fbde22d4..dcd233139294 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3833,6 +3833,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	const struct btf_type *mtype, *elem_type =3D NULL;
 	const struct btf_member *member;
 	const char *tname, *mname;
+	u32 vlen;
=20
 again:
 	tname =3D __btf_name_by_offset(btf_vmlinux, t->name_off);
@@ -3841,7 +3842,43 @@ int btf_struct_access(struct bpf_verifier_log *log=
,
 		return -EINVAL;
 	}
=20
+	vlen =3D btf_type_vlen(t);
 	if (off + size > t->size) {
+		/* If the last element is a variable size array, we may
+		 * need to relax the rule.
+		 */
+		struct btf_array *array_elem;
+
+		if (vlen =3D=3D 0)
+			goto error;
+
+		member =3D btf_type_member(t) + vlen - 1;
+		mtype =3D btf_type_skip_modifiers(btf_vmlinux, member->type,
+						NULL);
+		if (!btf_type_is_array(mtype))
+			goto error;
+
+		array_elem =3D (struct btf_array *)(mtype + 1);
+		if (array_elem->nelems !=3D 0)
+			goto error;
+
+		moff =3D btf_member_bit_offset(t, member) / 8;
+		if (off < moff)
+			goto error;
+
+		/* Only allow structure for now, can be relaxed for
+		 * other types later.
+		 */
+		elem_type =3D btf_type_skip_modifiers(btf_vmlinux,
+						    array_elem->type, NULL);
+		if (!btf_type_is_struct(elem_type))
+			goto error;
+
+		off =3D (off - moff) % elem_type->size;
+		return btf_struct_access(log, elem_type, off, size, atype,
+					 next_btf_id);
+
+error:
 		bpf_log(log, "access beyond struct %s at off %u size %u\n",
 			tname, off, size);
 		return -EACCES;
--=20
2.24.1

