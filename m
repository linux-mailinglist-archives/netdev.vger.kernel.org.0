Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF78287D17
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbgJHU2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:28:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730371AbgJHU2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:28:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602188927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=caF6a1MKbmv3Qw+xnDNzTfS/1KBH8aRkP9njZDRX0Fs=;
        b=Qd5ylcDy34T5Glzjuzewf2bUMz+zA6reHTYuBQ8kHWRz+aEJSe/nplZP5/9rDoYgYdFNxy
        pHDzXqj2DcD5qWETS7WZ935vH2LBh1EhXBvYCxRggyjMkOkC33e8sAma3dYmbWOMaSCZgX
        tJ1NFKz6wCCWcAO99msgH0wWGVQkaIs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-K37Gnl6uOrerpTfBwVlYLA-1; Thu, 08 Oct 2020 16:28:45 -0400
X-MC-Unique: K37Gnl6uOrerpTfBwVlYLA-1
Received: by mail-wr1-f69.google.com with SMTP id 33so4315541wrk.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:28:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=caF6a1MKbmv3Qw+xnDNzTfS/1KBH8aRkP9njZDRX0Fs=;
        b=lr4DWhD5lYq1ubcsK0qGrWAzBA3o7jfBzpy+uUOo807gQRh1E6AdMiKdNRg+KsELZK
         DGaKqDiFIJDF1v031Ce2uR8Im6I7d5Q0tp8ewsPAzvxW7mM1bMwv/cdmo9z5agWkSDeJ
         6e9uHqWwBIYBWLdh7yQHLgKKZ8Q2NI/nUdX/JFYWCJy5lj398yNFnxDTgGT89BHdtxP3
         xX5Af9FuPm0pJPt/jUesKMFuCeZNvJlBDMd5bpyUa9kHJUVmKSfIQODrl/IvHaWE3zum
         2e5TxayP3qIkle4AQRd15txrCUkcAR+QhDEsMjuajOO33G2ISpqYZ4JCOQzbgIMN74vY
         RCEA==
X-Gm-Message-State: AOAM533Tk94MgQfEYW96AXDpe2icoSXQCoCpsWam/5f9QdKPfyJOobYM
        iusuF3dzFUJjJOvCO358eD11uT1BiVxVkp3pYBR0eamnfPCTZR375wvTl4PchylqLabmb/MR1jq
        6oRatc/9Z8fTRI5Ks
X-Received: by 2002:adf:9124:: with SMTP id j33mr11087554wrj.272.1602188923790;
        Thu, 08 Oct 2020 13:28:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzh5A/5Z709VFadlr4JMrgafEqB5aQH7y0RpPTVbx0qmRWUq9A9IgbF5HNIuV7k7UKGbJOfFw==
X-Received: by 2002:adf:9124:: with SMTP id j33mr11087542wrj.272.1602188923600;
        Thu, 08 Oct 2020 13:28:43 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id w11sm8605695wrn.27.2020.10.08.13.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:28:42 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:28:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201008162813-mutt-send-email-mst@kernel.org>
References: <20201008161311.114398-1-sgarzare@redhat.com>
 <20201008160035-mutt-send-email-mst@kernel.org>
 <20201008202436.r33jqbbttqynfvhe@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008202436.r33jqbbttqynfvhe@steredhat>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 10:24:36PM +0200, Stefano Garzarella wrote:
> On Thu, Oct 08, 2020 at 04:00:51PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Oct 08, 2020 at 06:13:11PM +0200, Stefano Garzarella wrote:
> > > If riov and wiov are both defined and they point to different
> > > objects, only riov is initialized. If the wiov is not initialized
> > > by the caller, the function fails returning -EINVAL and printing
> > > "Readable desc 0x... after writable" error message.
> > > 
> > > Let's replace the 'else if' clause with 'if' to initialize both
> > > riov and wiov if they are not NULL.
> > > 
> > > As checkpatch pointed out, we also avoid crashing the kernel
> > > when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> > > and returning -EINVAL.
> > > 
> > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > Can you add more detail please? when does this trigger?
> 
> I'm developing vdpa_sim_blk and I'm using vringh_getdesc_iotlb()
> to get readable and writable buffers.
> 
> With virtio-blk devices a descriptors has both readable and writable
> buffers (eg. virtio_blk_outhdr in the readable buffer and status as last byte
> of writable buffer).
> So, I'm calling vringh_getdesc_iotlb() one time to get both type of buffer
> and put them in 2 iovecs:
> 
> 	ret = vringh_getdesc_iotlb(&vq->vring, &vq->riov, &vq->wiov,
> 				   &vq->head, GFP_ATOMIC);
> 
> With this patch applied it works well, without the function fails
> returning -EINVAL and printing "Readable desc 0x... after writable".
> 
> Am I using vringh_getdesc_iotlb() in the wrong way?
> 
> Thanks,
> Stefano
> 


I think it's ok, this info just needs to be in the commit log ...

> > > ---
> > >  drivers/vhost/vringh.c | 9 +++++----
> > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index e059a9a47cdf..8bd8b403f087 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -284,13 +284,14 @@ __vringh_iov(struct vringh *vrh, u16 i,
> > >  	desc_max = vrh->vring.num;
> > >  	up_next = -1;
> > >  
> > > +	/* You must want something! */
> > > +	if (WARN_ON(!riov && !wiov))
> > > +		return -EINVAL;
> > > +
> > >  	if (riov)
> > >  		riov->i = riov->used = 0;
> > > -	else if (wiov)
> > > +	if (wiov)
> > >  		wiov->i = wiov->used = 0;
> > > -	else
> > > -		/* You must want something! */
> > > -		BUG();
> > >  
> > >  	for (;;) {
> > >  		void *addr;
> > > -- 
> > > 2.26.2
> > 

