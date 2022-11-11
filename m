Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699F1625889
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbiKKKlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 05:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiKKKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 05:41:45 -0500
X-Greylist: delayed 413 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 11 Nov 2022 02:41:43 PST
Received: from smtp79.ord1d.emailsrvr.com (smtp79.ord1d.emailsrvr.com [184.106.54.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8232654E5
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 02:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1668162890;
        bh=sj8snJ80DkU30+xIoncU8DmYPeC+W6Y1vkK570DfJno=;
        h=Date:Subject:To:From:From;
        b=bErCIhbDeIb5GHsBxzY3fLcQ5QWHXYA+WyFlTBSIgC3Q9tE2tVDKq4kXzIha3xcFN
         abJmr25Ak+D+OjubmuZykBDYJZt8I9NCjttsg458/UIwe2DfvMFTYxZ7r63GF6cCu+
         EZQcoUQYeI+g2TS6e3djt9VOMU5WMtjVOkQ9YNbk=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp2.relay.ord1d.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 96AAD20072;
        Fri, 11 Nov 2022 05:34:49 -0500 (EST)
Message-ID: <0b22ce6a-97b5-2784-fb52-7cbae8be39b0@mev.co.uk>
Date:   Fri, 11 Nov 2022 10:34:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC] option to use proper skew timings for Micrel KSZ9021
Content-Language: en-GB
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
 <Y2vi/IxoTpfwR65T@lunn.ch>
From:   Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd.
In-Reply-To: <Y2vi/IxoTpfwR65T@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: fbe65feb-5cb2-48ff-9ea8-48e7808a6fbe-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 17:27, Andrew Lunn wrote:
>> I would like to add an optional boolean property to indicate that the skew
>> timing properties are to be interpreted as "proper" skew timings (in 120ps
>> steps) rather than fake skew timings.  When this property is true, the
>> driver can divide the specified skew timing values by 120 instead of 200.
>> The advantage of this is that the same skew timing property values can be
>> used in the device node and will apply to both KSZ9021 and KSZ9031 as long
>> as the values are in range for both chips.
> 
> Hi Ian
> 
> I don't see why this is an advantage. Yes, it is all messed up, but it
> is a well defined and documented mess. All this boolean will do is
> make it a more complex mess, leading it more errors with the wrong
> value set.

Hi Andrew,

I can think of a couple of use cases.  For example:

1. Forward planning to replace KSZ9021 with KSZ9031 in a future hardware 
iteration.  As long as the device tree and kernel driver (and possibly 
the bootloader if it uses the same device tree blob as the kernel 
internally) are upgraded at the same time, software upgrades of existing 
hardware with KSZ9021 will continue to work correctly.  Upgraded 
hardware with KSZ9031 will work properly with the updated software.

2. Due to KSZ9031 chip shortages, it may be useful to replace KSZ9031 
with KSZ9021 for a few manufacturing runs.  This can be done as long as 
the device tree and driver are updated to know about the new property in 
time for those manufacturing runs.

In both cases, the skew timings chosen would need to apply to both 
KSZ9021 and KSZ9031.

(At the time of writing, KSZ9031RNX chips are very difficult to get hold 
of except at exorbitant prices from scalpers (~US$200 per chip!), but 
the older generation KSZ9021RN chips are much easier to get hold of 
(~US$5 per chip).)

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
