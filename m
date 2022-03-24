Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62CA4E6523
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350947AbiCXOaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350953AbiCXOaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:30:22 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E173F0F;
        Thu, 24 Mar 2022 07:28:45 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F0F652222E;
        Thu, 24 Mar 2022 15:28:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648132124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CBauyiCRbelJs5M6LU0K3cCy/cSfRgKin2pevcyzRb4=;
        b=eimmWwICoNdsg2Ak75/cFZM+H2sWdTGDxWJY9k976hk2Qew2mjAex7c5BVbkgImJEHMwfC
        vOVK6m3vmkxnFnszIy8/K437HFu9UtbQTMKk7t2sU+xiwUsM4zxsDFkzc00P+0ZrqmjH2X
        lOh/A9vhQGxNtsdTSieWbe/A6ev0p5g=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Mar 2022 15:28:43 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/5] net: phy: support indirect c45 access in
 get_phy_c45_ids()
In-Reply-To: <Yjt3hHWt0mW6er8/@lunn.ch>
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-3-michael@walle.cc> <Yjt3hHWt0mW6er8/@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7503a496e1456fa65e4317bbe7590d9d@walle.cc>
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

Am 2022-03-23 20:39, schrieb Andrew Lunn:
>> +static int mdiobus_probe_mmd_read(struct mii_bus *bus, int prtad, int 
>> devad,
>> +				  u16 regnum)
>> +{
>> +	int ret;
>> +
>> +	/* For backwards compatibility, treat MDIOBUS_NO_CAP as c45 capable 
>> */
>> +	if (bus->probe_capabilities == MDIOBUS_NO_CAP ||
>> +	    bus->probe_capabilities >= MDIOBUS_C45)
> 
> Maybe we should do the work and mark up those that are C45 capable. At
> a quick count, see 16 of them.

I guess you grepped for MII_ADDR_C45 and had a look who
actually handled it correctly. Correct?

Let's say we mark these as either MDIOBUS_C45 or MDIOBUS_C45_C22,
can we then drop MDIOBUS_NO_CAP and make MDIOBUS_C22 the default
value (i.e. value 0) or do we have to go through all the mdio drivers
and add bus->probe_capabilities = MDIOBUS_C22 ? Grepping for
{of_,}mdiobus_register lists quite a few of them.

-michael
