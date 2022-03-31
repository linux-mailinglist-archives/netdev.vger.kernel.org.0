Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3514A4EDF10
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240207AbiCaQqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239201AbiCaQqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:46:31 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00F021547E;
        Thu, 31 Mar 2022 09:44:43 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E5E2F22239;
        Thu, 31 Mar 2022 18:44:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648745082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O97j9GQOAINPJ4PUtw5YlWh6uos4yu/dAJzWaEkyLNU=;
        b=dNaRR+sTs8mzmKT44ZWXrgiQVfYxYRo4btdARxKvF0TcAuBr1n5JvDQPnVAwvLM4lfJfu1
        9EgxakJZf+ztWgmBK9KJmRBvwzZxiVP2SPbVIjtEqyTRf3pZoZScfB/vU59HAn9z+pqHzm
        HGYb/fbDkVXGyNeLP7RQeLrGP4nKADk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 31 Mar 2022 18:44:41 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 3/3] net: phy: mscc-miim: add support to set
 MDIO bus frequency
In-Reply-To: <YkXWkaVRp4I1Gj0p@lunn.ch>
References: <20220331151440.3643482-1-michael@walle.cc>
 <20220331151440.3643482-3-michael@walle.cc> <YkXWkaVRp4I1Gj0p@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6f67f53e262bf6eb93a3db572b966f9e@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-31 18:28, schrieb Andrew Lunn:
>> @@ -295,21 +323,41 @@ static int mscc_miim_probe(struct 
>> platform_device *pdev)
>>  	if (!miim->info)
>>  		return -EINVAL;
>> 
>> -	ret = of_mdiobus_register(bus, pdev->dev.of_node);
>> +	miim->clk = devm_clk_get_optional(&pdev->dev, NULL);
>> +	if (IS_ERR(miim->clk))
>> +		return PTR_ERR(miim->clk);
>> +
>> +	ret = clk_prepare_enable(miim->clk);
>> +	if (ret)
>> +		return ret;
>> +
>> +	of_property_read_u32(np, "clock-frequency", &miim->clk_freq);
> 
> The clock is optional if there is no "clock-frequency" property.  If
> the property does exist, the clock should be mandatory. I don't think
> it should silently fail setting the bus frequency because the clock is
> missing.

Oh yes, agreed.

-michael
