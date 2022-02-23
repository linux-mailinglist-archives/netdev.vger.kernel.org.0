Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96894C078F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236708AbiBWCGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBWCGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:06:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D46A53FBF7
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645581935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=buzVwsZLq0iXCXG61A4X5ZxneH6xdRKfjx8nNyDkCvI=;
        b=LT0AAn2JfsNbZjkuyGcP2ugpYh4+zk5igLWBwvSwSMJ4YokZOQ2Me8srWRPSfpY5fm1n7F
        xPxiMPk3rzvEvEMd8g8Bmp6aOKEF6wKMF259R6SvkyMKTUfPN5G4TmNjbUhc0i1f6S0xGB
        0gPdoj5Cx/eCmaLvCxILnpWkwhC7eV4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-D4xfybZqMpuD37GYEdzjkg-1; Tue, 22 Feb 2022 21:05:34 -0500
X-MC-Unique: D4xfybZqMpuD37GYEdzjkg-1
Received: by mail-lj1-f200.google.com with SMTP id e9-20020a05651c090900b0024630875e4eso4910326ljq.18
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=buzVwsZLq0iXCXG61A4X5ZxneH6xdRKfjx8nNyDkCvI=;
        b=JmBM95xvqVRvtjM6OatYnqQWKcBdayKd6W0dQ2yitT6W6ZBxMlp8g2rw8j6pXmHSvK
         o5r5ASr6P6c8PDNTPd0nJRzs+RoSU0ylNQQxw5ekZwVUylgyhQu0YsZK/tSvQykdSXgp
         svjCnAslX0FWMp/S/DdgDMgmVi1fqO12FJy/jhf3we1bXG2TmfDnMhvQ1KeopPGqFSmb
         XzQCzh1NwxzgMUAkxW4v/u5AR8uU4GRq0hm6dHg1lOZVV5sXR3PFgFCxL5ImmLt90ovF
         PF1V8cBdUCE20N0TZIsQ5eppAiOGjqi1OHNaar1FtlpDk94O8tTT9/RSVuw/qhhVEWtT
         DkFw==
X-Gm-Message-State: AOAM530aGC8DzrPlIxBMNS0xd+KC5z4EFQzkmITEoetALhGx0Km5qXue
        hKF+1IQWwSMaZSezxdv17/PuXUAEtCMUqZgBgmRUWKrxLvfKZVDX1Id6ed/RNMZtMzxWqeuU+LV
        hyEKF7Pold7LTdt9QNj0b9VeYC+cXTBzf
X-Received: by 2002:ac2:5f68:0:b0:438:6751:6b83 with SMTP id c8-20020ac25f68000000b0043867516b83mr18922171lfc.376.1645581933129;
        Tue, 22 Feb 2022 18:05:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAHX+x2jwWdLU2x8SL6Qst3i9MqySV/buhDdfIJdvq9F0y/5J2MvOgBJXvw97jTjnOtyWiXmfjF5o4Wdrm/Uk=
X-Received: by 2002:ac2:5f68:0:b0:438:6751:6b83 with SMTP id
 c8-20020ac25f68000000b0043867516b83mr18922150lfc.376.1645581932830; Tue, 22
 Feb 2022 18:05:32 -0800 (PST)
MIME-Version: 1.0
References: <20220221195303.13560-1-mail@anirudhrb.com> <CACGkMEvLE=kV4PxJLRjdSyKArU+MRx6b_mbLGZHSUgoAAZ+-Fg@mail.gmail.com>
 <YhRtQEWBF0kqWMsI@anirudhrb.com> <CACGkMEvd7ETC_ANyrOSAVz_i64xqpYYazmm=+39E51=DMRFXdw@mail.gmail.com>
 <20220222090511-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220222090511-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Feb 2022 10:05:21 +0800
Message-ID: <CACGkMEu9mxo8sqPuymXzEOJbv8=fKq7TAScV2yrCM-bMozPibA@mail.gmail.com>
Subject: Re: [PATCH] vhost: validate range size before adding to iotlb
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 11:02 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Feb 22, 2022 at 03:11:07PM +0800, Jason Wang wrote:
> > On Tue, Feb 22, 2022 at 12:57 PM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > >
> > > On Tue, Feb 22, 2022 at 10:50:20AM +0800, Jason Wang wrote:
> > > > On Tue, Feb 22, 2022 at 3:53 AM Anirudh Rayabharam <mail@anirudhrb.com> wrote:
> > > > >
> > > > > In vhost_iotlb_add_range_ctx(), validate the range size is non-zero
> > > > > before proceeding with adding it to the iotlb.
> > > > >
> > > > > Range size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > One instance where it can happen is when userspace sends an IOTLB
> > > > > message with iova=size=uaddr=0 (vhost_process_iotlb_msg). So, an
> > > > > entry with size = 0, start = 0, last = (2^64 - 1) ends up in the
> > > > > iotlb. Next time a packet is sent, iotlb_access_ok() loops
> > > > > indefinitely due to that erroneous entry:
> > > > >
> > > > >         Call Trace:
> > > > >          <TASK>
> > > > >          iotlb_access_ok+0x21b/0x3e0 drivers/vhost/vhost.c:1340
> > > > >          vq_meta_prefetch+0xbc/0x280 drivers/vhost/vhost.c:1366
> > > > >          vhost_transport_do_send_pkt+0xe0/0xfd0 drivers/vhost/vsock.c:104
> > > > >          vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
> > > > >          kthread+0x2e9/0x3a0 kernel/kthread.c:377
> > > > >          ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
> > > > >          </TASK>
> > > > >
> > > > > Reported by syzbot at:
> > > > >         https://syzkaller.appspot.com/bug?extid=0abd373e2e50d704db87
> > > > >
> > > > > Reported-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > Tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
> > > > > Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
> > > > > ---
> > > > >  drivers/vhost/iotlb.c | 6 ++++--
> > > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > > > > index 670d56c879e5..b9de74bd2f9c 100644
> > > > > --- a/drivers/vhost/iotlb.c
> > > > > +++ b/drivers/vhost/iotlb.c
> > > > > @@ -53,8 +53,10 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > >                               void *opaque)
> > > > >  {
> > > > >         struct vhost_iotlb_map *map;
> > > > > +       u64 size = last - start + 1;
> > > > >
> > > > > -       if (last < start)
> > > > > +       // size can overflow to 0 when start is 0 and last is (2^64 - 1).
> > > > > +       if (last < start || size == 0)
> > > > >                 return -EFAULT;
> > > >
> > > > I'd move this check to vhost_chr_iter_write(), then for the device who
> > > > has its own msg handler (e.g vDPA) can benefit from it as well.
> > >
> > > Thanks for reviewing!
> > >
> > > I kept the check here thinking that all devices would benefit from it
> > > because they would need to call vhost_iotlb_add_range() to add an entry
> > > to the iotlb. Isn't that correct?
> >
> > Correct for now but not for the future, it's not guaranteed that the
> > per device iotlb message handler will use vhost iotlb.
> >
> > But I agree that we probably don't need to care about it too much now.
> >
> > > Do you see any other benefit in moving
> > > it to vhost_chr_iter_write()?
> > >
> > > One concern I have is that if we move it out some future caller to
> > > vhost_iotlb_add_range() might forget to handle this case.
> >
> > Yes.
> >
> > Rethink the whole fix, we're basically rejecting [0, ULONG_MAX] range
> > which seems a little bit odd.
>
> Well, I guess ideally we'd split this up as two entries - this kind of
> thing is after all one of the reasons we initially used first,last as
> the API - as opposed to first,size.
>
> Anirudh, could you do it like this instead of rejecting?
>
>
> > I wonder if it's better to just remove
> > the map->size. Having a quick glance at the the user, I don't see any
> > blocker for this.
> >
> > Thanks
>
> I think it's possible but won't solve the bug by itself, and we'd need
> to review and fix all users - a high chance of introducing
> another regression. And I think there's value of fitting under the
> stable rule of 100 lines with context.
> So sure, but let's fix the bug first.

Ok, I agree.

Thanks

>
>
>
> > >
> > > Thanks!
> > >
> > >         - Anirudh.
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > >         if (iotlb->limit &&
> > > > > @@ -69,7 +71,7 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> > > > >                 return -ENOMEM;
> > > > >
> > > > >         map->start = start;
> > > > > -       map->size = last - start + 1;
> > > > > +       map->size = size;
> > > > >         map->last = last;
> > > > >         map->addr = addr;
> > > > >         map->perm = perm;
> > > > > --
> > > > > 2.35.1
> > > > >
> > > >
> > >
>

