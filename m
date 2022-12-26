Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3481C656245
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 12:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiLZLtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 06:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiLZLsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 06:48:51 -0500
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9E9E61;
        Mon, 26 Dec 2022 03:48:48 -0800 (PST)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by forwardcorp1a.mail.yandex.net (Yandex) with ESMTP id E52165FD70;
        Mon, 26 Dec 2022 14:48:44 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:1::1:f])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id SmMqpV0Q0uQ1-VihaauT0;
        Mon, 26 Dec 2022 14:48:44 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672055324; bh=Nuxuuf1lhfDfoOk+xEW3obUWSUiFsuqUm9EH4ZXnZWg=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=F6GmxQu06XHnODjrFlMQpZEjNhsEVaS7BQXQS+noC42KMJ1Pg/w6GKDnaEZYgyu1d
         XpvxgmQo+ab7DZ5AXKWqhS5dZoF3cP271Ho3L13PK3H7SzUB0vyGFxcFQ/TA4oirML
         m4tCb4vstm2JtrDKSNH6dnwCxu4hXy1pQ1esjSuU=
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
Subject: [PATCH net v2 3/3] net/ethtool/ioctl: split ethtool_get_phy_stats into multiple helpers
Date:   Mon, 26 Dec 2022 14:48:25 +0300
Message-Id: <20221226114825.1937189-4-d-tatianin@yandex-team.ru>
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

So that it's easier to follow and make sense of the branching and
various conditions.

Stats retrieval has been split into two separate functions
ethtool_get_phy_stats_phydev & ethtool_get_phy_stats_ethtool.
The former attempts to retrieve the stats using phydev & phy_ops, while
the latter uses ethtool_ops.

Actual n_stats validation & array allocation has been moved into a new
ethtool_vzalloc_stats_array helper.

This also fixes a potential NULL dereference of
ops->get_ethtool_phy_stats where it was getting called in an else branch
unconditionally without making sure it was actually present.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/ioctl.c | 102 ++++++++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 33 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 3379af21c29f..36792633ce5f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2072,23 +2072,8 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
-static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+static int ethtool_vzalloc_stats_array(int n_stats, u64 **data)
 {
-	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
-	const struct ethtool_ops *ops = dev->ethtool_ops;
-	struct phy_device *phydev = dev->phydev;
-	struct ethtool_stats stats;
-	u64 *data;
-	int ret, n_stats;
-
-	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
-		return -EOPNOTSUPP;
-
-	if (phydev && !ops->get_ethtool_phy_stats &&
-	    phy_ops && phy_ops->get_sset_count)
-		n_stats = phy_ops->get_sset_count(phydev);
-	else
-		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 	if (n_stats < 0)
 		return n_stats;
 	if (n_stats > S32_MAX / sizeof(u64))
@@ -2096,31 +2081,82 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	if (WARN_ON_ONCE(!n_stats))
 		return -EOPNOTSUPP;
 
+	*data = vzalloc(array_size(n_stats, sizeof(u64)));
+	if (!*data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int ethtool_get_phy_stats_phydev(struct phy_device *phydev,
+					 struct ethtool_stats *stats,
+					 u64 **data)
+ {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
+	int n_stats, ret;
+
+	if (!phy_ops || !phy_ops->get_sset_count || !phy_ops->get_stats)
+		return -EOPNOTSUPP;
+
+	n_stats = phy_ops->get_sset_count(phydev);
+
+	ret = ethtool_vzalloc_stats_array(n_stats, data);
+	if (ret)
+		return ret;
+
+	stats->n_stats = n_stats;
+	return phy_ops->get_stats(phydev, stats, *data);
+}
+
+static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
+					  struct ethtool_stats *stats,
+					  u64 **data)
+{
+	const struct ethtool_ops *ops = dev->ethtool_ops;
+	int n_stats, ret;
+
+	if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
+		return -EOPNOTSUPP;
+
+	n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
+
+	ret = ethtool_vzalloc_stats_array(n_stats, data);
+	if (ret)
+		return ret;
+
+	stats->n_stats = n_stats;
+	ops->get_ethtool_phy_stats(dev, stats, *data);
+
+	return 0;
+}
+
+static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+{
+	struct phy_device *phydev = dev->phydev;
+	struct ethtool_stats stats;
+	u64 *data = NULL;
+	int ret = -EOPNOTSUPP;
+
 	if (copy_from_user(&stats, useraddr, sizeof(stats)))
 		return -EFAULT;
 
-	stats.n_stats = n_stats;
+	if (phydev)
+		ret = ethtool_get_phy_stats_phydev(phydev, &stats, &data);
 
-	data = vzalloc(array_size(n_stats, sizeof(u64)));
-	if (!data)
-		return -ENOMEM;
+	if (ret == -EOPNOTSUPP)
+		ret = ethtool_get_phy_stats_ethtool(dev, &stats, &data);
 
-	if (phydev && !ops->get_ethtool_phy_stats &&
-		phy_ops && phy_ops->get_stats) {
-		ret = phy_ops->get_stats(phydev, &stats, data);
-		if (ret < 0)
-			goto out;
-	} else {
-		ops->get_ethtool_phy_stats(dev, &stats, data);
-	}
+	if (ret)
+		goto out;
 
-	ret = -EFAULT;
-	if (copy_to_user(useraddr, &stats, sizeof(stats)))
+	if (copy_to_user(useraddr, &stats, sizeof(stats))) {
+		ret = -EFAULT;
 		goto out;
+	}
+
 	useraddr += sizeof(stats);
-	if (copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
-		goto out;
-	ret = 0;
+	if (copy_to_user(useraddr, data, array_size(stats.n_stats, sizeof(u64))))
+		ret = -EFAULT;
 
  out:
 	vfree(data);
-- 
2.25.1

