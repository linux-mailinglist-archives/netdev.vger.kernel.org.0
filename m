Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570A46C289C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjCUD34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjCUD3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:29:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE6137726;
        Mon, 20 Mar 2023 20:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32909B811CF;
        Tue, 21 Mar 2023 03:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160ACC433D2;
        Tue, 21 Mar 2023 03:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679369390;
        bh=GZWXqBx1VZ5HLFmDQaUsHeHsXagTJgeevyhmDS9nBQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fgt8ewdhEaKB7HcggS2oUKQwMcNjAqV2eGMyVXGnJauZ79cLN0Uq1f/sdAzSEe1L+
         DAusnUTbcsPD7vBET9ovu5kWDQsz4LsyQ4CacIDa31R7ZZGY9SGtZUWJxHJ1jOjBOf
         BI6cR447fnFLxdGR2kMzAfcl56Oo339nQmQ7gua4g/t4rvuu4OcwbO3KwSPoFpypE/
         R/TQBEEnnYE4Y2SPTUUR7kj1ajpDIz0ivcl568Qs80uG7BEZQGzaCqdqDfDIUxp33y
         P9ko7lq6mwUiJLD/E1Vbdgw8RHqnmP+RpYbcmiGVKQWaz048cEXLJtEk8JSWNXrZ8G
         GjGG53hhlKLCA==
Date:   Mon, 20 Mar 2023 20:29:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org, peppe.cavallaro@st.com,
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
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v2 10/12] net: stmmac: dwmac-qcom-ethqos:
 Respect phy-mode and TX delay
Message-ID: <20230320202948.7ba109a4@kernel.org>
In-Reply-To: <20230320221617.236323-11-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
        <20230320221617.236323-11-ahalaney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 17:16:15 -0500 Andrew Halaney wrote:
>  static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
>  {
> +	int phy_mode;
> +	int phase_shift;

nit: invert the order, we like variable declaration lines longest 
to shortest

> +	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
> +	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
> +	if (phy_mode == PHY_INTERFACE_MODE_RGMII_ID || phy_mode == PHY_INTERFACE_MODE_RGMII_TXID)

Let's try to stick to 80 chars where reasonable, this would be easier
to read as 2 lines.

> +		phase_shift = 0;
> +	else
> +		phase_shift = RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN;
> +
>  	/* Disable loopback mode */
>  	rgmii_updatel(ethqos, RGMII_CONFIG2_TX_TO_RX_LOOPBACK_EN,
>  		      0, RGMII_IO_MACRO_CONFIG2);
> @@ -300,9 +310,9 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
>  			      RGMII_CONFIG_PROG_SWAP, RGMII_IO_MACRO_CONFIG);
>  		rgmii_updatel(ethqos, RGMII_CONFIG2_DATA_DIVIDE_CLK_SEL,
>  			      0, RGMII_IO_MACRO_CONFIG2);
> +
>  		rgmii_updatel(ethqos, RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
> -			      RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
> -			      RGMII_IO_MACRO_CONFIG2);
> +				  phase_shift, RGMII_IO_MACRO_CONFIG2);

here and in couple more places looks like indentation got broken?
continuation line should start under the opening bracket + 1.
