Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCC204438
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbgFVXEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730785AbgFVXEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:04:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90470C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 16:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aRUdXlae828RD1Vwzx7C8ugwcxm/EpwywdfaZwpuYmw=; b=H8EbDKXUJ16D9eHNWdlXqgdOe
        oi2dgQydaEMVYS5XHh171ZHnM5/Wv3lAfJdhSA0xBi6bgXmWoD7Yv2gBZbQ1uNTmLKxZKK3mns+bi
        cA0psHfgnTqG7D83spJNhk0ZkfRpmS6wcWmnzlEjax+T5CSgKdqbItUniMJWxiOWDp3DVngOv4oKN
        LNz1OBFG86Zmm+Gmfs30z60pjYwpmNXhpyap/mHTm8Ix+N2KUyxHnt3uz+qMa7Y0Fx53p3/u4P2j7
        x4QLWVUUuw1etfy59d+Q98ux3+BLL/spqIqya3MSvJEF4E6R/UtxscBCUWQmP+RqIRbAua2RY4t16
        G+fMVgkpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58990)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnVTv-0000zv-Fi; Tue, 23 Jun 2020 00:04:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnVTu-0000S6-DY; Tue, 23 Jun 2020 00:04:02 +0100
Date:   Tue, 23 Jun 2020 00:04:02 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next v3 4/9] net: phy: add Lynx PCS module
Message-ID: <20200622230402.GP1551@shell.armlinux.org.uk>
References: <20200621225451.12435-1-ioana.ciornei@nxp.com>
 <20200621225451.12435-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200621225451.12435-5-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just spotted something else...

On Mon, Jun 22, 2020 at 01:54:46AM +0300, Ioana Ciornei wrote:
> +static void lynx_pcs_get_state_2500basex(struct mdio_device *pcs,
> +					 struct phylink_link_state *state)
> +{
> +	struct mii_bus *bus = pcs->bus;
> +	int addr = pcs->addr;
> +	int bmsr, lpa;
> +
> +	bmsr = mdiobus_read(bus, addr, MII_BMSR);
> +	lpa = mdiobus_read(bus, addr, MII_LPA);
> +	if (bmsr < 0 || lpa < 0) {
> +		state->link = false;
> +		return;
> +	}
> +
> +	state->link = !!(bmsr & BMSR_LSTATUS);
> +	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
> +	if (!state->link)
> +		return;
> +
> +	state->speed = SPEED_2500;

You seem to have missed setting state->duplex here - it defaults to
DUPLEX_UNKNOWN, and will remain as such, which is probably not what
you want.

> +	state->pause |= MLO_PAUSE_TX | MLO_PAUSE_RX;
> +}
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
