Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0809E3C143F
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhGHN1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:27:21 -0400
Received: from 185-125-188-181.canonical.com ([185.125.188.181]:51514 "EHLO
        smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229901AbhGHN1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:27:20 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jul 2021 09:27:19 EDT
Received: from localhost.localdomain (unknown [222.129.38.167])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F2B09401BE;
        Thu,  8 Jul 2021 13:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1625750250;
        bh=MZaGHZileR4ok+NZSlM+m9Pz61MDdpoPPs63678sG9k=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=wMlumXYlpN0n/yclDWu8glv34+OE5e0kLicAgCmYuQYhooP++yNldYLDdRuvlfmMQ
         BqdNhedF+Mfuhy2JwCRXw32TA6a60kOOjQZvu9oMvJfCmrJtfLzJin2ofDqxvARj2T
         cRI5yhvpa9IfaHbXJcRelXo99qJhAyPaepiAE5Ct149Qnwga5x635TBdgb/12ufHLk
         Qer4qH9flcYO5EAVOSfiNgEcy3VUjw3fCFJh+FHBFjlj3QRQtDIK41O/RRsY/9el0H
         N+XkWQGk7lO0M1Ho1AnJetVAyLs949u51jOeyn5mQ9qXWsLl2UZmFXFwjhzWtPuzhR
         OV/hhV6yQUJjA==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com, sean.wang@mediatek.com,
        Soul.Huang@mediatek.com, deren.wu@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] mt76: mt7921: continue to probe driver when fw already downloaded
Date:   Thu,  8 Jul 2021 21:17:10 +0800
Message-Id: <20210708131710.695595-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When reboot system, no power cycles, firmware is already downloaded,
return -EIO will break driver as error:
mt7921e: probe of 0000:03:00.0 failed with error -5

Skip firmware download and continue to probe.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index c2c4dc196802..cd690c64f65b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -931,7 +931,7 @@ static int mt7921_load_firmware(struct mt7921_dev *dev)
 	ret = mt76_get_field(dev, MT_CONN_ON_MISC, MT_TOP_MISC2_FW_N9_RDY);
 	if (ret) {
 		dev_dbg(dev->mt76.dev, "Firmware is already download\n");
-		return -EIO;
+		goto fw_loaded;
 	}
 
 	ret = mt7921_load_patch(dev);
@@ -949,6 +949,7 @@ static int mt7921_load_firmware(struct mt7921_dev *dev)
 		return -EIO;
 	}
 
+fw_loaded:
 	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_FWDL], false);
 
 #ifdef CONFIG_PM
-- 
2.32.0

