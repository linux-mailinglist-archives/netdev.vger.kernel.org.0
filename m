Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A404A1C1D5F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 20:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbgEASpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 14:45:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgEASpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 14:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XyXIyXDD+yRhRONHL1HUqJ0q0m9e/xJu1qfSy3rs0os=; b=wVWe/Eu+NSD/QPpPHw6q9PM8Ij
        TiHoGnaOf32kL+sPXJn1JF1psZdxieky+tbIehudXMuw56bWRHW8NrgZf1uo04ualUSnt9vBNV+/a
        j52lrimw89UwpNf70HUX8TCMX+XNz+l3C7mTStVFbJkEP6Y1RzCyI1o58GXGitOtdjmE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUafE-000Z9K-D3; Fri, 01 May 2020 20:45:32 +0200
Date:   Fri, 1 May 2020 20:45:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed_phy support / Question regarding
 proper devicetree
Message-ID: <20200501184532.GI128733@lunn.ch>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
 <20200426143116.GC1140627@lunn.ch>
 <6C2E44BB-F4D1-4BC3-9FCB-55F01DA4A3C9@berg-solutions.de>
 <20200427215209.GP1250287@lunn.ch>
 <3C939186-D81B-4423-A148-6C5F104E3684@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C939186-D81B-4423-A148-6C5F104E3684@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 01, 2020 at 08:09:05PM +0200, Roelof Berg wrote:
> Working status: I added fixed_phy support to the Microchip lan743x ethernet
> driver and for upstream contribution I need to make it runtime configurable via
> the device tree.
> 
> Question:
> 
> There are, amongst other, the following devices on my target (i.mx6): 
> /soc/aips-bus@2100000/ethernet@2188000
> /soc/pcie@1ffc000
> 
> Where would I put my additional lan743x ethernet device in the device tree ?

It is a child device of the PCIe host. So that decides where it goes
in the tree. The pcie bus should already be in the imx6 DTSI file. So
in your board specific dts file you want something like:

&pcie {
        host@0 {
                reg = <0 0 0 0 0>;

                #address-cells = <3>;
                #size-cells = <2>;

                ethernet: ethernet@0 {
                        reg = <0 0 0 0 0>;
			phy-connection-type = "rgmii";
                         
                        fixed-link {
                                speed = <100>;
                                full-duplex;
                        };
                };
         };
};

You will probably need to play around with this. It is not well
documented, there are few examples. I needed to put a few printk() in
the PCI core to get it working for the ZII boards.

    Andrew
