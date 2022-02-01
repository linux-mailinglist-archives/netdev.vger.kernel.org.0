Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9803C4A5BDD
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237745AbiBAMHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:07:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237585AbiBAMG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643717218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lqxgPfRTdQipPkPYZsZgmVQEbuVRLygE82y+uWGakJI=;
        b=FV067d9+8kzLm6sNa7K15rgcTE9pc8/qo9jAtWaTM3gapRBwFOkpU815dvz+M+6PkCuq/U
        GcpwP8dhqELXvAhJ/jnDA0jL9bnjCy8qJ18AwyynR89Nlr9fuB65NcLK1B8fwuP+KjjMzO
        j03kdvXgoiVUjv9N7BBtEYFk7eHcr8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-344-IjW4YP0yPFaVZwo0Yj1jtA-1; Tue, 01 Feb 2022 07:06:55 -0500
X-MC-Unique: IjW4YP0yPFaVZwo0Yj1jtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B26985EE60;
        Tue,  1 Feb 2022 12:06:54 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2E51108F845;
        Tue,  1 Feb 2022 12:06:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220130160826.32449-9-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 13:06:51 +0100
Message-ID: <87y22uyen8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> @@ -1582,6 +1760,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
>  		return -EINVAL;
>  
>  	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> +	case VFIO_DEVICE_FEATURE_MIGRATION:
> +		return vfio_ioctl_device_feature_migration(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
>  	default:
>  		if (unlikely(!device->ops->device_feature))
>  			return -EINVAL;
> @@ -1597,6 +1779,8 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = filep->private_data;
>  
>  	switch (cmd) {
> +	case VFIO_DEVICE_MIG_SET_STATE:
> +		return vfio_ioctl_mig_set_state(device, (void __user *)arg);
>  	case VFIO_DEVICE_FEATURE:
>  		return vfio_ioctl_device_feature(device, (void __user *)arg);
>  	default:

Not really a critique of this patch, but have we considered how mediated
devices will implement migration?

I.e. what parts of the ops will need to be looped through the mdev ops?
Do we need to consider the scope of some queries/operations (whole
device vs subdivisions etc.)? Not trying to distract from the whole new
interface here, but I think we should have at least an idea.

