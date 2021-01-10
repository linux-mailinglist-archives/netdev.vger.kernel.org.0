Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7B82F08FE
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAJSQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbhAJSQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:16:05 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44931C061786;
        Sun, 10 Jan 2021 10:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=O+uPm9U2WIb+ZW77mowWQe4OrWj3S34uU87jdrERcxY=; b=hGFI+0OTX1DkDmIAEEmDzCpkS
        fOr2Yqf4oaKMbSPGw70B6JLLg+hPe291w2jW/SunnICFKGMFLnERrBVq3+Y7mwztnLFyR5bMlyyuu
        7MkWWCOjHcmEYsI6hnOJfYaP3KobpSq1873mjnRtZ0TFbOdPsoaV1oMMCK7X4Yr3l5O7dsIPyEiD/
        +OqG3lpDV8xn0xTZAf9+GEAZBPeGfNGejuGFcbVIfnnaa6bKhI5Th1B0W6P/GAz5gNt3ssvq4LTKj
        OEjK7l7C4uXo3SoIMId40N2IKmeJtf15ggjwwpKwmtulCkbxavw1MHFsl4kqZyfX6ysgpapXPq5gl
        XIXIdoCqg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46252)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfFJ-00065a-AM; Sun, 10 Jan 2021 18:15:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfFH-0004QE-8l; Sun, 10 Jan 2021 18:15:19 +0000
Date:   Sun, 10 Jan 2021 18:15:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH RFC net-next  14/19] net: mvpp2: add ethtool flow control
 configuration support
Message-ID: <20210110181519.GJ1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-15-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610292623-15564-15-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:30:18PM +0200, stefanc@marvell.com wrote:
> @@ -5373,6 +5402,30 @@ static int mvpp2_ethtool_set_pause_param(struct net_device *dev,
>  					 struct ethtool_pauseparam *pause)
>  {
>  	struct mvpp2_port *port = netdev_priv(dev);
> +	int i;
> +
> +	if (pause->tx_pause && port->priv->global_tx_fc) {
> +		port->tx_fc = true;
> +		mvpp2_rxq_enable_fc(port);
> +		if (port->priv->percpu_pools) {
> +			for (i = 0; i < port->nrxqs; i++)
> +				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], true);
> +		} else {
> +			mvpp2_bm_pool_update_fc(port, port->pool_long, true);
> +			mvpp2_bm_pool_update_fc(port, port->pool_short, true);
> +		}
> +
> +	} else if (port->priv->global_tx_fc) {
> +		port->tx_fc = false;
> +		mvpp2_rxq_disable_fc(port);
> +		if (port->priv->percpu_pools) {
> +			for (i = 0; i < port->nrxqs; i++)
> +				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i], false);
> +		} else {
> +			mvpp2_bm_pool_update_fc(port, port->pool_long, false);
> +			mvpp2_bm_pool_update_fc(port, port->pool_short, false);
> +		}
> +	}

This doesn't look correct to me. This function is only called when
ethtool -A is used to change the flow control settings. This is not
the place to be configuring flow control, as flow control is
negotiated with the link partner.

The final resolved flow control settings are available in
mvpp2_mac_link_up() via the tx_pause and rx_pause parameters.

What also concerns me is whether flow control is supported in the
existing driver at all, given this patch set. If it isn't supported
without the firmware's help, then we should _not_ be negotiating flow
control with the link partner unless we actually support it, so the
Pause and Asym_Pause bits in mvpp2_phylink_validate() should be
cleared.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
