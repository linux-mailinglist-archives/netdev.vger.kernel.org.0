Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E376261C3
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 20:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiKKTLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 14:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiKKTLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 14:11:51 -0500
X-Greylist: delayed 520 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 11:11:50 PST
Received: from smtp94.iad3a.emailsrvr.com (smtp94.iad3a.emailsrvr.com [173.203.187.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF321F9C9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 11:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1668193389;
        bh=yPkSLcfzkxm0D6H/XqFrXHfgRK9Z9afFCVkiNNlv4HA=;
        h=Date:Subject:To:From:From;
        b=GcWEvlBpp2NswNFXCyI8xf5xagVJzQlqCsxyt0NEXPmhJFkHrbqJ0JtLT94NW6Nds
         azy1XKDVHhZ+tcFuHIJ2FLG5NMta6Ru0dXRRWjpqmgCALmjAAVqIqRT9+t1hi5saxh
         2dviv+G1MW+S5tS7fDF8Fk7BNTGUjAxcl37901Kc=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp4.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 71EB73CF9;
        Fri, 11 Nov 2022 14:03:09 -0500 (EST)
Message-ID: <f2dff077-8a0b-2164-404f-d9bf4ee40d76@mev.co.uk>
Date:   Fri, 11 Nov 2022 19:03:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Content-Language: en-GB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch> <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
 <Y25bQfVwPZDT4T5D@lunn.ch> <23e33ae8-3cd0-cd4b-4648-5ffb07329efa@mev.co.uk>
 <Y26MGEqo+kdSiQmM@lunn.ch>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <Y26MGEqo+kdSiQmM@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 97f75bb6-3257-4c00-9831-18e0f5731a73-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2022 17:53, Andrew Lunn wrote:
>>> And since you are adding more foot guns, please validate the values in
>>> DT as strictly as possible, without breaking the existing binding.
>>
>> Yes, some min/max clamping of skew values would be good.  The code for
>> KSZ9131 does that already.
> 
> I would want much more strict checking than that. The old and the new
> values probably don't intersect. So if you see an old value while
> micrel,skew-equals-real-picoseconds is in force, fail the probe with
> -EINVAL. It looks like the old binding silently preforms rounding to
> the nearest delay. So you probably should not do the opposite, error
> out for a new value when micrel,skew-equals-real-picoseconds is not in
> force. But you can add range checks. A negative value is clearly wrong
> for the old values and should be -EINVAL. You just need to watch out
> for that the current code reads the values as u32, not s32, so you
> won't actually see a negative value.

I'm not sure how to tell old values and new values apart (except for 
negative new values).  A divisibility test won't work for values that 
are divisible by 600 (lcm(120, 200)).

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

