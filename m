Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6047D571049
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 04:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiGLChu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 22:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiGLChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 22:37:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D1A8FD50;
        Mon, 11 Jul 2022 19:37:46 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LhlGv1PDrzcg36;
        Tue, 12 Jul 2022 10:35:35 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 10:37:45 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 10:37:45 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Pu Lehui <pulehui@huawei.com>
Subject: [PATCH bpf-next 1/3] samples: bpf: Fix cross-compiling error by using bootstrap bpftool
Date:   Tue, 12 Jul 2022 11:08:11 +0800
Message-ID: <20220712030813.865410-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220712030813.865410-1-pulehui@huawei.com>
References: <20220712030813.865410-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when cross compiling bpf samples, the host side cannot
use arch-specific bpftool to generate vmlinux.h or skeleton. Since
samples/bpf use bpftool for vmlinux.h, skeleton, and static linking
only, we can use lightweight bootstrap version of bpftool to handle
these, and it's always host-native.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
---
 samples/bpf/Makefile | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 5002a5b9a7da..57012b8259d2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -282,12 +282,18 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
 
 BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
 BPFTOOL_OUTPUT := $(abspath $(BPF_SAMPLES_PATH))/bpftool
-BPFTOOL := $(BPFTOOL_OUTPUT)/bpftool
+BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
+ifeq ($(CROSS_COMPILE),)
 $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
-	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ \
-		OUTPUT=$(BPFTOOL_OUTPUT)/ \
-		LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/ \
-		LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/
+	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../		\
+		OUTPUT=$(BPFTOOL_OUTPUT)/ 					\
+		LIBBPF_BOOTSTRAP_OUTPUT=$(LIBBPF_OUTPUT)/ 			\
+		LIBBPF_BOOTSTRAP_DESTDIR=$(LIBBPF_DESTDIR)/ bootstrap
+else
+$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) | $(BPFTOOL_OUTPUT)
+	$(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../ 		\
+		OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
+endif
 
 $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
 	$(call msg,MKDIR,$@)
-- 
2.25.1

