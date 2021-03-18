Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA1B340A51
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhCRQip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbhCRQiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:38:16 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B4C06174A;
        Thu, 18 Mar 2021 09:38:16 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2B7FB22205;
        Thu, 18 Mar 2021 17:38:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1616085494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MBkORc1i1EFSwgMZ1o0CjqSrDw+cjwMnNE9mNNijh+4=;
        b=rKY53G0+6UHdq42l4sWeAQ4Z7hy1mhSs3fUxYiqUKzPrZZrxOojNKpJjpy229u3RugTXX7
        Y4NuZik5fMGFK7fjRZPd0b7Hxzl9r8dQiCdMwmhTgZXKKc84H16azNB0L6nqHvfTEgQ+Nt
        T7fwhYd1LDgdLwzjWsk+IWK3nphLvIc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Mar 2021 17:38:13 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: at803x: remove at803x_aneg_done()
In-Reply-To: <ee24b531-df8b-fa3d-c7fd-8c529ecba4c8@gmail.com>
References: <20210318142356.30702-1-michael@walle.cc>
 <411c3508-978e-4562-f1e9-33ca7e98a752@gmail.com>
 <20210318151712.7hmdaufxylyl33em@skbuf>
 <ee24b531-df8b-fa3d-c7fd-8c529ecba4c8@gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <ae201dadd6842f533aaa2e1440209784@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-03-18 17:21, schrieb Heiner Kallweit:
> On 18.03.2021 16:17, Vladimir Oltean wrote:
>> On Thu, Mar 18, 2021 at 03:54:00PM +0100, Heiner Kallweit wrote:
>>> On 18.03.2021 15:23, Michael Walle wrote:
>>>> at803x_aneg_done() is pretty much dead code since the patch series
>>>> "net: phy: improve and simplify phylib state machine" [1]. Remove 
>>>> it.
>>>> 
>>> 
>>> Well, it's not dead, it's resting .. There are few places where
>>> phy_aneg_done() is used. So you would need to explain:
>>> - why these users can't be used with this PHY driver
>>> - or why the aneg_done callback isn't needed here and the
>>>   genphy_aneg_done() fallback is sufficient
>> 
>> The piece of code that Michael is removing keeps the aneg reporting as
>> "not done" even when the copper-side link was reported as up, but the
>> in-band autoneg has not finished.
>> 
>> That was the _intended_ behavior when that code was introduced, and 
>> you
>> have said about it:
>> https://www.spinics.net/lists/stable/msg389193.html
>> 
>> | That's not nice from the PHY:
>> | It signals "link up", and if the system asks the PHY for link 
>> details,
>> | then it sheepishly says "well, link is *almost* up".
>> 
>> If the specification of phy_aneg_done behavior does not include 
>> in-band
>> autoneg (and it doesn't), then this piece of code does not belong 
>> here.
>> 
>> The fact that we can no longer trigger this code from phylib is yet
>> another reason why it fails at its intended (and wrong) purpose and
>> should be removed.
>> 
> I don't argue against the change, I just think that the current commit
> description isn't sufficient. What you just said I would have expected
> in the commit description.

I'll come up with a better one, Vladimir, may I use parts of the text
above?

-michael
