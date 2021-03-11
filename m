Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA27336C69
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 07:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhCKGoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 01:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhCKGnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 01:43:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56729C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 22:43:55 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1lKF2o-0004X3-7r; Thu, 11 Mar 2021 07:43:38 +0100
Received: from pza by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1lKF2m-0002Gt-Ly; Thu, 11 Mar 2021 07:43:36 +0100
Date:   Thu, 11 Mar 2021 07:43:36 +0100
From:   Philipp Zabel <pza@pengutronix.de>
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <20210311064336.GA6206@pengutronix.de>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:38:04 up 21 days, 10:01, 47 users,  load average: 0.05, 0.11,
 0.09
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cristian,

On Thu, Mar 11, 2021 at 03:20:13AM +0200, Cristian Ciocaltea wrote:
> Add new driver for the Ethernet MAC used on the Actions Semi Owl
> family of SoCs.
> 
> Currently this has been tested only on the Actions Semi S500 SoC
> variant.
> 
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
> ---
[...]
> diff --git a/drivers/net/ethernet/actions/owl-emac.c b/drivers/net/ethernet/actions/owl-emac.c
> new file mode 100644
> index 000000000000..ebd8ea88bca4
> --- /dev/null
> +++ b/drivers/net/ethernet/actions/owl-emac.c
> @@ -0,0 +1,1660 @@
[...]
> +static int owl_emac_probe(struct platform_device *pdev)
> +{
[...]
> +	priv->reset = devm_reset_control_get(dev, NULL);

Please use

	priv->reset = devm_reset_control_get_exclusive(dev, NULL);

instead, to explicitly state that the driver requires exclusive
control over the reset line.

> +	if (IS_ERR(priv->reset)) {
> +		ret = PTR_ERR(priv->reset);
> +		dev_err(dev, "failed to get reset control: %d\n", ret);
> +		return ret;

You could use:

		return dev_err_probe(dev, PTR_ERR(priv->reset),
				     "failed to get reset control");

regards
Philipp
