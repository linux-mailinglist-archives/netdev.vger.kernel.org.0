Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3CF1BAEF7
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgD0UMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:12:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26852 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgD0UMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 16:12:44 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RKAomR031134
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=FlGBMjFQ58EfoYMjgVzYQGqT38VwRmb0fAAp4dHeBEM=;
 b=RE2RnCXTYm2NqYToXxK0glrj9/9A/Nlkayold1Zn5igT/QhRWAZmvD99Vi8nD9t/Y/Ow
 +q4mmJJk3DYV0Ma9xsl2Dt3Wqju0teYKfP4jg7lAtUXW2F5IHRI+I/Fv6ejbVdiigbl5
 ZzvtZl4kfhrVh/0y1AHTNlPVNLYyRufo4OE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57q245w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 13:12:44 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 13:12:43 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 2BF2F3700871; Mon, 27 Apr 2020 13:12:39 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v1 04/19] bpf: allow loading of a bpf_iter program
Date:   Mon, 27 Apr 2020 13:12:39 -0700
Message-ID: <20200427201239.2994896-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427201235.2994549-1-yhs@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_15:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004270164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bpf_iter program is a tracing program with attach type
BPF_TRACE_ITER. The load attribute
  attach_btf_id
is used by the verifier against a particular kernel function,
e.g., __bpf_iter__bpf_map in our previous bpf_map iterator.

The program return value must be 0 for now. In the
future, other return values may be used for filtering or
teminating the iterator.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/verifier.c          | 20 ++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a6c47f3febe..f39b9fec37ab 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_ITER,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 91728e0f27eb..fd36c22685d9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7074,6 +7074,11 @@ static int check_return_code(struct bpf_verifier_e=
nv *env)
 			return 0;
 		range =3D tnum_const(0);
 		break;
+	case BPF_PROG_TYPE_TRACING:
+		if (env->prog->expected_attach_type !=3D BPF_TRACE_ITER)
+			return 0;
+		range =3D tnum_const(0);
+		break;
 	default:
 		return 0;
 	}
@@ -10454,6 +10459,7 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
 	struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
 	u32 btf_id =3D prog->aux->attach_btf_id;
 	const char prefix[] =3D "btf_trace_";
+	struct btf_func_model fmodel;
 	int ret =3D 0, subprog =3D -1, i;
 	struct bpf_trampoline *tr;
 	const struct btf_type *t;
@@ -10595,6 +10601,20 @@ static int check_attach_btf_id(struct bpf_verifi=
er_env *env)
 		prog->aux->attach_func_proto =3D t;
 		prog->aux->attach_btf_trace =3D true;
 		return 0;
+	case BPF_TRACE_ITER:
+		if (!btf_type_is_func(t)) {
+			verbose(env, "attach_btf_id %u is not a function\n",
+				btf_id);
+			return -EINVAL;
+		}
+		t =3D btf_type_by_id(btf, t->type);
+		if (!btf_type_is_func_proto(t))
+			return -EINVAL;
+		prog->aux->attach_func_name =3D tname;
+		prog->aux->attach_func_proto =3D t;
+		ret =3D btf_distill_func_proto(&env->log, btf, t,
+					     tname, &fmodel);
+		return ret;
 	default:
 		if (!prog_extension)
 			return -EINVAL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 4a6c47f3febe..f39b9fec37ab 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -215,6 +215,7 @@ enum bpf_attach_type {
 	BPF_TRACE_FEXIT,
 	BPF_MODIFY_RETURN,
 	BPF_LSM_MAC,
+	BPF_TRACE_ITER,
 	__MAX_BPF_ATTACH_TYPE
 };
=20
--=20
2.24.1

