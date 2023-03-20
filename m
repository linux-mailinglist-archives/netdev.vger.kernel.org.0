Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB29C6C1EB7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjCTR6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCTR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D33BDBB
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08B326171D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FCAC4339B;
        Mon, 20 Mar 2023 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334708;
        bh=O4RyR07yi2qGmH1BLYuResHhBz60D+xmKAhT1KEoQP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ptIz4auyUDhigzQFj2Tx4iPbxUOPZDx7AEttC2UK5wgPbwF5w3753B4YqG2Ghc4sn
         tPkWya8TJ+fuNdDGPUCYw3z9imiDRS5brtEbzhK5LIu6UqbBS9VU8cNRTFkqFxqt3x
         +Z7dEQKKy3twuVwYsPPYxSwFclFALDBT8DBOsTeO75RcR/pYTQlRc39WEaLnD7DCFn
         bIavRq1ARxG5ESnwbCUULeA6pR4h0Jg7gVwyp1Wy3ZBTsZjOqSC0mm6OeG3Sdm+uhx
         t38dm/J9yMF4bVst4tLri6efsHY7bs0/WZlu2dYiHhhXQHG4TdUDR/4AWt8FkQRCkd
         efTgwWuQD4+MQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Date:   Mon, 20 Mar 2023 10:51:32 -0700
Message-Id: <20230320175144.153187-3-saeed@kernel.org>
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

Use a proper allocator for rmap entries using a naive for loop. The
allocator relies on whether an entry is NULL to be considered free.
Remove the used field of rmap which is not needed.

Also, avoid crashing the kernel if an entry is not available.

Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/cpu_rmap.h |  3 +--
 lib/cpu_rmap.c           | 26 +++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 7 deletions(-)

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
index e77f12bb3c77..e80ae6521f71 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -128,6 +128,17 @@ debug_print_rmap(const struct cpu_rmap *rmap, const char *prefix)
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
+	return -1;
+}
+
 /**
  * cpu_rmap_add - add object to a rmap
  * @rmap: CPU rmap allocated with alloc_cpu_rmap()
@@ -137,10 +148,11 @@ debug_print_rmap(const struct cpu_rmap *rmap, const char *prefix)
  */
 int cpu_rmap_add(struct cpu_rmap *rmap, void *obj)
 {
-	u16 index;
+	int index = get_free_index(rmap);
+
+	if (index == -1)
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
@@ -295,7 +307,11 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	glue->notify.release = irq_cpu_rmap_release;
 	glue->rmap = rmap;
 	cpu_rmap_get(rmap);
-	glue->index = cpu_rmap_add(rmap, glue);
+	rc = cpu_rmap_add(rmap, glue);
+	if (rc == -1)
+		return -ENOSPC;
+
+	glue->index = rc;
 	rc = irq_set_affinity_notifier(irq, &glue->notify);
 	if (rc) {
 		cpu_rmap_put(glue->rmap);
-- 
2.39.2

