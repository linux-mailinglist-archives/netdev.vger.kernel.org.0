Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE24D2F294D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392110AbhALH4J convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jan 2021 02:56:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54974 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731058AbhALH4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:56:09 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C7jo5e007937
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:28 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35ywme9a3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:28 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 23:55:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AF9152ECD646; Mon, 11 Jan 2021 23:55:25 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, kernel test robot <lkp@intel.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 1/7] bpf: add bpf_patch_call_args prototype to include/linux/bpf.h
Date:   Mon, 11 Jan 2021 23:55:14 -0800
Message-ID: <20210112075520.4103414-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210112075520.4103414-1-andrii@kernel.org>
References: <20210112075520.4103414-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1034 impostorscore=0 bulkscore=0 mlxlogscore=761
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_patch_call_args() prototype. This function is called from BPF verifier
and only if CONFIG_BPF_JIT_ALWAYS_ON is not defined. This fixes compiler
warning about missing prototype in some kernel configurations.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/bpf.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 07cb5d15e743..ef9309604b3e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1403,7 +1403,10 @@ static inline void bpf_long_memcpy(void *dst, const void *src, u32 size)
 /* verify correctness of eBPF program */
 int bpf_check(struct bpf_prog **fp, union bpf_attr *attr,
 	      union bpf_attr __user *uattr);
+
+#ifndef CONFIG_BPF_JIT_ALWAYS_ON
 void bpf_patch_call_args(struct bpf_insn *insn, u32 stack_depth);
+#endif
 
 struct btf *bpf_get_btf_vmlinux(void);
 
-- 
2.24.1

