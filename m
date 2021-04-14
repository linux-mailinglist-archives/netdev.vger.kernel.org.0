Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C922935FC38
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353684AbhDNUDC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:03:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27511 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353636AbhDNUCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13EK2B4g032108
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:25 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 37wvny3hmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:25 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:24 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 607CD2ED1A84; Wed, 14 Apr 2021 13:02:21 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 13/17] selftests/bpf: use -O0 instead of -Og in selftests builds
Date:   Wed, 14 Apr 2021 13:01:42 -0700
Message-ID: <20210414200146.2663044-14-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: r9KAKq6T24gVTmnxEffXgC8PBcy6BhVt
X-Proofpoint-GUID: r9KAKq6T24gVTmnxEffXgC8PBcy6BhVt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While -Og is designed to work well with debugger, it's still inferior to -O0
in terms of debuggability experience. It will cause some variables to still be
inlined, it will also prevent single-stepping some statements and otherwise
interfere with debugging experience. So switch to -O0 which turns off any
optimization and provides the best debugging experience.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 6448c626498f..22a88580b491 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -21,7 +21,7 @@ endif
 
 BPF_GCC		?= $(shell command -v bpf-gcc;)
 SAN_CFLAGS	?=
-CFLAGS += -g -Og -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)		\
+CFLAGS += -g -O0 -rdynamic -Wall $(GENFLAGS) $(SAN_CFLAGS)		\
 	  -I$(CURDIR) -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)		\
 	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(OUTPUT)			\
 	  -Dbpf_prog_load=bpf_prog_test_load				\
@@ -201,7 +201,7 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
 	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
 		    CC=$(HOSTCC) LD=$(HOSTLD)				       \
-		    EXTRA_CFLAGS='-g -Og'				       \
+		    EXTRA_CFLAGS='-g -O0'				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
 		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
 
@@ -219,7 +219,7 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	   ../../../include/uapi/linux/bpf.h                                   \
 	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
-		    EXTRA_CFLAGS='-g -Og'					       \
+		    EXTRA_CFLAGS='-g -O0'				       \
 		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
 
 ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
@@ -227,7 +227,7 @@ $(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)                \
 	   ../../../include/uapi/linux/bpf.h                                   \
 	   | $(INCLUDE_DIR) $(HOST_BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
-		    EXTRA_CFLAGS='-g -Og'					       \
+		    EXTRA_CFLAGS='-g -O0'				       \
 		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
 		    DESTDIR=$(HOST_SCRATCH_DIR)/ prefix= all install_headers
 endif
-- 
2.30.2

