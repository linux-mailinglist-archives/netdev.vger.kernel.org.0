Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14002D6DB7
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 02:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbgLKBqQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Dec 2020 20:46:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29166 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390028AbgLKBpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:45:43 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BB1dJMJ001064
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:45:01 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ak7agb8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 17:45:01 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 17:45:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 786352ECB17F; Thu, 10 Dec 2020 17:44:54 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf] bpf: fix enum names for bpf_this_cpu_ptr() and bpf_per_cpu_ptr() helpers
Date:   Thu, 10 Dec 2020 17:44:53 -0800
Message-ID: <20201211014453.3889762-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_11:2020-12-09,2020-12-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 mlxscore=0 suspectscore=8 spamscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxlogscore=877
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012110009
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove bpf_ prefix, which causes these helpers to be reported in verifier dump
as bpf_bpf_this_cpu_ptr() and bpf_bpf_per_cpu_ptr(), respectively.

Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/uapi/linux/bpf.h       | 4 ++--
 kernel/bpf/helpers.c           | 4 ++--
 kernel/trace/bpf_trace.c       | 4 ++--
 tools/include/uapi/linux/bpf.h | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e6ceac3f7d62..556216dc9703 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3897,8 +3897,8 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
-	FN(bpf_per_cpu_ptr),            \
-	FN(bpf_this_cpu_ptr),		\
+	FN(per_cpu_ptr),		\
+	FN(this_cpu_ptr),		\
 	FN(redirect_peer),		\
 	/* */
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 25520f5eeaf6..deda1185237b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -717,9 +717,9 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
-	case BPF_FUNC_bpf_per_cpu_ptr:
+	case BPF_FUNC_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
-	case BPF_FUNC_bpf_this_cpu_ptr:
+	case BPF_FUNC_this_cpu_ptr:
 		return &bpf_this_cpu_ptr_proto;
 	default:
 		break;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 048c655315f1..a125ea5e04cd 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1337,9 +1337,9 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return prog->aux->sleepable ? &bpf_copy_from_user_proto : NULL;
 	case BPF_FUNC_snprintf_btf:
 		return &bpf_snprintf_btf_proto;
-	case BPF_FUNC_bpf_per_cpu_ptr:
+	case BPF_FUNC_per_cpu_ptr:
 		return &bpf_per_cpu_ptr_proto;
-	case BPF_FUNC_bpf_this_cpu_ptr:
+	case BPF_FUNC_this_cpu_ptr:
 		return &bpf_this_cpu_ptr_proto;
 	default:
 		return NULL;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e6ceac3f7d62..556216dc9703 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3897,8 +3897,8 @@ union bpf_attr {
 	FN(seq_printf_btf),		\
 	FN(skb_cgroup_classid),		\
 	FN(redirect_neigh),		\
-	FN(bpf_per_cpu_ptr),            \
-	FN(bpf_this_cpu_ptr),		\
+	FN(per_cpu_ptr),		\
+	FN(this_cpu_ptr),		\
 	FN(redirect_peer),		\
 	/* */
 
-- 
2.24.1

