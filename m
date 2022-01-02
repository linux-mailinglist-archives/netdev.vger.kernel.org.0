Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278A3482C1D
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiABQnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:43:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47316 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbiABQnk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 11:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=p6z6R4Zq+iBUkifmKKYAC9qMQJ+15+ZEEM8C6DzOWp8=; b=j7
        Yd+uaaPiOFOfX2kH4cp/I+XeYgzct+wydzajip0fLO0Yk37F78L5G6gguHWqTriOxFYKkv33fa0K0
        12j066oLGvT7SlKZzZGl3LX5L0dA37ypyJYGDWEo6e06fGXdaNIV/CwLQQEc7fg5zzOc2vnaPjBKs
        OYbs7McL3NMmMy8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n43xE-000JsH-6L; Sun, 02 Jan 2022 17:43:32 +0100
Date:   Sun, 2 Jan 2022 17:43:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v10 1/3] net: ethernet: mtk_eth_soc: fix return value and
 refactor MDIO ops
Message-ID: <YdHWNIcr9AzFG7oN@lunn.ch>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
 <YdHJQhG3vmEJ4ia6@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <YdHJQhG3vmEJ4ia6@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=17> +static int _mtk_mdio_write(struct mtk_eth *eth, u32 phy_addr, u32 phy=
_reg,
> +			   u32 write_data)
>  {
>  	if (mtk_mdio_busy_wait(eth))
> -		return -1;
> -
> -	write_data &=3D 0xffff;
> +		return -EBUSY;

-ETIMEDOUT would be more normal.

I would probably also change mtk_mdio_busy_wait() so that it either
returned 0, or -ETIMEDOUT. That is the general pattern in Linux,
return 0 on success, or a negative error code. Returning -1 is an
invitation for trouble.

The code would then become

    ret =3D mtk_mdio_busy_wait(eth);
    if (ret < 0)
       return ret;

which is a very common pattern in Linux.

      Andrew
