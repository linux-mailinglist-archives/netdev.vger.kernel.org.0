Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A806A6D0
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 12:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbfGPKyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 06:54:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733067AbfGPKyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 06:54:05 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GArX6m036604
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 06:54:04 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tscv8rw67-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 06:54:04 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Tue, 16 Jul 2019 11:54:02 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 11:53:58 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GArvxF54722710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 10:53:57 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAEC811C058;
        Tue, 16 Jul 2019 10:53:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9264E11C052;
        Tue, 16 Jul 2019 10:53:56 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.96.205])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 10:53:56 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        ys114321@gmail.com, Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf v3] selftests/bpf: fix "alu with different scalars 1" on s390
Date:   Tue, 16 Jul 2019 12:53:53 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071610-0020-0000-0000-000003540257
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071610-0021-0000-0000-000021A7CE0C
Message-Id: <20190716105353.21704-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=638 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160137
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_LDX_MEM is used to load the least significant byte of the retrieved
test_val.index, however, on big-endian machines it ends up retrieving
the most significant byte.

Change the test to load the whole int in order to make it
endianness-independent.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---

v1->v2:
- use __BYTE_ORDER instead of __BYTE_ORDER__.
v2->v3:
- load the whole int instead of byte.

 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index c3de1a2c9dc5..a53d99cebd9f 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -183,7 +183,7 @@
 	BPF_EMIT_CALL(BPF_FUNC_map_lookup_elem),
 	BPF_JMP_IMM(BPF_JNE, BPF_REG_0, 0, 1),
 	BPF_EXIT_INSN(),
-	BPF_LDX_MEM(BPF_B, BPF_REG_1, BPF_REG_0, 0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_0, 0),
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_1, 0, 3),
 	BPF_MOV64_IMM(BPF_REG_2, 0),
 	BPF_MOV64_IMM(BPF_REG_3, 0x100000),
-- 
2.21.0

