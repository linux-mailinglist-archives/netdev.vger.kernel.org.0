Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D097D39557C
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhEaGdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhEaGdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 02:33:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A17661002;
        Mon, 31 May 2021 06:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622442730;
        bh=/Rpow5pd3vI3QDiPLujMq5XYut4dwN7beksCj+Osmiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VafGWsZBf8JY9hyaPQA2lYDCFBVOsJdxrXv6Ao4UOn9xAR5q75AQDEMjMNgdMIEZB
         6dFZCv8k/YU22mPbGQ6Yw0mZr/cbVfo08aoF91SsFjWMAMKhxQobvj8iQhm6dPrCXu
         ZdZKoa1KQCAFM7bTKNo/9xjeEFXT3xPGBt94IdM4=
Date:   Mon, 31 May 2021 08:32:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in
 Userspace
Message-ID: <YLSC6AthAl+VeQsv@kroah.com>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-12-xieyongji@bytedance.com>
 <YLRsehBRAiCJEDl0@kroah.com>
 <CACycT3vRHPfOGxmy1Uv=8_dqqq8iG4YTZHUizo+y8EYKGS5g8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vRHPfOGxmy1Uv=8_dqqq8iG4YTZHUizo+y8EYKGS5g8g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 02:19:37PM +0800, Yongji Xie wrote:
> Hi Greg,
> 
> Thanks a lot for the review!
> 
> On Mon, May 31, 2021 at 12:56 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, May 17, 2021 at 05:55:12PM +0800, Xie Yongji wrote:
> > > +struct vduse_dev {
> > > +     struct vduse_vdpa *vdev;
> > > +     struct device dev;
> > > +     struct cdev cdev;
> >
> > You now have 2 reference counted devices controling the lifespace of a
> > single structure.  A mess that is guaranteed to go wrong.  Please never
> > do this.
> >
> 
> These two are both used by cdev_device_add(). Looks like I didn't find
> any problem. Any suggestions?

Make one of these dynamic and do not have them both control the lifespan
of the structure.

> > > +     struct vduse_virtqueue *vqs;
> > > +     struct vduse_iova_domain *domain;
> > > +     char *name;
> > > +     struct mutex lock;
> > > +     spinlock_t msg_lock;
> > > +     atomic64_t msg_unique;
> >
> > Why do you need an atomic and a lock?
> >
> 
> You are right. We don't need an atomic here.
> 
> > > +     wait_queue_head_t waitq;
> > > +     struct list_head send_list;
> > > +     struct list_head recv_list;
> > > +     struct list_head list;
> > > +     struct vdpa_callback config_cb;
> > > +     struct work_struct inject;
> > > +     spinlock_t irq_lock;
> > > +     unsigned long api_version;
> > > +     bool connected;
> > > +     int minor;
> > > +     u16 vq_size_max;
> > > +     u32 vq_num;
> > > +     u32 vq_align;
> > > +     u32 config_size;
> > > +     u32 device_id;
> > > +     u32 vendor_id;
> > > +};
> > > +
> > > +struct vduse_dev_msg {
> > > +     struct vduse_dev_request req;
> > > +     struct vduse_dev_response resp;
> > > +     struct list_head list;
> > > +     wait_queue_head_t waitq;
> > > +     bool completed;
> > > +};
> > > +
> > > +struct vduse_control {
> > > +     unsigned long api_version;
> >
> > u64?
> >
> 
> OK.
> 
> > > +};
> > > +
> > > +static unsigned long max_bounce_size = (64 * 1024 * 1024);
> > > +module_param(max_bounce_size, ulong, 0444);
> > > +MODULE_PARM_DESC(max_bounce_size, "Maximum bounce buffer size. (default: 64M)");
> > > +
> > > +static unsigned long max_iova_size = (128 * 1024 * 1024);
> > > +module_param(max_iova_size, ulong, 0444);
> > > +MODULE_PARM_DESC(max_iova_size, "Maximum iova space size (default: 128M)");
> > > +
> > > +static bool allow_unsafe_device_emulation;
> > > +module_param(allow_unsafe_device_emulation, bool, 0444);
> > > +MODULE_PARM_DESC(allow_unsafe_device_emulation, "Allow emulating unsafe device."
> > > +     " We must make sure the userspace device emulation process is trusted."
> > > +     " Otherwise, don't enable this option. (default: false)");
> > > +
> >
> > This is not the 1990's anymore, please never use module parameters, make
> > these per-device attributes if you really need them.
> >
> 
> These parameters will be used before the device is created. Or do you
> mean add some attributes to the control device?

You need to do something, as no one can mess with a module parameter
easily.  Why do you need them at all, shouldn't it "just work" properly
with no need for userspace interaction?

> > > +static int vduse_init(void)
> > > +{
> > > +     int ret;
> > > +
> > > +     if (max_bounce_size >= max_iova_size)
> > > +             return -EINVAL;
> > > +
> > > +     ret = misc_register(&vduse_misc);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > > +     vduse_class = class_create(THIS_MODULE, "vduse");
> >
> > If you have a misc device, you do not need to create a class at the same
> > time.  Why are you doing both here?  Just stick with the misc device, no
> > need for anything else.
> >
> 
> The misc device is the control device represented by
> /dev/vduse/control. Then a VDUSE device represented by
> /dev/vduse/$NAME can be created by the ioctl(VDUSE_CREATE_DEV) on this
> control device.

Ah.  Then how about using the same MAJOR for all of these, and just have
the first minor (0) be your control?  That happens for other device
types (raw, loop, etc.).  Or just document this really well please, as
it was not obvious what you were doing here.

thanks,

greg k-h
