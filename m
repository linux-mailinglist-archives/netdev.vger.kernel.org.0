Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258BD1D6BB5
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgEQSWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:22:45 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52876 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgEQSWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 14:22:45 -0400
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id B0063440049;
        Sun, 17 May 2020 21:22:24 +0300 (IDT)
References: <3e2c01449dc29bc3d138d3a19e0c2220495dd7ed.1589710856.git.baruch@tkos.co.il> <20200517103558.GT1551@shell.armlinux.org.uk> <87lflq3afx.fsf@tarshish> <20200517175820.GB606317@lunn.ch>
User-agent: mu4e 1.4.4; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: net: mdio_bus: try indirect clause 45 regs access
In-reply-to: <20200517175820.GB606317@lunn.ch>
Date:   Sun, 17 May 2020 21:22:41 +0300
Message-ID: <87v9ku1kwe.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, May 17 2020, Andrew Lunn wrote:
>> > I don't think this should be done at mdiobus level; I think this is a
>> > layering violation.  It needs to happen at the PHY level because the
>> > indirect C45 access via C22 registers is specific to PHYs.
>> >
>> > It also needs to check in the general case that the PHY does indeed
>> > support the C22 register set - not all C45 PHYs do.
>> >
>> > So, I think we want this fallback to be conditional on:
>> >
>> > - are we probing for the PHY, trying to read its IDs and
>> >   devices-in-package registers - if yes, allow fallback.
>> > - does the C45 PHY support the C22 register set - if yes, allow
>> >   fallback.
>> 
>> I'll take a look. Thanks.
>  
> Another option to consider is a third compatible string. We have
> compatibles for C22, C45. Add another one for C45 over C22, and have
> the core support it as the third access method next to C22 and C45.
>
> We already rely on the DT author getting C22 vs C45 correct for the
> hardware. Is it too much to ask they get it write when there are three
> options?

Networking hardware DT configuration is confusing enough already. Since
we can determine indirect C45 access automatically, I think we should do
that.

> As to your particular hardware, if i remember correctly, some of the
> Marvell SoCs have mdio and xmdio bus masters. The mdio bus can only do
> C22, and the xmdio can only do C45. Have the hardware engineers put
> the PHY on the wrong bus?

The Armada 385 has only C22 MDIO. Other Armada SoCs have both MDIO and
XMDIO.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
