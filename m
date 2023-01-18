Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9359E6722E2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjARQW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjARQWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:22:02 -0500
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A3BD956EC2
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:18:59 -0800 (PST)
Received: (qmail 212574 invoked by uid 1000); 18 Jan 2023 11:18:58 -0500
Date:   Wed, 18 Jan 2023 11:18:58 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to
 devm_of_phy_optional_get()
Message-ID: <Y8gb8l18XzYOPhoD@rowland.harvard.edu>
References: <cover.1674036164.git.geert+renesas@glider.be>
 <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 11:15:20AM +0100, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> handle NULL parameters fine.

The patch ignores a possible -ENOSYS error return.  Is it known that 
this will never happen?

Alan Stern

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/usb/host/ohci-exynos.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 8d7977fd5d3bd502..8dd9c3b2411c383f 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
>  			return -EINVAL;
>  		}
>  
> -		phy = devm_of_phy_get(dev, child, NULL);
> +		phy = devm_of_phy_optional_get(dev, child, NULL);
>  		exynos_ohci->phy[phy_number] = phy;
>  		if (IS_ERR(phy)) {
> -			ret = PTR_ERR(phy);
> -			if (ret == -EPROBE_DEFER) {
> -				of_node_put(child);
> -				return ret;
> -			} else if (ret != -ENOSYS && ret != -ENODEV) {
> -				dev_err(dev,
> -					"Error retrieving usb2 phy: %d\n", ret);
> -				of_node_put(child);
> -				return ret;
> -			}
> +			of_node_put(child);
> +			return dev_err_probe(dev, PTR_ERR(phy),
> +					     "Error retrieving usb2 phy\n");
>  		}
>  	}
>  
> @@ -97,12 +90,10 @@ static int exynos_ohci_phy_enable(struct device *dev)
>  	int ret = 0;
>  
>  	for (i = 0; ret == 0 && i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ohci->phy[i]))
> -			ret = phy_power_on(exynos_ohci->phy[i]);
> +		ret = phy_power_on(exynos_ohci->phy[i]);
>  	if (ret)
>  		for (i--; i >= 0; i--)
> -			if (!IS_ERR(exynos_ohci->phy[i]))
> -				phy_power_off(exynos_ohci->phy[i]);
> +			phy_power_off(exynos_ohci->phy[i]);
>  
>  	return ret;
>  }
> @@ -114,8 +105,7 @@ static void exynos_ohci_phy_disable(struct device *dev)
>  	int i;
>  
>  	for (i = 0; i < PHY_NUMBER; i++)
> -		if (!IS_ERR(exynos_ohci->phy[i]))
> -			phy_power_off(exynos_ohci->phy[i]);
> +		phy_power_off(exynos_ohci->phy[i]);
>  }
>  
>  static int exynos_ohci_probe(struct platform_device *pdev)
> -- 
> 2.34.1
> 
