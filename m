Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB01E9F6CB
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfH0XVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 19:21:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbfH0XVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 19:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yyggdSixggZVwfbhlugdOIVryJszIf73PbIlhGxQlis=; b=i1eZ/8Msx8EtiwwMlgoRL+rtjW
        aZfgF4Nrm27aAl30yOLSMtnhfFB36ilBngdm5e9cCif/P36AeOomcLGgnkj/0kFdPtAYO1GadbWAr
        mZucsMLCl9Rotf4ceNveZx8eVMz3Kl/qfyNO68lrOe1m9RynIhQDpc2zWQ4I2kh35ODU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2kmK-0007In-7U; Wed, 28 Aug 2019 01:21:32 +0200
Date:   Wed, 28 Aug 2019 01:21:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next v2 3/3] dpaa2-eth: Add pause frame support
Message-ID: <20190827232132.GD26248@lunn.ch>
References: <1566915351-32075-1-git-send-email-ruxandra.radulescu@nxp.com>
 <1566915351-32075-3-git-send-email-ruxandra.radulescu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566915351-32075-3-git-send-email-ruxandra.radulescu@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 05:15:51PM +0300, Ioana Radulescu wrote:
> Starting with firmware version MC10.18.0, we have support for
> L2 flow control. Asymmetrical configuration (Rx or Tx only) is
> supported, but not pause frame autonegotioation.

> +static int set_pause(struct dpaa2_eth_priv *priv)
> +{
> +	struct device *dev = priv->net_dev->dev.parent;
> +	struct dpni_link_cfg link_cfg = {0};
> +	int err;
> +
> +	/* Get the default link options so we don't override other flags */
> +	err = dpni_get_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
> +	if (err) {
> +		dev_err(dev, "dpni_get_link_cfg() failed\n");
> +		return err;
> +	}
> +
> +	link_cfg.options |= DPNI_LINK_OPT_PAUSE;
> +	link_cfg.options &= ~DPNI_LINK_OPT_ASYM_PAUSE;
> +	err = dpni_set_link_cfg(priv->mc_io, 0, priv->mc_token, &link_cfg);
> +	if (err) {
> +		dev_err(dev, "dpni_set_link_cfg() failed\n");
> +		return err;
> +	}
> +
> +	priv->link_state.options = link_cfg.options;
> +
> +	return 0;
> +}
> +
>  /* Configure the DPNI object this interface is associated with */
>  static int setup_dpni(struct fsl_mc_device *ls_dev)
>  {
> @@ -2500,6 +2562,13 @@ static int setup_dpni(struct fsl_mc_device *ls_dev)
>  
>  	set_enqueue_mode(priv);
>  
> +	/* Enable pause frame support */
> +	if (dpaa2_eth_has_pause_support(priv)) {
> +		err = set_pause(priv);
> +		if (err)
> +			goto close;

Hi Ioana

So by default you have the MAC do pause, not asym pause?  Generally,
any MAC that can do asym pause does asym pause.

But if this is what you want, it is not wrong.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
