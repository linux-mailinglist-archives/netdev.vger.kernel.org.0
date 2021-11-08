Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35994499B2
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbhKHQai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhKHQah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 11:30:37 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55049C061570;
        Mon,  8 Nov 2021 08:27:53 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id n85so12015226pfd.10;
        Mon, 08 Nov 2021 08:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=06pjZgUlhuSLHVkSAvU2VOH/sHyuv+YQc4ZfaT3ttl0=;
        b=WPKGIGDNpXn3gfNci+GeR1RT1zNO+AcE1eoQppQ6W3uJQtn9uyBzgNSVOl7IvQTpsZ
         swau6Rcp38biDe2TFzfDTQJ3sd/jGf1FFwIUN+Mp/W+GnXVm6wjLG6yDnUFQZ4BVC16n
         4L8C0hRTFH4XcZavYxp5gKyKjrYhrcHvnAKWn8xRZrbICKc2l97zJNq3Y47X21bo/Jak
         IOJPXwYz51fJJFplwzxTDQvkC7hKU6CCaa0lw2xn/Osc6W90qISnGCq+0Vw267J3tdtC
         2ALWFKHZOim2j1JFVZQCOybQr2svGui94KCFEuxTdsPgZG5C5v1awKwNTpcz6yHsXhhT
         woNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06pjZgUlhuSLHVkSAvU2VOH/sHyuv+YQc4ZfaT3ttl0=;
        b=M92ExlxTPrvOm09oUR2HNiod74uu0MCHB3b5nKoylSOYDs5bZCHYn+0BAEfAq6oPN6
         H41gVKJz2MEGyyZUhgOBlyE70xWX7tiqcLUlrlTVf/6+5bOueSbRhZ8UWS4yd4IwYneU
         XmaHLiDuE/X5ei6SBsSoKsxJs/bBwkxnhNdndk+A4r1Y0Vjykw6fI434cxq+5vgvHlpJ
         vOlfkOgCPwkCVXAXkf4PBYTyuhjGGJyVoJeUvF+ZEEs8ToQlkWCOx6h56KvtxffC1u9k
         TN7r24ovKiV0QSkG4sjA1k4uacZbsAxPBfuno+WkGwF5Bq+PSHHcEneATj7LJXHlJJIf
         4HAg==
X-Gm-Message-State: AOAM532wZTPmItWNqnC5buRWvzzrSxSqWuGC586D77i6CgnbNRvnwM+6
        PYzW+Z5mD9tGwMblnfrNsRQ=
X-Google-Smtp-Source: ABdhPJwYkwHWXMW8cexif3W/MwCFRyjWUyKQQ7LUdUrSS+hfN8U80oGITmZRDoMj+NbNpm4RmUkQWA==
X-Received: by 2002:a63:f52:: with SMTP id 18mr518972pgp.58.1636388872836;
        Mon, 08 Nov 2021 08:27:52 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k20sm17287865pfc.83.2021.11.08.08.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 08:27:52 -0800 (PST)
Subject: Re: [RFC PATCH] sched&net: avoid over-pulling tasks due to network
 interrupts
To:     Peter Zijlstra <peterz@infradead.org>,
        Barry Song <21cnbao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        fw@strlen.de, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        Guodong Xu <guodong.xu@linaro.org>,
        yangyicong <yangyicong@huawei.com>, shenyang39@huawei.com,
        tangchengchang@huawei.com, Barry Song <song.bao.hua@hisilicon.com>,
        Libo Chen <libo.chen@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
References: <20211105105136.12137-1-21cnbao@gmail.com>
 <YYUiYrXMOQGap4+5@hirez.programming.kicks-ass.net>
 <CAGsJ_4wofduvT2BJipJppJza_ZyL2pU3Ni-B3R+A3_Zqv2v_4g@mail.gmail.com>
 <YYjthV9W09H5Err8@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c94dd79-af90-3258-6f53-d63417ce4126@gmail.com>
Date:   Mon, 8 Nov 2021 08:27:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YYjthV9W09H5Err8@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/21 1:27 AM, Peter Zijlstra wrote:
> On Mon, Nov 08, 2021 at 07:08:09AM +1300, Barry Song wrote:
>> On Sat, Nov 6, 2021 at 1:25 AM Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> On Fri, Nov 05, 2021 at 06:51:36PM +0800, Barry Song wrote:
>>>> From: Barry Song <song.bao.hua@hisilicon.com>
>>>>
>>>> In LPC2021, both Libo Chen and Tim Chen have reported the overpull
>>>> of network interrupts[1]. For example, while running one database,
>>>> ethernet is located in numa0, numa1 might be almost idle due to
>>>> interrupts are pulling tasks to numa0 because of wake_up affine.
>>>> I have seen the same problem. One way to solve this problem is
>>>> moving to a normal wakeup in network rather than using a sync
>>>> wakeup which will be more aggressively pulling tasks in scheduler
>>>> core.
>>>>
>>>> On kunpeng920 with 4numa, ethernet is located at numa0, storage
>>>> disk is located at numa2. While using sysbench to connect this
>>>> mysql machine, I am seeing numa1 is idle though numa0,2 and 3
>>>> are quite busy.
>>>>
>>>
>>>> I am not saying this patch is exactly the right approach, But I'd
>>>> like to use this RFC to connect the people of net and scheduler,
>>>> and start the discussion in this wider range.
>>>
>>> Well the normal way would be to use multi-queue crud and/or receive
>>> packet steering to get the interrupt/wakeup back to the cpu that data
>>> came from.
>>
>> The test case has been a multi-queue ethernet and irqs are balanced
>> to NUMA0 by irqbalanced or pinned to NUMA0 where the card is located
>> by the script like:
>> #!/bin/bash
>> irq_list=(`cat /proc/interrupts | grep network_name| awk -F: '{print $1}'`)
>> cpunum=0
>> for irq in ${irq_list[@]}
>> do
>> echo $cpunum > /proc/irq/$irq/smp_affinity_list
>> echo `cat /proc/irq/$irq/smp_affinity_list`
>> (( cpunum+=1 ))
>> done
>>
>> I have heard some people are working around this issue  by pinning
>> multi-queue IRQs to multiple NUMAs which can spread interrupts and
>> avoid over-pulling tasks to one NUMA only, but lose ethernet locality?
> 
> So you're doing explicitly the wrong thing with your script above and
> then complain the scheduler follows that and destroys your data
> locality?
> 
> The network folks made RPS/RFS specifically to spread the processing of
> the packets back to the CPUs/Nodes the TX happened on to increase data
> locality. Why not use that?
> 

+1

This documentation should describe how this can be done

Documentation/networking/scaling.rst

Hopefully it is not completely outdated.
 
