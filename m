Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36757233797
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgG3RVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:21:11 -0400
Received: from mail.as201155.net ([185.84.6.188]:31288 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgG3RVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 13:21:11 -0400
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:54510 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1k1CEs-0005yp-2X; Thu, 30 Jul 2020 19:21:06 +0200
X-CTCH-RefID: str=0001.0A782F17.5F230182.005D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=g26FjbxVUABEUOyEi0P4Kxobh0qYUIuASKlvLhVTGlo=;
        b=FIoDxjeu4HhFNmRkS6YSO9Lr/3SjEut4Uv24zVYJ7fy3GI/PxgYEpPa5BAKyF95pMl4ml0OOsxHNUsFauca7Uj5ai50eGiv7gWMuCkDEr78H2boaanrbpyj3jT4O7XFgCfdUXvQ9DvjfU3HzydIXWofK36w2zbFl77E9kJWRRHk=;
Subject: Re: [PATCH] net: add support for threaded NAPI polling
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, netdev@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>
References: <20200729165058.83984-1-nbd@nbd.name>
 <866c7d83-868d-120e-f535-926c4cc9e615@gmail.com>
 <5aa0c26f-d3f1-b33f-a598-e4727d6f10f0@dd-wrt.com>
 <5eb18175-b5b9-6e4e-2541-7533e21ccb21@gmail.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <e65f8b84-e6f2-7aa0-4920-db44c63b5efc@dd-wrt.com>
Date:   Thu, 30 Jul 2020 19:21:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <5eb18175-b5b9-6e4e-2541-7533e21ccb21@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2a01:7700:8040:300:315c:d267:8dd:d539]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1k1CEs-00062t-GF; Thu, 30 Jul 2020 19:21:06 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 30.07.2020 um 18:08 schrieb Eric Dumazet:
>
> On 7/30/20 7:30 AM, Sebastian Gottschall wrote:
>> Am 29.07.2020 um 19:44 schrieb Eric Dumazet:
>>> On 7/29/20 9:50 AM, Felix Fietkau wrote:
>>>> For some drivers (especially 802.11 drivers), doing a lot of work in the NAPI
>>>> poll function does not perform well. Since NAPI poll is bound to the CPU it
>>>> was scheduled from, we can easily end up with a few very busy CPUs spending
>>>> most of their time in softirq/ksoftirqd and some idle ones.
>>>>
>>>> Introduce threaded NAPI for such drivers based on a workqueue. The API is the
>>>> same except for using netif_threaded_napi_add instead of netif_napi_add.
>>>>
>>>> In my tests with mt76 on MT7621 using threaded NAPI + a thread for tx scheduling
>>>> improves LAN->WLAN bridging throughput by 10-50%. Throughput without threaded
>>>> NAPI is wildly inconsistent, depending on the CPU that runs the tx scheduling
>>>> thread.
>>>>
>>>> With threaded NAPI, throughput seems stable and consistent (and higher than
>>>> the best results I got without it).
>>>>
>>>> Based on a patch by Hillf Danton
>>>>
>>>> Cc: Hillf Danton <hdanton@sina.com>
>>>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>>>> ---
>>>> Changes since RFC v2:
>>>> - fix unused but set variable reported by kbuild test robot
>>>>
>>>> Changes since RFC:
>>>> - disable softirq around threaded poll functions
>>>> - reuse most parts of napi_poll()
>>>> - fix re-schedule condition
>>>>
>>>>    include/linux/netdevice.h |  23 ++++++
>>>>    net/core/dev.c            | 162 ++++++++++++++++++++++++++------------
>>>>    2 files changed, 133 insertions(+), 52 deletions(-)
>>>>
>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>> index ac2cd3f49aba..3a39211c7598 100644
>>>> --- a/include/linux/netdevice.h
>>>> +++ b/include/linux/netdevice.h
>>>> @@ -347,6 +347,7 @@ struct napi_struct {
>>>>        struct list_head    dev_list;
>>>>        struct hlist_node    napi_hash_node;
>>>>        unsigned int        napi_id;
>>>> +    struct work_struct    work;
>>>>    };
>>>>      enum {
>>>> @@ -357,6 +358,7 @@ enum {
>>>>        NAPI_STATE_HASHED,    /* In NAPI hash (busy polling possible) */
>>>>        NAPI_STATE_NO_BUSY_POLL,/* Do not add in napi_hash, no busy polling */
>>>>        NAPI_STATE_IN_BUSY_POLL,/* sk_busy_loop() owns this NAPI */
>>>> +    NAPI_STATE_THREADED,    /* Use threaded NAPI */
>>>>    };
>>>>      enum {
>>>> @@ -367,6 +369,7 @@ enum {
>>>>        NAPIF_STATE_HASHED     = BIT(NAPI_STATE_HASHED),
>>>>        NAPIF_STATE_NO_BUSY_POLL = BIT(NAPI_STATE_NO_BUSY_POLL),
>>>>        NAPIF_STATE_IN_BUSY_POLL = BIT(NAPI_STATE_IN_BUSY_POLL),
>>>> +    NAPIF_STATE_THREADED     = BIT(NAPI_STATE_THREADED),
>>>>    };
>>>>      enum gro_result {
>>>> @@ -2315,6 +2318,26 @@ static inline void *netdev_priv(const struct net_device *dev)
>>>>    void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>>>>                int (*poll)(struct napi_struct *, int), int weight);
>>>>    +/**
>>>> + *    netif_threaded_napi_add - initialize a NAPI context
>>>> + *    @dev:  network device
>>>> + *    @napi: NAPI context
>>>> + *    @poll: polling function
>>>> + *    @weight: default weight
>>>> + *
>>>> + * This variant of netif_napi_add() should be used from drivers using NAPI
>>>> + * with CPU intensive poll functions.
>>>> + * This will schedule polling from a high priority workqueue that
>>>> + */
>>>> +static inline void netif_threaded_napi_add(struct net_device *dev,
>>>> +                       struct napi_struct *napi,
>>>> +                       int (*poll)(struct napi_struct *, int),
>>>> +                       int weight)
>>>> +{
>>>> +    set_bit(NAPI_STATE_THREADED, &napi->state);
>>>> +    netif_napi_add(dev, napi, poll, weight);
>>>> +}
>>>> +
>>>>    /**
>>>>     *    netif_tx_napi_add - initialize a NAPI context
>>>>     *    @dev:  network device
>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>> index 19f1abc26fcd..11b027f3a2b9 100644
>>>> --- a/net/core/dev.c
>>>> +++ b/net/core/dev.c
>>>> @@ -158,6 +158,7 @@ static DEFINE_SPINLOCK(offload_lock);
>>>>    struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
>>>>    struct list_head ptype_all __read_mostly;    /* Taps */
>>>>    static struct list_head offload_base __read_mostly;
>>>> +static struct workqueue_struct *napi_workq __read_mostly;
>>>>      static int netif_rx_internal(struct sk_buff *skb);
>>>>    static int call_netdevice_notifiers_info(unsigned long val,
>>>> @@ -6286,6 +6287,11 @@ void __napi_schedule(struct napi_struct *n)
>>>>    {
>>>>        unsigned long flags;
>>>>    +    if (test_bit(NAPI_STATE_THREADED, &n->state)) {
>>>> +        queue_work(napi_workq, &n->work);
>>>> +        return;
>>>> +    }
>>>> +
>>> Where is the corresponding cancel_work_sync() or flush_work() at device dismantle ?
>>>
>>> Just hoping the thread will eventually run seems optimistic to me.
>>>
>>>
>>> Quite frankly, I do believe this STATE_THREADED status should be a generic NAPI attribute
>>> that can be changed dynamically, at admin request, instead of having to change/recompile
>>> a driver.
>> thats not that easy. wifi devices do use dummy netdev devices. they are not visible to sysfs and other administrative options.
>> so changing it would just be possible if a special mac80211 based control would be implemented for these drivers.
>> for standard netdev devices it isnt a big thing to implement a administrative control by sysfs (if you are talking about such a feature)
> We do not want to add code in fast path only for one device. We need something truly generic.
>
> I am not saying only the admin can chose, it is fine if a driver does not give the choice
> and will simply call netif_threaded_napi_add()
what could make sense if the feature can be disabled / enabled, but it 
will only affect drivers using the netif_threaded_napi_add call, but it 
should not affect drivers
using the old api in any way since not all drivers will work with this 
feature.
