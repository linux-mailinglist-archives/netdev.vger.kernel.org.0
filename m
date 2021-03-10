Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEE3333431
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhCJEFg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 23:05:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20062 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232260AbhCJEE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 23:04:56 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12A442wM006256
        for <netdev@vger.kernel.org>; Tue, 9 Mar 2021 20:04:56 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 376hbyhfcu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 20:04:56 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 9 Mar 2021 20:04:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 446962ED1C92; Tue,  9 Mar 2021 20:04:53 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 09/10] selftests/bpf: pass all BPF .o's through BPF static linker
Date:   Tue, 9 Mar 2021 20:04:30 -0800
Message-ID: <20210310040431.916483-10-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210310040431.916483-1-andrii@kernel.org>
References: <20210310040431.916483-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_03:2021-03-09,2021-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass all individual BPF object files (progs/*.o) through `bpftool gen bpfo`
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
index dbca39f45382..45a2ae1916ed 100644
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
+	$(Q)$$(BPFTOOL) gen bpfo $$(<:.o=.bpfo) $$<
+	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.bpfo) > $$@
 endif
 
 # ensure we set up tests.h header generation rule just once
-- 
2.24.1

