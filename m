Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6076137FC
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 14:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiJaN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 09:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiJaN1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 09:27:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9884A10073;
        Mon, 31 Oct 2022 06:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X9mXfQU2azroHjW2fTPBBkJLznInfmUPZPQXER+vmpQ=; b=gmeka71Q7kSt2ZGYKoTPo7Nnrr
        cJwdn8qVOkG7+mLn+qf3KQmFuec/MvR2q9J711pCgxpnZzVFFryxTqNwef48sHo5mKEaWYSZF8Cgf
        m4o9xNpp0tpiRCPBPR3trUz4mi+uQfplAo+lWwoMwsu8QOJuuCDjZkRiZdpH9h3QNrpU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1opUov-0011OF-Nu; Mon, 31 Oct 2022 14:27:17 +0100
Date:   Mon, 31 Oct 2022 14:27:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chester Lin <clin@suse.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jan Petrous <jan.petrous@nxp.com>,
        Ondrej Spacek <ondrej.spacek@nxp.com>,
        Ghennadi Procopciuc <Ghennadi.Procopciuc@nxp.com>,
        Andra-Teodora Ilie <andra.ilie@nxp.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 5/5] net: stmmac: Add NXP S32 SoC family support
Message-ID: <Y1/NNbZiVvM9+mrm@lunn.ch>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-6-clin@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221031101052.14956-6-clin@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* set interface mode */
> +	if (gmac->ctrl_sts) {
> +		switch (gmac->intf_mode) {
> +		default:
> +			dev_info(&pdev->dev, "unsupported mode %u, set the default phy mode.\n",
> +				 gmac->intf_mode);

If it is an unsupported mode use dev_err() and return -EINVAL;

> +			fallthrough;
> +		case PHY_INTERFACE_MODE_SGMII:
> +			dev_info(&pdev->dev, "phy mode set to SGMII\n");

dev_dbg()

Please don't spam the lock with useless information.

> +			intf_sel = PHY_INTF_SEL_SGMII;
> +			break;
> +		case PHY_INTERFACE_MODE_RGMII:
> +		case PHY_INTERFACE_MODE_RGMII_ID:
> +		case PHY_INTERFACE_MODE_RGMII_TXID:
> +		case PHY_INTERFACE_MODE_RGMII_RXID:
> +			dev_info(&pdev->dev, "phy mode set to RGMII\n");

dev_dbg()

> +			intf_sel = PHY_INTF_SEL_RGMII;
> +			break;
> +		case PHY_INTERFACE_MODE_RMII:
> +			dev_info(&pdev->dev, "phy mode set to RMII\n");

dev_dbg()

> +			intf_sel = PHY_INTF_SEL_RMII;
> +			break;
> +		case PHY_INTERFACE_MODE_MII:
> +			dev_info(&pdev->dev, "phy mode set to MII\n");

dev_dbg()

> +			intf_sel = PHY_INTF_SEL_MII;
> +			break;
> +		}
> +
> +		writel(intf_sel, gmac->ctrl_sts);
> +	}
> +
> +	return 0;
> +}
> +
> +static int s32cc_config_cache_coherency(struct platform_device *pdev,
> +					struct plat_stmmacenet_data *plat_dat)
> +{
> +	plat_dat->axi4_ace_ctrl =
> +		devm_kzalloc(&pdev->dev,
> +			     sizeof(struct stmmac_axi4_ace_ctrl),
> +			     GFP_KERNEL);
> +
> +	if (!plat_dat->axi4_ace_ctrl) {
> +		dev_info(&pdev->dev, "Fail to allocate axi4_ace_ctrl\n");

dev_err(). But devm_kzalloc() failing will produce log messages, so
you probably don't need this.

    Andrew
