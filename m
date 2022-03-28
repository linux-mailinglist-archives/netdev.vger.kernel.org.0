Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77684E9E30
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiC1RyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244768AbiC1Rwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:52:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2273C73F;
        Mon, 28 Mar 2022 10:51:13 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0YP2PvWz67NB8;
        Tue, 29 Mar 2022 01:48:41 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:51:10 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <corbet@lwn.net>, <viro@zeniv.linux.org.uk>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <shuah@kernel.org>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <zohar@linux.ibm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 02/18] bpf-preload: Move bpf_preload.h to include/linux
Date:   Mon, 28 Mar 2022 19:50:17 +0200
Message-ID: <20220328175033.2437312-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move bpf_preload.h to include/linux, so that third-party providers can
develop out-of-tree kernel modules to preload eBPF programs.

Export the bpf_preload_ops global variable if CONFIG_BPF_SYSCALL is
defined.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 {kernel/bpf/preload => include/linux}/bpf_preload.h | 4 ++++
 kernel/bpf/inode.c                                  | 2 +-
 kernel/bpf/preload/bpf_preload_kern.c               | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)
 rename {kernel/bpf/preload => include/linux}/bpf_preload.h (85%)

diff --git a/kernel/bpf/preload/bpf_preload.h b/include/linux/bpf_preload.h
similarity index 85%
rename from kernel/bpf/preload/bpf_preload.h
rename to include/linux/bpf_preload.h
index f065c91213a0..09d55d9f1131 100644
--- a/kernel/bpf/preload/bpf_preload.h
+++ b/include/linux/bpf_preload.h
@@ -11,6 +11,10 @@ struct bpf_preload_ops {
 	int (*preload)(struct bpf_preload_info *);
 	struct module *owner;
 };
+
+#ifdef CONFIG_BPF_SYSCALL
 extern struct bpf_preload_ops *bpf_preload_ops;
+#endif /*CONFIG_BPF_SYSCALL*/
+
 #define BPF_PRELOAD_LINKS 2
 #endif
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..1f2d468abf58 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -20,7 +20,7 @@
 #include <linux/filter.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
-#include "preload/bpf_preload.h"
+#include <linux/bpf_preload.h>
 
 enum bpf_type {
 	BPF_TYPE_UNSPEC	= 0,
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index 5106b5372f0c..f43391d1c49c 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -2,7 +2,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/init.h>
 #include <linux/module.h>
-#include "bpf_preload.h"
+#include <linux/bpf_preload.h>
 #include "iterators/iterators.lskel.h"
 
 static struct bpf_link *maps_link, *progs_link;
-- 
2.32.0

