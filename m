Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48422502C52
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354816AbiDOPHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354865AbiDOPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:07:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74457326EE;
        Fri, 15 Apr 2022 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2/N+rOJE8PGxoG4dig2bE/oA6uo9oIRZf9q57tBjzQE=; b=GnBlTtZl+CTu47NOU5RTWHTUPI
        Wu9zQs+XHNXsnVwMvkDNvzpLIWb0NykNl6158dpCd4qjS4LnU0iaxLDxa5Qr3LCHaIquJx02Bq1nW
        ManUpHs8CCJ6fOuusMWxnR8X84jAuzCCb6xZDXq0z0aWokpwKlVkxHlzY4d/oCeemaB8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nfNVO-00Fz2n-E6; Fri, 15 Apr 2022 17:05:02 +0200
Date:   Fri, 15 Apr 2022 17:05:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cchavva@marvell.com, Damian Eppel <deppel@marvell.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] Marvell MDIO clock related changes.
Message-ID: <YlmJnh1OQ64Y3Fiv@lunn.ch>
References: <20220415143026.11088-1-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415143026.11088-1-pmalgujar@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 07:30:26AM -0700, Piyush Malgujar wrote:
> This patch includes following support related to MDIO Clock:

Please make you patch subject more specific. Marvell has lots of MDIO
bus masters, those in the mvebu SoCs, there is at least one USB MDIO
bus master, a couple in various SoHo switches, etc.

git log --oneline mdio-thunder.c will give you an idea what to use.

> 1) clock gating:
> The purpose of this change is to apply clock gating for MDIO clock when there is no transaction happening.
> This will stop the MDC clock toggling in idle scenario.
>
> 2) Marvell MDIO clock frequency attribute change:
> This MDIO change provides an option for user to have the bus speed set to their needs which is otherwise set
> to default(3.125 MHz).

Please read 802.3 Clause 22. The default should be 2.5MHz.

Also, you are clearly doing two different things here, so there should
be two patches.

> In case someone needs to use this attribute, they have to add an extra attribute clock-freq
> in the mdio entry in their DTS and this driver will support the rest.
> 
> The changes are made in a way that the clock will set to the nearest possible value based on the clock calculation

Please keep line lengths to 80. I'm surprised checkpatch did not warn
about this.


> and required frequency from DTS. Below are some possible values:
> default:3.125 MHz
> Max:16.67 MHz
> 
> These changes has been verified internally with Marvell SoCs 9x and 10x series.
> 
> Signed-off-by: Piyush Malgujar <pmalgujar@marvell.com>
> Signed-off-by: Damian Eppel <deppel@marvell.com>

These are in the wrong order. Since you are submitting it, your
Signed-off-by: comes last.

> ---
>  drivers/net/mdio/mdio-cavium.h  |  1 +
>  drivers/net/mdio/mdio-thunder.c | 65 +++++++++++++++++++++++++++++++++
>  2 files changed, 66 insertions(+)
> 
> diff --git a/drivers/net/mdio/mdio-cavium.h b/drivers/net/mdio/mdio-cavium.h
> index a2245d436f5dae4d6424b7c7bfca0aa969a3b3ad..ed4c48d8a38bd80e6a169f7a6d90c1f2a0daccfc 100644
> --- a/drivers/net/mdio/mdio-cavium.h
> +++ b/drivers/net/mdio/mdio-cavium.h
> @@ -92,6 +92,7 @@ struct cavium_mdiobus {
>  	struct mii_bus *mii_bus;
>  	void __iomem *register_base;
>  	enum cavium_mdiobus_mode mode;
> +	u32 clk_freq;
>  };
>  
>  #ifdef CONFIG_CAVIUM_OCTEON_SOC
> diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
> index 822d2cdd2f3599025f3e79d4243337c18114c951..642d08aff3f7f849102992a891790e900b111d5c 100644
> --- a/drivers/net/mdio/mdio-thunder.c
> +++ b/drivers/net/mdio/mdio-thunder.c
> @@ -19,6 +19,46 @@ struct thunder_mdiobus_nexus {
>  	struct cavium_mdiobus *buses[4];
>  };
>  
> +#define _calc_clk_freq(_phase) (100000000U / (2 * (_phase)))
> +#define _calc_sample(_phase) (2 * (_phase) - 3)

Please avoid macros like this. Use a function.

> +
> +#define PHASE_MIN 3
> +#define PHASE_DFLT 16
> +#define DFLT_CLK_FREQ _calc_clk_freq(PHASE_DFLT)
> +#define MAX_CLK_FREQ _calc_clk_freq(PHASE_MIN)
> +
> +static inline u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)
> +{
> +	unsigned int p;
> +	u32 freq = 0, freq_prev;
> +
> +	for (p = PHASE_MIN; p < PHASE_DFLT; p++) {
> +		freq_prev = freq;
> +		freq = _calc_clk_freq(p);
> +
> +		if (req_freq >= freq)
> +			break;
> +	}
> +
> +	if (p == PHASE_DFLT)
> +		freq = DFLT_CLK_FREQ;
> +
> +	if (p == PHASE_MIN || p == PHASE_DFLT)
> +		goto out;
> +
> +	/* Check which clock value from the identified range
> +	 * is closer to the requested value
> +	 */
> +	if ((freq_prev - req_freq) < (req_freq - freq)) {
> +		p = p - 1;
> +		freq = freq_prev;
> +	}
> +out:
> +	*phase = p;
> +	*sample = _calc_sample(p);
> +	return freq;
> +}
> +
>  static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  				     const struct pci_device_id *ent)
>  {
> @@ -59,6 +99,8 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  		struct mii_bus *mii_bus;
>  		struct cavium_mdiobus *bus;
>  		union cvmx_smix_en smi_en;
> +		union cvmx_smix_clk smi_clk;
> +		u32 req_clk_freq;
>  
>  		/* If it is not an OF node we cannot handle it yet, so
>  		 * exit the loop.
> @@ -87,6 +129,29 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  		bus->register_base = nexus->bar0 +
>  			r.start - pci_resource_start(pdev, 0);
>  
> +		smi_clk.u64 = oct_mdio_readq(bus->register_base + SMI_CLK);
> +		smi_clk.s.clk_idle = 1;
> +
> +		if (!of_property_read_u32(node, "clock-freq", &req_clk_freq)) {

Documentation/devicetree/bindings/net/mdio.yaml

says:

  clock-frequency:
    description:
      Desired MDIO bus clock frequency in Hz. Values greater than IEEE 802.3
      defined 2.5MHz should only be used when all devices on the bus support
      the given clock speed.

Please use this property name, and update the binding for your device
to indicate it is valid.

> +			u32 phase, sample;
> +
> +			dev_info(&pdev->dev, "requested bus clock frequency=%d\n",
> +				 req_clk_freq);

dev_dbg()

> +
> +			 bus->clk_freq = _config_clk(req_clk_freq,
> +						     &phase, &sample);

There should be some sort of range checks here, and return -EINVAL, if
asked to do lower/higher than what the hardware can support.

> +
> +			 smi_clk.s.phase = phase;
> +			 smi_clk.s.sample_hi = (sample >> 4) & 0x1f;
> +			 smi_clk.s.sample = sample & 0xf;

You indentation is messed up here. checkpatch would definitely of
found that! Please do use checkpatch.

> +		} else {
> +			bus->clk_freq = DFLT_CLK_FREQ;
> +		}
> +
> +		oct_mdio_writeq(smi_clk.u64, bus->register_base + SMI_CLK);
> +		dev_info(&pdev->dev, "bus clock frequency set to %d\n",
> +			 bus->clk_freq);

Only use dev_info() for really important messages. We don't spam the
kernel log for trivial things.

       Andrew
