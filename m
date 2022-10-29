Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBF4612565
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 23:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJ2VEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 17:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiJ2VEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 17:04:53 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Oct 2022 14:04:50 PDT
Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B656411461
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 14:04:48 -0700 (PDT)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id ostGo0hePez1rostGo2ToZ; Sat, 29 Oct 2022 22:57:15 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 29 Oct 2022 22:57:15 +0200
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] sfc: Fix an error handling path in efx_pci_probe()
Date:   Sat, 29 Oct 2022 22:57:11 +0200
Message-Id: <dc114193121c52c8fa3779e49bdd99d4b41344a9.1667077009.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs after the first kzalloc() the corresponding memory
allocation is never freed.

Add the missing kfree() in the error handling path, as already done in the
remove() function.

Fixes: 7e773594dada ("sfc: Separate efx_nic memory from net_device memory")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
When 7e773594dada was merged, sfc/ef100.c had the same issue.
But it seems to have been fixed in 98ff4c7c8ac7.
---
 drivers/net/ethernet/sfc/efx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 054d5ce6029e..0556542d7a6b 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1059,8 +1059,10 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 
 	/* Allocate and initialise a struct net_device */
 	net_dev = alloc_etherdev_mq(sizeof(probe_data), EFX_MAX_CORE_TX_QUEUES);
-	if (!net_dev)
-		return -ENOMEM;
+	if (!net_dev) {
+		rc = -ENOMEM;
+		goto fail0;
+	}
 	probe_ptr = netdev_priv(net_dev);
 	*probe_ptr = probe_data;
 	efx->net_dev = net_dev;
@@ -1132,6 +1134,8 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	WARN_ON(rc > 0);
 	netif_dbg(efx, drv, efx->net_dev, "initialisation failed. rc=%d\n", rc);
 	free_netdev(net_dev);
+ fail0:
+	kfree(probe_data);
 	return rc;
 }
 
-- 
2.34.1

