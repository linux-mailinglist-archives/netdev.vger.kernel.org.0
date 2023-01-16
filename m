Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A668466C3CB
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjAPP0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjAPP0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:26:20 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9310423C44;
        Mon, 16 Jan 2023 07:22:54 -0800 (PST)
Received: from localhost.localdomain (unknown [222.129.38.177])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D5AC53F177;
        Mon, 16 Jan 2023 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1673882572;
        bh=WShhfjt/HHh0NshNOvMg+g+72tOEAis9r62sjM//RqY=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=ipYD4Y0OQQUCmjI0C9LbgmGfDgYwAkymK/5e/Hm2HEncGkBXrPt6rWG4g2D5mZJw9
         Jgh33MGAUY9aRlbwCPMOzuLugGeO2D+8C3MtWLMv2RhFihPvI2moS5LaKJxYRfGeou
         unqi8CB9nANne05yDdaF+DFbXVvI2a+poruvmdBKVNmVhi3I5oq7Sxk+cKkNGRNH35
         nyl19EjLjhj5l8xQuiJlovuSohVQKYp/TQXmWquO4QakI2KX0eFlKVYxpFjSXCsGcJ
         HgXeiX8euL1TqKoq7Cz/Xb/edl4DhoproU6nP75142a2fzH77iLu3OQE4RF0S7cl96
         3vcYvYlnmWQQQ==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        aaron.ma@canonical.com
Subject: [PATCH] wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read
Date:   Mon, 16 Jan 2023 23:22:35 +0800
Message-Id: <20230116152235.1433484-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel NULL pointer dereference when ACPI SAR table isn't implemented well.
Fix the error code of return to mark the ACPI SAR table as invalid.

[    5.077128] mt7921e 0000:06:00.0: sar cnt = 0
[    5.077381] BUG: kernel NULL pointer dereference, address:
0000000000000004
[    5.077630] #PF: supervisor read access in kernel mode
[    5.077883] #PF: error_code(0x0000) - not-present page
[    5.078138] PGD 0 P4D 0
[    5.078398] Oops: 0000 [#1] PREEMPT SMP NOPTI
[    5.079202] RIP: 0010:mt7921_init_acpi_sar+0x106/0x220
[mt7921_common]
...
[    5.080786] Call Trace:
[    5.080786]  <TASK>
[    5.080786]  mt7921_register_device+0x37d/0x490 [mt7921_common]
[    5.080786]  mt7921_pci_probe.part.0+0x2ee/0x310 [mt7921e]
[    5.080786]  mt7921_pci_probe+0x52/0x70 [mt7921e]
[    5.080786]  local_pci_probe+0x47/0x90
[    5.080786]  pci_call_probe+0x55/0x190
[    5.080786]  pci_device_probe+0x84/0x120

Fixes: f965333e491e ("mt76: mt7921: introduce ACPI SAR support")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
index 47e034a9b003..ed9241d4aa64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
@@ -33,14 +33,17 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 	    sar_root->package.elements[0].type != ACPI_TYPE_INTEGER) {
 		dev_err(mdev->dev, "sar cnt = %d\n",
 			sar_root->package.count);
+		ret = -EINVAL;
 		goto free;
 	}
 
 	if (!*tbl) {
 		*tbl = devm_kzalloc(mdev->dev, sar_root->package.count,
 				    GFP_KERNEL);
-		if (!*tbl)
+		if (!*tbl) {
+			ret = -ENOMEM;
 			goto free;
+		}
 	}
 	if (len)
 		*len = sar_root->package.count;
@@ -52,9 +55,9 @@ mt7921_acpi_read(struct mt7921_dev *dev, u8 *method, u8 **tbl, u32 *len)
 			break;
 		*(*tbl + i) = (u8)sar_unit->integer.value;
 	}
-free:
 	ret = (i == sar_root->package.count) ? 0 : -EINVAL;
 
+free:
 	kfree(sar_root);
 
 	return ret;
-- 
2.34.1

