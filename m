Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12753B886D
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhF3Sap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhF3Sao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:30:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216FCC061756
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 11:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=33tQFFvA7Ti06ePdDNVjOrnVQWsre92kl8L02A2qP7I=; b=M1+zks0ZVh99Jsk+EtLaGX3K5
        vKepbcqSHLazn4Nr4rcwq7m5Eth6PzAtG2uwHm7AqV8IdA7BEXagDQItVw1Lecjj0ZweOP0X4AT28
        14iY8RtA6GMhMipebOa+TltCJM50Sa9QkRyRh6ITjnCPUfhyIwbxxNeNRRjABdUo1mQ5tBTIEX6rh
        Z6odcNTrbY0byVpfCyduNy4mLMIm+stptptplsFYLR6ur9uG4oJbmAjcJwLzPjhUDxVU2ToE+Lo2/
        MyP7uP0Sz4YEcEE5LLoa7QzGhOufBm8b5Llk6cb9EgewGfWXlPizEypCRKpynnd5jujZK+rQfjk3d
        lHb/Z53Ag==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45556)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lyewU-0000OZ-V3; Wed, 30 Jun 2021 19:28:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lyewT-0003Ks-AC; Wed, 30 Jun 2021 19:28:09 +0100
Date:   Wed, 30 Jun 2021 19:28:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA
 PHY
Message-ID: <20210630182809.GH22278@shell.armlinux.org.uk>
References: <20210630174022.1016525-1-robert.hancock@calian.com>
 <20210630174651.GF22278@shell.armlinux.org.uk>
 <df768ccb16990f35598d466ad674dfd7b36b8601.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df768ccb16990f35598d466ad674dfd7b36b8601.camel@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 30, 2021 at 06:23:46PM +0000, Robert Hancock wrote:
> On Wed, 2021-06-30 at 18:46 +0100, Russell King (Oracle) wrote:
> > On Wed, Jun 30, 2021 at 11:40:22AM -0600, Robert Hancock wrote:
> > > Allow phytool ioctl access to read/write registers in the internal
> > > PCS/PMA PHY if it is enabled.
> > 
> > I wonder if this is something that should happen in phylink?
> > 
> 
> If there are other drivers which have a PCS which could be accessed with
> phytool etc., it might make sense. Right now phylink core doesn't really have
> any knowledge that the PCS PHY actually exists as something that can be
> accessed via MDIO registers, it just talks to it indirectly through the
> mac_config and mac_pcs_get_state callbacks in the driver which then call back
> into the c22_pcs helper functions to actually talk to the PCS. 

Phylink does know that a PCS exists. It has separate pcs_ops for it, and
slightly changes its behaviour when a PCS exists.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
