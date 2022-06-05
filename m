Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618F153D963
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 05:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243681AbiFEDYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 23:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiFEDYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 23:24:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2936186CD;
        Sat,  4 Jun 2022 20:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+l0GZ7z58a9WOSaF56AZ+Q4QK3euNlwmXxmDuMAYC+0=; b=K+yykGXDLEVF9Ufmqm3D0H4Shj
        6gO8dpe4F4i8e1Pfucb+cFS4RfoYy6SGYGLVDLsl6Sjc/IDmP4LpaZyB7+jEouIdNL04if+bplwCG
        fx/lUI/AjdVL+ox1TljEKu1wxbjrmmxFizBfiMcg3ImDC38rXPpVGJrvDOWR+czzTyMk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxgsT-005b5j-K9; Sun, 05 Jun 2022 05:24:33 +0200
Date:   Sun, 5 Jun 2022 05:24:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        cchavva@marvell.com, deppel@marvell.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 3/3] net: mdio: mdio-thunder: support for clock-freq
 attribute
Message-ID: <Ypwh8e0jdQPVyJVq@lunn.ch>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
 <20220530125329.30717-4-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530125329.30717-4-pmalgujar@marvell.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static inline u32 clk_freq(u32 phase)

Please keep with the naming scheme in the rest of the driver, 
thunder_mdiobus_clk_freq()

> +{
> +	return (100000000U / (2 * (phase)));
> +}
> +
> +static inline u32 calc_sample(u32 phase)
> +{

thunder_mdiobus_calc_sample()

> +	return (2 * (phase) - 3);
> +}
> +
> +static u32 _config_clk(u32 req_freq, u32 *phase, u32 *sample)

thunder_mdiobus_config_clk().

> +{
> +	unsigned int p;
> +	u32 freq = 0, freq_prev;
> +
> +	for (p = PHASE_MIN; p < PHASE_DFLT; p++) {
> +		freq_prev = freq;
> +		freq = clk_freq(p);
> +
> +		if (req_freq >= freq)
> +			break;
> +	}
> +
> +	if (p == PHASE_DFLT)
> +		freq = clk_freq(PHASE_DFLT);
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
> +	*sample = calc_sample(p);
> +	return freq;
> +}
> +
>  static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  				     const struct pci_device_id *ent)
>  {
> @@ -56,6 +101,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  	i = 0;
>  	device_for_each_child_node(&pdev->dev, fwn) {
>  		struct resource r;
> +		u32 req_clk_freq;
>  		struct mii_bus *mii_bus;
>  		struct cavium_mdiobus *bus;
>  		union cvmx_smix_clk smi_clk;
> @@ -90,6 +136,23 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  
>  		smi_clk.u64 = oct_mdio_readq(bus->register_base + SMI_CLK);
>  		smi_clk.s.clk_idle = 1;
> +
> +		if (!of_property_read_u32(node, "clock-frequency", &req_clk_freq)) {
> +			u32 phase, sample;
> +
> +			dev_dbg(&pdev->dev, "requested bus clock frequency=%d\n",
> +				req_clk_freq);
> +
> +			bus->clk_freq = _config_clk(req_clk_freq,
> +						    &phase, &sample);
> +
> +			smi_clk.s.phase = phase;
> +			smi_clk.s.sample_hi = (sample >> 4) & 0x1f;
> +			smi_clk.s.sample = sample & 0xf;
> +		} else {
> +			bus->clk_freq = clk_freq(PHASE_DFLT);
> +		}

You can make this simpler by setting req_clk_freq to your odd
default. Then call of_property_read_u32(). If the property is not
defined, the value of req_clk_freq will not be changed, and the
calculation should come out with the correct value.

	    Andrew
