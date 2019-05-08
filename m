Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B781701A
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 06:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfEHEaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 00:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfEHEaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 00:30:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 26BD03001828;
        Wed,  8 May 2019 04:30:09 +0000 (UTC)
Received: from [10.72.12.176] (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 860CD5DD81;
        Wed,  8 May 2019 04:30:02 +0000 (UTC)
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <20190508001518-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a9dabfe9-4abd-8908-1350-34b2eeb1e35d@redhat.com>
Date:   Wed, 8 May 2019 12:30:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508001518-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 08 May 2019 04:30:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/8 下午12:16, Michael S. Tsirkin wrote:
> On Tue, May 07, 2019 at 12:03:36AM -0400, Jason Wang wrote:
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
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
>> Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>> Changes from V1:
>> - keep the check in tun_xdp_xmit()
>> ---
>>   drivers/net/tun.c | 8 +++++++-
>>   1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index e9ca1c0..32a0b23 100644
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
> Hmm don't we need to range check txq?


Looks not since tun_select_queue will always return a value which is 
less than MAX_TAP_QUEUES. And we NULL out the last enabled queue in 
tun_detach().

Thanks


>
>
>> @@ -1313,6 +1315,10 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>>   
>>   	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>>   					    numqueues]);
>> +	if (!tfile) {
>> +		rcu_read_unlock();
>> +		return -ENXIO; /* Caller will free/return all frames */
>> +	}
>>   
>>   	spin_lock(&tfile->tx_ring.producer_lock);
>>   	for (i = 0; i < n; i++) {
>> -- 
>> 1.8.3.1
