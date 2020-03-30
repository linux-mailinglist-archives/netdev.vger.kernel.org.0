Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82500197864
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 12:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgC3KIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 06:08:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50680 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728257AbgC3KIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 06:08:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uKxUCAA8naXHaUyESFTbDBUPBkSlzaNGfueG/RrQv68=; b=QsrA/r4ImKVHNXWTLdmlNbZ9M
        R+WTvCT5BWADbtt/e12KDk0e9TUIo7QSf4xyeYopXYanyY+92UyC1q9J3TWIbZehhAzda/OkStsqy
        smVBIEsMrUKY3IZCpfv/qk04mZi4ZbH3hyGwmTfULiV0Tbu8sRJW4PiLkoiKKq4xK6FKkBfSTPxXf
        VjklOBqLhM151hqzwkwgjCNQ84+JPdL9h1izH6R0iH8q7hYeOzqvHKgm2AclN7OuvXZHGZYkSkIha
        Sgkv6ZXfXZwI1HdDcNoXCfaFYY8Snx8pnkgToRyU6FU698yNHB6CjstMjashFAyqdiSgl7sUrfQdW
        12Uty1bLQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59868)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jIrLb-0001bc-1S; Mon, 30 Mar 2020 11:08:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jIrLY-00071i-Oy; Mon, 30 Mar 2020 11:08:44 +0100
Date:   Mon, 30 Mar 2020 11:08:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: phylink: add separate pcs
 operations structure
Message-ID: <20200330100844.GE25745@shell.armlinux.org.uk>
References: <20200329160036.GB25745@shell.armlinux.org.uk>
 <E1jIaNC-0007lp-7j@rmk-PC.armlinux.org.uk>
 <ab4164b1-2415-ec81-c235-0d3469dba4af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4164b1-2415-ec81-c235-0d3469dba4af@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 01:42:08PM -0700, Florian Fainelli wrote:
> 
> 
> On 3/29/2020 9:01 AM, Russell King wrote:
> > Add a separate set of PCS operations, which MAC drivers can use to
> > couple phylink with their associated MAC PCS layer.  The PCS
> > operations include:
> > 
> > - pcs_get_state() - reads the link up/down, resolved speed, duplex
> >    and pause from the PCS.
> > - pcs_config() - configures the PCS for the specified mode, PHY
> >    interface type, and setting the advertisement.
> > - pcs_an_restart() - restarts 802.3 in-band negotiation with the
> >    link partner
> > - pcs_link_up() - informs the PCS that link has come up, and the
> >    parameters of the link. Link parameters are used to program the
> >    PCS for fixed speed and non-inband modes.
> > 
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Although your kernel documentation is pretty comprehensive, I am fairly
> sure people are going to get confused about whether they need to
> implement pcs_an_restart vs. mac_an_restart and pcs_get_state vs.
> mac_pcs_get_state (with the possibility of a naming confusion for the
> latter). Maybe some guidelines in the comment as to which one to
> implement could save some support.

If one is making use of the PCS operations, then the PCS operations
are used in preference to the MAC operations in all cases except the
pcs_config() and pcs_link_up() methods.

This is already documented with:

 * When present, this overrides mac_pcs_get_state() in &struct
 * phylink_mac_ops.

 * When PCS ops are present, this overrides mac_an_restart() in &struct
 * phylink_mac_ops.

I'm not sure adding more words will help - in my experience, the more
words that are used, the more people nitpick and mess up.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
