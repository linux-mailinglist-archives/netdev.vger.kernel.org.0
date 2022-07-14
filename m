Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114B6574162
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiGNCQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiGNCQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:16:07 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9201E3C4;
        Wed, 13 Jul 2022 19:16:07 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LjyhT6DHMz1L8wP;
        Thu, 14 Jul 2022 10:13:29 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 10:15:47 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 14 Jul 2022 10:15:47 +0800
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
Subject: [PATCH bpf-next v2 3/3] bpf: iterators: build and use lightweight bootstrap version of bpftool
Date:   Thu, 14 Jul 2022 10:46:12 +0800
Message-ID: <20220714024612.944071-4-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714024612.944071-1-pulehui@huawei.com>
References: <20220714024612.944071-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

kernel/bpf/preload/iterators use bpftool for vmlinux.h, skeleton, and
static linking only. So we can use lightweight bootstrap version of
bpftool to handle these, and it will be faster.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
---
 kernel/bpf/preload/iterators/Makefile | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/preload/iterators/Makefile b/kernel/bpf/preload/iterators/Makefile
index bfe24f8c5a20..6762b1260f2f 100644
--- a/kernel/bpf/preload/iterators/Makefile
+++ b/kernel/bpf/preload/iterators/Makefile
@@ -9,7 +9,7 @@ LLVM_STRIP ?= llvm-strip
 TOOLS_PATH := $(abspath ../../../../tools)
 BPFTOOL_SRC := $(TOOLS_PATH)/bpf/bpftool
 BPFTOOL_OUTPUT := $(abs_out)/bpftool
-DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
+DEFAULT_BPFTOOL := $(BPFTOOL_OUTPUT)/bootstrap/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 
 LIBBPF_SRC := $(TOOLS_PATH)/lib/bpf
@@ -61,9 +61,5 @@ $(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(LIBBPF_OU
 		    OUTPUT=$(abspath $(dir $@))/ prefix=		       \
 		    DESTDIR=$(LIBBPF_DESTDIR) $(abspath $@) install_headers
 
-$(DEFAULT_BPFTOOL): $(BPFOBJ) | $(BPFTOOL_OUTPUT)
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)			       \
-		    OUTPUT=$(BPFTOOL_OUTPUT)/				       \
-		    LIBBPF_OUTPUT=$(LIBBPF_OUTPUT)/			       \
-		    LIBBPF_DESTDIR=$(LIBBPF_DESTDIR)/			       \
-		    prefix= DESTDIR=$(abs_out)/ install-bin
+$(DEFAULT_BPFTOOL): | $(BPFTOOL_OUTPUT)
+	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOL_SRC)	OUTPUT=$(BPFTOOL_OUTPUT)/ bootstrap
-- 
2.25.1

