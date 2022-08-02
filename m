Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3D85875FC
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbiHBDab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiHBDa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:30:29 -0400
Received: from smtp237.sjtu.edu.cn (smtp237.sjtu.edu.cn [202.120.2.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A40B960E4;
        Mon,  1 Aug 2022 20:30:25 -0700 (PDT)
Received: from mta91.sjtu.edu.cn (unknown [10.118.0.91])
        by smtp237.sjtu.edu.cn (Postfix) with ESMTPS id BA78810087D76;
        Tue,  2 Aug 2022 11:30:22 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 72A3C37C842;
        Tue,  2 Aug 2022 11:30:22 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from mta91.sjtu.edu.cn ([127.0.0.1])
        by localhost (mta91.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RufOKsyVjWCM; Tue,  2 Aug 2022 11:30:22 +0800 (CST)
Received: from mstore105.sjtu.edu.cn (mstore101.sjtu.edu.cn [10.118.0.105])
        by mta91.sjtu.edu.cn (Postfix) with ESMTP id 4C71C37C83E;
        Tue,  2 Aug 2022 11:30:22 +0800 (CST)
Date:   Tue, 2 Aug 2022 11:30:22 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma <eperezma@redhat.com>
Cc:     jasowang <jasowang@redhat.com>, sgarzare <sgarzare@redhat.com>,
        Michael Tsirkin <mst@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Message-ID: <705314501.4326759.1659411022241.JavaMail.zimbra@sjtu.edu.cn>
In-Reply-To: <CAJaqyWcP3CQoqN=oQ2c3d9UbGPgSS+j18CA5NO5JGAW64Z+H-Q@mail.gmail.com>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn> <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn> <CAJaqyWcP3CQoqN=oQ2c3d9UbGPgSS+j18CA5NO5JGAW64Z+H-Q@mail.gmail.com>
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Originating-IP: [58.45.124.125]
X-Mailer: Zimbra 8.8.15_GA_4308 (ZimbraWebClient - GC103 (Mac)/8.8.15_GA_3928)
Thread-Topic: vhost: reorder used descriptors in a batch
Thread-Index: 2uQimWZ8S6RVjUSqAqH+t287XtEj/w==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



----- Original Message -----
> From: "eperezma" <eperezma@redhat.com>
> To: "Guo Zhi" <qtxuning1999@sjtu.edu.cn>
> Cc: "jasowang" <jasowang@redhat.com>, "sgarzare" <sgarzare@redhat.com>, "Michael Tsirkin" <mst@redhat.com>, "netdev"
> <netdev@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>, "kvm list" <kvm@vger.kernel.org>,
> "virtualization" <virtualization@lists.linux-foundation.org>
> Sent: Friday, July 22, 2022 3:07:17 PM
> Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch

> On Thu, Jul 21, 2022 at 10:44 AM Guo Zhi <qtxuning1999@sjtu.edu.cn> wrote:
>>
>> Device may not use descriptors in order, for example, NIC and SCSI may
>> not call __vhost_add_used_n with buffers in order.  It's the task of
>> __vhost_add_used_n to order them.  This commit reorder the buffers using
>> vq->heads, only the batch is begin from the expected start point and is
>> continuous can the batch be exposed to driver.  And only writing out a
>> single used ring for a batch of descriptors, according to VIRTIO 1.1
>> spec.
>>
>> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
>> ---
>>  drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>>  drivers/vhost/vhost.h |  3 +++
>>  2 files changed, 45 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index 40097826c..e2e77e29f 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>>         vq->used_flags = 0;
>>         vq->log_used = false;
>>         vq->log_addr = -1ull;
>> +       vq->next_used_head_idx = 0;
>>         vq->private_data = NULL;
>>         vq->acked_features = 0;
>>         vq->acked_backend_features = 0;
>> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>>                                           GFP_KERNEL);
>>                 if (!vq->indirect || !vq->log || !vq->heads)
>>                         goto err_nomem;
>> +
>> +               memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>>         }
>>         return 0;
>>
>> @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue
>> *vq,
>>                             unsigned count)
>>  {
>>         vring_used_elem_t __user *used;
>> +       struct vring_desc desc;
>>         u16 old, new;
>>         int start;
>> +       int begin, end, i;
>> +       int copy_n = count;
>> +
>> +       if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>> +               /* calculate descriptor chain length for each used buffer */
>> +               for (i = 0; i < count; i++) {
>> +                       begin = heads[i].id;
>> +                       end = begin;
>> +                       vq->heads[begin].len = 0;
>> +                       do {
>> +                               vq->heads[begin].len += 1;
>> +                               if (unlikely(vhost_get_desc(vq, &desc, end))) {
>> +                                       vq_err(vq, "Failed to get descriptor:
>> idx %d addr %p\n",
>> +                                              end, vq->desc + end);
>> +                                       return -EFAULT;
>> +                               }
>> +                       } while ((end = next_desc(vq, &desc)) != -1);
>> +               }
>> +
>> +               count = 0;
>> +               /* sort and batch continuous used ring entry */
>> +               while (vq->heads[vq->next_used_head_idx].len != 0) {
>> +                       count++;
>> +                       i = vq->next_used_head_idx;
>> +                       vq->next_used_head_idx = (vq->next_used_head_idx +
>> +
>> vq->heads[vq->next_used_head_idx].len)
>> +                                                 % vq->num;
>> +                       vq->heads[i].len = 0;
>> +               }
> 
> You're iterating vq->heads with two different indexes here.
> 
> The first loop is working with indexes [0, count), which is fine if
> heads is a "cache" and everything can be overwritten (as it used to be
> before this patch).
> 
> The other loop trusts in vq->next_used_head_idx, which is saved between calls.
> 
> So both uses are going to conflict with each other.
> 

The first loop is to calculate the length of each descriptor, and the next is to find
the begin point of next batch. The next loop contains the first loop.

> A proposal for checking this is to push the data in the chains
> incrementally at the virtio_test driver, and check that they are
> returned properly. Like, the first buffer in the chain has the value
> of N, the second one N+1, and so on.
> 

LGTM. I'll try this to enhance the test.

> Let's split saving chains in its own patch.
> 
> 
>> +               /* only write out a single used ring entry with the id
>> corresponding
>> +                * to the head entry of the descriptor chain describing the last
>> buffer
>> +                * in the batch.
>> +                */
> 
> Let's delay the batching for now, we can add it as an optimization on
> top in the case of devices.
> 
> My proposal is to define a new struct vring_used_elem_inorder:
> 
> struct vring_used_elem_inorder {
>    uint16_t written'
>    uint16_t num;
> }
> 
> And create a per vq array of them, with vq->num size. Let's call it
> used_inorder for example.
> 
> Everytime the device uses a buffer chain of N buffers, written L and
> first descriptor id D, it stores vq->used_inorder[D] = { .written = L,
> .num = N }. .num == 0 means the buffer is not available.
> 
> After storing that information, you have your next_used_head_idx. You
> can check if vq->used_inorder[next_used_head_idx] is used (.num != 0).
> In case is not, there is no need to perform any actions for now.
> 
> In case it is, you iterate vq->used_inorder. First you write as used
> next_used_head_idx. After that, next_used_head_idx increments by .num,
> and we need to clean .num. If vq->used_inorder[vq->next_used_head_idx]
> is used too, repeat.
> 
> I think we could even squash vq->heads and vq->used_inorder with some
> tricks, because a chain's length would always be bigger or equal than
> used descriptor one, but to store in a different array would be more
> clear.
> 

I think this algorithm is the same with that in the patch. But it is better
to add a struct named vring_used_elem_inorder instead of vq->heads, which 
is more clear.

>> +               heads[0].id = i;
>> +               copy_n = 1;
> 
> The device must not write anything to the used ring if the next
> descriptor has not been used. I'm failing to trace how this works when
> the second half of the batch in vhost/test.c is used here.
> 
> Thanks!
> 
> 

Sorry for my mistake, I forgot add the check if(count == 0) in the patch.

>> +       }
>>
>>         start = vq->last_used_idx & (vq->num - 1);
>>         used = vq->used->ring + start;
>> -       if (vhost_put_used(vq, heads, start, count)) {
>> +       if (vhost_put_used(vq, heads, start, copy_n)) {
>>                 vq_err(vq, "Failed to write used");
>>                 return -EFAULT;
>>         }
>> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct
>> vring_used_elem *heads,
>>
>>         start = vq->last_used_idx & (vq->num - 1);
>>         n = vq->num - start;
>> -       if (n < count) {
>> +       if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>>                 r = __vhost_add_used_n(vq, heads, n);
>>                 if (r < 0)
>>                         return r;
>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>> index d9109107a..7b2c0fbb5 100644
>> --- a/drivers/vhost/vhost.h
>> +++ b/drivers/vhost/vhost.h
>> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>>         bool log_used;
>>         u64 log_addr;
>>
>> +       /* Sort heads in order */
>> +       u16 next_used_head_idx;
>> +
>>         struct iovec iov[UIO_MAXIOV];
>>         struct iovec iotlb_iov[64];
>>         struct iovec *indirect;
>> --
>> 2.17.1
>>
