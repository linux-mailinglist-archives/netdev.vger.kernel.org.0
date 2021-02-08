Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17933129BC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 05:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhBHE3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 23:29:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229537AbhBHE3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 23:29:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612758454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UL8cH8XCzdkqrrckXfp0ppSR7tIhk9JzqfHaTniZt4I=;
        b=Sw2iLJ+cmwzCNdKCBjcd5vdcIIdjTaW2nCwwtKC4AGOTfiJVb1q4z0pR/66bsyN7P5sPDP
        jdIB303W8vYSUS10tunzowVTPbkrxz+FmfZTnDyC9+Owau7wD9vB6/CDgwWHDGSdC8Lz7D
        mPf6+AUkytPH6zLXfeaZ2wBTDb/jbww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-oAenPR9uPeWRpEXqIQWZWw-1; Sun, 07 Feb 2021 23:27:32 -0500
X-MC-Unique: oAenPR9uPeWRpEXqIQWZWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4AA80197A;
        Mon,  8 Feb 2021 04:27:30 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C96F5D722;
        Mon,  8 Feb 2021 04:27:19 +0000 (UTC)
Subject: Re: [PATCH v1] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     lulu@redhat.com
References: <20210204073618.36336-1-elic@nvidia.com>
 <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f2206fa2-0ddc-1858-54e7-71614b142e46@redhat.com>
Date:   Mon, 8 Feb 2021 12:27:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <81f5ce4f-cdb0-26cd-0dce-7ada824b1b86@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/6 上午7:07, Si-Wei Liu wrote:
>
>
> On 2/3/2021 11:36 PM, Eli Cohen wrote:
>> When a change of memory map occurs, the hardware resources are destroyed
>> and then re-created again with the new memory map. In such case, we need
>> to restore the hardware available and used indices. The driver failed to
>> restore the used index which is added here.
>>
>> Also, since the driver also fails to reset the available and used
>> indices upon device reset, fix this here to avoid regression caused by
>> the fact that used index may not be zero upon device reset.
>>
>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 
>> devices")
>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>> ---
>> v0 -> v1:
>> Clear indices upon device reset
>>
>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> index 88dde3455bfd..b5fe6d2ad22f 100644
>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>       u64 device_addr;
>>       u64 driver_addr;
>>       u16 avail_index;
>> +    u16 used_index;
>>       bool ready;
>>       struct vdpa_callback cb;
>>       bool restore;
>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>       u32 virtq_id;
>>       struct mlx5_vdpa_net *ndev;
>>       u16 avail_idx;
>> +    u16 used_idx;
>>       int fw_state;
>>         /* keep last in the struct */
>> @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net 
>> *ndev, struct mlx5_vdpa_virtque
>>         obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, 
>> obj_context);
>>       MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, 
>> mvq->avail_idx);
>> +    MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, 
>> mvq->used_idx);
>>       MLX5_SET(virtio_net_q_object, obj_context, 
>> queue_feature_bit_mask_12_3,
>>            get_features_12_3(ndev->mvdev.actual_features));
>>       vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, 
>> virtio_q_context);
>> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net 
>> *ndev, struct mlx5_vdpa_virtqueue *m
>>   struct mlx5_virtq_attr {
>>       u8 state;
>>       u16 available_index;
>> +    u16 used_index;
>>   };
>>     static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct 
>> mlx5_vdpa_virtqueue *mvq,
>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net 
>> *ndev, struct mlx5_vdpa_virtqueu
>>       memset(attr, 0, sizeof(*attr));
>>       attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>>       attr->available_index = MLX5_GET(virtio_net_q_object, 
>> obj_context, hw_available_index);
>> +    attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, 
>> hw_used_index);
>>       kfree(out);
>>       return 0;
>>   @@ -1535,6 +1540,16 @@ static void teardown_virtqueues(struct 
>> mlx5_vdpa_net *ndev)
>>       }
>>   }
>>   +static void clear_virtqueues(struct mlx5_vdpa_net *ndev)
>> +{
>> +    int i;
>> +
>> +    for (i = ndev->mvdev.max_vqs - 1; i >= 0; i--) {
>> +        ndev->vqs[i].avail_idx = 0;
>> +        ndev->vqs[i].used_idx = 0;
>> +    }
>> +}
>> +
>>   /* TODO: cross-endian support */
>>   static inline bool mlx5_vdpa_is_little_endian(struct mlx5_vdpa_dev 
>> *mvdev)
>>   {
>> @@ -1610,6 +1625,7 @@ static int save_channel_info(struct 
>> mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>           return err;
>>         ri->avail_index = attr.available_index;
>> +    ri->used_index = attr.used_index;
>>       ri->ready = mvq->ready;
>>       ri->num_ent = mvq->num_ent;
>>       ri->desc_addr = mvq->desc_addr;
>> @@ -1654,6 +1670,7 @@ static void restore_channels_info(struct 
>> mlx5_vdpa_net *ndev)
>>               continue;
>>             mvq->avail_idx = ri->avail_index;
>> +        mvq->used_idx = ri->used_index;
>>           mvq->ready = ri->ready;
>>           mvq->num_ent = ri->num_ent;
>>           mvq->desc_addr = ri->desc_addr;
>> @@ -1768,6 +1785,7 @@ static void mlx5_vdpa_set_status(struct 
>> vdpa_device *vdev, u8 status)
>>       if (!status) {
>>           mlx5_vdpa_info(mvdev, "performing device reset\n");
>>           teardown_driver(ndev);
>> +        clear_virtqueues(ndev);
> The clearing looks fine at the first glance, as it aligns with the 
> other state cleanups floating around at the same place. However, the 
> thing is get_vq_state() is supposed to be called right after to get 
> sync'ed with the latest internal avail_index from device while vq is 
> stopped. The index was saved in the driver software at vq suspension, 
> but before the virtq object is destroyed. We shouldn't clear the 
> avail_index too early.


Good point.

There's a limitation on the virtio spec and vDPA framework that we can 
not simply differ device suspending from device reset.

Need to think about that. I suggest a new state in [1], the issue is 
that people doesn't like the asynchronous API that it introduces.


>
> Possibly it can be postponed to where VIRTIO_CONFIG_S_DRIVER_OK gets 
> set again, i.e. right before the setup_driver() in 
> mlx5_vdpa_set_status()?


Looks like a good workaround.

Thanks


>
> -Siwei


[1] 
https://lists.oasis-open.org/archives/virtio-comment/202012/msg00029.html


>
>> mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>           ndev->mvdev.status = 0;
>>           ndev->mvdev.mlx_features = 0;
>

