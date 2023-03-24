Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C09A6C8914
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbjCXXOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbjCXXN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:13:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499916331
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C2F562CFD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDE6C433EF;
        Fri, 24 Mar 2023 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699632;
        bh=VNNhatiKCLKF1cV/7I12fjVTFa36+Nni43y0C5gZOKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpLi+ntx9aS0oSdL7mDy6JUBW1Yh+kMrrNL6GZziPG9WzV9ehxsgEnm+s+5H5jSFx
         DYY8i2Xx8c2YbC0P52zCxKRRx6psy/MfSrxsYqMIG3UbumKOkgVv7/GxZnBUOfNLYV
         ZI5+kcDcJIjuz+nLJ+9CmRs49irqAR/G6FVgyTXU/eoG+t96yKh/lKq8QXtLa5vFx5
         wQXxM2k3EHGUPllgpSM/s7ldy0rypp88rX6piJuIoMvtCWak1YXT/lkTOyLbxy6fyo
         YD2KDVNVbnWkS23u+Owiv5KQ4g6n6hCs4lgJ/cfBUFFXJyEmkhsogMQd9IYZUvc9Eb
         QizdyHuL9XABw==
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
Subject: [net-next V2 02/15] lib: cpu_rmap: Use allocator for rmap entries
Date:   Fri, 24 Mar 2023 16:13:28 -0700
Message-Id: <20230324231341.29808-3-saeed@kernel.org>
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

Use a proper allocator for rmap entries using a naive for loop. The
allocator relies on whether an entry is NULL to be considered free.
Remove the used field of rmap which is not needed.

Also, avoid crashing the kernel if an entry is not available.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/linux/cpu_rmap.h |  3 +--
 lib/cpu_rmap.c           | 43 ++++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
index be8aea04d023..0ec745e6cd36 100644
--- a/include/linux/cpu_rmap.h
+++ b/include/linux/cpu_rmap.h
@@ -16,14 +16,13 @@
  * struct cpu_rmap - CPU affinity reverse-map
  * @refcount: kref for object
  * @size: Number of objects to be reverse-mapped
- * @used: Number of objects added
  * @obj: Pointer to array of object pointers
  * @near: For each CPU, the index and distance to the nearest object,
  *      based on affinity masks
  */
 struct cpu_rmap {
 	struct kref	refcount;
-	u16		size, used;
+	u16		size;
 	void		**obj;
 	struct {
 		u16	index;
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index e77f12bb3c77..5d4bf7a8b926 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -128,19 +128,31 @@ debug_print_rmap(const struct cpu_rmap *rmap, const char *prefix)
 }
 #endif
 
+static int get_free_index(struct cpu_rmap *rmap)
+{
+	int i;
+
+	for (i = 0; i < rmap->size; i++)
+		if (!rmap->obj[i])
+			return i;
+
+	return -ENOSPC;
+}
+
 /**
  * cpu_rmap_add - add object to a rmap
  * @rmap: CPU rmap allocated with alloc_cpu_rmap()
  * @obj: Object to add to rmap
  *
- * Return index of object.
+ * Return index of object or -ENOSPC if no free entry was found
  */
 int cpu_rmap_add(struct cpu_rmap *rmap, void *obj)
 {
-	u16 index;
+	int index = get_free_index(rmap);
+
+	if (index < 0)
+		return index;
 
-	BUG_ON(rmap->used >= rmap->size);
-	index = rmap->used++;
 	rmap->obj[index] = obj;
 	return index;
 }
@@ -230,7 +242,7 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
 	if (!rmap)
 		return;
 
-	for (index = 0; index < rmap->used; index++) {
+	for (index = 0; index < rmap->size; index++) {
 		glue = rmap->obj[index];
 		if (glue)
 			irq_set_affinity_notifier(glue->notify.irq, NULL);
@@ -295,13 +307,22 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	glue->notify.release = irq_cpu_rmap_release;
 	glue->rmap = rmap;
 	cpu_rmap_get(rmap);
-	glue->index = cpu_rmap_add(rmap, glue);
+	rc = cpu_rmap_add(rmap, glue);
+	if (rc < 0)
+		goto err_add;
+
+	glue->index = rc;
 	rc = irq_set_affinity_notifier(irq, &glue->notify);
-	if (rc) {
-		cpu_rmap_put(glue->rmap);
-		rmap->obj[glue->index] = NULL;
-		kfree(glue);
-	}
+	if (rc)
+		goto err_set;
+
+	return rc;
+
+err_set:
+	rmap->obj[glue->index] = NULL;
+err_add:
+	cpu_rmap_put(glue->rmap);
+	kfree(glue);
 	return rc;
 }
 EXPORT_SYMBOL(irq_cpu_rmap_add);
-- 
2.39.2

