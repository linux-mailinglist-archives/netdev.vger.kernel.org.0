Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B911A52AD3C
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353134AbiEQVAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353124AbiEQVAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:00:06 -0400
Received: from smtp.smtpout.orange.fr (smtp03.smtpout.orange.fr [80.12.242.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156B5532CC
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:00:04 -0700 (PDT)
Received: from pop-os.home ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id r4ISnP1h2JXxRr4ISnYTVj; Tue, 17 May 2022 23:00:03 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 17 May 2022 23:00:03 +0200
X-ME-IP: 86.243.180.246
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sburla@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH v2 2/2] octeon_ep: Fix irq releasing in the error handling path of octep_request_irqs()
Date:   Tue, 17 May 2022 22:59:59 +0200
Message-Id: <d2fb2830e65081e2d15780bb5a5e1fb5d3602061.1652819974.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
References: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When taken, the error handling path does not undo correctly what has
already been allocated.

Introduce a new loop index, 'j', in order to simplify the error handling
path and rewrite part of it.
It is now written with the same logic and intermediate variables used
when resources are allocated. This is much more straightforward.

Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
v2: Introduce 'j' and use it in the 2nd for loop
    Rewrite the error handling path (Dan Carpenter)

v1:
    https://lore.kernel.org/all/a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr/
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 6b60a03574a0..a9b82d221780 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -202,7 +202,7 @@ static int octep_request_irqs(struct octep_device *oct)
 	struct msix_entry *msix_entry;
 	char **non_ioq_msix_names;
 	int num_non_ioq_msix;
-	int ret, i;
+	int ret, i, j;
 
 	num_non_ioq_msix = CFG_GET_NON_IOQ_MSIX(oct->conf);
 	non_ioq_msix_names = CFG_GET_NON_IOQ_MSIX_NAMES(oct->conf);
@@ -233,23 +233,23 @@ static int octep_request_irqs(struct octep_device *oct)
 	}
 
 	/* Request IRQs for Tx/Rx queues */
-	for (i = 0; i < oct->num_oqs; i++) {
-		ioq_vector = oct->ioq_vector[i];
-		msix_entry = &oct->msix_entries[i + num_non_ioq_msix];
+	for (j = 0; j < oct->num_oqs; j++) {
+		ioq_vector = oct->ioq_vector[j];
+		msix_entry = &oct->msix_entries[j + num_non_ioq_msix];
 
 		snprintf(ioq_vector->name, sizeof(ioq_vector->name),
-			 "%s-q%d", netdev->name, i);
+			 "%s-q%d", netdev->name, j);
 		ret = request_irq(msix_entry->vector,
 				  octep_ioq_intr_handler, 0,
 				  ioq_vector->name, ioq_vector);
 		if (ret) {
 			netdev_err(netdev,
 				   "request_irq failed for Q-%d; err=%d",
-				   i, ret);
+				   j, ret);
 			goto ioq_irq_err;
 		}
 
-		cpumask_set_cpu(i % num_online_cpus(),
+		cpumask_set_cpu(j % num_online_cpus(),
 				&ioq_vector->affinity_mask);
 		irq_set_affinity_hint(msix_entry->vector,
 				      &ioq_vector->affinity_mask);
@@ -257,10 +257,13 @@ static int octep_request_irqs(struct octep_device *oct)
 
 	return 0;
 ioq_irq_err:
-	while (i > num_non_ioq_msix) {
-		--i;
-		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
-		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
+	while (j) {
+		--j;
+		ioq_vector = oct->ioq_vector[j];
+		msix_entry = &oct->msix_entries[j + num_non_ioq_msix];
+
+		irq_set_affinity_hint(msix_entry->vector, NULL);
+		free_irq(msix_entry->vector, ioq_vector);
 	}
 non_ioq_irq_err:
 	while (i) {
-- 
2.34.1

