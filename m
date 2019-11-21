Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390D21058C5
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKURlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:41:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46037 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKURlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:41:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so1932607pgg.12;
        Thu, 21 Nov 2019 09:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gj3j4wW1LcJXUsfRUfHXA/hV3jdPeZ9DVCb2XMC1Meo=;
        b=nfKjiIRMngcffCxR40onlG04nX9NLiy5kLvCmS1pbo3alC6Cnu3heD/+YDmsyozHf+
         JuVl2BrHbqKDYhmHlPqm9voUN8oyZpHsGK5YFBwypOUwOTk+OuQKpxzcWIrsVHAcA5Ji
         kV0x8Y7fcHqpBY6FZAFyqznbwfEJK58lRap5LJ4GLwJKyfFMW18o+1AX7uFZyMYSrncb
         VFd+K+np7bIT5BREgD9jt3erPBr6bisIhHXBytWS0oabdQpAV8PAQfmyCVu3PO2cO3u5
         SsU/r85Pgeun0QPP5oTCJpayUWL8CsR8uIwk+jtUWOJAbj8VJr3mGkcaAwJNQioZZWvh
         pDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj3j4wW1LcJXUsfRUfHXA/hV3jdPeZ9DVCb2XMC1Meo=;
        b=PDZoV9VLOKzuEoLy5RpwvV2wlaHt+mMkkB7+pNlK44zFjuFcsii+TYUbPrhYr4OczO
         LYYAE9SsTziy5sdI4fzAWmaSq12856gNvAcCMp01GS63m2z1+TxphpNxEP/jozXrlHAz
         8oV/t6mti5ZuprkYzn4iQ+acVvlX/OsHJabWEkDz16NL0qds4zZk4bzRPhJoiP2megVe
         Wi4ofZij9ru2ylOhkzouDZBPX0L2lUhFIo+nBJCZSrHcHfQAAuP7z1n5TshjOdbgkcAD
         tjnbTwRx1R+Ln7gNfAmx18cPUNxa0mKFcIWHwuOR68672DCLjWNzDP4pli2Px+biahgt
         j/Ig==
X-Gm-Message-State: APjAAAWUl2Pv2wrq9aOv/AXCl3kiKvbnhc3Yl93+q1WCLNgRMDgnJAmq
        8pUSf6bI1iz6EToGPOj7/3KfwCt9
X-Google-Smtp-Source: APXvYqx/HLBFtOJ6ArRBY8+Ltz14FwPQepAqZjHqZYrxvLZN/ns3qwZQ5hndF6XL8dohY7YDjg1wPg==
X-Received: by 2002:a63:1e4e:: with SMTP id p14mr10801747pgm.127.1574358071398;
        Thu, 21 Nov 2019 09:41:11 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a145sm4412442pfa.7.2019.11.21.09.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 09:41:10 -0800 (PST)
Subject: Re: [PATCH v2] net: ipmr: fix suspicious RCU warning
To:     Anders Roxell <anders.roxell@linaro.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, paulmck@kernel.org,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20191120152255.18928-1-anders.roxell@linaro.org>
 <e07311c7-24b8-8c48-d6f2-a7c93976613c@gmail.com>
 <CADYN=9Jzxgun9k8v9oQT47ZUFGPhCnsDoYaohG-DXmA1De1zXg@mail.gmail.com>
 <CADYN=9Kzz0DoK+hMaWqUyxXYrpTXpxG6YEWz-fo1Zgt+Z37T3Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a31bebef-ae89-988b-8c17-c3076f857cde@gmail.com>
Date:   Thu, 21 Nov 2019 09:41:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CADYN=9Kzz0DoK+hMaWqUyxXYrpTXpxG6YEWz-fo1Zgt+Z37T3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/19 2:17 AM, Anders Roxell wrote:
> On Thu, 21 Nov 2019 at 08:15, Anders Roxell <anders.roxell@linaro.org> wrote:
>>
>> On Wed, 20 Nov 2019 at 18:45, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>
>>>
>>> On 11/20/19 7:22 AM, Anders Roxell wrote:
> 
> [snippet]
> 
>>>> +     rtnl_lock();
>>>>       err = ipmr_rules_init(net);
>>>> +     rtnl_unlock();
>>>>       if (err < 0)
>>>>               goto ipmr_rules_fail;
>>>
>>> Hmmm... this might have performance impact for creation of a new netns
>>>
>>> Since the 'struct net' is not yet fully initialized (thus published/visible),
>>> should we really have to grab RTNL (again) only to silence a warning ?
>>>
>>> What about the following alternative ?
>>
>> I tried what you suggested, unfortunately, I still got the warning.
> 
> I was wrong, so if I also add "lockdep_rtnl_is_held()" to the
> "ipmr_for_each_table()" macro it works.
> 
>>
>>
>> [   43.253850][    T1] =============================
>> [   43.255473][    T1] WARNING: suspicious RCU usage
>> [   43.259068][    T1]
>> 5.4.0-rc8-next-20191120-00003-g3aa7c2a8649e-dirty #6 Not tainted
>> [   43.263078][    T1] -----------------------------
>> [   43.265134][    T1] net/ipv4/ipmr.c:1759 RCU-list traversed in
>> non-reader section!!
>> [   43.267587][    T1]
>> [   43.267587][    T1] other info that might help us debug this:
>> [   43.267587][    T1]
>> [   43.271129][    T1]
>> [   43.271129][    T1] rcu_scheduler_active = 2, debug_locks = 1
>> [   43.274021][    T1] 2 locks held by swapper/0/1:
>> [   43.275532][    T1]  #0: ffff000065abeaa0 (&dev->mutex){....}, at:
>> __device_driver_lock+0xa0/0xb0
>> [   43.278930][    T1]  #1: ffffa000153017f0 (rtnl_mutex){+.+.}, at:
>> rtnl_lock+0x1c/0x28
>> [   43.282023][    T1]
>> [   43.282023][    T1] stack backtrace:
>> [   43.283921][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
>> 5.4.0-rc8-next-20191120-00003-g3aa7c2a8649e-dirty #6
>> [   43.287152][    T1] Hardware name: linux,dummy-virt (DT)
>> [   43.288920][    T1] Call trace:
>> [   43.290057][    T1]  dump_backtrace+0x0/0x2d0
>> [   43.291535][    T1]  show_stack+0x20/0x30
>> [   43.292967][    T1]  dump_stack+0x204/0x2ac
>> [   43.294423][    T1]  lockdep_rcu_suspicious+0xf4/0x108
>> [   43.296163][    T1]  ipmr_device_event+0x100/0x1e8
>> [   43.297812][    T1]  notifier_call_chain+0x100/0x1a8
>> [   43.299486][    T1]  raw_notifier_call_chain+0x38/0x48
>> [   43.301248][    T1]  call_netdevice_notifiers_info+0x128/0x148
>> [   43.303158][    T1]  rollback_registered_many+0x684/0xb48
>> [   43.304963][    T1]  rollback_registered+0xd8/0x150
>> [   43.306595][    T1]  unregister_netdevice_queue+0x194/0x1b8
>> [   43.308406][    T1]  unregister_netdev+0x24/0x38
>> [   43.310012][    T1]  virtnet_remove+0x44/0x78
>> [   43.311519][    T1]  virtio_dev_remove+0x5c/0xc0
>> [   43.313114][    T1]  really_probe+0x508/0x920
>> [   43.314635][    T1]  driver_probe_device+0x164/0x230
>> [   43.316337][    T1]  device_driver_attach+0x8c/0xc0
>> [   43.318024][    T1]  __driver_attach+0x1e0/0x1f8
>> [   43.319584][    T1]  bus_for_each_dev+0xf0/0x188
>> [   43.321169][    T1]  driver_attach+0x34/0x40
>> [   43.322645][    T1]  bus_add_driver+0x204/0x3c8
>> [   43.324202][    T1]  driver_register+0x160/0x1f8
>> [   43.325788][    T1]  register_virtio_driver+0x7c/0x88
>> [   43.327480][    T1]  virtio_net_driver_init+0xa8/0xf4
>> [   43.329196][    T1]  do_one_initcall+0x4c0/0xad8
>> [   43.330767][    T1]  kernel_init_freeable+0x3e0/0x500
>> [   43.332444][    T1]  kernel_init+0x14/0x1f0
>> [   43.333901][    T1]  ret_from_fork+0x10/0x18
>>
>>
>> Cheers,
>> Anders
>>
>>>
>>> diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
>>> index 6e68def66822f47fc08d94eddd32a4bd4f9fdfb0..b6dcdce08f1d82c83756a319623e24ae0174092c 100644
>>> --- a/net/ipv4/ipmr.c
>>> +++ b/net/ipv4/ipmr.c
>>> @@ -94,7 +94,7 @@ static DEFINE_SPINLOCK(mfc_unres_lock);
>>>
>>>  static struct kmem_cache *mrt_cachep __ro_after_init;
>>>
>>> -static struct mr_table *ipmr_new_table(struct net *net, u32 id);
>>> +static struct mr_table *ipmr_new_table(struct net *net, u32 id, bool init);
>>>  static void ipmr_free_table(struct mr_table *mrt);
>>>
> 
>  static void ip_mr_forward(struct net *net, struct mr_table *mrt,
> @@ -110,7 +110,8 @@ static void ipmr_expire_process(struct timer_list *t);
> 
>  #ifdef CONFIG_IP_MROUTE_MULTIPLE_TABLES
>  #define ipmr_for_each_table(mrt, net) \
> -       list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list)
> +       list_for_each_entry_rcu(mrt, &net->ipv4.mr_tables, list, \
> +                               lockdep_rtnl_is_held())
>  static struct mr_table *ipmr_mr_table_iter(struct net *net,
>                                            struct mr_table *mrt)
> 
> 
> Cheers,
> Anders

That is great, I guess we can submit the two patches in a series.

