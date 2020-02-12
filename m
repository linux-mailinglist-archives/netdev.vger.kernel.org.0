Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E0415A0AD
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 06:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgBLFgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 00:36:32 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36670 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgBLFgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 00:36:31 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so513222plm.3;
        Tue, 11 Feb 2020 21:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=djGdtLQBSo6slMTPwkCZM128lW+uk2cY++9NjwuUFtg=;
        b=qAzWdnmG0i+/gCiKXMqTvTKModKwn16+zDrN3sJbaPgHglcgWuGbKihzCHuTUPer6E
         T4FI4U+vhy1VHR2SUbywkeLivwjN5zOcT+t2be4nhhC2rXTOPKLdltOSXl3WcKZXJR0p
         JT2BtmWAYa4FVuOXfBEV0qzAK3AT4ksRfNIuDD8zrgBZGb8f51WLcb4DjcebQIEpUcO+
         qLWDGcU0dMeQsco96R09YomlKVqwv6inOGiTRtyeS5PoHtUyEJt9bbpmRdVS8f7Vf6en
         Kh3Mxd0zdGlxzjJEQxTHTTOO7Qedy0OzuHsQRSgbY/qlDjHjp2NhigilXkn6A2MCeI3v
         bIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=djGdtLQBSo6slMTPwkCZM128lW+uk2cY++9NjwuUFtg=;
        b=QTKh0Lm4UVwZ5r0vpkKFIlPIcK8PV1mqLwMJPMhIz/5Ofep5Fahqg4SsapqsnAW5NT
         G2GfVn3yATNcjicl8NPHs1CAkb0OgYYed2nuqqsBT2Anq0rvdVjYyShWdNZBq3M3QbrI
         ElD/YTGnDQSP2OZzbpnjT7eVg1MCveAEwID9O7A7el/UWsPjUX3LrHF9m8TyVL/1zrxH
         Rt/HCShwUEUw7bWSkTRVq5GrPYYQowZHrF13VSGQ9xDHei/kNTq29x4uW6D0ZlEIhLbN
         RiTC3Mmkx2vUgIbD0D70y8MirLRrdjqa8r+DofWgvSqlQ82SoxQo5MA3AgRR87pWc52M
         u3ow==
X-Gm-Message-State: APjAAAVMBh6imv8+IoEvISN/ZlEh4z4w1C6HQhRkWq7XNecpYET5NC6D
        kKV/mnVkII6YFXr3BeyASnQ=
X-Google-Smtp-Source: APXvYqynQlvI7U4wvrevwh4HRFy3Xyt//DV5BuosPmk/enKxdVat+xl7Q1uWKNKmr3HwNObMpB3Vxg==
X-Received: by 2002:a17:90b:3c9:: with SMTP id go9mr7992864pjb.7.1581485790863;
        Tue, 11 Feb 2020 21:36:30 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id h7sm6149415pgc.69.2020.02.11.21.36.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 21:36:30 -0800 (PST)
Subject: Re: Deadlock in cleanup_net and addrconf_verify_work locks up
 workqueue
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Sargun Dhillon <sargun@sargun.me>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Gabriel Hartmann <ghartmann@netflix.com>,
        Rob Gulewich <rgulewich@netflix.com>,
        Bruce Curtis <brucec@netflix.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
References: <20200211192330.GA9862@ircssh-2.c.rugged-nimbus-611.internal>
 <8924a0a5-9179-f6a9-91d8-1163b425ec35@gmail.com>
Message-ID: <75e34850-54f5-6d08-e4f9-dd6e1e9ee09d@gmail.com>
Date:   Tue, 11 Feb 2020 21:36:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8924a0a5-9179-f6a9-91d8-1163b425ec35@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/11/20 9:08 PM, Eric Dumazet wrote:
> 
> 
> On 2/11/20 11:23 AM, Sargun Dhillon wrote:
>> We've found a workqueue stall / deadlock. Our workload is a container-oriented
>> workload in which we utilize IPv6. Our container (namespace) churn is quite
>> frequent, and containers can be terminated before their networking is
>> even setup.
>>
>> We're running 4.19.73 in production, and in investigation of the underlying
>> causes, I don't think that future versions of 4.19 fix it.
>>
>> We've narrowed it down to a lockup between ipv6_addrconf, and cleanup_net.
> 
> Sure, PID 1369493 addrconf_verify_work() is waiting for RTNL.
> 
> But PID 8  ?
> 
> __flush_work() is being called.
> 
> But from where ? Stacks seem not complete.
> 
> 
>>
>> crash> bt 8
>> PID: 8      TASK: ffff9a1072b50000  CPU: 24  COMMAND: "kworker/u192:0"
>>  #0 [ffffbfe2c00fbb70] __schedule at ffffffffa7f02bf7
>>  #1 [ffffbfe2c00fbc10] schedule at ffffffffa7f031e8
>>  #2 [ffffbfe2c00fbc18] schedule_timeout at ffffffffa7f0700e
>>  #3 [ffffbfe2c00fbc90] wait_for_completion at ffffffffa7f03b50
>>  #4 [ffffbfe2c00fbce0] __flush_work at ffffffffa76a2532
>>  #5 [ffffbfe2c00fbd58] rollback_registered_many at ffffffffa7dbcdf4
>>  #6 [ffffbfe2c00fbdc0] unregister_netdevice_many at ffffffffa7dbd31e
>>  #7 [ffffbfe2c00fbdd0] default_device_exit_batch at ffffffffa7dbd512
>>  #8 [ffffbfe2c00fbe40] cleanup_net at ffffffffa7dab970
>>  #9 [ffffbfe2c00fbe98] process_one_work at ffffffffa76a17c4
>> #10 [ffffbfe2c00fbed8] worker_thread at ffffffffa76a19dd
>> #11 [ffffbfe2c00fbf10] kthread at ffffffffa76a7fd3
>> #12 [ffffbfe2c00fbf50] ret_from_fork at ffffffffa80001ff
>>
>> crash> bt 1369493
>> PID: 1369493  TASK: ffff9a03684d9600  CPU: 58  COMMAND: "kworker/58:1"
>>  #0 [ffffbfe30d68fd48] __schedule at ffffffffa7f02bf7
>>  #1 [ffffbfe30d68fde8] schedule at ffffffffa7f031e8
>>  #2 [ffffbfe30d68fdf0] schedule_preempt_disabled at ffffffffa7f0349a
>>  #3 [ffffbfe30d68fdf8] __mutex_lock at ffffffffa7f04aed
>>  #4 [ffffbfe30d68fe90] addrconf_verify_work at ffffffffa7e8d1aa
>>  #5 [ffffbfe30d68fe98] process_one_work at ffffffffa76a17c4
>>  #6 [ffffbfe30d68fed8] worker_thread at ffffffffa76a19dd
>>  #7 [ffffbfe30d68ff10] kthread at ffffffffa76a7fd3
>>  #8 [ffffbfe30d68ff50] ret_from_fork at ffffffffa80001ff
>>
>>
>>
>>  struct -x mutex.owner.counter rtnl_mutex
>>   owner.counter = 0xffff9a1072b50001
>>
>> 0xffff9a1072b50001 & (~0x07) = 0xffff9a1072b50000
>>
>> This points back to PID 8 / CPU 24. It is working on cleanup_net, and a part
>> of cleanup net involves calling ops_exit_list, and as part of that it calls
>> default_device_exit_batch. default_device_exit_batch takes the rtnl lock before
>> calling into unregister_netdevice_many, and rollback_registered_many.
>> rollback_registered_many calls flush_all_backlogs. This will never complete
>> because it is holding the rtnl lock, and PID 1369493 / CPU 58 is waiting
>> for rtnl_lock.
> 
> But PID 1369493 is waiting on a mutex, thus properly yielding the cpu.
> (schedule() is clearly shown)
> 
> This should not prevent other threads
> from making progress so that flush_all_backlogs() completes eventually.
> 
> flush_all_backlogs() does not care of how many threads are currently blocked
> because they can not grab rtnl while flush_all_backlogs() is running.
> 
>>
>> If relevant, the workqueue stalls themselves look something like:
>> BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=0 stuck for 3720s!
>> BUG: workqueue lockup - pool cpus=70 node=0 flags=0x0 nice=-20 stuck for 3719s!
>> Showing busy workqueues and worker pools:
>> workqueue events: flags=0x0
>>   pwq 32: cpus=16 node=0 flags=0x0 nice=0 active=2/256
>>     in-flight: 1274779:slab_caches_to_rcu_destroy_workfn slab_caches_to_rcu_destroy_workfn
>> workqueue events_highpri: flags=0x10
>>   pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
>>     pending: flush_backlog BAR(8)
>> workqueue events_power_efficient: flags=0x82
>>   pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
>>     in-flight: 1396446:check_lifetime
>> workqueue mm_percpu_wq: flags=0x8
>>   pwq 140: cpus=70 node=0 flags=0x0 nice=0 active=1/256
>>     pending: vmstat_update
>> workqueue netns: flags=0xe000a
>>   pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
>>     in-flight: 8:cleanup_net
>>     delayed: cleanup_net
>> workqueue writeback: flags=0x4e
>>   pwq 193: cpus=0-23,48-71 node=0 flags=0x4 nice=0 active=1/256
>>     in-flight: 1334335:wb_workfn
>> workqueue kblockd: flags=0x18
>>   pwq 141: cpus=70 node=0 flags=0x0 nice=-20 active=1/256
>>     pending: blk_mq_run_work_fn
>> workqueue ipv6_addrconf: flags=0x40008
>>   pwq 116: cpus=58 node=0 flags=0x0 nice=0 active=1/1
>>     in-flight: 1369493:addrconf_verify_work
>> workqueue ena: flags=0xe000a
>>   pwq 192: cpus=0-95 flags=0x4 nice=0 active=1/1
>>     in-flight: 7505:ena_fw_reset_device [ena]
>>

Can you test the following :

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cb493e15959c4d1bb68cf30f4099a8daa785bb84..bcc7ce03f13881415f64c7329559c7ed1e6321f3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4410,8 +4410,6 @@ static void addrconf_verify_rtnl(void)
        now = jiffies;
        next = round_jiffies_up(now + ADDR_CHECK_FREQUENCY);
 
-       cancel_delayed_work(&addr_chk_work);
-
        for (i = 0; i < IN6_ADDR_HSIZE; i++) {
 restart:
                hlist_for_each_entry_rcu_bh(ifp, &inet6_addr_lst[i], addr_lst) {
