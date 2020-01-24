Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BDC14783A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 06:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbgAXFmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 00:42:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730222AbgAXFmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 00:42:06 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00O5diOv014298
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:42:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=z6s3h17AdBFhJYV46iNnioJ79bYFwSTm//wxVeY/sb8=;
 b=Xrg6f42qADGVwNloovRANqCKcEUmtXdgr7q0G3z2q6e0ETIzGz/9CKbys8m3Gf8J2Heh
 T/7p3zy+N1uiWlkyaOUWowQ2n9AOH8DK4VerC5jAgVycWBJ/jAck8DQpEC7W8sh3mv3o
 IcD3HO4haPIgAApXyiRn/xoG4+5kHBq6EiU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpu2180bv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 21:42:04 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 21:42:02 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DC8B62EC1D16; Thu, 23 Jan 2020 21:41:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: improve bpftool changes detection
Date:   Thu, 23 Jan 2020 21:41:48 -0800
Message-ID: <20200124054148.2455060-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_01:2020-01-23,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=8 adultscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001240045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detect when bpftool source code changes and trigger rebuild within
selftests/bpf Makefile. Also fix few small formatting problems.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 5f41f5bd8033..257a1aaaa37d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -155,16 +155,17 @@ $(OUTPUT)/test_sysctl: cgroup_helpers.c
 
 DEFAULT_BPFTOOL := $(SCRATCH_DIR)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
-$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BUILD_DIR)/bpftool
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			\
-		    OUTPUT=$(BUILD_DIR)/bpftool/			\
+$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
+		    $(BPFOBJ) | $(BUILD_DIR)/bpftool
+	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
+		    OUTPUT=$(BUILD_DIR)/bpftool/			       \
 		    prefix= DESTDIR=$(SCRATCH_DIR)/ install
 
-$(BPFOBJ): $(wildcard $(BPFDIR)/*.c $(BPFDIR)/*.h $(BPFDIR)/Makefile)          \
+$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
 	   ../../../include/uapi/linux/bpf.h                                   \
 	   | $(INCLUDE_DIR) $(BUILD_DIR)/libbpf
 	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
-		DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
+		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
 
 $(BUILD_DIR)/libbpf $(BUILD_DIR)/bpftool $(INCLUDE_DIR):
 	$(call msg,MKDIR,,$@)
-- 
2.17.1

