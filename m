Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD7F3DEA01
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235135AbhHCJvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhHCJvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 05:51:08 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9913C061796
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 02:50:56 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x14so28185822edr.12
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 02:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jILE4iG7Hf5kzSZ86WpBt9OleoKnKxcD0AIYcg4CDWg=;
        b=UYLK3kL70/wbKlpjOzW8UaU540qw0H/BDGz2GAidxIH+0Tbdq0r3XuevQhcMlSwF58
         U+YHGLL8f22QDEunPk9DqMq1eT1/Yz2ExXO9GDS/ufNbqgnesYijDgUYNyUBGpqkPBK0
         jc6z0LopU31KIzZFUVhnBr86QNVcAec5ZQBL5MTDd8HrrSV4ZRwjz36IsOtuGmnH5X6A
         jYcjFh70UmazEs1b8oePF1wJDVsQ8glRQ/glBwJR4GBZ9yTuI1WAaizqZ05szzG1Ixmq
         2ctXvL00wRUev+FoavAHzmKe4yzO/7Bj+vNrO7PmMnz9qL1uqQVTrFk5IPvZ//M0qMCj
         v22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jILE4iG7Hf5kzSZ86WpBt9OleoKnKxcD0AIYcg4CDWg=;
        b=GZKe6RmcO2kqF3RbDBh7Eicx6X9BxN/e83QtwEskFKsRN8JO6Q3H2Gp/RaBpt5Z7pG
         xZ98IdqMX8nBv5F/qtNV78ODhfcnjzSIeTGc8EpwDvoVRYnBHSsTtfUXKobnU2ZgAwoe
         jKHSX44XDoV/9Jt0ldZIIp0ILZJbP35DhPLMkKz3yxzlnm6B71BjHOxGq6ORRn4TpKDB
         4i7HzJXyDVi6PqNGNraSZr32nWYpjDU95D+zAva7dYGH4r/odE0QKmT50uclkp2IDkOP
         PtKA7BKXfBRDsb1+aRlkeaKkvdeozb45q9C6oSN81tiuVw69G/bITmqxnHlzF9qLmyX6
         dBwg==
X-Gm-Message-State: AOAM533WOCq+rbXeXCRuTYUpD84IR+mpgrNM6T0VWcpehGi4wBFYKHat
        EOjvGMQzBNwJMIeb/ytl0aobhICpICQXeK+v3AEL
X-Google-Smtp-Source: ABdhPJy97k/uCbx6CjOrhsXKJtmjljacfy1qGYT4R+qrgPXqN+DQqG/xN8Jl5mhRS2KKa0ZWZzj3JvoQucqDWlc+mNo=
X-Received: by 2002:a05:6402:18c1:: with SMTP id x1mr24603324edy.145.1627984255528;
 Tue, 03 Aug 2021 02:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-6-xieyongji@bytedance.com>
 <55191de0-1a03-ff0d-1a49-afc419014bab@redhat.com>
In-Reply-To: <55191de0-1a03-ff0d-1a49-afc419014bab@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 3 Aug 2021 17:50:44 +0800
Message-ID: <CACycT3sfiFizYQckHi5k4MpVpOOQCEwJhC-cToAnXaBVHTDPQQ@mail.gmail.com>
Subject: Re: [PATCH v10 05/17] vhost-vdpa: Fail the vhost_vdpa_set_status() on
 reset failure
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 4:10 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=81=93=
:
> > Re-read the device status to ensure it's set to zero during
> > resetting. Otherwise, fail the vhost_vdpa_set_status() after timeout.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vhost/vdpa.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index b07aa161f7ad..dd05c1e1133c 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -157,7 +157,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa=
 *v, u8 __user *statusp)
> >       struct vdpa_device *vdpa =3D v->vdpa;
> >       const struct vdpa_config_ops *ops =3D vdpa->config;
> >       u8 status, status_old;
> > -     int nvqs =3D v->nvqs;
> > +     int timeout =3D 0, nvqs =3D v->nvqs;
> >       u16 i;
> >
> >       if (copy_from_user(&status, statusp, sizeof(status)))
> > @@ -173,6 +173,15 @@ static long vhost_vdpa_set_status(struct vhost_vdp=
a *v, u8 __user *statusp)
> >               return -EINVAL;
> >
> >       ops->set_status(vdpa, status);
> > +     if (status =3D=3D 0) {
> > +             while (ops->get_status(vdpa)) {
> > +                     timeout +=3D 20;
> > +                     if (timeout > VDPA_RESET_TIMEOUT_MS)
> > +                             return -EIO;
> > +
> > +                     msleep(20);
> > +             }
>
>
> Spec has introduced the reset a one of the basic facility. And consider
> we differ reset here.
>
> This makes me think if it's better to introduce a dedicated vdpa ops for
> reset?
>

Do you mean replace the ops.set_status(vdev, 0) with the ops.reset()?
Then we can remove the timeout processing which is device specific
stuff.

Thanks,
Yongji
