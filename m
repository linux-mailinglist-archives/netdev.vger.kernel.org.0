Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 256376E34A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 11:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfGSJSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 05:18:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725853AbfGSJSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 05:18:54 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6J9HQT4118482
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 05:18:53 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tu9jmunsy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 05:18:52 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <iii@linux.ibm.com>;
        Fri, 19 Jul 2019 10:18:50 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 10:18:47 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6J9IkE560096614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 09:18:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A67AAE05A;
        Fri, 19 Jul 2019 09:18:46 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DEFEAE056;
        Fri, 19 Jul 2019 09:18:46 +0000 (GMT)
Received: from white.boeblingen.de.ibm.com (unknown [9.152.98.35])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jul 2019 09:18:45 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ys114321@gmail.com,
        alexei.starovoitov@gmail.com
Cc:     gor@linux.ibm.com, heiko.carstens@de.ibm.com,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf v3] bpf: fix narrower loads on s390
Date:   Fri, 19 Jul 2019 11:18:15 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071909-0012-0000-0000-00000334562D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071909-0013-0000-0000-0000216DDB0D
Message-Id: <20190719091815.92181-1-iii@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=704 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190107
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

v1 -> v2: extract endianness-dependent code into a separate function
v2 -> v3: rename the function and move it to where it belongs

 include/linux/filter.h | 13 +++++++++++++
 kernel/bpf/verifier.c  |  4 ++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ff65d22cf336..92c6e31fb008 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -24,6 +24,7 @@
 
 #include <net/sch_generic.h>
 
+#include <asm/byteorder.h>
 #include <uapi/linux/filter.h>
 #include <uapi/linux/bpf.h>
 
@@ -747,6 +748,18 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
 	return size <= size_default && (size & (size - 1)) == 0;
 }
 
+static inline u8
+bpf_ctx_narrow_load_shift(u32 off, u32 size, u32 size_default)
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
 #define bpf_ctx_wide_access_ok(off, size, type, field)			\
 	(size == sizeof(__u64) &&					\
 	off >= offsetof(type, field) &&					\
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5900cbb966b1..c84d83f86141 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8616,8 +8616,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 		}
 
 		if (is_narrower_load && size < target_size) {
-			u8 shift = (off & (size_default - 1)) * 8;
-
+			u8 shift = bpf_ctx_narrow_load_shift(off, size,
+							     size_default);
 			if (ctx_field_size <= 4) {
 				if (shift)
 					insn_buf[cnt++] = BPF_ALU32_IMM(BPF_RSH,
-- 
2.21.0

