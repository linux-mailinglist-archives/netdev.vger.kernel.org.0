Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BF35FC3B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353645AbhDNUDO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:03:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27894 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353632AbhDNUCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:53 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJtWwI011244
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:31 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvcmkkyy-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:31 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6AFA12ED1A84; Wed, 14 Apr 2021 13:02:23 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 14/17] selftests/bpf: omit skeleton generation for multi-linked BPF object files
Date:   Wed, 14 Apr 2021 13:01:43 -0700
Message-ID: <20210414200146.2663044-15-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: _EVyA5mJNk8iNNzI0--2peJVc4aC7YtW
X-Proofpoint-ORIG-GUID: _EVyA5mJNk8iNNzI0--2peJVc4aC7YtW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Skip generating individual BPF skeletons for files that are supposed to be
linked together to form the final BPF object file. Very often such files are
"incomplete" BPF object files, which will fail libbpf bpf_object__open() step,
if used individually, thus failing BPF skeleton generation. This is by design,
so skip individual BPF skeletons and only validate them as part of their
linked final BPF object file and skeleton.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 22a88580b491..cfa3e91c9a49 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -307,6 +307,8 @@ LINKED_SKELS := test_static_linked.skel.h
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 
+LINKED_BPF_SRCS := $(patsubst %.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
+
 # Set up extra TRUNNER_XXX "temporary" variables in the environment (relies on
 # $eval()) and pass control to DEFINE_TEST_RUNNER_RULES.
 # Parameters:
@@ -325,7 +327,7 @@ TRUNNER_TESTS_HDR := $(TRUNNER_TESTS_DIR)/tests.h
 TRUNNER_BPF_SRCS := $$(notdir $$(wildcard $(TRUNNER_BPF_PROGS_DIR)/*.c))
 TRUNNER_BPF_OBJS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.o, $$(TRUNNER_BPF_SRCS))
 TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
-				 $$(filter-out $(SKEL_BLACKLIST),	\
+				 $$(filter-out $(SKEL_BLACKLIST) $(LINKED_BPF_SRCS),\
 					       $$(TRUNNER_BPF_SRCS)))
 TRUNNER_BPF_SKELS_LINKED := $$(addprefix $$(TRUNNER_OUTPUT)/,$(LINKED_SKELS))
 TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)
-- 
2.30.2

