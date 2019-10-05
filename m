Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E63ECC7FF
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 07:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbfJEFDX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 5 Oct 2019 01:03:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49700 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfJEFDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 01:03:22 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x954wSri004099
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 22:03:21 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ved839s9f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 22:03:21 -0700
Received: from 2401:db00:2120:81dc:face:0:23:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 22:03:20 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id E9FD576091D; Fri,  4 Oct 2019 22:03:18 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <x86@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 02/10] bpf: add typecast to bpf helpers to help BTF generation
Date:   Fri, 4 Oct 2019 22:03:06 -0700
Message-ID: <20191005050314.1114330-3-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191005050314.1114330-1-ast@kernel.org>
References: <20191005050314.1114330-1-ast@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-05_02:2019-10-03,2019-10-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=828
 mlxscore=0 impostorscore=0 clxscore=1034 spamscore=0 bulkscore=0
 malwarescore=0 suspectscore=1 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910050044
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When pahole converts dwarf to btf it emits only used types.
Wrap existing bpf helper functions into typedef and use it in
typecast to make gcc emits this type into dwarf.
Then pahole will convert it to btf.
The "btf_#name_of_helper" types will be used to figure out
types of arguments of bpf helpers.
The generate code before and after is the same.
Only dwarf and btf are different.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/filter.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 2ce57645f3cd..d3d51d7aff2c 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -464,10 +464,11 @@ static inline bool insn_is_zext(const struct bpf_insn *insn)
 #define BPF_CALL_x(x, name, ...)					       \
 	static __always_inline						       \
 	u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__));   \
+	typedef u64 (*btf_##name)(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__)); \
 	u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__));	       \
 	u64 name(__BPF_REG(x, __BPF_DECL_REGS, __BPF_N, __VA_ARGS__))	       \
 	{								       \
-		return ____##name(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
+		return ((btf_##name)____##name)(__BPF_MAP(x,__BPF_CAST,__BPF_N,__VA_ARGS__));\
 	}								       \
 	static __always_inline						       \
 	u64 ____##name(__BPF_MAP(x, __BPF_DECL_ARGS, __BPF_V, __VA_ARGS__))
-- 
2.20.0

