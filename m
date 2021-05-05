Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A31374471
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234772AbhEEQ5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:57:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236415AbhEEQyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:54:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB8D61461;
        Wed,  5 May 2021 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232710;
        bh=VWFWm5cUN1jSxsItT/U9HhoMnGvxh07KV69SrLyK5ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8LuGWZ0CFj/j9LrHALciQam79aHAsxzB46F5Zd+SozCbu61OLfawa3NqI4nGC9vc
         uO/fjc3WFz8z1p/ui/kiXc1LIWmlvdXUkDsAGCHSEFVQTCN9wYZgJw0dLThgsmOFpB
         HRNIo5MXFVNX8Z+bfkcQc0yRfYpWYBWmI9tvLkJx6358qnA8G+sYmDWG11db2pViYQ
         1/GQc/1UkMp9nTwhVGwbmDIiIMkpOXk11UOQ7m55Iofw4vPCe+MiqkLeUex2CP+qkb
         Lc26wgxXCzxoXUN1FzXA/mzNwBU8i64JP0DxAHgmyds6GrNT+/RlHLKZfJKmSO/ern
         VpobiP70NR+hg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 69/85] mt76: mt7615: fix entering driver-own state on mt7663
Date:   Wed,  5 May 2021 12:36:32 -0400
Message-Id: <20210505163648.3462507-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5c7d374444afdeb9dd534a37c4f6c13af032da0c ]

Fixes hardware wakeup issues

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index c31036f57aef..62a971660da7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -341,12 +341,20 @@ static int mt7615_mcu_drv_pmctrl(struct mt7615_dev *dev)
 	u32 addr;
 	int err;
 
-	addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
+	if (is_mt7663(mdev)) {
+		/* Clear firmware own via N9 eint */
+		mt76_wr(dev, MT_PCIE_DOORBELL_PUSH, MT_CFG_LPCR_HOST_DRV_OWN);
+		mt76_poll(dev, MT_CONN_ON_MISC, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
+
+		addr = MT_CONN_HIF_ON_LPCTL;
+	} else {
+		addr = MT_CFG_LPCR_HOST;
+	}
+
 	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
 
 	mt7622_trigger_hif_int(dev, true);
 
-	addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
 	err = !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
 
 	mt7622_trigger_hif_int(dev, false);
-- 
2.30.2

