Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9526425C7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiLEJ3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiLEJ3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:29:07 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EB715738;
        Mon,  5 Dec 2022 01:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uYIGjJD2wgkVcMrKaqHksISnsayovI84ZVgDoXZJbZM=; b=XUShWzoGgZRjua1LdqRbH3lpeo
        kJvToInvKRelfGJisTV+Sq0WROK9101f/+PnxcP65ttNQ2SA/0wbutD2NpMJow+Bf0mvUPDUPUiws
        o6xvb/W69BxN8BbcsixypAUEiqwspCxAGju6J13Sshd8N7Q20NqVX9MpOfQgWaPWupaZ2p9qDljY9
        y6BSAVLwQGSvwtMwPQatSyNIvshqHiASHjLER9dsY78MpzMFv50Nb0m6sxUS2byMZrCyfz58xOWKU
        gOB2kJ9E23qab889cfBvyw02yB7CEZCGmuwm9WU7biH9H79ED7APpsNw0qLJDkH5rcOyuhkHkkGZk
        Gdf8a3yA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35576)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p27mP-0006ZO-Qo; Mon, 05 Dec 2022 09:28:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p27mN-00078a-J7; Mon, 05 Dec 2022 09:28:51 +0000
Date:   Mon, 5 Dec 2022 09:28:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y42509XkIN1S73Er@shell.armlinux.org.uk>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 02:41:35AM +0100, Piergiorgio Beruto wrote:
> +int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct ethnl_req_info req_info = {};
> +	struct nlattr **tb = info->attrs;
> +	const struct ethtool_phy_ops *ops;
> +	struct phy_plca_cfg plca_cfg;
> +	struct net_device *dev;
> +
> +	bool mod = false;
> +	int ret;
> +
> +	ret = ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_PLCA_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev = req_info.dev;
> +
> +	// check that the PHY device is available and connected
> +	if (!dev->phydev) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}

This check should really be done under the RTNL lock. phydevs can come
and go with SFP cages.

> +
> +	rtnl_lock();

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
