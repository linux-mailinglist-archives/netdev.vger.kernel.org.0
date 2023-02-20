Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFA769C53F
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjBTGRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBTGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:17:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B1AE3BF;
        Sun, 19 Feb 2023 22:16:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C90DB80AD5;
        Mon, 20 Feb 2023 06:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25AD5C4339C;
        Mon, 20 Feb 2023 06:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676873816;
        bh=pMGv4SyPGRfo0WP/fzR89zfuG2L3rq94hSEQU95SGQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xz9rd/k+vqLfQfG/5nnow/aShk3NQ8eDrOW34XYBtLHFhdGA1kdJo+GxeIusTkfy0
         6lG4xJUXdfoWby51siTH5ZznVke79q1P9/grJL1kBt3npKisp77mmxorbw7YKTT1Yh
         mhZaTXVOQhfhpVFgwKIfZPTCajUy9IUPWLJp1FhFtTmYJLleIPIEpqzhjIcPw9qUzr
         lfirAOiDUWAo/0Hjguk/PnIA2+hw6PMAkgBGWwlCFUjM5ll8h7yJkxG3K3OISU6G05
         k4XPVH46ywBz+OZpKSmL0ahW2NApCDG7ekhylN6GDmufqnjsYBIx6rNZ5WA8oHVfR9
         4DdDs0yJrQ3Dg==
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
Subject: [PATCH net-next 03/14] lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
Date:   Sun, 19 Feb 2023 22:14:31 -0800
Message-Id: <20230220061442.403092-4-saeed@kernel.org>
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

Add a function to complement irq_cpu_rmap_add(). It removes the irq from
the reverse mapping by setting the notifier to NULL.

CC: Ben Hutchings <bhutchings@solarflare.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>
CC: Eric Dumazet <edumazet@google.com>
CC: linux-kernel@vger.kernel.org
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
index e95d018e01c2..7c67e9382845 100644
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
2.39.1

