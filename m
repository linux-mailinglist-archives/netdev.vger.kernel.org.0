Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB196039D6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiJSGii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJSGih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:38:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0326D841
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892DB61782
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E40C433B5;
        Wed, 19 Oct 2022 06:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161516;
        bh=JJx00aAAtwUypuCtcolO+cWhVO7D9ur6mP4+srJ//2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMHxL41THkl5ScI4gYCFo7+Jc6U54APKjhKuLUErjdCiv22ZgqA6drDVhwfaff/UN
         D8+5vVMZfXdarNsSpK2OuHQr18Yet5FN9Yjak7tMVnN7tLXWnWALVkjat5TRpy5Vn4
         gN8bFqrk9hXFspHLLutWWBKGTrlRy4LyEBlHXIXiwlhW+bLcETmlB0EqBv36xY0Smn
         41XIXkH+Jd9EBSET4gNcnIZGtjtZGVoumVXgFKuoU6neGziQEbD57vUY1iCIIaJXuk
         TWNosGIIH+Hh9Fblxtx6c65jjdnv7JEKoF1XmpuH8RaJ8P5msR2pC1u2ssnNIUy661
         AM3IVooA7DE7Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net 02/16] net/mlx5: Wait for firmware to enable CRS before pci_restore_state
Date:   Tue, 18 Oct 2022 23:37:59 -0700
Message-Id: <20221019063813.802772-3-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

After firmware reset driver should verify firmware already enabled CRS
and became responsive to pci config cycles before restoring pci state.
Fix that by waiting till device_id is readable through PCI again.

Fixes: eabe8e5e88f5 ("net/mlx5: Handle sync reset now event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fw_reset.c  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index e8896f368362..07c583996c29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -358,6 +358,23 @@ static int mlx5_pci_link_toggle(struct mlx5_core_dev *dev)
 		err = -ETIMEDOUT;
 	}
 
+	do {
+		err = pci_read_config_word(dev->pdev, PCI_DEVICE_ID, &reg16);
+		if (err)
+			return err;
+		if (reg16 == dev_id)
+			break;
+		msleep(20);
+	} while (!time_after(jiffies, timeout));
+
+	if (reg16 == dev_id) {
+		mlx5_core_info(dev, "Firmware responds to PCI config cycles again\n");
+	} else {
+		mlx5_core_err(dev, "Firmware is not responsive (0x%04x) after %llu ms\n",
+			      reg16, mlx5_tout_ms(dev, PCI_TOGGLE));
+		err = -ETIMEDOUT;
+	}
+
 restore:
 	list_for_each_entry(sdev, &bridge_bus->devices, bus_list) {
 		pci_cfg_access_unlock(sdev);
-- 
2.37.3

