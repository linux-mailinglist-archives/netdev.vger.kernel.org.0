Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FAA4686A5
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 18:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385253AbhLDRm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 12:42:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43280 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385247AbhLDRm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 12:42:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A8E60AE0;
        Sat,  4 Dec 2021 17:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11754C341C0;
        Sat,  4 Dec 2021 17:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638639569;
        bh=rXm5f+w8zJdRjZd/08cu7eGF5p64j7gfTbLFnnwiDFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unGVyD3y/1S13VNXCbpJl98HfgtM+zgjFdTT8xFOVa2FjzWHg98H+yymCmLLowcc5
         qXUVBBWNRpmCVhFT3SrOC/VRYVTrBfU64iUYfWZZZLBO7eMO9bwyDlLgefI7PBBKIk
         Ly84Q+05R/ICIsL94wS6PJP/HtCYpZbMEeh/C1Dj1SsgINR61RlsFw+rIwjgCkjrDK
         Q7Q1g7Y8VVHp7W9zkex8GjVMhTVzLxgldFypCEEpKZMehIR9scT90bUyprTYeB6rRT
         PJ6V24x9UZUL9wYnny90sIxMNhUew/undG8Ru4x+k9q/vGHGSrRYsyT/BCMktMfIca
         Fc1Klfhq3cPhA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] mt76: mt7921: fix build regression
Date:   Sat,  4 Dec 2021 18:38:35 +0100
Message-Id: <20211204173848.873293-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211204173848.873293-1-arnd@kernel.org>
References: <20211204173848.873293-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

After mt7921s got added, there are two possible build problems:

a) mt7921s does not get built at all if mt7921e is not also enabled

b) there is a link error when mt7921e is a loadable module, but mt7921s
configured as built-in:

ERROR: modpost: "mt7921_mac_sta_add" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mac_sta_assoc" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mac_sta_remove" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mac_write_txwi" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mcu_drv_pmctrl" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mcu_fill_message" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_mcu_parse_response" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_ops" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_queue_rx_skb" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!
ERROR: modpost: "mt7921_update_channel" [drivers/net/wireless/mediatek/mt76/mt7921/mt7921e.ko] undefined!

Fix both by making sure that Kbuild enters the subdirectory when
either one is enabled.

Fixes: 48fab5bbef40 ("mt76: mt7921: introduce mt7921s support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 79ab850a45a2..c78ae4b89761 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -34,4 +34,4 @@ obj-$(CONFIG_MT76x2_COMMON) += mt76x2/
 obj-$(CONFIG_MT7603E) += mt7603/
 obj-$(CONFIG_MT7615_COMMON) += mt7615/
 obj-$(CONFIG_MT7915E) += mt7915/
-obj-$(CONFIG_MT7921E) += mt7921/
+obj-$(CONFIG_MT7921_COMMON) += mt7921/
-- 
2.29.2

