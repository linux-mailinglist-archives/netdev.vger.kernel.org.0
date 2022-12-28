Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E8657615
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiL1LyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 06:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiL1LyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 06:54:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C43101DA
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672228401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hQKS1NwOrIIXUtr0/6kNG7P651iOA+L6EemF1Qhqo8=;
        b=a3/ip11NJgo5ciZu+r1h09W/A1329peynAL+bUgFJfbFzb6V0h/xZieJGGi9Bh2HO+sGCm
        295/1DMdVZTTyyDgO/AN1KZdIeiO5y0U33hQQOEy6pdFuNNtB8uCOCVIviF5d/sLAUd3Ia
        AeOp2ZZMih0j0m4upN1I7N8WE9TFbbs=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-290-EcHwvu_aOdiKwEpo1qWf3Q-1; Wed, 28 Dec 2022 06:53:20 -0500
X-MC-Unique: EcHwvu_aOdiKwEpo1qWf3Q-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-14c958c18b5so7622814fac.23
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 03:53:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3hQKS1NwOrIIXUtr0/6kNG7P651iOA+L6EemF1Qhqo8=;
        b=cTnpNe+UWE6tPp+w2zbQfhJiAL4o3xkRvlsSuSxQD7N5iSTw0+uwQJ6kR6MlV67+7l
         PpKRjtacJJ013dIBiorq73VxZe4y+4qN/9MKiDQhjoo6343fyzgsCHwmJ/tC4CRjMjla
         Ieu9kxxFoSfMOiYUOF8Qr+oem650MCCoe/vZaQ69Z1JpbcuvoL4b3kj/FaFIcmSjx8aZ
         nHRaycsVVaodIJ6ogRQ0NvQUzzYnScVFhWUCm++/60q3SbEMAY2YzoiSaoDWtBDgWRtF
         onJQl2fVn0TPe0c2A+W2N/UpZqKvfXGpTiioAG5Y+yZWYlDTsp7R1NWwQF5EBsRyLi1k
         1lag==
X-Gm-Message-State: AFqh2kpT587b4Ex88WuVW9h/ZMgW4EtZ2+PKb5uCxgaVT7PtpD3NZUAt
        uHxeSoFP8E03qJo5dJ2n9X2DPZirbLeYVRc9fQBrr7d9umVzGot50ZN0S9bKV6KDvmxq8iJLfQx
        lkUmYP7grqhJUX0LvL/rLF5q16Jwid6FL
X-Received: by 2002:a9d:7843:0:b0:678:1eb4:3406 with SMTP id c3-20020a9d7843000000b006781eb43406mr1573921otm.237.1672228399893;
        Wed, 28 Dec 2022 03:53:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuiaCrxXL5+xhMG7tUHPCIJ4eF/3FYo5UTrnp+O2D9BcfxMWXCf0aeUTDXkBGQmvAAjX9SfrHhS9db4WpzKM1c=
X-Received: by 2002:a9d:7843:0:b0:678:1eb4:3406 with SMTP id
 c3-20020a9d7843000000b006781eb43406mr1573914otm.237.1672228399502; Wed, 28
 Dec 2022 03:53:19 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-1-jasowang@redhat.com> <20221226074908.8154-4-jasowang@redhat.com>
 <20221226183705-mutt-send-email-mst@kernel.org> <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org> <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org> <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
In-Reply-To: <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 28 Dec 2022 19:53:08 +0800
Message-ID: <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
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

On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/12/27 17:38, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> >> =E5=9C=A8 2022/12/27 15:33, Michael S. Tsirkin =E5=86=99=E9=81=93:
> >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> >>>>> But device is still going and will later use the buffers.
> >>>>>
> >>>>> Same for timeout really.
> >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep=
.
> >>>> If we think the timeout is hard, we can start from the wait.
> >>>>
> >>>> Thanks
> >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> >>> that sounds more reasonable. E.g. someone is turning on promisc,
> >>> a spike in CPU usage might be unwelcome.
> >>
> >> Yes, this would be more obvious is UP is used.
> >>
> >>
> >>> things we should be careful to address then:
> >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> >>>      in a loop for a while, and we also get a backtrace.
> >>>      E.g. with this - how do we know who has the RTNL?
> >>>      We need to integrate with kernel/watchdog.c for good results
> >>>      and to make sure policy is consistent.
> >>
> >> That's fine, will consider this.

So after some investigation, it seems the watchdog.c doesn't help. The
only export helper is touch_softlockup_watchdog() which tries to avoid
triggering the lockups warning for the known slow path.

And before the patch, we end up with a real infinite loop which could
be caught by RCU stall detector which is not the case of the sleep.
What we can do is probably do a periodic netdev_err().

Thanks

> >>
> >>
> >>> 2- overhead. In a very common scenario when device is in hypervisor,
> >>>      programming timers etc has a very high overhead, at bootup
> >>>      lots of CVQ commands are run and slowing boot down is not nice.
> >>>      let's poll for a bit before waiting?
> >>
> >> Then we go back to the question of choosing a good timeout for poll. A=
nd
> >> poll seems problematic in the case of UP, scheduler might not have the
> >> chance to run.
> > Poll just a bit :) Seriously I don't know, but at least check once
> > after kick.
>
>
> I think it is what the current code did where the condition will be
> check before trying to sleep in the wait_event().
>
>
> >
> >>> 3- suprise removal. need to wake up thread in some way. what about
> >>>      other cases of device breakage - is there a chance this
> >>>      introduces new bugs around that? at least enumerate them please.
> >>
> >> The current code did:
> >>
> >> 1) check for vq->broken
> >> 2) wakeup during BAD_RING()
> >>
> >> So we won't end up with a never woke up process which should be fine.
> >>
> >> Thanks
> >
> > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > idea - can cause crashes if kernel panics on error.
>
>
> Yes, it's better to use __virtqueue_break() instead.
>
> But consider we will start from a wait first, I will limit the changes
> in virtio-net without bothering virtio core.
>
> Thanks
>
>
> >
> >>>

