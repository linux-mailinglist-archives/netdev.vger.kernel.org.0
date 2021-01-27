Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D3F3050F5
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239189AbhA0Eci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:32:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236483AbhA0Dev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 22:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611718404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mP/fMR1bI+k0zNRDvvWBuMv6uUuCjAv3+TKblysN3yY=;
        b=gd37cK7MRRRKVGgyUc5sy0suDEUXMu1dK2h/fcllqOo2/jbmqzuxAlzA4Vm9jzRoPTZUEs
        cvQpXHjzy9/Od4bWm1gPKp34jAKTXzjOH2mvG2M/PB6rn/LWXSAbP6rQfgcjiVNeAplRE1
        yaMlgtbTHl/W+tvaYK7EKiD+ot6B/qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-h0jZK0l6NYKMj4AJ1_KZWg-1; Tue, 26 Jan 2021 22:33:19 -0500
X-MC-Unique: h0jZK0l6NYKMj4AJ1_KZWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36E2E10054FF;
        Wed, 27 Jan 2021 03:33:17 +0000 (UTC)
Received: from [10.72.13.33] (ovpn-13-33.pek2.redhat.com [10.72.13.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F0C26F92A;
        Wed, 27 Jan 2021 03:33:04 +0000 (UTC)
Subject: Re: [RFC v3 03/11] vdpa: Remove the restriction that only supports
 virtio-net devices
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, stefanha@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119045920.447-4-xieyongji@bytedance.com>
 <310d7793-e4ff-fba3-f358-418cb64c7988@redhat.com>
 <20210120110832.oijcmywq7pf7psg3@steredhat>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1979cffc-240e-a9f9-b0ab-84a1f82ac81e@redhat.com>
Date:   Wed, 27 Jan 2021 11:33:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210120110832.oijcmywq7pf7psg3@steredhat>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/20 下午7:08, Stefano Garzarella wrote:
> On Wed, Jan 20, 2021 at 11:46:38AM +0800, Jason Wang wrote:
>>
>> On 2021/1/19 下午12:59, Xie Yongji wrote:
>>> With VDUSE, we should be able to support all kinds of virtio devices.
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> ---
>>>  drivers/vhost/vdpa.c | 29 +++--------------------------
>>>  1 file changed, 3 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>> index 29ed4173f04e..448be7875b6d 100644
>>> --- a/drivers/vhost/vdpa.c
>>> +++ b/drivers/vhost/vdpa.c
>>> @@ -22,6 +22,7 @@
>>>  #include <linux/nospec.h>
>>>  #include <linux/vhost.h>
>>>  #include <linux/virtio_net.h>
>>> +#include <linux/virtio_blk.h>
>>>  #include "vhost.h"
>>> @@ -185,26 +186,6 @@ static long vhost_vdpa_set_status(struct 
>>> vhost_vdpa *v, u8 __user *statusp)
>>>      return 0;
>>>  }
>>> -static int vhost_vdpa_config_validate(struct vhost_vdpa *v,
>>> -                      struct vhost_vdpa_config *c)
>>> -{
>>> -    long size = 0;
>>> -
>>> -    switch (v->virtio_id) {
>>> -    case VIRTIO_ID_NET:
>>> -        size = sizeof(struct virtio_net_config);
>>> -        break;
>>> -    }
>>> -
>>> -    if (c->len == 0)
>>> -        return -EINVAL;
>>> -
>>> -    if (c->len > size - c->off)
>>> -        return -E2BIG;
>>> -
>>> -    return 0;
>>> -}
>>
>>
>> I think we should use a separate patch for this.
>
> For the vdpa-blk simulator I had the same issues and I'm adding a 
> .get_config_size() callback to vdpa devices.
>
> Do you think make sense or is better to remove this check in 
> vhost/vdpa, delegating the boundaries checks to get_config/set_config 
> callbacks.


A question here. How much value could we gain from get_config_size() 
consider we can let vDPA parent to validate the length in its get_config().

Thanks


>
> Thanks,
> Stefano
>

