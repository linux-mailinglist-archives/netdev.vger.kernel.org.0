Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13C67A4DE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 22:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234926AbjAXVUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 16:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbjAXVUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 16:20:37 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E2D3A8C;
        Tue, 24 Jan 2023 13:20:35 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 161CC38;
        Tue, 24 Jan 2023 22:20:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674595234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iefToLm/HhuY9nOOwIdvaLvUm7L0h1oW0ep+0Gv8q4g=;
        b=IN9x24bRydV5+CHB0ToGcAJ1Rq57g0jZeXSCW9gRyUhem7tMrw2mL1XLIYPFnmThxDstIT
        Jdcw60/nd4iY+IQIm+1LXHumWzBhLLvYBONHgb6C1dc7+FvFbnKE/vwweT/czkhj/BqNmC
        BpRsxcSgZP3wCFt6uISYdGUDgaCq4IeaZaiaoFmWhEYOgO87RXnLwdvajdGf5mAglDyvJk
        l8DHS7lwN9PFmebDdvn0VRcY7I9oiTup7NdfHDfpJ0zmTTwlyprZ1aGTTIHVnoms5Tcmtp
        iRPZpSwXQ/fFlxsy8CrEQuRgyCluPszqFtwJHYftljDreq5IjcmZB5qHs4Oqvw==
MIME-Version: 1.0
Date:   Tue, 24 Jan 2023 22:20:33 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
In-Reply-To: <Y9BHjEUSvIRI2Mrz@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch> <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
 <dcea8c36e626dc31ee1ddd8c867eb999@walle.cc> <Y9BHjEUSvIRI2Mrz@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c7f8d06e5b974b042c9e731c81508c82@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-01-24 22:03, schrieb Andrew Lunn:
>> Btw. for the DT case, it seems we need yet another property
>> to indicate broken MDIO busses.
> 
> I would prefer to avoid that. I would suggest you do what i did for
> the none DT case. First probe using C22 for all devices known in DT.
> Then call mdiobus_prevent_c45_scan() which will determine if any of
> the found devices are FUBAR and will break C45. Then do a second probe
> using C45 and/or C45 over C22 for those devices in DT with the c45
> compatible.

I tried that yesterday. Have a look at of_mdiobus_register() [1].
There the device tree is walked and each PHY with a reg property
is probed. Afterwards, if there was a node without a reg property,
the bus is scanned for the missing PHYs. If we would just probe c22
first, the order of the auto scanning might change, if there is a
c45 phy in between two c22 phys. I was thinking to just ignore the
case that the autoscan would discover a broken PHY.

  (1) scan c22
  (2) scan c45 (maybe using c45-over-c22)
  (3) do the autoscan

-michael

[1] 
https://elixir.bootlin.com/linux/v6.2-rc5/source/drivers/net/mdio/of_mdio.c#L149



> 
> 	Andrew
