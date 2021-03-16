Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6FF33CAA8
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 02:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbhCPBO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 21:14:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52768 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234167AbhCPBOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 21:14:25 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G19kr3021514
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0Kx5OB279JUPfG0XhqfvNUjSnBkCzSNDIwedcdzf8o4=;
 b=BZvbWejXeJlcp+IIsDI0bVN8GVXeXjCm533BWQTWOqKRYfxU5kl2oB4qGMwRx0Rja/VU
 Fk3KNf/AGWFzpxq1lGwkol8PSq09gXpDZokL9XaVpml1KwjBYnXLUxvC5PPPd+a5+1A5
 1iI2zymdYDxtMI+ZAU2y5jHbxba6gTTW3Hs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 378usu3r7s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 18:14:24 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 15 Mar 2021 18:14:22 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 1C45A2942B57; Mon, 15 Mar 2021 18:14:20 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 07/15] bpf: tcp: White list some tcp cong functions to be called by bpf-tcp-cc
Date:   Mon, 15 Mar 2021 18:14:20 -0700
Message-ID: <20210316011420.4177709-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316011336.4173585-1-kafai@fb.com>
References: <20210316011336.4173585-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-15_15:2021-03-15,2021-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch white list some tcp cong helper functions, tcp_slow_start()
and tcp_cong_avoid_ai().  They are allowed to be directly called by
the bpf-tcp-cc program.

A few tcp cc implementation functions are also white listed.
A potential use case is the bpf-tcp-cc implementation may only
want to override a subset of a tcp_congestion_ops.  For others,
the bpf-tcp-cc can directly call the kernel counter parts instead of
re-implementing (or copy-and-pasting) them to the bpf program.

They will only be available to the bpf-tcp-cc typed program.
The white listed functions are not bounded to a fixed ABI contract.
When any of them has changed, the bpf-tcp-cc program has to be changed
like any in-tree/out-of-tree kernel tcp-cc implementations do also.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/bpf_tcp_ca.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index d520e61649c8..ed6e6b5b762b 100644
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
+static bool bpf_tcp_ca_check_kern_func_call(u32 kfunc_btf_id)
+{
+	return btf_id_set_contains(&bpf_tcp_ca_kfunc_ids, kfunc_btf_id);
+}
+
 static const struct bpf_verifier_ops bpf_tcp_ca_verifier_ops =3D {
 	.get_func_proto		=3D bpf_tcp_ca_get_func_proto,
 	.is_valid_access	=3D bpf_tcp_ca_is_valid_access,
 	.btf_struct_access	=3D bpf_tcp_ca_btf_struct_access,
+	.check_kern_func_call	=3D bpf_tcp_ca_check_kern_func_call,
 };
=20
 static int bpf_tcp_ca_init_member(const struct btf_type *t,
--=20
2.30.2

