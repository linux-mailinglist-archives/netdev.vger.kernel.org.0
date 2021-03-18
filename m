Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F111340E88
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbhCRTl2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Mar 2021 15:41:28 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48674 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232943AbhCRTlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:41:08 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12IJUZq5016647
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:41:07 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 37bs1h6ce8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:41:07 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 12:41:06 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 00C9C2ED2588; Thu, 18 Mar 2021 12:41:05 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v4 bpf-next 11/12] selftests/bpf: pass all BPF .o's through BPF static linker
Date:   Thu, 18 Mar 2021 12:40:35 -0700
Message-ID: <20210318194036.3521577-12-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318194036.3521577-1-andrii@kernel.org>
References: <20210318194036.3521577-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_12:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103180139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass all individual BPF object files (generated from progs/*.c) through
`bpftool gen object` command to validate that BPF static linker doesn't
corrupt them.

As an additional sanity checks, validate that passing resulting object files
through linker again results in identical ELF files. Exact same ELF contents
can be guaranteed only after two passes, as after the first pass ELF sections
order changes, and thus .BTF.ext data sections order changes. That, in turn,
means that strings are added into the final BTF string sections in different
order, so .BTF strings data might not be exactly the same. But doing another
round of linking afterwards should result in the identical ELF file, which is
checked with additional `diff` command.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index dbca39f45382..3a7c02add70c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -355,12 +355,13 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS))
 
-$(TRUNNER_BPF_SKELS): $(TRUNNER_OUTPUT)/%.skel.h:			\
-		      $(TRUNNER_OUTPUT)/%.o				\
-		      $(BPFTOOL)					\
-		      | $(TRUNNER_OUTPUT)
+$(TRUNNER_BPF_SKELS): %.skel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
-	$(Q)$$(BPFTOOL) gen skeleton $$< > $$@
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked.o) $$<
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked.o)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
+	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
+	$(Q)$$(BPFTOOL) gen skeleton $$(<:.o=.linked.o) name $$(notdir $$(<:.o=)) > $$@
 endif
 
 # ensure we set up tests.h header generation rule just once
-- 
2.30.2

