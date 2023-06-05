Return-Path: <netdev+bounces-7938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 796AC7222B4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:56:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33C762811CC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C28B154A9;
	Mon,  5 Jun 2023 09:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2181B134BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:55:58 +0000 (UTC)
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DEAD3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:55:55 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685958945tf7p5e7d
Received: from localhost.localdomain ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 17:55:42 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: q+EIYT+FhZr/VWuGHW5yOVBJty4/KxOGCld9HRMpYcy/D5WeCYPAUYbZz9UH+
	J/kAH6IeVNcesMFgtGGtJLGbwYvCyZlUFJGssk0Dz8LEe2RgAfCaZo+ZWAFLfzJMFnuIo0o
	SklNtt3yOzWkQmAHsvCAQtT4Z/eE2X/mVangy09ChbeBR+D8tZl6ESh1sR33jQCXvhNjJmt
	PhNv4l0EVvL1tJm/AZpQMU4nkuozLW9fpftWcyGlV0ehvTmFAOMJA0vDK5SaKwFSnKmva92
	taBgQFUeb9JKQOE2zvIH2hHhHiDrpMs+QJYEigDaT8VJiBt0taLZwiTAqHEnHp1upD920W0
	QD1lSWrZQcZaXVMzxOCvQPWT8TGs76h9HFYBn/vCP7Y0M+zXOawBwrh9X24N7OapQhkLQ9b
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 11037389191732909534
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC,PATCH net-next 1/3] net: ngbe: add Wake on Lan support
Date: Mon,  5 Jun 2023 17:52:50 +0800
Message-ID: <6DD3D5EDF01AE3F5+20230605095527.57898-2-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230605095527.57898-1-mengyuanlou@net-swift.com>
References: <20230605095527.57898-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ethtool_ops get_wol.
Implement Wake-on-LAN support.

Magic packets are checked by fw, for now just support
WAKE_MAGIC and do not supoort to set_wol.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c | 10 ++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c    |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
index 5b25834baf38..2bc54fdafb31 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
@@ -8,12 +8,22 @@
 #include "../libwx/wx_ethtool.h"
 #include "ngbe_ethtool.h"
 
+static void ngbe_get_wol(struct net_device *netdev,
+			 struct ethtool_wolinfo *wol)
+{
+	if (!netdev->wol_enabled)
+		return;
+	wol->supported = WAKE_MAGIC;
+	wol->wolopts = WAKE_MAGIC;
+}
+
 static const struct ethtool_ops ngbe_ethtool_ops = {
 	.get_drvinfo		= wx_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.nway_reset		= phy_ethtool_nway_reset,
+	.get_wol		= ngbe_get_wol,
 };
 
 void ngbe_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index c99a5d3de72e..5d013ac3acd1 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -628,6 +628,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	wr32(wx, NGBE_PSR_WKUP_CTL, wx->wol);
 
 	device_set_wakeup_enable(&pdev->dev, wx->wol);
+	netdev->wol_enabled = wx->wol_enabled;
 
 	/* Save off EEPROM version number and Option Rom version which
 	 * together make a unique identify for the eeprom
-- 
2.41.0


