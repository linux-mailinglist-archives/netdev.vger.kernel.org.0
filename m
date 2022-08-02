Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E28E587DA2
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236793AbiHBNzM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Aug 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbiHBNzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:55:02 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6143727144;
        Tue,  2 Aug 2022 06:54:59 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id BC7F510087D60;
        Tue,  2 Aug 2022 21:54:55 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 5ECE837C83F;
        Tue,  2 Aug 2022 21:54:55 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZPDhxsbjdrJk; Tue,  2 Aug 2022 21:54:55 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 1FAC837C83E;
        Tue,  2 Aug 2022 21:54:55 +0800 (CST)
Date:   Tue, 2 Aug 2022 21:54:55 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     jasowang <jasowang@redhat.com>
Cc:     eperezma <eperezma@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <401747890.4486725.1659448495048.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [202.120.40.82]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: reorder used descriptors in a batch
Thread-Index: 1IG5Y+pztzcgqiaurw7RI47Es3FIgQ==
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> From: "jasowang" <jasowang@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>, "eperezma" <eperezma@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael
> Tsirkin" <mst@redhat.com>
> Cc: "netdev" <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Tuesday, July 26, 2022 3:36:01 PM
> Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch

> ÔÚ 2022/7/21 16:43, Guo Zhi Ð´µÀ:
>> Device may not use descriptors in order, for example, NIC and SCSI may
>> not call __vhost_add_used_n with buffers in order.  It's the task of
>> __vhost_add_used_n to order them.
> 
> 
> I'm not sure this is ture. Having ooo descriptors is probably by design
> to have better performance.
> 
> This might be obvious for device that may have elevator or QOS stuffs.
> 
> I suspect the right thing to do here is, for the device that can't
> perform better in the case of IN_ORDER, let's simply not offer IN_ORDER
> (zerocopy or scsi). And for the device we know it can perform better,
> non-zercopy ethernet device we can do that.
> 

Hi, it seems that you don't like define in order feature as a transparent feature.

If we move the in_order treatment to the device specific code (net.c, scsi.c, ...):

The in_order feature bit would be declared in net.c, and not in vhost.c, Only specific device(eg, net, vsock) support in order feature and expose used descriptors in order. 
The code of vhost.c would be untouched or almost untouched, and only the code in net.c,scsi.c needs to be modified, the device will do batching job by itself.
This can achieve the best performance for that device which use desceriptors in order.

If this is better, I will send a new version patches for this RFC.

> 
>>   This commit reorder the buffers using
>> vq->heads, only the batch is begin from the expected start point and is
>> continuous can the batch be exposed to driver.  And only writing out a
>> single used ring for a batch of descriptors, according to VIRTIO 1.1
>> spec.
> 
> 
> So this sounds more like a "workaround" of the device that can't consume
> buffer in order, I suspect it can help in performance.
> 
> More below.
> 
> 
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>>   drivers/vhost/vhost.h |  3 +++
>>   2 files changed, 45 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826c..e2e77e29f 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>   	vq->used_flags = 0;
>>   	vq->log_used = false;
>>   	vq->log_addr = -1ull;
>> +	vq->next_used_head_idx = 0;
>>   	vq->private_data = NULL;
>>   	vq->acked_features = 0;
>>   	vq->acked_backend_features = 0;
>> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>>   					  GFP_KERNEL);
>>   		if (!vq->indirect || !vq->log || !vq->heads)
>>   			goto err_nomem;
>> +
>> +		memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>>   	}
>>   	return 0;
>>   
>> @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue
>> *vq,
>>   			    unsigned count)
>>   {
>>   	vring_used_elem_t __user *used;
>> +	struct vring_desc desc;
>>   	u16 old, new;
>>   	int start;
>> +	int begin, end, i;
>> +	int copy_n = count;
>> +
>> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
> 
> 
> How do you guarantee that ids of heads are contiguous?
> 
> 
>> +		/* calculate descriptor chain length for each used buffer */
> 
> 
> I'm a little bit confused about this comment, we have heads[i].len for this?
> 
> 
>> +		for (i = 0; i < count; i++) {
>> +			begin = heads[i].id;
>> +			end = begin;
>> +			vq->heads[begin].len = 0;
> 
> 
> Does this work for e.g RX virtqueue?
> 
> 
>> +			do {
>> +				vq->heads[begin].len += 1;
>> +				if (unlikely(vhost_get_desc(vq, &desc, end))) {
> 
> 
> Let's try hard to avoid more userspace copy here, it's the source of
> performance regression.
> 
> Thanks
> 
> 
>> +					vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
>> +					       end, vq->desc + end);
>> +					return -EFAULT;
>> +				}
>> +			} while ((end = next_desc(vq, &desc)) != -1);
>> +		}
>> +
>> +		count = 0;
>> +		/* sort and batch continuous used ring entry */
>> +		while (vq->heads[vq->next_used_head_idx].len != 0) {
>> +			count++;
>> +			i = vq->next_used_head_idx;
>> +			vq->next_used_head_idx = (vq->next_used_head_idx +
>> +						  vq->heads[vq->next_used_head_idx].len)
>> +						  % vq->num;
>> +			vq->heads[i].len = 0;
>> +		}
>> +		/* only write out a single used ring entry with the id corresponding
>> +		 * to the head entry of the descriptor chain describing the last buffer
>> +		 * in the batch.
>> +		 */
>> +		heads[0].id = i;
>> +		copy_n = 1;
>> +	}
>>   
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	used = vq->used->ring + start;
>> -	if (vhost_put_used(vq, heads, start, count)) {
>> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>>   		vq_err(vq, "Failed to write used");
>>   		return -EFAULT;
>>   	}
>> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> vring_used_elem *heads,
>>   
>>   	start = vq->last_used_idx & (vq->num - 1);
>>   	n = vq->num - start;
>> -	if (n < count) {
>> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>>   		r = __vhost_add_used_n(vq, heads, n);
>>   		if (r < 0)
>>   			return r;
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index d9109107a..7b2c0fbb5 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>>   	bool log_used;
>>   	u64 log_addr;
>>   
>> +	/* Sort heads in order */
>> +	u16 next_used_head_idx;
>> +
>>   	struct iovec iov[UIO_MAXIOV];
>>   	struct iovec iotlb_iov[64];
>>   	struct iovec *indirect;
