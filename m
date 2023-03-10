Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861146B3C30
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCJKc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:32:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjCJKcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:32:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC041116BF;
        Fri, 10 Mar 2023 02:32:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8563D20653;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1678444334; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AadlA5Ixh0fCoPEBLO98G7bQ7AGSZJpNvfUKk6JlaZA=;
        b=xL0cbeEQboJcFPAwwkkO/x/Lg47bim2ZlZj9ADRe8B70qRZnfrKkRVOb7tQAtQEuRJ8oWd
        4xODf5QTjwba+ye05JFiG1g6juG97Xrhm+cHsP2CZtaBlrgRm3dG9tloj5sM82aaq5UrnA
        rSpocyNABRsaIoyrwB+6HJvIKLuAZZs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1678444334;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AadlA5Ixh0fCoPEBLO98G7bQ7AGSZJpNvfUKk6JlaZA=;
        b=Tp3d18/cjDXI1xemJ2Ql0+pg8xRv7dJpjAQipryYAFQS1kFeT7CjhYVlubYfS85pvh7d3s
        +8uiaUrOMfmUtODg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52ECF139F9;
        Fri, 10 Mar 2023 10:32:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aJWPEy4HC2SsXQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 10 Mar 2023 10:32:14 +0000
From:   Vlastimil Babka <vbabka@suse.cz>
To:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 1/7] mm/slob: remove CONFIG_SLOB
Date:   Fri, 10 Mar 2023 11:32:03 +0100
Message-Id: <20230310103210.22372-2-vbabka@suse.cz>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove SLOB from Kconfig and Makefile. Everything under #ifdef
CONFIG_SLOB, and mm/slob.c is now dead code.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 init/Kconfig               |  2 +-
 kernel/configs/tiny.config |  1 -
 mm/Kconfig                 | 22 ----------------------
 mm/Makefile                |  1 -
 4 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 1fb5f313d18f..72ac3f66bc27 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -973,7 +973,7 @@ config MEMCG
 
 config MEMCG_KMEM
 	bool
-	depends on MEMCG && !SLOB
+	depends on MEMCG
 	default y
 
 config BLK_CGROUP
diff --git a/kernel/configs/tiny.config b/kernel/configs/tiny.config
index c2f9c912df1c..144b2bd86b14 100644
--- a/kernel/configs/tiny.config
+++ b/kernel/configs/tiny.config
@@ -7,6 +7,5 @@ CONFIG_KERNEL_XZ=y
 # CONFIG_KERNEL_LZO is not set
 # CONFIG_KERNEL_LZ4 is not set
 # CONFIG_SLAB is not set
-# CONFIG_SLOB_DEPRECATED is not set
 CONFIG_SLUB=y
 CONFIG_SLUB_TINY=y
diff --git a/mm/Kconfig b/mm/Kconfig
index 4751031f3f05..669399ab693c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -238,30 +238,8 @@ config SLUB
 	   and has enhanced diagnostics. SLUB is the default choice for
 	   a slab allocator.
 
-config SLOB_DEPRECATED
-	depends on EXPERT
-	bool "SLOB (Simple Allocator - DEPRECATED)"
-	depends on !PREEMPT_RT
-	help
-	   Deprecated and scheduled for removal in a few cycles. SLUB
-	   recommended as replacement. CONFIG_SLUB_TINY can be considered
-	   on systems with 16MB or less RAM.
-
-	   If you need SLOB to stay, please contact linux-mm@kvack.org and
-	   people listed in the SLAB ALLOCATOR section of MAINTAINERS file,
-	   with your use case.
-
-	   SLOB replaces the stock allocator with a drastically simpler
-	   allocator. SLOB is generally more space efficient but
-	   does not perform as well on large systems.
-
 endchoice
 
-config SLOB
-	bool
-	default y
-	depends on SLOB_DEPRECATED
-
 config SLUB_TINY
 	bool "Configure SLUB for minimal memory footprint"
 	depends on SLUB && EXPERT
diff --git a/mm/Makefile b/mm/Makefile
index 8e105e5b3e29..2d9c1e7f6085 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -81,7 +81,6 @@ obj-$(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP)	+= hugetlb_vmemmap.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
 obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
-obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += page_poison.o
-- 
2.39.2

