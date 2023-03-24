Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EF6C8915
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 00:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbjCXXOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbjCXXOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 19:14:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D7E166F8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 16:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F93EB82664
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 23:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C64C4339B;
        Fri, 24 Mar 2023 23:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679699631;
        bh=R5Dcu4im8mTB1GPdKaBdvzPMm6a86ne4BJngQDovN54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeIcrvtDpYDnUDqqliP4EAVmyyIPgxKnxd3osuBpQSxt4alYmSHIMEGfQWkMQ4hQB
         d0Ilyrwn1MXrt04mApidkimT0IcuZ0zuiCZARnysbKrdoT7s/jZwHD7QbxFXgHFG5p
         kVzV0bQY5ZX+ZHwRxx4ehsRbW7GG/W6R1j/3sH0FBfLFWQyQpUsKGE2NZ9p8e/bcuq
         Jl9q8uHB0IcB12oeNTrfwK4lzRlp2Hkblw1REYH2uwW06iChCJ+4SFXeJmHAb9EYrd
         BJoa3M+lneIwo9WiDgbhO4BWQJ7I4FISiW6aBkWJWBX8x/ZC9gAxJnV0SxGaQCktr7
         0BWo4JnY/HSBg==
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
Subject: [net-next V2 01/15] lib: cpu_rmap: Avoid use after free on rmap->obj array entries
Date:   Fri, 24 Mar 2023 16:13:27 -0700
Message-Id: <20230324231341.29808-2-saeed@kernel.org>
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

When calling irq_set_affinity_notifier() with NULL at the notify
argument, it will cause freeing of the glue pointer in the
corresponding array entry but will leave the pointer in the array. A
subsequent call to free_irq_cpu_rmap() will try to free this entry again
leading to possible use after free.

Fix that by setting NULL to the array entry and checking that we have
non-zero at the array entry when iterating over the array in
free_irq_cpu_rmap().

The current code does not suffer from this since there are no cases
where irq_set_affinity_notifier(irq, NULL) (note the NULL passed for the
notify arg) is called, followed by a call to free_irq_cpu_rmap() so we
don't hit and issue. Subsequent patches in this series excersize this
flow, hence the required fix.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

