Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD6422D6CF
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 12:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGYKiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 06:38:10 -0400
Received: from mail.as201155.net ([185.84.6.188]:41766 "EHLO mail.as201155.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgGYKiJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 06:38:09 -0400
X-Greylist: delayed 127898 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2020 06:38:07 EDT
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:48828 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jzHZ5-0003nz-2W; Sat, 25 Jul 2020 12:38:03 +0200
X-CTCH-RefID: str=0001.0A782F21.5F1C0B8B.0051,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=jq3dlc+cdk2c+17CURe7NgYwWb2Z4/X0bonnPMZqnwU=;
        b=s3f/EwNj9aECmwSa4lZEFSQWpxhwGjBE+CtfnLMUCESNry3Xk03e2WYds8iESztGNVoXOHof93R0U7M4zuFtt512wYXzfolDjd66dYrzxYuFOJx1npOBkEEkI+x+Zea49TfKrAYNPG4lI0EdvzEGYLQ8uCL4J2zTozrXjVgDSEs=;
Subject: Re: [RFC 0/7] Add support to process rx packets in thread
To:     Hillf Danton <hdanton@sina.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Lunn <andrew@lunn.ch>,
        Rakesh Pillai <pillair@codeaurora.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Markus Elfring <Markus.Elfring@web.de>,
        "evgreen@chromium.org" <evgreen@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <20200721172514.GT1339445@lunn.ch> <20200725081633.7432-1-hdanton@sina.com>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <8359a849-2b8a-c842-a501-c6cb6966e345@dd-wrt.com>
Date:   Sat, 25 Jul 2020 12:38:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <20200725081633.7432-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2a01:7700:8040:4d00:3da5:f3e1:ed1:597]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jzHZ5-0002yT-Bk; Sat, 25 Jul 2020 12:38:03 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

you may consider this

https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1142611.html 
<https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1142611.html>

years ago someone already wanted to bring this feature upstream, but it 
was denied. i already tested this patch the last 2 days and it worked so 
far (with some little modifications)
so such a solution existed already and may be considered here

Sebastian


someone

Am 25.07.2020 um 10:16 schrieb Hillf Danton:
> On Wed, 22 Jul 2020 09:12:42 +0000 David Laight wrote:
>>> On 21 July 2020 18:25 Andrew Lunn wrote:
>>>
>>> On Tue, Jul 21, 2020 at 10:44:19PM +0530, Rakesh Pillai wrote:
>>>> NAPI gets scheduled on the CPU core which got the
>>>> interrupt. The linux scheduler cannot move it to a
>>>> different core, even if the CPU on which NAPI is running
>>>> is heavily loaded. This can lead to degraded wifi
>>>> performance when running traffic at peak data rates.
>>>>
>>>> A thread on the other hand can be moved to different
>>>> CPU cores, if the one on which its running is heavily
>>>> loaded. During high incoming data traffic, this gives
>>>> better performance, since the thread can be moved to a
>>>> less loaded or sometimes even a more powerful CPU core
>>>> to account for the required CPU performance in order
>>>> to process the incoming packets.
>>>>
>>>> This patch series adds the support to use a high priority
>>>> thread to process the incoming packets, as opposed to
>>>> everything being done in NAPI context.
>>> I don't see why this problem is limited to the ath10k driver. I expect
>>> it applies to all drivers using NAPI. So shouldn't you be solving this
>>> in the NAPI core? Allow a driver to request the NAPI core uses a
>>> thread?
>> It's not just NAPI the problem is with the softint processing.
>> I suspect a lot of systems would work better if it ran as
>> a (highish priority) kernel thread.
> Hi folks
>
> Below is a minimunm poc implementation I can imagine on top of workqueue
> to make napi threaded. Thoughts are appreciated.
>
>> I've had to remove the main locks from a multi-threaded application
>> and replace them with atomic counters.
>> Consider what happens when the threads remove items from a shared
>> work list.
>> The code looks like:
>> 	mutex_enter();
>> 	remove_item_from_list();
>> 	mutex_exit().
>> The mutex is only held for a few instructions, so while you'd expect
>> the cache line to be 'hot' you wouldn't get real contention.
>> However the following scenarios happen:
>> 1) An ethernet interrupt happens while the mutex is held.
>>     This stops the other threads until all the softint processing
>>     has finished.
>> 2) An ethernet interrupt (and softint) runs on a thread that is
>>     waiting for the mutex.
>>     (Or on the cpu that the thread's processor affinity ties it to.)
>>     In this case the 'fair' (ticket) mutex code won't let any other
>>     thread acquire the mutex.
>>     So again everything stops until the softints all complete.
>>
>> The second one is also a problem when trying to wake up all
>> the threads (eg after adding a lot of items to the list).
>> The ticket locks force them to wake in order, but
>> sometimes the 'thundering herd' would work better.
>>
>> IIRC this is actually worse for processes running under the RT
>> scheduler (without CONFIG_PREEMPT) because the they are almost
>> always scheduled on the same cpu they ran on last.
>> If it is busy, but cannot be pre-empted, they are not moved
>> to an idle cpu.
>>     
>> To confound things there is a very broken workaround for broken
>> hardware in the driver for the e1000 interface on (at least)
>> Ivy Bridge cpu that can cause the driver to spin for a very
>> long time (IIRC milliseconds) whenever it has to write to a
>> MAC register (ie on every transmit setup).
>>
>> 	David
>>
>> -
>> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
>> Registration No: 1397386 (Wales)
> To make napi threaded, if either irq or softirq thread is entirely ruled
> out, add napi::work that will be queued on a highpri workqueue. It is
> actually a unbound one to facilitate scheduler to catter napi loads on to
> idle CPU cores. What users need to do with the threaded napi
> is s/netif_napi_add/netif_threaded_napi_add/ and no more.
>
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -338,6 +338,9 @@ struct napi_struct {
>   	struct list_head	dev_list;
>   	struct hlist_node	napi_hash_node;
>   	unsigned int		napi_id;
> +#ifdef CONFIG_THREADED_NAPI
> +	struct work_struct	work;
> +#endif
>   };
>   
>   enum {
> @@ -2234,6 +2237,19 @@ static inline void *netdev_priv(const st
>   void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>   		    int (*poll)(struct napi_struct *, int), int weight);
>   
> +#ifdef CONFIG_THREADED_NAPI
> +void netif_threaded_napi_add(struct net_device *dev, struct napi_struct *napi,
> +		    int (*poll)(struct napi_struct *, int), int weight);
> +#else
> +static inline void netif_threaded_napi_add(struct net_device *dev,
> +					struct napi_struct *napi,
> +					int (*poll)(struct napi_struct *, int),
> +					int weight)
> +{
> +	netif_napi_add(dev, napi, poll, weight);
> +}
> +#endif
> +
>   /**
>    *	netif_tx_napi_add - initialize a NAPI context
>    *	@dev:  network device
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6277,6 +6277,61 @@ static int process_backlog(struct napi_s
>   	return work;
>   }
>   
> +#ifdef CONFIG_THREADED_NAPI
> +/* unbound highpri workqueue for threaded napi */
> +static struct workqueue_struct *napi_workq;
> +
> +static void napi_workfn(struct work_struct *work)
> +{
> +	struct napi_struct *n = container_of(work, struct napi_struct, work);
> +
> +	for (;;) {
> +		if (!test_bit(NAPI_STATE_SCHED, &n->state))
> +			return;
> +
> +		if (n->poll(n, n->weight) < n->weight)
> +			return;
> +
> +		if (need_resched()) {
> +			/*
> +			 * have to pay for the latency of task switch even if
> +			 * napi is scheduled
> +			 */
> +			if (test_bit(NAPI_STATE_SCHED, &n->state))
> +				queue_work(napi_workq, work);
> +			return;
> +		}
> +	}
> +}
> +
> +void netif_threaded_napi_add(struct net_device *dev,
> +				struct napi_struct *napi,
> +				int (*poll)(struct napi_struct *, int),
> +				int weight)
> +{
> +	netif_napi_add(dev, napi, poll, weight);
> +	INIT_WORK(&napi->work, napi_workfn);
> +}
> +
> +static inline bool is_threaded_napi(struct napi_struct *n)
> +{
> +	return n->work.func == napi_workfn;
> +}
> +
> +static inline void threaded_napi_sched(struct napi_struct *n)
> +{
> +	if (is_threaded_napi(n))
> +		queue_work(napi_workq, &n->work);
> +	else
> +		____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +}
> +#else
> +static inline void threaded_napi_sched(struct napi_struct *n)
> +{
> +	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +}
> +#endif
> +
>   /**
>    * __napi_schedule - schedule for receive
>    * @n: entry to schedule
> @@ -6289,7 +6344,7 @@ void __napi_schedule(struct napi_struct
>   	unsigned long flags;
>   
>   	local_irq_save(flags);
> -	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	threaded_napi_sched(n);
>   	local_irq_restore(flags);
>   }
>   EXPORT_SYMBOL(__napi_schedule);
> @@ -6335,7 +6390,7 @@ EXPORT_SYMBOL(napi_schedule_prep);
>    */
>   void __napi_schedule_irqoff(struct napi_struct *n)
>   {
> -	____napi_schedule(this_cpu_ptr(&softnet_data), n);
> +	threaded_napi_sched(n);
>   }
>   EXPORT_SYMBOL(__napi_schedule_irqoff);
>   
> @@ -10685,6 +10740,10 @@ static int __init net_dev_init(void)
>   		sd->backlog.weight = weight_p;
>   	}
>   
> +#ifdef CONFIG_THREADED_NAPI
> +	napi_workq = alloc_workqueue("napi_workq", WQ_UNBOUND | WQ_HIGHPRI,
> +					    WQ_UNBOUND_MAX_ACTIVE);
> +#endif
>   	dev_boot_phase = 0;
>   
>   	/* The loopback device is special if any other network devices
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>
