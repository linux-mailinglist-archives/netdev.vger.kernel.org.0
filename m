Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAAC67AD48
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 10:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjAYJEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 04:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbjAYJEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 04:04:48 -0500
Received: from mail.kernel-space.org (unknown [IPv6:2a01:4f8:c2c:5a84::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6481AB
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 01:04:46 -0800 (PST)
Received: from ziongate (localhost [127.0.0.1])
        by ziongate (OpenSMTPD) with ESMTP id 25b579e7;
        Wed, 25 Jan 2023 09:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=default; bh=DhTa4N22ii8VSBhN0YJorr
        6IVmY=; b=BO4MExooj4o+0j7FCzaI+BKW6uEwgum9Tg3MTT1YwXP0CLq0mS/rQ5
        K7O9fYqrbdxSfd7XS5e/0S4M8WzhNdzte/wXPq/9N3NZOE809ekVaZ9JvIH67Xkb
        Z/UMs/zcarW94odalK1gNtJXKG7t7kAqdaXexBcfKyyr5bzUHR6Cs=
DomainKey-Signature: a=rsa-sha1; c=simple; d=kernel-space.org; h=date
        :from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; q=dns; s=default; b=fVTW9NkgE69yRgHd
        ZIROADyN2WBz+3YFk+hwoG87HOZAS56a/2Ft1Vpelp+k7UFImb+PsweURCcnNOMh
        rBLyak1tAFh8A3YvDWWcjdoWSum73OGGjN2VE0592K/XQOYz3qv48S7NG3ZEhKq9
        5qT1T0FRGfRLV7//AU37tV1kDlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1674637484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GxqmdV+9BGYkZYdYNk5c3U4dbONynXzuvNZ8T3NcyUs=;
        b=MfYM12N9kSZ3+iIfNGWqkZbmtqxt2sk9XIv8bImM7zRMPCm+6Rz/BgnhbKcXeeaVPJUp3P
        ahtFMydzCHic/uPbLLXRZX7bFFUHgXaJn6VEihRMAdTKdpuw/CqKa3sQY7Lm/aZTKWe3mn
        RSiuHt6zqGwBb849J5QPBgzTTE3OeuI=
Received: from dfj (<unknown> [95.236.233.95])
        by ziongate (OpenSMTPD) with ESMTPSA id 5fac0801 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 25 Jan 2023 09:04:44 +0000 (UTC)
Date:   Wed, 25 Jan 2023 10:04:46 +0100 (CET)
From:   Angelo Dureghello <angelo@kernel-space.org>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
In-Reply-To: <Y8/jrzhb2zoDiidZ@lunn.ch>
Message-ID: <9e722bb5-a4f6-3f04-39bc-8775d054a0f2@kernel-space.org>
References: <Y7yIK4a8mfAUpQ2g@lunn.ch> <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org> <20230110222246.iy7m7f36iqrmiyqw@skbuf> <Y73ub0xgNmY5/4Qr@lunn.ch> <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org> <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org> <20230123191844.ltcm7ez5yxhismos@skbuf> <Y87pLbMC4GRng6fa@lunn.ch> <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org> <Y8/jrzhb2zoDiidZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew and Vladimir,

thanks a lot for both your suggestions, will study and reason
on them, and likely try them.

On Tue, 24 Jan 2023, Andrew Lunn wrote:

> On Tue, Jan 24, 2023 at 08:21:35AM +0100, Angelo Dureghello wrote:
>>
>> Hi Andrew and Vladimir,
>>
>> On Mon, 23 Jan 2023, Andrew Lunn wrote:
>>
>>>> I don't know what this means:
>>>>
>>>> | I am now trying this way on mv88e6321,
>>>> | - one vlan using dsa kernel driver,
>>>> | - other vlan using dsdt userspace driver.
>>>>
>>>> specifically what is "dsdt userspace driver".
>>>
>>> I think DSDT is Marvells vendor crap code.
>>>
>> Yes, i have seen someone succeeding using it, why do you think it's crap ?
>
> In the Linux kernel community, that is the name given to vendor code,
> because in general, that is the quality level. The quality does vary
> from vendor to vendor and SDK to SDK, some are actually O.K.
>
>>
>>> Having two drivers for the same hardware is a recipe for disaster.
>>>
>>>  Andrew
>>>
>>
>> What i need is something as
>>
>>         eth0 ->  vlan1 -> port5(rmii)  ->  port 0,1,2
>>         eth1 ->  vlan2 -> port6(rgmii) ->  port 3,4
>>
>> The custom board i have here is already designed in this way
>> (2 fixed-link mac-to-mac connecitons) and trying my best to have
>> the above layout working.
>
> With todays mainline i would do:
>
> So set eth0 as DSA master port.
>
> Create a bridge br0 with ports 0, 1, 2.
> Create a bridge br1 with ports 3, 4, 6.
>
> You don't actually make use of the br1 interface in Linux, it just
> needs to be up. You can think of eth1 being connected to an external
> managed switch.
>
> 	Andrew
>

Thanks,
angelo
