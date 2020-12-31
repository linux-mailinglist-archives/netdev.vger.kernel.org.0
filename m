Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5352E7DB5
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 03:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgLaCil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 21:38:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbgLaCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 21:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609382234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bT6v+Ec3+GbfoduwGKdxSsf6srhaUGcfdLab8NVdm2s=;
        b=O4BPz8IiqhYfWBhividbbnNVC0Nt2u7axhnTtpAaJ8f/NGa/7Jm8ycgDxY0z54A8yUZISq
        wCZY+vq+9UTwcVJgMXOtaycYej6qPt8Ndm7zyUCU71V4mZwGBATtOXSQfTMyD2//3f4awL
        gt83u3bQcSQiXxBJV8BJtDtrQ+pPv+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-GeJektIsNXyPt9-_fNw6JQ-1; Wed, 30 Dec 2020 21:37:12 -0500
X-MC-Unique: GeJektIsNXyPt9-_fNw6JQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D02418030A1;
        Thu, 31 Dec 2020 02:37:10 +0000 (UTC)
Received: from [10.72.12.236] (ovpn-12-236.pek2.redhat.com [10.72.12.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4058D60BE2;
        Thu, 31 Dec 2020 02:36:59 +0000 (UTC)
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
 <20201230100506.GB5241@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c3fe570c-6130-c8c8-1209-54e2120d93f0@redhat.com>
Date:   Thu, 31 Dec 2020 10:36:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201230100506.GB5241@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/30 下午6:05, Eli Cohen wrote:
> On Wed, Dec 16, 2020 at 02:48:09PM +0800, Jason Wang wrote:
>> Follows the vDPA support for multiple address spaces, this patch
>> introduce uAPI for the userspace to know the number of virtqueue
>> groups supported by the vDPA device.
>>
>> Signed-off-by: Jason Wang<jasowang@redhat.com>
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
> Is this and other ioctls already supported in qemu?


Not yet, the prototype is under development.

I test the series with a small and dedicated userspace program.

Thanks


>

