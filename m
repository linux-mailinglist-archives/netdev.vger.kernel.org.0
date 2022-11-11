Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFCB626076
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiKKReL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:34:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbiKKReJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:34:09 -0500
Received: from smtp102.ord1d.emailsrvr.com (smtp102.ord1d.emailsrvr.com [184.106.54.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6959C61BAF
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 09:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1668188046;
        bh=VQsY5jOYOykeen0fQm9DXICrBW6lVMLJWS6p0ku81sw=;
        h=Date:Subject:To:From:From;
        b=dqhWHyXpexwj1paela0kLet2Ek8WVkgmvudIfttSaTvO5NmSN2+f3JROUr1/jkkCk
         UQ+fakbws+wxP01s/Z01w9fkhRBlwFx31mWdZDN5/MZU1GSPwEFU/WZpVRTn0sQUwq
         tA0BLMOIff5BND0/yxDXZn2Qbe4FT2V/y+qa9gd8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp13.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 23FE1C014B;
        Fri, 11 Nov 2022 12:34:06 -0500 (EST)
Message-ID: <23e33ae8-3cd0-cd4b-4648-5ffb07329efa@mev.co.uk>
Date:   Fri, 11 Nov 2022 17:34:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Content-Language: en-GB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch> <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
 <Y25bQfVwPZDT4T5D@lunn.ch>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <Y25bQfVwPZDT4T5D@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 5b107aa5-e7cc-447a-ab27-776d22546d33-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2022 14:25, Andrew Lunn wrote:
>> 1. Forward planning to replace KSZ9021 with KSZ9031 in a future hardware
>> iteration.  As long as the device tree and kernel driver (and possibly the
>> bootloader if it uses the same device tree blob as the kernel internally)
>> are upgraded at the same time, software upgrades of existing hardware with
>> KSZ9021 will continue to work correctly.  Upgraded hardware with KSZ9031
>> will work properly with the updated software.
>>
>> 2. Due to KSZ9031 chip shortages, it may be useful to replace KSZ9031 with
>> KSZ9021 for a few manufacturing runs.  This can be done as long as the
>> device tree and driver are updated to know about the new property in time
>> for those manufacturing runs.
>>
>> In both cases, the skew timings chosen would need to apply to both KSZ9021
>> and KSZ9031.
> 
> So you are saying that as it is pin compatible ( i assume), you can
> swap the PHY and still call it the same board, and still use the same
> device tree blob.

Yes, but you've convinced me that it is slightly more involved than I 
initially thought!

> If you are going to do this, i think you really should fix all the
> bugs, not just the step. KSZ9021 has an offset of -840ps. KSZ9031 has
> an offset of -900ps. So both are broke, in that the skew is expected
> to be a signed value, 0 meaning 0.
> 
> I would suggest a bool property something like:
> 
> micrel,skew-equals-real-picoseconds
> 
> and you need to update the documentation in a way it is really clear
> what is going on.

Perhaps it could allow the renamed properties for the KSZ9131 to be 
used. (They have similar names to the KSZ9021/KSZ9031 properties, but 
change the `-ps` suffix to `-psec`.)  Those are already absolute 
timings.  There would need to be a decision on what to do if the node 
contains a mixture of `foo-ps` and `foo-psec` properties.

> I would also consider adding a phydev_dbg() which prints the actual ps
> skew being used, with/without the bug.
> 
> And since you are adding more foot guns, please validate the values in
> DT as strictly as possible, without breaking the existing binding.

Yes, some min/max clamping of skew values would be good.  The code for 
KSZ9131 does that already.

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-

