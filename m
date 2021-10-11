Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35EE42966A
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhJKSGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:06:47 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51840 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbhJKSGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:06:45 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id B4BFE200DF96;
        Mon, 11 Oct 2021 20:04:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B4BFE200DF96
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633975482;
        bh=6Qd/0FkpBN3/qIEXoRXzg12UVnq1MfpytjuF0pwskBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZCK/IZgmM36hy3ZkTB0NlBh0rUc9iZOixAATehMHj3Q4T0msXPQCHCdUFUVj5HZo
         xhdhzOv3QEqhhdem+NbfpGsp+FAtBSlIJMycoamFSjCfrGxdKA95Vq8gT+T9pvVuo5
         CIYTvzABfTbe1pLJU/RN5xobVbhyxNL3RTMSEWHGHIcMVUdk4Zak2TEwRL0ebJ9poA
         Rq+s5oLkuOD5gzSySLZSzFGaAlGkpT2FHT8IkscLA74uJrgjHoCvgAMCYZVRBv8RxV
         6guZTSP48aV31T37s1lEAowl2Yrmw4EH8XlHWn2W51FIVauRPOndX5dGS27de3h1X9
         OdkO+0fKSZIyw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net 2/2] selftests: net: modify IOAM tests for undef bits
Date:   Mon, 11 Oct 2021 20:04:12 +0200
Message-Id: <20211011180412.22781-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011180412.22781-1-justin.iurman@uliege.be>
References: <20211011180412.22781-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The output behavior for undefined bits is now directly tested inside the bash
script. Trying to set an undefined bit should be refused.

The input behavior for undefined bits has been removed due to the fact that we
would need another sender allowed to set undefined bits.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 tools/testing/selftests/net/ioam6.sh       |  26 +++-
 tools/testing/selftests/net/ioam6_parser.c | 164 ++++++++-------------
 2 files changed, 81 insertions(+), 109 deletions(-)

diff --git a/tools/testing/selftests/net/ioam6.sh b/tools/testing/selftests/net/ioam6.sh
index 3caf72bb9c6a..a2489ec398fe 100755
--- a/tools/testing/selftests/net/ioam6.sh
+++ b/tools/testing/selftests/net/ioam6.sh
@@ -468,10 +468,26 @@ out_bits()
   for i in {0..22}
   do
     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
-           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
-
-    run_test "out_bit$i" "${desc/<n>/$i}" ioam-node-alpha ioam-node-beta \
-           db01::2 db01::1 veth0 ${bit2type[$i]} 123
+           prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} \
+           dev veth0 &>/dev/null
+
+    local cmd_res=$?
+    local descr="${desc/<n>/$i}"
+
+    if [[ $i -ge 12 && $i -le 21 ]]
+    then
+      if [ $cmd_res != 0 ]
+      then
+        npassed=$((npassed+1))
+        log_test_passed "$descr"
+      else
+        nfailed=$((nfailed+1))
+        log_test_failed "$descr"
+      fi
+    else
+      run_test "out_bit$i" "$descr" ioam-node-alpha ioam-node-beta \
+             db01::2 db01::1 veth0 ${bit2type[$i]} 123
+    fi
   done
 
   bit2size[22]=$tmp
@@ -544,7 +560,7 @@ in_bits()
   local tmp=${bit2size[22]}
   bit2size[22]=$(( $tmp + ${#BETA[9]} + ((4 - (${#BETA[9]} % 4)) % 4) ))
 
-  for i in {0..22}
+  for i in {0..11} {22..22}
   do
     ip -netns ioam-node-alpha route change db01::/64 encap ioam6 trace \
            prealloc type ${bit2type[$i]} ns 123 size ${bit2size[$i]} dev veth0
diff --git a/tools/testing/selftests/net/ioam6_parser.c b/tools/testing/selftests/net/ioam6_parser.c
index d376cb2c383c..8f6997d35816 100644
--- a/tools/testing/selftests/net/ioam6_parser.c
+++ b/tools/testing/selftests/net/ioam6_parser.c
@@ -94,16 +94,6 @@ enum {
 	TEST_OUT_BIT9,
 	TEST_OUT_BIT10,
 	TEST_OUT_BIT11,
-	TEST_OUT_BIT12,
-	TEST_OUT_BIT13,
-	TEST_OUT_BIT14,
-	TEST_OUT_BIT15,
-	TEST_OUT_BIT16,
-	TEST_OUT_BIT17,
-	TEST_OUT_BIT18,
-	TEST_OUT_BIT19,
-	TEST_OUT_BIT20,
-	TEST_OUT_BIT21,
 	TEST_OUT_BIT22,
 	TEST_OUT_FULL_SUPP_TRACE,
 
@@ -125,16 +115,6 @@ enum {
 	TEST_IN_BIT9,
 	TEST_IN_BIT10,
 	TEST_IN_BIT11,
-	TEST_IN_BIT12,
-	TEST_IN_BIT13,
-	TEST_IN_BIT14,
-	TEST_IN_BIT15,
-	TEST_IN_BIT16,
-	TEST_IN_BIT17,
-	TEST_IN_BIT18,
-	TEST_IN_BIT19,
-	TEST_IN_BIT20,
-	TEST_IN_BIT21,
 	TEST_IN_BIT22,
 	TEST_IN_FULL_SUPP_TRACE,
 
@@ -199,30 +179,6 @@ static int check_ioam_header(int tid, struct ioam6_trace_hdr *ioam6h,
 		       ioam6h->nodelen != 2 ||
 		       ioam6h->remlen;
 
-	case TEST_OUT_BIT12:
-	case TEST_IN_BIT12:
-	case TEST_OUT_BIT13:
-	case TEST_IN_BIT13:
-	case TEST_OUT_BIT14:
-	case TEST_IN_BIT14:
-	case TEST_OUT_BIT15:
-	case TEST_IN_BIT15:
-	case TEST_OUT_BIT16:
-	case TEST_IN_BIT16:
-	case TEST_OUT_BIT17:
-	case TEST_IN_BIT17:
-	case TEST_OUT_BIT18:
-	case TEST_IN_BIT18:
-	case TEST_OUT_BIT19:
-	case TEST_IN_BIT19:
-	case TEST_OUT_BIT20:
-	case TEST_IN_BIT20:
-	case TEST_OUT_BIT21:
-	case TEST_IN_BIT21:
-		return ioam6h->overflow ||
-		       ioam6h->nodelen ||
-		       ioam6h->remlen != 1;
-
 	case TEST_OUT_BIT22:
 	case TEST_IN_BIT22:
 		return ioam6h->overflow ||
@@ -326,6 +282,66 @@ static int check_ioam6_data(__u8 **p, struct ioam6_trace_hdr *ioam6h,
 		*p += sizeof(__u32);
 	}
 
+	if (ioam6h->type.bit12) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit13) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit14) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit15) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit16) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit17) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit18) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit19) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit20) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
+	if (ioam6h->type.bit21) {
+		if (__be32_to_cpu(*((__u32 *)*p)) != 0xffffffff)
+			return 1;
+		*p += sizeof(__u32);
+	}
+
 	if (ioam6h->type.bit22) {
 		len = cnf.sc_data ? strlen(cnf.sc_data) : 0;
 		aligned = cnf.sc_data ? __ALIGN_KERNEL(len, 4) : 0;
@@ -455,26 +471,6 @@ static int str2id(const char *tname)
 		return TEST_OUT_BIT10;
 	if (!strcmp("out_bit11", tname))
 		return TEST_OUT_BIT11;
-	if (!strcmp("out_bit12", tname))
-		return TEST_OUT_BIT12;
-	if (!strcmp("out_bit13", tname))
-		return TEST_OUT_BIT13;
-	if (!strcmp("out_bit14", tname))
-		return TEST_OUT_BIT14;
-	if (!strcmp("out_bit15", tname))
-		return TEST_OUT_BIT15;
-	if (!strcmp("out_bit16", tname))
-		return TEST_OUT_BIT16;
-	if (!strcmp("out_bit17", tname))
-		return TEST_OUT_BIT17;
-	if (!strcmp("out_bit18", tname))
-		return TEST_OUT_BIT18;
-	if (!strcmp("out_bit19", tname))
-		return TEST_OUT_BIT19;
-	if (!strcmp("out_bit20", tname))
-		return TEST_OUT_BIT20;
-	if (!strcmp("out_bit21", tname))
-		return TEST_OUT_BIT21;
 	if (!strcmp("out_bit22", tname))
 		return TEST_OUT_BIT22;
 	if (!strcmp("out_full_supp_trace", tname))
@@ -509,26 +505,6 @@ static int str2id(const char *tname)
 		return TEST_IN_BIT10;
 	if (!strcmp("in_bit11", tname))
 		return TEST_IN_BIT11;
-	if (!strcmp("in_bit12", tname))
-		return TEST_IN_BIT12;
-	if (!strcmp("in_bit13", tname))
-		return TEST_IN_BIT13;
-	if (!strcmp("in_bit14", tname))
-		return TEST_IN_BIT14;
-	if (!strcmp("in_bit15", tname))
-		return TEST_IN_BIT15;
-	if (!strcmp("in_bit16", tname))
-		return TEST_IN_BIT16;
-	if (!strcmp("in_bit17", tname))
-		return TEST_IN_BIT17;
-	if (!strcmp("in_bit18", tname))
-		return TEST_IN_BIT18;
-	if (!strcmp("in_bit19", tname))
-		return TEST_IN_BIT19;
-	if (!strcmp("in_bit20", tname))
-		return TEST_IN_BIT20;
-	if (!strcmp("in_bit21", tname))
-		return TEST_IN_BIT21;
 	if (!strcmp("in_bit22", tname))
 		return TEST_IN_BIT22;
 	if (!strcmp("in_full_supp_trace", tname))
@@ -606,16 +582,6 @@ static int (*func[__TEST_MAX])(int, struct ioam6_trace_hdr *, __u32, __u16) = {
 	[TEST_OUT_BIT9]		= check_ioam_header_and_data,
 	[TEST_OUT_BIT10]		= check_ioam_header_and_data,
 	[TEST_OUT_BIT11]		= check_ioam_header_and_data,
-	[TEST_OUT_BIT12]		= check_ioam_header,
-	[TEST_OUT_BIT13]		= check_ioam_header,
-	[TEST_OUT_BIT14]		= check_ioam_header,
-	[TEST_OUT_BIT15]		= check_ioam_header,
-	[TEST_OUT_BIT16]		= check_ioam_header,
-	[TEST_OUT_BIT17]		= check_ioam_header,
-	[TEST_OUT_BIT18]		= check_ioam_header,
-	[TEST_OUT_BIT19]		= check_ioam_header,
-	[TEST_OUT_BIT20]		= check_ioam_header,
-	[TEST_OUT_BIT21]		= check_ioam_header,
 	[TEST_OUT_BIT22]		= check_ioam_header_and_data,
 	[TEST_OUT_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
 	[TEST_IN_UNDEF_NS]		= check_ioam_header,
@@ -633,16 +599,6 @@ static int (*func[__TEST_MAX])(int, struct ioam6_trace_hdr *, __u32, __u16) = {
 	[TEST_IN_BIT9]			= check_ioam_header_and_data,
 	[TEST_IN_BIT10]		= check_ioam_header_and_data,
 	[TEST_IN_BIT11]		= check_ioam_header_and_data,
-	[TEST_IN_BIT12]		= check_ioam_header,
-	[TEST_IN_BIT13]		= check_ioam_header,
-	[TEST_IN_BIT14]		= check_ioam_header,
-	[TEST_IN_BIT15]		= check_ioam_header,
-	[TEST_IN_BIT16]		= check_ioam_header,
-	[TEST_IN_BIT17]		= check_ioam_header,
-	[TEST_IN_BIT18]		= check_ioam_header,
-	[TEST_IN_BIT19]		= check_ioam_header,
-	[TEST_IN_BIT20]		= check_ioam_header,
-	[TEST_IN_BIT21]		= check_ioam_header,
 	[TEST_IN_BIT22]		= check_ioam_header_and_data,
 	[TEST_IN_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
 	[TEST_FWD_FULL_SUPP_TRACE]	= check_ioam_header_and_data,
-- 
2.25.1

