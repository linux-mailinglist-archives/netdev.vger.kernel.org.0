Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF6E597C27
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiHRDPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiHRDPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:15:05 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297A5F69;
        Wed, 17 Aug 2022 20:14:55 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id EAB2D1007FEC2;
        Thu, 18 Aug 2022 11:14:51 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id A8C7B37C83F;
        Thu, 18 Aug 2022 11:14:51 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LQVKrW1XeNzi; Thu, 18 Aug 2022 11:14:51 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 66A2E37C83E;
        Thu, 18 Aug 2022 11:14:51 +0800 (CST)
Date:   Thu, 18 Aug 2022 11:14:51 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        eperezma <eperezma@redhat.com>, jasowang <jasowang@redhat.com>,
        sgarzare <sgarzare@redhat.com>, Michael Tsirkin <mst@redhat.com>
Message-ID: <740765206.8333341.1660792491216.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <1660791937.681257-2-xuanzhuo@linux.alibaba.com>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn> <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn> <1660791937.681257-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC v2 5/7] virtio: unmask F_NEXT flag in desc_extra
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [36.148.65.198]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: virtio: unmask F_NEXT flag in desc_extra
Thread-Index: oba2ba4WyD9k9gWyXec9T2Msqu35hA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>, "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma"
> <eperezma@redhat.com>, "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin"
> <mst@redhat.com>
> Sent: Thursday, August 18, 2022 11:05:37 AM
> Subject: Re: [RFC v2 5/7] virtio: unmask F_NEXT flag in desc_extra

> On Wed, 17 Aug 2022 21:57:16 +0800, Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>> We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
>> unmask it so that we can access desc_extra to get next information.
> 
> I think we should state the purpose of this.
> 
I have to unmask F_NEXT flag in desc_extra in this series, because if in order
negotiated, the driver has to iterate the descriptor chain to get chain length
from desc_extra. (The reason why we should use desc_extra is that descs may be
changed by malicious hypervisors, https://lkml.org/lkml/2022/7/26/224).

>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/virtio/virtio_ring.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index a5ec724c01d8..1c1b3fa376a2 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -567,7 +567,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>  	}
>>  	/* Last one doesn't continue. */
>>  	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
>> -	if (!indirect && vq->use_dma_api)
>> +	if (!indirect)
>>  		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
>>  			~VRING_DESC_F_NEXT;
>>
>> @@ -584,6 +584,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
>>  					 total_sg * sizeof(struct vring_desc),
>>  					 VRING_DESC_F_INDIRECT,
>>  					 false);
>> +		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
>> +			~VRING_DESC_F_NEXT;
> 
> This seems unnecessary.
> 
>>  	}
>>
>>  	/* We're using some buffers from the free list. */
>> @@ -693,7 +695,7 @@ static void detach_buf_split(struct vring_virtqueue *vq,
>> unsigned int head,
>>  	/* Put back on free list: unmap first-level descriptors and find end */
>>  	i = head;
>>
>> -	while (vq->split.vring.desc[i].flags & nextflag) {
>> +	while (vq->split.desc_extra[i].flags & nextflag) {
> 
> nextflag is __virtio16
> 
> You can use VRING_DESC_F_NEXT directly.
> 
> Thanks.

Sorry for the mistake, I will fix it.

> 
>>  		vring_unmap_one_split(vq, i);
>>  		i = vq->split.desc_extra[i].next;
>>  		vq->vq.num_free++;
>> --
>> 2.17.1
>>
