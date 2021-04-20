Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3E1365AED
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhDTOLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbhDTOLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 10:11:08 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55E2C06174A;
        Tue, 20 Apr 2021 07:10:36 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0AC6E22249;
        Tue, 20 Apr 2021 16:10:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1618927834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZzdrVgE6rVEqETqHd8rICoxokCvYVI1LWiUV3nczwY=;
        b=cBJj9IsnVoI7b/0muDZcpHZqc3LniZ3iMVIeIikjGvHDpK7tINA/9wf5YXiBKC5wIPvUKh
        M9aKOmcv2URowTX4Aix2zhYd4BtWcv3VvOMJkHoPl9tdTj3La9JvMlblmLKJy9OB3ArGBh
        BdVn4VeZ8hENRNVkvb0Vtlq9iurmfMo=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Apr 2021 16:10:34 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 0/5] Flow control for NXP ENETC
In-Reply-To: <20210420140433.hajuvfiz4humhhkt@skbuf>
References: <20210416234225.3715819-1-olteanv@gmail.com>
 <fa2347b25d25e71f891e50f6f789e421@walle.cc>
 <20210420140433.hajuvfiz4humhhkt@skbuf>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <0bf4aa61dea7be0723fda2d8597644ad@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Am 2021-04-20 16:04, schrieb Vladimir Oltean:
> On Tue, Apr 20, 2021 at 03:27:24PM +0200, Michael Walle wrote:
>> Hi Vladimir,
>> 
>> Am 2021-04-17 01:42, schrieb Vladimir Oltean:
>> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
>> >
>> > This patch series contains logic for enabling the lossless mode on the
>> > RX rings of the ENETC, and the PAUSE thresholds on the internal FIFO
>> > memory.
>> >
>> > During testing it was found that, with the default FIFO configuration,
>> > a sender which isn't persuaded by our PAUSE frames and keeps sending
>> > will cause some MAC RX frame errors. To mitigate this, we need to ensure
>> > that the FIFO never runs completely full, so we need to fix up a setting
>> > that was supposed to be configured well out of reset. Unfortunately this
>> > requires the addition of a new mini-driver.
>> 
>> What happens if the mini driver is not enabled? Then the fixes aren't
>> applied and bad things happen (now with the addition of flow control),
>> right?
>> 
>> I'm asking because, if you have the arm64 defconfig its not enabled.
>> 
>> shouldn't it be something like:
>> 
>> diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig
>> b/drivers/net/ethernet/freescale/enetc/Kconfig
>> index d88f60c2bb82..cdc0ff89388a 100644
>> --- a/drivers/net/ethernet/freescale/enetc/Kconfig
>> +++ b/drivers/net/ethernet/freescale/enetc/Kconfig
>> @@ -2,7 +2,7 @@
>>  config FSL_ENETC
>>         tristate "ENETC PF driver"
>>         depends on PCI && PCI_MSI
>> -       depends on FSL_ENETC_IERB || FSL_ENETC_IERB=n
>> +       select FSL_ENETC_IERB
>>         select FSL_ENETC_MDIO
>>         select PHYLINK
>>         select PCS_LYNX
> 
> Yes, ideally the IERB driver and the ENETC PF driver should be built in
> the same way, or the IERB driver can be built-in and the PF driver can
> be module. I don't know how to express this using Kconfig, sorry.

With the small patch above it is:
  FSL_ENETC=m -> FSL_ENETC_IERB = m or y
  FSL_ENETC=y -> FSL_ENETC_IERB = y
  FSL_ENETC=n -> FSL_ENETC_IERB = m,y or n

Will you fix it? Should I prepare a patch?

-michael
