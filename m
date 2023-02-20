Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D356569C53D
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjBTGRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjBTGRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF020CC3F;
        Sun, 19 Feb 2023 22:16:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 881B7B80A4A;
        Mon, 20 Feb 2023 06:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8CFC433EF;
        Mon, 20 Feb 2023 06:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873815;
        bh=GOZ4JdcYU9TtiKTGvXlNiyr92ooWCZWs/0NVfAXBMhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnNyWAKl351YOqbSFIUACAlXRFwipftu5Z4+0bgrsJ/9O28Sm5Mps1XVuuIPFqqOS
         WJdD2WO/d6Fk0C4tne0SfIgu7XF8W1J97zpxKMqFW8TEXTtCvrHYLZprttu4isQz5o
         AdjIaL3MWbVvgmSQv5IRruVGavd4weVi9yWb2Qmp9j9NpOQBmC7i23IjBaAfd/Z2Kv
         1I0tlywTbaGKI92oihSSbfdn1eGCebnAhrmrciP7JBE3SufG8TEeAjTltyoQjt51Ug
         tBmr1VDUyIwPAoAyznzpsejTYc1Pr1gzlvKpz2NA75i38BEkVnIWQlxApsf84qjhEC
         KZLYkHdGhRzBg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Decotigny <decot@googlers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 02/14] lib: cpu_rmap: Use allocator for rmap entries
Date:   Sun, 19 Feb 2023 22:14:30 -0800
Message-Id: <20230220061442.403092-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
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

CC: Ben Hutchings <bhutchings@solarflare.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>
CC: Eric Dumazet <edumazet@google.com>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/cpu_rmap.h |  3 +--
 lib/cpu_rmap.c           | 23 +++++++++++++++++++----
 2 files changed, 20 insertions(+), 6 deletions(-)

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
index e77f12bb3c77..e95d018e01c2 100644
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
+	u16 index = get_free_index(rmap);
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
@@ -296,6 +308,9 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	glue->rmap = rmap;
 	cpu_rmap_get(rmap);
 	glue->index = cpu_rmap_add(rmap, glue);
+	if (glue->index == -1)
+		return -ENOSPC;
+
 	rc = irq_set_affinity_notifier(irq, &glue->notify);
 	if (rc) {
 		cpu_rmap_put(glue->rmap);
-- 
2.39.1

