Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0023D3DA3B6
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237402AbhG2NPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:15:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237236AbhG2NPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 09:15:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=szPN/IUb4a+Mhtg0in2BOoWLdWFrCWgNEz1rf5rVRSc=; b=g+UaSTqBrLYgUXsX7qNj30vi3O
        oU5DJzh1/d3hSVyQQdnAtMHlTpdjC0EiWvlMDv1ujH7OxWZXPw0CCoyjMgvtW22TFQT9/At66e6IY
        7B+URLhr4cNRG1fByKI4ADH0zcerOlV9Q30mTApkv9cNyGkGwaTwqYmDou4oolarVAN4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m95ss-00FJXN-B2; Thu, 29 Jul 2021 15:15:34 +0200
Date:   Thu, 29 Jul 2021 15:15:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH 2/3] net: mdio-ipq4019: rename mdio_ipq4019 to mdio_ipq
Message-ID: <YQKp9gsnjBNmXYIc@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-2-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729125358.5227-2-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 08:53:57PM +0800, Luo Jie wrote:
> mdio_ipq driver supports more SOCs such as ipq40xx, ipq807x,
> ipq60xx and ipq50xx.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/mdio/Kconfig                      |  6 +-
>  drivers/net/mdio/Makefile                     |  2 +-
>  .../net/mdio/{mdio-ipq4019.c => mdio-ipq.c}   | 66 +++++++++----------
>  3 files changed, 37 insertions(+), 37 deletions(-)
>  rename drivers/net/mdio/{mdio-ipq4019.c => mdio-ipq.c} (81%)

Hi Luo

We don't rename files unless there is a very good reason. It makes
back porting of fixes harder in stable. There are plenty of examples
of files with device specific names, but supporting a broad range of
devices. Take for example lm75, at24.

> -config MDIO_IPQ4019
> -	tristate "Qualcomm IPQ4019 MDIO interface support"
> +config MDIO_IPQ
> +	tristate "Qualcomm IPQ MDIO interface support"
>  	depends on HAS_IOMEM && OF_MDIO
>  	depends on GPIOLIB && COMMON_CLK && RESET_CONTROLLER
>  	help
>  	  This driver supports the MDIO interface found in Qualcomm
> -	  IPQ40xx series Soc-s.
> +	  IPQ40xx, IPQ60XX, IPQ807X and IPQ50XX series Soc-s.

Please leave the MDIO_IPQ4019 unchanged, so we don't break backwards
compatibility, but the changes to the text are O.K.

> @@ -31,38 +31,38 @@
>  /* 0 = Clause 22, 1 = Clause 45 */
>  #define MDIO_MODE_C45				BIT(8)
>  
> -#define IPQ4019_MDIO_TIMEOUT	10000
> -#define IPQ4019_MDIO_SLEEP		10
> +#define IPQ_MDIO_TIMEOUT	10000
> +#define IPQ_MDIO_SLEEP		10

This sort of mass rename will also make back porting fixes
harder. Please don't do it.

> -static const struct of_device_id ipq4019_mdio_dt_ids[] = {
> +static const struct of_device_id ipq_mdio_dt_ids[] = {
>  	{ .compatible = "qcom,ipq4019-mdio" },
> +	{ .compatible = "qcom,ipq-mdio" },
>  	{ }
>  };

Such a generic name is not a good idea. It appears this driver is not
compatible with the IPQ8064? It is O.K. to add more specific
compatibles. So you could add

qcom,ipq40xx, qcom,ipq60xx, qcom,ipq807x and qcom,ipq50xx.

But really, there is no need. Take for example snps,dwmac-mdio, which
is used in all sorts of devices.

   Andrew
