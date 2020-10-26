Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6832985B8
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 04:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421648AbgJZC7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:59:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389452AbgJZC7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 22:59:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603681187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wj4XKzYinjtinYOa4SEH9Db7ssmjPWw3m5dgQvIRbIo=;
        b=dxEFla1r0HXUGjU8Zgvx50F9mjy+oo1k2K53H2Gn0tky06aAVnYLwurqdKN82nBXxaQ/Ae
        tlRMJbKSv/QSfWN7xfQTAQQIRbqlqAmcDPSqdx0oDQWNL4CFGBXcGOVPkiecxj4mbI0gJO
        q4uaIYndUZVxUqfnSqT7IoMszH/82PM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-SsQjknsqOSaucbGw5t__FQ-1; Sun, 25 Oct 2020 22:59:45 -0400
X-MC-Unique: SsQjknsqOSaucbGw5t__FQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E8121006C81;
        Mon, 26 Oct 2020 02:59:44 +0000 (UTC)
Received: from [10.72.13.201] (ovpn-13-201.pek2.redhat.com [10.72.13.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F012E55769;
        Mon, 26 Oct 2020 02:59:38 +0000 (UTC)
Subject: Re: [PATCH net] vhost_vdpa: Return -EFUALT if copy_from_user() fails
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kuba@kernel.org
References: <20201023120853.GI282278@mwanda>
 <20201023113326-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4485cc8d-ac69-c725-8493-eda120e29c41@redhat.com>
Date:   Mon, 26 Oct 2020 10:59:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201023113326-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/23 下午11:34, Michael S. Tsirkin wrote:
> On Fri, Oct 23, 2020 at 03:08:53PM +0300, Dan Carpenter wrote:
>> The copy_to/from_user() functions return the number of bytes which we
>> weren't able to copy but the ioctl should return -EFAULT if they fail.
>>
>> Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Needed for stable I guess.


Agree.

Acked-by: Jason Wang <jasowang@redhat.com>


>> ---
>>   drivers/vhost/vdpa.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 62a9bb0efc55..c94a97b6bd6d 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -428,12 +428,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>   	void __user *argp = (void __user *)arg;
>>   	u64 __user *featurep = argp;
>>   	u64 features;
>> -	long r;
>> +	long r = 0;
>>   
>>   	if (cmd == VHOST_SET_BACKEND_FEATURES) {
>> -		r = copy_from_user(&features, featurep, sizeof(features));
>> -		if (r)
>> -			return r;
>> +		if (copy_from_user(&features, featurep, sizeof(features)))
>> +			return -EFAULT;
>>   		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
>>   			return -EOPNOTSUPP;
>>   		vhost_set_backend_features(&v->vdev, features);
>> @@ -476,7 +475,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>   		break;
>>   	case VHOST_GET_BACKEND_FEATURES:
>>   		features = VHOST_VDPA_BACKEND_FEATURES;
>> -		r = copy_to_user(featurep, &features, sizeof(features));
>> +		if (copy_to_user(featurep, &features, sizeof(features)))
>> +			r = -EFAULT;
>>   		break;
>>   	default:
>>   		r = vhost_dev_ioctl(&v->vdev, cmd, argp);

