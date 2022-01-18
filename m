Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E8E491611
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245696AbiARCch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344702AbiARCal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:30:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1975C0613EC;
        Mon, 17 Jan 2022 18:27:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 146E2611C0;
        Tue, 18 Jan 2022 02:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15146C36AE3;
        Tue, 18 Jan 2022 02:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472843;
        bh=syKAXgGkNN/cd6e1sptDYNJgaiCH3RcEKn5+Joj72mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2A1H6YW7424jBk6rhLRnwsU6XGVrKIw2Lti04m3TqnnUMm8cGGv/BrsIs17yOF16
         m3aPLZHJJfOWVUHpfmzkdttZbaKJJPYTqcMjVeSg9lbnk8RnmeAglf2HOUMa39zRRt
         g+a1wZRK1MFxOyUPhntpaCbkX/rE1/QLj6Bf5DiI5fDZpQU38ATcN/YoQlvcn52JrV
         ddhSKNfZrLi5J/mBaTeakdUdB7vSKkVcxaQHRtu15whP+XiYXeVEzz//2+D1zrrkvh
         C4J7p/RvAbO8wtxNSUK207wnZG+InGsi0UtngxOhlODXm3m+u+gySLvOAguyRFvVhX
         I22LwbyYXCWsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chiu <chui-hao.chiu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 152/217] mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()
Date:   Mon, 17 Jan 2022 21:18:35 -0500
Message-Id: <20220118021940.1942199-152-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Chiu <chui-hao.chiu@mediatek.com>

[ Upstream commit 8c55516de3f9b76b9d9444e7890682ec2efc809f ]

ieee80211_register_hw() is called with rtnl_lock held, and this could be
caused lockdep from a work item that's on a workqueue that is flushed
with the rtnl held.

Move mt7615_register_ext_phy() outside the init_work().

Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
index a2465b49ecd0c..87b4aa52ee0f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci_init.c
@@ -28,8 +28,6 @@ static void mt7615_pci_init_work(struct work_struct *work)
 		return;
 
 	mt7615_init_work(dev);
-	if (dev->dbdc_support)
-		mt7615_register_ext_phy(dev);
 }
 
 static int mt7615_init_hardware(struct mt7615_dev *dev)
@@ -160,6 +158,12 @@ int mt7615_register_device(struct mt7615_dev *dev)
 	mt7615_init_txpower(dev, &dev->mphy.sband_2g.sband);
 	mt7615_init_txpower(dev, &dev->mphy.sband_5g.sband);
 
+	if (dev->dbdc_support) {
+		ret = mt7615_register_ext_phy(dev);
+		if (ret)
+			return ret;
+	}
+
 	return mt7615_init_debugfs(dev);
 }
 
-- 
2.34.1

