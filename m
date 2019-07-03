Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5BC5E85E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfGCQFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:05:50 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726430AbfGCQFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:05:49 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63G5etJ023935
        for <netdev@vger.kernel.org>; Wed, 3 Jul 2019 12:05:48 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tgxvq9qxb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 12:05:44 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Wed, 3 Jul 2019 17:03:54 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 3 Jul 2019 17:03:51 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x63G3ouq41353382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Jul 2019 16:03:50 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5E76A4062;
        Wed,  3 Jul 2019 16:03:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF662A405F;
        Wed,  3 Jul 2019 16:03:49 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.248])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Jul 2019 16:03:49 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next] selftests/bpf: fix "alu with different scalars 1" on s390
Date:   Wed,  3 Jul 2019 18:03:46 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19070316-0008-0000-0000-000002F97EF2
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070316-0009-0000-0000-00002266CDE6
Message-Id: <20190703160346.63982-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=755 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907030194
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_LDX_MEM is used to load the least significant byte of the retrieved
test_val.index, however, on big-endian machines it ends up retrieving
the most significant byte.

Use the correct least significant byte offset on big-endian machines.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index c3de1a2c9dc5..3b221bb4b317 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -183,7 +183,11 @@
 	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
 	BPF_EXIT_INSN(),
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
 	BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
+#else
+	BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, sizeof(int) - 1),
+#endif
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 3),
 	BPF_MOV64_IMM(BPF_REG_2, 0),
 	BPF_MOV64_IMM(BPF_REG_3, 0x100000),
-- 
2.21.0

