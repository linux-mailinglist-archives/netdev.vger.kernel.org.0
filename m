Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC13133E780
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 04:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhCQDNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Mar 2021 23:13:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11566 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhCQDNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 23:13:08 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12H34nYt003350
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:07 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 379e11frpy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 20:13:07 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 20:13:06 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AF7FB2ED23D6; Tue, 16 Mar 2021 20:13:05 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 3/4] selftests/bpf: treat compilation warnings as errors
Date:   Tue, 16 Mar 2021 20:12:56 -0700
Message-ID: <20210317031257.846314-4-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210317031257.846314-1-andrii@kernel.org>
References: <20210317031257.846314-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_09:2021-03-16,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=702 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170024
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make selftests/bpf compilation more strict by treating warnings as errors. We
are generally pretty good at keeping compilation clean, but it's easy to miss
minor warnings. So let's not trust people and just employ stricter compiler
enforcement.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index d0db2b673c6f..7e18f3e66e61 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -21,7 +21,7 @@ endif
 
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 SAN_CFLAGS	?=
-CFLAGS += -g -Og -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)		\
+CFLAGS += -g -Og -rdynamic -Wall -Werror $(GENFLAGS) $(SAN_CFLAGS)	\
 	  -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)		\
 	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(OUTPUT)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
@@ -270,7 +270,7 @@ IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
 MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 			\
+BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
 	     -I$(INCLUDE_DIR) -I$(CURDIR) -I$(APIDIR)			\
 	     -I$(abspath $(OUTPUT)/../usr/include)
 
-- 
2.30.2

