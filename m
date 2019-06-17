Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B1F47BF3
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFQIQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:16:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbfFQIQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 04:16:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8E8E33082E70;
        Mon, 17 Jun 2019 08:16:33 +0000 (UTC)
Received: from [10.72.12.67] (ovpn-12-67.pek2.redhat.com [10.72.12.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A8CE101F96B;
        Mon, 17 Jun 2019 08:16:30 +0000 (UTC)
Subject: Re: [PATCH] Fix tun: wake up waitqueues after IFF_UP is set
From:   Jason Wang <jasowang@redhat.com>
To:     Fei Li <lifei.shirley@bytedance.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zhengfeiran@bytedance.com, duanxiongchun@bytedance.com
References: <20190617073320.69015-1-lifei.shirley@bytedance.com>
 <28bef625-ce70-20a1-7d8b-296cd43015c4@redhat.com>
Message-ID: <2d05dce3-e19a-2f0f-8b74-8defae38640d@redhat.com>
Date:   Mon, 17 Jun 2019 16:16:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <28bef625-ce70-20a1-7d8b-296cd43015c4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 17 Jun 2019 08:16:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/17 下午4:10, Jason Wang wrote:
>
> On 2019/6/17 下午3:33, Fei Li wrote:
>> Currently after setting tap0 link up, the tun code wakes tx/rx waited
>> queues up in tun_net_open() when .ndo_open() is called, however the
>> IFF_UP flag has not been set yet. If there's already a wait queue, it
>> would fail to transmit when checking the IFF_UP flag in tun_sendmsg().
>> Then the saving vhost_poll_start() will add the wq into wqh until it
>> is waken up again. Although this works when IFF_UP flag has been set
>> when tun_chr_poll detects; this is not true if IFF_UP flag has not
>> been set at that time. Sadly the latter case is a fatal error, as
>> the wq will never be waken up in future unless later manually
>> setting link up on purpose.
>>
>> Fix this by moving the wakeup process into the NETDEV_UP event
>> notifying process, this makes sure IFF_UP has been set before all
>> waited queues been waken up.


Btw, the title needs some tweak. E.g you need use "net" as prefix since 
it's a fix for net.git and "Fix" could be removed like:

[PATCH net] tun: wake up waitqueues after IFF_UP is set.

Thanks


>>
>> Signed-off-by: Fei Li <lifei.shirley@bytedance.com>
>> ---
>>   drivers/net/tun.c | 17 +++++++++--------
>>   1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index c452d6d831dd..a3c9cab5a4d0 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1015,17 +1015,9 @@ static void tun_net_uninit(struct net_device 
>> *dev)
>>   static int tun_net_open(struct net_device *dev)
>>   {
>>       struct tun_struct *tun = netdev_priv(dev);
>> -    int i;
>>         netif_tx_start_all_queues(dev);
>>   -    for (i = 0; i < tun->numqueues; i++) {
>> -        struct tun_file *tfile;
>> -
>> -        tfile = rtnl_dereference(tun->tfiles[i]);
>> - tfile->socket.sk->sk_write_space(tfile->socket.sk);
>> -    }
>> -
>>       return 0;
>>   }
>>   @@ -3634,6 +3626,7 @@ static int tun_device_event(struct 
>> notifier_block *unused,
>>   {
>>       struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>>       struct tun_struct *tun = netdev_priv(dev);
>> +    int i;
>>         if (dev->rtnl_link_ops != &tun_link_ops)
>>           return NOTIFY_DONE;
>> @@ -3643,6 +3636,14 @@ static int tun_device_event(struct 
>> notifier_block *unused,
>>           if (tun_queue_resize(tun))
>>               return NOTIFY_BAD;
>>           break;
>> +    case NETDEV_UP:
>> +        for (i = 0; i < tun->numqueues; i++) {
>> +            struct tun_file *tfile;
>> +
>> +            tfile = rtnl_dereference(tun->tfiles[i]);
>> + tfile->socket.sk->sk_write_space(tfile->socket.sk);
>> +        }
>> +        break;
>>       default:
>>           break;
>>       }
>
>
> Acked-by: Jason Wang <jasowang@redhat.com)
>
