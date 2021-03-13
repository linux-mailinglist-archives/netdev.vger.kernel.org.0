Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7664333A091
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhCMTgT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 14:36:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234516AbhCMTgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:36:11 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12DJYqYp018654
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:36:11 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 378ucs9evc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 11:36:11 -0800
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 13 Mar 2021 11:36:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 617352ED20BF; Sat, 13 Mar 2021 11:36:01 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 10/11] selftests/bpf: pass all BPF .o's through BPF static linker
Date:   Sat, 13 Mar 2021 11:35:36 -0800
Message-ID: <20210313193537.1548766-11-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210313193537.1548766-1-andrii@kernel.org>
References: <20210313193537.1548766-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-13_07:2021-03-12,2021-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1034 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103130151
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass all individual BPF object files (progs/*.o) through `bpftool gen object`
command to validate that BPF static linker doesn't corrupt them.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore | 1 +
 tools/testing/selftests/bpf/Makefile   | 8 +++-----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4866f6a21901..811da0ea3ecd 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -36,4 +36,5 @@ test_cpp
 /runqslower
 /bench
 *.ko
+*.bpfo
 xdpxceiver
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index dbca39f45382..7ed5690be237 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -355,12 +355,10 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS))
 
-$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
-		      $(TRUNNER_OUTPUT)/%.o				\
-		      $(BPFTOOL)					\
-		      | $(TRUNNER_OUTPUT)
+$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.bpfo) $$<
+	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@
 endif
 
 # ensure we set up tests.h header generation rule just once
-- 
2.24.1

