Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9BB23C0DA
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgHDUlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727111AbgHDUlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:41:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968ABC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:41:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so21333239pfm.4
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 13:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wPAdD8vklsUm86j2FfKDxp6DS9jq05P29cScR31qd2w=;
        b=palkN5unkO+E53jfruOVAB+mXYB6NnSydn8xHDgzUVdqWoyG1L9RagibkV73Syr1Q+
         ZRkRsPxud8BpirVAFSQuumAOcJ8oY+7BDOLFRjDY8jwULfV7u81kj1uYq3Wz1wYw3aIt
         EJ6rvXByCO7ic3fn3gDvpb7rPaWwDviPmvDVY7JzLdjTA1iUM4Pzt83eVe/AEQUOGt7O
         bA/SEeubQyi93/hIf6axBwBN9ucrW4g9m7x53JGjF3s1xmpn54Xbr4VS6dyrbDys4Dfy
         aMgIK1xR2dHj4Hhyl2oY0jSxSivFdoxthjY9FBaCxX1+nk99d7lzdAIiCrMcoxai4ZPH
         +Www==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wPAdD8vklsUm86j2FfKDxp6DS9jq05P29cScR31qd2w=;
        b=qYd0NPnYx9mejQWpyJcOduVKG+RIL7UI/nDehY+LVIMefFIWCXJOHDv+IgAttFpbLb
         5c5maP8J6pMXYVCuDcA7cZ3VtTzJ+PmJ1Z9e5naOWKLSGdUhmtnI3hnatNlBfWEFD4yM
         o/wU/K9zMlzt6djtLLXzVHtjrM1Ky4+6X7J4GgNDjm/us7F26eTUFeECpjBkYr1H0D3D
         67sLqoRPCXQDTCAh/GDlSfi9URGkKZtsqrB0C0TRUIZa+7CK93TcS3b4+rpgG5Mvs/aG
         aaVp0Rm4WSySe8/q3k75z0MKvhgU4lK6m/uAfJXKnBzgEUfN8N6DqR0z5cEoB3KVi/A1
         iVZQ==
X-Gm-Message-State: AOAM531DIEnytMpJvol5YJoPSmPzt+atHhIgHQqE+1Eq6Ev4wjT5v4gN
        9aYBu6rc6XtgCH5t4slM5ZQ1o/tY
X-Google-Smtp-Source: ABdhPJxjWw9aFQhaWtf2wClgujZHSVemqDBTmYQf9G+hSeDyGIzW/pYc1Y/tQmgCVPCbuNGNqp6xzQ==
X-Received: by 2002:aa7:9344:: with SMTP id 4mr192668pfn.30.1596573682051;
        Tue, 04 Aug 2020 13:41:22 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id r15sm15752610pfq.189.2020.08.04.13.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:41:21 -0700 (PDT)
Subject: Re: [PATCH] net: add support for threaded NAPI polling
To:     Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
References: <20200729165058.83984-1-nbd@nbd.name>
 <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
 <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
 <5eb18175-b5b9-6e4e-2541-7533e21ccb21@gmail.com>
 <e65f8b84-e6f2-7aa0-4920-db44c63b5efc@dd-wrt.com>
 <b88836ef-7db4-9cd5-a36f-e20855de0304@gmail.com>
 <f03b59e7-54ac-0db2-afd2-ab415d0f15b0@dd-wrt.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2408a542-c674-63d6-f277-14da7b35c77b@gmail.com>
Date:   Tue, 4 Aug 2020 13:41:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <f03b59e7-54ac-0db2-afd2-ab415d0f15b0@dd-wrt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/20 7:27 AM, Sebastian Gottschall wrote:
> 
> Am 31.07.2020 um 18:36 schrieb Eric Dumazet:
>>
>> On 7/30/20 10:21 AM, Sebastian Gottschall wrote:
>>> Am 30.07.2020 um 18:08 schrieb Eric Dumazet:
>>>> On 7/30/20 7:30 AM, Sebastian Gottschall wrote:
>>>>> Am 29.07.2020 um 19:44 schrieb Eric Dumazet:
>>>>>> On 7/29/20 9:50 AM, Felix Fietkau wrote:
>>>>>>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>>>>>>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>>>>>>> was scheduled from, we can easily end up with a few very busy CPUs spending
>>>>>>> most of their time in softirq/ksoftirqd and some idle ones.
>>>>>>>
>>>>>>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>>>>>>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>>>>>>
>>>>>>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>>>>>>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>>>>>>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>>>>>>> thread.
>>>>>>>
>>>>>>> With threaded NAPI, throughput seems stable and consistent (and higher than
>>>>>>> the best results I got without it).
>>>>>>>
>>>>>>> Based on a patch by Hillf Danton
>>>>>>>
>>>>>>> Cc: Hillf Danton <hdanton@sina.com>
>>>>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>>>>> ---
>>>>>>> Changes since RFC v2:
>>>>>>> - fix unused but set variable reported by kbuild test robot
>>>>>>>
>>>>>>> Changes since RFC:
>>>>>>> - disable softirq around threaded poll functions
>>>>>>> - reuse most parts of napi_poll()
>>>>>>> - fix re-schedule condition
>>>>>>>
>>>>>>>     include/linux/netdevice.h |  23 ++++++
>>>>>>>     net/core/dev.c            | 162 ++++++++++++++++++++++++++------------
>>>>>>>     2 files changed, 133 insertions(+), 52 deletions(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>>>> index ac2cd3f49aba..3a39211c7598 100644
>>>>>>> --- a/include/linux/netdevice.h
>>>>>>> +++ b/include/linux/netdevice.h
>>>>>>> @@ -347,6 +347,7 @@ struct napi_struct {
>>>>>>>         struct list_head    dev_list;
>>>>>>>         struct hlist_node    napi_hash_node;
>>>>>>>         unsigned int        napi_id;
>>>>>>> +    struct work_struct    work;
>>>>>>>     };
>>>>>>>       enum {
>>>>>>> @@ -357,6 +358,7 @@ enum {
>>>>>>>         NAPI_STATE_HASHED,    /* In NAPI hash (busy polling possible) */
>>>>>>>         NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>>>>>>>         NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
>>>>>>> +    NAPI_STATE_THREADED,    /* Use threaded NAPI */
>>>>>>>     };
>>>>>>>       enum {
>>>>>>> @@ -367,6 +369,7 @@ enum {
>>>>>>>         NAPIF_STATE_HASHED     = BIT(NAPI_STATE_HASHED),
>>>>>>>         NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>>>>>>>         NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
>>>>>>> +    NAPIF_STATE_THREADED     = BIT(NAPI_STATE_THREADED),
>>>>>>>     };
>>>>>>>       enum gro_result {
>>>>>>> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>>>>>>>     void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>>>>>>>                 int (*poll)(struct napi_struct *, int), int weight);
>>>>>>>     +/**
>>>>>>> + *    netif_threaded_napi_add - initialize a NAPI context
>>>>>>> + *    @dev:  network device
>>>>>>> + *    @napi: NAPI context
>>>>>>> + *    @poll: polling function
>>>>>>> + *    @weight: default weight
>>>>>>> + *
>>>>>>> + * This variant of netif_napi_add() should be used from drivers using NAPI
>>>>>>> + * with CPU intensive poll functions.
>>>>>>> + * This will schedule polling from a high priority workqueue that
>>>>>>> + */
>>>>>>> +static inline void netif_threaded_napi_add(struct net_device *dev,
>>>>>>> +                       struct napi_struct *napi,
>>>>>>> +                       int (*poll)(struct napi_struct *, int),
>>>>>>> +                       int weight)
>>>>>>> +{
>>>>>>> +    set_bit(NAPI_STATE_THREADED, &napi->state);
>>>>>>> +    netif_napi_add(dev, napi, poll, weight);
>>>>>>> +}
>>>>>>> +
>>>>>>>     /**
>>>>>>>      *    netif_tx_napi_add - initialize a NAPI context
>>>>>>>      *    @dev:  network device
>>>>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>>>>> index 19f1abc26fcd..11b027f3a2b9 100644
>>>>>>> --- a/net/core/dev.c
>>>>>>> +++ b/net/core/dev.c
>>>>>>> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>>>>>>>     struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>>>>>>>     struct list_head ptype_all __read_mostly;    /* Taps */
>>>>>>>     static struct list_head offload_base __read_mostly;
>>>>>>> +static struct workqueue_struct *napi_workq __read_mostly;
>>>>>>>       static int netif_rx_internal(struct sk_buff *skb);
>>>>>>>     static int call_netdevice_notifiers_info(unsigned long val,
>>>>>>> @@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
>>>>>>>     {
>>>>>>>         unsigned long flags;
>>>>>>>     +    if (test_bit(NAPI_STATE_THREADED, &n->state)) {
>>>>>>> +        queue_work(napi_workq, &n->work);
>>>>>>> +        return;
>>>>>>> +    }
>>>>>>> +
>>>>>> Where is the corresponding cancel_work_sync() or flush_work() at device dismantle ?
>>>>>>
>>>>>> Just hoping the thread will eventually run seems optimistic to me.
>>>>>>
>>>>>>
>>>>>> Quite frankly, I do believe this STATE_THREADED status should be a generic NAPI attribute
>>>>>> that can be changed dynamically, at admin request, instead of having to change/recompile
>>>>>> a driver.
>>>>> thats not that easy. wifi devices do use dummy netdev devices. they are not visible to sysfs and other administrative options.
>>>>> so changing it would just be possible if a special mac80211 based control would be implemented for these drivers.
>>>>> for standard netdev devices it isnt a big thing to implement a administrative control by sysfs (if you are talking about such a feature)
>>>> We do not want to add code in fast path only for one device. We need something truly generic.
>>>>
>>>> I am not saying only the admin can chose, it is fine if a driver does not give the choice
>>>> and will simply call netif_threaded_napi_add()
>>> what could make sense if the feature can be disabled / enabled, but it will only affect drivers using the netif_threaded_napi_add call, but it should not affect drivers
>>> using the old api in any way since not all drivers will work with this feature.
>>
>> If we provide something in core NAPI stack, we want to make sure we can test/use it with other drivers.
>>
>> ethtool, or a /sys/class/net/ethXXX entry could be used.
> but this doesnt work for wifi drivers. since wifi drivers are using dummy netdev devices. we are running in circles here
> i mean a sane way could be also that dummy netdev devices are present in sysfs too which is not the case right now.
> so changing the api, so the driver is forced to set sane virtual dummy netdev name (like the driver name for instance). so it can be accessed by sysfs.
>>
>> The argument about not affecting other drivers is misleading, since the patch adds another conditional test in
>> standard NAPI layer.
>>
>> Lets keep NAPI generic please.
>>
>> Lets make sure syzbot will find bugs without having to attach a specific mac80211 hardware.
> the patch is not mac80211 specific. i  tested it already with network drivers. it is generic.

Not really generic as you have to compile a new driver/kernel, since a driver
will either call netif_threaded_napi_add() or netif_napi_add().

Just to be extra clear : We have reasons to like the proposal, and want to use it,
without manual changes in NAPI drivers.


>>
>> Another concern I have with this patch is that we no longer can contain NIC processing is done
>> on a selected set of cpus (as commanded in /proc/irq/XXX/smp_affinity).
>> Or can we ?
> i had this discussion already with felix in a phonecall last week. kthread vs. workq. his oppinion is that workq works more effective than kthread's
> since kthreads required application support for good balancing like irqbalance. personally i have no real oppinion here. the good point on kthreads is
> that i'm able to track the system load per thread with simple process watching. and its possible to force the thread on a specific cpuset.

In either cases we want to be able tune things from scripts without requesting human looking at a process list :)

Hint : patch does not use WQ_SYSFS





