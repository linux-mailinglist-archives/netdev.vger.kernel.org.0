Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36CDC6E880
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbfGSQOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:14:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbfGSQOC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:14:02 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6948B3CA08;
        Fri, 19 Jul 2019 16:14:01 +0000 (UTC)
Received: from redhat.com (ovpn-120-192.rdu2.redhat.com [10.10.120.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81CEF67139;
        Fri, 19 Jul 2019 16:13:54 +0000 (UTC)
Date:   Fri, 19 Jul 2019 12:13:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?utf-8?B?5YaJ?= jiang <jiangkidd@hotmail.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
Subject: Re: [PATCH] virtio-net: parameterize min ring num_free for virtio
 receive
Message-ID: <20190719121243-mutt-send-email-mst@kernel.org>
References: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
 <20190718085836-mutt-send-email-mst@kernel.org>
 <bdd30ef5-4f69-8218-eed0-38c6daac42db@redhat.com>
 <20190718103641-mutt-send-email-mst@kernel.org>
 <20190718104307-mutt-send-email-mst@kernel.org>
 <d1faa33a-6c4c-1190-8430-f0639edc3b96@redhat.com>
 <9c1bdbc5-e2c1-8dd7-52f9-1a4b43b86ff0@hotmail.com>
 <BYAPR14MB3205CA9A194A3828D869E2E5A6CB0@BYAPR14MB3205.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR14MB3205CA9A194A3828D869E2E5A6CB0@BYAPR14MB3205.namprd14.prod.outlook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 19 Jul 2019 16:14:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 03:31:29PM +0000, 冉 jiang wrote:
> 
> On 2019/7/19 22:29, Jiang wrote:
> >
> > On 2019/7/19 10:36, Jason Wang wrote:
> >>
> >> On 2019/7/18 下午10:43, Michael S. Tsirkin wrote:
> >>> On Thu, Jul 18, 2019 at 10:42:47AM -0400, Michael S. Tsirkin wrote:
> >>>> On Thu, Jul 18, 2019 at 10:01:05PM +0800, Jason Wang wrote:
> >>>>> On 2019/7/18 下午9:04, Michael S. Tsirkin wrote:
> >>>>>> On Thu, Jul 18, 2019 at 12:55:50PM +0000, ? jiang wrote:
> >>>>>>> This change makes ring buffer reclaim threshold num_free 
> >>>>>>> configurable
> >>>>>>> for better performance, while it's hard coded as 1/2 * queue now.
> >>>>>>> According to our test with qemu + dpdk, packet dropping happens 
> >>>>>>> when
> >>>>>>> the guest is not able to provide free buffer in avail ring timely.
> >>>>>>> Smaller value of num_free does decrease the number of packet 
> >>>>>>> dropping
> >>>>>>> during our test as it makes virtio_net reclaim buffer earlier.
> >>>>>>>
> >>>>>>> At least, we should leave the value changeable to user while the
> >>>>>>> default value as 1/2 * queue is kept.
> >>>>>>>
> >>>>>>> Signed-off-by: jiangkidd<jiangkidd@hotmail.com>
> >>>>>> That would be one reason, but I suspect it's not the
> >>>>>> true one. If you need more buffer due to jitter
> >>>>>> then just increase the queue size. Would be cleaner.
> >>>>>>
> >>>>>>
> >>>>>> However are you sure this is the reason for
> >>>>>> packet drops? Do you see them dropped by dpdk
> >>>>>> due to lack of space in the ring? As opposed to
> >>>>>> by guest?
> >>>>>>
> >>>>>>
> >>>>> Besides those, this patch depends on the user to choose a suitable 
> >>>>> threshold
> >>>>> which is not good. You need either a good value with demonstrated 
> >>>>> numbers or
> >>>>> something smarter.
> >>>>>
> >>>>> Thanks
> >>>> I do however think that we have a problem right now: try_fill_recv can
> >>>> take up a long time during which net stack does not run at all. 
> >>>> Imagine
> >>>> a 1K queue - we are talking 512 packets. That's exceessive.
> >>
> >>
> >> Yes, we will starve a fast host in this case.
> >>
> >>
> >>>>    napi poll
> >>>> weight solves a similar problem, so it might make sense to cap this at
> >>>> napi_poll_weight.
> >>>>
> >>>> Which will allow tweaking it through a module parameter as a
> >>>> side effect :) Maybe just do NAPI_POLL_WEIGHT.
> >>> Or maybe NAPI_POLL_WEIGHT/2 like we do at half the queue ;). Please
> >>> experiment, measure performance and let the list know
> >>>
> >>>> Need to be careful though: queues can also be small and I don't 
> >>>> think we
> >>>> want to exceed queue size / 2, or maybe queue size - napi_poll_weight.
> >>>> Definitely must not exceed the full queue size.
> >>
> >>
> >> Looking at intel, it uses 16 and i40e uses 32.  It looks to me 
> >> NAPI_POLL_WEIGHT/2 is better.
> >>
> >> Jiang, want to try that and post a new patch?
> >>
> >> Thanks
> >>
> >>
> >>>>
> >>>> -- 
> >>>> MST
> >
> > We did have completed several rounds of test with setting the value to 
> > budget (64 as the default value). It does improve a lot with pps is 
> > below 400pps for a single stream. Let me consolidate the data and will 
> > send it soon. Actually, we are confident that it runs out of free 
> > buffer in avail ring when packet dropping happens with below systemtap:
> >
> > Just a snippet:
> >
> > probe module("virtio_ring").function("virtqueue_get_buf")
> > {
> >     x = (@cast($_vq, "vring_virtqueue")->vring->used->idx)- 
> > (@cast($_vq, "vring_virtqueue")->last_used_idx) ---> we use this one 
> > to verify if the queue is full, which means guest is not able to take 
> > buffer from the queue timely
> >
> >     if (x<0 && (x+65535)<4096)
> >         x = x+65535
> >
> >     if((x==1024) && @cast($_vq, "vring_virtqueue")->vq->callback == 
> > callback_addr)
> >         netrxcount[x] <<< gettimeofday_s()
> > }
> >
> >
> > probe module("virtio_ring").function("virtqueue_add_inbuf")
> > {
> >     y = (@cast($vq, "vring_virtqueue")->vring->avail->idx)- 
> > (@cast($vq, "vring_virtqueue")->vring->used->idx) ---> we use this one 
> > to verify if we run out of free buffer in avail ring
> >     if (y<0 && (y+65535)<4096)
> >         y = y+65535
> >
> >     if(@2=="debugon")
> >     {
> >         if(y==0 && @cast($vq, "vring_virtqueue")->vq->callback == 
> > callback_addr)
> >         {
> >             netrxfreecount[y] <<< gettimeofday_s()
> >
> >             printf("no avail ring left seen, printing most recent 5 
> > num free, vq: %lx, current index: %d\n", $vq, recentfreecount)
> >             for(i=recentfreecount; i!=((recentfreecount+4) % 5); 
> > i=((i+1) % 5))
> >             {
> >                 printf("index: %d, num free: %d\n", i, recentfree[$vq, 
> > i])
> >             }
> >
> >             printf("index: %d, num free: %d\n", i, recentfree[$vq, i])
> >             //exit()
> >         }
> >     }
> > }
> >
> >
> > probe 
> > module("virtio_net").statement("virtnet_receive@drivers/net/virtio_net.c:732")
> > {
> >     recentfreecount++
> >     recentfreecount = recentfreecount % 5
> >     recentfree[$rq->vq, recentfreecount] = $rq->vq->num_free ---> 
> > record the num_free for the last 5 calls to virtnet_receive, so we can 
> > see if lowering the bar helps.
> > }
> >
> >
> > Here is the result:
> >
> > no avail ring left seen, printing most recent 5 num free, vq: 
> > ffff9c13c1200000, current index: 1
> > index: 1, num free: 561
> > index: 2, num free: 305
> > index: 3, num free: 369
> > index: 4, num free: 433
> > index: 0, num free: 497
> > no avail ring left seen, printing most recent 5 num free, vq: 
> > ffff9c13c1200000, current index: 1
> > index: 1, num free: 543
> > index: 2, num free: 463
> > index: 3, num free: 469
> > index: 4, num free: 476
> > index: 0, num free: 479
> > no avail ring left seen, printing most recent 5 num free, vq: 
> > ffff9c13c1200000, current index: 2
> > index: 2, num free: 555
> > index: 3, num free: 414
> > index: 4, num free: 420
> > index: 0, num free: 427
> > index: 1, num free: 491
> >
> > You can see in the last 4 calls to virtnet_receive before we run out 
> > of free buffer and start to relaim, num_free is quite high. So if we 
> > can do the reclaim earlier, it will certainly help.
> >
> > Meanwhile, the patch I proposed actually keeps the default value as 
> > 1/2 * queue. So the default behavior remains and only leave the 
> > interface to advanced users, who really understands what they are 
> > doing. Also, the best value may vary in different environment. Do you 
> > still think hardcoding this is better option?
> >
> >
> > Jiang
> >
> Here is the snippet from our test result. Test1 was done with default 
> driver with the value of 1/2 * queue, while test2 is with my patch and 
> min_numfree set to 64 (the default budget value). We can see average 
> drop packets do decrease a lot in test2. Let me know if you need the 
> full testing data.
> 
> test1Time    avgDropPackets    test2Time    avgDropPackets    pps
> 
> > 16:21.0    12.295    56:50.4    0    300k
> > 17:19.1    15.244    56:50.4    0    300k
> > 18:17.5    18.789    56:50.4    0    300k
> > 19:15.1    14.208    56:50.4    0    300k
> > 20:13.2    20.818    56:50.4    0.267    300k
> > 21:11.2    12.397    56:50.4    0    300k
> > 22:09.3    12.599    56:50.4    0    300k
> > 23:07.3    15.531    57:48.4    0    300k
> > 24:05.5    13.664    58:46.5    0    300k
> > 25:03.7    13.158    59:44.5    4.73    300k
> > 26:01.1    2.486    00:42.6    0    300k
> > 26:59.1    11.241    01:40.6    0    300k
> > 27:57.2    20.521    02:38.6    0    300k
> > 28:55.2    30.094    03:36.7    0    300k
> > 29:53.3    16.828    04:34.7    0.963    300k
> > 30:51.3    46.916    05:32.8    0    400k
> > 31:49.3    56.214    05:32.8    0    400k
> > 32:47.3    58.69    05:32.8    0    400k
> > 33:45.3    61.486    05:32.8    0    400k
> > 34:43.3    72.175    05:32.8    0.598    400k
> > 35:41.3    56.699    05:32.8    0    400k
> > 36:39.3    61.071    05:32.8    0    400k
> > 37:37.3    43.355    06:30.8    0    400k
> > 38:35.4    44.644    06:30.8    0    400k
> > 39:33.4    72.336    06:30.8    0    400k
> > 40:31.4    70.676    06:30.8    0    400k
> > 41:29.4    108.009    06:30.8    0    400k
> > 42:27.4    65.216    06:30.8    0    400k
> 
> 
> Jiang


OK I find this surprising but I accept what you see.
I'm inclined not to add a tunable and just select
a value ourselves.
I'm also fine with using the napi poll module parameter
which will give you a bit of tunability.

-- 
MST
