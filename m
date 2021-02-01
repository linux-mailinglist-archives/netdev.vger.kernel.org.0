Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4D30A09D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 04:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhBADiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 22:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231394AbhBADiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 22:38:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612150596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/gAb6zAwOxu2R4KqWA0oIvyoIahKBpzIeRdzj32BG5w=;
        b=bJop+up8IO4G6tv6qmUnsBVaSvpzoRSuuBdKaCtmMyb8h+ltkybCYmS69SlUiq0/gNuHEW
        +OZJ4PEiRlxD73Ztj73X3Jf0EoksnxIkC2TAkWXNhfv7rn3tyJVUc63dExcic4ZG+C5Kjv
        175DNFWOR5XAAmKeTyF5wGBgwNLBXMo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-3I_W8Ol6Ns6EcSdpf565sA-1; Sun, 31 Jan 2021 22:36:31 -0500
X-MC-Unique: 3I_W8Ol6Ns6EcSdpf565sA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83616801B13;
        Mon,  1 Feb 2021 03:36:30 +0000 (UTC)
Received: from [10.72.13.233] (ovpn-13-233.pek2.redhat.com [10.72.13.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEE9D5D9DC;
        Mon,  1 Feb 2021 03:36:24 +0000 (UTC)
Subject: Re: [PATCH 2/2] vdpa/mlx5: Restore the hardware used index after
 change map
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-3-elic@nvidia.com>
 <54239b51-918c-3475-dc88-4da1a4548da8@redhat.com>
 <20210131185536.GA164217@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0c99f35c-7644-7201-cd11-7d486389a182@redhat.com>
Date:   Mon, 1 Feb 2021 11:36:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210131185536.GA164217@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/1 上午2:55, Eli Cohen wrote:
> On Fri, Jan 29, 2021 at 11:49:45AM +0800, Jason Wang wrote:
>> On 2021/1/28 下午9:41, Eli Cohen wrote:
>>> When a change of memory map occurs, the hardware resources are destroyed
>>> and then re-created again with the new memory map. In such case, we need
>>> to restore the hardware available and used indices. The driver failed to
>>> restore the used index which is added here.
>>>
>>> Fixes 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>
>> A question. Does this mean after a vq is suspended, the hw used index is not
>> equal to vq used index?
> Surely there is just one "Used index" for a VQ. What I was trying to say
> is that after the VQ is suspended, I read the used index by querying the
> hardware. The read result is the used index that the hardware wrote to
> memory.


Just to make sure I understand here. So it looks to me we had two index. 
The first is the used index which is stored in the memory/virtqueue, the 
second is the one that is stored by the device.


>   After the I create the new hardware object, I need to tell it
> what is the used index (and the available index) as a way to sync it
> with the existing VQ.


For avail index I understand that the hardware index is not synced with 
the avail index stored in the memory/virtqueue. The question is used 
index, if the hardware one is not synced with the one in the virtqueue. 
It means after vq is suspended,  some requests is not completed by the 
hardware (e.g the buffer were not put to used ring).

This may have implications to live migration, it means those 
unaccomplished requests needs to be migrated to the destination and 
resubmitted to the device. This looks not easy.

Thanks


>
> This sync is especially important when a change of map occurs while the
> VQ was already used (hence the indices are likely to be non zero). This
> can be triggered by hot adding memory after the VQs have been used.
>
>> Thanks
>>
>>
>>> ---
>>>    drivers/vdpa/mlx5/net/mlx5_vnet.c | 7 +++++++
>>>    1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 549ded074ff3..3fc8588cecae 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -87,6 +87,7 @@ struct mlx5_vq_restore_info {
>>>    	u64 device_addr;
>>>    	u64 driver_addr;
>>>    	u16 avail_index;
>>> +	u16 used_index;
>>>    	bool ready;
>>>    	struct vdpa_callback cb;
>>>    	bool restore;
>>> @@ -121,6 +122,7 @@ struct mlx5_vdpa_virtqueue {
>>>    	u32 virtq_id;
>>>    	struct mlx5_vdpa_net *ndev;
>>>    	u16 avail_idx;
>>> +	u16 used_idx;
>>>    	int fw_state;
>>>    	/* keep last in the struct */
>>> @@ -804,6 +806,7 @@ static int create_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
>>>    	obj_context = MLX5_ADDR_OF(create_virtio_net_q_in, in, obj_context);
>>>    	MLX5_SET(virtio_net_q_object, obj_context, hw_available_index, mvq->avail_idx);
>>> +	MLX5_SET(virtio_net_q_object, obj_context, hw_used_index, mvq->used_idx);
>>>    	MLX5_SET(virtio_net_q_object, obj_context, queue_feature_bit_mask_12_3,
>>>    		 get_features_12_3(ndev->mvdev.actual_features));
>>>    	vq_ctx = MLX5_ADDR_OF(virtio_net_q_object, obj_context, virtio_q_context);
>>> @@ -1022,6 +1025,7 @@ static int connect_qps(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>>>    struct mlx5_virtq_attr {
>>>    	u8 state;
>>>    	u16 available_index;
>>> +	u16 used_index;
>>>    };
>>>    static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq,
>>> @@ -1052,6 +1056,7 @@ static int query_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueu
>>>    	memset(attr, 0, sizeof(*attr));
>>>    	attr->state = MLX5_GET(virtio_net_q_object, obj_context, state);
>>>    	attr->available_index = MLX5_GET(virtio_net_q_object, obj_context, hw_available_index);
>>> +	attr->used_index = MLX5_GET(virtio_net_q_object, obj_context, hw_used_index);
>>>    	kfree(out);
>>>    	return 0;
>>> @@ -1602,6 +1607,7 @@ static int save_channel_info(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqu
>>>    		return err;
>>>    	ri->avail_index = attr.available_index;
>>> +	ri->used_index = attr.used_index;
>>>    	ri->ready = mvq->ready;
>>>    	ri->num_ent = mvq->num_ent;
>>>    	ri->desc_addr = mvq->desc_addr;
>>> @@ -1646,6 +1652,7 @@ static void restore_channels_info(struct mlx5_vdpa_net *ndev)
>>>    			continue;
>>>    		mvq->avail_idx = ri->avail_index;
>>> +		mvq->used_idx = ri->used_index;
>>>    		mvq->ready = ri->ready;
>>>    		mvq->num_ent = ri->num_ent;
>>>    		mvq->desc_addr = ri->desc_addr;

