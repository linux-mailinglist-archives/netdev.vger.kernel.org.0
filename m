Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B761E5B80
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgE1JLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:11:48 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:51921 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728080AbgE1JLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 05:11:48 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9311A23E44;
        Thu, 28 May 2020 11:11:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1590657106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQI9eKxgFwwqo7lAirfupMY1mvgzDKPVoZMhXExfpR4=;
        b=o7d+xvIP36ic7ee5Au56p89Syr1PsUkuGH0H9KfGwIoShD9J7AVOlJyvHtEXbAk+6y4zSU
        bmiqcn43mXeu70kr2lIoJZy9k9RMfXdG5b6P58hhpD6jmJ+W0dWmfBu87eMQgEJZIp41Di
        W4AbgruL8QsTe+L5hTUdjLyOo+3TP5k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 May 2020 11:11:45 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3 0/3] net: enetc: remove bootloader dependency
In-Reply-To: <CA+h21hruQkYEYatnOSSc6r2EPR+SY-NbcKCRF6sX2oNLy84itg@mail.gmail.com>
References: <20200528063847.27704-1-michael@walle.cc>
 <0130cb1878a47efc23f23cf239d0380f@walle.cc>
 <CA+h21hruQkYEYatnOSSc6r2EPR+SY-NbcKCRF6sX2oNLy84itg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <043ef77349823caa9e2b058f44a11a06@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-28 10:43, schrieb Vladimir Oltean:
> On Thu, 28 May 2020 at 11:18, Michael Walle <michael@walle.cc> wrote:
>> 
>> Am 2020-05-28 08:38, schrieb Michael Walle:
>> > These patches were picked from the following series:
>> > https://lore.kernel.org/netdev/1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com/
>> > They have never been resent. I've picked them up, addressed Andrews
>> > comments, fixed some more bugs and asked Claudiu if I can keep their
>> > SOB
>> > tags; he agreed. I've tested this on our board which happens to have a
>> > bootloader which doesn't do the enetc setup in all cases. Though, only
>> > SGMII mode was tested.
>> >
>> > changes since v2:
>> >  - removed SOBs from "net: enetc: Initialize SerDes for SGMII and
>> > USXGMII
>> >    protocols" because almost everything has changed.
>> >  - get a phy_device for the internal PCS PHY so we can use the phy_
>> >    functions instead of raw mdiobus writes
>> 
>> mhh after reading,
>> https://lore.kernel.org/netdev/CA+h21hoq2qkmxDFEb2QgLfrbC0PYRBHsca=0cDcGOr3txy9hsg@mail.gmail.com/
>> this seems to be the wrong way of doing it.
>> 
>> -michael
> 
> FWIW, some time after the merge window closes, I plan to convert the
> felix and seville drivers to mdio_device. It wouldn't be such a big
> deal to also convert enetc to phylink then, and also do this
> phy_device -> mdio_device for it too.


Btw. you/we can also remove that magic SGMII link timer numbers:

#define ENETC_PCS_LINK_TIMER_VAL(ms) \
    ((u32)(125000000 * (ms) / 1000))

Then for SGMII its ENETC_PCS_LINK_TIMER_VAL(1.6) and for 1000BaseX
(and 2500BaseX?) its ENETC_PCS_LINK_TIMER_VAL(10) (which also match
to the default value in the registers).

Please note, that the current hardcoded values doesn't match the
calculated ones precisely. I don't know where these are coming from,
but the 1.6ms matches the SGMII spec.

-michael
