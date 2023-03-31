Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E908C6D2651
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjCaQy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjCaQyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:54:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4FE1CBAC
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 09:54:29 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1piI0q-0007MO-3L; Fri, 31 Mar 2023 18:54:04 +0200
Message-ID: <24d12b0e-0a96-4027-988a-16b433572f68@pengutronix.de>
Date:   Fri, 31 Mar 2023 18:53:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [Linux-stm32] [PATCH v2 2/2] net: stmmac: dwmac-imx: use platform
 specific reset for imx93 SoCs
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Cc:     imx@lists.linux.dev, linux-kernel@vger.kernel.org,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Wong Vee Khee <veekhee@apple.com>,
        Jose Abreu <joabreu@synopsys.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Fabio Estevam <festevam@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Revanth Kumar Uppala <ruppala@nvidia.com>
References: <20230331163143.52506-1-shenwei.wang@nxp.com>
 <20230331163143.52506-2-shenwei.wang@nxp.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230331163143.52506-2-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Shenwei,

On 31.03.23 18:31, Shenwei Wang wrote:
> The patch addresses an issue with the reset logic on the i.MX93 SoC, which
> requires configuration of the correct interface speed under RMII mode to
> complete the reset. The patch implements a fix_soc_reset function and uses
> it specifically for the i.MX93 SoCs.

[...]

>  static int
>  imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
>  {
> @@ -305,6 +327,9 @@ static int imx_dwmac_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_dwmac_init;
>  
> +	if (of_machine_is_compatible("fsl,imx93"))
> +		dwmac->plat_dat->fix_soc_reset = imx_dwmac_mx93_reset;

imx_dwmac_mx93_reset is accessing eqos registers in an eqos driver. I don't
see why you need to check against SoC compatible instead of device compatible
here.

My suggestion is to add fix_soc_reset to the struct imx_dwmac_ops associated
with "nxp,imx93-dwmac-eqos" compatible and use that to populate
plat_dat->fix_soc_reset unconditionally.

Thanks,
Ahmad


> +
>  	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>  	if (ret)
>  		goto err_drv_probe;

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

