Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B004EB1B1
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiC2QTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239561AbiC2QTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:19:36 -0400
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Mar 2022 09:17:53 PDT
Received: from mint-fitpc2.localdomain (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6B3BA18FACB
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 09:17:53 -0700 (PDT)
Received: from palantir17.mph.net (palantir17 [192.168.0.4])
        by mint-fitpc2.localdomain (Postfix) with ESMTP id 17CD83200AE;
        Tue, 29 Mar 2022 17:07:50 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nZENp-00027e-M9; Tue, 29 Mar 2022 17:07:49 +0100
Subject: [PATCH net] sfc: Avoid NULL pointer dereference on systems without
 numa awareness
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ihuguet@redhat.com, ecree.xilinx@gmail.com
Date:   Tue, 29 Mar 2022 17:07:49 +0100
Message-ID: <164857006953.8140.3265568858101821256.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=4.4 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On such systems cpumask_of_node() returns NULL, which bitmap
operations are not happy with.

Fixes: c265b569a45f ("sfc: default config to 1 channel/core in local NUMA node only")
Fixes: 09a99ab16c60 ("sfc: set affinity hints in local NUMA node only")
Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_channels.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index d6fdcdc530ca..f9064532beb6 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -91,11 +91,9 @@ static unsigned int count_online_cores(struct efx_nic *efx, bool local_node)
 	}
 
 	cpumask_copy(filter_mask, cpu_online_mask);
-	if (local_node) {
-		int numa_node = pcibus_to_node(efx->pci_dev->bus);
-
-		cpumask_and(filter_mask, filter_mask, cpumask_of_node(numa_node));
-	}
+	if (local_node)
+		cpumask_and(filter_mask, filter_mask,
+			    cpumask_of_pcibus(efx->pci_dev->bus));
 
 	count = 0;
 	for_each_cpu(cpu, filter_mask) {
@@ -386,8 +384,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 #if defined(CONFIG_SMP)
 void efx_set_interrupt_affinity(struct efx_nic *efx)
 {
-	int numa_node = pcibus_to_node(efx->pci_dev->bus);
-	const struct cpumask *numa_mask = cpumask_of_node(numa_node);
+	const struct cpumask *numa_mask = cpumask_of_pcibus(efx->pci_dev->bus);
 	struct efx_channel *channel;
 	unsigned int cpu;
 

