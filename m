Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F21583F
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 05:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfEGDyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 23:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfEGDyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 23:54:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C911307D91E;
        Tue,  7 May 2019 03:54:09 +0000 (UTC)
Received: from [10.72.12.47] (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88F4660BEC;
        Tue,  7 May 2019 03:54:03 +0000 (UTC)
Subject: Re: [PATCH net] tuntap: synchronize through tfiles array instead of
 tun->numqueues
To:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Cc:     mst@redhat.com, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>
References: <1557199416-55253-1-git-send-email-jasowang@redhat.com>
 <7b9744b4-42ec-7d0a-20ff-d65f71b16c63@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6f880c3e-ebb6-a683-6c75-c94409a60741@redhat.com>
Date:   Tue, 7 May 2019 11:54:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <7b9744b4-42ec-7d0a-20ff-d65f71b16c63@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 07 May 2019 03:54:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/7 上午11:41, Eric Dumazet wrote:
>
> On 5/6/19 11:23 PM, Jason Wang wrote:
>> When a queue(tfile) is detached through __tun_detach(), we move the
>> last enabled tfile to the position where detached one sit but don't
>> NULL out last position. We expect to synchronize the datapath through
>> tun->numqueues. Unfortunately, this won't work since we're lacking
>> sufficient mechanism to order or synchronize the access to
>> tun->numqueues.
>>
>> To fix this, NULL out the last position during detaching and check
>> RCU protected tfile against NULL instead of checking tun->numqueues in
>> datapath.
>>
>> Cc: YueHaibing <yuehaibing@huawei.com>
>> Cc: Cong Wang <xiyou.wangcong@gmail.com>
>> Cc: weiyongjun (A) <weiyongjun1@huawei.com>
>> Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/net/tun.c | 12 +++++++-----
>>   1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index e9ca1c0..a64c928 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>   				   tun->tfiles[tun->numqueues - 1]);
>>   		ntfile = rtnl_dereference(tun->tfiles[index]);
>>   		ntfile->queue_index = index;
>> +		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
>> +				   NULL);
>>   
>>   		--tun->numqueues;
>>   		if (clean) {
>> @@ -1082,7 +1084,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>>   	tfile = rcu_dereference(tun->tfiles[txq]);
>>   
>>   	/* Drop packet if interface is not attached */
>> -	if (txq >= tun->numqueues)
>> +	if (!tfile)
>>   		goto drop;
>>   
>>   	if (!rcu_dereference(tun->steering_prog))
>> @@ -1306,13 +1308,13 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>>   	rcu_read_lock();
>>   
>>   	numqueues = READ_ONCE(tun->numqueues);
>> -	if (!numqueues) {
>> -		rcu_read_unlock();
>> -		return -ENXIO; /* Caller will free/return all frames */
>> -	}
>>   
> If you remove the test on (!numqueues),
> the following might crash with a divide by zero...


Indeed, let me post V2.

Thanks


>
>>   	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>>   					    numqueues]);
