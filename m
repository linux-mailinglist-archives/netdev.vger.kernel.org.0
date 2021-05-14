Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48803808B3
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhENLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 07:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhENLmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 07:42:12 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0164FC061574;
        Fri, 14 May 2021 04:41:00 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso1290916wmj.2;
        Fri, 14 May 2021 04:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tT6jKLZNQNfFr1GIuQvLHWEimMB6bE2z6imkro1v2a8=;
        b=GVNO3CokxQ8SOTfZEfWxNhJl0fvGM1xPU3k3KDXx9mLTCP6rYJriNTmwvnLIoCpoBa
         JdcErrs5j60EdlS1hTt7ate9LCNPsXryDn3uUCrCgxoOz3b3Q6iqc0NyRs2+gclx9k+c
         I6buShHdjfVbW8GY9gAxaJ6USaWSPcK/ugll8PGmX0dK22hCIdA21HCAH7RrO/dMkuaW
         mIyWcsEI73b2vvxsHN6jvPkPNehKA4iRyZ1NYCPgwek4aYeib3pg6WH8rkJIQLPvb/gF
         0koTJYXnzxslXP9OycK2YjDnz6jRqgS31fyS69N5ihnU8RxxbLtUNl62qMh0SHCuXSVF
         sFEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tT6jKLZNQNfFr1GIuQvLHWEimMB6bE2z6imkro1v2a8=;
        b=SPGuGFP0iOoimIZclc1mvcjmh7AdR6zx0WAdX0ybGpHqxQIoggt925XmnIMZxE4suU
         tz8PzmtXK8AdZI4QGglRTQMMdit5bg/+6fvKUCG6P39nREEBIumxGvrmKvqbPFYwNfgu
         5jHG1+IGzd5nBk5a4qwBWkATlj5pbLG8G1AsylLHiQlpoWSugUMg2F+RtA26Fj4Qvl5Y
         zsVMgUsGZgJPmxrhVwiokxcUgFTlM97Uk/Ith28Iqt5OMqPYMXgIO8cHG8dc0wcfLcO5
         kwlJmfRPd3txfjcLmT7mDUqVm1tKyMN5VebO/JVAumJNHKE7KDwDFi2mqEekPt6G1EiP
         5M8A==
X-Gm-Message-State: AOAM531hd/4FOYHGudnnTHoX5nFdRvTtjHDm38qOeR4E/VQPpdsF5jex
        ADfnqm1z7bciXtUVzIctGbk=
X-Google-Smtp-Source: ABdhPJxlBZ6eXp05NMP11e+cgbIDlzJuQ/ORHGVZUsg5IxZwf9+GcRDJAxqgu28sch2iYpqtwU++gQ==
X-Received: by 2002:a05:600c:4a22:: with SMTP id c34mr49233188wmp.160.1620992458669;
        Fri, 14 May 2021 04:40:58 -0700 (PDT)
Received: from [192.168.2.202] (pd9e5a369.dip0.t-ipconnect.de. [217.229.163.105])
        by smtp.gmail.com with ESMTPSA id x10sm4051041wrt.65.2021.05.14.04.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 04:40:58 -0700 (PDT)
Subject: Re: [BUG] Deadlock in _cfg80211_unregister_wdev()
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
References: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
 <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
From:   Maximilian Luz <luzmaximilian@gmail.com>
Message-ID: <522833b9-08c1-f470-a328-0e7419e86617@gmail.com>
Date:   Fri, 14 May 2021 13:40:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/21 10:26 AM, Johannes Berg wrote:
> On Fri, 2021-05-14 at 01:07 +0200, Maximilian Luz wrote:
>> Following commit a05829a7222e ("cfg80211: avoid holding the RTNL when
>> calling the driver"), the mwifiex_pcie module fails to unload. This also
>> prevents the device from rebooting / shutting down.
>>
>> Attempting to unload the module
>>
> 
> I'm *guessing* that you're attempting to unload the module while the
> interface is still up, i.e. you didn't "ip link set wlan0 down" first?

I did not. Doing so indeed allows unloading of the module.

> If so, that is likely fixed by this commit as well:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ea6b2098dd02789f68770fd3d5a373732207be2f

Thanks for pointing this out. That's backported to 5.12.2, right?
Unfortunately the error still persists there (as on all other post 5.12
kernels, as mentioned below).

> However, your log says:
> 
>> [  245.504764]       Tainted: G         C OE     5.11.0-1-surface-dev #2
> 
> so I have no idea what kernel you're using, because 5.11 did *not*
> contain commit a05829a7222e ("cfg80211: avoid holding the RTNL when
> calling the driver"). If you backported the bug you get to be
> responsible for backporting the fixes too?

This is a log from a05829a7222e checked out, which was pre 5.12-rc1, so the
last tag is still 5.11 which sets the package version in my packaging scripts
to that as well. It's not an actual 5.11 kernel, sorry for the confusion.
There is no backporting going on, just bisecting.

> If that's all not solving the issue then please try to resolve with gdb
> what line of code "cfg80211_netdev_notifier_call+0x12a" is, and please
> also clarify exactly what (upstream!) kernel you're using.

The issue exists on 5.12 through 5.12.4, as well as 5.13-rc1 (which is
why I didn't bother specifying a version, sorry again).

If you really want me to, I'll try to find some time to learn GDB kernel
debugging (never done that before, so might take a bit) however, I think
it's fairly clear what's going wrong and why the fix you've linked below
doesn't apply in this case:

Your fix is fixing

     cfg80211_destroy_iface_wk() takes wiphy_lock
      -> cfg80211_destroy_ifaces()
       -> ieee80211_del_iface
        -> ieeee80211_if_remove
         -> cfg80211_unregister_wdev
          -> unregister_netdevice_queue
           -> dev_close_many
            -> __dev_close_many
             -> raw_notifier_call_chain
              -> cfg80211_netdev_notifier_call

by addressing this in cfg80211_destroy_iface{s,_wk}(). The trace from my
log shows

     mwifiex_uninit_sw() takes wiphy_lock
      -> mwifiex_del_virtual_intf
       -> cfg80211_unregister_netdevice()
        -> cfg80211_unregister_wdev()
         -> _cfg80211_unregister_wdev() has lockdep_assert_held(&rdev->wiphy.mtx)
          -> unregister_netdevice_queue
           -> dev_close_many
            -> __dev_close_many
             -> raw_notifier_call_chain
              -> cfg80211_netdev_notifier_call attempts to take wiphy_lock again

So your fix does not address this particular issue. It doesn't even
touch any of the affected code path. I believe it is instead fixing one
symptom of the same underlying problem.

While the last parts of the trace are the same (specifically following
cfg80211_unregister_wdev()), the lock is initially taken in different
functions. Your fix addresses this by changing cfg80211_destroy_ifaces(),
and cfg80211_destroy_iface_wk() which, however, were never called on the
path that's causing _this_ issue.

Furthermore, if you go through that trace, there's only one notifier
call in __dev_close_many(), which is

   call_netdevice_notifiers(NETDEV_GOING_DOWN, dev)

which I believe I have linked in my previous mail. Since the state value
is NETDEV_GOING_DOWN, this has to be case [3] (unless I'm missing
something).

Regards,
Max

[3]: https://elixir.bootlin.com/linux/v5.13-rc1/source/net/wireless/core.c#L1428
