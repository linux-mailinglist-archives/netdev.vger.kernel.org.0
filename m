Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F21A878C
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfIDN7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:24 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39234 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730245AbfIDN7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:23 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id DC574821822; Wed,  4 Sep 2019 20:53:40 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249 (unknown [62.213.40.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ispman.iskranet.ru (Postfix) with ESMTPS id 36513821822;
        Wed,  4 Sep 2019 20:53:40 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
        <20190723151702.14430-2-asolokha@kb.kras.ru>
        <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com>
Date:   Wed, 04 Sep 2019 20:53:38 +0700
Message-ID: <87k1aop3q5.fsf@kb.kras.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


>> @@ -1964,7 +1966,7 @@ void stop_gfar(struct net_device *dev)
>>         /* disable ints and gracefully shut down Rx/Tx DMA */
>>         gfar_halt(priv);
>>
>> -       phy_stop(dev->phydev);
>> +       phylink_stop(priv->phylink);
>>
>>         free_skb_resources(priv);
>>  }
>> @@ -2219,12 +2221,7 @@ int startup_gfar(struct net_device *ndev)
>>         /* Start Rx/Tx DMA and enable the interrupts */
>>         gfar_start(priv);
>>
>> -       /* force link state update after mac reset */
>> -       priv->oldlink = 0;
>> -       priv->oldspeed = 0;
>> -       priv->oldduplex = -1;
>> -
>> -       phy_start(ndev->phydev);
>> +       phylink_start(priv->phylink);
>>
>>         enable_napi(priv);
>>
>> @@ -2593,7 +2590,7 @@ static int gfar_close(struct net_device *dev)
>>         stop_gfar(dev);
>>
>>         /* Disconnect from the PHY */
>> -       phy_disconnect(dev->phydev);
>> +       phylink_disconnect_phy(priv->phylink);
>
> It is very odd to disconnect from the PHY on ndo_close and connect
> back on ndo_open. I don't know of any other driver that does that.
> Can't you change the behavior to simply start and stop phylink here?

I surely can. But I've just looked at xilinx_axienet, mvneta, mvpp2, and stmmac,
and they all call phylink_stop() and phylink_disconnect_phy() in ndo_stop. What
do you think would justify such a change?
