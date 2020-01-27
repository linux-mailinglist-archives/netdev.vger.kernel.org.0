Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B78914A941
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 18:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgA0Rvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 12:51:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgA0Rvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 12:51:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RHolKg009442
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:51:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=qROix2s9Ti53ZGEPOA9CO6nXYZ7L6BmhcxXnJW5YfcQ=;
 b=Mnif3EAgw8OEMmVkp8WRVf/uP2011vvwMzaodKySnizMI1Xxichi9vvoJBsbCbjIUqTl
 XVSXeL7DQ2rVD+sFKHfzvAB9iD56K3B4eRFkvRQ10e2AY5brEVIHQGjjaLTf2lE8Anom
 /8v4HbB8WwRZhjTebD5CBsmIaOGT/Ob89HM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xs6qme9ya-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 09:51:48 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 27 Jan 2020 09:51:46 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C84F52942041; Mon, 27 Jan 2020 09:51:45 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: Reuse log from btf_prase_vmlinux() in btf_struct_ops_init()
Date:   Mon, 27 Jan 2020 09:51:45 -0800
Message-ID: <20200127175145.1154438-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_06:2020-01-24,2020-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=583 impostorscore=0 priorityscore=1501 adultscore=0
 spamscore=0 phishscore=0 suspectscore=38 mlxscore=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2001270145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using a locally defined "struct bpf_verifier_log log = {}",
btf_struct_ops_init() should reuse the "log" from its calling
function "btf_parse_vmlinux()".  It should also resolve the
frame-size too large compiler warning in some ARCH.

Fixes: 27ae7997a661 ("bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/bpf.h         | 7 +++++--
 kernel/bpf/bpf_struct_ops.c | 5 ++---
 kernel/bpf/btf.c            | 2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e9ad3943cd9..49b1a70e12c8 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -728,7 +728,7 @@ struct bpf_struct_ops {
 #if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL)
 #define BPF_MODULE_OWNER ((void *)((0xeB9FUL << 2) + POISON_POINTER_DELTA))
 const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id);
-void bpf_struct_ops_init(struct btf *btf);
+void bpf_struct_ops_init(struct btf *btf, struct bpf_verifier_log *log);
 bool bpf_struct_ops_get(const void *kdata);
 void bpf_struct_ops_put(const void *kdata);
 int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
@@ -752,7 +752,10 @@ static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
 	return NULL;
 }
-static inline void bpf_struct_ops_init(struct btf *btf) { }
+static inline void bpf_struct_ops_init(struct btf *btf,
+				       struct bpf_verifier_log *log)
+{
+}
 static inline bool bpf_try_module_get(const void *data, struct module *owner)
 {
 	return try_module_get(owner);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 8ad1c9ea26b2..042f95534f86 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -96,12 +96,11 @@ const struct bpf_prog_ops bpf_struct_ops_prog_ops = {
 
 static const struct btf_type *module_type;
 
-void bpf_struct_ops_init(struct btf *btf)
+void bpf_struct_ops_init(struct btf *btf, struct bpf_verifier_log *log)
 {
 	s32 type_id, value_id, module_id;
 	const struct btf_member *member;
 	struct bpf_struct_ops *st_ops;
-	struct bpf_verifier_log log = {};
 	const struct btf_type *t;
 	char value_name[128];
 	const char *mname;
@@ -172,7 +171,7 @@ void bpf_struct_ops_init(struct btf *btf)
 							       member->type,
 							       NULL);
 			if (func_proto &&
-			    btf_distill_func_proto(&log, btf,
+			    btf_distill_func_proto(log, btf,
 						   func_proto, mname,
 						   &st_ops->func_models[j])) {
 				pr_warn("Error in parsing func ptr %s in struct %s\n",
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b7c1660fb594..8c9d8f266bef 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3643,7 +3643,7 @@ struct btf *btf_parse_vmlinux(void)
 		goto errout;
 	}
 
-	bpf_struct_ops_init(btf);
+	bpf_struct_ops_init(btf, log);
 
 	btf_verifier_env_free(env);
 	refcount_set(&btf->refcnt, 1);
-- 
2.17.1

