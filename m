Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4DA42DF3A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhJNQgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbhJNQgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 12:36:40 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1CAC061753
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 09:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rWTtBHHhXY4jnsCdKVmXHpUzMRVuyqvgG9+JMQ2KHXI=; b=VIsmsJE503g+ZslNEnRbRHWt5V
        IvxC5Ql1q0KVPJEU+AKSf0E3whquTBkqZWC66QFa600VeEhUpvs8K47mns5yZnSOzDDlJcozXKmw6
        CtvEU3uO3+FQSxQooIVoLfyY7lr7zIpDZq/gSLGxRkIc16xFHhL+2TNsDWrnsY+BjJ4iwS30x7dMx
        LFF6dR8Pz2AYiTXO1gxXsBGVrVek6jU5uMrXD9Y91N9LaQb18BMKIHi4Zy51xJC05vBTh1X+TdGbL
        Gwp4BafDdD8vMaidUH85a52AW+icfZVIey5OiVNkd24PrJzY4J0uE3dDvEOSqXyCvrCgkBfiMztEL
        A4fk4xyg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55112)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mb3ga-0001Xl-NR; Thu, 14 Oct 2021 17:34:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mb3gZ-0002IY-5e; Thu, 14 Oct 2021 17:34:27 +0100
Date:   Thu, 14 Oct 2021 17:34:27 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2 1/2] net: macb: Clean up macb_validate
Message-ID: <YWhcEzZzrE5lMxD4@shell.armlinux.org.uk>
References: <20211011165517.2857893-1-sean.anderson@seco.com>
 <163402758460.4280.9175185858026827934@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163402758460.4280.9175185858026827934@kwain>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 10:33:04AM +0200, Antoine Tenart wrote:
> Hello Sean,
> 
> Quoting Sean Anderson (2021-10-11 18:55:16)
> > As the number of interfaces grows, the number of if statements grows
> > ever more unweildy. Clean everything up a bit by using a switch
> > statement. No functional change intended.
> 
> I'm not 100% convinced this makes macb_validate more readable: there are
> lots of conditions, and jumps, in the switch.
> 
> Maybe you could try a mixed approach; keeping the invalid modes checks
> (bitmap_zero) at the beginning and once we know the mode is valid using
> a switch statement. That might make it easier to read as this should
> remove lots of conditionals. (We'll still have the one/_NA checks
> though).

Some of this could be improved if we add the ability for a MAC to
specify the phy_interface_t modes that it supports as a bitmap
before calling phylink_create() - then we can have phylink check
that the mode is supported itself prior to calling the validate
handler.

You can find some patches that add the "supported_interfaces" masks
in git.armlinux.org.uk/linux-arm.git net-queue

and we could add to phylink_validate():

	if (!phy_interface_empty(pl->config->supported_interfaces) &&
	    !test_bit(state->interface, pl->config->supported_interfaces))
		return -EINVAL;

which should go a long way to simplifying a lot of these validation
implementations.

Any thoughts on that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
