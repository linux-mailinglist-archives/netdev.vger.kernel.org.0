Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17A1DB426
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgETMvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgETMvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 08:51:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC757C061A0E;
        Wed, 20 May 2020 05:51:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id z15so2317843pjb.0;
        Wed, 20 May 2020 05:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XVrZcEQ3Ohwq93lQaVh49GHURIxMEGS078tmEHwT2JQ=;
        b=aOST2MULZ/U9WisiPYmah4vmhjjvFf/jMZY3I2re/kUa5PCYb2JOrvRfx6QapIT4PT
         DdPWlxNkXXtABiJ8ZLQH8y+tCiMkVBQWvKF4e2r5teEkEILQrJS3mwV0fC/BwUE4SOYl
         5rVAlIyi4b5/dEdVT5XZYzXE6e1RTsrPrBfaOzmhYJAzNkayzQaheIjaZhsNU9xer7RZ
         eHtsX04xOAXnBxnfhnloASIpXviTlUD+5kQoMRjM0P8lrJdK81kDkxDJMwj2mpNAaJJ7
         2pJTZ3q+BTp4lYWkc7Bl8sUZrWBba9QxiFNRZdlJijDTq67sB2lDV/CzXVP0OamL3PS4
         Pshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVrZcEQ3Ohwq93lQaVh49GHURIxMEGS078tmEHwT2JQ=;
        b=cP/9GVALplibfpPTuggHEiOCzkFtE+neE+68DxTy514ZEBwrBCC5795MJPt0x9qGID
         pDlOqv2OibDAT33KPi2KjxeqofF1PLqYTrJT2XABs1sUFdRh2qNtFgTVjsabWrPsgKB9
         xUz6WFHupDkd45LRvXZN4Cc44Q/6pCV5s5xoK7XnSwwsr0kj0M/TQzxFpfGQEvQcou1D
         myC6EE+XBZzmd6MEj0T7maf/MhmrffsMDI3FDKAkIYA2fDXykfBYNOnNqBbjgBbI6Vtz
         RXc9jWfpcXixKSOqTOtXE4LYRInXzWMTBzuLbaEFMR30EAzbNG/MFtJGMq4SCo2wLk3l
         mDgw==
X-Gm-Message-State: AOAM533dZe61vcyio66nBDvjgNqgMThKkaemjLOpi74FfLy/xPZmnJme
        7AT4d4CobclGn5gmckqGKzMHcjKh
X-Google-Smtp-Source: ABdhPJz/vfz6SPgr2I4WPUNz2HX9I6wa5WPDb+JOB4wSOa/i95lO65KxDD4uC82ktZiTA2FuyRsamg==
X-Received: by 2002:a17:90b:1288:: with SMTP id fw8mr5179133pjb.160.1589979090211;
        Wed, 20 May 2020 05:51:30 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id mn19sm2109266pjb.8.2020.05.20.05.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 05:51:29 -0700 (PDT)
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a
 seqcount
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200519214547.352050-2-a.darwish@linutronix.de>
 <33cec6a9-2f6e-3d3c-99ac-9b2a3304ec26@gmail.com>
 <20200520064246.GA353513@debian-buster-darwi.lab.linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1498089b-08bd-d776-1570-d8b34463c702@gmail.com>
Date:   Wed, 20 May 2020 05:51:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520064246.GA353513@debian-buster-darwi.lab.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/20 11:42 PM, Ahmed S. Darwish wrote:
> Hello Eric,
> 
> On Tue, May 19, 2020 at 07:01:38PM -0700, Eric Dumazet wrote:
>>
>> On 5/19/20 2:45 PM, Ahmed S. Darwish wrote:
>>> Sequence counters write paths are critical sections that must never be
>>> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
>>>
>>> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
>>> netdev name retrieval.") handled a deadlock, observed with
>>> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
>>> infinitely spinning: it got scheduled after the seqcount write side
>>> blocked inside its own critical section.
>>>
>>> To fix that deadlock, among other issues, the commit added a
>>> cond_resched() inside the read side section. While this will get the
>>> non-preemptible kernel eventually unstuck, the seqcount reader is fully
>>> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
>>>
>>> The fix is also still broken: if the seqcount reader belongs to a
>>> real-time scheduling policy, it can spin forever and the kernel will
>>> livelock.
>>>
>>> Disabling preemption over the seqcount write side critical section will
>>> not work: inside it are a number of GFP_KERNEL allocations and mutex
>>> locking through the drivers/base/ :: device_rename() call chain.
>>>
>>> From all the above, replace the seqcount with a rwsem.
>>>
>>> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
>>> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
>>> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
>>> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>> ---
>>>  net/core/dev.c | 30 ++++++++++++------------------
>>>  1 file changed, 12 insertions(+), 18 deletions(-)
>>>
>>
>> Seems fine to me, assuming rwsem prevent starvation of the writer.
>>
> 
> Thanks for the review.
> 
> AFAIK, due to 5cfd92e12e13 ("locking/rwsem: Adaptive disabling of reader
> optimistic spinning"), using a rwsem shouldn't lead to writer starvation
> in the contended case.

Hmm this was in linux-5.3, so very recent stuff.

Has this patch been backported to stable releases ?

With all the Fixes: tags you added, stable teams will backport this networking patch to
all stable versions.

Do we have a way to tune a dedicare rwsem to 'give preference to the (unique in this case) writer" over
a myriad of potential readers ?

Thanks.

