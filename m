Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5635F4498B4
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 16:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239119AbhKHPsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 10:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbhKHPsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 10:48:42 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B056C061570;
        Mon,  8 Nov 2021 07:45:58 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id b15so44922485edd.7;
        Mon, 08 Nov 2021 07:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVza8bc+buwzI929X8sHOlCTGiVgpXXZXYwI8Fybjx0=;
        b=phVki65L5hxv+xQOyJZrMNRFTbKH8OSIgDhhxuQwrxszhIsMEYK2tLOpFd6UvSQPhZ
         tzin2L3SCtV4nnTmGGJee1cW3YYxd2bTzWjqD9czUAc0h44JLEhAKGuwEmZB6EaBSfJo
         aZRUcsFCRMxgBKkmcuGfNo0wHG/5hbZG8j/GZ5Tae7vFKszVoaG7AF0a3LjEmzjYOhZ0
         RYXNe9hex9CxKhRjDVTeUKxGdC5eJBSheHLCJWgEsbiPt9X4UqRvrzxeKDoDoGtHx53u
         STkv5P52gd9jJpYVeCz1rbzirDzJU4brHGIaFJT8ndihadb6Y6Bk5i8AK3cinOYPniap
         Y/Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVza8bc+buwzI929X8sHOlCTGiVgpXXZXYwI8Fybjx0=;
        b=REHhksjps6yNzIc69n1YuaARm+H5CAEkZqgT+y9Ow+OVUFaxlCB5f9sfU08C78FMH/
         FNlKelY7SS8NcFlgzyVOPkKCRm/dq0tk4PVcNgId+huL/tgPq/NmN5DxkyLN4TAnkbJt
         I45bsWPRub4NOwffryVYRH0PrDCTEEcqVvZKw0/a9OVXiIUK8HXU80SDP5+VyMUZKj9Q
         CuKiNg6FOTZgFA+0+IOE4+8yjX+l8fpYFg1cfuop1sQ3Wsz9FWB+ygLG3vXIH74bp5LT
         GYOZonqSEz6P5iiMOGoVXb8Gj2EK6HFV9DaNng+U+hzB0JmH3iRI4+TjCzlkVZXuT91Q
         qv8g==
X-Gm-Message-State: AOAM531xlqni2wglrbvyeJdUV/cSFNzCicAqgO+qdTZ+u6bt9EZE3krs
        9jyZwkhazefX+znknpuo5iA=
X-Google-Smtp-Source: ABdhPJwJmcAuxFWPTO6M9QJsOkA9H+B2EKW7FArIW5Jx9cV/hYP96PeZTzf5PPn+RN4BVA5Gqqtdvg==
X-Received: by 2002:a17:907:3f18:: with SMTP id hq24mr302251ejc.506.1636386356512;
        Mon, 08 Nov 2021 07:45:56 -0800 (PST)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id f7sm9536865edl.33.2021.11.08.07.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 07:45:56 -0800 (PST)
Date:   Mon, 8 Nov 2021 17:45:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: Fix VLAN filter delete timeout
 issue in Intel mGBE SGMII
Message-ID: <20211108154554.axd2lmm2a3gw6vfu@skbuf>
References: <20210305054930.7434-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305054930.7434-1-boon.leong.ong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 05, 2021 at 01:49:30PM +0800, Ong Boon Leong wrote:
> For Intel mGbE controller, MAC VLAN filter delete operation will time-out
> if serdes power-down sequence happened first during driver remove() with
> below message.
> 
> [82294.764958] intel-eth-pci 0000:00:1e.4 eth2: stmmac_dvr_remove: removing driver
> [82294.778677] intel-eth-pci 0000:00:1e.4 eth2: Timeout accessing MAC_VLAN_Tag_Filter
> [82294.779997] intel-eth-pci 0000:00:1e.4 eth2: failed to kill vid 0081/0
> [82294.947053] intel-eth-pci 0000:00:1d.2 eth1: stmmac_dvr_remove: removing driver
> [82295.002091] intel-eth-pci 0000:00:1d.1 eth0: stmmac_dvr_remove: removing driver
> 
> Therefore, we delay the serdes power-down to be after unregister_netdev()
> which triggers the VLAN filter delete.
> 
> Fixes: b9663b7ca6ff ("net: stmmac: Enable SERDES power up/down sequence")
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 0eba44e9c1f8..208cae344ffa 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5249,13 +5249,16 @@ int stmmac_dvr_remove(struct device *dev)
>  	netdev_info(priv->dev, "%s: removing driver", __func__);
>  
>  	stmmac_stop_all_dma(priv);
> +	stmmac_mac_set(priv, priv->ioaddr, false);
> +	netif_carrier_off(ndev);
> +	unregister_netdev(ndev);
>  
> +	/* Serdes power down needs to happen after VLAN filter
> +	 * is deleted that is triggered by unregister_netdev().
> +	 */
>  	if (priv->plat->serdes_powerdown)
>  		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
>  
> -	stmmac_mac_set(priv, priv->ioaddr, false);
> -	netif_carrier_off(ndev);
> -	unregister_netdev(ndev);
>  #ifdef CONFIG_DEBUG_FS
>  	stmmac_exit_fs(ndev);
>  #endif
> -- 
> 2.17.0
> 

Don't you also want to fix the probe path?

stmmac_dvr_probe:
	ret = register_netdev(ndev);
	if (ret) {
		dev_err(priv->device, "%s: ERROR %i registering the device\n",
			__func__, ret);
		goto error_netdev_register;
	}

	if (priv->plat->serdes_powerup) {
		ret = priv->plat->serdes_powerup(ndev,
						 priv->plat->bsp_priv);

		if (ret < 0)
			goto error_serdes_powerup;
	}

Since the device can start being used immediately after registration, it
depends upon the SERDES clock being powered up.
