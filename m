Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B7E1D7FCF
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgERRPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:15:50 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:35378 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbgERRPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:15:50 -0400
Received: from [192.168.254.4] (unknown [50.34.197.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B2CEA13C2B0;
        Mon, 18 May 2020 10:15:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B2CEA13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1589822148;
        bh=NyVoTLXcAUhrdBxNZ3ByqbNgi3//xvQrJFVw1pieP30=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=EahJ6nXo7xZTcMND2RMRA4QyfxAc1FQKjY8+FPeO8oUKOR2i3l0nqdyxzv7gU4Vv6
         5YMXtFaxixJ0wrNqx15kMIf2rnfeEAq4VgGmvyoEbOYlayENNUB0xWSlLypTcHncK4
         xjQhLdCQM5BreEQPEobOFdGqMe+Wa4cHXg9HoiiE=
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
Date:   Mon, 18 May 2020 10:15:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20200518170934.GJ11244@42.do-not-panic.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/18/2020 10:09 AM, Luis Chamberlain wrote:
> On Mon, May 18, 2020 at 09:58:53AM -0700, Ben Greear wrote:
>>
>>
>> On 05/18/2020 09:51 AM, Luis Chamberlain wrote:
>>> On Sat, May 16, 2020 at 03:24:01PM +0200, Johannes Berg wrote:
>>>> On Fri, 2020-05-15 at 21:28 +0000, Luis Chamberlain wrote:> module_firmware_crashed
>>>>
>>>> You didn't CC me or the wireless list on the rest of the patches, so I'm
>>>> replying to a random one, but ...
>>>>
>>>> What is the point here?
>>>>
>>>> This should in no way affect the integrity of the system/kernel, for
>>>> most devices anyway.
>>>
>>> Keyword you used here is "most device". And in the worst case, *who*
>>> knows what other odd things may happen afterwards.
>>>
>>>> So what if ath10k's firmware crashes? If there's a driver bug it will
>>>> not handle it right (and probably crash, WARN_ON, or something else),
>>>> but if the driver is working right then that will not affect the kernel
>>>> at all.
>>>
>>> Sometimes the device can go into a state which requires driver removal
>>> and addition to get things back up.
>>
>> It would be lovely to be able to detect this case in the driver/system
>> somehow!  I haven't seen any such cases recently,
>
> I assure you that I have run into it. Once it does again I'll report
> the crash, but the problem with some of this is that unless you scrape
> the log you won't know. Eventually, a uevent would indeed tell inform
> me.
>
>> but in case there is
>> some common case you see, maybe we can think of a way to detect it?
>
> ath10k is just one case, this patch series addresses a simple way to
> annotate this tree-wide.
>
>>>> So maybe I can understand that maybe you want an easy way to discover -
>>>> per device - that the firmware crashed, but that still doesn't warrant a
>>>> complete kernel taint.
>>>
>>> That is one reason, another is that a taint helps support cases *fast*
>>> easily detect if the issue was a firmware crash, instead of scraping
>>> logs for driver specific ways to say the firmware has crashed.
>>
>> You can listen for udev events (I think that is the right term),
>> and find crashes that way.  You get the actual crash info as well.
>
> My follow up to this was to add uevent to add_taint() as well, this way
> these could generically be processed by userspace.

I'm not opposed to the taint, though I have not thought much on it.

But, if you can already get the crash info from uevent, and it automatically
comes without polling or scraping logs, then what benefit beyond that does
the taint give you?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
