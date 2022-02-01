Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7284A5C0C
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiBAMSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:34259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbiBAMSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643717926;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p80pVCK1gXrI3n6sSmbbOeR3VX7jDC7zAMezgnAoQu4=;
        b=Jl22SBJYoSf2l8qkQ+14/ZJkip1Is3AKBW/1qY8HXMM097aVZiZWCfclprgXyR0pVezIeO
        rnjjZBxKzV68/Vwnw29Es1HBnCRGebWjEqN2F9ZG0vUw7xLPg0v1Ip6W63LNE/OEM02lsQ
        zUU/0IExeiiPQ8lq7D52el8Xa+DSmoQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-663-NnFqnMasO1uOD2aPCalypw-1; Tue, 01 Feb 2022 07:18:41 -0500
X-MC-Unique: NnFqnMasO1uOD2aPCalypw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DAB21966321;
        Tue,  1 Feb 2022 12:18:40 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B86570384;
        Tue,  1 Feb 2022 12:18:31 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220201121041.GA1786498@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com> <87y22uyen8.fsf@redhat.com>
 <20220201121041.GA1786498@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 13:18:29 +0100
Message-ID: <87v8xyye3u.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 01:06:51PM +0100, Cornelia Huck wrote:
>> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
>> 
>> > @@ -1582,6 +1760,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>> >  		return -EINVAL;
>> >  
>> >  	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
>> > +	case VFIO_DEVICE_FEATURE_MIGRATION:
>> > +		return vfio_ioctl_device_feature_migration(
>> > +			device, feature.flags, arg->data,
>> > +			feature.argsz - minsz);
>> >  	default:
>> >  		if (unlikely(!device->ops->device_feature))
>> >  			return -EINVAL;
>> > @@ -1597,6 +1779,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>> >  	struct vfio_device *device = filep->private_data;
>> >  
>> >  	switch (cmd) {
>> > +	case VFIO_DEVICE_MIG_SET_STATE:
>> > +		return vfio_ioctl_mig_set_state(device, (void __user *)arg);
>> >  	case VFIO_DEVICE_FEATURE:
>> >  		return vfio_ioctl_device_feature(device, (void __user *)arg);
>> >  	default:
>> 
>> Not really a critique of this patch, but have we considered how mediated
>> devices will implement migration?
>
> Yes
>
>> I.e. what parts of the ops will need to be looped through the mdev
>> ops?
>
> I've deleted mdev ops in every driver except the intel vgpu, once
> Christoph's patch there is merged mdev ops will be almost gone
> completely.

Ok, if there's nothing left to do, that's fine. (I'm assuming that the
Intel vgpu patch is on its way in? I usually don't keep track of things
I'm not directly involved with.)

