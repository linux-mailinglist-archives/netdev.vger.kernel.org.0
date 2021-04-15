Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD036040D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhDOIQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:16:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhDOIQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:16:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618474592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3qfacKPFWYJe6SJGGT9jnGqaiQMDFfgudP5Ye2GaUQ=;
        b=UvM2lA4UEc+hvdVPyTlY+DpqNXKkbZ4cpZgX5dfqQDKCQT4DLwiQVExI+wKsytfUqNk0GL
        0ISGthUimiUPrxjMQS3z77H5NNqDNHhrzB7uq18WvIBdXspQsksB4WwrTwtdE18kukpGVf
        rRSjezJKfi3fN2AbiiCth8q0agg6yS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-nf00DL1qOpq2a81pIwwyBQ-1; Thu, 15 Apr 2021 04:16:29 -0400
X-MC-Unique: nf00DL1qOpq2a81pIwwyBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9AA2310053E8;
        Thu, 15 Apr 2021 08:16:28 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-61.pek2.redhat.com [10.72.12.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1581C1F057;
        Thu, 15 Apr 2021 08:16:21 +0000 (UTC)
Subject: Re: [PATCH 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, lulu@redhat.com, leonro@nvidia.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-4-lingshan.zhu@intel.com>
 <20210415081236.anbssqtsyjnmiaby@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <178b6e14-dfb5-b5f9-477e-15801d849c2a@redhat.com>
Date:   Thu, 15 Apr 2021 16:16:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415081236.anbssqtsyjnmiaby@steredhat>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/15 下午4:12, Stefano Garzarella 写道:
> On Wed, Apr 14, 2021 at 05:18:32PM +0800, Zhu Lingshan wrote:
>> get_config_size() should return the size based on the decected
>> device type.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>> drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 9b6a38b798fa..b48b9789b69e 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -347,7 +347,16 @@ static u32 ifcvf_vdpa_get_vq_align(struct 
>> vdpa_device *vdpa_dev)
>>
>> static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>> {
>> -    return sizeof(struct virtio_net_config);
>> +    struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>> +    size_t size;
>> +
>> +    if (vf->dev_type == VIRTIO_ID_NET)
>> +        size = sizeof(struct virtio_net_config);
>> +
>> +    if (vf->dev_type == VIRTIO_ID_BLOCK)
>> +        size = sizeof(struct virtio_blk_config);
>> +
>> +    return size;
>
> I'm not familiar with the ifcvf details, but can it happen that the 
> device is not block or net?
>
> Should we set `size` to 0 by default to handle this case or are we 
> sure it's one of the two?
>
> Maybe we should add a comment or a warning message in this case, to 
> prevent some analysis tool or compiler from worrying that `size` might 
> be uninitialized.
>
> I was thinking something like this:
>
>     switch(vf->dev_type) {
>     case VIRTIO_ID_NET:
>         size = sizeof(struct virtio_net_config);
>         break;
>     case VIRTIO_ID_BLOCK:
>         size = sizeof(struct virtio_blk_config);
>         break;
>     default:
>         /* or WARN(1, "") if dev_warn() not apply */
>         dev_warn(... , "virtio ID [0x%x] not supported\n")
>         size = 0;
>
>     }
>

Yes, I agree.

Thanks


> Thanks,
> Stefano
>

