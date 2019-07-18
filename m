Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE4ED6CB97
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 11:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbfGRJOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 05:14:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726383AbfGRJOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 05:14:03 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6I980Pr087775
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 05:14:02 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ttnc21bxu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 05:14:01 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 18 Jul 2019 10:13:43 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Jul 2019 10:13:42 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6I9DeZ950790514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 09:13:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADCBE4C04E;
        Thu, 18 Jul 2019 09:13:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 718414C050;
        Thu, 18 Jul 2019 09:13:40 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.99.77])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jul 2019 09:13:40 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf] selftests/bpf: fix "valid read map access into a read-only array 1" on s390
Date:   Thu, 18 Jul 2019 11:13:35 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071809-0020-0000-0000-00000354FB9A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071809-0021-0000-0000-000021A8D23A
Message-Id: <20190718091335.73695-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=743 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180104
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test looks up a 32-bit map element and then loads it using a 64-bit
load. This does not work on s390, which is a big-endian machine.

Since the point of this test doesn't seem to be loading a smaller value
using a larger load, simply use a 32-bit load.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index bcb83196e459..f3c33e128709 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -226,7 +226,7 @@
 	BPF_LD_MAP_FD(BPF_REG_1, 0),
 	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
 	BPF_JMP_IMM(BPF_JEQ, BPF_REG_0, 0, 1),
-	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_0, 0),
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_array_ro = { 3 },
-- 
2.21.0

