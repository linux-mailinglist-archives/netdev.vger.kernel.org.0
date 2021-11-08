Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8094499EA
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhKHQfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhKHQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:35:10 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5097C061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 08:32:25 -0800 (PST)
Subject: Re: [PATCH net v2] net: phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636389143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C5Dzc+mQBNeXAXqLZe0/BBFocYRQN/s01o/RDUSHqEk=;
        b=4ypjE2SCiEDCVciulxlosD2z35pWo4XTwkg0RzYY6RE0tmbKnXoDgIZhjU2sgKrlvzI7PX
        tQ6aioEpb3fuHCci22KnvQiXBiSRwWE5nqicgc/2QPh+Edl6OAFmJ7xhAVE2xjbgcHmUcG
        T/+X5cxcw445PxGWkxHrQtnK7hubkg2WGBqLgMAsAz/bfU1VWOaRTKAGmVu1NlcsmWvmYR
        +F1bC4cta5jTKZ/CJQC4q9+1F8QsCJVZSESgCajWPa+/FgiPGofZfP4kXgxlmERZXGqpGm
        aGRRwaxrZ7QbhWCAerCP8qyGc3vgbMUwrZxMKWoj7Kviguc2Lf9KiO9XWOWVdQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636389143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C5Dzc+mQBNeXAXqLZe0/BBFocYRQN/s01o/RDUSHqEk=;
        b=fxLUHeMjNebmpsc92s4OHVIpSZrMK2Gx0Sa7LPlZm0i66b9aP1WUYJqDTY6P6MsD0gxaSR
        hJH8u0AbiyYpxQBA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Benedikt Spranger <b.spranger@linutronix.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
References: <20211105153648.8337-1-bage@linutronix.de>
 <20211108141834.19105-1-bage@linutronix.de>
 <YYkzbE39ERAxzg4k@shell.armlinux.org.uk> <20211108160653.3d6127df@mitra>
 <YYlLvhE6/wjv8g3z@lunn.ch>
From:   Bastian Germann <bage@linutronix.de>
Message-ID: <63e5522a-f420-28c4-dd60-ce317dbbdfe0@linutronix.de>
Date:   Mon, 8 Nov 2021 17:32:23 +0100
MIME-Version: 1.0
In-Reply-To: <YYlLvhE6/wjv8g3z@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE-frami
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 08.11.21 um 17:09 schrieb Andrew Lunn:
> On Mon, Nov 08, 2021 at 04:06:53PM +0100, Benedikt Spranger wrote:
>> On Mon, 8 Nov 2021 14:25:48 +0000
>> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
>>
>>> On Mon, Nov 08, 2021 at 03:18:34PM +0100, bage@linutronix.de wrote:
>>>> From: Bastian Germann <bage@linutronix.de>
>>>>
>>>> Take the return of phy_start_aneg into account so that ethtool will
>>>> handle negotiation errors and not silently accept invalid input.
>>>
>>> I don't think this description is accurate. If we get to call
>>> phy_start_aneg() with invalid input, then something has already
>>> gone wrong.
>> The MDI/MDIX/auto-MDIX settings are not checked before calling
>> phy_start_aneg(). If the PHY supports forcing MDI and auto-MDIX, but
>> not forcing MDIX _phy_start_aneg() returns a failure, which is silently
>> ignored.
> 
> Does the broadcom driver currently do this, or is this the new
> functionality you are adding?
> 
> It actually seems odd that auto and MDI is supported, but not MDIX?  I
> would suggest checking with Florian about that. Which particular
> broadcom PHY is it?

It is BCM53125. Currently, you can set "mdix auto|off|on" which does not take any effect.
The chip will do what is its default depending on copper autonegotiation.

I am adding support for setting "mdix auto|off". I want the thing to error on "mdix on".
Where would I add that check?
