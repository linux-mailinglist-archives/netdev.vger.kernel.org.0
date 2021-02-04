Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2555F30EA8F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhBDC7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232956AbhBDC7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612407491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=We/txEWy5TS7k8mKU0fX6vqYwMryG2RJZY1WeQ5MTGg=;
        b=UsBDQfZLIEMqzJnn+P5gMTaGZ2ouLqjIbLPZNjwZZ/1Q8P1ysiHut6oUPp098MClQmFuU8
        +xP42w8rxf4iY8wDrJQsvcfFsaNRo9/eowesILMiu8+cZfu2nWLt9otKN/VehEsrhLPJg8
        crrdWcG97K4C0SDkTq5PiP1bO0dL+nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-4I-AD5gBN-mY_QZRr-WHWQ-1; Wed, 03 Feb 2021 21:58:07 -0500
X-MC-Unique: 4I-AD5gBN-mY_QZRr-WHWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00B07107ACE3;
        Thu,  4 Feb 2021 02:58:06 +0000 (UTC)
Received: from [10.72.14.1] (ovpn-14-1.pek2.redhat.com [10.72.14.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6210F5D9C0;
        Thu,  4 Feb 2021 02:57:58 +0000 (UTC)
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Si-Wei Liu <siwliu.kernel@gmail.com>
Cc:     Eli Cohen <elic@nvidia.com>, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com,
        Si-Wei Liu <si-wei.liu@oracle.com>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
 <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
 <CAPWQSg3KOAypcrs9krW8cGE7EDLTehCUCYFZMUYYNaYPH1oBZQ@mail.gmail.com>
 <c65808bf-b336-8718-f7ea-b39fcc658dfb@redhat.com>
 <20210202070631.GA233234@mtl-vdi-166.wap.labs.mlnx>
 <CAPWQSg058RGaxSS7s5s=kpxdGryiy2padRFztUZtXN+ttiDd1A@mail.gmail.com>
 <20210202092253.GA236663@mtl-vdi-166.wap.labs.mlnx>
 <CAPWQSg0tRXoGF88LQSLzUg88ZEi8p+M=R6Qd445iABShfn-o4g@mail.gmail.com>
 <eed86e79-4fd9-dfcf-da17-288a3fc597e3@redhat.com>
 <CAPWQSg1=aXByZoR2eZj4rfak0CDxZF6GnLNsh-vMyqyERetQpw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2a65c6c1-cf88-90ca-beb9-8ac55a2c7fe7@redhat.com>
Date:   Thu, 4 Feb 2021 10:57:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPWQSg1=aXByZoR2eZj4rfak0CDxZF6GnLNsh-vMyqyERetQpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/4 上午7:19, Si-Wei Liu wrote:
> On Tue, Feb 2, 2021 at 9:16 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/3 上午1:54, Si-Wei Liu wrote:
>>> On Tue, Feb 2, 2021 at 1:23 AM Eli Cohen <elic@nvidia.com> wrote:
>>>> On Tue, Feb 02, 2021 at 12:38:51AM -0800, Si-Wei Liu wrote:
>>>>> Thanks Eli and Jason for clarifications. See inline.
>>>>>
>>>>> On Mon, Feb 1, 2021 at 11:06 PM Eli Cohen <elic@nvidia.com> wrote:
>>>>>> On Tue, Feb 02, 2021 at 02:02:25PM +0800, Jason Wang wrote:
>>>>>>> On 2021/2/2 下午12:15, Si-Wei Liu wrote:
>>>>>>>> On Mon, Feb 1, 2021 at 7:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>>>>>>>> On 2021/2/2 上午3:17, Si-Wei Liu wrote:
>>>>>>>>>> On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wrote:
>>>>>>>>>>> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
>>>>>>>>>>>> suspend_vq should only suspend the VQ on not save the current available
>>>>>>>>>>>> index. This is done when a change of map occurs when the driver calls
>>>>>>>>>>>> save_channel_info().
>>>>>>>>>>> Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
>>>>>>>>>>> which doesn't save the available index as save_channel_info() doesn't
>>>>>>>>>>> get called in that path at all. How does it handle the case that
>>>>>>>>>>> aget_vq_state() is called from userspace (e.g. QEMU) while the
>>>>>>>>>>> hardware VQ object was torn down, but userspace still wants to access
>>>>>>>>>>> the queue index?
>>>>>>>>>>>
>>>>>>>>>>> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-email-si-wei.liu@oracle.com/
>>>>>>>>>>>
>>>>>>>>>>> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
>>>>>>>>>>> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
>>>>>>>>>>>
>>>>>>>>>>> QEMU will complain with the above warning while VM is being rebooted
>>>>>>>>>>> or shut down.
>>>>>>>>>>>
>>>>>>>>>>> Looks to me either the kernel driver should cover this requirement, or
>>>>>>>>>>> the userspace has to bear the burden in saving the index and not call
>>>>>>>>>>> into kernel if VQ is destroyed.
>>>>>>>>>> Actually, the userspace doesn't have the insights whether virt queue
>>>>>>>>>> will be destroyed if just changing the device status via set_status().
>>>>>>>>>> Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
>>>>>>>>>> so. Hence this still looks to me to be Mellanox specifics and
>>>>>>>>>> mlx5_vdpa implementation detail that shouldn't expose to userspace.
>>>>>>>>> So I think we can simply drop this patch?
>>>>>>>> Yep, I think so. To be honest I don't know why it has anything to do
>>>>>>>> with the memory hotplug issue.
>>>>>>> Eli may know more, my understanding is that, during memory hotplut, qemu
>>>>>>> need to propagate new memory mappings via set_map(). For mellanox, it means
>>>>>>> it needs to rebuild memory keys, so the virtqueue needs to be suspended.
>>>>>>>
>>>>>> I think Siwei was asking why the first patch was related to the hotplug
>>>>>> issue.
>>>>> I was thinking how consistency is assured when saving/restoring this
>>>>> h/w avail_index against the one in the virtq memory, particularly in
>>>>> the region_add/.region_del() context (e.g. the hotplug case). Problem
>>>>> is I don't see explicit memory barrier when guest thread updates the
>>>>> avail_index, how does the device make sure the h/w avail_index is
>>>>> uptodate while guest may race with updating the virtq's avail_index in
>>>>> the mean while? Maybe I completely miss something obvious?
>>>> DKIM-Signature: v1; arsa-sha256; crelaxed/relaxed; dnvidia.com; sn1;
>>>>           t 12257780; bhHnB0z4VEKwRS3WGY8d836MJgxu5Eln/jbFZlNXVxc08;
>>>>           hX-PGP-Universal:Date:From:To:CC:Subject:Message-ID:References:
>>>>            MIME-Version:Content-Type:Content-Disposition:
>>>>            Content-Transfer-Encoding:In-Reply-To:User-Agent:X-Originating-IP:
>>>>            X-ClientProxiedBy;
>>>>           bgGmb8+rcn3/rKzKQ/7QzSnghWzZ+FAU0XntsRZYGQ66sFvT7zsYPHogG3LIWNY77t
>>>>            wNHPw7GCJrNaH3nEXPbOp0FMOZw4Kv4W7UPuYPobbLeTkvuPAidjB8dM42vz+1X61t
>>>>            9IVQT9X4hnAxRjI5CqZOo41GS4Tl1X+ykGoA+VE80BR/R/+nQ3tXDVULfppzeB+vu3
>>>>            TWnnpaZ2GyoNyPlMiyVRkHdXzDVgA4uQHxwHn7otGK5J4lzyu8KrFyQtiP+f6hfu5v
>>>>            crJkYS8e9A+rfzUmKWuyHcKcmhPhAVJ4XdpzZcDXXlMHVxG7nR1o88xttC6D1+oNIP
>>>>            9xHI3DkNBpEuA
>>>> If you're asking about syncronization upon hot plug of memory, the
>>>> hardware always goes to read the available index from memory when a new
>>>> hardware object is associted with a virtqueue. You can argue then that
>>>> you don't need to restore the available index and you may be right but
>>>> this is the currect inteface to the firmware.
>>>>
>>>>
>>>> If you're asking on generally how sync is assured when the guest updates
>>>> the available index, can you please send a pointer to the code where you
>>>> see the update without a memory barrier?
>>> This is a snippet of virtqueue_add_split() where avail_index gets
>>> updated by guest:
>>>
>>>           /* Put entry in available array (but don't update avail->idx until they
>>>            * do sync). */
>>>           avail = vq->split.avail_idx_shadow & (vq->split.vring.num - 1);
>>>           vq->split.vring.avail->ring[avail] = cpu_to_virtio16(_vq->vdev, head);
>>>
>>>           /* Descriptors and available array need to be set before we expose the
>>>            * new available array entries. */
>>>           virtio_wmb(vq->weak_barriers);
>>>           vq->split.avail_idx_shadow++;
>>>           vq->split.vring.avail->idx = cpu_to_virtio16(_vq->vdev,
>>>                                                   vq->split.avail_idx_shadow);
>>>           vq->num_added++;
>>>
>>> There's memory barrier to make sure the update to descriptor and
>>> available ring is seen before writing to the avail->idx, but there
>>> seems no gurantee that this update would flush to the memory
>>> immmedately either before or after the mlx5-vdpa is suspened and gets
>>> the old avail_index value stashed somewhere. In this case, how does
>>> the hardware ensure the consistency between the guest virtio and host
>>> mlx5-vdpa? Or, it completly relies on guest to update the avail_index
>>> once the next buffer is available, so that the index will be in sync
>>> again?
>>
>> I'm not sure I get the question but notice that the driver should check
>> and notify virtqueue when device want a notification. So there's a
>> virtio_wmb() e.g in:
>>
>> static bool virtqueue_kick_prepare_split(struct virtqueue *_vq)
>> {
>>       struct vring_virtqueue *vq = to_vvq(_vq);
>>       u16 new, old;
>>       bool needs_kick;
>>
>>       START_USE(vq);
>>       /* We need to expose available array entries before checking avail
>>        * event. */
>>       virtio_mb(vq->weak_barries);
>>
>>       old = vq->split.avail_idx_shadow - vq->num_added;
>>       new = vq->split.avail_idx_shadow;
>>       vq->num_added = 0;
>>
>> (See the comment above virtio_mb()). So the avail idx is guaranteed to
>> be committed to memroy(cache hierarchy) before the check of
>> notification. I think we sync through this.
> Thanks for pointing it out! Indeed, the avail index is synced before
> kicking the device. However, even so I think the race might still be
> possible, see below:
>
>
>    mlx5_vdpa device                       virtio driver
> -------------------------------------------------------------------------
>                                    virtqueue_add_split
>                                      (bumped up avail_idx1 to
>                                      avail_idx2, but update
>                                      not yet committed to mem)
>
> (hot plug memory...)
> mlx5_vdpa_set_map
>    mlx5_vdpa_change_map
>      suspend_vqs
>        suspend_vq
>          (avail_idx1 was saved)
>      save_channels_info
>      :
>      :                             virtqueue_kick_prepare_split
>      :                               (avail_idx2 committed to memory)
>      restore_channels_info
>      setup_driver
>        ...
>          create_virtqueue
>            (saved avail_idx1
>            getting restored;
>            whereas current
>            avail_idx2 in
>            memory is ignored)


The index is not ignored, the device is expected to read descriptors 
from avail_idx1 until avail_idx2.


> :
> :
>                                     virtqueue_notify
>                                       vp_notify
> mlx5_vdpa_kick_vq
>    (device processing up to
>    avail_idx1 rather than
>    avail_idx2?)
>
>
> According to Eli, the vdpa firmware does not load the latest value,
> i.e. avail_idx2 from memory when re-creating the virtqueue object.


During sync it's not needed but after the device start to work, it needs 
to read descriptor until the available index.


> Instead it starts with a stale avail_idx1 that was saved in mlx5_vdpa
> driver private structure before the memory update is made. That is the
> way how the current firmware interface is designed. The thing I'm not
> sure though is if the firmware/device will resync and get to the
> latest avail_idx2 from memory while processing the kick request with
> mlx5_vdpa_kick_vq?


I think the point is that, the device must have an internal avail index, 
and the device is only expected to sync this internal avail index.


> If not, a few avail entries will be missing in the
> kick, which could cause odd behavior or implicit failure.
>
> But if the firmware will resync on kick_vq (and get_vq_state), I think
> I completely lost the point of saving and restoring avail_idx when
> changing the memory map...


The memory map changing is usually transparent to guest driver but only 
the device. Maybe you can refer vhost codes or qemu codes for the device 
logic.

Thanks


>
> Thanks,
> -Siwei
>
>> Thanks
>>
>>
>>> Thanks,
>>> -Siwei
>>>
>>>>> Thanks,
>>>>> -Siwei
>>>>>
>>>>>> But you're correct. When memory is added, I get a new memory map. This
>>>>>> requires me to build a new memory key object which covers the new memory
>>>>>> map. Since the virtqueue objects are referencing this memory key, I need
>>>>>> to destroy them and build new ones referncing the new memory key.
>>>>>>
>>>>>>> Thanks
>>>>>>>
>>>>>>>
>>>>>>>> -Siwei
>>>>>>>>
>>>>>>>>> Thanks
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>> -Siwei
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>>      drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
>>>>>>>>>>>>      1 file changed, 8 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>> index 88dde3455bfd..549ded074ff3 100644
>>>>>>>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>>>>>>>> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>>>>>>>>>>>>
>>>>>>>>>>>>      static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>>>>>>>>>>>>      {
>>>>>>>>>>>> -       struct mlx5_virtq_attr attr;
>>>>>>>>>>>> -
>>>>>>>>>>>>             if (!mvq->initialized)
>>>>>>>>>>>>                     return;
>>>>>>>>>>>>
>>>>>>>>>>>> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>>>>>>>>>>>>
>>>>>>>>>>>>             if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>>>>>>>>>>>>                     mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
>>>>>>>>>>>> -
>>>>>>>>>>>> -       if (query_virtqueue(ndev, mvq, &attr)) {
>>>>>>>>>>>> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
>>>>>>>>>>>> -               return;
>>>>>>>>>>>> -       }
>>>>>>>>>>>> -       mvq->avail_idx = attr.available_index;
>>>>>>>>>>>>      }
>>>>>>>>>>>>
>>>>>>>>>>>>      static void suspend_vqs(struct mlx5_vdpa_net *ndev)
>>>>>>>>>>>> --
>>>>>>>>>>>> 2.29.2
>>>>>>>>>>>>

