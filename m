Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1516C1EB8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCTR6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjCTR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:58:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11444166CE
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 10:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE552B8105C
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 17:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CF70C433EF;
        Mon, 20 Mar 2023 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679334707;
        bh=2y0B517d8f0E345yxjD1dtPfGi8DD+AXXdIGVqX/PqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yqy4UMx9GFRLyt2WBpZrl2ksJdBDY5uAh6msDa9HGwy8hyxNMLPXVN5hb5WM/zzn7
         rn7tvJHSRiJtqVA6Z9UEuP1HdSlu2MJpliAOUR6F57eshXVXUe6UeypGvjcQBcL5n2
         rCYN3CR/Q2PNNUk2Eir7bLdUIh6c6vz4vpcBTvtLVTinW5+6YFBlJTOMyeLddJswTA
         3Fo6EPkgD4d/t78UOTs8H3Dw7RMIwNEqcayA6RwALLZjGXK4sNjRrS9tMXW0FFS64m
         mNNPZK3USnJRkMOmy5W7/rGMY4hvSedXdABybi+82JsmdoQzZtF/tAi9irj9MRUOcg
         irXExW6xeLFZw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: [net-next 01/14] lib: cpu_rmap: Avoid use after free on rmap->obj array entries
Date:   Mon, 20 Mar 2023 10:51:31 -0700
Message-Id: <20230320175144.153187-2-saeed@kernel.org>
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

When calling irq_set_affinity_notifier() with NULL at the notify
argument, it will cause freeing of the glue pointer in the
corresponding array entry but will leave the pointer in the array. A
subsequent call to free_irq_cpu_rmap() will try to free this entry again
leading to possible use after free.

Fix that by setting NULL to the array entry and checking that we have
non-zero at the array entry when iterating over the array in
free_irq_cpu_rmap().

Fixes: c39649c331c7 ("lib: cpu_rmap: CPU affinity reverse-mapping")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 lib/cpu_rmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index f08d9c56f712..e77f12bb3c77 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -232,7 +232,8 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
 
 	for (index = 0; index < rmap->used; index++) {
 		glue = rmap->obj[index];
-		irq_set_affinity_notifier(glue->notify.irq, NULL);
+		if (glue)
+			irq_set_affinity_notifier(glue->notify.irq, NULL);
 	}
 
 	cpu_rmap_put(rmap);
@@ -268,6 +269,7 @@ static void irq_cpu_rmap_release(struct kref *ref)
 		container_of(ref, struct irq_glue, notify.kref);
 
 	cpu_rmap_put(glue->rmap);
+	glue->rmap->obj[glue->index] = NULL;
 	kfree(glue);
 }
 
@@ -297,6 +299,7 @@ int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq)
 	rc = irq_set_affinity_notifier(irq, &glue->notify);
 	if (rc) {
 		cpu_rmap_put(glue->rmap);
+		rmap->obj[glue->index] = NULL;
 		kfree(glue);
 	}
 	return rc;
-- 
2.39.2

