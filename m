Return-Path: <netdev+bounces-7939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A54E7222B9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA6B1281215
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F041156D9;
	Mon,  5 Jun 2023 09:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81768156D0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 09:55:59 +0000 (UTC)
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6CDB8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:55:56 -0700 (PDT)
X-QQ-mid: bizesmtp86t1685958949thg5h7d1
Received: from localhost.localdomain ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 17:55:48 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: I8hG9CuxGDK0dYQWPu8BK+vCoQHoPW8MS8SPSQ87/wRkRRiNJs521qRw/iu+6
	E8wXtilwc8HvhNUdviDfw3Wb+22TA4d2GRyi365FGivCrZ+BouYOCXGmIXP+YCiNCc2Ms2K
	zCzUXsDIhEPgZz7shRMNiErHr4mUKZpvgD9OCwSMLnKkxkgeeKy65Whr4etFYfWC3TfYF8k
	JS2k8VYBVe8niYhtA+0harSwgsjOMa+czWdH1Cf3dGpLACnWHA0skqtxJN4ZY0xCxH2aHCG
	KH8NzmUD5Nt/Q1IjnWetu9tIVfNhkgq8A0uFpxzKEvsp/5IF3zs0C3mh5MweDoA/sgRyP85
	BXvp0UZHv/DTX7p0m3DBadeCOfVRe/IDbMxZEly64gYAJGncG5gAAxGVS2Lnahra0qPOKpP
	YTG6hNN49Ww=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2369341711221289698
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC,PATCH net-next 2/3] net: core: add member ncsi_enabled to net_device
Date: Mon,  5 Jun 2023 17:52:51 +0800
Message-ID: <BEDE537DCE76BDAF+20230605095527.57898-3-mengyuanlou@net-swift.com>
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

Add flag ncsi_enabled to struct net_device indicating whether
NCSI is enabled. Phy_suspend() will use it to decide whether PHY
can be suspended or not.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/phy/phy_device.c | 4 +++-
 include/linux/netdevice.h    | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2cad9cc3f6b8..6587b35071e9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1859,7 +1859,9 @@ int phy_suspend(struct phy_device *phydev)
 		return 0;
 
 	phy_ethtool_get_wol(phydev, &wol);
-	phydev->wol_enabled = wol.wolopts || (netdev && netdev->wol_enabled);
+	phydev->wol_enabled = wol.wolopts ||
+			      (netdev && netdev->wol_enabled) ||
+			      (netdev && netdev->ncsi_enabled);
 	/* If the device has WOL enabled, we cannot suspend the PHY */
 	if (phydev->wol_enabled && !(phydrv->flags & PHY_ALWAYS_CALL_SUSPEND))
 		return -EBUSY;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 08fbd4622ccf..7650b6a210ff 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2021,6 +2021,8 @@ enum netdev_ml_priv_type {
  *
  *	@wol_enabled:	Wake-on-LAN is enabled
  *
+ *	@ncsi_enabled:	NCSI is enabled
+ *
  *	@threaded:	napi threaded mode is enabled
  *
  *	@net_notifier_list:	List of per-net netdev notifier block
@@ -2390,6 +2392,7 @@ struct net_device {
 	struct lock_class_key	*qdisc_tx_busylock;
 	bool			proto_down;
 	unsigned		wol_enabled:1;
+	unsigned		ncsi_enabled:1;
 	unsigned		threaded:1;
 
 	struct list_head	net_notifier_list;
-- 
2.41.0


