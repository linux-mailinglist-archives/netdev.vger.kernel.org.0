Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F44369D7F
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbhDWXig convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 19:38:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49506 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244221AbhDWXhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:37:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NNU5Dn009458
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:23 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3845w5gqxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:23 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:36:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id ADD322ED5CF6; Fri, 23 Apr 2021 16:36:15 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 3/5] selftests/bpf: fix BPF_CORE_READ_BITFIELD() macro
Date:   Fri, 23 Apr 2021 16:30:56 -0700
Message-ID: <20210423233058.3386115-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423233058.3386115-1-andrii@kernel.org>
References: <20210423233058.3386115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: hbCa_L9_g4nHesPro7Mz0YfWMai3CmOq
X-Proofpoint-GUID: hbCa_L9_g4nHesPro7Mz0YfWMai3CmOq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 phishscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230158
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix BPF_CORE_READ_BITFIELD() macro used for reading CO-RE-relocatable
bitfields. Missing breaks in a switch caused 8-byte reads always. This can
confuse libbpf because it does strict checks that memory load size corresponds
to the original size of the field, which in this case quite often would be
wrong.

After fixing that, we run into another problem, which quite subtle, so worth
documenting here. The issue is in Clang optimization and CO-RE relocation
interactions. Without that asm volatile construct (also known as
barrier_var()), Clang will re-order BYTE_OFFSET and BYTE_SIZE relocations and
will apply BYTE_OFFSET 4 times for each switch case arm. This will result in
the same error from libbpf about mismatch of memory load size and original
field size. I.e., if we were reading u32, we'd still have *(u8 *), *(u16 *),
*(u32 *), and *(u64 *) memory loads, three of which will fail. Using
barrier_var() forces Clang to apply BYTE_OFFSET relocation first (and once) to
calculate p, after which value of p is used without relocation in each of
switch case arms, doing appropiately-sized memory load.

Here's the list of relevant relocations and pieces of generated BPF code
before and after this patch for test_core_reloc_bitfields_direct selftests.

BEFORE
=====
 #45: core_reloc: insn #160 --> [5] + 0:5: byte_sz --> struct core_reloc_bitfields.u32
 #46: core_reloc: insn #167 --> [5] + 0:5: byte_off --> struct core_reloc_bitfields.u32
 #47: core_reloc: insn #174 --> [5] + 0:5: byte_off --> struct core_reloc_bitfields.u32
 #48: core_reloc: insn #178 --> [5] + 0:5: byte_off --> struct core_reloc_bitfields.u32
 #49: core_reloc: insn #182 --> [5] + 0:5: byte_off --> struct core_reloc_bitfields.u32

     157:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r2 = 0 ll
     159:       7b 12 20 01 00 00 00 00 *(u64 *)(r2 + 288) = r1
     160:       b7 02 00 00 04 00 00 00 r2 = 4
; BYTE_SIZE relocation here                 ^^^
     161:       66 02 07 00 03 00 00 00 if w2 s> 3 goto +7 <LBB0_63>
     162:       16 02 0d 00 01 00 00 00 if w2 == 1 goto +13 <LBB0_65>
     163:       16 02 01 00 02 00 00 00 if w2 == 2 goto +1 <LBB0_66>
     164:       05 00 12 00 00 00 00 00 goto +18 <LBB0_69>

0000000000000528 <LBB0_66>:
     165:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
     167:       69 11 08 00 00 00 00 00 r1 = *(u16 *)(r1 + 8)
; BYTE_OFFSET relo here w/ WRONG size        ^^^^^^^^^^^^^^^^
     168:       05 00 0e 00 00 00 00 00 goto +14 <LBB0_69>

0000000000000548 <LBB0_63>:
     169:       16 02 0a 00 04 00 00 00 if w2 == 4 goto +10 <LBB0_67>
     170:       16 02 01 00 08 00 00 00 if w2 == 8 goto +1 <LBB0_68>
     171:       05 00 0b 00 00 00 00 00 goto +11 <LBB0_69>

0000000000000560 <LBB0_68>:
     172:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
     174:       79 11 08 00 00 00 00 00 r1 = *(u64 *)(r1 + 8)
; BYTE_OFFSET relo here w/ WRONG size        ^^^^^^^^^^^^^^^^
     175:       05 00 07 00 00 00 00 00 goto +7 <LBB0_69>

0000000000000580 <LBB0_65>:
     176:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
     178:       71 11 08 00 00 00 00 00 r1 = *(u8 *)(r1 + 8)
; BYTE_OFFSET relo here w/ WRONG size        ^^^^^^^^^^^^^^^^
     179:       05 00 03 00 00 00 00 00 goto +3 <LBB0_69>

00000000000005a0 <LBB0_67>:
     180:       18 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r1 = 0 ll
     182:       61 11 08 00 00 00 00 00 r1 = *(u32 *)(r1 + 8)
; BYTE_OFFSET relo here w/ RIGHT size        ^^^^^^^^^^^^^^^^

00000000000005b8 <LBB0_69>:
     183:       67 01 00 00 20 00 00 00 r1 <<= 32
     184:       b7 02 00 00 00 00 00 00 r2 = 0
     185:       16 02 02 00 00 00 00 00 if w2 == 0 goto +2 <LBB0_71>
     186:       c7 01 00 00 20 00 00 00 r1 s>>= 32
     187:       05 00 01 00 00 00 00 00 goto +1 <LBB0_72>

00000000000005e0 <LBB0_71>:
     188:       77 01 00 00 20 00 00 00 r1 >>= 32

AFTER
=====

 #30: core_reloc: insn #132 --> [5] + 0:5: byte_off --> struct core_reloc_bitfields.u32
 #31: core_reloc: insn #134 --> [5] + 0:5: byte_sz --> struct core_reloc_bitfields.u32

     129:       18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 r2 = 0 ll
     131:       7b 12 20 01 00 00 00 00 *(u64 *)(r2 + 288) = r1
     132:       b7 01 00 00 08 00 00 00 r1 = 8
; BYTE_OFFSET relo here                     ^^^
; no size check for non-memory dereferencing instructions
     133:       0f 12 00 00 00 00 00 00 r2 += r1
     134:       b7 03 00 00 04 00 00 00 r3 = 4
; BYTE_SIZE relocation here                 ^^^
     135:       66 03 05 00 03 00 00 00 if w3 s> 3 goto +5 <LBB0_63>
     136:       16 03 09 00 01 00 00 00 if w3 == 1 goto +9 <LBB0_65>
     137:       16 03 01 00 02 00 00 00 if w3 == 2 goto +1 <LBB0_66>
     138:       05 00 0a 00 00 00 00 00 goto +10 <LBB0_69>

0000000000000458 <LBB0_66>:
     139:       69 21 00 00 00 00 00 00 r1 = *(u16 *)(r2 + 0)
; NO CO-RE relocation here                   ^^^^^^^^^^^^^^^^
     140:       05 00 08 00 00 00 00 00 goto +8 <LBB0_69>

0000000000000468 <LBB0_63>:
     141:       16 03 06 00 04 00 00 00 if w3 == 4 goto +6 <LBB0_67>
     142:       16 03 01 00 08 00 00 00 if w3 == 8 goto +1 <LBB0_68>
     143:       05 00 05 00 00 00 00 00 goto +5 <LBB0_69>

0000000000000480 <LBB0_68>:
     144:       79 21 00 00 00 00 00 00 r1 = *(u64 *)(r2 + 0)
; NO CO-RE relocation here                   ^^^^^^^^^^^^^^^^
     145:       05 00 03 00 00 00 00 00 goto +3 <LBB0_69>

0000000000000490 <LBB0_65>:
     146:       71 21 00 00 00 00 00 00 r1 = *(u8 *)(r2 + 0)
; NO CO-RE relocation here                   ^^^^^^^^^^^^^^^^
     147:       05 00 01 00 00 00 00 00 goto +1 <LBB0_69>

00000000000004a0 <LBB0_67>:
     148:       61 21 00 00 00 00 00 00 r1 = *(u32 *)(r2 + 0)
; NO CO-RE relocation here                   ^^^^^^^^^^^^^^^^

00000000000004a8 <LBB0_69>:
     149:       67 01 00 00 20 00 00 00 r1 <<= 32
     150:       b7 02 00 00 00 00 00 00 r2 = 0
     151:       16 02 02 00 00 00 00 00 if w2 == 0 goto +2 <LBB0_71>
     152:       c7 01 00 00 20 00 00 00 r1 s>>= 32
     153:       05 00 01 00 00 00 00 00 goto +1 <LBB0_72>

00000000000004d0 <LBB0_71>:
     154:       77 01 00 00 20 00 00 00 r1 >>= 323

Fixes: ee26dade0e3b ("libbpf: Add support for relocatable bitfields")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index 53b3e199fb25..09ebe3db5f2f 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -88,11 +88,19 @@ enum bpf_enum_value_kind {
 	const void *p = (const void *)s + __CORE_RELO(s, field, BYTE_OFFSET); \
 	unsigned long long val;						      \
 									      \
+	/* This is a so-called barrier_var() operation that makes specified   \
+	 * variable "a black box" for optimizing compiler.		      \
+	 * It forces compiler to perform BYTE_OFFSET relocation on p and use  \
+	 * its calculated value in the switch below, instead of applying      \
+	 * the same relocation 4 times for each individual memory load.       \
+	 */								      \
+	asm volatile("" : "=r"(p) : "0"(p));				      \
+									      \
 	switch (__CORE_RELO(s, field, BYTE_SIZE)) {			      \
-	case 1: val = *(const unsigned char *)p;			      \
-	case 2: val = *(const unsigned short *)p;			      \
-	case 4: val = *(const unsigned int *)p;				      \
-	case 8: val = *(const unsigned long long *)p;			      \
+	case 1: val = *(const unsigned char *)p; break;			      \
+	case 2: val = *(const unsigned short *)p; break;		      \
+	case 4: val = *(const unsigned int *)p; break;			      \
+	case 8: val = *(const unsigned long long *)p; break;		      \
 	}								      \
 	val <<= __CORE_RELO(s, field, LSHIFT_U64);			      \
 	if (__CORE_RELO(s, field, SIGNED))				      \
-- 
2.30.2

