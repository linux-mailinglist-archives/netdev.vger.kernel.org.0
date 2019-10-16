Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B26D8868
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbfJPGBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:01:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61846 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388268AbfJPGBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:01:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G5vrPV026313
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=lASZsbS0MzgZ+kv94/3rudInFfHv8e6mbGeyrZdtm9c=;
 b=Z6T7t10iiLrUKWtZZbm2voaFDX4HMOJZ/s/5Wv2VwEeSHKon6GDGL3i3kXcZ1HFFqEh5
 aZOTgMPpFiD8SKW1T5H16Dej94WZ6c2FXmiA95lzM6tWwmACJFn70226yBOEyLBZizVc
 qoQBgzzXBj0x1WEtaUtz3kYqUzOUo9lBW54= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnfbbv1dd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:15 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 23:01:14 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D812486195B; Tue, 15 Oct 2019 23:01:09 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 4/7] selftests/bpf: add simple per-test targets to Makefile
Date:   Tue, 15 Oct 2019 23:00:48 -0700
Message-ID: <20191016060051.2024182-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016060051.2024182-1-andriin@fb.com>
References: <20191016060051.2024182-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=9 priorityscore=1501 adultscore=0 mlxlogscore=437
 clxscore=1015 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160056
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

