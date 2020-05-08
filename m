Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5E11CB41C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgEHPzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:55:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41799 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727815AbgEHPzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588953315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o2NuVDMsNek1XqDZ23KXOT0aYU3U9mtuti+eij0cQ3Y=;
        b=RH/5e3x/Aznsbd5AM1J6BO+2cqjJRQKQ+ghv58yZ4onqXKu52Yll3jfDrYllFqRXnZ0nKO
        3f2rtaNllTzDrvWbaSRolJ2itxGSdcZE0opMh4qcFX2KXuNbcI3CtqooBvkUkAiwE+/gsb
        us/8o0UifSojcAi6TAgXtPfpSD3kH2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-tB1ktjf7Nd6ZDjXX8AJRsw-1; Fri, 08 May 2020 11:55:11 -0400
X-MC-Unique: tB1ktjf7Nd6ZDjXX8AJRsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59A41107ACCA;
        Fri,  8 May 2020 15:55:09 +0000 (UTC)
Received: from w520.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 615F6341E3;
        Fri,  8 May 2020 15:55:08 +0000 (UTC)
Date:   Fri, 8 May 2020 09:55:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 08/12] vfio: use __anon_inode_getfd
Message-ID: <20200508095507.54051943@w520.home>
In-Reply-To: <20200508153634.249933-9-hch@lst.de>
References: <20200508153634.249933-1-hch@lst.de>
        <20200508153634.249933-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 May 2020 17:36:30 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Use __anon_inode_getfd instead of opencoding the logic using
> get_unused_fd_flags + anon_inode_getfile.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 37 ++++++++-----------------------------
>  1 file changed, 8 insertions(+), 29 deletions(-)


Thanks!

Acked-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 765e0e5d83ed9..33a88103f857f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1451,42 +1451,21 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
>  		return ret;
>  	}
>  
> -	/*
> -	 * We can't use anon_inode_getfd() because we need to modify
> -	 * the f_mode flags directly to allow more than just ioctls
> -	 */
> -	ret = get_unused_fd_flags(O_CLOEXEC);
> -	if (ret < 0) {
> -		device->ops->release(device->device_data);
> -		vfio_device_put(device);
> -		return ret;
> -	}
> -
> -	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
> -				   device, O_RDWR);
> -	if (IS_ERR(filep)) {
> -		put_unused_fd(ret);
> -		ret = PTR_ERR(filep);
> -		device->ops->release(device->device_data);
> -		vfio_device_put(device);
> -		return ret;
> -	}
> -
> -	/*
> -	 * TODO: add an anon_inode interface to do this.
> -	 * Appears to be missing by lack of need rather than
> -	 * explicitly prevented.  Now there's need.
> -	 */
> +	ret = __anon_inode_getfd("[vfio-device]", &vfio_device_fops,
> +				   device, O_CLOEXEC | O_RDWR, &filep);
> +	if (ret < 0)
> +		goto release;
>  	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
> -
>  	atomic_inc(&group->container_users);
> -
>  	fd_install(ret, filep);
>  
>  	if (group->noiommu)
>  		dev_warn(device->dev, "vfio-noiommu device opened by user "
>  			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> -
> +	return ret;
> +release:
> +	device->ops->release(device->device_data);
> +	vfio_device_put(device);
>  	return ret;
>  }
>  

