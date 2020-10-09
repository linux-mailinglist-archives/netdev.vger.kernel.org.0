Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6372880E9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730693AbgJID5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:57:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgJID5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602215850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uo7BVuO5nWq7vRp+Q6BR8DRA9qJtxjDgxial76TpnbI=;
        b=DxLqrmHqTmx7VLwDPpQI1/Eak5FmOvuP3OKzEHhjxu8Ky20mOLCfsDT89kKF2w9YspYLeT
        +5uwf/UIVfox8+KCI09kAAJDLsid7f4t0YEeWJuzO9xq4Ez3tXzl1FK3Ab50KPogmNrx6/
        2h2bBXdos2VAVRVdBMKtoJMgqT4Z0dQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-I6MnL823NTCeUzAiJitfyQ-1; Thu, 08 Oct 2020 23:57:27 -0400
X-MC-Unique: I6MnL823NTCeUzAiJitfyQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1AF387950C;
        Fri,  9 Oct 2020 03:57:25 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 796DC5C1BD;
        Fri,  9 Oct 2020 03:56:52 +0000 (UTC)
Subject: Re: [RFC PATCH 10/24] vdpa: introduce config operations for
 associating ASID to a virtqueue group
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-11-jasowang@redhat.com>
 <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <70af3ff0-74ed-e519-56f5-d61e6a48767f@redhat.com>
Date:   Fri, 9 Oct 2020 11:56:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001132927.GC32363@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/1 下午9:29, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 11:21:11AM +0800, Jason Wang wrote:
>> This patch introduces a new bus operation to allow the vDPA bus driver
>> to associate an ASID to a virtqueue group.
>>
> So in case of virtio_net, I would expect that all the data virtqueues
> will be associated with the same address space identifier.


Right.

I will add the codes to do this in the next version. It should be more 
explicit than have this assumption by default.


> Moreover,
> this assignment should be provided before the set_map call that provides
> the iotlb for the address space, correct?


I think it's better not have this limitation, note that set_map() now 
takes a asid argument.

So for hardware if the associated as is changed, the driver needs to 
program the hardware to switch to the new mapping.

Does this work for mlx5?


>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   include/linux/vdpa.h | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> index 1e1163daa352..e2394995a3cd 100644
>> --- a/include/linux/vdpa.h
>> +++ b/include/linux/vdpa.h
>> @@ -160,6 +160,12 @@ struct vdpa_device {
>>    * @get_generation:		Get device config generation (optional)
>>    *				@vdev: vdpa device
>>    *				Returns u32: device generation
>> + * @set_group_asid:		Set address space identifier for a
>> + *				virtqueue group
>> + *				@vdev: vdpa device
>> + *				@group: virtqueue group
>> + *				@asid: address space id for this group
>> + *				Returns integer: success (0) or error (< 0)
>>    * @set_map:			Set device memory mapping (optional)
>>    *				Needed for device that using device
>>    *				specific DMA translation (on-chip IOMMU)
>> @@ -237,6 +243,10 @@ struct vdpa_config_ops {
>>   		       u64 iova, u64 size, u64 pa, u32 perm);
>>   	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
>>   			 u64 iova, u64 size);
>> +	int (*set_group_asid)(struct vdpa_device *vdev, unsigned int group,
>> +			      unsigned int asid);
>> +
>> +
> Extra space


Will fix.

Thanks


>>   
>>   	/* Free device resources */
>>   	void (*free)(struct vdpa_device *vdev);
>> -- 
>> 2.20.1
>>

