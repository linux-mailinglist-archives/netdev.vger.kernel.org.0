Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89069C539
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBTGRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjBTGQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:16:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460DCCDC4;
        Sun, 19 Feb 2023 22:16:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDE4660CBB;
        Mon, 20 Feb 2023 06:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FF6C4339C;
        Mon, 20 Feb 2023 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873814;
        bh=AkzmOYv2R3+KnWodinjT0tOoD5/NytiDQasvqL4pbCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URzNFbOIS0pIyamvT4jTyXJ2DoQDrMCu9hbTMDfFWj27tkmX8HBu6x0Q2EV7rsR+v
         31u+KC1jzNHfrqCBBALpKj7dTqG0m7d9jBLn6e2+TpPczbRMJ1DCxG3KFzi7wRkHx/
         9INKg8nR+inAukOUXX8DDzZrw+6MJ9x8GAqinVEGJClf1LJjBJ2ty9VW3b7OyAbb05
         mGVNm2bVOE2qYjyEcIkON5IYKRUqHyGTr5Wi6C4fm1JFqgh7/Lxzo+gjwgOhDZlFvl
         4xqwOSENCoukohBBkypjYICvwN5rMIQnCpBOJuGaRDgK3jhQQgXnV/LeVsluCKtzxp
         RmblhigstcELA==
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
Subject: [PATCH net-next 01/14] lib: cpu_rmap: Avoid use after free on rmap->obj array entries
Date:   Sun, 19 Feb 2023 22:14:29 -0800
Message-Id: <20230220061442.403092-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230220061442.403092-1-saeed@kernel.org>
References: <20230220061442.403092-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
CC: Ben Hutchings <bhutchings@solarflare.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>
CC: Eric Dumazet <edumazet@google.com>
CC: linux-kernel@vger.kernel.org
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
2.39.1

