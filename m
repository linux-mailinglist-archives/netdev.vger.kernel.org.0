Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905A9BC9B7
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395495AbfIXOEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392022AbfIXOEX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 10:04:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A2E420F0;
        Tue, 24 Sep 2019 14:04:22 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6E5960C5E;
        Tue, 24 Sep 2019 14:04:13 +0000 (UTC)
Date:   Tue, 24 Sep 2019 08:04:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        tiwei.bie@intel.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, idos@mellanox.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com
Subject: Re: [PATCH 5/6] vringh: fix copy direction of
 vringh_iov_push_kern()
Message-ID: <20190924080413.0cc875c5@x1.home>
In-Reply-To: <20190923115930-mutt-send-email-mst@kernel.org>
References: <20190923130331.29324-1-jasowang@redhat.com>
        <20190923130331.29324-6-jasowang@redhat.com>
        <20190923094559.765da494@x1.home>
        <20190923115930-mutt-send-email-mst@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 24 Sep 2019 14:04:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Sep 2019 12:00:41 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Mon, Sep 23, 2019 at 09:45:59AM -0600, Alex Williamson wrote:
> > On Mon, 23 Sep 2019 21:03:30 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> >   
> > > We want to copy from iov to buf, so the direction was wrong.
> > > 
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/vhost/vringh.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)  
> > 
> > 
> > Why is this included in the series?  Seems like an unrelated fix being
> > held up within a proposal for a new feature.  Thanks,
> > 
> > Alex  
> 
> It's better to have it as patch 1/6, but it's a dependency of the
> example driver in the series. I can reorder when I apply.

It's a fix, please submit it separately through virtio/vhost channels,
then it will already be in the base kernel we use for the rest of the
series.  The remainder of the series certainly suggests a workflow
through the vfio tree rather than virtio/vhost.  Thanks,

Alex

> > > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > > index 08ad0d1f0476..a0a2d74967ef 100644
> > > --- a/drivers/vhost/vringh.c
> > > +++ b/drivers/vhost/vringh.c
> > > @@ -852,6 +852,12 @@ static inline int xfer_kern(void *src, void *dst, size_t len)
> > >  	return 0;
> > >  }
> > >  
> > > +static inline int kern_xfer(void *dst, void *src, size_t len)
> > > +{
> > > +	memcpy(dst, src, len);
> > > +	return 0;
> > > +}
> > > +
> > >  /**
> > >   * vringh_init_kern - initialize a vringh for a kernelspace vring.
> > >   * @vrh: the vringh to initialize.
> > > @@ -958,7 +964,7 @@ EXPORT_SYMBOL(vringh_iov_pull_kern);
> > >  ssize_t vringh_iov_push_kern(struct vringh_kiov *wiov,
> > >  			     const void *src, size_t len)
> > >  {
> > > -	return vringh_iov_xfer(wiov, (void *)src, len, xfer_kern);
> > > +	return vringh_iov_xfer(wiov, (void *)src, len, kern_xfer);
> > >  }
> > >  EXPORT_SYMBOL(vringh_iov_push_kern);
> > >    

