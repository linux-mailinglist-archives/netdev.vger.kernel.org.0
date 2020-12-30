Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1902B2E75F9
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 05:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgL3E32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 23:29:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgL3E32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 23:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609302482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F7VOtk7yYlfXfkKIWDbIt/rwZpMlvsngOus3otwzlNY=;
        b=bZKF02r4WoA1bRj3Nn8vcn2Sjrge5NIqkkSZlpXAUZmyAazufSEBWvcW9uyD8bRtQuwCYF
        AVDrjPgLj9QM4lWnZbznXGaYJv0R8nmiDf2Wrl5CeWmWmBSNRw1Aslp4toDISvpKoPW0W0
        ZMP64l8D8jgh2l1lMF9zqfG6ECNjmBo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-rqaq5UO7OvObBieWgbT8Bg-1; Tue, 29 Dec 2020 23:28:00 -0500
X-MC-Unique: rqaq5UO7OvObBieWgbT8Bg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF011E75A;
        Wed, 30 Dec 2020 04:27:58 +0000 (UTC)
Received: from [10.72.13.30] (ovpn-13-30.pek2.redhat.com [10.72.13.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78F2271CBE;
        Wed, 30 Dec 2020 04:27:48 +0000 (UTC)
Subject: Re: [PATCH 10/21] vhost: support ASID in IOTLB API
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lulu@redhat.com, eli@mellanox.com,
        lingshan.zhu@intel.com, rob.miller@broadcom.com,
        stefanha@redhat.com, sgarzare@redhat.com
References: <20201216064818.48239-1-jasowang@redhat.com>
 <20201216064818.48239-11-jasowang@redhat.com>
 <20201229102059.GB195479@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <0fc761c7-6053-c098-a251-ae2f7380f95e@redhat.com>
Date:   Wed, 30 Dec 2020 12:27:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201229102059.GB195479@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/29 下午6:20, Eli Cohen wrote:
>> -static int vhost_process_iotlb_msg(struct vhost_dev *dev,
>> +static int vhost_process_iotlb_msg(struct vhost_dev *dev, u16 asid,
>>   				   struct vhost_iotlb_msg *msg)
>>   {
>>   	int ret = 0;
>>   
>> +	if (asid != 0)
>> +		return -EINVAL;
>> +
>>   	mutex_lock(&dev->mutex);
>>   	vhost_dev_lock_vqs(dev);
>>   	switch (msg->type) {
>> @@ -1135,6 +1138,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>>   	struct vhost_iotlb_msg msg;
>>   	size_t offset;
>>   	int type, ret;
>> +	u16 asid = 0;
> You assume asid occupies just 16 bits. So maybe you should reserve the
> other 16 bits for future extension:
>
> struct vhost_msg_v2 {
>          __u32 type;
> -       __u32 reserved;
> +       __u16 asid;
> +       __u16 reserved;
>          union {
>
> Moreover, maybe this should be reflected in previous patches that use
> the asid:
>
> -static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
> +static int mlx5_vdpa_set_map(struct vdpa_device *vdev, u16 asid,
> +                            struct vhost_iotlb *iotlb)
>
> -static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
> +static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u16 asid,
>                                          struct vhost_iotlb_msg *msg)
>
> etc.


Good catch.

This is a bug of the code actually. Since I want to stick to 32bit to be 
large enough for e.g PASID.

Will fix.

Thanks


>

