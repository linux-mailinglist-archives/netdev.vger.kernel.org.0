Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88129E346
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 15:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfD2NHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 09:07:21 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7707 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbfD2NHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 09:07:21 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E12E8D361BF05A01302D;
        Mon, 29 Apr 2019 21:07:18 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 29 Apr 2019
 21:07:08 +0800
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     Jason Wang <jasowang@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
 <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com>
 <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com>
 <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <brouer@redhat.com>, <mst@redhat.com>,
        <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        <3chas3@gmail.com>, <wangli39@baidu.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <27477e2a-ddfa-4e80-7f8c-18e4f5ff4990@huawei.com>
Date:   Mon, 29 Apr 2019 21:07:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/4/29 10:23, Jason Wang wrote:
> 
> On 2019/4/29 上午1:59, Cong Wang wrote:
>> On Sun, Apr 28, 2019 at 12:51 AM Jason Wang <jasowang@redhat.com> wrote:
>>>> tun_net_xmit() doesn't have the chance to
>>>> access the change because it holding the rcu_read_lock().
>>>
>>>
>>> The problem is the following codes:
>>>
>>>
>>>          --tun->numqueues;
>>>
>>>          ...
>>>
>>>          synchronize_net();
>>>
>>> We need make sure the decrement of tun->numqueues be visible to readers
>>> after synchronize_net(). And in tun_net_xmit():
>>
>> It doesn't matter at all. Readers are okay to read it even they still use the
>> stale tun->numqueues, as long as the tfile is not freed readers can read
>> whatever they want...
> 
> This is only true if we set SOCK_RCU_FREE, isn't it?
> 
>>
>> The decrement of tun->numqueues is just how we unpublish the old
>> tfile, it is still valid for readers to read it _after_ unpublish, we only need
>> to worry about free, not about unpublish. This is the whole spirit of RCU.
>>
> 
> The point is we don't convert tun->numqueues to RCU but use
> synchronize_net().
> 
>> You need to rethink about my SOCK_RCU_FREE patch.
> 
> The code is wrote before SOCK_RCU_FREE is introduced and assume no
> de-reference from device after synchronize_net(). It doesn't harm to
> figure out the root cause which may give us more confidence to the fix
> (e.g like SOCK_RCU_FREE).
> 
> I don't object to fix with SOCK_RCU_FREE, but then we should remove
> the redundant synchronize_net(). But I still prefer to synchronize
> everything explicitly like (completely untested):
> 
>>From df91f77d35a6aa7943b6f2a7d4b329990896a0fe Mon Sep 17 00:00:00 2001
> From: Jason Wang <jasowang@redhat.com>
> Date: Mon, 29 Apr 2019 10:21:06 +0800
> Subject: [PATCH] tuntap: synchronize through tfiles instead of numqueues
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/tun.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 80bff1b4ec17..03715f605fb5 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -698,6 +698,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>  
>  		rcu_assign_pointer(tun->tfiles[index],
>  				   tun->tfiles[tun->numqueues - 1]);
> +		rcu_assign_pointer(tun->tfiles[tun->numqueues], NULL);
>  		ntfile = rtnl_dereference(tun->tfiles[index]);

move here to avoid NULL pointer dereference,  it works for me

		rcu_assign_pointer(tun->tfiles[tun->numqueues -1 ], NULL);

>  		ntfile->queue_index = index;
>  
> @@ -1082,7 +1083,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	tfile = rcu_dereference(tun->tfiles[txq]);
>  
>  	/* Drop packet if interface is not attached */
> -	if (txq >= tun->numqueues)
> +	if (!tfile)
>  		goto drop;
>  
>  	if (!rcu_dereference(tun->steering_prog))
> @@ -1305,15 +1306,13 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>  
>  	rcu_read_lock();
>  
> -	numqueues = READ_ONCE(tun->numqueues);
> -	if (!numqueues) {
> +	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
> +					    tun->numqueues]);
> +	if (!tfile) {
>  		rcu_read_unlock();
>  		return -ENXIO; /* Caller will free/return all frames */
>  	}
>  
> -	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
> -					    numqueues]);
> -
>  	spin_lock(&tfile->tx_ring.producer_lock);
>  	for (i = 0; i < n; i++) {
>  		struct xdp_frame *xdp = frames[i];
> 

