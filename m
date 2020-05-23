Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D961DF5F7
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 10:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgEWIIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 04:08:37 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:10362 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387500AbgEWIIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 04:08:36 -0400
Received: from localhost.localdomain (unknown [222.205.77.158])
        by mail-app2 (Coremail) with SMTP id by_KCgD3_5P02che+eO4AQ--.44369S4;
        Sat, 23 May 2020 16:08:24 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: smsc911x: Fix runtime PM imbalance on error
Date:   Sat, 23 May 2020 16:08:20 +0800
Message-Id: <20200523080820.13476-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgD3_5P02che+eO4AQ--.44369S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4DCr17trykKr1rJFyUAwb_yoW8Xw13pa
        1xXa4rWr1SqryYyr4DJr1DZFW3Aay7trZagrs7Kw1fZw1Yya4vqF4xtryaqF1kJrW0yr1f
        tF4qv34fCFs5ArUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUva1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8ZwCF04k20xvY0x0EwIxG
        rwCF04k20xvE74AGY7Cv6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
        Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r12
        6r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
        kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv
        67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyT
        uYvjfUeHUDDUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgQJBlZdtORGcwADsk
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove runtime PM usage counter decrement when the
increment function has not been called to keep the
counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/smsc/smsc911x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 49a6a9167af4..fc168f85e7af 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -2493,20 +2493,20 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 
 	retval = smsc911x_init(dev);
 	if (retval < 0)
-		goto out_disable_resources;
+		goto out_init_fail;
 
 	netif_carrier_off(dev);
 
 	retval = smsc911x_mii_init(pdev, dev);
 	if (retval) {
 		SMSC_WARN(pdata, probe, "Error %i initialising mii", retval);
-		goto out_disable_resources;
+		goto out_init_fail;
 	}
 
 	retval = register_netdev(dev);
 	if (retval) {
 		SMSC_WARN(pdata, probe, "Error %i registering device", retval);
-		goto out_disable_resources;
+		goto out_init_fail;
 	} else {
 		SMSC_TRACE(pdata, probe,
 			   "Network interface: \"%s\"", dev->name);
@@ -2547,9 +2547,10 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_disable_resources:
+out_init_fail:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+out_disable_resources:
 	(void)smsc911x_disable_resources(pdev);
 out_enable_resources_fail:
 	smsc911x_free_resources(pdev);
-- 
2.17.1

