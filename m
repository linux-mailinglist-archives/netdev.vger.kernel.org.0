Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F462EFADC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 23:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAHWKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 8 Jan 2021 17:10:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725844AbhAHWKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 17:10:21 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 108M92FV019973
        for <netdev@vger.kernel.org>; Fri, 8 Jan 2021 14:09:40 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 35x79rpt95-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 14:09:40 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 8 Jan 2021 14:09:37 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8695F2ECD237; Fri,  8 Jan 2021 14:09:35 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 bpf-next 2/7] bpf: avoid warning when re-casting __bpf_call_base into __bpf_call_base_args
Date:   Fri, 8 Jan 2021 14:09:25 -0800
Message-ID: <20210108220930.482456-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210108220930.482456-1-andrii@kernel.org>
References: <20210108220930.482456-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-08_11:2021-01-07,2021-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=749 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101080113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF interpreter uses extra input argument, so re-casts __bpf_call_base into
__bpf_call_base_args. Avoid compiler warning about incompatible function
prototypes by casting to void * first.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 include/linux/filter.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 29c27656165b..5edf2b660881 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -886,7 +886,7 @@ void sk_filter_uncharge(struct sock *sk, struct sk_filter *fp);
 u64 __bpf_call_base(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 #define __bpf_call_base_args \
 	((u64 (*)(u64, u64, u64, u64, u64, const struct bpf_insn *)) \
-	 __bpf_call_base)
+	 (void *)__bpf_call_base)
 
 struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog);
 void bpf_jit_compile(struct bpf_prog *prog);
-- 
2.24.1

