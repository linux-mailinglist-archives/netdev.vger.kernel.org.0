Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30041650450
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiLRSaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 13:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiLRS3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 13:29:33 -0500
Received: from smtp.smtpout.orange.fr (smtp-26.smtpout.orange.fr [80.12.242.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C898E22B
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 10:08:51 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id 6y5fpvYLi8ao36y5fpZW7m; Sun, 18 Dec 2022 19:08:49 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Dec 2022 19:08:49 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Chris Lee <christopher.lee@cspi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrew Gallatin <gallatin@myri.com>,
        Brice Goglin <brice@myri.com>, Jeff Garzik <jgarzik@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] myri10ge: Fix an error handling path in myri10ge_probe()
Date:   Sun, 18 Dec 2022 19:08:40 +0100
Message-Id: <f03711f1d0919017c081e273e16afd9009874fd4.1671386898.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some memory allocated in myri10ge_probe_slices() is not released in the
error handling path of myri10ge_probe().

Add the corresponding kfree(), as already done in the remove function.

Fixes: 0dcffac1a329 ("myri10ge: add multislices support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 8073d7a90a26..c5687d94ea88 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3912,6 +3912,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_free_slices(mgp);
 
 abort_with_firmware:
+	kfree(mgp->msix_vectors);
 	myri10ge_dummy_rdma(mgp, 0);
 
 abort_with_ioremap:
-- 
2.34.1

