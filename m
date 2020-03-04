Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D2179834
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgCDSns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:43:48 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbgCDSns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:43:48 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024ITiHP022424
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 10:43:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=rXVNnDc2b0N43zIsSnrY4qwJop2dhCpuxuYn7MyhGnU=;
 b=oRYDK1KgO032Utky49pXKwPd5SuFt+Pyl8W1jZMgwWC17AWeA/62eztzqxR0UcnETK/q
 5JohBZxSAMf9I7sbWMg6YFRJBcV8IGzJJzytpigOpf0T28u7CzVJPNR6sbyIAbyvyW4T
 GpJyzfq4WAhp6wYlhXsDwQdxWdUWP0NIh3I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yhbxwtyr7-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:43:47 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 10:43:45 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8BAAA2EC2D4D; Wed,  4 Mar 2020 10:43:41 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: support out-of-tree vmlinux builds for VMLINUX_BTF
Date:   Wed, 4 Mar 2020 10:43:36 -0800
Message-ID: <20200304184336.165766-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_07:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=862 bulkscore=0 malwarescore=0 suspectscore=8 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040125
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add detection of out-of-tree built vmlinux image for the purpose of
VMLINUX_BTF detection. According to Documentation/kbuild/kbuild.rst, O takes
precedence over KBUILD_OUTPUT.

Also ensure ~/path/to/build/dir also works by relying on wildcard's resolution
first, but then applying $(abspath) at the end to also handle
O=../../whatever cases.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/Makefile | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2d7f5df33f04..ee4ad34adb4a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -129,10 +129,13 @@ $(OUTPUT)/test_stub.o: test_stub.c $(BPFOBJ)
 	$(call msg,CC,,$@)
 	$(CC) -c $(CFLAGS) -o $@ $<
 
-VMLINUX_BTF_PATHS := $(abspath ../../../../vmlinux)			\
-			       /sys/kernel/btf/vmlinux			\
-			       /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF:= $(firstword $(wildcard $(VMLINUX_BTF_PATHS)))
+VMLINUX_BTF_PATHS := $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF:= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+
 $(OUTPUT)/runqslower: $(BPFOBJ)
 	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/runqslower	\
 		    OUTPUT=$(SCRATCH_DIR)/ VMLINUX_BTF=$(VMLINUX_BTF)   \
-- 
2.17.1

