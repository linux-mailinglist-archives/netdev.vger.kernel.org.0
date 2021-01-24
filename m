Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765A5301BE1
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 13:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbhAXMgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 07:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726614AbhAXMgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 07:36:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B3DC061573;
        Sun, 24 Jan 2021 04:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WYE60wX0pIl/kZwDTYiKILPY4lj+XNi4mogj/NMseJE=; b=DF8nLhl2YxyP+Q34aI4aw3KDP
        +u325ofu+z5PnLKiNiELVeRw6Is0s1wgXWE9NHElc0qnDLNZg+mRIs5YGwL6nJo0QGlx/+5mN7efF
        00gy8bCj2Meigmy22SApDgSApUw5fqrtnkyMVUrdKUIx/v6pz3HlBDg0YzpqTl2yG4/ZlQNh2N5Ij
        /3JimAi1HtLaJQxUPW+zPr5Ja9G26WoXv1NtgZQhPWTx4blRQmaWDC//U2LX95sdzDYK4FBzNnnIZ
        tVCNeEAJRD62JtFcthes4bZHO5rmdSYG7Y1EuI+3szLuh1KBIdup8ScfbShpcN6QDuLcZuX61FDtC
        HVfePgmcA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52110)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3ecW-0002NN-Ac; Sun, 24 Jan 2021 12:35:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3ecU-0001h3-Sd; Sun, 24 Jan 2021 12:35:54 +0000
Date:   Sun, 24 Jan 2021 12:35:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org, mw@semihalf.com,
        andrew@lunn.ch, atenart@kernel.org
Subject: Re: [PATCH v2 RFC net-next 13/18] net: mvpp2: add ethtool flow
 control configuration support
Message-ID: <20210124123554.GW1551@shell.armlinux.org.uk>
References: <1611488647-12478-1-git-send-email-stefanc@marvell.com>
 <1611488647-12478-14-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611488647-12478-14-git-send-email-stefanc@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 01:44:02PM +0200, stefanc@marvell.com wrote:
> @@ -6407,6 +6490,29 @@ static void mvpp2_mac_link_up(struct phylink_config *config,
>  			     val);
>  	}
>  
> +	if (tx_pause && port->priv->global_tx_fc) {
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
> +

It seems this can be written more succinctly:

	if (port->priv->global_tx_fc) {
		port->tx_fc = tx_pause;
		if (tx_pause)
			mvpp2_rxq_enable_fc(port);
		else
			mvpp2_rxq_disable_fc(port);
		if (port->priv->percpu_pools) {
			for (i = 0; i < port->nrxqs; i++)
				mvpp2_bm_pool_update_fc(port,
						&port->priv->bm_pools[i],
						tx_pause);
		} else {
			mvpp2_bm_pool_update_fc(port, port->pool_long,
						tx_pause);
			mvpp2_bm_pool_update_fc(port, port->pool_short,
						tx_pause);
		}
	}

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
