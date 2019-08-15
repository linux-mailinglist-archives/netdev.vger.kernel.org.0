Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5D28E82A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 11:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbfHOJZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 05:25:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730939AbfHOJZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 05:25:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0459C307D96D;
        Thu, 15 Aug 2019 09:25:58 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEDED95A46;
        Thu, 15 Aug 2019 09:25:47 +0000 (UTC)
Subject: Re: [PATCH] virtio-net: lower min ring num_free for efficiency
To:     =?UTF-8?B?5YaJIGppYW5n?= <jiangkidd@hotmail.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>
References: <BYAPR14MB3205E4E194942B0A1A91A222A6AD0@BYAPR14MB3205.namprd14.prod.outlook.com>
 <f61d9621-cc33-44a2-f297-43f8af8d759b@redhat.com>
 <BYAPR14MB3205B734E554EACEEE337ADDA6AC0@BYAPR14MB3205.namprd14.prod.outlook.com>
 <38df7fdd-bd6a-cc82-534d-d7cbf3f1933c@redhat.com>
 <BYAPR14MB320512CCA27487548DDAA57FA6AC0@BYAPR14MB3205.namprd14.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <92f7955b-1b5a-84cb-895b-8d47044d7f03@redhat.com>
Date:   Thu, 15 Aug 2019 17:25:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR14MB320512CCA27487548DDAA57FA6AC0@BYAPR14MB3205.namprd14.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 15 Aug 2019 09:25:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/15 下午4:36, 冉 jiang wrote:
> On 2019/8/15 11:17, Jason Wang wrote:
>> On 2019/8/15 上午11:11, 冉 jiang wrote:
>>> On 2019/8/15 11:01, Jason Wang wrote:
>>>> On 2019/8/14 上午10:06, ? jiang wrote:
>>>>> This change lowers ring buffer reclaim threshold from 1/2*queue to
>>>>> budget
>>>>> for better performance. According to our test with qemu + dpdk, packet
>>>>> dropping happens when the guest is not able to provide free buffer in
>>>>> avail ring timely with default 1/2*queue. The value in the patch has
>>>>> been
>>>>> tested and does show better performance.
>>>> Please add your tests setup and result here.
>>>>
>>>> Thanks
>>>>
>>>>
>>>>> Signed-off-by: jiangkidd <jiangkidd@hotmail.com>
>>>>> ---
>>>>>     drivers/net/virtio_net.c | 2 +-
>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>>> index 0d4115c9e20b..bc08be7925eb 100644
>>>>> --- a/drivers/net/virtio_net.c
>>>>> +++ b/drivers/net/virtio_net.c
>>>>> @@ -1331,7 +1331,7 @@ static int virtnet_receive(struct receive_queue
>>>>> *rq, int budget,
>>>>>             }
>>>>>         }
>>>>>     -    if (rq->vq->num_free > virtqueue_get_vring_size(rq->vq) / 2) {
>>>>> +    if (rq->vq->num_free > min((unsigned int)budget,
>>>>> virtqueue_get_vring_size(rq->vq)) / 2) {
>>>>>             if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>>>>>                 schedule_delayed_work(&vi->refill, 0);
>>>>>         }
>>> Sure, here are the details:
>>
>> Thanks for the details, but I meant it's better if you could summarize
>> you test result in the commit log in a compact way.
>>
>> Btw, some comments, see below:
>>
>>
>>>
>>> Test setup & result:
>>>
>>> ----------------------------------------------------
>>>
>>> Below is the snippet from our test result. Test1 was done with default
>>> driver with the value of 1/2 * queue, while test2 is with my patch. We
>>> can see average
>>> drop packets do decrease a lot in test2.
>>>
>>> test1Time    avgDropPackets    test2Time    avgDropPackets pps
>>>
>>> 16:21.0    12.295    56:50.4    0 300k
>>> 17:19.1    15.244    56:50.4    0    300k
>>> 18:17.5    18.789    56:50.4    0    300k
>>> 19:15.1    14.208    56:50.4    0    300k
>>> 20:13.2    20.818    56:50.4    0.267    300k
>>> 21:11.2    12.397    56:50.4    0    300k
>>> 22:09.3    12.599    56:50.4    0    300k
>>> 23:07.3    15.531    57:48.4    0    300k
>>> 24:05.5    13.664    58:46.5    0    300k
>>> 25:03.7    13.158    59:44.5    4.73    300k
>>> 26:01.1    2.486    00:42.6    0    300k
>>> 26:59.1    11.241    01:40.6    0    300k
>>> 27:57.2    20.521    02:38.6    0    300k
>>> 28:55.2    30.094    03:36.7    0    300k
>>> 29:53.3    16.828    04:34.7    0.963    300k
>>> 30:51.3    46.916    05:32.8    0    400k
>>> 31:49.3    56.214    05:32.8    0    400k
>>> 32:47.3    58.69    05:32.8    0    400k
>>> 33:45.3    61.486    05:32.8    0    400k
>>> 34:43.3    72.175    05:32.8    0.598    400k
>>> 35:41.3    56.699    05:32.8    0    400k
>>> 36:39.3    61.071    05:32.8    0    400k
>>> 37:37.3    43.355    06:30.8    0    400k
>>> 38:35.4    44.644    06:30.8    0    400k
>>> 39:33.4    72.336    06:30.8    0    400k
>>> 40:31.4    70.676    06:30.8    0    400k
>>> 41:29.4    108.009    06:30.8    0    400k
>>> 42:27.4    65.216    06:30.8    0    400k
>>
>> Why there're difference in test time? Could you summarize them like:
>>
>> Test setup: e.g testpmd or pktgen to generate packets to guest
>>
>> avg packets drop before: XXX
>>
>> avg packets drop after: YYY(-ZZZ%)
>>
>> Thanks
>>
>>
>>>
>>> Data to prove why the patch helps:
>>>
>>> ----------------------------------------------------
>>>
>>> We did have completed several rounds of test with setting the value to
>>> budget (64 as the default value). It does improve a lot with pps is
>>> below 400pps for a single stream. We are confident that it runs out
>>> of free
>>> buffer in avail ring when packet dropping happens with below systemtap:
>>>
>>> Just a snippet:
>>>
>>> probe module("virtio_ring").function("virtqueue_get_buf")
>>> {
>>>         x = (@cast($_vq, "vring_virtqueue")->vring->used->idx)-
>>> (@cast($_vq, "vring_virtqueue")->last_used_idx) ---> we use this one
>>> to verify if the queue is full, which means guest is not able to take
>>> buffer from the queue timely
>>>
>>>         if (x<0 && (x+65535)<4096)
>>>             x = x+65535
>>>
>>>         if((x==1024) && @cast($_vq, "vring_virtqueue")->vq->callback ==
>>> callback_addr)
>>>             netrxcount[x] <<< gettimeofday_s()
>>> }
>>>
>>>
>>> probe module("virtio_ring").function("virtqueue_add_inbuf")
>>> {
>>>         y = (@cast($vq, "vring_virtqueue")->vring->avail->idx)-
>>> (@cast($vq, "vring_virtqueue")->vring->used->idx) ---> we use this one
>>> to verify if we run out of free buffer in avail ring
>>>         if (y<0 && (y+65535)<4096)
>>>             y = y+65535
>>>
>>>         if(@2=="debugon")
>>>         {
>>>             if(y==0 && @cast($vq, "vring_virtqueue")->vq->callback ==
>>> callback_addr)
>>>             {
>>>                 netrxfreecount[y] <<< gettimeofday_s()
>>>
>>>                 printf("no avail ring left seen, printing most recent 5
>>> num free, vq: %lx, current index: %d\n", $vq, recentfreecount)
>>>                 for(i=recentfreecount; i!=((recentfreecount+4) % 5);
>>> i=((i+1) % 5))
>>>                 {
>>>                     printf("index: %d, num free: %d\n", i,
>>> recentfree[$vq,
>>> i])
>>>                 }
>>>
>>>                 printf("index: %d, num free: %d\n", i, recentfree[$vq,
>>> i])
>>>                 //exit()
>>>             }
>>>         }
>>> }
>>>
>>>
>>> probe
>>> module("virtio_net").statement("virtnet_receive@drivers/net/virtio_net.c:732")
>>>
>>>
>>> {
>>>         recentfreecount++
>>>         recentfreecount = recentfreecount % 5
>>>         recentfree[$rq->vq, recentfreecount] = $rq->vq->num_free --->
>>> record the num_free for the last 5 calls to virtnet_receive, so we can
>>> see if lowering the bar helps.
>>> }
>>>
>>>
>>> Here is the result:
>>>
>>> no avail ring left seen, printing most recent 5 num free, vq:
>>> ffff9c13c1200000, current index: 1
>>> index: 1, num free: 561
>>> index: 2, num free: 305
>>> index: 3, num free: 369
>>> index: 4, num free: 433
>>> index: 0, num free: 497
>>> no avail ring left seen, printing most recent 5 num free, vq:
>>> ffff9c13c1200000, current index: 1
>>> index: 1, num free: 543
>>> index: 2, num free: 463
>>> index: 3, num free: 469
>>> index: 4, num free: 476
>>> index: 0, num free: 479
>>> no avail ring left seen, printing most recent 5 num free, vq:
>>> ffff9c13c1200000, current index: 2
>>> index: 2, num free: 555
>>> index: 3, num free: 414
>>> index: 4, num free: 420
>>> index: 0, num free: 427
>>> index: 1, num free: 491
>>>
>>> We can see in the last 4 calls to virtnet_receive before we run out
>>> of free buffer and start to relaim, num_free is quite high. So if we
>>> can do the reclaim earlier, it will certainly help.
>>>
>>> Jiang
>>
>> Right, but I think there's no need to put those thing in the commit log.
>>
>> Thanks
>>
>>
> Sure, here is the info:
>
>
> Test setup: iperf3 to generate packets to guest (total 30mins, pps 400k)


Please also note that type of packets e.g TCP or UDP.

Thanks


>
> avg packets drop before: 2842
>
> avg packets drop after: 360(-87.3%)
>
>
> Just let me know if it looks good enough. Thx.
>
> Jiang
>
