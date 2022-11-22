Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C3F6335D1
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiKVHWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiKVHWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:22:46 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A94101FB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 23:22:40 -0800 (PST)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 5EEA060BFB;
        Tue, 22 Nov 2022 10:22:38 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b721::1:36])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id AMSFmOFnwF-MbN80oi2;
        Tue, 22 Nov 2022 10:22:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1669101757; bh=Ucfk3XPONbn37aQksPm6TNfxrOHdr4Qy624rAON7bC0=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=hQIo3k+yFRPa9CImetSnquHyfTOpFTCLLIYtT7rAWu6twkQUPZfkYw3EkZkUElR7A
         uDImE5JfuAMmu9RbkyvPBVvYakmtslN6i0BDcKU5dSUnxkcp2cqT9QYIPb5nwBeCNN
         D2daa4kAhJtZE5A6KR3/KNWhHGHjq944u+j0BD60=
Authentication-Results: iva8-3a65cceff156.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Andrew Lunn <andrew@lunn.ch>,
        Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] net/ethtool/ioctl: ensure that we have phy ops before using them
Date:   Tue, 22 Nov 2022 10:21:43 +0300
Message-Id: <20221122072143.53841-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ops->get_ethtool_phy_stats was getting called in an else branch
of ethtool_get_phy_stats() unconditionally without making sure
it was actually present.

Refactor the checks to avoid unnecessary nesting and make them more
readable. Add an extra WARN_ON_ONCE(1) to emit a warning when a driver
declares that it has phy stats without a way to retrieve them.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 net/ethtool/ioctl.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 57e7238a4136..04f9ba98b038 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2100,23 +2100,28 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
 	stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
-		if (!data)
-			return -ENOMEM;
+	if (!n_stats) {
+		data = NULL;
+		goto copy_back;
+	}
 
-		if (phydev && !ops->get_ethtool_phy_stats &&
-		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(phydev, &stats, data);
-			if (ret < 0)
-				goto out;
-		} else {
-			ops->get_ethtool_phy_stats(dev, &stats, data);
-		}
+	data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!data)
+		return -ENOMEM;
+
+	if (ops->get_ethtool_phy_stats) {
+		ops->get_ethtool_phy_stats(dev, &stats, data);
+	} else if (phydev && phy_ops && phy_ops->get_stats) {
+		ret = phy_ops->get_stats(phydev, &stats, data);
+		if (ret < 0)
+			goto out;
 	} else {
-		data = NULL;
+		WARN_ON_ONCE(1);
+		n_stats = 0;
+		stats.n_stats = 0;
 	}
 
+copy_back:
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
-- 
2.25.1

