Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178AD9BCAC
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 11:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbfHXJLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 05:11:30 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45314 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfHXJL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 05:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4vyjjTN2tY41ujVV2LAb3z/n7iq9ZDGRMpuHH14WmRc=; b=aY2z4X+f8fiIvgDdndWJ+vJ10
        ON7uivJ/JKcwRZHdK601HGIg7z8/eT/l3WAFvrkT6/I82UhQF2XGxaLmOsMItNKNOY5zVdRw0UP7p
        DB2PpYPEF1sUUpYyfKXB/yl3/+E4OZPsFquqFOaMGqTSIqdNEB0hMo8uOApXfB7z/5RR545LUHb3B
        C18hZE0OcDAHoP2+q72CrSNSW7AqpwJRhNSmuxztJ4utoXX6aj3qG+qkIkWA5CXNECiE9PzzryvnC
        wR0hDRU5j5wnhJp78pL4ilROPp+r+FOdU1/hx7LRQu12laAXtmcO3TpZIecZwFe6XyQmJyxYRtWP9
        l8r4nECzQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53936)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1S4m-00029T-5T; Sat, 24 Aug 2019 10:11:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1S4g-0002Ql-9j; Sat, 24 Aug 2019 10:11:06 +0100
Date:   Sat, 24 Aug 2019 10:11:06 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 1/3] net: ethernet: mediatek: Add basic
 PHYLINK support
Message-ID: <20190824091106.GC13294@shell.armlinux.org.uk>
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-2-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190823134516.27559-2-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 03:45:14PM +0200, René van Dorst wrote:
> This convert the basics to PHYLINK API.
> SGMII support is not in this patch.
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> --
> v2->v3:
> * Make link_down() similar as link_up() suggested by Russell King

Yep, almost there, but...

> +static void mtk_mac_link_down(struct phylink_config *config, unsigned int mode,
> +			      phy_interface_t interface)
> +{
> +	struct mtk_mac *mac = container_of(config, struct mtk_mac,
> +					   phylink_config);
> +	u32 mcr = mtk_r32(mac->hw, MTK_MAC_MCR(mac->id));
>  
> +	mcr &= (MAC_MCR_TX_EN | MAC_MCR_RX_EN);

... this clears all bits _except_ for the tx and rx enable (which will
remain set) - you probably wanted a ~ before the (.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
