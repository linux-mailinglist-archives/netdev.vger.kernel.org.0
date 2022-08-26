Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E4C5A2364
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbiHZIn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 04:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiHZInK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 04:43:10 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8601629816;
        Fri, 26 Aug 2022 01:43:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4038C22CF;
        Fri, 26 Aug 2022 10:42:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661503378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wb/8RpcvRS+tdrKSkweZ8TUnn8oGwIokn6ovrmThycQ=;
        b=uUnVGbyDT1WfagYTCq0hXVF7r4GRmZa1bavIz0N9q/TMUVhUjgGSEeANAq03TESnjjlc1f
        vxODqwoOM//PDizqkf0BAflyaCErZL/s1XobCvIOYzE2uhsEUjlGecQEygnGDEP9XlE9hW
        ZRl2M9qKuvF0fK58ilFdjOEisSpHQrYm6PpdP2f13PGGT703BXrdx07DJaWOPdpu5kGVf9
        9emAeOOAlbFa1NMvGQN/oB0rvRBh17HyN962FVvgJ7r/45aqrvXEAw+A499YKSAaOGqgID
        sC9zbeZSGlwzpKiP+YRErL3exE47L5Q6MJTCQQfKhdIlc1STSRPo7q+dL3agPA==
From:   Michael Walle <michael@walle.cc>
To:     divya.koppera@microchip.com
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next] net: phy: micrel: Adding SQI support for lan8814 phy
Date:   Fri, 26 Aug 2022 10:42:49 +0200
Message-Id: <20220826084249.1031557-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825080549.9444-1-Divya.Koppera@microchip.com>
References: <20220825080549.9444-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Supports SQI(Signal Quality Index) for lan8814 phy, where
> it has SQI index of 0-7 values and this indicator can be used
> for cable integrity diagnostic and investigating other noise
> sources.
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index e78d0bf69bc3..3775da7afc64 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1975,6 +1975,13 @@ static int ksz886x_cable_test_get_status(struct phy_device *phydev,
>  #define LAN8814_CLOCK_MANAGEMENT			0xd
>  #define LAN8814_LINK_QUALITY				0x8e
>  
> +#define LAN8814_DCQ_CTRL				0xe6
> +#define LAN8814_DCQ_CTRL_READ_CAPTURE_			BIT(15)

Why does it end with an underscore?

> +#define LAN8814_DCQ_CTRL_CHANNEL_MASK			GENMASK(1, 0)
> +#define LAN8814_DCQ_SQI					0xe4
> +#define LAN8814_DCQ_SQI_MAX				7
> +#define LAN8814_DCQ_SQI_VAL_MASK			GENMASK(3, 1)
> +
>  static int lanphy_read_page_reg(struct phy_device *phydev, int page, u32 addr)
>  {
>  	int data;
> @@ -2927,6 +2934,32 @@ static int lan8814_probe(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int lan8814_get_sqi(struct phy_device *phydev)
> +{
> +	int rc, val;
> +
> +	val = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_CTRL);
> +	if (val < 0)
> +		return val;
> +
> +	val &= ~LAN8814_DCQ_CTRL_CHANNEL_MASK;

I do have a datasheet for this PHY, but it doesn't mention 0xe6 on EP1.
So I can only guess that this "channel mask" is for the 4 rx/tx pairs
on GbE? And you only seem to evaluate one of them. Is that the correct
thing to do here?

-michael


> +	val |= LAN8814_DCQ_CTRL_READ_CAPTURE_;
> +	rc = lanphy_write_page_reg(phydev, 1, LAN8814_DCQ_CTRL, val);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = lanphy_read_page_reg(phydev, 1, LAN8814_DCQ_SQI);
> +	if (rc < 0)
> +		return rc;
> +
> +	return FIELD_GET(LAN8814_DCQ_SQI_VAL_MASK, rc);
> +}
