Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B618BF6B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbfHMRKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:10:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726654AbfHMRKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:10:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DH7I0W115113
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 13:10:48 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2uc0rv1kbg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 13:10:48 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <naveen.n.rao@linux.vnet.ibm.com>;
        Tue, 13 Aug 2019 18:10:46 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 13 Aug 2019 18:10:41 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7DHAeM240304730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Aug 2019 17:10:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C435A404D;
        Tue, 13 Aug 2019 17:10:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9251FA405B;
        Tue, 13 Aug 2019 17:10:38 +0000 (GMT)
Received: from naverao1-tp.ibmuc.com (unknown [9.85.107.69])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Aug 2019 17:10:38 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, <bpf@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] bpf: handle 32-bit zext during constant blinding
Date:   Tue, 13 Aug 2019 22:40:18 +0530
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19081317-4275-0000-0000-000003589A30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19081317-4276-0000-0000-0000386AAAB6
Message-Id: <20190813171018.28221-1-naveen.n.rao@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=821 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130164
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since BPF constant blinding is performed after the verifier pass, there
are certain ALU32 instructions inserted which don't have a corresponding
zext instruction inserted after. This is causing a kernel oops on
powerpc and can be reproduced by running 'test_cgroup_storage' with
bpf_jit_harden=2.

Fix this by emitting BPF_ZEXT during constant blinding if
prog->aux->verifier_zext is set.

Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
This approach (the location where zext is being introduced below, in 
particular) works for powerpc, but I am not entirely sure if this is 
sufficient for other architectures as well. This is broken on v5.3-rc4.

- Naveen


 kernel/bpf/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 8191a7db2777..d84146e6fd9e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -890,7 +890,8 @@ int bpf_jit_get_func_addr(const struct bpf_prog *prog,
 
 static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			      const struct bpf_insn *aux,
-			      struct bpf_insn *to_buff)
+			      struct bpf_insn *to_buff,
+			      bool emit_zext)
 {
 	struct bpf_insn *to = to_buff;
 	u32 imm_rnd = get_random_int();
@@ -939,6 +940,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
 		*to++ = BPF_ALU32_REG(from->code, from->dst_reg, BPF_REG_AX);
+		if (emit_zext)
+			*to++ = BPF_ZEXT_REG(from->dst_reg);
 		break;
 
 	case BPF_ALU64 | BPF_ADD | BPF_K:
@@ -992,6 +995,10 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 			off -= 2;
 		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ from->imm);
 		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
+		if (emit_zext) {
+			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
+			off--;
+		}
 		*to++ = BPF_JMP32_REG(from->code, from->dst_reg, BPF_REG_AX,
 				      off);
 		break;
@@ -1005,6 +1012,8 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	case 0: /* Part 2 of BPF_LD | BPF_IMM | BPF_DW. */
 		*to++ = BPF_ALU32_IMM(BPF_MOV, BPF_REG_AX, imm_rnd ^ aux[0].imm);
 		*to++ = BPF_ALU32_IMM(BPF_XOR, BPF_REG_AX, imm_rnd);
+		if (emit_zext)
+			*to++ = BPF_ZEXT_REG(BPF_REG_AX);
 		*to++ = BPF_ALU64_REG(BPF_OR,  aux[0].dst_reg, BPF_REG_AX);
 		break;
 
@@ -1088,7 +1097,8 @@ struct bpf_prog *bpf_jit_blind_constants(struct bpf_prog *prog)
 		    insn[1].code == 0)
 			memcpy(aux, insn, sizeof(aux));
 
-		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff);
+		rewritten = bpf_jit_blind_insn(insn, aux, insn_buff,
+						clone->aux->verifier_zext);
 		if (!rewritten)
 			continue;
 
-- 
2.22.0

