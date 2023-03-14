Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5EC6B8753
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCNBAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCNBAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:00:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954F51117E;
        Mon, 13 Mar 2023 18:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y6fsAeAZisUsOyM9bq21nKdUzGuVcfPdezi6Gdsvp+Y=; b=fOVzAogDt3T/HacpWZZ6HE1vWu
        jAjiKi7RNHNnADZ8lpo5gJmnxCUdocuklB81QexvrEheh9C9O3Tv7bMksMRuVhBS1SjQLecD6H9he
        VPPaJO1yKphC28NLSZq/F8ZCtC6fmdHe/tnCMbwxyRLNHU3LRsbko2PM/+uIwaD35TA0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pbt0t-007FMJ-0v; Tue, 14 Mar 2023 01:59:39 +0100
Date:   Tue, 14 Mar 2023 01:59:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com
Subject: Re: [PATCH net-next 08/11] net: stmmac: Add EMAC3 variant of dwmac4
Message-ID: <9dc9eb28-43a9-4eca-b6de-302ce27388bf@lunn.ch>
References: <20230313165620.128463-1-ahalaney@redhat.com>
 <20230313165620.128463-9-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313165620.128463-9-ahalaney@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index 21aaa2730ac8..9e3d8e1202bd 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -281,9 +281,8 @@ static int stmmac_mdio_read_c22(struct mii_bus *bus, int phyaddr, int phyreg)
>  	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
>  	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
>  		& priv->hw->mii.clk_csr_mask;
> -	if (priv->plat->has_gmac4) {
> +	if (priv->plat->has_gmac4 || priv->plat->has_emac3)
>  		value |= MII_GMAC4_READ;
> -	}

Removing the {} is correct in terms of the coding style, but it should
be done as part of a separate patch.

	Andrew
