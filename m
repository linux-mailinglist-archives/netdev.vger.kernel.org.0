Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6689C15A051
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 06:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbgBLFI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 00:08:56 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:37562 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgBLFI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 00:08:56 -0500
Received: by mail-pf1-f173.google.com with SMTP id p14so620091pfn.4;
        Tue, 11 Feb 2020 21:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i6oz4Em/YwD3zMXErB3gfnjjpevME7SwZCfI7Bvtm8I=;
        b=n73nQHFjhy+TiG3McdOtcWdpXmLqd3TJ/QJXJliiwFcRDQXzZD9TCGt3XkOlhz8cwH
         3lheFgTW7pjZ3IWM/kYBsY4Kxie3OwJGLu4hW/45WqIE7wWyJ0WKm9jq7RZU71Qh851o
         +oI7f8Or8ABx6bn9mSAlmN9EbBBubGoGLyGOxzxCccXurub9tOOg8pMqlXq8zodcqhZQ
         8tMm/m7a04fvLvRRyGOP4p1J0TKqa9K7sakeHh29hbC0qBRrPEcsryZVtK5nNkZexxov
         le4PZoj/9do7rIz/16nb7coONIntjJGSBxpBHF/tN6A5x9hFD8whorppnUvrTvVvg7eR
         pFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6oz4Em/YwD3zMXErB3gfnjjpevME7SwZCfI7Bvtm8I=;
        b=tLJlt15Y0xivbGaoUKaaiDS7GP0lksOciOvi1ubMwshEUBzHmdU4ccYRQKojGFsPmo
         UMA6EHg3yXbO8K//whnpy/CmaDzeRH88Qyb8XUhZgJaF3cUx4dTyYkUj3O0N0m4h7GRV
         VdWI6PLf8LGkVEipU5ARyjUimUkWKY45JzXodOIu26yalFJGeIehaW/4PRVj95Jd2B1p
         cKfMtKlHzCvY4KGDJ0OUpjNdL8TqD8ntiAWpGE1CO93BglQ6K0uIzJ5jiO7FnWGB62ux
         6bBlN3FtAQCeVvbKzHolxRhuBYIkI5xEQOL8poGH9cyu294HLFqYMqZP2kImFxPbrinL
         axnw==
X-Gm-Message-State: APjAAAU7muFiyefPfDBNya7bRPUdGAyXCuow/gMaeN+wvzOeBXqN8KxR
        AdhqzcGQZnHf6IzMUzMMSS0t1j/Q
X-Google-Smtp-Source: APXvYqz5FqsvQRv0b2GKjMQgW95qAHtiaIEADGGBRLwPeXIw3RL56UOM15zhS61eAIH5iXWH+0H9RQ==
X-Received: by 2002:a63:cd43:: with SMTP id a3mr10817674pgj.247.1581484135202;
        Tue, 11 Feb 2020 21:08:55 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n15sm6330225pfq.168.2020.02.11.21.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 21:08:54 -0800 (PST)
Subject: Re: Deadlock in cleanup_net and addrconf_verify_work locks up
 workqueue
To:     Sargun Dhillon <sargun@sargun.me>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Gabriel Hartmann <ghartmann@netflix.com>,
        Rob Gulewich <rgulewich@netflix.com>,
        Bruce Curtis <brucec@netflix.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
References: <20200211192330.GA9862@ircssh-2.c.rugged-nimbus-611.internal>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8924a0a5-9179-f6a9-91d8-1163b425ec35@gmail.com>
Date:   Tue, 11 Feb 2020 21:08:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200211192330.GA9862@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 11:23 AM, Sargun Dhillon wrote:
> We've found a workqueue stall / deadlock. Our workload is a container-oriented
> workload in which we utilize IPv6. Our container (namespace) churn is quite
> frequent, and containers can be terminated before their networking is
> even setup.
> 
> We're running 4.19.73 in production, and in investigation of the underlying
> causes, I don't think that future versions of 4.19 fix it.
> 
> We've narrowed it down to a lockup between ipv6_addrconf, and cleanup_net.

Sure, PID 1369493 addrconf_verify_work() is waiting for RTNL.

But PID 8  ?

__flush_work() is being called.

But from where ? Stacks seem not complete.


> 
> crash> bt 8
> PID: 8      TASK: ffff9a1072b50000  CPU: 24  COMMAND: "kworker/u192:0"
>  #0 [ffffbfe2c00fbb70] __schedule at ffffffffa7f02bf7
>  #1 [ffffbfe2c00fbc10] schedule at ffffffffa7f031e8
>  #2 [ffffbfe2c00fbc18] schedule_timeout at ffffffffa7f0700e
>  #3 [ffffbfe2c00fbc90] wait_for_completion at ffffffffa7f03b50
>  #4 [ffffbfe2c00fbce0] __flush_work at ffffffffa76a2532
>  #5 [ffffbfe2c00fbd58] rollback_registered_many at ffffffffa7dbcdf4
>  #6 [ffffbfe2c00fbdc0] unregister_netdevice_many at ffffffffa7dbd31e
>  #7 [ffffbfe2c00fbdd0] default_device_exit_batch at ffffffffa7dbd512
>  #8 [ffffbfe2c00fbe40] cleanup_net at ffffffffa7dab970
>  #9 [ffffbfe2c00fbe98] process_one_work at ffffffffa76a17c4
> #10 [ffffbfe2c00fbed8] worker_thread at ffffffffa76a19dd
> #11 [ffffbfe2c00fbf10] kthread at ffffffffa76a7fd3
> #12 [ffffbfe2c00fbf50] ret_from_fork at ffffffffa80001ff
> 
> crash> bt 1369493
> PID: 1369493  TASK: ffff9a03684d9600  CPU: 58  COMMAND: "kworker/58:1"
>  #0 [ffffbfe30d68fd48] __schedule at ffffffffa7f02bf7
>  #1 [ffffbfe30d68fde8] schedule at ffffffffa7f031e8
>  #2 [ffffbfe30d68fdf0] schedule_preempt_disabled at ffffffffa7f0349a
>  #3 [ffffbfe30d68fdf8] __mutex_lock at ffffffffa7f04aed
>  #4 [ffffbfe30d68fe90] addrconf_verify_work at ffffffffa7e8d1aa
>  #5 [ffffbfe30d68fe98] process_one_work at ffffffffa76a17c4
>  #6 [ffffbfe30d68fed8] worker_thread at ffffffffa76a19dd
>  #7 [ffffbfe30d68ff10] kthread at ffffffffa76a7fd3
>  #8 [ffffbfe30d68ff50] ret_from_fork at ffffffffa80001ff
> 
> 
> 
>  struct -x mutex.owner.counter rtnl_mutex
>   owner.counter = 0xffff9a1072b50001
> 
> 0xffff9a1072b50001 & (~0x07) = 0xffff9a1072b50000
> 
> This points back to PID 8 / CPU 24. It is working on cleanup_net, and a part
> of cleanup net involves calling ops_exit_list, and as part of that it calls
> default_device_exit_batch. default_device_exit_batch takes the rtnl lock before
> calling into unregister_netdevice_many, and rollback_registered_many.
> rollback_registered_many calls flush_all_backlogs. This will never complete
> because it is holding the rtnl lock, and PID 1369493 / CPU 58 is waiting
> for rtnl_lock.

But PID 1369493 is waiting on a mutex, thus properly yielding the cpu.
(schedule() is clearly shown)

This should not prevent other threads
from making progress so that flush_all_backlogs() completes eventually.

flush_all_backlogs() does not care of how many threads are currently blocked
because they can not grab rtnl while flush_all_backlogs() is running.

> 
> If relevant, the workqueue stalls themselves look something like:
> BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=0 stuck for 3720s!
> BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=-20 stuck for 3719s!
> Showing busy workqueues and worker pools:
> workqueue events: flags=0x0
>   pwq 32: cpus=16 node=0 flags=0x0 nice=0 active=2/256
>     in-flight: 1274779:slab_caches_to_rcu_destroy_workfn slab_caches_to_rcu_destroy_workfn
> workqueue events_highpri: flags=0x10
>   pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
>     pending: flush_backlog BAR(8)
> workqueue events_power_efficient: flags=0x82
>   pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
>     in-flight: 1396446:check_lifetime
> workqueue mm_percpu_wq: flags=0x8
>   pwq 140: cpus=70 node=0 flags=0x0 nice=0 active=1/256
>     pending: vmstat_update
> workqueue netns: flags=0xe000a
>   pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
>     in-flight: 8:cleanup_net
>     delayed: cleanup_net
> workqueue writeback: flags=0x4e
>   pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
>     in-flight: 1334335:wb_workfn
> workqueue kblockd: flags=0x18
>   pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
>     pending: blk_mq_run_work_fn
> workqueue ipv6_addrconf: flags=0x40008
>   pwq 116: cpus=58 node=0 flags=0x0 nice=0 active=1/1
>     in-flight: 1369493:addrconf_verify_work
> workqueue ena: flags=0xe000a
>   pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
>     in-flight: 7505:ena_fw_reset_device [ena]
> 
