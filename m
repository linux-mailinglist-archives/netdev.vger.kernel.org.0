Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7492AE462
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732286AbgKJXsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:48:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbgKJXsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:48:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3023C207E8;
        Tue, 10 Nov 2020 23:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605052126;
        bh=wRBFRLvW3yQNab1zY31tsSRJ4SNnP8HEwm3V2HkrMqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fhobiSMnzLxSvz8w/acYZFNFAdjO6S7nMnLGENliejDLk+irP0ccDoLNUnOMExnnm
         iI0JTLETEaLTJT56/fzfyFQc7d3RupdzF0fdf7BQY+bcmR140Vi5X9oorLTJiBhDwL
         mMdfAXrNCMoCtnLCAHgpV7ZS8GHXeMROisxGwZWw=
Date:   Tue, 10 Nov 2020 15:48:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] lan743x: correctly handle chips with internal
 PHY
Message-ID: <20201110154844.651c5f98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201108171224.23829-1-TheSven73@gmail.com>
References: <20201108171224.23829-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 12:12:24 -0500 Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> Commit 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
> assumes that chips with an internal PHY will never have a devicetree
> entry. This is incorrect: even for these chips, a devicetree entry
> can be useful e.g. to pass the mac address from bootloader to chip:
> 
>     &pcie {
>             status = "okay";
> 
>             host@0 {
>                     reg = <0 0 0 0 0>;
> 
>                     #address-cells = <3>;
>                     #size-cells = <2>;
> 
>                     lan7430: ethernet@0 {
>                             /* LAN7430 with internal PHY */
>                             compatible = "microchip,lan743x";
>                             status = "okay";
>                             reg = <0 0 0 0 0>;
>                             /* filled in by bootloader */
>                             local-mac-address = [00 00 00 00 00 00];
>                     };
>             };
>     };
> 
> If a devicetree entry is present, the driver will not attach the chip
> to its internal phy, and the chip will be non-operational.
> 
> Fix by tweaking the phy connection algorithm:
> - first try to connect to a phy specified in the devicetree
>   (could be 'real' phy, or just a 'fixed-link')
> - if that doesn't succeed, try to connect to an internal phy, even
>   if the chip has a devnode
> 
> Tested on a LAN7430 with internal PHY. I cannot test a device using
> fixed-link, as I do not have access to one.
> 
> Fixes: 6f197fb63850 ("lan743x: Added fixed link and RGMII support")
> Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>

Applied, thank you!
