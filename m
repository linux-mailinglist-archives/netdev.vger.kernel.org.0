Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE31499CC
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgAZJU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:20:56 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:40607 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgAZJU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:20:56 -0500
Received: from localhost.localdomain ([93.23.15.185])
        by mwinf5d07 with ME
        id uxLl2100n3zZxD103xLmMA; Sun, 26 Jan 2020 10:20:54 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 26 Jan 2020 10:20:54 +0100
X-ME-IP: 93.23.15.185
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     claudiu.manoil@nxp.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] gianfar: Allocate the correct number of rx queues in 'gfar_of_init()'
Date:   Sun, 26 Jan 2020 10:20:28 +0100
Message-Id: <20200126092028.14246-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can get values for rx and tx queues from "fsl,num_rx_queues" and
"fsl,num_tx_queues". However, when 'alloc_etherdev_mq()' is called, the
value for "tx" is used for both.

Use 'alloc_etherdev_mqs()' instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
WARNING: This patch is purely speculative!

I don't fully understand the code, and tx and rx queues seem to be
allocated by 'gfar_alloc_[rt]x_queues()' and handled with priv-> fields.
I don't know the relationship between queues provided by the core, and the
ones specificly handled in this driver.

'netif_set_real_num_rx_queues()' a few lines below is also spurious to me.
If "fsl,num_rx_queues" > "fsl,num_tx_queues" it will return an error and
things then look out of synch (i.e. 'priv->num_rx_queues' is set to a value
bigger than what is allocated by core, that is to say the one from
'priv->num_tx_queues')

If my assumptions are correct, I guess that the call to
'netif_set_real_num_rx_queues()' is useless


Sorry for the noise if I'm completly wrong.
In such a case, some explanation would be appreciated.
---
 drivers/net/ethernet/freescale/gianfar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 72868a28b621..5e934069682e 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -708,7 +708,7 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 		return -EINVAL;
 	}
 
-	*pdev = alloc_etherdev_mq(sizeof(*priv), num_tx_qs);
+	*pdev = alloc_etherdev_mqs(sizeof(*priv), num_tx_qs, num_rx_qs);
 	dev = *pdev;
 	if (NULL == dev)
 		return -ENOMEM;
-- 
2.20.1

