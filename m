Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1B5315DFE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhBJECa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:02:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229601AbhBJECY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:02:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612929657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiSar9TAMcy2xRKolsSKppUgJqRDQOLGsEBTg7PEtAM=;
        b=MkhsLP7NMCMJryY90Y/6HIs7ka6uC0gt3/mJcyvBjwK+e2blk7WErWJwBdsRZK9+tQDsOa
        LsFM2foQNMX9pZJHsGksqE5cB55jpAWxSVAKeCj5DiVig4kC5H2SXIFQurhJQoSQvLu+Ji
        T/e4cZOVHMJ+ZSxoavRTxXa/a/z8oSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-pat8V0wMPIeyoW0ZjqVYMg-1; Tue, 09 Feb 2021 23:00:56 -0500
X-MC-Unique: pat8V0wMPIeyoW0ZjqVYMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C762189DF4F;
        Wed, 10 Feb 2021 04:00:54 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 830E219C78;
        Wed, 10 Feb 2021 04:00:48 +0000 (UTC)
Subject: Re: [PATCH 3/3] mlx5_vdpa: defer clear_virtqueues to until DRIVER_OK
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com, elic@nvidia.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1612614564-4220-1-git-send-email-si-wei.liu@oracle.com>
 <1612614564-4220-3-git-send-email-si-wei.liu@oracle.com>
 <2e2bc8d7-5d64-c28c-9aa0-1df32c7dcef3@redhat.com>
 <00d3ec60-3635-a5f1-15fc-21e6ce53202b@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ca25b0fd-5871-2543-d802-b10ed2a1d3a4@redhat.com>
Date:   Wed, 10 Feb 2021 12:00:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00d3ec60-3635-a5f1-15fc-21e6ce53202b@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/10 上午8:26, Si-Wei Liu wrote:
>
>
> On 2/8/2021 7:37 PM, Jason Wang wrote:
>>
>> On 2021/2/6 下午8:29, Si-Wei Liu wrote:
>>> While virtq is stopped,  get_vq_state() is supposed to
>>> be  called to  get  sync'ed  with  the latest internal
>>> avail_index from device. The saved avail_index is used
>>> to restate  the virtq  once device is started.  Commit
>>> b35ccebe3ef7 introduced the clear_virtqueues() routine
>>> to  reset  the saved  avail_index,  however, the index
>>> gets cleared a bit earlier before get_vq_state() tries
>>> to read it. This would cause consistency problems when
>>> virtq is restarted, e.g. through a series of link down
>>> and link up events. We  could  defer  the  clearing of
>>> avail_index  to  until  the  device  is to be started,
>>> i.e. until  VIRTIO_CONFIG_S_DRIVER_OK  is set again in
>>> set_status().
>>>
>>> Fixes: b35ccebe3ef7 ("vdpa/mlx5: Restore the hardware used index 
>>> after change map")
>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>> ---
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c 
>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index aa6f8cd..444ab58 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1785,7 +1785,6 @@ static void mlx5_vdpa_set_status(struct 
>>> vdpa_device *vdev, u8 status)
>>>       if (!status) {
>>>           mlx5_vdpa_info(mvdev, "performing device reset\n");
>>>           teardown_driver(ndev);
>>> -        clear_virtqueues(ndev);
>>>           mlx5_vdpa_destroy_mr(&ndev->mvdev);
>>>           ndev->mvdev.status = 0;
>>>           ++mvdev->generation;
>>> @@ -1794,6 +1793,7 @@ static void mlx5_vdpa_set_status(struct 
>>> vdpa_device *vdev, u8 status)
>>>         if ((status ^ ndev->mvdev.status) & 
>>> VIRTIO_CONFIG_S_DRIVER_OK) {
>>>           if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
>>> +            clear_virtqueues(ndev);
>>
>>
>> Rethink about this. As mentioned in another thread, this in fact 
>> breaks set_vq_state().  (See vhost_virtqueue_start() -> 
>> vhost_vdpa_set_vring_base() in qemu codes).
> I assume that the clearing for vhost-vdpa would be done via (qemu code),
>
> vhost_dev_start()->vhost_vdpa_dev_start()->vhost_vdpa_call(status | 
> VIRTIO_CONFIG_S_DRIVER_OK)
>
> which is _after_ vhost_virtqueue_start() gets called to restore the 
> avail_idx to h/w in vhost_dev_start(). What am I missing here?
>
> -Siwei


I think not. I thought clear_virtqueues() will clear hardware index but 
looks not. (I guess we need a better name other than clear_virtqueues(), 
e.g from the name it looks like the it will clear the hardware states)

Thanks


>
>
>>
>> The issue is that the avail idx is forgot, we need keep it.
>>
>> Thanks
>>
>>
>>>               err = setup_driver(ndev);
>>>               if (err) {
>>>                   mlx5_vdpa_warn(mvdev, "failed to setup driver\n");
>>
>

