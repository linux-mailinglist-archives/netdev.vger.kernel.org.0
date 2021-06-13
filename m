Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E6B3A5844
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhFMMWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 08:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbhFMMWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 08:22:54 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF84C061574;
        Sun, 13 Jun 2021 05:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mmyFe4CD1HqfyTgZipLbaHYfBnHjTeV2soAr4WgrLn0=; b=Jcam4PNyqOrWoyMZeEHGBppGG
        BjX0jmsrgghgEF+xxiDoIxtfzSsIPtPWurfL4igsI+46/HXriPp/D4Pf20YFn7v0+XNdhq56CjozY
        J0k/br+tWAkH6oTceb3MwPrS8WnU/5D9Jy27AhtXoWSOWu2jrUfY4Xwa6Zb9KIzKdNlsk50wP46Od
        +uxthAQoD+TGMKdenzFsJ/lhNhP7XIY+O8eBnhy6H7xx4esZd/gM9L59bTyuUC3aGGvQOHbUJUZXw
        c/95MON/iYMlZYQUyZ5Sg6qfbw/vYUZP8QomsBWaYS9vSeAd71uT8HH0b1u83lc45YIKaMtIPJgGG
        wFIl+zBMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44976)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsP6e-0003N9-DD; Sun, 13 Jun 2021 13:20:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsP6Z-0003BA-Cn; Sun, 13 Jun 2021 13:20:43 +0100
Date:   Sun, 13 Jun 2021 13:20:43 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Reto Schneider <code@reto-schneider.ch>
Cc:     devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] net: ethernet: mtk_eth_soc: Support custom ifname
Message-ID: <20210613122043.GP22278@shell.armlinux.org.uk>
References: <20210613115820.1525478-1-code@reto-schneider.ch>
 <20210613115820.1525478-2-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613115820.1525478-2-code@reto-schneider.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 01:58:19PM +0200, Reto Schneider wrote:
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 64adfd24e134..8bb09801918f 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2948,6 +2948,7 @@ static const struct net_device_ops mtk_netdev_ops = {
>  static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  {
>  	const __be32 *_id = of_get_property(np, "reg", NULL);
> +	const char *const name = of_get_property(np, "label", NULL);
>  	phy_interface_t phy_mode;
>  	struct phylink *phylink;
>  	struct mtk_mac *mac;
> @@ -3020,6 +3021,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  
>  	mac->phylink = phylink;
>  
> +	if (name)
> +		strncpy(eth->netdev[id]->name, name, IFNAMSIZ);

Please don't use strncpy() - this is a good example why strncpy() is bad
news.

 * strncpy - Copy a length-limited, C-string
 * @dest: Where to copy the string to
 * @src: Where to copy the string from
 * @count: The maximum number of bytes to copy
 *
 * The result is not %NUL-terminated if the source exceeds
 * @count bytes.

Consequently, if "name" is IFNAMSIZ bytes or longer,
eth->netdev[id]->name will not be NUL terminated, and subsequent use
will run off the end of the string. strscpy() is safer to use here.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
