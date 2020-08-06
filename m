Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1801623D8E4
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 11:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgHFJq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 05:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbgHFJqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 05:46:48 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8154C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 02:46:47 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 3so9045234wmi.1
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 02:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HCuZ1AE6ZgXTHf6fXEjPA1475jOCie1uEGUdegbvURc=;
        b=d1+mOJ23EM0hnP6wz0k3umfPrQkIoAa9bP0QF3OozgSz/ibmWxne3rLbPpKErmJedw
         L/so77oV3BTV6k2GAy03XiKHi/gV8nnGX5rXwlufnzhOyrc6SJe+MqGV5ZI5sP2a7MDZ
         bJIKp01a6M28Fh21VlucbDi0T+3Tm2K/nmH+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HCuZ1AE6ZgXTHf6fXEjPA1475jOCie1uEGUdegbvURc=;
        b=OGALD/7zfBrPgXAECNLdiyHR7byr+/2NJByNu2WdDVjlKvGkA50JQh9ovApS3dQEZR
         94i58JBYFGEd+uyVgwLH85yVbI5viHvGEDJagMtHQjH3SsfWtsjVhgcHIOcj8Oe0ReaT
         tiK8MZHy4eBxOnBRMacSZ0BDZlKwhUXmZ9Ea+6PRllp5kZHOKY+u/gZU7xwxmtiGCfkY
         8b8Hl0lt3M5x/zPpPTFmn6aqGqVLL26P86XQcEAjNXyq5HUtq/IsADMmBLFgsejyAmsZ
         xApGS4aEWj3lbocid9r7ov9Oj3JjRSBG4E0OFvAZ0LqQAPfyRhCSDYf3FI1PT9zq4f9T
         bWsg==
X-Gm-Message-State: AOAM533d9Nd0gQEtQFUZ0b6uSsBj4BWSRuzdzghy2xb4Lfgs6q7JCOIj
        xsEWK0znhqMV2TBdKsliv1DWHdxi36w=
X-Google-Smtp-Source: ABdhPJwcd0EqpLeabrxwAIHTm01vWFWbz6EZ2fax/g/vZRf40piGaxYPhq+xKV7MThoxMG6yBmUQTQ==
X-Received: by 2002:a1c:2d95:: with SMTP id t143mr6940521wmt.44.1596707205824;
        Thu, 06 Aug 2020 02:46:45 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 31sm5791630wrj.94.2020.08.06.02.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 02:46:44 -0700 (PDT)
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Network Development <netdev@vger.kernel.org>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
 <20200805163425.6c13ef11@hermes.lan>
 <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
Date:   Thu, 6 Aug 2020 12:46:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/08/2020 12:17, Rasmus Villemoes wrote:
> On 06/08/2020 01.34, Stephen Hemminger wrote:
>> On Wed, 5 Aug 2020 16:25:23 +0200
>> Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
>>
>>> Hi,
>>>
>>> We're seeing occasional lockups on an embedded board (running an -rt
>>> kernel), which I believe I've tracked down to the
>>>
>>>             if (!rtnl_trylock())
>>>                     return restart_syscall();
>>>
>>> in net/bridge/br_sysfs_br.c. The problem is that some SCHED_FIFO task
>>> writes a "1" to the /sys/class/net/foo/bridge/flush file, while some
>>> lower-priority SCHED_FIFO task happens to hold rtnl_lock(). When that
>>> happens, the higher-priority task is stuck in an eternal ERESTARTNOINTR
>>> loop, and the lower-priority task never gets runtime and thus cannot
>>> release the lock.
>>>
>>> I've written a script that rather quickly reproduces this both on our
>>> target and my desktop machine (pinning everything on one CPU to emulate
>>> the uni-processor board), see below. Also, with this hacky patch
>>
>> There is a reason for the trylock, it works around a priority inversion.
> 
> Can you elaborate? It seems to me that it _causes_ a priority inversion
> since priority inheritance doesn't have a chance to kick in.
> 
>> The real problem is expecting a SCHED_FIFO task to be safe with this
>> kind of network operation.
> 
> Maybe. But ignoring the SCHED_FIFO/rt-prio stuff, it also seems a bit
> odd to do what is essentially a busy-loop - yes, the restart_syscall()
> allows signals to be delivered (including allowing the process to get
> killed), but in the absence of any signals, the pattern essentially
> boils down to
> 
>   while (!rtnl_trylock())
>     ;
> 
> So even for regular tasks, this seems to needlessly hog the cpu.
> 
> I tried this
> 
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 0318a69888d4..e40e264f9b16 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -44,8 +44,8 @@ static ssize_t store_bridge_parm(struct device *d,
>         if (endp == buf)
>                 return -EINVAL;
> 
> -       if (!rtnl_trylock())
> -               return restart_syscall();
> +       if (rtnl_lock_interruptible())
> +               return -ERESTARTNOINTR;
> 
>         err = (*set)(br, val);
>         if (!err)
> 
> with the obvious definition of rtnl_lock_interruptible(), and it makes
> the problem go away. Isn't it better to sleep waiting for the lock (and
> with -rt, giving proper priority boost) or a signal to arrive rather
> than busy-looping back and forth between syscall entry point and the
> trylock()?
> 
> I see quite a lot of
> 
>     if (mutex_lock_interruptible(...))
>             return -ERESTARTSYS;
> 
> but for the rtnl_mutex, I see the trylock...restart_syscall pattern
> being used in a couple of places. So there must be something special
> about the rtnl_mutex?
> 
> Thanks,
> Rasmus
> 

Hi Rasmus,
I haven't tested anything but git history (and some grepping) points to deadlocks when
sysfs entries are being changed under rtnl.
For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
This is a common usage pattern throughout net/, the bridge is not the only case and there are more
commits which talk about deadlocks.
Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.

Cheers,
 Nik


