Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD636D0A3
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 17:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390698AbfGRPBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 11:01:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727848AbfGRPBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 11:01:16 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6IEsoDr022085
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 11:01:14 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tts6hna4c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Jul 2019 11:01:14 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Thu, 18 Jul 2019 16:01:10 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Jul 2019 16:01:07 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6IF16ST62783622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Jul 2019 15:01:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00F6C11C050;
        Thu, 18 Jul 2019 15:01:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C764011C04C;
        Thu, 18 Jul 2019 15:01:05 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.99.77])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Jul 2019 15:01:05 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf v2] bpf: fix narrower loads on s390
Date:   Thu, 18 Jul 2019 17:01:03 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071815-0008-0000-0000-000002FEB53C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071815-0009-0000-0000-0000226C340D
Message-Id: <20190718150103.84837-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-18_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=627 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907180156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The very first check in test_pkt_md_access is failing on s390, which
happens because loading a part of a struct __sk_buff field produces
an incorrect result.

The preprocessed code of the check is:

{
	__u8 tmp = *((volatile __u8 *)&skb->len +
		((sizeof(skb->len) - sizeof(__u8)) / sizeof(__u8)));
	if (tmp != ((*(volatile __u32 *)&skb->len) & 0xFF)) return 2;
};

clang generates the following code for it:

      0:	71 21 00 03 00 00 00 00	r2 = *(u8 *)(r1 + 3)
      1:	61 31 00 00 00 00 00 00	r3 = *(u32 *)(r1 + 0)
      2:	57 30 00 00 00 00 00 ff	r3 &= 255
      3:	5d 23 00 1d 00 00 00 00	if r2 != r3 goto +29 <LBB0_10>

Finally, verifier transforms it to:

  0: (61) r2 = *(u32 *)(r1 +104)
  1: (bc) w2 = w2
  2: (74) w2 >>= 24
  3: (bc) w2 = w2
  4: (54) w2 &= 255
  5: (bc) w2 = w2

The problem is that when verifier emits the code to replace a partial
load of a struct __sk_buff field (*(u8 *)(r1 + 3)) with a full load of
struct sk_buff field (*(u32 *)(r1 + 104)), an optional shift and a
bitwise AND, it assumes that the machine is little endian and
incorrectly decides to use a shift.

Adjust shift count calculation to account for endianness.

Fixes: 31fd85816dbe ("bpf: permits narrower load from bpf program context fields")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 include/linux/filter.h | 13 +++++++++++++
 kernel/bpf/verifier.c  |  4 ++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ff65d22cf336..4fe88e43f0fe 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -24,6 +24,8 @@
 
 #include <net/sch_generic.h>
 
+#include <asm/byteorder.h>
+
 #include <uapi/linux/filter.h>
 #include <uapi/linux/bpf.h>
 
@@ -1216,4 +1218,15 @@ struct bpf_sockopt_kern {
 	s32		retval;
 };
 
+static inline u8 bpf_narrower_load_shift(u32 size_default, u32 size, u32 off)
+{
+	u8 load_off = off & (size_default - 1);
+
+#ifdef __LITTLE_ENDIAN
+	return load_off * 8;
+#else
+	return (size_default - (load_off + size)) * 8;
+#endif
+}
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5900cbb966b1..48edc9c9a879 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8616,8 +8616,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		}
 
 		if (is_narrower_load && size < target_size) {
-			u8 shift = (off & (size_default - 1)) * 8;
-
+			u8 shift = bpf_narrower_load_shift(size_default, size,
+							   off);
 			if (ctx_field_size <= 4) {
 				if (shift)
 					insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
-- 
2.21.0

