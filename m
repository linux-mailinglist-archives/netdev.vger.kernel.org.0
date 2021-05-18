Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA03874F2
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 11:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347737AbhERJWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 05:22:01 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:50484 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238036AbhERJV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 05:21:56 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UZII4qy_1621329636;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UZII4qy_1621329636)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 18 May 2021 17:20:37 +0800
Subject: Re: [PATCH] virtio_net: Use BUG_ON instead of if condition followed
 by BUG
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
 <YKJ/KPtw5Xcjsea+@lunn.ch>
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Message-ID: <32044caf-8da4-8bbd-86d6-693ab284351c@linux.alibaba.com>
Date:   Tue, 18 May 2021 17:20:36 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKJ/KPtw5Xcjsea+@lunn.ch>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks for your comments,
It is a good idea, I think we can follow the similar logic in function 
'receive_buf':
	if (virtio_net_hdr_to_skb(skb, &hdr->hdr,
				  virtio_is_little_endian(vi->vdev))) {
		net_warn_ratelimited("%s: bad gso: type: %u, size:%u\n",
				     dev->name, hdr->hdr.gso_type,
				     hdr->hdr.gso_size);
		goto frame_err;
	}

I will summit a new patch later.


ÔÚ 2021/5/17 ÏÂÎç10:35, Andrew Lunn Ð´µÀ:
> On Mon, May 17, 2021 at 09:31:19PM +0800, Xianting Tian wrote:
>> BUG_ON() uses unlikely in if(), which can be optimized at compile time.
>>
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index c921ebf3ae82..212d52204884 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct
>> sk_buff *skb)
>>   	else
>>   		hdr = skb_vnet_hdr(skb);
>>
>> -	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
> 
> How fatal is it not being able to get the header from the skb? There
> has been push back on the use of BUG() or its variants, since it kills
> the machine dead. Would it be possible to turn this into a WARN_ON and
> return -EPROTO or something?
> 
>         Andrew
> 
