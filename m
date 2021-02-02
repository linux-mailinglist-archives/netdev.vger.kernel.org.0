Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA7330B5B6
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhBBDOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:14:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23560 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231158AbhBBDOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:14:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612235584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kUWFN4ekNdpi4WxcUqZD8X9JUjgbpEhAfA6K+mxCnDM=;
        b=RLyef//RASzBIdUap2YcepjW5QNuNC+p7cB0W47Y69as0hrnS4yU8lCeo5Q8lKKI0EMxo5
        22ib9AB5V+Ezdebz1ljnAQ8DzpGgHV0DblXKmqroOY9Vfj3p7L9YbUQkoZGbtYNhRmTfoe
        n4dbVVZj6qWK2hSbC5VkFJLM5i1bb5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Xm7YpHbfPKGCCPIAwAzINg-1; Mon, 01 Feb 2021 22:13:01 -0500
X-MC-Unique: Xm7YpHbfPKGCCPIAwAzINg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5B4C800D53;
        Tue,  2 Feb 2021 03:12:59 +0000 (UTC)
Received: from [10.72.13.250] (ovpn-13-250.pek2.redhat.com [10.72.13.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80C2360BE5;
        Tue,  2 Feb 2021 03:12:54 +0000 (UTC)
Subject: Re: [PATCH 1/2] vdpa/mlx5: Avoid unnecessary query virtqueue
To:     Si-Wei Liu <siwliu.kernel@gmail.com>, Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lulu@redhat.com, Si-Wei Liu <si-wei.liu@oracle.com>
References: <20210128134130.3051-1-elic@nvidia.com>
 <20210128134130.3051-2-elic@nvidia.com>
 <CAPWQSg0XtEQ1U5N3a767Ak_naoyPdVF1CeE4r3hmN11a-aoBxg@mail.gmail.com>
 <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9d6058d6-5ce1-0442-8fd9-5a6fe6a0bc6b@redhat.com>
Date:   Tue, 2 Feb 2021 11:12:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPWQSg3U9DCSK_01Kzuea5B1X+Ef9JB23wBY82A3ss-UXGek_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/2 上午3:17, Si-Wei Liu wrote:
> On Mon, Feb 1, 2021 at 10:51 AM Si-Wei Liu <siwliu.kernel@gmail.com> wrote:
>> On Thu, Jan 28, 2021 at 5:46 AM Eli Cohen <elic@nvidia.com> wrote:
>>> suspend_vq should only suspend the VQ on not save the current available
>>> index. This is done when a change of map occurs when the driver calls
>>> save_channel_info().
>> Hmmm, suspend_vq() is also called by teardown_vq(), the latter of
>> which doesn't save the available index as save_channel_info() doesn't
>> get called in that path at all. How does it handle the case that
>> aget_vq_state() is called from userspace (e.g. QEMU) while the
>> hardware VQ object was torn down, but userspace still wants to access
>> the queue index?
>>
>> Refer to https://lore.kernel.org/netdev/1601583511-15138-1-git-send-email-si-wei.liu@oracle.com/
>>
>> vhost VQ 0 ring restore failed: -1: Resource temporarily unavailable (11)
>> vhost VQ 1 ring restore failed: -1: Resource temporarily unavailable (11)
>>
>> QEMU will complain with the above warning while VM is being rebooted
>> or shut down.
>>
>> Looks to me either the kernel driver should cover this requirement, or
>> the userspace has to bear the burden in saving the index and not call
>> into kernel if VQ is destroyed.
> Actually, the userspace doesn't have the insights whether virt queue
> will be destroyed if just changing the device status via set_status().
> Looking at other vdpa driver in tree i.e. ifcvf it doesn't behave like
> so. Hence this still looks to me to be Mellanox specifics and
> mlx5_vdpa implementation detail that shouldn't expose to userspace.


So I think we can simply drop this patch?

Thanks


>> -Siwei
>>
>>
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>> ---
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 8 --------
>>>   1 file changed, 8 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 88dde3455bfd..549ded074ff3 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1148,8 +1148,6 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>>>
>>>   static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
>>>   {
>>> -       struct mlx5_virtq_attr attr;
>>> -
>>>          if (!mvq->initialized)
>>>                  return;
>>>
>>> @@ -1158,12 +1156,6 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
>>>
>>>          if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
>>>                  mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
>>> -
>>> -       if (query_virtqueue(ndev, mvq, &attr)) {
>>> -               mlx5_vdpa_warn(&ndev->mvdev, "failed to query virtqueue\n");
>>> -               return;
>>> -       }
>>> -       mvq->avail_idx = attr.available_index;
>>>   }
>>>
>>>   static void suspend_vqs(struct mlx5_vdpa_net *ndev)
>>> --
>>> 2.29.2
>>>

