Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76E62F2951
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392164AbhALH4Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jan 2021 02:56:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392152AbhALH4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:56:16 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C7tXef023095
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:35 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1phdhu-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:35 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 23:55:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D62F42ECD646; Mon, 11 Jan 2021 23:55:27 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, kernel test robot <lkp@intel.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 2/7] bpf: avoid warning when re-casting __bpf_call_base into __bpf_call_base_args
Date:   Mon, 11 Jan 2021 23:55:15 -0800
Message-ID: <20210112075520.4103414-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210112075520.4103414-1-andrii@kernel.org>
References: <20210112075520.4103414-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1034 suspectscore=0 mlxlogscore=762 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF interpreter uses extra input argument, so re-casts __bpf_call_base into
__bpf_call_base_args. Avoid compiler warning about incompatible function
prototypes by casting to void * first.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 1ea47e01ad6e ("bpf: add support for bpf_call to interpreter")
Acked-by: Yonghong Song <yhs@fb.com>
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

