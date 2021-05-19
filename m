Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E6389096
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbhESOUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:20:12 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:45947 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239857AbhESOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 10:20:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UZPxG0E_1621433926;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UZPxG0E_1621433926)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 19 May 2021 22:18:46 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
Subject: Re: [PATCH] virtio_net: Remove BUG() to aviod machine dead
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <a351fbe1-0233-8515-2927-adc826a7fb94@linux.alibaba.com>
 <20210518055336-mutt-send-email-mst@kernel.org>
Message-ID: <4aaf5125-ce75-c72a-4b4a-11c91cb85a72@linux.alibaba.com>
Date:   Wed, 19 May 2021 22:18:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518055336-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks, I submit the patch as commented by Andrew 
https://lkml.org/lkml/2021/5/18/256

Actually, if xmit_skb() returns error, below code will give a warning 
with error code.

	/* Try to transmit */
	err = xmit_skb(sq, skb);

	/* This should not happen! */
	if (unlikely(err)) {
		dev->stats.tx_fifo_errors++;
		if (net_ratelimit())
			dev_warn(&dev->dev,
				 "Unexpected TXQ (%d) queue failure: %d\n",
				 qnum, err);
		dev->stats.tx_dropped++;
		dev_kfree_skb_any(skb);
		return NETDEV_TX_OK;
	}





ÔÚ 2021/5/18 ÏÂÎç5:54, Michael S. Tsirkin Ð´µÀ:
> typo in subject
> 
> On Tue, May 18, 2021 at 05:46:56PM +0800, Xianting Tian wrote:
>> When met error, we output a print to avoid a BUG().
>>
>> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
>> ---
>>   drivers/net/virtio_net.c | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index c921ebf3ae82..a66174d13e81 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -1647,9 +1647,8 @@ static int xmit_skb(struct send_queue *sq, struct
>> sk_buff *skb)
>>   		hdr = skb_vnet_hdr(skb);
>>
>>   	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
>> -				    virtio_is_little_endian(vi->vdev), false,
>> -				    0))
>> -		BUG();
>> +				virtio_is_little_endian(vi->vdev), false, 0))
>> +		return -EPROTO;
>>
> 
> why EPROTO? can you add some comments to explain what is going on pls?
> 
> is this related to a malicious hypervisor thing?
> 
> don't we want at least a WARN_ON? Or _ONCE?
> 
>>   	if (vi->mergeable_rx_bufs)
>>   		hdr->num_buffers = 0;
>> -- 
>> 2.17.1
