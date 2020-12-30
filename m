Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF42F2E76AD
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 07:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgL3Gup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 01:50:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbgL3Gup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 01:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609310958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=heg1e+a0V0k76vMPfwBRgNJmwNSkeMx7Vj1PPs8FGPE=;
        b=VKKPcvhHq6gU9fQeXblMMGEbp3CZ6GsWgUTCkToPC0WiIigTK+l3djt2pnO/Ea9xwfEY4x
        MfzvOD2yJXEdpw1/ZM9Y8Uw7V/5dr0kt6jSMu7Q9NUcpMmG/+P8bQFxeLkDo+9UHw+Bmr1
        v8rr/TMiWKeCv3Cyp0dhFO31tJ/f/kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-Te43lXXeP_qDJgvLF9ML3Q-1; Wed, 30 Dec 2020 01:49:17 -0500
X-MC-Unique: Te43lXXeP_qDJgvLF9ML3Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C497107ACE6;
        Wed, 30 Dec 2020 06:49:15 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E61FA71CBB;
        Wed, 30 Dec 2020 06:49:04 +0000 (UTC)
Subject: Re: [PATCH 12/21] vhost-vdpa: introduce uAPI to get the number of
 virtqueue groups
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-13-jasowang@redhat.com>
 <20201229122455.GF195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f7e603f1-0200-566a-5360-f093da358b6d@redhat.com>
Date:   Wed, 30 Dec 2020 14:49:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229122455.GF195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午8:24, Eli Cohen wrote:
> On Wed, Dec 16, 2020 at 02:48:09PM +0800, Jason Wang wrote:
>> Follows the vDPA support for multiple address spaces, this patch
>> introduce uAPI for the userspace to know the number of virtqueue
>> groups supported by the vDPA device.
> Can you explain what exactly you mean be userspace?


It's the userspace that uses the uAPI introduced in this patch.


> Is it just qemu or
> is it destined to the virtio_net driver run by the qemu process?


It could be Qemu, DPDK or other userspace program.

The guest virtio-net driver will not use this but talks to the virtio 
device emulated by Qemu.


> Also can you say for what purpose?


This can be used for facilitate the checking of whether the control vq 
could be supported.

E.g if the device support less than 2 groups, qemu won't advertise 
control vq.

Yes, #groups could be inferred from GET_VRING_GROUP. But it's not 
straightforward as this.

Thanks


>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vdpa.c       | 4 ++++
>>   include/uapi/linux/vhost.h | 3 +++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 060d5b5b7e64..1ba5901b28e7 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -536,6 +536,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>   	case VHOST_VDPA_GET_VRING_NUM:
>>   		r = vhost_vdpa_get_vring_num(v, argp);
>>   		break;
>> +	case VHOST_VDPA_GET_GROUP_NUM:
>> +		r = copy_to_user(argp, &v->vdpa->ngroups,
>> +				 sizeof(v->vdpa->ngroups));
>> +		break;
>>   	case VHOST_SET_LOG_BASE:
>>   	case VHOST_SET_LOG_FD:
>>   		r = -ENOIOCTLCMD;
>> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
>> index 59c6c0fbaba1..8a4e6e426bbf 100644
>> --- a/include/uapi/linux/vhost.h
>> +++ b/include/uapi/linux/vhost.h
>> @@ -145,4 +145,7 @@
>>   /* Get the valid iova range */
>>   #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
>>   					     struct vhost_vdpa_iova_range)
>> +/* Get the number of virtqueue groups. */
>> +#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x79, unsigned int)
>> +
>>   #endif
>> -- 
>> 2.25.1
>>

