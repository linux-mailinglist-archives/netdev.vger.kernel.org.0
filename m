Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9A5F496B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJDSsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJDSst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:48:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8936A4B6;
        Tue,  4 Oct 2022 11:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dF82zEweBR6fURXs87QKoPIU10/wyDMoBMuKcKxbCsw=; b=d0wFHXUGjqakfSh7afsSgf3RRB
        OT8a0L76nJh3fk/DCEhHtF8iYPeVQKVOexG133WwReAh9NXuOBwZEnIx4Xl0kyKihbyxUPx4i+zQj
        eC7ERK6/BNr8qbSs005EU7PeROav2iTSEeZHTFgg8KAUMFjmoEUygbP/zfVQpD6X5iKMRxAQWok2f
        xZum0cUHhxAjlt1XkKUV3P8B3sezjfw1r/IRycgtAnbFOAB8hqK3XAPJuEiy6gm6rfLS8HhJjBLal
        7Rl1eizXkUJ8P/kGvr0f1heBrU3HvvB1jK8W5DoveYwiFIS31Dxb/pMBufvlD7LJnoKqKTpiHlc5b
        9V3vvf9A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34586)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ofmy4-0008Le-Nz; Tue, 04 Oct 2022 19:48:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ofmy0-0004bi-Eh; Tue, 04 Oct 2022 19:48:32 +0100
Date:   Tue, 4 Oct 2022 19:48:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v6 6/9] net: dpaa: Convert to phylink
Message-ID: <YzyAADoHpExvo6XE@shell.armlinux.org.uk>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
 <20220930200933.4111249-7-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930200933.4111249-7-sean.anderson@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 04:09:30PM -0400, Sean Anderson wrote:
> +static void memac_validate(struct phylink_config *config,
> +			   unsigned long *supported,
> +			   struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +	struct fman_mac *memac = fman_config_to_mac(config)->fman_mac;
> +
> +	phylink_generic_validate(config, supported, state);
> +
> +	if (phy_interface_mode_is_rgmii(state->interface) &&
> +	    memac->rgmii_no_half_duplex) {
> +		phylink_caps_to_linkmodes(mask, MAC_10HD | MAC_100HD);
> +		linkmode_andnot(supported, supported, mask);
> +		linkmode_andnot(state->advertising, state->advertising, mask);
> +	}
> +}

Having been through the rest of this with a fine tooth comb, nothing
else stands out with the exception of the above, which I think could
be done better with this patch:

http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e65a47c4053255bd51715d5550e21c869971258c

Since the above would become:

static void memac_validate(struct phylink_config *config,
			   unsigned long *supported,
			   struct phylink_link_state *state)
{
	struct mac_device *mac_dev = fman_config_to_mac(config);
	struct fman_mac *memac = mac_dev->fman_mac;
	unsigned long caps;

	caps = mac_dev->phylink_config.capabilities;

	if (phy_interface_mode_is_rgmii(state->interface) &&
	    memac->rgmii_no_half_duplex)
		caps &= ~(MAC_10HD | MAC_100HD);

	phylink_validate_mask_caps(supported, state, caps);
}

If you want to pick up my patch that adds this helper into your series,
please do.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
