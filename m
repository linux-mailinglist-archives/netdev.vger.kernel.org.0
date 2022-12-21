Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A76536A4
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 19:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbiLUSu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 13:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiLUSuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 13:50:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4226549;
        Wed, 21 Dec 2022 10:50:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671648634; x=1703184634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z01BVsejbngTM6ruRmidtKJYXyXGIth2OroyVk1DGBk=;
  b=hrvHIUU3/2K7c3DF4f1EFgOsTUesWCoGp14cWmIiGP0plC/2cc2t6Xnb
   j7DWxg3Vsl2JPQETTSvhj953mhDw+SIS8cpzCtIB5+fM+cFBJzb8us9Hq
   gNY/Cif9BupG3lXbz1rPIpu1w9DtTUVskTrg/qMaUsCh8EqlCFu8McmyM
   KBAl8EzvbR6KetrLv/wKvcvb9yaIhCrsqMzMsMHrj1wJbXkRm4n4PxS5Q
   cf4vuy1CtldZsBl3s1d6bqwye4VfmTFo92IPeqNNxPNfhVq5iTv6Qi8cO
   +HZq0J1ZF4oPim9I7Q/AAiCfmcJngPdGlXzWh8jDptaONKvOzTX/jYCKH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="319999393"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="319999393"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 10:50:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10568"; a="653595156"
X-IronPort-AV: E=Sophos;i="5.96,263,1665471600"; 
   d="scan'208";a="653595156"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 10:50:31 -0800
Date:   Wed, 21 Dec 2022 19:50:23 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Krzysztof Halasa <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khc@pm.waw.pl>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ixp4xx_eth: Fix an error handling path in
 ixp4xx_eth_probe()
Message-ID: <Y6NVb8igxFCwwdw5@localhost.localdomain>
References: <3ab37c3934c99066a124f99e73c0fc077fcb69b4.1671607040.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab37c3934c99066a124f99e73c0fc077fcb69b4.1671607040.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 21, 2022 at 08:17:52AM +0100, Christophe JAILLET wrote:
> If an error occurs after a successful ixp4xx_mdio_register() call, it
> should be undone by a corresponding ixp4xx_mdio_remove().

What about error when mdio_bus is 0? It means that mdio_register can
return no error, but sth happen and there is no need to call mdio_remove
in this case?

I mean:
 /* If the instance with the MDIO bus has not yet appeared,
  * defer probing until it gets probed.
  */
  if (!mdio_bus)
	return -EPROBE_DEFER;
> 
> Add the missing call in the error handling path, as already done in the
> remove function.
> 
> Fixes: 2098c18d6cf6 ("IXP4xx: Add PHYLIB support to Ethernet driver.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> index 3b0c5f177447..007d68b385a5 100644
> --- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
> +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> @@ -1490,8 +1490,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  
>  	netif_napi_add_weight(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
netif_napi_add_weight() doesn't need to be unrolled in case of error
(call netif_napi_del() or something)?

Thanks

>  
> -	if (!(port->npe = npe_request(NPE_ID(port->id))))
> -		return -EIO;
> +	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
> +		err = -EIO;
> +		goto err_remove_mdio;
> +	}
>  
>  	port->plat = plat;
>  	npe_port_tab[NPE_ID(port->id)] = port;
> @@ -1530,6 +1532,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
>  err_free_mem:
>  	npe_port_tab[NPE_ID(port->id)] = NULL;
>  	npe_release(port->npe);
> +err_remove_mdio:
> +	ixp4xx_mdio_remove();
>  	return err;
>  }
>  
> -- 
> 2.34.1
> 
