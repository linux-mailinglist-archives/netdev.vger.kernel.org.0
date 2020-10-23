Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83468297260
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465906AbgJWPeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 11:34:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S462662AbgJWPeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 11:34:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603467276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ADAkD04qBn0B56sR0AT6lBpOwDqugN8IZrafwTxz76g=;
        b=eG88lGXGygBi0iqfHOorbRDDY27yfRke7h7SuhIx5J+3s3D7Sj9XcAYe5KWu3lZexvsPg1
        gjI+61y10+4t4AVLL0rHMU/bK572E41XqhIcZC+N0oDWmlKPs2JEBNVHLFbJpdhTu1oxx+
        kF9kabttyc4w2LA//lLWoFi5h1FAl4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-6fLU9xqyN5Wrrt4Zl_bywg-1; Fri, 23 Oct 2020 11:34:33 -0400
X-MC-Unique: 6fLU9xqyN5Wrrt4Zl_bywg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB22818B9F09;
        Fri, 23 Oct 2020 15:34:31 +0000 (UTC)
Received: from redhat.com (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C41070597;
        Fri, 23 Oct 2020 15:34:28 +0000 (UTC)
Date:   Fri, 23 Oct 2020 11:34:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] vhost_vdpa: Return -EFUALT if copy_from_user() fails
Message-ID: <20201023113326-mutt-send-email-mst@kernel.org>
References: <20201023120853.GI282278@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023120853.GI282278@mwanda>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 03:08:53PM +0300, Dan Carpenter wrote:
> The copy_to/from_user() functions return the number of bytes which we
> weren't able to copy but the ioctl should return -EFAULT if they fail.
> 
> Fixes: a127c5bbb6a8 ("vhost-vdpa: fix backend feature ioctls")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Needed for stable I guess.

> ---
>  drivers/vhost/vdpa.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 62a9bb0efc55..c94a97b6bd6d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -428,12 +428,11 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  	void __user *argp = (void __user *)arg;
>  	u64 __user *featurep = argp;
>  	u64 features;
> -	long r;
> +	long r = 0;
>  
>  	if (cmd == VHOST_SET_BACKEND_FEATURES) {
> -		r = copy_from_user(&features, featurep, sizeof(features));
> -		if (r)
> -			return r;
> +		if (copy_from_user(&features, featurep, sizeof(features)))
> +			return -EFAULT;
>  		if (features & ~VHOST_VDPA_BACKEND_FEATURES)
>  			return -EOPNOTSUPP;
>  		vhost_set_backend_features(&v->vdev, features);
> @@ -476,7 +475,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>  		break;
>  	case VHOST_GET_BACKEND_FEATURES:
>  		features = VHOST_VDPA_BACKEND_FEATURES;
> -		r = copy_to_user(featurep, &features, sizeof(features));
> +		if (copy_to_user(featurep, &features, sizeof(features)))
> +			r = -EFAULT;
>  		break;
>  	default:
>  		r = vhost_dev_ioctl(&v->vdev, cmd, argp);

