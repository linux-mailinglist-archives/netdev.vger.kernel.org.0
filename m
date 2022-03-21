Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843674E3015
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352235AbiCUSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352231AbiCUSiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:38:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E658C7EB25;
        Mon, 21 Mar 2022 11:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dDCb7VwO78ZT5/8ldz11dabmBXlAs88fHNpQV9wbUC4=; b=GmXUQcVX55+y78QphrbynKFs7S
        /3mucpI0R0/+7pH1jJVdbp1mse9LzHLJW+DrUSGvRGpMsP/9w+xiWS1VvcBg8zwwOOOQ9sGVwL3G1
        ChOxZxspvcep+zn8EHyJciD2dbASQZb1BBn273hMWTfw7hGEDj4oKZ/Aq6z11MBxPQdQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWMtR-00BzcD-He; Mon, 21 Mar 2022 19:36:37 +0100
Date:   Mon, 21 Mar 2022 19:36:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC Patch net-next 3/3] net: phy: lan87xx: added ethtool SQI
 support
Message-ID: <YjjFtUEDm2Dta1ez@lunn.ch>
References: <20220321155337.16260-1-arun.ramadoss@microchip.com>
 <20220321155337.16260-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321155337.16260-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define T1_DCQ_SQI_MSK			GENMASK(3, 1)

> +static int lan87xx_get_sqi(struct phy_device *phydev)
> +{
> +	u16 sqi_value[LAN87XX_SQI_ENTRY];

> +	for (i = 0; i < LAN87XX_SQI_ENTRY; i++) {
> +
> +		sqi_value[i] = FIELD_GET(T1_DCQ_SQI_MSK, rc);

> +
> +	/* Sorting SQI values */
> +	sort(sqi_value, LAN87XX_SQI_ENTRY, sizeof(u16), lan87xx_sqi_cmp, NULL);

Sort is quite heavyweight. Your SQI values are in the range 0-7 right?
So rather than have an array of LAN87XX_SQI_ENTRY entries, why not
create a histogram? You then just need to keep 8 uints. There is no
need to perform a sort to discard the outliers, simply remove from the
outer histogram buckets. And then you can calculate the average.

That should be faster and use less memory.

     Andrew
