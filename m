Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85141A2C4F
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDHX0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:26:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726651AbgDHXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:49 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 038NPkrb015030
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hhSDLhksnFQwWDo9xGvziq4KSONqdprdX6aZrtmDNNg=;
 b=P458p4z0sa4Cs74OOSrgOUOMC4XAYTau7rkfBW0HuPG/q919Q/rB+Au00W8mMEhPl3ZE
 0RGdAtWoEEswkDAGISYuFIfGp/C1ODD+xtIWhVtEcM+WKGHidBNOQZQLHv5x9lsq/qm1
 T+R0p5SLduRbUQfNHcfn8eq9+yK1svGuPC0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3091m5fkux-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:49 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:33 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 6DA973700D98; Wed,  8 Apr 2020 16:25:32 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 10/16] bpf: support variable length array in tracing programs
Date:   Wed, 8 Apr 2020 16:25:32 -0700
Message-ID: <20200408232532.2676247-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=726 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004080164
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
index d65c6912bdaf..89a0d983b169 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3837,6 +3837,31 @@ int btf_struct_access(struct bpf_verifier_log *log=
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

