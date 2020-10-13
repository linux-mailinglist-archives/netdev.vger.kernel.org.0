Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003DE28C84E
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 07:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbgJMFhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 01:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbgJMFhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 01:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602567473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rw74HsxIwD123mE8HaMFYEH2HF+ZHaHtXtmLpiU4KEM=;
        b=JhBfu33XXm22LoUfHUP2RJzrtlrpSK6AXi1dKdA1yCIacELfyNByrc7mgDCttGM/aR/ZuV
        rzGggOjjWXBwaxs1TiISepbRBbyeaJ006RMNQiAGhu5PSNumDqpQn5n18BVV6dnFu1y4EO
        aayJpEDGRvxg02Ebhaq/A6NoMQZF6xY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-eJ5E8C6iOFOGdP0OrCPmlg-1; Tue, 13 Oct 2020 01:37:51 -0400
X-MC-Unique: eJ5E8C6iOFOGdP0OrCPmlg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52329805F0D;
        Tue, 13 Oct 2020 05:37:50 +0000 (UTC)
Received: from [10.72.13.59] (ovpn-13-59.pek2.redhat.com [10.72.13.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A5C227BDC;
        Tue, 13 Oct 2020 05:37:44 +0000 (UTC)
Subject: Re: [PATCH v2] vdpa/mlx5: Setup driver only if
 VIRTIO_CONFIG_S_DRIVER_OK
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>
References: <20200908123346.GA169007@mtl-vdi-166.wap.labs.mlnx>
 <1004346338.16284947.1599617319808.JavaMail.zimbra@redhat.com>
 <20200909053045.GB200399@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b3c13c74-b945-93a8-fb36-d24b944bb19b@redhat.com>
Date:   Tue, 13 Oct 2020 13:37:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909053045.GB200399@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/9 下午1:30, Eli Cohen wrote:
> On Tue, Sep 08, 2020 at 10:08:39PM -0400, Jason Wang wrote:
>>
>> ----- Original Message -----
>>> set_map() is used by mlx5 vdpa to create a memory region based on the
>>> address map passed by the iotlb argument. If we get successive calls, we
>>> will destroy the current memory region and build another one based on
>>> the new address mapping. We also need to setup the hardware resources
>>> since they depend on the memory region.
>>>
>>> If these calls happen before DRIVER_OK, It means that driver VQs may
>>> also not been setup and we may not create them yet. In this case we want
>>> to avoid setting up the other resources and defer this till we get
>>> DRIVER OK.
>>>
>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
>>> Signed-off-by: Eli Cohen <elic@nvidia.com>
>>> ---
>>> V1->V2: Improve changelog description
>>>
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 9df69d5efe8c..c89cd48a0aab 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1645,6 +1645,9 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_net
>>> *ndev, struct vhost_iotlb *
>>>   	if (err)
>>>   		goto err_mr;
>>>   
>>> +	if (!(ndev->mvdev.status & VIRTIO_CONFIG_S_DRIVER_OK))
>>> +		return 0;
>>> +
>> Is there any reason that we still need to do vq suspending and saving before?
>>
> Though suspend_vqs() and save_channels_info() will be called, they will
> not actually do any work because the mvq->initialized is false.
>
> Since we don't expect so many false map updates I think it makes sense
> to avoid logic around the calls suspend_vqs() and save_channels_info().


I see.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


>
>> Thanks
>>
>>>   	restore_channels_info(ndev);
>>>   	err = setup_driver(ndev);
>>>   	if (err)
>>> --
>>> 2.26.0
>>>
>>>

