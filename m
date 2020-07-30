Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B465233655
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgG3QI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgG3QI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:08:58 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA73DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 09:08:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so4600550pjb.4
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 09:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZZhP2kARf9SKWsQw0B7zVeljnUj9nw/aCP+DN53YNZc=;
        b=OZ/8S0u/Xq+Vu60JSMLIZC0vM52aE80drZI7hOhvPSQYhvWAyO+2FGCvGPjypudVU5
         pnnpn+su7J7ZKasNO7zeHGByleEN0evc7kMkSOLL0iY4JSU76QeiGCecFOYE6gwZpf4r
         CDFybG6xHiRbBofC1U73NjYyZJ4gONH7uf5ZpDtHa9CgzwVJbF4zEOV0aWsDPnqA/CRe
         oISqYzbqA/j56vXINr1vBGC2jReIq2hxsON67YMUfqm1DerCIOEXEX2JbN7IJ8oXdMwC
         CTCLeazRRiWF7gg8AS08WZs4IWbPWOT3PD86PzN25HsOA72j5WVh8JYLkW77hHTAPx7R
         Q6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZZhP2kARf9SKWsQw0B7zVeljnUj9nw/aCP+DN53YNZc=;
        b=I7OMOZFYtzpDkJgBlMPDxSCewquea0tyEJgZ/uV6HtWtReA+h41u3+A2mmrvawEChg
         8wxvm4HhtNwFoATDHVGmV8MToSlTt+wnpwxj+hUydIF8CoUFrzXXxOLNWj5dGipOLnsD
         1XqPQlu5MDYLVT8zp2Cd2D8mqQfHksQEvm2sJLD2w7UwFvM3snoi8EQLKe5r7rWGxjUe
         h8FoIJ7t0wGKOld1OdRHsvIQnen0BlAjXJrzukt52knbIEzOdgTt7xjINgthj7KbZ/HH
         byDA0O0OdOacZs0hASGuqbevirpHWPKrZeqRh45Z+/3OCwplXmyro6lBGWJB8nQ4gMhY
         3wZg==
X-Gm-Message-State: AOAM530GTDVtzDnio41JFJnzqYvU1mh/GD7ZtkfJEn1XLIqqwN1IsqC9
        x4hyhZ5cYqmMQePqSNhSZ61bxcYG
X-Google-Smtp-Source: ABdhPJzyrVVVdOUZ8OkVE+MOMIyf3Ab8ytTEEG5EB0iAce4t+hiUQnjHwxShEh9OuWtQvNYxVJanGg==
X-Received: by 2002:a65:620e:: with SMTP id d14mr34809599pgv.360.1596125338313;
        Thu, 30 Jul 2020 09:08:58 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d13sm6726030pfq.118.2020.07.30.09.08.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 09:08:57 -0700 (PDT)
Subject: Re: [PATCH] net: add support for threaded NAPI polling
To:     Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200729165058.83984-1-nbd@nbd.name>
 <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
 <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5eb18175-b5b9-6e4e-2541-7533e21ccb21@gmail.com>
Date:   Thu, 30 Jul 2020 09:08:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/20 7:30 AM, Sebastian Gottschall wrote:
> 
> Am 29.07.2020 um 19:44 schrieb Eric Dumazet:
>>
>> On 7/29/20 9:50 AM, Felix Fietkau wrote:
>>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>>> was scheduled from, we can easily end up with a few very busy CPUs spending
>>> most of their time in softirq/ksoftirqd and some idle ones.
>>>
>>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>>
>>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>>> thread.
>>>
>>> With threaded NAPI, throughput seems stable and consistent (and higher than
>>> the best results I got without it).
>>>
>>> Based on a patch by Hillf Danton
>>>
>>> Cc: Hillf Danton <hdanton@sina.com>
>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>> ---
>>> Changes since RFC v2:
>>> - fix unused but set variable reported by kbuild test robot
>>>
>>> Changes since RFC:
>>> - disable softirq around threaded poll functions
>>> - reuse most parts of napi_poll()
>>> - fix re-schedule condition
>>>
>>>   include/linux/netdevice.h |  23 ++++++
>>>   net/core/dev.c            | 162 ++++++++++++++++++++++++++------------
>>>   2 files changed, 133 insertions(+), 52 deletions(-)
>>>
>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>> index ac2cd3f49aba..3a39211c7598 100644
>>> --- a/include/linux/netdevice.h
>>> +++ b/include/linux/netdevice.h
>>> @@ -347,6 +347,7 @@ struct napi_struct {
>>>       struct list_head    dev_list;
>>>       struct hlist_node    napi_hash_node;
>>>       unsigned int        napi_id;
>>> +    struct work_struct    work;
>>>   };
>>>     enum {
>>> @@ -357,6 +358,7 @@ enum {
>>>       NAPI_STATE_HASHED,    /* In NAPI hash (busy polling possible) */
>>>       NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>>>       NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
>>> +    NAPI_STATE_THREADED,    /* Use threaded NAPI */
>>>   };
>>>     enum {
>>> @@ -367,6 +369,7 @@ enum {
>>>       NAPIF_STATE_HASHED     = BIT(NAPI_STATE_HASHED),
>>>       NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>>>       NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
>>> +    NAPIF_STATE_THREADED     = BIT(NAPI_STATE_THREADED),
>>>   };
>>>     enum gro_result {
>>> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>>>   void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>>>               int (*poll)(struct napi_struct *, int), int weight);
>>>   +/**
>>> + *    netif_threaded_napi_add - initialize a NAPI context
>>> + *    @dev:  network device
>>> + *    @napi: NAPI context
>>> + *    @poll: polling function
>>> + *    @weight: default weight
>>> + *
>>> + * This variant of netif_napi_add() should be used from drivers using NAPI
>>> + * with CPU intensive poll functions.
>>> + * This will schedule polling from a high priority workqueue that
>>> + */
>>> +static inline void netif_threaded_napi_add(struct net_device *dev,
>>> +                       struct napi_struct *napi,
>>> +                       int (*poll)(struct napi_struct *, int),
>>> +                       int weight)
>>> +{
>>> +    set_bit(NAPI_STATE_THREADED, &napi->state);
>>> +    netif_napi_add(dev, napi, poll, weight);
>>> +}
>>> +
>>>   /**
>>>    *    netif_tx_napi_add - initialize a NAPI context
>>>    *    @dev:  network device
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index 19f1abc26fcd..11b027f3a2b9 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>>>   struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>>>   struct list_head ptype_all __read_mostly;    /* Taps */
>>>   static struct list_head offload_base __read_mostly;
>>> +static struct workqueue_struct *napi_workq __read_mostly;
>>>     static int netif_rx_internal(struct sk_buff *skb);
>>>   static int call_netdevice_notifiers_info(unsigned long val,
>>> @@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
>>>   {
>>>       unsigned long flags;
>>>   +    if (test_bit(NAPI_STATE_THREADED, &n->state)) {
>>> +        queue_work(napi_workq, &n->work);
>>> +        return;
>>> +    }
>>> +
>>
>> Where is the corresponding cancel_work_sync() or flush_work() at device dismantle ?
>>
>> Just hoping the thread will eventually run seems optimistic to me.
>>
>>
>> Quite frankly, I do believe this STATE_THREADED status should be a generic NAPI attribute
>> that can be changed dynamically, at admin request, instead of having to change/recompile
>> a driver.
> thats not that easy. wifi devices do use dummy netdev devices. they are not visible to sysfs and other administrative options.
> so changing it would just be possible if a special mac80211 based control would be implemented for these drivers.
> for standard netdev devices it isnt a big thing to implement a administrative control by sysfs (if you are talking about such a feature)

We do not want to add code in fast path only for one device. We need something truly generic.

I am not saying only the admin can chose, it is fine if a driver does not give the choice
and will simply call netif_threaded_napi_add()

