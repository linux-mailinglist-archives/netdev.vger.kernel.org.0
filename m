Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E11D101945
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfKSGWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 01:22:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61218 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726637AbfKSGWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 01:22:00 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAJ69h5k013413
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:21:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=F+7fIxEhnpTfrOrqIZxn/IyNrmwgQqo6D1Zt5/GRS/k=;
 b=p3Pzax4unieaIAburwav3i1w8CRq5z6SH/48df2B0X+XZAA7lB+v0FqhBM40eIRiaWJ/
 RT3K8VCELO1ZqfoZ6xgtfNdJ/PGDaVQ0ImsILK3PkUOFS3kFtdxiWhXiYJj6KTFd5BfL
 uZiDmLjy5ovIAQKwDcrue3ElxR0cYUEVyyE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2wc6jq0u8x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:21:58 -0800
Received: from 2401:db00:2120:80d4:face:0:39:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Mon, 18 Nov 2019 22:21:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 308BA2EC1846; Mon, 18 Nov 2019 22:21:53 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix call relocation offset calculation bug
Date:   Mon, 18 Nov 2019 22:21:51 -0800
Message-ID: <20191119062151.777260-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_01:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 phishscore=0 suspectscore=8
 impostorscore=0 mlxscore=0 clxscore=1015 mlxlogscore=823 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911190057
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When relocating subprogram call, libbpf doesn't take into account
relo->text_off, which comes from symbol's value. This generally works fine for
subprograms implemented as static functions, but breaks for global functions.

Taking a simplified test_pkt_access.c as an example:

__attribute__ ((noinline))
static int test_pkt_access_subprog1(volatile struct __sk_buff *skb)
{
        return skb->len * 2;
}

__attribute__ ((noinline))
static int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
{
        return skb->len + val;
}

SEC("classifier/test_pkt_access")
int test_pkt_access(struct __sk_buff *skb)
{
        if (test_pkt_access_subprog1(skb) != skb->len * 2)
                return TC_ACT_SHOT;
        if (test_pkt_access_subprog2(2, skb) != skb->len + 2)
                return TC_ACT_SHOT;
        return TC_ACT_UNSPEC;
}

When compiled, we get two relocations, pointing to '.text' symbol. .text has
st_value set to 0 (it points to the beginning of .text section):

0000000000000008  000000050000000a R_BPF_64_32            0000000000000000 .text
0000000000000040  000000050000000a R_BPF_64_32            0000000000000000 .text

test_pkt_access_subprog1 and test_pkt_access_subprog2 offsets (targets of two
calls) are encoded within call instruction's imm32 part as -1 and 2,
respectively:

0000000000000000 test_pkt_access_subprog1:
       0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       1:       64 00 00 00 01 00 00 00 w0 <<= 1
       2:       95 00 00 00 00 00 00 00 exit

0000000000000018 test_pkt_access_subprog2:
       3:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       4:       04 00 00 00 02 00 00 00 w0 += 2
       5:       95 00 00 00 00 00 00 00 exit

0000000000000000 test_pkt_access:
       0:       bf 16 00 00 00 00 00 00 r6 = r1
===>   1:       85 10 00 00 ff ff ff ff call -1
       2:       bc 01 00 00 00 00 00 00 w1 = w0
       3:       b4 00 00 00 02 00 00 00 w0 = 2
       4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
       5:       64 02 00 00 01 00 00 00 w2 <<= 1
       6:       5e 21 08 00 00 00 00 00 if w1 != w2 goto +8 <LBB0_3>
       7:       bf 61 00 00 00 00 00 00 r1 = r6
===>   8:       85 10 00 00 02 00 00 00 call 2
       9:       bc 01 00 00 00 00 00 00 w1 = w0
      10:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
      11:       04 02 00 00 02 00 00 00 w2 += 2
      12:       b4 00 00 00 ff ff ff ff w0 = -1
      13:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB0_3>
      14:       b4 00 00 00 02 00 00 00 w0 = 2
0000000000000078 LBB0_3:
      15:       95 00 00 00 00 00 00 00 exit

Now, if we compile example with global functions, the setup changes.
Relocations are now against specifically test_pkt_access_subprog1 and
test_pkt_access_subprog2 symbols, with test_pkt_access_subprog2 pointing 24
bytes into its respective section (.text), i.e., 3 instructions in:

0000000000000008  000000070000000a R_BPF_64_32            0000000000000000 test_pkt_access_subprog1
0000000000000048  000000080000000a R_BPF_64_32            0000000000000018 test_pkt_access_subprog2

Calls instructions now encode offsets relative to function symbols and are both
set ot -1:

0000000000000000 test_pkt_access_subprog1:
       0:       61 10 00 00 00 00 00 00 r0 = *(u32 *)(r1 + 0)
       1:       64 00 00 00 01 00 00 00 w0 <<= 1
       2:       95 00 00 00 00 00 00 00 exit

0000000000000018 test_pkt_access_subprog2:
       3:       61 20 00 00 00 00 00 00 r0 = *(u32 *)(r2 + 0)
       4:       0c 10 00 00 00 00 00 00 w0 += w1
       5:       95 00 00 00 00 00 00 00 exit

0000000000000000 test_pkt_access:
       0:       bf 16 00 00 00 00 00 00 r6 = r1
===>   1:       85 10 00 00 ff ff ff ff call -1
       2:       bc 01 00 00 00 00 00 00 w1 = w0
       3:       b4 00 00 00 02 00 00 00 w0 = 2
       4:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
       5:       64 02 00 00 01 00 00 00 w2 <<= 1
       6:       5e 21 09 00 00 00 00 00 if w1 != w2 goto +9 <LBB2_3>
       7:       b4 01 00 00 02 00 00 00 w1 = 2
       8:       bf 62 00 00 00 00 00 00 r2 = r6
===>   9:       85 10 00 00 ff ff ff ff call -1
      10:       bc 01 00 00 00 00 00 00 w1 = w0
      11:       61 62 00 00 00 00 00 00 r2 = *(u32 *)(r6 + 0)
      12:       04 02 00 00 02 00 00 00 w2 += 2
      13:       b4 00 00 00 ff ff ff ff w0 = -1
      14:       1e 21 01 00 00 00 00 00 if w1 == w2 goto +1 <LBB2_3>
      15:       b4 00 00 00 02 00 00 00 w0 = 2
0000000000000080 LBB2_3:
      16:       95 00 00 00 00 00 00 00 exit

Thus the right formula to calculate target call offset after relocation should
take into account relocation's target symbol value (offset within section),
call instruction's imm32 offset, and (subtracting, to get relative instruction
offset) instruction index of call instruction itself. All that is shifted by
number of instructions in main program, given all sub-programs are copied over
after main program.

Convert test_pkt_access.c to global functions to verify this works.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                              | 8 ++++++--
 tools/testing/selftests/bpf/progs/test_pkt_access.c | 8 ++++----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 15e91a1d6c11..a7d183f7ac72 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1870,9 +1870,13 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 				pr_warn("incorrect bpf_call opcode\n");
 				return -LIBBPF_ERRNO__RELOC;
 			}
+			if (sym.st_value % 8) {
+				pr_warn("bad call relo offset: %lu\n", sym.st_value);
+				return -LIBBPF_ERRNO__RELOC;
+			}
 			prog->reloc_desc[i].type = RELO_CALL;
 			prog->reloc_desc[i].insn_idx = insn_idx;
-			prog->reloc_desc[i].text_off = sym.st_value;
+			prog->reloc_desc[i].text_off = sym.st_value / 8;
 			obj->has_pseudo_calls = true;
 			continue;
 		}
@@ -3573,7 +3577,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 			 prog->section_name);
 	}
 	insn = &prog->insns[relo->insn_idx];
-	insn->imm += prog->main_prog_cnt - relo->insn_idx;
+	insn->imm += relo->text_off + prog->main_prog_cnt - relo->insn_idx;
 	return 0;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/testing/selftests/bpf/progs/test_pkt_access.c
index 3a7b4b607ed3..dd0d2dfe55d8 100644
--- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
+++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
@@ -35,14 +35,14 @@ int _version SEC("version") = 1;
  *
  * Which makes it an interesting test for BTF-enabled verifier.
  */
-static __attribute__ ((noinline))
-int test_pkt_access_subprog1(volatile struct __sk_buff *skb)
+__attribute__ ((noinline))
+int test_pkt_access_subprog1(struct __sk_buff *skb)
 {
 	return skb->len * 2;
 }
 
-static __attribute__ ((noinline))
-int test_pkt_access_subprog2(int val, volatile struct __sk_buff *skb)
+__attribute__ ((noinline))
+int test_pkt_access_subprog2(int val, struct __sk_buff *skb)
 {
 	return skb->len * val;
 }
-- 
2.17.1

