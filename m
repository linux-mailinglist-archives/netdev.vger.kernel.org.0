Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03541AE25B
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 04:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbfIJCb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 22:31:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392735AbfIJCb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 22:31:28 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BCB3B5B38D226E5D2DEE;
        Tue, 10 Sep 2019 10:31:25 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Tue, 10 Sep 2019
 10:31:19 +0800
Subject: Re: [PATCH v3] tun: fix use-after-free when register netdev failed
To:     Jason Wang <jasowang@redhat.com>
References: <1566221479-16094-1-git-send-email-yangyingliang@huawei.com>
 <5D5FB3B6.5080800@huawei.com>
 <1be732b2-6eda-4ea6-772d-780694557910@redhat.com>
 <5D6DC5BF.5020009@huawei.com>
 <4a5d84b7-f3cb-c4e1-d6fe-28d186a551ee@redhat.com>
 <5D6DFD57.7020905@huawei.com>
 <71e17457-d4bc-15be-dfb3-d0a977fd7556@redhat.com>
 <5D6E17A7.1020102@huawei.com>
 <314835944.12221643.1567507811976.JavaMail.zimbra@redhat.com>
 <5D706CE4.3000103@huawei.com>
 <542aa2c2-fd54-1e6c-f2f4-46fcc2e6f6ee@redhat.com>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        eric dumazet <eric.dumazet@gmail.com>,
        xiyou wangcong <xiyou.wangcong@gmail.com>,
        <weiyongjun1@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5D770AF6.1060902@huawei.com>
Date:   Tue, 10 Sep 2019 10:31:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <542aa2c2-fd54-1e6c-f2f4-46fcc2e6f6ee@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/9/5 11:10, Jason Wang wrote:
> On 2019/9/5 上午10:03, Yang Yingliang wrote:
>>
>> On 2019/9/3 18:50, Jason Wang wrote:
>>> ----- Original Message -----
>>>> On 2019/9/3 14:06, Jason Wang wrote:
>>>>> On 2019/9/3 下午1:42, Yang Yingliang wrote:
>>>>>> On 2019/9/3 11:03, Jason Wang wrote:
>>>>>>> On 2019/9/3 上午9:45, Yang Yingliang wrote:
>>>>>>>> On 2019/9/2 13:32, Jason Wang wrote:
>>>>>>>>> On 2019/8/23 下午5:36, Yang Yingliang wrote:
>>>>>>>>>> On 2019/8/23 11:05, Jason Wang wrote:
>>>>>>>>>>> ----- Original Message -----
>>>>>>>>>>>> On 2019/8/22 14:07, Yang Yingliang wrote:
>>>>>>>>>>>>> On 2019/8/22 10:13, Jason Wang wrote:
>>>>>>>>>>>>>> On 2019/8/20 上午10:28, Jason Wang wrote:
>>>>>>>>>>>>>>> On 2019/8/20 上午9:25, David Miller wrote:
>>>>>>>>>>>>>>>> From: Yang Yingliang <yangyingliang@huawei.com>
>>>>>>>>>>>>>>>> Date: Mon, 19 Aug 2019 21:31:19 +0800
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>>> Call tun_attach() after register_netdevice() to make sure
>>>>>>>>>>>>>>>>> tfile->tun
>>>>>>>>>>>>>>>>> is not published until the netdevice is registered. So the
>>>>>>>>>>>>>>>>> read/write
>>>>>>>>>>>>>>>>> thread can not use the tun pointer that may freed by
>>>>>>>>>>>>>>>>> free_netdev().
>>>>>>>>>>>>>>>>> (The tun and dev pointer are allocated by
>>>>>>>>>>>>>>>>> alloc_netdev_mqs(), they
>>>>>>>>>>>>>>>>> can
>>>>>>>>>>>>>>>>> be freed by netdev_freemem().)
>>>>>>>>>>>>>>>> register_netdevice() must always be the last operation in
>>>>>>>>>>>>>>>> the order of
>>>>>>>>>>>>>>>> network device setup.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> At the point register_netdevice() is called, the device is
>>>>>>>>>>>>>>>> visible
>>>>>>>>>>>>>>>> globally
>>>>>>>>>>>>>>>> and therefore all of it's software state must be fully
>>>>>>>>>>>>>>>> initialized and
>>>>>>>>>>>>>>>> ready for us.
>>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>> You're going to have to find another solution to these
>>>>>>>>>>>>>>>> problems.
>>>>>>>>>>>>>>> The device is loosely coupled with sockets/queues. Each
>>>>>>>>>>>>>>> side is
>>>>>>>>>>>>>>> allowed to be go away without caring the other side. So
>>>>>>>>>>>>>>> in this
>>>>>>>>>>>>>>> case, there's a small window that network stack think the
>>>>>>>>>>>>>>> device has
>>>>>>>>>>>>>>> one queue but actually not, the code can then safely drop
>>>>>>>>>>>>>>> them.
>>>>>>>>>>>>>>> Maybe it's ok here with some comments?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Or if not, we can try to hold the device before tun_attach
>>>>>>>>>>>>>>> and drop
>>>>>>>>>>>>>>> it after register_netdevice().
>>>>>>>>>>>>>> Hi Yang:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> I think maybe we can try to hold refcnt instead of playing
>>>>>>>>>>>>>> real num
>>>>>>>>>>>>>> queues here. Do you want to post a V4?
>>>>>>>>>>>>> I think the refcnt can prevent freeing the memory in this
>>>>>>>>>>>>> case.
>>>>>>>>>>>>> When register_netdevice() failed, free_netdev() will be called
>>>>>>>>>>>>> directly,
>>>>>>>>>>>>> dev->pcpu_refcnt and dev are freed without checking refcnt of
>>>>>>>>>>>>> dev.
>>>>>>>>>>>> How about using patch-v1 that using a flag to check whether the
>>>>>>>>>>>> device
>>>>>>>>>>>> registered successfully.
>>>>>>>>>>>>
>>>>>>>>>>> As I said, it lacks sufficient locks or barriers. To be clear, I
>>>>>>>>>>> meant
>>>>>>>>>>> something like (compile-test only):
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>>>>>>>>> index db16d7a13e00..e52678f9f049 100644
>>>>>>>>>>> --- a/drivers/net/tun.c
>>>>>>>>>>> +++ b/drivers/net/tun.c
>>>>>>>>>>> @@ -2828,6 +2828,7 @@ static int tun_set_iff(struct net *net,
>>>>>>>>>>> struct file *file, struct ifreq *ifr)
>>>>>>>>>>>                                  (ifr->ifr_flags & TUN_FEATURES);
>>>>>>>>>>> INIT_LIST_HEAD(&tun->disabled);
>>>>>>>>>>> +               dev_hold(dev);
>>>>>>>>>>>                    err = tun_attach(tun, file, false,
>>>>>>>>>>> ifr->ifr_flags & IFF_NAPI,
>>>>>>>>>>>                                     ifr->ifr_flags &
>>>>>>>>>>> IFF_NAPI_FRAGS);
>>>>>>>>>>>                    if (err < 0)
>>>>>>>>>>> @@ -2836,6 +2837,7 @@ static int tun_set_iff(struct net *net,
>>>>>>>>>>> struct file *file, struct ifreq *ifr)
>>>>>>>>>>>                    err = register_netdevice(tun->dev);
>>>>>>>>>>>                    if (err < 0)
>>>>>>>>>>>                            goto err_detach;
>>>>>>>>>>> +               dev_put(dev);
>>>>>>>>>>>            }
>>>>>>>>>>>              netif_carrier_on(tun->dev);
>>>>>>>>>>> @@ -2852,11 +2854,13 @@ static int tun_set_iff(struct net *net,
>>>>>>>>>>> struct file *file, struct ifreq *ifr)
>>>>>>>>>>>            return 0;
>>>>>>>>>>>       err_detach:
>>>>>>>>>>> +       dev_put(dev);
>>>>>>>>>>>            tun_detach_all(dev);
>>>>>>>>>>>            /* register_netdevice() already called
>>>>>>>>>>> tun_free_netdev() */
>>>>>>>>>>>            goto err_free_dev;
>>>>>>>>>>>       err_free_flow:
>>>>>>>>>>> +       dev_put(dev);
>>>>>>>>>>>            tun_flow_uninit(tun);
>>>>>>>>>>> security_tun_dev_free_security(tun->security);
>>>>>>>>>>>     err_free_stat:
>>>>>>>>>>>
>>>>>>>>>>> What's your thought?
>>>>>>>>>> The dev pointer are freed without checking the refcount in
>>>>>>>>>> free_netdev() called by err_free_dev
>>>>>>>>>>
>>>>>>>>>> path, so I don't understand how the refcount protects this
>>>>>>>>>> pointer.
>>>>>>>>>>
>>>>>>>>> The refcount are guaranteed to be zero there, isn't it?
>>>>>>>> No, it's not.
>>>>>>>>
>>>>>>>> err_free_dev:
>>>>>>>>           free_netdev(dev);
>>>>>>>>
>>>>>>>> void free_netdev(struct net_device *dev)
>>>>>>>> {
>>>>>>>> ...
>>>>>>>>           /* pcpu_refcnt can be freed without checking refcount */
>>>>>>>>           free_percpu(dev->pcpu_refcnt);
>>>>>>>>           dev->pcpu_refcnt = NULL;
>>>>>>>>
>>>>>>>>           /*  Compatibility with error handling in drivers */
>>>>>>>>           if (dev->reg_state == NETREG_UNINITIALIZED) {
>>>>>>>>                   /* dev can be freed without checking refcount */
>>>>>>>>                   netdev_freemem(dev);
>>>>>>>>                   return;
>>>>>>>>           }
>>>>>>>> ...
>>>>>>>> }
>>>>>>> Right, but what I meant is in my patch, when code reaches
>>>>>>> free_netdev() the refcnt is zero. What did I miss?
>>>>>> Yes, but it can't fix the UAF problem.
>>>>> Well, it looks to me that the dev_put() in tun_put() won't release the
>>>>> device in this case.
>>>> The device is not released in tun_put().
>>>> This is how the UAF occurs:
>>>>
>>>>            CPUA                                           CPUB
>>>>        tun_set_iff()
>>>>          alloc_netdev_mqs()
>>>>          tun_attach()
>>>>                                                       
>>>> tun_chr_read_iter()
>>>>                                                          tun_get()
>>>>                                                          tun_do_read()
>>>>                                                           
>>>> tun_ring_recv()
>>>>          register_netdevice() <-- inject error
>>>>          goto err_detach
>>>>          tun_detach_all() <-- set RCV_SHUTDOWN
>>>>          free_netdev() <-- called from
>>>>                           err_free_dev path
>>>>            netdev_freemem() <-- free the memory
>>>>                              without check refcount
>>>>            (In this path, the refcount cannot prevent
>>>>             freeing the memory of dev, and the memory
>>>>             will be used by dev_put() called by
>>>>             tun_chr_read_iter() on CPUB.)
>>>>                                                           (Break from
>>>>                                                          
>>>> tun_ring_recv(),
>>>>                                                           because
>>>> RCV_SHUTDOWN
>>>>                                                           is set)
>>>>                                                         tun_put()
>>>>                                                         dev_put() <--
>>>> use the
>>>>                                                         memory freed by
>>>>                                                         netdev_freemem()
>>>>
>>>>
>>> My bad, thanks for the patience. Since all evil come from the
>>> tfile->tun, how about delay the publishing of tfile->tun until the
>>> success of registration to make sure dev_put() and dev_hold() work.
>>> (Compile test only)
>>>
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index db16d7a13e00..aab0be40d443 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -787,7 +787,8 @@ static void tun_detach_all(struct net_device *dev)
>>>    }
>>>      static int tun_attach(struct tun_struct *tun, struct file *file,
>>> -              bool skip_filter, bool napi, bool napi_frags)
>>> +              bool skip_filter, bool napi, bool napi_frags,
>>> +              bool publish_tun)
>>>    {
>>>        struct tun_file *tfile = file->private_data;
>>>        struct net_device *dev = tun->dev;
>>> @@ -870,7 +871,8 @@ static int tun_attach(struct tun_struct *tun,
>>> struct file *file,
>>>         * initialized tfile; otherwise we risk using half-initialized
>>>         * object.
>>>         */
>>> -    rcu_assign_pointer(tfile->tun, tun);
>>> +    if (publish_tun)
>>> +        rcu_assign_pointer(tfile->tun, tun);
>>>        rcu_assign_pointer(tun->tfiles[tun->numqueues], tfile);
>>>        tun->numqueues++;
>>>        tun_set_real_num_queues(tun);
>>> @@ -2730,7 +2732,7 @@ static int tun_set_iff(struct net *net, struct
>>> file *file, struct ifreq *ifr)
>>>              err = tun_attach(tun, file, ifr->ifr_flags & IFF_NOFILTER,
>>>                     ifr->ifr_flags & IFF_NAPI,
>>> -                 ifr->ifr_flags & IFF_NAPI_FRAGS);
>>> +                 ifr->ifr_flags & IFF_NAPI_FRAGS, true);
>>>            if (err < 0)
>>>                return err;
>>>    @@ -2829,13 +2831,17 @@ static int tun_set_iff(struct net *net,
>>> struct file *file, struct ifreq *ifr)
>>>              INIT_LIST_HEAD(&tun->disabled);
>>>            err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
>>> -                 ifr->ifr_flags & IFF_NAPI_FRAGS);
>>> +                 ifr->ifr_flags & IFF_NAPI_FRAGS, false);
>>>            if (err < 0)
>>>                goto err_free_flow;
>>>              err = register_netdevice(tun->dev);
>>>            if (err < 0)
>>>                goto err_detach;
>>> +        /* free_netdev() won't check refcnt, to aovid race
>>> +         * with dev_put() we need publish tun after registration.
>>> +         */
>>> +        rcu_assign_pointer(tfile->tun, tun);
>>>        }
>>>          netif_carrier_on(tun->dev);
>>> @@ -2978,7 +2984,7 @@ static int tun_set_queue(struct file *file,
>>> struct ifreq *ifr)
>>>            if (ret < 0)
>>>                goto unlock;
>>>            ret = tun_attach(tun, file, false, tun->flags & IFF_NAPI,
>>> -                 tun->flags & IFF_NAPI_FRAGS);
>>> +                 tun->flags & IFF_NAPI_FRAGS, true);
>>>        } else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
>>>            tun = rtnl_dereference(tfile->tun);
>>>            if (!tun || !(tun->flags & IFF_MULTI_QUEUE) ||
>>> tfile->detached)
>> I tested this patch, it can fix this UAF.
>>
>> But as Eric replied in my patch v1, tun_get() will return NULL as long
>> as tun_set_iff() (TUNSETIFF ioctl())
>> has not yet been called.
>
> Isn't this the expected behavior. Without TUNSETIFF, it means the
> netdevice is not attached, tun_get() should return NULL here.
>
>
>> This could break some applications, since tun_get() is used from poll()
>> and other syscalls.
>>
>> I think it should return '-EAGIAN' instead of '-EBADFD' in this way. I
>> did some change in patch v1,
>> if it's OK, I will send a v4.
>>
>>   drivers/net/tun.c | 34 ++++++++++++++++++++++++++++++----
>>   1 file changed, 30 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index db16d7a13e00..0abc654010e3 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -115,6 +115,7 @@ do {                                \
>>   /* High bits in flags field are unused. */
>>   #define TUN_VNET_LE     0x80000000
>>   #define TUN_VNET_BE     0x40000000
>> +#define TUN_DEV_REGISTERED    0x20000000
>>
>>   #define TUN_FEATURES (IFF_NO_PI | IFF_ONE_QUEUE | IFF_VNET_HDR | \
>>                 IFF_MULTI_QUEUE | IFF_NAPI | IFF_NAPI_FRAGS)
>> @@ -719,8 +720,10 @@ static void __tun_detach(struct tun_file *tfile,
>> bool clean)
>>               netif_carrier_off(tun->dev);
>>
>>               if (!(tun->flags & IFF_PERSIST) &&
>> -                tun->dev->reg_state == NETREG_REGISTERED)
>> +                tun->dev->reg_state == NETREG_REGISTERED) {
>> +                tun->flags &= ~TUN_DEV_REGISTERED;
>
> As I said for previous versions. It's not good that try to invent new
> internal state like this, and you need carefully to deal with the
> synchronization, it could be lock or barriers. Consider the
> synchronization of tun is already complex, let's better try to avoid
> adding more but using exist mechanism, e.g pointer publishing through RCU.
OK, need I post a V4 by using the diff file you sent ?
>
> Thanks
>
>
>>                   unregister_netdevice(tun->dev);
>> +            }
>>           }
>>           if (tun)
>>               xdp_rxq_info_unreg(&tfile->xdp_rxq);
>> @@ -884,8 +887,12 @@ static struct tun_struct *tun_get(struct tun_file
>> *tfile)
>>
>>       rcu_read_lock();
>>       tun = rcu_dereference(tfile->tun);
>> -    if (tun)
>> -        dev_hold(tun->dev);
>> +    if (tun) {
>> +        if (tun->flags & TUN_DEV_REGISTERED)
>> +            dev_hold(tun->dev);
>> +        else
>> +            tun = ERR_PTR(-EAGAIN);
>> +    }
>>       rcu_read_unlock();
>>
>>       return tun;
>> @@ -1428,7 +1435,7 @@ static __poll_t tun_chr_poll(struct file *file,
>> poll_table *wait)
>>       struct sock *sk;
>>       __poll_t mask = 0;
>>
>> -    if (!tun)
>> +    if (IS_ERR_OR_NULL(tun))
>>           return EPOLLERR;
>>
>>       sk = tfile->socket.sk;
>> @@ -2017,6 +2024,9 @@ static ssize_t tun_chr_write_iter(struct kiocb
>> *iocb, struct iov_iter *from)
>>       if (!tun)
>>           return -EBADFD;
>>
>> +    if (IS_ERR(tun))
>> +        return PTR_ERR(tun);
>> +
>>       result = tun_get_user(tun, tfile, NULL, from,
>>                     file->f_flags & O_NONBLOCK, false);
>>
>> @@ -2242,6 +2252,10 @@ static ssize_t tun_chr_read_iter(struct kiocb
>> *iocb, struct iov_iter *to)
>>
>>       if (!tun)
>>           return -EBADFD;
>> +
>> +    if (IS_ERR(tun))
>> +        return PTR_ERR(tun);
>> +
>>       ret = tun_do_read(tun, tfile, to, file->f_flags & O_NONBLOCK, NULL);
>>       ret = min_t(ssize_t, ret, len);
>>       if (ret > 0)
>> @@ -2525,6 +2539,9 @@ static int tun_sendmsg(struct socket *sock,
>> struct msghdr *m, size_t total_len)
>>       if (!tun)
>>           return -EBADFD;
>>
>> +    if (IS_ERR(tun))
>> +        return PTR_ERR(tun);
>> +
>>       if (ctl && (ctl->type == TUN_MSG_PTR)) {
>>           struct tun_page tpage;
>>           int n = ctl->num;
>> @@ -2573,6 +2590,11 @@ static int tun_recvmsg(struct socket *sock,
>> struct msghdr *m, size_t total_len,
>>           goto out_free;
>>       }
>>
>> +    if (IS_ERR(tun)) {
>> +        ret = PTR_ERR(tun);
>> +        goto out_free;
>> +    }
>> +
>>       if (flags & ~(MSG_DONTWAIT|MSG_TRUNC|MSG_ERRQUEUE)) {
>>           ret = -EINVAL;
>>           goto out_put_tun;
>> @@ -2622,6 +2644,9 @@ static int tun_peek_len(struct socket *sock)
>>       if (!tun)
>>           return 0;
>>
>> +    if (IS_ERR(tun))
>> +        return PTR_ERR(tun);
>> +
>>       ret = PTR_RING_PEEK_CALL(&tfile->tx_ring, tun_ptr_peek_len);
>>       tun_put(tun);
>>
>> @@ -2836,6 +2861,7 @@ static int tun_set_iff(struct net *net, struct
>> file *file, struct ifreq *ifr)
>>           err = register_netdevice(tun->dev);
>>           if (err < 0)
>>               goto err_detach;
>> +        tun->flags |= TUN_DEV_REGISTERED;
>>       }
>>
>>       netif_carrier_on(tun->dev);


