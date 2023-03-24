Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A346C8917
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjCXXOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjCXXOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881E41CF5D
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD528B82665
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EBFC433D2;
        Fri, 24 Mar 2023 23:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699633;
        bh=XSswy1WXblrf/I9POzSThnJOJli4IetxoZOzgBfppSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in6F4QQzDY5399tDtcM1tXke7hJ5Of/Mjt9rv4QS+oYRT99YZQSEKpU4T7J4+jlnJ
         rOUh97Qnd5YUcCBhoVk0OVQzwaraNZ5cJ+NU6ebWs/t4AcQVjBdo8JXVS+1INLlWc5
         IVyKmSQhfFwk0mpRUPfePAcMzfH03CKvVLVL69mNiaVz9NxqStuK2YfAp19L7LY5F0
         9x6ImmvstKM+Px52IP4CWkRv5SfHJCHwJvSHi3WJBLnSFtTFTe7RV0DPJwVC6guah+
         Wd5VUKhfPEY6MdbBnP3LY7kOB6MGws12Vp753WK3E8gL9aYhOTCQHuzRgu3q6kmWrb
         prEjdkICWWjFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eli Cohen <elic@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [net-next V2 03/15] lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
Date:   Fri, 24 Mar 2023 16:13:29 -0700
Message-Id: <20230324231341.29808-4-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324231341.29808-1-saeed@kernel.org>
References: <20230324231341.29808-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

Add a function to complement irq_cpu_rmap_add(). It removes the irq from
the reverse mapping by setting the notifier to NULL. The function calls
irq_set_affinity_notifier() with NULL at the notify argument which then
cancel any pending notifier work and decrement reference on the
notifier. When ref count reaches zero, the glue pointer is kfree and the
rmap entry is set to NULL serving both to avoid second attempt to
release it and also making the rmap entry available for subsequent
mapping.

It should be noted the drivers usually creates the reverse mapping at
initialization time and remove it at unload time so we do not expect
failures in allocating rmap due to kref holding the glue entry.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/linux/cpu_rmap.h |  1 +
 lib/cpu_rmap.c           | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
index 0ec745e6cd36..cae324d10965 100644
--- a/include/linux/cpu_rmap.h
+++ b/include/linux/cpu_rmap.h
@@ -60,6 +60,7 @@ static inline struct cpu_rmap *alloc_irq_cpu_rmap(unsigned int size)
 }
 extern void free_irq_cpu_rmap(struct cpu_rmap *rmap);
 
+int irq_cpu_rmap_remove(struct cpu_rmap *rmap, int irq);
 extern int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq);
 
 #endif /* __LINUX_CPU_RMAP_H */
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 5d4bf7a8b926..73c1636b927b 100644
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

