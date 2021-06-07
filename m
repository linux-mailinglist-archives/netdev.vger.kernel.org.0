Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC8A39D905
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFGJry convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Jun 2021 05:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGJrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 05:47:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082F3C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 02:46:03 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lqBpJ-0000ke-06; Mon, 07 Jun 2021 11:45:45 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lqBpE-00032G-DJ; Mon, 07 Jun 2021 11:45:40 +0200
Message-ID: <b89d828a08528aaa07e3527d254785f1e40b9bee.camel@pengutronix.de>
Subject: Re: [PATCH v2] net: stmmac: explicitly deassert GMAC_AHB_RESET
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     bjorn.andersson@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Mon, 07 Jun 2021 11:45:40 +0200
In-Reply-To: <20210606103019.2807397-1-mnhagan88@gmail.com>
References: <3436f8f0-77dc-d4ff-4489-e9294c434a08@gmail.com>
         <20210606103019.2807397-1-mnhagan88@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-06-06 at 11:30 +0100, Matthew Hagan wrote:
> We are currently assuming that GMAC_AHB_RESET will already be deasserted
> by the bootloader. However if this has not been done, probing of the GMAC
> will fail. To remedy this we must ensure GMAC_AHB_RESET has been deasserted
> prior to probing.
> 
> v2 changes:
>  - remove NULL condition check for stmmac_ahb_rst in stmmac_main.c
>  - unwrap dev_err() message in stmmac_main.c
>  - add PTR_ERR() around plat->stmmac_ahb_rst in stmmac_platform.c
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ++++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
>  include/linux/stmmac.h                                | 1 +
>  3 files changed, 12 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 6d41dd6f9f7a..0d4cb423cbbd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -6840,6 +6840,10 @@ int stmmac_dvr_probe(struct device *device,
>  			reset_control_reset(priv->plat->stmmac_rst);
>  	}
>  
> +	ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
> +	if (ret == -ENOTSUPP)
> +		dev_err(priv->device, "unable to bring out of ahb reset\n");
> +

I would make this

	if (ret)
		dev_err(priv->device, "unable to bring out of ahb reset: %pe\n", ERR_PTR(ret));

Also consider asserting the reset again in the remove path. Or is there
a reason not to?

With that addressed,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
