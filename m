Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757601BAEFE
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD0UM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27542 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgD0UMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:55 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RK1sOq011056
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kXoluhMsHKsMkwaNLp1zg62W5qFepa1g37rsHxyv4GI=;
 b=Bdyp1rF6/9VkNW9Mra5YyWXJJgD6vovHiBd1w+YTQe+jPr4IdeFvz7g3Bxjvny+5p/J4
 qofDjECIDR8z1kxYvo7Q+i20VIWpvIui7MdZw0hH56UNBuRgqagKD7IV+Igvo2zI/U6Z
 Upm2KhH2qqQ7NvhFzkTEEsHLqz/UWQWlKfk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gdyeq-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:53 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:51 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7FF303700871; Mon, 27 Apr 2020 13:12:51 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 14/19] bpf: support variable length array in tracing programs
Date:   Mon, 27 Apr 2020 13:12:51 -0700
Message-ID: <20200427201251.2995957-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=0 mlxlogscore=739 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270161
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
 kernel/bpf/btf.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 2c098e6b1acc..22c69e1d5a56 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3831,6 +3831,7 @@ int btf_struct_access(struct bpf_verifier_log *log,
 	const struct btf_type *mtype, *elem_type =3D NULL;
 	const struct btf_member *member;
 	const char *tname, *mname;
+	u32 vlen;
=20
 again:
 	tname =3D __btf_name_by_offset(btf_vmlinux, t->name_off);
@@ -3839,7 +3840,37 @@ int btf_struct_access(struct bpf_verifier_log *log=
,
 		return -EINVAL;
 	}
=20
-	if (off + size > t->size) {
+	vlen =3D btf_type_vlen(t);
+	if (vlen > 0 && off + size > t->size) {
+		/* If the last element is a variable size array, we may
+		 * need to relax the rule.
+		 */
+		struct btf_array *array_elem;
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

