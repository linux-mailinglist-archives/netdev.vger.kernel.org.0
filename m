Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04F6DD663
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjDKJOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjDKJOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:14:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245FB2690
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681204435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rG8YVr+3IWo4CE+CY2XyHcE+ZCDuW4teuWofuqNtms0=;
        b=U+7HSel9jMppWWIyNARB03sZZpFm0YdAyDWNFUXCYM8eaUmjByV7zRk/U9axH/l9beXKlL
        mTQvfD6qT/n8zKKhAbWGSMSWJ6GT0VlO9PdX0TTH1EfLa/5vZ2g8rgVyt7Ej2Ii4OfdGEG
        PW6Yok4xcWS4Zwltqz0NLrTPoznugHs=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-ezjFibeOP-iUk2yDgX2CfQ-1; Tue, 11 Apr 2023 05:13:53 -0400
X-MC-Unique: ezjFibeOP-iUk2yDgX2CfQ-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1845b15bbdaso1744109fac.7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681204433; x=1683796433;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG8YVr+3IWo4CE+CY2XyHcE+ZCDuW4teuWofuqNtms0=;
        b=jtrCbpdDGxKLV5I3fskfsSOusg8qYZ5DIoF/3cL0qOa0KB8e24SNtB85K06cL2xkj1
         ryaH82ygeZDG5VESEzLf72NDizCZvkg5WtguPQTr2FxPt9cjdw0Q9evH5atCKCO8pUnC
         lqHS7V6orGsUr6FA0nK0Cts73F5EMzBoLxvbsLpRIhF1tXRnGA1BoGUYIBcmM+1ablT0
         FZL+lNbVqT56iShJBXswoHk+jj7BgNU8gsH1zploDbwwp9TpUYQcggiBg3gjueU/6eWz
         HsUDnxBOVLOXM+fbt3Xbhc0s3sadrvClu0I3ZAm9nP0UyhLo84sg0+ROnqpUH8/3LCI/
         aKkg==
X-Gm-Message-State: AAQBX9c8a2BqLozivcqfvWATvpcvx21zgmdwkG0fkLGGMqx7DthQ9n1N
        dczbTCEZ8SggRHP6xDzvD+7NbhQuzjhTeBB3kySwvfA7PpM/VUdX/JcmUI0iVcnz27trOERlclF
        yqgAOEjF1qcmH2PeZeLaJ5inpg47Qisd5
X-Received: by 2002:aca:280f:0:b0:387:5a8c:4125 with SMTP id 15-20020aca280f000000b003875a8c4125mr2889711oix.3.1681204432871;
        Tue, 11 Apr 2023 02:13:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350YvpDPRV+stgWN71cbwISfDR9tuAtGF5dt0HDFBq3HH+19cK/azHyaoNC8arnfyuDaEmDUHp+71+dODeIH4ho4=
X-Received: by 2002:aca:280f:0:b0:387:5a8c:4125 with SMTP id
 15-20020aca280f000000b003875a8c4125mr2889704oix.3.1681204432261; Tue, 11 Apr
 2023 02:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com> <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
 <CACLfguWKw68=wZNa7Ga+Jm8xTE93A_5za3Dc=S_z7ds9FCkRKg@mail.gmail.com>
In-Reply-To: <CACLfguWKw68=wZNa7Ga+Jm8xTE93A_5za3Dc=S_z7ds9FCkRKg@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 17:13:41 +0800
Message-ID: <CACGkMEv3aca0Thx+X3WZxbV2HK7514G3RzR+A0PqRu7k6Deztg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 3:29=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> On Tue, Apr 11, 2023 at 11:10=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
> >
> > On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com> wro=
te:
> > >
> > > While using the no-batch mode, the process will not begin with
> > > VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> > > VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> > > same as VHOST_IOTLB_UPDATE
> > >
> > > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > > ---
> > >  drivers/vhost/vdpa.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 7be9d9d8f01c..32636a02a0ab 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struct =
vhost_dev *dev, u32 asid,
> > >                 goto unlock;
> > >
> > >         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> > > +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||
> >
> > I'm not sure I get here, invalidation doesn't need to create a new AS.
> >
> > Or maybe you can post the userspace code that can trigger this issue?
> >
> > Thanks
> >
> sorry I didn't write it clearly
> For this issue can reproduce in vIOMMU no-batch mode support because
> while the vIOMMU enabled, it will
> flash a large memory to unmap, and this memory are haven't been mapped
> before, so this unmapping will fail
>
> qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
> qemu-system-x86_64: vhost_vdpa_dma_unmap(0x7fa26d1dd190, 0x0,
> 0x80000000) =3D -5 (Bad address)

So if this is a simple unmap, which error condition had you met in
vhost_vdpa_process_iotlb_msg()?

I think you need to trace to see what happens. For example:

1) can the code pass asid_to_iotlb()
2) if not, ASID 0 has been deleted since all the mappings have been unmappe=
d

if ASID 0 has been completely unmap, any reason we need to unmap it
again? And do we need to drop the vhost_vdpa_remove_as() from both

1) vhost_vdpa_unmap()
and
2) vhost_vdpa_process_iotlb_msg()
?

Thanks

> qemu-system-x86_64: failed to write, fd=3D12, errno=3D14 (Bad address)
> ....
> in batch mode this operation will begin with VHOST_IOTLB_BATCH_BEGIN,
> so don't have this issue
>
> Thanks
> cindy
> > >             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
> > >                 as =3D vhost_vdpa_find_alloc_as(v, asid);
> > >                 if (!as) {
> > > --
> > > 2.34.3
> > >
> >
>

