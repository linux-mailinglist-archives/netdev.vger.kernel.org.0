Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C2480188
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 17:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbhL0QVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 11:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhL0QVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 11:21:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFE1C06173E;
        Mon, 27 Dec 2021 08:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RSEhGp8eMqXQRr+8UPnF+WguCciA3JX0Md7WUMkePUo=; b=ni+9alY6BXaeUBEkhjtRG7Z1KY
        VaYrtW/eg4v+NkdveUv1ZkEwl3+GqdtKwA9HdaflPQRA5afQX0/jrH0QodRNeqGohPbUyf3jmSNFd
        K/T9YeXw5C89URjTY0Fa/huBgaJznW/c8LNbrrvMyLWGkG5QW/N7WAc4/VC+ZjaztxUF/EkLR/YI2
        8iW1dkRYiXya/zVKl08XslB8RKJSpDPCEyAPVs6rK0x+6sJXlQlje9/+LPZ3sOptUrLd5oTDwBdJy
        5WXTjjx7SzfCpa2nklXCG2faprJk2L/DAzYUFn2lPpnJIzkVZag+vokBGSTnh87Bz4PUbnk/9H8Dr
        5xvvuw/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56460)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n1skY-0001Fb-Ty; Mon, 27 Dec 2021 16:21:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n1skU-0008H4-RQ; Mon, 27 Dec 2021 16:21:22 +0000
Date:   Mon, 27 Dec 2021 16:21:22 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3] net: ethernet: mtk_eth_soc: implement Clause 45 MDIO
 access
Message-ID: <YcnoAscVe+2YILT8@shell.armlinux.org.uk>
References: <YcjsFnbg87o45ltd@lunn.ch>
 <YcjjzNJ159Bo1xk7@lunn.ch>
 <YcjlMCacTTJ4RsSA@shell.armlinux.org.uk>
 <YcjepQ2fmkPZ2+pE@makrotopia.org>
 <YcnlMtninjjjPhjI@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YcnlMtninjjjPhjI@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 27, 2021 at 04:09:22PM +0000, Daniel Golle wrote:
> Implement read and write access to IEEE 802.3 Clause 45 Ethernet
> phy registers.
> Tested on the Ubiquiti UniFi 6 LR access point featuring
> MediaTek MT7622BV WiSoC with Aquantia AQR112C.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
> v3: return -1 instead of 0xffff on error in _mtk_mdio_write

Oh no, not this "-1 disease" again.

        eth->mii_bus->write = mtk_mdio_write;

static int mtk_mdio_write(struct mii_bus *bus, int phy_addr,
                          int phy_reg, u16 val)
{
        struct mtk_eth *eth = bus->priv;

        return _mtk_mdio_write(eth, phy_addr, phy_reg, val);
}

This means if you return -1 from _mtk_mdio_write() (which for some
strange reason returns a u32, not an "int") then you actually end
up returning -EPERM. This is not an appropriate errno code.

As a general rule of thumb, if you're returning an "int" and wish
to return "this failed" then always return an appropriate negative
errno code in the kernel so there isn't any possibility of
accidentially returning -EPERM through using "return -1".

This driver needs fixing _both_ due to returning -1, and also the
return type from both _mtk_mdio_write() and _mtk_mdio_read().

To see why it's important to return a proper error code, see
drivers/net/phy/phy_device.c::get_phy_c22_id() where -ENODEV and
-EIO are specifically checked. Any other negative value here will
stop the bus being scanned and cause the bus to be torn down.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
