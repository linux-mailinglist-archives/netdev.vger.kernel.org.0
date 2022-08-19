Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8210F59A575
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350375AbiHSSTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349919AbiHSSTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:19:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327FABA9C2;
        Fri, 19 Aug 2022 11:19:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C716BB82893;
        Fri, 19 Aug 2022 18:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127A0C433C1;
        Fri, 19 Aug 2022 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660933189;
        bh=VePZQAU6T+O5oGDYmuOeMWxlXbRse+vPgED/BSRqZoE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B5gBw/pxffa8qOxisneIHM0VsOGEmm55AAkTAQC8e49DBqWSF1EKhFL2vaLuYnyt2
         kRZuAhYzjkqv7ptFJDgkR9a0+jvBImgEXBUHgPuA4cOAgROyGLWwDmmFba7m7A2vOc
         Ico5tmXtclSq2GkgJ/1ga93tAFRj97aRohVn8QD3cHASn9JmvCxxE9XJI3W1HQYNsB
         194g7ERMtszQx/JjZFeMq1ZrblhiJPW9mEEh6U/ZIaG0Q/XcAstStBKhtfpXNXgF57
         2bVBV12REojkKOPp7fMJqvdNH0gPsjhABj1gCCVdHCfFpLYqovr+YtjVoQRLKRurPn
         BdVyc6UoCRaEA==
Date:   Fri, 19 Aug 2022 20:19:43 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Marcus Carlberg <marcus.carlberg@axis.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <20220819201943.5f6a4d09@thinkpad>
In-Reply-To: <20220819135629.32590-1-marcus.carlberg@axis.com>
References: <20220819135629.32590-1-marcus.carlberg@axis.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 15:56:29 +0200
Marcus Carlberg <marcus.carlberg@axis.com> wrote:

> Since the probe defaults all interfaces to the highest speed possible
> (10GBASE-X in mv88e6393x) before the phy mode configuration from the
> devicetree is considered it is currently impossible to use port 0 in
> RGMII mode.
> 
> This change will allow RGMII modes to be configurable for port 0
> enabling port 0 to be configured as RGMII as well as serial depending
> on configuration.
> 
> Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
> ---
> 
> Notes:
>     v2: add phy mode input validation for SERDES only ports
> 
>  drivers/net/dsa/mv88e6xxx/port.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> index 90c55f23b7c9..5c4195c635b0 100644
> --- a/drivers/net/dsa/mv88e6xxx/port.c
> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> @@ -517,6 +517,12 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	case PHY_INTERFACE_MODE_RMII:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_RMII;
>  		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		cmode = MV88E6XXX_PORT_STS_CMODE_RGMII;
> +		break;
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  		cmode = MV88E6XXX_PORT_STS_CMODE_1000BASEX;
>  		break;
> @@ -634,6 +640,19 @@ int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  	if (port != 0 && port != 9 && port != 10)
>  		return -EOPNOTSUPP;
>  
> +	if (port == 9 || port == 10) {
> +		switch (mode) {
> +		case PHY_INTERFACE_MODE_RMII:
> +		case PHY_INTERFACE_MODE_RGMII:
> +		case PHY_INTERFACE_MODE_RGMII_ID:
> +		case PHY_INTERFACE_MODE_RGMII_RXID:
> +		case PHY_INTERFACE_MODE_RGMII_TXID:
> +			return -EINVAL;
> +		default:
> +			break;
> +		}
> +	}
> +
>  	/* mv88e6393x errata 4.5: EEE should be disabled on SERDES ports */
>  	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
>  	if (err)

You also need to change
 mv88e6393x_phylink_get_caps in chip.c
to add RGMII interface types to the supported bit field if port == 0,
because the mv88e6xxx_translate_cmode() call does not fill RGMII as
supported there if cmode isn't RGMII at the beginning.

Also this should have Fixes tag?

Marek
