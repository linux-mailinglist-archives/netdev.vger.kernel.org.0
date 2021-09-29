Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAE41BFE3
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 09:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244723AbhI2H2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 03:28:49 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33144 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244660AbhI2H2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 03:28:33 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 417D5214E6; Wed, 29 Sep 2021 15:26:50 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 10/10] mctp: Warn if pointer is set for a wrong dev type
Date:   Wed, 29 Sep 2021 15:26:14 +0800
Message-Id: <20210929072614.854015-11-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210929072614.854015-1-matt@codeconstruct.com.au>
References: <20210929072614.854015-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should not occur but is a sanity check.

May help tracking down Trinity reported issue
https://lore.kernel.org/lkml/20210913030701.GA5926@xsang-OptiPlex-9020/

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index f556c6d01abc..3827d62f52c9 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -337,12 +337,26 @@ static int mctp_set_link_af(struct net_device *dev, const struct nlattr *attr,
 	return 0;
 }
 
+/* Matches netdev types that should have MCTP handling */
+static bool mctp_known(struct net_device *dev)
+{
+	/* only register specific types (inc. NONE for TUN devices) */
+	return dev->type == ARPHRD_MCTP ||
+		   dev->type == ARPHRD_LOOPBACK ||
+		   dev->type == ARPHRD_NONE;
+}
+
 static void mctp_unregister(struct net_device *dev)
 {
 	struct mctp_dev *mdev;
 
 	mdev = mctp_dev_get_rtnl(dev);
-
+	if (mctp_known(dev) != (bool)mdev) {
+		// Sanity check, should match what was set in mctp_register
+		netdev_warn(dev, "%s: mdev pointer %d but type (%d) match is %d",
+			    __func__, (bool)mdev, mctp_known(dev), dev->type);
+		return;
+	}
 	if (!mdev)
 		return;
 
@@ -360,16 +374,19 @@ static int mctp_register(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	/* Already registered? */
-	if (rtnl_dereference(dev->mctp_ptr))
-		return 0;
+	mdev = rtnl_dereference(dev->mctp_ptr);
 
-	/* only register specific types (inc. NONE for TUN devices) */
-	if (!(dev->type == ARPHRD_MCTP ||
-	      dev->type == ARPHRD_LOOPBACK ||
-	      dev->type == ARPHRD_NONE)) {
+	if (mdev) {
+		if (!mctp_known(dev))
+			netdev_warn(dev, "%s: mctp_dev set for unknown type %d",
+				    __func__, dev->type);
 		return 0;
 	}
 
+	/* only register specific types */
+	if (!mctp_known(dev))
+		return 0;
+
 	mdev = mctp_add_dev(dev);
 	if (IS_ERR(mdev))
 		return PTR_ERR(mdev);
-- 
2.30.2

