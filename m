Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C81D883C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387844AbfJPFuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:50:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387668AbfJPFuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:50:09 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G5o4gb016639
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lASZsbS0MzgZ+kv94/3rudInFfHv8e6mbGeyrZdtm9c=;
 b=Pxd1rFHUpJTeM7yj2yEDydXbFSuWMJf20S9x4T9IhLaC9z036ojbF9+0Lls7J2ijP6Im
 u7iLDnnzOrrWcrxeHQ2BeN6qS3TQY4TWxiCs+Y2t0qOl13N/XsV5FW6kWdFmS3+mtpNy
 HD79gEPoSMKV4kDXTTZio2L2wkJjokbhMLo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnf1wm20m-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 22:50:08 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 22:49:57 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BB3B286193C; Tue, 15 Oct 2019 22:49:56 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 4/7] selftests/bpf: add simple per-test targets to Makefile
Date:   Tue, 15 Oct 2019 22:49:42 -0700
Message-ID: <20191016054945.1988387-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016054945.1988387-1-andriin@fb.com>
References: <20191016054945.1988387-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=429 priorityscore=1501 suspectscore=9 phishscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160054
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently it's impossible to do `make test_progs` and have only
test_progs be built, because all the binary targets are defined in terms
of $(OUTPUT)/<binary>, and $(OUTPUT) is absolute path to current
directory (or whatever gets overridden to by user).

This patch adds simple re-directing targets for all test targets making
it possible to do simple and nice `make test_progs` (and any other
target).

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5f97262e5fcb..fbced23935cc 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -84,6 +84,16 @@ TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_use
 
 include ../lib.mk
 
+# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
+# to build individual tests.
+# NOTE: Semicolon at the end is critical to override lib.mk's default static
+# rule for binaries.
+$(notdir $(TEST_GEN_PROGS)						\
+	 $(TEST_PROGS)							\
+	 $(TEST_PROGS_EXTENDED)						\
+	 $(TEST_GEN_PROGS_EXTENDED)					\
+	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
+
 # NOTE: $(OUTPUT) won't get default value if used before lib.mk
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 all: $(TEST_CUSTOM_PROGS)
-- 
2.17.1

