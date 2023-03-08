Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19846B01C4
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCHImT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjCHImG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:42:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5987884819;
        Wed,  8 Mar 2023 00:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE637616EF;
        Wed,  8 Mar 2023 08:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D041EC433D2;
        Wed,  8 Mar 2023 08:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678264914;
        bh=faVHU/dbuLKTk9WcMpfYqJi90mJwb8srK+ZMIZ6kqTI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gS6wxgULAeV6Rb/oxK814OTJ7EpMeYB3vSwzzCKh+ljzZ5PDfWH5bJakoFj/rAPAD
         YzxE8xDJ6K0q3qfHVQstzd1mo5QFS+f1xdxGSXeU2j5ikot4Rx5iHQG7fK49lotrQy
         gm+mmv8gddwo7iS6nBQkM01HJ39cF2eg3nmRPccLDvAAr+l3ghJJ6X3Lg5d0KLkL5W
         F9TXtr9bsaufW0zc4XV2CnB+YOVkbJIoyFEb1W1oUW47lsdtGyiRXIIAjOepbzf9oR
         O7WPDxipanSpjLdAElT48LpqC7cQP/Oi0M5V0On8Reu8Homg5s7bFH1PqLhm//G3RC
         /LJb0qtZHHJHQ==
Message-ID: <39879d9f-041b-9156-95a5-a81702721739@kernel.org>
Date:   Wed, 8 Mar 2023 10:41:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 5/6] soc: ti: pruss: Add helper function to enable OCP
 master ports
Content-Language: en-US
To:     MD Danish Anwar <danishanwar@ti.com>,
        "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>
Cc:     linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-6-danishanwar@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230306110934.2736465-6-danishanwar@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/03/2023 13:09, MD Danish Anwar wrote:
> From: Suman Anna <s-anna@ti.com>
> 
> The PRU-ICSS subsystem on OMAP-architecture based SoCS (AM33xx, AM437x
> and AM57xx SoCs) has a control bit STANDBY_INIT in the PRUSS_CFG register
> to initiate a Standby sequence (when set) and trigger a MStandby request
> to the SoC's PRCM module. This same bit is also used to enable the OCP
> master ports (when cleared). The clearing of the STANDBY_INIT bit requires
> an acknowledgment from PRCM and is done through the monitoring of the
> PRUSS_SYSCFG.SUB_MWAIT bit.
> 
> Add a helper function pruss_cfg_ocp_master_ports() to allow the PRU
> client drivers to control this bit and enable or disable the firmware
> running on PRU cores access to any peripherals or memory to achieve
> desired functionality. The access is disabled by default on power-up
> and on any suspend (context is not maintained).
> 
> Signed-off-by: Suman Anna <s-anna@ti.com>
> Co-developed-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Grzegorz Jaszczyk <grzegorz.jaszczyk@linaro.org>
> Signed-off-by: Puranjay Mohan <p-mohan@ti.com>
> ---
>  drivers/soc/ti/pruss.c           | 81 +++++++++++++++++++++++++++++++-
>  include/linux/remoteproc/pruss.h |  6 +++
>  2 files changed, 85 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/soc/ti/pruss.c b/drivers/soc/ti/pruss.c
> index 537a3910ffd8..dc3abda0b8c2 100644
> --- a/drivers/soc/ti/pruss.c
> +++ b/drivers/soc/ti/pruss.c
> @@ -22,14 +22,19 @@
>  #include <linux/remoteproc.h>
>  #include <linux/slab.h>
>  
> +#define SYSCFG_STANDBY_INIT	BIT(4)
> +#define SYSCFG_SUB_MWAIT_READY	BIT(5)
> +
>  /**
>   * struct pruss_private_data - PRUSS driver private data
>   * @has_no_sharedram: flag to indicate the absence of PRUSS Shared Data RAM
>   * @has_core_mux_clock: flag to indicate the presence of PRUSS core clock
> + * @has_ocp_syscfg: flag to indicate if OCP SYSCFG is present
>   */
>  struct pruss_private_data {
>  	bool has_no_sharedram;
>  	bool has_core_mux_clock;
> +	bool has_ocp_syscfg;
>  };
>  
>  /**
> @@ -205,6 +210,72 @@ int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>  }
>  EXPORT_SYMBOL_GPL(pruss_cfg_update);
>  
> +/**
> + * pruss_cfg_ocp_master_ports() - configure PRUSS OCP master ports
> + * @pruss: the pruss instance handle
> + * @enable: set to true for enabling or false for disabling the OCP master ports
> + *
> + * This function programs the PRUSS_SYSCFG.STANDBY_INIT bit either to enable or
> + * disable the OCP master ports (applicable only on SoCs using OCP interconnect
> + * like the OMAP family). Clearing the bit achieves dual functionalities - one
> + * is to deassert the MStandby signal to the device PRCM, and the other is to
> + * enable OCP master ports to allow accesses outside of the PRU-ICSS. The
> + * function has to wait for the PRCM to acknowledge through the monitoring of
> + * the PRUSS_SYSCFG.SUB_MWAIT bit when enabling master ports. Setting the bit
> + * disables the master access, and also signals the PRCM that the PRUSS is ready
> + * for Standby.
> + *
> + * Return: 0 on success, or an error code otherwise. ETIMEDOUT is returned
> + * when the ready-state fails.
> + */
> +int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
> +{
> +	int ret;
> +	u32 syscfg_val, i;
> +	const struct pruss_private_data *data;
> +
> +	if (IS_ERR_OR_NULL(pruss))
> +		return -EINVAL;
> +
> +	data = of_device_get_match_data(pruss->dev);
> +
> +	/* nothing to do on non OMAP-SoCs */
> +	if (!data || !data->has_ocp_syscfg)
> +		return 0;
> +
> +	/* assert the MStandby signal during disable path */
> +	if (!enable)
> +		return pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG,
> +					SYSCFG_STANDBY_INIT,
> +					SYSCFG_STANDBY_INIT);

You can omit the above if() if you just encapsulate the below in

if (enable) {


> +
> +	/* enable the OCP master ports and disable MStandby */
> +	ret = pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT, 0);
> +	if (ret)
> +		return ret;
> +
> +	/* wait till we are ready for transactions - delay is arbitrary */
> +	for (i = 0; i < 10; i++) {
> +		ret = pruss_cfg_read(pruss, PRUSS_CFG_SYSCFG, &syscfg_val);
> +		if (ret)
> +			goto disable;
> +
> +		if (!(syscfg_val & SYSCFG_SUB_MWAIT_READY))
> +			return 0;
> +
> +		udelay(5);
> +	}
> +
> +	dev_err(pruss->dev, "timeout waiting for SUB_MWAIT_READY\n");
> +	ret = -ETIMEDOUT;

}

> +
> +disable:
> +	pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
> +			 SYSCFG_STANDBY_INIT);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_ocp_master_ports);
> +
>  static void pruss_of_free_clk_provider(void *data)
>  {
>  	struct device_node *clk_mux_np = data;
> @@ -495,10 +566,16 @@ static int pruss_remove(struct platform_device *pdev)
>  /* instance-specific driver private data */
>  static const struct pruss_private_data am437x_pruss1_data = {
>  	.has_no_sharedram = false,
> +	.has_ocp_syscfg = true,
>  };
>  
>  static const struct pruss_private_data am437x_pruss0_data = {
>  	.has_no_sharedram = true,
> +	.has_ocp_syscfg = false,
> +};
> +
> +static const struct pruss_private_data am33xx_am57xx_data = {
> +	.has_ocp_syscfg = true,
>  };

How about keeping platform data for different platforms separate?

i.e. am33xx_pruss_data and am57xx_pruss_data

>  
>  static const struct pruss_private_data am65x_j721e_pruss_data = {
> @@ -506,10 +583,10 @@ static const struct pruss_private_data am65x_j721e_pruss_data = {
>  };
>  
>  static const struct of_device_id pruss_of_match[] = {
> -	{ .compatible = "ti,am3356-pruss" },
> +	{ .compatible = "ti,am3356-pruss", .data = &am33xx_am57xx_data },
>  	{ .compatible = "ti,am4376-pruss0", .data = &am437x_pruss0_data, },
>  	{ .compatible = "ti,am4376-pruss1", .data = &am437x_pruss1_data, },
> -	{ .compatible = "ti,am5728-pruss" },
> +	{ .compatible = "ti,am5728-pruss", .data = &am33xx_am57xx_data },
>  	{ .compatible = "ti,k2g-pruss" },
>  	{ .compatible = "ti,am654-icssg", .data = &am65x_j721e_pruss_data, },
>  	{ .compatible = "ti,j721e-icssg", .data = &am65x_j721e_pruss_data, },
> diff --git a/include/linux/remoteproc/pruss.h b/include/linux/remoteproc/pruss.h
> index 7952f250301a..8cb99d3cad0d 100644
> --- a/include/linux/remoteproc/pruss.h
> +++ b/include/linux/remoteproc/pruss.h
> @@ -168,6 +168,7 @@ int pruss_release_mem_region(struct pruss *pruss,
>  int pruss_cfg_read(struct pruss *pruss, unsigned int reg, unsigned int *val);
>  int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>  		     unsigned int mask, unsigned int val);
> +int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable);
>  
>  #else
>  
> @@ -203,6 +204,11 @@ static inline int pruss_cfg_update(struct pruss *pruss, unsigned int reg,
>  	return -EOPNOTSUPP;
>  }
>  
> +static inline int pruss_cfg_ocp_master_ports(struct pruss *pruss, bool enable)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #endif /* CONFIG_TI_PRUSS */
>  
>  #if IS_ENABLED(CONFIG_PRU_REMOTEPROC)

cheers,
-roger
