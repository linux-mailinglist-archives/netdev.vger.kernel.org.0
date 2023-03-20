Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D606C1EBA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjCTR6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjCTR6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:58:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9362F3D0B8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:53:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5077B81063
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA1FC433EF;
        Mon, 20 Mar 2023 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334709;
        bh=yLZGKCDjAVIshJpLCpnJeMML0FsMKh2mhq/cUUvMtic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o78NCJWvtnhPgdfXs1rSXUdWbE9giDBdlfIc+0T8BNLTdIC16+vpl49ikQDRRmk9p
         grOpHjqAuO+rmRnyeurqw4BU458l/gejP4jGc3njyOPjDEZ938AktWEyOY3jpshX/k
         JHNf460C3w1/X201zNajA7RTznofwjGeeNVvSeXctkyPJZlUmandZOL0UN6tM4DgbG
         ZCgBKewzJdUQJO4qBHsggkIiKNH9K6sTUY9JbXCJG35Va4eulCzAVuMS7sWpSoxnJm
         E8+qIJiw1QIdqUCGSV24ZZPyzCZbZi0wVpAwIT6JjJI+tS8FtRuZjfcTh2k5LPY5vM
         6wgAusLleH9Ww==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net-next 03/14] lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
Date:   Mon, 20 Mar 2023 10:51:33 -0700
Message-Id: <20230320175144.153187-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320175144.153187-1-saeed@kernel.org>
References: <20230320175144.153187-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add a function to complement irq_cpu_rmap_add(). It removes the irq from
the reverse mapping by setting the notifier to NULL.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/cpu_rmap.h |  2 ++
 lib/cpu_rmap.c           | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
index 0ec745e6cd36..58284f1f3a58 100644
--- a/include/linux/cpu_rmap.h
+++ b/include/linux/cpu_rmap.h
@@ -60,6 +60,8 @@ static inline struct cpu_rmap *alloc_irq_cpu_rmap(unsigned int size)
 }
 extern void free_irq_cpu_rmap(struct cpu_rmap *rmap);
 
+extern int irq_cpu_rmap_remove(struct cpu_rmap *rmap, int irq);
 extern int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq);
 
+
 #endif /* __LINUX_CPU_RMAP_H */
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index e80ae6521f71..e09c37ff2a00 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -285,6 +285,17 @@ static void irq_cpu_rmap_release(struct kref *ref)
 	kfree(glue);
 }
 
+/**
+ * irq_cpu_rmap_remove - remove an IRQ from a CPU affinity reverse-map
+ * @rmap: The reverse-map
+ * @irq: The IRQ number
+ */
+int irq_cpu_rmap_remove(struct cpu_rmap *rmap, int irq)
+{
+	return irq_set_affinity_notifier(irq, NULL);
+}
+EXPORT_SYMBOL(irq_cpu_rmap_remove);
+
 /**
  * irq_cpu_rmap_add - add an IRQ to a CPU affinity reverse-map
  * @rmap: The reverse-map
-- 
2.39.2

