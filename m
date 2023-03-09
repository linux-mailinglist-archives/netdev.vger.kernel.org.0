Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299516B1BEE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCIHFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCIHEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:04:54 -0500
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D16609F226;
        Wed,  8 Mar 2023 23:04:52 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id BEF0480DE;
        Thu,  9 Mar 2023 07:04:51 +0000 (UTC)
Date:   Thu, 9 Mar 2023 09:04:50 +0200
From:   Tony Lindgren <tony@atomide.com>
To:     MD Danish Anwar <danishanwar@ti.com>
Cc:     "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros <rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Nishanth Menon <nm@ti.com>, linux-remoteproc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, srk@ti.com, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] soc: ti: pruss: Add helper function to enable OCP
 master ports
Message-ID: <20230309070450.GE7501@atomide.com>
References: <20230306110934.2736465-1-danishanwar@ti.com>
 <20230306110934.2736465-6-danishanwar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306110934.2736465-6-danishanwar@ti.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* MD Danish Anwar <danishanwar@ti.com> [230306 11:10]:
> From: Suman Anna <s-anna@ti.com>
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
> +
> +disable:
> +	pruss_cfg_update(pruss, PRUSS_CFG_SYSCFG, SYSCFG_STANDBY_INIT,
> +			 SYSCFG_STANDBY_INIT);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pruss_cfg_ocp_master_ports);

The above you should no longer be needed, see for example am33xx-l4.dtsi
for pruss_tm: target-module@300000. The SYSCFG register is managed by
drivers/bus/ti-sysc.c using compatible "ti,sysc-pruss", and the "sysc"
reg-names property. So when any of the child devices do pm_runtime_get()
related functions, the PRUSS top level interconnect target module is
automatically enabled and disabled as needed.

If there's something still missing like dts configuration for some SoCs,
or quirk handling in ti-sysc.c, let's fix those instead so we can avoid
exporting a custom function for pruss_cfg_ocp_master_ports.

Regards,

Tony
