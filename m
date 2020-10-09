Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAE32880D0
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbgJIDrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31566 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgJIDrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602215220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ux54JNdDdEVnzLVcdf0BICEoj5Z4IXVy7u4NzlDD89k=;
        b=bp74xLL/4Hifzvm9x//kosmf4/CUjXn1HVFolsqGPivUnfpnMUKAchEwVCztVBELJC6HTw
        5uxCptHn221RPPiS49nTIYMUv7oc5SWfYuF6c+Z1C2sM+pDCe3FZmvsRMuud7UYOLtRUAB
        7xIqAc8Y6H12C3M+svJUkiBW0yBUnvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-CF7VmrsZN8Kp6ziGbLQnNw-1; Thu, 08 Oct 2020 23:46:59 -0400
X-MC-Unique: CF7VmrsZN8Kp6ziGbLQnNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8679884A61F;
        Fri,  9 Oct 2020 03:46:57 +0000 (UTC)
Received: from [10.72.13.133] (ovpn-13-133.pek2.redhat.com [10.72.13.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 534906EF63;
        Fri,  9 Oct 2020 03:46:30 +0000 (UTC)
Subject: Re: [RFC PATCH 06/24] vhost-vdpa: switch to use vhost-vdpa specific
 IOTLB
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-7-jasowang@redhat.com>
 <20200930120202.GA229518@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <766420cf-09bc-fb3d-f83b-140f99bfc6e3@redhat.com>
Date:   Fri, 9 Oct 2020 11:46:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930120202.GA229518@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/30 下午8:02, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 11:21:07AM +0800, Jason Wang wrote:
>> To ease the implementation of per group ASID support for vDPA
>> device. This patch switches to use a vhost-vdpa specific IOTLB to
>> avoid the unnecessary refactoring of the vhost core.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>   drivers/vhost/vdpa.c | 14 ++++++++------
>>   1 file changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 74bef1c15a70..ec3c94f706c1 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -40,6 +40,7 @@ struct vhost_vdpa {
>>   	struct vhost_virtqueue *vqs;
>>   	struct completion completion;
>>   	struct vdpa_device *vdpa;
>> +	struct vhost_iotlb *iotlb;
>>   	struct device dev;
>>   	struct cdev cdev;
>>   	atomic_t opened;
>> @@ -514,12 +515,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
>>   
>>   static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
>>   {
>> -	struct vhost_dev *dev = &v->vdev;
>> -	struct vhost_iotlb *iotlb = dev->iotlb;
>> +	struct vhost_iotlb *iotlb = v->iotlb;
>>   
>>   	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
>> -	kfree(dev->iotlb);
>> -	dev->iotlb = NULL;
>> +	kfree(v->iotlb);
>> +	v->iotlb = NULL;
>>   }
>>   
>>   static int perm_to_iommu_flags(u32 perm)
>> @@ -681,7 +681,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>>   	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>>   	struct vdpa_device *vdpa = v->vdpa;
>>   	const struct vdpa_config_ops *ops = vdpa->config;
>> -	struct vhost_iotlb *iotlb = dev->iotlb;
>> +	struct vhost_iotlb *iotlb = v->iotlb;
>>   	int r = 0;
>>   
>>   	r = vhost_dev_check_owner(dev);
>> @@ -812,12 +812,14 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>   
>>   	r = vhost_vdpa_alloc_domain(v);
>>   	if (r)
>> -		goto err_init_iotlb;
>> +		goto err_alloc_domain;
> You're still using this:
> dev->iotlb = vhost_iotlb_alloc(0, 0);
>
> Shouldn't you use
> v->iotlb = host_iotlb_alloc(0, 0);
>
> to set the vdpa device iotlb field?


Yes, you're right.

Will fix.

Thanks


>
>>   
>>   	filep->private_data = v;
>>   
>>   	return 0;
>>   
>> +err_alloc_domain:
>> +	vhost_vdpa_iotlb_free(v);
>>   err_init_iotlb:
>>   	vhost_vdpa_cleanup(v);
>>   err:
>> -- 
>> 2.20.1
>>

