Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F718639231
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 00:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiKYXZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 18:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiKYXZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 18:25:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D69F55A90
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 15:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6X80aiCh6lShoHJJJZI7HbCAV1UM+PD1bmdGJ7PWfeU=; b=MjUjElqCzD1UnBs3Rf7PBufPy0
        jGPRNRkB2x7ajkt8TgP1ngT78rdPegjxzf/sEF4JT52tuWnVFE/5BAaLWDqlJ2Y19kYhC7RxGWeoJ
        5RX7rZRT9k8JoVCfhSmNAJa4Ikv8WZLQs45R7FA/xHg29mULHa4nNFVkiy6p/IM5Zcj4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oyi4Z-003TIx-Dn; Sat, 26 Nov 2022 00:25:31 +0100
Date:   Sat, 26 Nov 2022 00:25:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v1 3/3] net/ethtool/ioctl: correct & simplify
 ethtool_get_phy_stats if checks
Message-ID: <Y4FO65aWvYu8Y6U7@lunn.ch>
References: <20221125164913.360082-1-d-tatianin@yandex-team.ru>
 <20221125164913.360082-4-d-tatianin@yandex-team.ru>
 <Y4ETXbZn3wSnZbfh@lunn.ch>
 <55705e49-4b35-59be-5e41-7454dd12a0a4@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55705e49-4b35-59be-5e41-7454dd12a0a4@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I did experiment with that for a bit at the start, couldn't come up with a
> clear solution right away so went with this instead.

How about this? The patch is a lot less readable than the end code.
Compile tested only.

	Andrew

--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2077,58 +2077,88 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
        return ret;
 }
 
-static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+static int ethtool_get_phy_stats_phydev(struct phy_device *phydev,
+                                       struct ethtool_stats *stats,
+                                       u64 **data)
 {
        const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
+       int n_stats;
+
+       if (!phy_ops || !phy_ops->get_sset_count || !phy_ops->get_stats)
+               return -EOPNOTSUPP;
+
+       n_stats = phy_ops->get_sset_count(phydev);
+       if (n_stats < 0)
+               return n_stats;
+       if (n_stats > S32_MAX / sizeof(u64))
+               return -ENOMEM;
+       if (WARN_ON_ONCE(!n_stats))
+               return -EOPNOTSUPP;
+
+       stats->n_stats = n_stats;
+
+       *data = vzalloc(array_size(n_stats, sizeof(u64)));
+       if (!*data)
+               return -ENOMEM;
+
+       return phy_ops->get_stats(phydev, stats, *data);
+}
+
+static int ethtool_get_phy_stats_ethtool(struct net_device *dev,
+                                        struct ethtool_stats *stats,
+                                        u64 **data)
+{
        const struct ethtool_ops *ops = dev->ethtool_ops;
-       struct phy_device *phydev = dev->phydev;
-       struct ethtool_stats stats;
-       u64 *data;
-       int ret, n_stats;
+       int n_stats;
 
-       if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
+       if (!ops || !ops->get_sset_count || ops->get_ethtool_phy_stats)
                return -EOPNOTSUPP;
 
-       if (phydev && !ops->get_ethtool_phy_stats &&
-           phy_ops && phy_ops->get_sset_count)
-               n_stats = phy_ops->get_sset_count(phydev);
-       else
-               n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
+       n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
        if (n_stats < 0)
                return n_stats;
        if (n_stats > S32_MAX / sizeof(u64))
                return -ENOMEM;
-       WARN_ON_ONCE(!n_stats);
+       if (WARN_ON_ONCE(!n_stats))
+               return -EOPNOTSUPP;
+
+       stats->n_stats = n_stats;
+
+       *data = vzalloc(array_size(n_stats, sizeof(u64)));
+       if (!*data)
+               return -ENOMEM;
+
+       ops->get_ethtool_phy_stats(dev, stats, *data);
+
+       return 0;
+}
+
+static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
+{
+       struct phy_device *phydev = dev->phydev;
+       struct ethtool_stats stats;
+       u64 *data;
+       int ret;
 
        if (copy_from_user(&stats, useraddr, sizeof(stats)))
                return -EFAULT;
 
-       stats.n_stats = n_stats;
-
-       if (n_stats) {
-               data = vzalloc(array_size(n_stats, sizeof(u64)));
-               if (!data)
-                       return -ENOMEM;
+       if (phydev)
+               ret = ethtool_get_phy_stats_phydev(phydev, &stats, &data);
+       else
+               ret = ethtool_get_phy_stats_ethtool(dev, &stats, &data);
+       if (ret)
+               return ret;
 
-               if (phydev && !ops->get_ethtool_phy_stats &&
-                   phy_ops && phy_ops->get_stats) {
-                       ret = phy_ops->get_stats(phydev, &stats, data);
-                       if (ret < 0)
-                               goto out;
-               } else {
-                       ops->get_ethtool_phy_stats(dev, &stats, data);
-               }
-       } else {
-               data = NULL;
+       if (copy_to_user(useraddr, &stats, sizeof(stats))) {
+               ret = -EFAULT;
+               goto out;
        }
 
-       ret = -EFAULT;
-       if (copy_to_user(useraddr, &stats, sizeof(stats)))
-               goto out;
        useraddr += sizeof(stats);
-       if (n_stats && copy_to_user(useraddr, data, array_size(n_stats, sizeof(u64))))
-               goto out;
-       ret = 0;
+       if (copy_to_user(useraddr, data,
+                        array_size(stats.n_stats, sizeof(u64))))
+               ret = -EFAULT;
 
  out:
        vfree(data);
