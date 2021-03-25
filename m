Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8853486A3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhCYBw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:52:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19208 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236032AbhCYBwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:08 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1mNIE001087
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=H2mx139/2obYNybO33ciNhdjOOBWHsiCCukqaKY5pK0=;
 b=jSovQaxZmTb2AOdC0yiz7l5H+dmEV2kHaVp6aUuleNChEBYvKZ86pIn36u1BAYkB4ZpF
 Ah73xaSyGYKlOB6+klPeUM2ep3g9GnYUnl9GbHI28ZlBBS/iFPG1vS5Dv/xMkjHFKN3y
 42shBCGHFoEZYQIVDwivQevazRPKPSsMlVw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37fn33sjah-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:08 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:06 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id BD04A29429D7; Wed, 24 Mar 2021 18:52:01 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf-next 06/14] bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
Date:   Wed, 24 Mar 2021 18:52:01 -0700
Message-ID: <20210325015201.1546345-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch puts some tcp cong helper functions, tcp_slow_start()
and tcp_cong_avoid_ai(), into the allowlist for the bpf-tcp-cc
program.

A few tcp cc implementation functions are also put into the
allowlist.  A potential use case is the bpf-tcp-cc implementation
may only want to override a subset of a tcp_congestion_ops.  For others,
the bpf-tcp-cc can directly call the kernel counter parts instead of
re-implementing (or copy-and-pasting) them to the bpf program.

They will only be available to the bpf-tcp-cc typed program.
The allowlist functions are not bounded to a fixed ABI contract.
When any of them has changed, the bpf-tcp-cc program has to be changed
like any in-tree/out-of-tree kernel tcp-cc implementations do also.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index d520e61649c8..40520b77a307 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -5,6 +5,7 @@
 #include <linux/bpf_verifier.h>
 #include <linux/bpf.h>
 #include <linux/btf.h>
+#include <linux/btf_ids.h>
 #include <linux/filter.h>
 #include <net/tcp.h>
 #include <net/bpf_sk_storage.h>
@@ -178,10 +179,50 @@ bpf_tcp_ca_get_func_proto(enum bpf_func_id func_id,
 	}
 }
=20
+BTF_SET_START(bpf_tcp_ca_kfunc_ids)
+BTF_ID(func, tcp_reno_ssthresh)
+BTF_ID(func, tcp_reno_cong_avoid)
+BTF_ID(func, tcp_reno_undo_cwnd)
+BTF_ID(func, tcp_slow_start)
+BTF_ID(func, tcp_cong_avoid_ai)
+#if IS_BUILTIN(CONFIG_TCP_CONG_CUBIC)
+BTF_ID(func, cubictcp_init)
+BTF_ID(func, cubictcp_recalc_ssthresh)
+BTF_ID(func, cubictcp_cong_avoid)
+BTF_ID(func, cubictcp_state)
+BTF_ID(func, cubictcp_cwnd_event)
+BTF_ID(func, cubictcp_acked)
+#endif
+#if IS_BUILTIN(CONFIG_TCP_CONG_DCTCP)
+BTF_ID(func, dctcp_init)
+BTF_ID(func, dctcp_update_alpha)
+BTF_ID(func, dctcp_cwnd_event)
+BTF_ID(func, dctcp_ssthresh)
+BTF_ID(func, dctcp_cwnd_undo)
+BTF_ID(func, dctcp_state)
+#endif
+#if IS_BUILTIN(CONFIG_TCP_CONG_BBR)
+BTF_ID(func, bbr_init)
+BTF_ID(func, bbr_main)
+BTF_ID(func, bbr_sndbuf_expand)
+BTF_ID(func, bbr_undo_cwnd)
+BTF_ID(func, bbr_cwnd_even),
+BTF_ID(func, bbr_ssthresh)
+BTF_ID(func, bbr_min_tso_segs)
+BTF_ID(func, bbr_set_state)
+#endif
+BTF_SET_END(bpf_tcp_ca_kfunc_ids)
+
+static bool bpf_tcp_ca_check_kfunc_call(u32 kfunc_btf_id)
+{
+	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
+}
+
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops =3D {
 	.get_func_proto		=3D bpf_tcp_ca_get_func_proto,
 	.is_valid_access	=3D bpf_tcp_ca_is_valid_access,
 	.btf_struct_access	=3D bpf_tcp_ca_btf_struct_access,
+	.check_kfunc_call	=3D bpf_tcp_ca_check_kfunc_call,
 };
=20
 static int bpf_tcp_ca_init_member(const struct btf_type *t,
--=20
2.30.2

