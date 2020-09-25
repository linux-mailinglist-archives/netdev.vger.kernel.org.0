Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD172785C6
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgIYL1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:27:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726255AbgIYL1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 07:27:41 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601033255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIYjG/eOf0A02Qd+6Up4W+Jt7X/3F3zVaDbUU4OQaQY=;
        b=Q+S1EPK0lsQMmRlut3qUcYdf0X48B4SgW5ds+P5+VH7ZXjCKU8+AXkN0R/bx5MHUOABSZy
        XhUYs5pWyq+N65gg5MNQzxpbL+NOk+6T3HapKPgQ85AAbnkIBT8Cg/O5ubvQ9JdOsDdk2N
        PFzfxWZnFgKpt/8kmN9tukqvzzKRu10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-z4Vu6R3RNealyVJDGYbeXg-1; Fri, 25 Sep 2020 07:27:33 -0400
X-MC-Unique: z4Vu6R3RNealyVJDGYbeXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD02A88EF0E;
        Fri, 25 Sep 2020 11:27:31 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 930765D9F7;
        Fri, 25 Sep 2020 11:27:15 +0000 (UTC)
Subject: Re: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-3-jasowang@redhat.com>
 <20200924053119-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c2f3c4a3-604f-ad27-d34d-a829446a3c7e@redhat.com>
Date:   Fri, 25 Sep 2020 19:27:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924053119-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/24 下午5:31, Michael S. Tsirkin wrote:
> On Thu, Sep 24, 2020 at 11:21:03AM +0800, Jason Wang wrote:
>> We need to free vqs during the err path after it has been allocated
>> since vhost won't do that for us.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> This is a bugfix too right? I don't see it posted separately ...


A patch that is functional equivalent is posted here:

https://www.mail-archive.com/virtualization@lists.linux-foundation.org/msg42558.html

I'm a little bit lazy to use that one since this patch is probably wrote 
before that one.

Thanks


>
>> ---
>>   drivers/vhost/vdpa.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 796fe979f997..9c641274b9f3 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -764,6 +764,12 @@ static void vhost_vdpa_free_domain(struct vhost_vdpa *v)
>>   	v->domain = NULL;
>>   }
>>   
>> +static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
>> +{
>> +	vhost_dev_cleanup(&v->vdev);
>> +	kfree(v->vdev.vqs);
>> +}
>> +
>>   static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>   {
>>   	struct vhost_vdpa *v;
>> @@ -809,7 +815,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>>   	return 0;
>>   
>>   err_init_iotlb:
>> -	vhost_dev_cleanup(&v->vdev);
>> +	vhost_vdpa_cleanup(v);
>>   err:
>>   	atomic_dec(&v->opened);
>>   	return r;
>> @@ -840,8 +846,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>>   	vhost_vdpa_free_domain(v);
>>   	vhost_vdpa_config_put(v);
>>   	vhost_vdpa_clean_irq(v);
>> -	vhost_dev_cleanup(&v->vdev);
>> -	kfree(v->vdev.vqs);
>> +	vhost_vdpa_cleanup(v);
>>   	mutex_unlock(&d->mutex);
>>   
>>   	atomic_dec(&v->opened);
>> -- 
>> 2.20.1

