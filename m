Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6EF55B2C8
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 18:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiFZQ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 12:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFZQ1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 12:27:54 -0400
Received: from smtp.smtpout.orange.fr (smtp06.smtpout.orange.fr [80.12.242.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF36ABC3D
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 09:27:50 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 5V6xoYQJBm7vs5V6xoSSv7; Sun, 26 Jun 2022 18:27:48 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 26 Jun 2022 18:27:48 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] hinic: Use the bitmap API when applicable
Date:   Sun, 26 Jun 2022 18:27:45 +0200
Message-Id: <6ff7b7d21414240794a77dc2456914412718a145.1656260842.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
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

'vlan_bitmap' is a bitmap and is used as such. So allocate it with
devm_bitmap_zalloc() and its explicit bit size (i.e. VLAN_N_VID).

This avoids the need of the VLAN_BITMAP_SIZE macro which:
   - needlessly has a 'nic_dev' parameter
   - should be "long" (and not byte) aligned, so that the bitmap semantic
     is respected

This is in fact not an issue because VLAN_N_VID is 4096 at the time
being, but devm_bitmap_zalloc() is less verbose and easier to understand.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 05329292d940..56a89793f47d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -62,8 +62,6 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 
 #define HINIC_LRO_RX_TIMER_DEFAULT	16
 
-#define VLAN_BITMAP_SIZE(nic_dev)       (ALIGN(VLAN_N_VID, 8) / 8)
-
 #define work_to_rx_mode_work(work)      \
 		container_of(work, struct hinic_rx_mode_work, work)
 
@@ -1242,9 +1240,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 	u64_stats_init(&tx_stats->syncp);
 	u64_stats_init(&rx_stats->syncp);
 
-	nic_dev->vlan_bitmap = devm_kzalloc(&pdev->dev,
-					    VLAN_BITMAP_SIZE(nic_dev),
-					    GFP_KERNEL);
+	nic_dev->vlan_bitmap = devm_bitmap_zalloc(&pdev->dev, VLAN_N_VID,
+						  GFP_KERNEL);
 	if (!nic_dev->vlan_bitmap) {
 		err = -ENOMEM;
 		goto err_vlan_bitmap;
-- 
2.34.1

