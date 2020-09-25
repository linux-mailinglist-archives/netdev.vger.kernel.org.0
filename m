Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF34278621
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 13:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgIYLmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 07:42:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35758 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728038AbgIYLmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 07:42:00 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601034119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4y1m9JMkkDOJsL4k1JE6OPASJ9H32SGI/WQkPFQ5hvU=;
        b=iwexTabAGU0b08pCHODieUbpJaDJQ0KpLNaRgJ0ARiqdRRtjqpfTMtRVqIcAww0mWfxbZw
        Xx855XAMsBx6PiF9dKfJ2O1cwFUGJsPzct7pzH/wrIcQsZALQK93CarRlB80uqJxT06ra2
        wyo2jnr37Oz+usIr7nacEQSwmsjeoZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-oSmASuxLNzWLqtK_WBmrYA-1; Fri, 25 Sep 2020 07:41:55 -0400
X-MC-Unique: oSmASuxLNzWLqtK_WBmrYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6C8B1007382;
        Fri, 25 Sep 2020 11:41:53 +0000 (UTC)
Received: from [10.72.12.44] (ovpn-12-44.pek2.redhat.com [10.72.12.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5FB527BB7;
        Fri, 25 Sep 2020 11:41:38 +0000 (UTC)
Subject: Re: [RFC PATCH 02/24] vhost-vdpa: fix vqs leak in vhost_vdpa_open()
To:     Eli Cohen <elic@nvidia.com>
Cc:     mst@redhat.com, lulu@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.miller@broadcom.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, hanand@xilinx.com,
        mhabets@solarflare.com, eli@mellanox.com, amorenoz@redhat.com,
        maxime.coquelin@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com
References: <20200924032125.18619-1-jasowang@redhat.com>
 <20200924032125.18619-3-jasowang@redhat.com>
 <20200924074816.GC170403@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7237334f-10df-6d5b-dce9-c16b38166ae0@redhat.com>
Date:   Fri, 25 Sep 2020 19:41:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200924074816.GC170403@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/24 下午3:48, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 11:21:03AM +0800, Jason Wang wrote:
>> We need to free vqs during the err path after it has been allocated
>> since vhost won't do that for us.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
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
> Wouldn't it be cleaner to call kfree(vqs) explicilty inside
> vhost_vdpa_open() in case of failure and keep the symetry of
> vhost_dev_init()/vhost_dev_cleanup()?


That's also fine.

See 
https://www.mail-archive.com/virtualization@lists.linux-foundation.org/msg42558.html

I will use that for the next version.

Thanks.


>
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
>>

