Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D413F629157
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiKOFHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiKOFHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:07:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9E4140F6;
        Mon, 14 Nov 2022 21:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E5BDB8165D;
        Tue, 15 Nov 2022 05:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD4FC433D7;
        Tue, 15 Nov 2022 05:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668488827;
        bh=7haCLadCF4QfnZdVg6gZJuBcpCT3VBUqM11uFcjlPRE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RRo9am5EdLULZ91p3s4X3mge/fKyS/JwEMX7EL4WMW4uNdV33qKiF/tGn2J/gSG1k
         8Jv+fIkOIaOBkn6JEZgag+i1lHHpch4En4a+tuuh85U9//Vf7FLj6c75CTGkNK6OxC
         xt4luEs2hEAf48uMmRqAskavY84GDfwWj/9mWik497r78daxpOCJ9aZhAD3BrMHES2
         Ewf7BjVXprai3rdD5wVnbV2OGOFdmYcxc9m91MFVS4Jk3sIxHxvbZ53dDtyz+EoaRy
         tmP8NA241DxSkLNqSXGKTbhoM20GiIyoFoultUkTSbkbN1qUIJtxlmabM4jTrg24r/
         F9iJwqqxGe3rQ==
Date:   Mon, 14 Nov 2022 21:07:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, yc-core@yandex-team.ru
Subject: Re: [PATCH v1] net/ethtool/ioctl: ensure that we have phy ops
 before using them
Message-ID: <20221114210705.216996a9@kernel.org>
In-Reply-To: <20221114081532.3475625-1-d-tatianin@yandex-team.ru>
References: <20221114081532.3475625-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Nov 2022 11:15:32 +0300 Daniil Tatianin wrote:
> +	if (!(phydev && phy_ops && phy_ops->get_stats) &&
> +	    !ops->get_ethtool_phy_stats)

This condition is still complicated.

> +		return -EOPNOTSUPP;

The only way this crash can happen is if driver incorrectly returns
non-zero stats count but doesn't have a callback to read the stats.
So WARN_ON() would be in order here.

>  	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
>  		return -EOPNOTSUPP;
>  
> @@ -2063,13 +2066,12 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
>  		if (!data)
>  			return -ENOMEM;
>  
> -		if (dev->phydev && !ops->get_ethtool_phy_stats &&
> -		    phy_ops && phy_ops->get_stats) {
> -			ret = phy_ops->get_stats(dev->phydev, &stats, data);
> +		if (ops->get_ethtool_phy_stats) {
> +			ops->get_ethtool_phy_stats(dev, &stats, data);
> +		} else {
> +			ret = phy_ops->get_stats(phydev, &stats, data);
>  			if (ret < 0)
>  				goto out;
> -		} else {
> -			ops->get_ethtool_phy_stats(dev, &stats, data);
>  		}

We can also clean up the pointless indentation of this code while at it.

How about something along these lines (completely untested, please
review, test and make your own):

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 99272a67525c..ee04c388f4c9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2105,23 +2105,28 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 
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
