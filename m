Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98DA649003
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLJRfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 12:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLJRfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 12:35:13 -0500
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E54618B3F
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 09:35:10 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 43kgp2tOxbw2u43kgpGtEJ; Sat, 10 Dec 2022 18:35:08 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 10 Dec 2022 18:35:08 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vamsi Attunuru <vattunuru@marvell.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions
Date:   Sat, 10 Dec 2022 18:35:00 +0100
Message-Id: <69f153db5152a141069f990206e7389f961d41ec.1670693669.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mcs_register_interrupts(), a call to request_irq() is not balanced by a
corresponding free_irq(), neither in the error handling path, nor in the
remove function.

Add the missing calls.

Fixes: 6c635f78c474 ("octeontx2-af: cn10k: mcs: Handle MCS block interrupts")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is untested and speculative.
I'm always reluctant to send patches around irq management, because it is
sometimes tricky.
Review with care!

Maybe introducing a mcs_unregister_interrupts() function would be cleaner
and more future proof.
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index c0bedf402da9..f68a6a0e3aa4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -1184,10 +1184,13 @@ static int mcs_register_interrupts(struct mcs *mcs)
 	mcs->tx_sa_active = alloc_mem(mcs, mcs->hw->sc_entries);
 	if (!mcs->tx_sa_active) {
 		ret = -ENOMEM;
-		goto exit;
+		goto free_irq;
 	}
 
 	return ret;
+
+free_irq:
+	free_irq(pci_irq_vector(mcs->pdev, MCS_INT_VEC_IP), mcs);
 exit:
 	pci_free_irq_vectors(mcs->pdev);
 	mcs->num_vec = 0;
@@ -1589,6 +1592,7 @@ static void mcs_remove(struct pci_dev *pdev)
 
 	/* Set MCS to external bypass */
 	mcs_set_external_bypass(mcs, true);
+	free_irq(pci_irq_vector(pdev, MCS_INT_VEC_IP), mcs);
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
2.34.1

