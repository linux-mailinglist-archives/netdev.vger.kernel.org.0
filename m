Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9451030B6
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbfKTAZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:25:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54900 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727579AbfKTAZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 19:25:18 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAK0KUmM005486
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:25:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=MbGumYYtT1gSAdjS9P2LAn3BCvf1HNoO7T+xod/wMNs=;
 b=NiVupZYMGcyEEgx8Z9FxBLMBdDHculf+g75qGeYzcYiKtWzS+4eIEuflgWAlDMZ9k/wB
 QllplURHecH6HwQtnbBK0Gk3idwFkqFAti4kFAKJS6n0l1TN55iBb0s6s5LXs8tZhyRR
 7OOBWliHVGNmXZyZ7irl5CN5WJGoEqFPfdM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wcnrv1m3v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 16:25:17 -0800
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Nov 2019 16:25:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B62F52EC1AD8; Tue, 19 Nov 2019 16:25:12 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: enforce no-ALU32 for test_progs-no_alu32
Date:   Tue, 19 Nov 2019 16:25:10 -0800
Message-ID: <20191120002510.4130605-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-19_08:2019-11-15,2019-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 mlxlogscore=802 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=8 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911200002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the most recent Clang, alu32 is enabled by default if -mcpu=probe or
-mcpu=v3 is specified. Use a separate build rule with -mcpu=v2 to enforce no
ALU32 mode.

Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index d4400fbe6634..4fe4aec0367c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -163,6 +163,12 @@ define CLANG_BPF_BUILD_RULE
 		-c $1 -o - || echo "BPF obj compilation failed") | 	\
 	$(LLC) -march=bpf -mcpu=probe $4 -filetype=obj -o $2
 endef
+# Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
+define CLANG_NOALU32_BPF_BUILD_RULE
+	($(CLANG) $3 -O2 -target bpf -emit-llvm				\
+		-c $1 -o - || echo "BPF obj compilation failed") | 	\
+	$(LLC) -march=bpf -mcpu=v2 $4 -filetype=obj -o $2
+endef
 # Similar to CLANG_BPF_BUILD_RULE, but using native Clang and bpf LLC
 define CLANG_NATIVE_BPF_BUILD_RULE
 	($(CLANG) $3 -O2 -emit-llvm					\
@@ -275,6 +281,7 @@ TRUNNER_BPF_LDFLAGS := -mattr=+alu32
 $(eval $(call DEFINE_TEST_RUNNER,test_progs))
 
 # Define test_progs-no_alu32 test runner.
+TRUNNER_BPF_BUILD_RULE := CLANG_NOALU32_BPF_BUILD_RULE
 TRUNNER_BPF_LDFLAGS :=
 $(eval $(call DEFINE_TEST_RUNNER,test_progs,no_alu32))
 
-- 
2.17.1

