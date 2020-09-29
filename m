Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C070F27BE4E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgI2Hpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:45:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726431AbgI2Hpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:45:36 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601365535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1+9sAOtKEe29ld0FF+l1aCaoyNACbHHQtUzJc8aMjXk=;
        b=O7ST8MYJmV2EG79T8SPQkK/jqpjYKsJB2DRgKSEJVSB2IZl/mEaSIbwwwcaSieQ7rK16zg
        kU13ClJjq2U/gbG+NEBFhR6m7SNnifxzsEYM0G0N6GvWbxLi+XjCGHR6xsyYYs73YYSzCW
        1S9JLgiKmjojTNm7/TXxqZnXJGXelto=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-ApL0Lz-nMiSYz5iFUo_1wA-1; Tue, 29 Sep 2020 03:45:33 -0400
X-MC-Unique: ApL0Lz-nMiSYz5iFUo_1wA-1
Received: by mail-wm1-f71.google.com with SMTP id l15so1471604wmh.9
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 00:45:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1+9sAOtKEe29ld0FF+l1aCaoyNACbHHQtUzJc8aMjXk=;
        b=FXOuORe1McwdMD8K5NjCKtMoj7Ei7UzrMbHuU2cosg93+mOzV8Q2Bjnt2GTGEaJeYB
         sgXio06A9H8OFOwRE7owFkysI1mDO2tJyWqah53ym658NnqIUgsxMDbtigTdvu6mgL+2
         RMGkgt02N3ooz5pXIADHMHWf3kRS2N9IXOT9/aIosXy8zDmlHHS6TgyA0c+S6A0eEpjP
         FbZGa6xf9nPZuSzLaCIudOmk7tVFAe5oao2XxVHgyQ2sPQrmtrPNX9IaM5fOFRwsWsrP
         hEWc1BFyRIxN205jede2GsN2h5+0O3wu+brP7iJ2YkFuiGut/oQn2/S3qUKw0Q3gTQOk
         v10Q==
X-Gm-Message-State: AOAM533QJEa/sbfbJkEOg3igjoK5b/ojHZhvsPwhp7Cf5bmxuS390seM
        a3OyQytfvSu+qFiumXYasd/JDgATy5WmsMNy9slSIy5RFBQ/3AeY4c2/Z7GCmnu7GnS+MVYcniZ
        IuFqppyXLW+3kN1bf
X-Received: by 2002:a1c:1bd1:: with SMTP id b200mr3149919wmb.171.1601365531986;
        Tue, 29 Sep 2020 00:45:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyVXyN8T+1pYGTvhFLvLpxttwSL6WyYHVFkUGy5/+wp03N2mwSfIfnBECxhR1qh6UyzNKksMQ==
X-Received: by 2002:a1c:1bd1:: with SMTP id b200mr3149899wmb.171.1601365531746;
        Tue, 29 Sep 2020 00:45:31 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id z11sm4729299wru.88.2020.09.29.00.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 00:45:30 -0700 (PDT)
Date:   Tue, 29 Sep 2020 03:45:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Greg Kurz <groug@kaod.org>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] vhost: Don't call vq_access_ok() when using IOTLB
Message-ID: <20200929034358-mutt-send-email-mst@kernel.org>
References: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160129650442.480158.12085353517983890660.stgit@bahia.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 02:35:04PM +0200, Greg Kurz wrote:
> When the IOTLB device is enabled, the vring addresses we get from
> userspace are GIOVAs. It is thus wrong to pass them to vq_access_ok()
> which only takes HVAs. The IOTLB map is likely empty at this stage,
> so there isn't much that can be done with these GIOVAs. Access validation
> will be performed at IOTLB prefetch time anyway.
> 
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
> Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
> Cc: jasowang@redhat.com
> CC: stable@vger.kernel.org # 4.14+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  drivers/vhost/vhost.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..6296e33df31d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1509,7 +1509,10 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>  	 * If it is not, we don't as size might not have been setup.
>  	 * We will verify when backend is configured. */
>  	if (vq->private_data) {
> -		if (!vq_access_ok(vq, vq->num,
> +		/* If an IOTLB device is present, the vring addresses are
> +		 * GIOVAs. Access will be validated during IOTLB prefetch. */
> +		if (!vq->iotlb &&
> +		    !vq_access_ok(vq, vq->num,
>  			(void __user *)(unsigned long)a.desc_user_addr,
>  			(void __user *)(unsigned long)a.avail_user_addr,
>  			(void __user *)(unsigned long)a.used_user_addr))

OK I think you are right here.

Jason, can you ack pls?

However, I think a cleaner way to check this is by moving
the following check from vhost_vq_access_ok to vq_access_ok:

        /* Access validation occurs at prefetch time with IOTLB */
        if (vq->iotlb)
                return true;


> 

