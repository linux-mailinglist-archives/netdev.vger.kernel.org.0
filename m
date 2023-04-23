Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73716EBD67
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 08:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjDWGbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 02:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDWGbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 02:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F1B1BF0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 23:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682231433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ojJ8J6SwJ2t3heHFBn0Bsabr0jgX7CmT47hae2NlsQQ=;
        b=MVTLOyMh5YF4Mwh+lshu9Sa3hCb55pW3VlBcWbII1xnXec3NuPAaXQBG3TOrlSxhNaPsFv
        sjr38iO+GW2HT4N1qSk12tgbaPrYhotsknT9OHFyNoHNJm4v9BqkFWjy8zhsbZwzozt9aQ
        NNCo1QjZbVkLkawFhj95bJt511UcjLI=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-vUp4tcNPMYGHOrZ4DSEgIQ-1; Sun, 23 Apr 2023 02:30:30 -0400
X-MC-Unique: vUp4tcNPMYGHOrZ4DSEgIQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-187959a901eso2153408fac.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 23:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682231429; x=1684823429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojJ8J6SwJ2t3heHFBn0Bsabr0jgX7CmT47hae2NlsQQ=;
        b=PdVmB39k/NtpAln+haFPPMRbFtGB3fHtTi7l5C/BJl8UHRBcMLJcG6My6pNpuh21zR
         AulampXxSd8SqxqAAgM8jei0NarJrJUfiijXWSWnl6jGZx4ZmSFKVaehrPEBcQaQQuCw
         +FfAJD1uJvVFnSMLmOYoGtUzFO1zvVvGXYaGepXXHfFzjl7AaiiZ+kwZ0f2mnsragfVV
         OtHtYnYr6sdOuA34cj3JM8zD9En0gwwZ7aw8COayUtaIUdCL1+FjGTWoy6a0bBcjnXo3
         OUQjE/75IcWMV4SR86H008NHiDsuhfI+UEw+71TvLgrdE8Z7ESfsoa4CXlM8IcYYBRoN
         g80Q==
X-Gm-Message-State: AAQBX9cXA79k3UPuj6rfArUrmgU0zhccvmF8pcn0Em0lkbylZDULiXMV
        PSwEIi3yypNmVbJgN2/z89Tx2eRGM0VCuwukLosYqbcHLWa+83zQVm3a9VAoArfawZS6918k06K
        Koani8UYJFFv4QCZYA0AiTfcr4BvX4xh0
X-Received: by 2002:a05:6870:d389:b0:184:8300:bfac with SMTP id k9-20020a056870d38900b001848300bfacmr7672321oag.35.1682231429423;
        Sat, 22 Apr 2023 23:30:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzsgF0Z9L5BvVC8ev7/eC3gT2mJGdBB3NlrQjX6tzHkIyY6LeBMqfYTzC99ghGTCiMe89Snmwc8jP9Ue530OI=
X-Received: by 2002:a05:6870:d389:b0:184:8300:bfac with SMTP id
 k9-20020a056870d38900b001848300bfacmr7672318oag.35.1682231429136; Sat, 22 Apr
 2023 23:30:29 -0700 (PDT)
MIME-Version: 1.0
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <CACGkMEuiHqPkqYk1ZG3RZXLjm+EM3bmR0v1T1yH-ADEazOwTMA@mail.gmail.com>
 <d7530c13-f1a1-311e-7d5e-8e65f3bc2e50@redhat.com> <CACGkMEuWpHokhwvJ5cF41_C=ezqFhoOyUOposdZ5+==A642OmQ@mail.gmail.com>
 <88a24206-b576-efc6-1bce-7f5075024c63@redhat.com>
In-Reply-To: <88a24206-b576-efc6-1bce-7f5075024c63@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 23 Apr 2023 14:30:18 +0800
Message-ID: <CACGkMEuZpk8QcrUQSOxqt6j3F9Ge-HdSs5-18FayMMQmH3Tcmg@mail.gmail.com>
Subject: Re: [RFC 0/2] vduse: add support for networking devices
To:     Maxime Coquelin <maxime.coquelin@redhat.com>
Cc:     xieyongji@bytedance.com, mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 10:28=E2=80=AFPM Maxime Coquelin
<maxime.coquelin@redhat.com> wrote:
>
>
>
> On 4/21/23 07:51, Jason Wang wrote:
> > On Thu, Apr 20, 2023 at 10:16=E2=80=AFPM Maxime Coquelin
> > <maxime.coquelin@redhat.com> wrote:
> >>
> >>
> >>
> >> On 4/20/23 06:34, Jason Wang wrote:
> >>> On Wed, Apr 19, 2023 at 9:43=E2=80=AFPM Maxime Coquelin
> >>> <maxime.coquelin@redhat.com> wrote:
> >>>>
> >>>> This small series enables virtio-net device type in VDUSE.
> >>>> With it, basic operation have been tested, both with
> >>>> virtio-vdpa and vhost-vdpa using DPDK Vhost library series
> >>>> adding VDUSE support [0] using split rings layout.
> >>>>
> >>>> Control queue support (and so multiqueue) has also been
> >>>> tested, but require a Kernel series from Jason Wang
> >>>> relaxing control queue polling [1] to function reliably.
> >>>>
> >>>> Other than that, we have identified a few gaps:
> >>>>
> >>>> 1. Reconnection:
> >>>>    a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
> >>>>       index, even after the virtqueue has already been
> >>>>       processed. Is that expected? I have tried instead to
> >>>>       get the driver's avail index directly from the avail
> >>>>       ring, but it does not seem reliable as I sometimes get
> >>>>       "id %u is not a head!\n" warnings. Also such solution
> >>>>       would not be possible with packed ring, as we need to
> >>>>       know the wrap counters values.
> >>>
> >>> Looking at the codes, it only returns the value that is set via
> >>> set_vq_state(). I think it is expected to be called before the
> >>> datapath runs.
> >>>
> >>> So when bound to virtio-vdpa, it is expected to return 0. But we need
> >>> to fix the packed virtqueue case, I wonder if we need to call
> >>> set_vq_state() explicitly in virtio-vdpa before starting the device.
> >>>
> >>> When bound to vhost-vdpa, Qemu will call VHOST_SET_VRING_BASE which
> >>> will end up a call to set_vq_state(). Unfortunately, it doesn't
> >>> support packed ring which needs some extension.
> >>>
> >>>>
> >>>>    b. Missing IOCTLs: it would be handy to have new IOCTLs to
> >>>>       query Virtio device status,
> >>>
> >>> What's the use case of this ioctl? It looks to me userspace is
> >>> notified on each status change now:
> >>>
> >>> static int vduse_dev_set_status(struct vduse_dev *dev, u8 status)
> >>> {
> >>>           struct vduse_dev_msg msg =3D { 0 };
> >>>
> >>>           msg.req.type =3D VDUSE_SET_STATUS;
> >>>           msg.req.s.status =3D status;
> >>>
> >>>           return vduse_dev_msg_sync(dev, &msg);
> >>> }
> >>
> >> The idea was to be able to query the status at reconnect time, and
> >> neither having to assume its value nor having to store its value in a
> >> file (the status could change while the VDUSE application is stopped,
> >> but maybe it would receive the notification at reconnect).
> >
> > I see.
> >
> >>
> >> I will prototype using a tmpfs file to save needed information, and se=
e
> >> if it works.
> >
> > It might work but then the API is not self contained. Maybe it's
> > better to have a dedicated ioctl.
> >
> >>
> >>>> and retrieve the config
> >>>>       space set at VDUSE_CREATE_DEV time.
> >>>
> >>> In order to be safe, VDUSE avoids writable config space. Otherwise
> >>> drivers could block on config writing forever. That's why we don't do
> >>> it now.
> >>
> >> The idea was not to make the config space writable, but just to be abl=
e
> >> to fetch what was filled at VDUSE_CREATE_DEV time.
> >>
> >> With the tmpfs file, we can avoid doing that and just save the config
> >> space there.
> >
> > Same as the case for status.
>
> I have cooked a DPDK patch to support reconnect with a tmpfs file as
> suggested by Yongji:
>
> https://gitlab.com/mcoquelin/dpdk-next-virtio/-/commit/53913f2b1155b02c44=
d5d3d298aafd357e7a8c48

This seems tricky, for example for status:

dev->log->status =3D dev->status;

What if we crash here?


>
> That's still rough around the edges, but it seems to work reliably
> for the testing I have done so far. We'll certainly want to use the
> tmpfs memory to directly store available indexes and wrap counters to
> avoid introducing overhead in the datapath.

That's fine, we probably need a chapter in the kernel doc to describe
the reliable reconnection but it is not limited to tmpfs.

> The tricky part will be to
> manage NUMA affinity.

This part is not clear to me, what affinity should we care about?
There's a sysfs that was invented by YongJi for virtqueue affinity
management recently.

Thanks

>
> Regards,
> Maxime
>
> >
> > Thanks
> >
> >>
> >>> We need to harden the config write before we can proceed to this I th=
ink.
> >>>
> >>>>
> >>>> 2. VDUSE application as non-root:
> >>>>     We need to run the VDUSE application as non-root. There
> >>>>     is some race between the time the UDEV rule is applied
> >>>>     and the time the device starts being used. Discussing
> >>>>     with Jason, he suggested we may have a VDUSE daemon run
> >>>>     as root that would create the VDUSE device, manages its
> >>>>     rights and then pass its file descriptor to the VDUSE
> >>>>     app. However, with current IOCTLs, it means the VDUSE
> >>>>     daemon would need to know several information that
> >>>>     belongs to the VDUSE app implementing the device such
> >>>>     as supported Virtio features, config space, etc...
> >>>>     If we go that route, maybe we should have a control
> >>>>     IOCTL to create the device which would just pass the
> >>>>     device type. Then another device IOCTL to perform the
> >>>>     initialization. Would that make sense?
> >>>
> >>> I think so. We can hear from others.
> >>>
> >>>>
> >>>> 3. Coredump:
> >>>>     In order to be able to perform post-mortem analysis, DPDK
> >>>>     Vhost library marks pages used for vrings and descriptors
> >>>>     buffers as MADV_DODUMP using madvise(). However with
> >>>>     VDUSE it fails with -EINVAL. My understanding is that we
> >>>>     set VM_DONTEXPAND flag to the VMAs and madvise's
> >>>>     MADV_DODUMP fails if it is present. I'm not sure to
> >>>>     understand why madvise would prevent MADV_DODUMP if
> >>>>     VM_DONTEXPAND is set. Any thoughts?
> >>>
> >>> Adding Peter who may know the answer.
> >>
> >> Thanks!
> >> Maxime
> >>
> >>> Thanks
> >>>
> >>>>
> >>>> [0]: https://patchwork.dpdk.org/project/dpdk/list/?series=3D27594&st=
ate=3D%2A&archive=3Dboth
> >>>> [1]: https://lore.kernel.org/lkml/CACGkMEtgrxN3PPwsDo4oOsnsSLJfEmBEZ=
0WvjGRr3whU+QasUg@mail.gmail.com/T/
> >>>>
> >>>> Maxime Coquelin (2):
> >>>>     vduse: validate block features only with block devices
> >>>>     vduse: enable Virtio-net device type
> >>>>
> >>>>    drivers/vdpa/vdpa_user/vduse_dev.c | 11 +++++++----
> >>>>    1 file changed, 7 insertions(+), 4 deletions(-)
> >>>>
> >>>> --
> >>>> 2.39.2
> >>>>
> >>>
> >>
> >
>

