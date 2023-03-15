Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5887A6BB11B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbjCOMYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbjCOMYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8CF94A78;
        Wed, 15 Mar 2023 05:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 376C961D55;
        Wed, 15 Mar 2023 12:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3ABC4339B;
        Wed, 15 Mar 2023 12:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678882944;
        bh=4GJSSVGMwZD38/Ejk6Cy5qgk/cy1eMuVjzNzpQ7gzOs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TsonW231iv0jJ+vihZdxLLaHHQHIIr77MPaTTDEFCRVthe9u2jV6VIb7oTKZdtJSG
         RA2WhLyTjGB2NuBTVoYl/VXcOBKWf7gdd1zONoSJf7y7glKaLbP0yoogvZiw8VzsLe
         IR9UiUWOBRMNLLU2/GAlV/IQECXHinZcaNK9EohcRhLETsuCR/NM8tsoYcizPoaVhu
         Veg1JTp6tFYPRDRafKnGRlQBhA61WLHcrD691moWlnaBR/2OaChI1Ms95XGwcG+wqh
         aFu5ykoDA9DqXRPm9AJQx1SOWqGLHoZiv2yTotXOxmV/1hGKXkL4j79DxhAD9YArHn
         Bdf3J+r8ZnuwQ==
Message-ID: <d168e7dd-42a0-b728-5c4c-e97209c13871@kernel.org>
Date:   Wed, 15 Mar 2023 14:22:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 4/5] soc: ti: pruss: Add helper functions to set GPI
 mode, MII_RT_event and XFR
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230313111127.1229187-1-danishanwar@ti.com>
 <20230313111127.1229187-5-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230313111127.1229187-5-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/03/2023 13:11, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The PRUSS CFG module is represented as a syscon node and is currently
> managed by the PRUSS platform driver. Add easy accessor functions to set
> GPI mode, MII_RT event enable/disable and XFR (XIN XOUT) enable/disable
> to enable the PRUSS Ethernet usecase. These functions reuse the generic
> pruss_cfg_update() API function.
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
> ---
>  drivers/soc/ti/pruss.c           | 60 ++++++++++++++++++++++++++++++++
>  include/linux/remoteproc/pruss.h | 22 ++++++++++++
>  2 files changed, 82 insertions(+)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 26d8129b515c..2f04b7922ddb 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -203,6 +203,66 @@ static int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>  	return regmap_update_bits(pruss->cfg_regmap, reg, mask, val);
>  }
>  
> +/**
> + * pruss_cfg_gpimode() - set the GPI mode of the PRU
> + * @pruss: the pruss instance handle
> + * @pru_id: id of the PRU core within the PRUSS
> + * @mode: GPI mode to set
> + *
> + * Sets the GPI mode for a given PRU by programming the
> + * corresponding PRUSS_CFG_GPCFGx register
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
> +		      enum pruss_gpi_mode mode)
> +{
> +	if (pru_id < 0 || pru_id >= PRUSS_NUM_PRUS)
> +		return -EINVAL;
> +
> +	if (mode < 0 || mode > PRUSS_GPI_MODE_MAX)
> +		return -EINVAL;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_GPCFG(pru_id),
> +				PRUSS_GPCFG_PRU_GPI_MODE_MASK,
> +				mode << PRUSS_GPCFG_PRU_GPI_MODE_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_gpimode);
> +
> +/**
> + * pruss_cfg_miirt_enable() - Enable/disable MII RT Events
> + * @pruss: the pruss instance
> + * @enable: enable/disable
> + *
> + * Enable/disable the MII RT Events for the PRUSS.
> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
> +{
> +	u32 set = enable ? PRUSS_MII_RT_EVENT_EN : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_MII_RT,
> +				PRUSS_MII_RT_EVENT_EN, set);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_miirt_enable);
> +
> +/**
> + * pruss_cfg_xfr_enable() - Enable/disable XIN XOUT shift functionality
> + * @pruss: the pruss instance
> + * @enable: enable/disable
> + * @mask: Mask for PRU / RTU

You should not expect the user to provide the mask but only
the core type e.g. 

enum pru_type {
        PRU_TYPE_PRU = 0,
        PRU_TYPE_RTU,
        PRU_TYPE_TX_PRU,
        PRU_TYPE_MAX,
};

Then you figure out the mask in the function.
Also check for invalid pru_type and return error if so.

> + *
> + * Return: 0 on success, or an error code otherwise
> + */
> +int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask)

re-arrange so it is (struct pruss, enum pru_type, bool enable)

> +{
> +	u32 set = enable ? mask : 0;
> +
> +	return pruss_cfg_update(pruss, PRUSS_CFG_SPP, mask, set);
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_xfr_enable);
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 12ef10b9fe9a..51a3eedd2be6 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -101,6 +101,7 @@ enum pruss_gpi_mode {
>  	PRUSS_GPI_MODE_PARALLEL,
>  	PRUSS_GPI_MODE_28BIT_SHIFT,
>  	PRUSS_GPI_MODE_MII,
> +	PRUSS_GPI_MODE_MAX,

This could have come as part of patch 3.

>  };
>  
>  /**
> @@ -165,6 +166,10 @@ int pruss_request_mem_region(struct pruss *pruss, enum pruss_mem mem_id,
>  			     struct pruss_mem_region *region);
>  int pruss_release_mem_region(struct pruss *pruss,
>  			     struct pruss_mem_region *region);
> +int pruss_cfg_gpimode(struct pruss *pruss, enum pruss_pru_id pru_id,
> +		      enum pruss_gpi_mode mode);
> +int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable);
> +int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask);
>  
>  #else
>  
> @@ -188,6 +193,23 @@ static inline int pruss_release_mem_region(struct pruss *pruss,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int pruss_cfg_gpimode(struct pruss *pruss,
> +				    enum pruss_pru_id pru_id,
> +				    enum pruss_gpi_mode mode)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_miirt_enable(struct pruss *pruss, bool enable)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline int pruss_cfg_xfr_enable(struct pruss *pruss, bool enable, u32 mask)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)

cheers,
-roger
