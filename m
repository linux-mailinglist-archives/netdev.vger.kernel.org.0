Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95D20656242
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 12:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiLZLss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 06:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiLZLso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 06:48:44 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF2EF34;
        Mon, 26 Dec 2022 03:48:43 -0800 (PST)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id 7E5585FCCF;
        Mon, 26 Dec 2022 14:48:42 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id SmMqpV0Q0uQ1-ma6jHp3e;
        Mon, 26 Dec 2022 14:48:41 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672055322; bh=Bc0UQBiLcPIeNMMXHPDirTDhvMlEZMdLdU3YkqOgz/I=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=N5T9G93zwobBipUq19jbhhBmDj8j0GgPwems6oUkB37L7dASt/SC/y8DdxCdz/DXx
         ZCWqVzQhJ6XOaVACPADlS/nCNQOQQzE9hVV2tEyj6CSFlW+qGu6MGuZny51XgOXiu6
         HE4zINwgOn+Ld1rA8mXZLtYchhOBP8U6hUdRMBKQ=
Authentication-Results: vla1-81430ab5870b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] net/ethtool/ioctl: remove if n_stats checks from ethtool_get_phy_stats
Date:   Mon, 26 Dec 2022 14:48:24 +0300
Message-Id: <20221226114825.1937189-3-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
References: <20221226114825.1937189-1-d-tatianin@yandex-team.ru>
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

Now that we always early return if we don't have any stats we can remove
these checks as they're no longer necessary.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/ioctl.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e8a294b38b7b..3379af21c29f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2101,28 +2101,24 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
 	stats.n_stats = n_stats;
 
-	if (n_stats) {
-		data = vzalloc(array_size(n_stats, sizeof(u64)));
-		if (!data)
-			return -ENOMEM;
+	data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!data)
+		return -ENOMEM;
 
-		if (phydev && !ops->get_ethtool_phy_stats &&
-		    phy_ops && phy_ops->get_stats) {
-			ret = phy_ops->get_stats(phydev, &stats, data);
-			if (ret < 0)
-				goto out;
-		} else {
-			ops->get_ethtool_phy_stats(dev, &stats, data);
-		}
+	if (phydev && !ops->get_ethtool_phy_stats &&
+		phy_ops && phy_ops->get_stats) {
+		ret = phy_ops->get_stats(phydev, &stats, data);
+		if (ret < 0)
+			goto out;
 	} else {
-		data = NULL;
+		ops->get_ethtool_phy_stats(dev, &stats, data);
 	}
 
 	ret = -EFAULT;
 	if (copy_to_user(useraddr, &stats, sizeof(stats)))
 		goto out;
 	useraddr += sizeof(stats);
-	if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
+	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
 		goto out;
 	ret = 0;
 
-- 
2.25.1

