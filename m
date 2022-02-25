Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D89F4C3DF5
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 06:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiBYFka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 00:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236037AbiBYFk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 00:40:28 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FAB2C0300
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 21:39:57 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 9AE82202A0; Fri, 25 Feb 2022 13:39:55 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next 1/3] mctp: Avoid warning if unregister notifies twice
Date:   Fri, 25 Feb 2022 13:39:36 +0800
Message-Id: <20220225053938.643605-2-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220225053938.643605-1-matt@codeconstruct.com.au>
References: <20220225053938.643605-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously if an unregister notify handler ran twice (waiting for
netdev to be released) it would print a warning in mctp_unregister()
every subsequent time the unregister notify occured.

Instead we only need to worry about the case where a mctp_ptr is
set on an unknown device type.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index da13444c632b..f49be882e98e 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -428,10 +428,10 @@ static void mctp_unregister(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	mdev = mctp_dev_get_rtnl(dev);
-	if (mctp_known(dev) != (bool)mdev) {
+	if (mdev && !mctp_known(dev)) {
 		// Sanity check, should match what was set in mctp_register
-		netdev_warn(dev, "%s: mdev pointer %d but type (%d) match is %d",
-			    __func__, (bool)mdev, mctp_known(dev), dev->type);
+		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
+			    __func__, dev->type);
 		return;
 	}
 	if (!mdev)
@@ -455,7 +455,7 @@ static int mctp_register(struct net_device *dev)
 
 	if (mdev) {
 		if (!mctp_known(dev))
-			netdev_warn(dev, "%s: mctp_dev set for unknown type %d",
+			netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
 				    __func__, dev->type);
 		return 0;
 	}
-- 
2.32.0

