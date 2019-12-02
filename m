Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3841810EB08
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 14:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfLBNqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 08:46:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbfLBNqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 08:46:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s7PmRgS34bnx+DHAnO+vmv7OQpjXwYwCkPaJH2/QmvI=; b=Ffw0mhWVburOJV3CZDBrSqr8bH
        i+nLcw/iEa0xVKWwL/riSDHiT2ncvWqNFPyE90i8bY6ZLBztclpNOSzrycw95xwnHEkq3yAEzqKsj
        O0PAFEKRKBd5N7TJ9/jh6cnD0IK87FUim01punsVzhStK+Enxwye/yYBRAE+BN1WCafs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ibm1e-0000Vs-T6; Mon, 02 Dec 2019 14:46:06 +0100
Date:   Mon, 2 Dec 2019 14:46:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sam Lewis <sam.vr.lewis@gmail.com>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: Re: PROBLEM: smsc95xx loses config on link down/up
Message-ID: <20191202134606.GA1234@lunn.ch>
References: <CA+ZLECteuEZJM_4gtbxiEAAKbKnJ_3UfGN4zg_m2EVxk_9=WiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ZLECteuEZJM_4gtbxiEAAKbKnJ_3UfGN4zg_m2EVxk_9=WiA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 06:19:14PM +1100, Sam Lewis wrote:
> I'm using a LAN9514 chip in my embedded Linux device and have noticed
> that changing Ethernet configuration (with ethtool for example) does
> not persist after putting the link up.

Hi Sam

Did you ever get a reply to this?

> I've hacked through the driver code (without really knowing what I'm
> doing, just adding various print statements) and I think this happens
> because setting a link up causes the `smsc95xx_reset` function to be
> called which seems to clear all configuration through:
> 
> 1) Doing a PHY reset (with `smsc95xx_write_reg(dev, PM_CTRL, PM_CTL_PHY_RST_)`)
> 2) Doing (another?) PHY reset (with `smsc95xx_mdio_write(dev->net,
> dev->mii.phy_id, MII_BMCR, BMCR_RESET)`)

In general, BMCR_RESET does not clear configuration registers such as
auto-neg etc. It generally just gives the PHY a kick to restart itself
using the configuration as set. So i would initially point a finger at
PM_CTL_PHY_RST_.

Is there a full datasheet somewhere?

You might want to think about using PM_CTL_PHY_RST_ once during probe,
and only BMCR_RESET in open.

    Andrew
