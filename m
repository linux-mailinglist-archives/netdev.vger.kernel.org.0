Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D604665409
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjAKFzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjAKFzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:55:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E4AE77
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673416501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QaLGbA/auVkkHt3S1yCaMOL0LGZnHy0mTSjzASi2TM=;
        b=IkEjxfFnvWdA8bbkuFo5RnuJ3I+K3/pFVxatpqyNWUAEY2cAGQCezZCmUdYlQqxYEo5t6b
        5rGYZ65uIpCbA0KseBhsKczNWvkE6Ja3aAsEaPW+tBDRTefJ9rGv9LyxyDbvf2SYNuPg6y
        7CukapG7KP8cEmjCUJjM6jp3eUaAE+Y=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-569-SYRMLVRzPYqUB_BirViyMg-1; Wed, 11 Jan 2023 00:54:59 -0500
X-MC-Unique: SYRMLVRzPYqUB_BirViyMg-1
Received: by mail-oo1-f70.google.com with SMTP id o19-20020a4a3853000000b004f20c01535dso1885859oof.15
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 21:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QaLGbA/auVkkHt3S1yCaMOL0LGZnHy0mTSjzASi2TM=;
        b=jWa94GBFt58L/RKzNPcR1W/almYR6RPBFQ9QZQiz2dtVtzBmn7bxIyNd+c2G9YPvji
         mzpnR0/elgmwVepe9T2IJLLrbNLSpbg7eIaUqmmmk6QillIE73KAYvfPtV4uC/YEeDWn
         ZcruPz32EBH1ph6ey6FUWRxv7WgbGChybhmjrX8Hj0JLitirvRO0gnKHe6zyuPa094DG
         jpOU4vqj8JBs4hiFV5ag0bY6NKRkfQ5D8r7W6P8BQCizAwaVqMFUtgtKyrqBbQk+aBHe
         K2bWRF7Xwga6yl9UzZ9bDyhrEo0Wo3GFyLImXopCUNjP8jxII8qUx19E7nwhCu3Evt0E
         ZmPQ==
X-Gm-Message-State: AFqh2kohloHh04AuLZR0R+FRKySthCiw5l4iBksUfLzOfdtIanxlMNwY
        DBkIG7QzP1Aus0lD7GUtZVWzC/kF8cP0FeA7UFc4fMjIwFXNM0FaUrKC70CK4O1fckV9c/o++KR
        6s/MSajsLw5NpRMSSxb+TyMEeINKW0NVi
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id c9-20020a544e89000000b0035c303dfe37mr3104773oiy.35.1673416498900;
        Tue, 10 Jan 2023 21:54:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs7Pcd5hAhHUVfkAiJZKDPAqISOY6JH4N8DrXmnBv2nFKpYbwPgNUa2bCZjQ76vdprk/AP+0MaVbiBxAY7PylY=
X-Received: by 2002:a54:4e89:0:b0:35c:303d:fe37 with SMTP id
 c9-20020a544e89000000b0035c303dfe37mr3104772oiy.35.1673416498603; Tue, 10 Jan
 2023 21:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20221227022528.609839-1-mie@igel.co.jp> <20221227022528.609839-3-mie@igel.co.jp>
 <CACGkMEtAaYpuZtS0gx_m931nFzcvqSNK9BhvUZH_tZXTzjgQCg@mail.gmail.com>
 <CANXvt5rfXDYa0nLzKW5-Q-hjhw-19npXVneqBO1TcsariU6rWg@mail.gmail.com>
 <CACGkMEvmZ5MEX4WMa3JhzT404C2uhsNk0nnkYBRtvLPhNTSzHQ@mail.gmail.com> <18a0a7cd-0601-0ff6-12d7-353819692155@igel.co.jp>
In-Reply-To: <18a0a7cd-0601-0ff6-12d7-353819692155@igel.co.jp>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 11 Jan 2023 13:54:47 +0800
Message-ID: <CACGkMEsVeE9G=-OkvazGu_EtfKgD8iakon54iLgFFPWYJSSekg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/9] vringh: remove vringh_iov and unite to vringh_kiov
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 11:27 AM Shunsuke Mie <mie@igel.co.jp> wrote:
>
>
> On 2022/12/28 15:36, Jason Wang wrote:
> > On Tue, Dec 27, 2022 at 3:06 PM Shunsuke Mie <mie@igel.co.jp> wrote:
> >> 2022=E5=B9=B412=E6=9C=8827=E6=97=A5(=E7=81=AB) 15:04 Jason Wang <jasow=
ang@redhat.com>:
> >>> On Tue, Dec 27, 2022 at 10:25 AM Shunsuke Mie <mie@igel.co.jp> wrote:
> >>>> struct vringh_iov is defined to hold userland addresses. However, to=
 use
> >>>> common function, __vring_iov, finally the vringh_iov converts to the
> >>>> vringh_kiov with simple cast. It includes compile time check code to=
 make
> >>>> sure it can be cast correctly.
> >>>>
> >>>> To simplify the code, this patch removes the struct vringh_iov and u=
nifies
> >>>> APIs to struct vringh_kiov.
> >>>>
> >>>> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> >>> While at this, I wonder if we need to go further, that is, switch to
> >>> using an iov iterator instead of a vringh customized one.
> >> I didn't see the iov iterator yet, thank you for informing me.
> >> Is that iov_iter? https://lwn.net/Articles/625077/
> > Exactly.
>
> I've investigated the iov_iter, vhost and related APIs. As a result, I
> think that it is not easy to switch to use the iov_iter. Because, the
> design of vhost and vringh is different.

Yes, but just to make sure we are on the same page, the reason I
suggest iov_iter for vringh is that the vringh itself has customized
iter equivalent, e.g it has iter for kernel,user, or even iotlb. At
least the kernel and userspace part could be switched to iov_iter.
Note that it has nothing to do with vhost.

>
> The iov_iter has vring desc info and meta data of transfer method. The
> vhost provides generic transfer function for the iov_iter. In constrast,
> vringh_iov just has vring desc info. The vringh provides transfer functio=
ns
> for each methods.
>
> In the future, it is better to use common data structure and APIs between
> vhost and vringh (or merge completely), but it requires a lot of
> changes, so I'd like to just
> organize data structure in vringh as a first step in this patch.

That's fine.

Thansk

>
>
> Best
>
> > Thanks
> >
> >>> Thanks
> >>>
> >>>> ---
> >>>>   drivers/vhost/vringh.c | 32 ++++++------------------------
> >>>>   include/linux/vringh.h | 45 ++++----------------------------------=
----
> >>>>   2 files changed, 10 insertions(+), 67 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> >>>> index 828c29306565..aa3cd27d2384 100644
> >>>> --- a/drivers/vhost/vringh.c
> >>>> +++ b/drivers/vhost/vringh.c
> >>>> @@ -691,8 +691,8 @@ EXPORT_SYMBOL(vringh_init_user);
> >>>>    * calling vringh_iov_cleanup() to release the memory, even on err=
or!
> >>>>    */
> >>>>   int vringh_getdesc_user(struct vringh *vrh,
> >>>> -                       struct vringh_iov *riov,
> >>>> -                       struct vringh_iov *wiov,
> >>>> +                       struct vringh_kiov *riov,
> >>>> +                       struct vringh_kiov *wiov,
> >>>>                          bool (*getrange)(struct vringh *vrh,
> >>>>                                           u64 addr, struct vringh_ra=
nge *r),
> >>>>                          u16 *head)
> >>>> @@ -708,26 +708,6 @@ int vringh_getdesc_user(struct vringh *vrh,
> >>>>          if (err =3D=3D vrh->vring.num)
> >>>>                  return 0;
> >>>>
> >>>> -       /* We need the layouts to be the identical for this to work =
*/
> >>>> -       BUILD_BUG_ON(sizeof(struct vringh_kiov) !=3D sizeof(struct v=
ringh_iov));
> >>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, iov) !=3D
> >>>> -                    offsetof(struct vringh_iov, iov));
> >>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, i) !=3D
> >>>> -                    offsetof(struct vringh_iov, i));
> >>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, used) !=3D
> >>>> -                    offsetof(struct vringh_iov, used));
> >>>> -       BUILD_BUG_ON(offsetof(struct vringh_kiov, max_num) !=3D
> >>>> -                    offsetof(struct vringh_iov, max_num));
> >>>> -       BUILD_BUG_ON(sizeof(struct iovec) !=3D sizeof(struct kvec));
> >>>> -       BUILD_BUG_ON(offsetof(struct iovec, iov_base) !=3D
> >>>> -                    offsetof(struct kvec, iov_base));
> >>>> -       BUILD_BUG_ON(offsetof(struct iovec, iov_len) !=3D
> >>>> -                    offsetof(struct kvec, iov_len));
> >>>> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_base)
> >>>> -                    !=3D sizeof(((struct kvec *)NULL)->iov_base));
> >>>> -       BUILD_BUG_ON(sizeof(((struct iovec *)NULL)->iov_len)
> >>>> -                    !=3D sizeof(((struct kvec *)NULL)->iov_len));
> >>>> -
> >>>>          *head =3D err;
> >>>>          err =3D __vringh_iov(vrh, *head, (struct vringh_kiov *)riov=
,
> >>>>                             (struct vringh_kiov *)wiov,
> >>>> @@ -740,14 +720,14 @@ int vringh_getdesc_user(struct vringh *vrh,
> >>>>   EXPORT_SYMBOL(vringh_getdesc_user);
> >>>>
> >>>>   /**
> >>>> - * vringh_iov_pull_user - copy bytes from vring_iov.
> >>>> + * vringh_iov_pull_user - copy bytes from vring_kiov.
> >>>>    * @riov: the riov as passed to vringh_getdesc_user() (updated as =
we consume)
> >>>>    * @dst: the place to copy.
> >>>>    * @len: the maximum length to copy.
> >>>>    *
> >>>>    * Returns the bytes copied <=3D len or a negative errno.
> >>>>    */
> >>>> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, si=
ze_t len)
> >>>> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, s=
ize_t len)
> >>>>   {
> >>>>          return vringh_iov_xfer(NULL, (struct vringh_kiov *)riov,
> >>>>                                 dst, len, xfer_from_user);
> >>>> @@ -755,14 +735,14 @@ ssize_t vringh_iov_pull_user(struct vringh_iov=
 *riov, void *dst, size_t len)
> >>>>   EXPORT_SYMBOL(vringh_iov_pull_user);
> >>>>
> >>>>   /**
> >>>> - * vringh_iov_push_user - copy bytes into vring_iov.
> >>>> + * vringh_iov_push_user - copy bytes into vring_kiov.
> >>>>    * @wiov: the wiov as passed to vringh_getdesc_user() (updated as =
we consume)
> >>>>    * @src: the place to copy from.
> >>>>    * @len: the maximum length to copy.
> >>>>    *
> >>>>    * Returns the bytes copied <=3D len or a negative errno.
> >>>>    */
> >>>> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> >>>> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
> >>>>                               const void *src, size_t len)
> >>>>   {
> >>>>          return vringh_iov_xfer(NULL, (struct vringh_kiov *)wiov,
> >>>> diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> >>>> index 1991a02c6431..733d948e8123 100644
> >>>> --- a/include/linux/vringh.h
> >>>> +++ b/include/linux/vringh.h
> >>>> @@ -79,18 +79,6 @@ struct vringh_range {
> >>>>          u64 offset;
> >>>>   };
> >>>>
> >>>> -/**
> >>>> - * struct vringh_iov - iovec mangler.
> >>>> - *
> >>>> - * Mangles iovec in place, and restores it.
> >>>> - * Remaining data is iov + i, of used - i elements.
> >>>> - */
> >>>> -struct vringh_iov {
> >>>> -       struct iovec *iov;
> >>>> -       size_t consumed; /* Within iov[i] */
> >>>> -       unsigned i, used, max_num;
> >>>> -};
> >>>> -
> >>>>   /**
> >>>>    * struct vringh_kiov - kvec mangler.
> >>>>    *
> >>>> @@ -113,44 +101,19 @@ int vringh_init_user(struct vringh *vrh, u64 f=
eatures,
> >>>>                       vring_avail_t __user *avail,
> >>>>                       vring_used_t __user *used);
> >>>>
> >>>> -static inline void vringh_iov_init(struct vringh_iov *iov,
> >>>> -                                  struct iovec *iovec, unsigned num=
)
> >>>> -{
> >>>> -       iov->used =3D iov->i =3D 0;
> >>>> -       iov->consumed =3D 0;
> >>>> -       iov->max_num =3D num;
> >>>> -       iov->iov =3D iovec;
> >>>> -}
> >>>> -
> >>>> -static inline void vringh_iov_reset(struct vringh_iov *iov)
> >>>> -{
> >>>> -       iov->iov[iov->i].iov_len +=3D iov->consumed;
> >>>> -       iov->iov[iov->i].iov_base -=3D iov->consumed;
> >>>> -       iov->consumed =3D 0;
> >>>> -       iov->i =3D 0;
> >>>> -}
> >>>> -
> >>>> -static inline void vringh_iov_cleanup(struct vringh_iov *iov)
> >>>> -{
> >>>> -       if (iov->max_num & VRINGH_IOV_ALLOCATED)
> >>>> -               kfree(iov->iov);
> >>>> -       iov->max_num =3D iov->used =3D iov->i =3D iov->consumed =3D =
0;
> >>>> -       iov->iov =3D NULL;
> >>>> -}
> >>>> -
> >>>>   /* Convert a descriptor into iovecs. */
> >>>>   int vringh_getdesc_user(struct vringh *vrh,
> >>>> -                       struct vringh_iov *riov,
> >>>> -                       struct vringh_iov *wiov,
> >>>> +                       struct vringh_kiov *riov,
> >>>> +                       struct vringh_kiov *wiov,
> >>>>                          bool (*getrange)(struct vringh *vrh,
> >>>>                                           u64 addr, struct vringh_ra=
nge *r),
> >>>>                          u16 *head);
> >>>>
> >>>>   /* Copy bytes from readable vsg, consuming it (and incrementing wi=
ov->i). */
> >>>> -ssize_t vringh_iov_pull_user(struct vringh_iov *riov, void *dst, si=
ze_t len);
> >>>> +ssize_t vringh_iov_pull_user(struct vringh_kiov *riov, void *dst, s=
ize_t len);
> >>>>
> >>>>   /* Copy bytes into writable vsg, consuming it (and incrementing wi=
ov->i). */
> >>>> -ssize_t vringh_iov_push_user(struct vringh_iov *wiov,
> >>>> +ssize_t vringh_iov_push_user(struct vringh_kiov *wiov,
> >>>>                               const void *src, size_t len);
> >>>>
> >>>>   /* Mark a descriptor as used. */
> >>>> --
> >>>> 2.25.1
> >>>>
> >> Best,
> >> Shunsuke
> >>
>

