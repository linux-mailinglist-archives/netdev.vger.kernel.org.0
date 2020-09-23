Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8407D2764A8
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIWXh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:37:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:2728 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726419AbgIWXh5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 19:37:57 -0400
IronPort-SDR: 28NqNpMJG/m5adPOJgcPoH/Wi/DWIsjXLrxREvyuBR3LyFsim7blEk7tYL9mR/OAlCoSMQITrz
 xrr8nVrnRGnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158399686"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158399686"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 16:37:57 -0700
IronPort-SDR: WdTdzfVzp3Lt4/dSGVRMHwVmN1s8WAVnIUCVfH5cqidBiXhfihNDyd5b8mtVi965r3q1WvMTHU
 AgQ52VeEmwkg==
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="511260588"
Received: from smtp.ostc.intel.com ([10.54.29.231])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 16:37:57 -0700
Received: from localhost (mtg-dev.jf.intel.com [10.54.74.10])
        by smtp.ostc.intel.com (Postfix) with ESMTP id 20DE26369;
        Wed, 23 Sep 2020 16:37:04 -0700 (PDT)
Date:   Wed, 23 Sep 2020 16:37:04 -0700
From:   mark gross <mgross@linux.intel.com>
To:     Voon Weifeng <weifeng.voon@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>
Subject: Re: [PATCH v1 net] net: stmmac: removed enabling eee in EEE set
 callback
Message-ID: <20200923233704.GE56905@mtg-dev.jf.intel.com>
Reply-To: mgross@linux.intel.com
References: <20200923085614.8147-1-weifeng.voon@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923085614.8147-1-weifeng.voon@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Mark Gross <mgross@linux.intel.com>

On Wed, Sep 23, 2020 at 04:56:14PM +0800, Voon Weifeng wrote:
> EEE should be only be enabled during stmmac_mac_link_up() when the
> link are up and being set up properly. set_eee should only do settings
> configuration and disabling the eee.
> 
> Without this fix, turning on EEE using ethtool will return
> "Operation not supported". This is due to the driver is in a dead loop
> waiting for eee to be advertised in the for eee to be activated but the
> driver will only configure the EEE advertisement after the eee is
> activated.
> 
> Ethtool should only return "Operation not supported" if there is no EEE
> capbility in the MAC controller.
> 
> Fixes: 8a7493e58ad6 ("net: stmmac: Fix a race in EEE enable callback")
> 
> Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c  | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> index ac5e8cc5fb9f..430a4b32ec1e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
> @@ -675,23 +675,16 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
>  	struct stmmac_priv *priv = netdev_priv(dev);
>  	int ret;
>  
> -	if (!edata->eee_enabled) {
> +	if (!priv->dma_cap.eee)
> +		return -EOPNOTSUPP;
> +
> +	if (!edata->eee_enabled)
>  		stmmac_disable_eee_mode(priv);
> -	} else {
> -		/* We are asking for enabling the EEE but it is safe
> -		 * to verify all by invoking the eee_init function.
> -		 * In case of failure it will return an error.
> -		 */
> -		edata->eee_enabled = stmmac_eee_init(priv);
> -		if (!edata->eee_enabled)
> -			return -EOPNOTSUPP;
> -	}
>  
>  	ret = phylink_ethtool_set_eee(priv->phylink, edata);
>  	if (ret)
>  		return ret;
>  
> -	priv->eee_enabled = edata->eee_enabled;
>  	priv->tx_lpi_timer = edata->tx_lpi_timer;
>  	return 0;
>  }
> -- 
> 2.17.1
> 
