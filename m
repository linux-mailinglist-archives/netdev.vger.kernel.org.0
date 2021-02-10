Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810CA3164ED
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBJLRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:17:35 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:57147 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhBJLPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:15:17 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id C9C5522EE4;
        Wed, 10 Feb 2021 12:14:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612955676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O3hOdHbd8TlmpvkNZrPrCPOXWwvYrsaTiI23G0yqJfE=;
        b=A4y9998+3utye6ediaZeN35Q4/BQTaiQLICs4Eo6vqFSnpcz5L7OoHPoB4wRpAndy5adHz
        bx6twguoCzqkoDQ1SfHUN4l3brqXVBXAMKs3UXQcGce6nPM1JZvu623j3KYoaK8uEPQaSA
        TDiBwvDzY8J/dmk8fI3uGFvqMO9+hIM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 12:14:35 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
In-Reply-To: <20210210104900.GS1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
 <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
 <20210210104900.GS1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <3a9716ffafc632d2963d3eee673fb0b1@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-10 11:49, schrieb Russell King - ARM Linux admin:
> On Wed, Feb 10, 2021 at 11:38:18AM +0100, Michael Walle wrote:
>> Am 2021-02-10 11:30, schrieb Russell King - ARM Linux admin:
>> > On Wed, Feb 10, 2021 at 08:03:07AM +0100, Heiner Kallweit wrote:
>> > > On 09.02.2021 17:40, Michael Walle wrote:
>> > > > +out:
>> > > > +	return phy_restore_page(phydev, oldpage, err);
>> > >
>> > > If a random page was set before entering config_init, do we actually
>> > > want
>> > > to restore it? Or wouldn't it be better to set the default page as
>> > > part
>> > > of initialization?
>> >
>> > I think you've missed asking one key question: does the paging on this
>> > PHY affect the standardised registers at 0..15 inclusive, or does it
>> > only affect registers 16..31?
>> 
>> For this PHY it affects only registers >=16. But that doesn't 
>> invaldiate
>> the point that for other PHYs this might affect all regsisters. Eg. 
>> ones
>> where you could select between fiber and copper pages, right?
> 
> You are modifying the code using ip101a_g_* functions, which is only
> used for the IP101A and IP101G PHYs. Do these devices support fiber
> in a way that change the first 16 registers?

The PHY doesn't support fiber and register 0..15 are always available
regardless of the selected page for the IP101G.

genphy_() stuff will work, but the IP101G PHY driver specific functions,
like interrupt and mdix will break if someone is messing with the page
register from userspace.

So Heiner's point was, that there are other PHY drivers which
also break when a user changes registers from userspace and no one
seemed to cared about that for now.

I guess it boils down to: how hard should we try to get the driver
behave correctly if the user is changing registers. Or can we
just make the assumption that if the PHY driver sets the page
selection to its default, all the other callbacks will work
on this page.

-michael
