Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E3F67FCF4
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 06:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjA2Ftw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 00:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjA2Ftv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 00:49:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1BF21976
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674971344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v/JqQvkfYmpECZlGXQBcNM/6Zavf+3AMGSMqsORLXLY=;
        b=VFw2cw+qzbamZhvB2xLsIJJXl4iTJ4+zj6s4op7Yx6NiTAZr1jHPgJv8oU2WYt3Uq69wPD
        XjO/eLgt0vy9lYa08UQY3DUfdmTQOIo4U52SxtQDVJxVWxizOfeNf3AAUydtZ2643oS36o
        Dc9/5iQCCf+VBwMASIwBIVorVh3wZ18=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-DnigKFWMPsybEe1OQVTbdQ-1; Sun, 29 Jan 2023 00:49:01 -0500
X-MC-Unique: DnigKFWMPsybEe1OQVTbdQ-1
Received: by mail-oi1-f198.google.com with SMTP id es24-20020a056808279800b003630973475fso3740779oib.9
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 21:49:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/JqQvkfYmpECZlGXQBcNM/6Zavf+3AMGSMqsORLXLY=;
        b=mMctwZn0qfaqI+DtLFGbhxkVNtkLSBRCJov8GSsQlQL8kA8YCs8F/SVZUlX0nKJD1r
         dr2k3tjamkgycXtyKRvSz2apU2FkGuflwN1gS1T1qs5jEryNw9ahSELQSSTU8kyQextj
         osjG+QD1GUjkAtnrscYPmGNvVZ06DyIjgXHCTD3vDGRa9VtjtxirrXyjRCENzJQ3TW3U
         CGuGkib9adc41TC2qLysXRjBaW5ntjhiAzejVw6QMHwgn7VcYtPb1nt46UcaJPJNFumI
         E2p6FwdsCd5Ax9zjYwUeyO9AAd2CQPThoY66C1HhPA4vcjzT8bbU+2qVaP2fLj2SDcIh
         tKSw==
X-Gm-Message-State: AFqh2kr1bYBQ4/Idx8bCSqq3mVuulbI1jWImiBFeY20yb6Zo+yo2Qe7c
        INmp2bOhejTddnUSbpXuIgRvTmfKpWMOIaaqyADftfQ/tfWAQ07fnq95uU8DFwW9ccOQaHLx+PV
        Dceth5EvrgsMiu+N9+FK+vmmuX/RjtcPw
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id y14-20020a056871010e00b0015b96b59916mr3701897oab.280.1674971340719;
        Sat, 28 Jan 2023 21:49:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsY8GrgffCnTLZZkxvDGxQQI39DxhaTkYBL757UooQVj0vRieclaFLm0dBs/b3Ed5SX/SbZEXdYdiLyT5qVIfA=
X-Received: by 2002:a05:6871:10e:b0:15b:96b5:9916 with SMTP id
 y14-20020a056871010e00b0015b96b59916mr3701888oab.280.1674971340445; Sat, 28
 Jan 2023 21:49:00 -0800 (PST)
MIME-Version: 1.0
References: <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org> <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org> <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org> <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org> <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230127053112-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 29 Jan 2023 13:48:49 +0800
Message-ID: <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
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

On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> > > > >
> > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com=
> wrote:
> > > > > > >
> > > > > > >
> > > > > > > =E5=9C=A8 2022/12/27 17:38, Michael S. Tsirkin =E5=86=99=E9=
=81=93:
> > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > > >> =E5=9C=A8 2022/12/27 15:33, Michael S. Tsirkin =E5=86=99=
=E9=81=93:
> > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrot=
e:
> > > > > > > >>>>> But device is still going and will later use the buffer=
s.
> > > > > > > >>>>>
> > > > > > > >>>>> Same for timeout really.
> > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another=
 is to sleep.
> > > > > > > >>>> If we think the timeout is hard, we can start from the w=
ait.
> > > > > > > >>>>
> > > > > > > >>>> Thanks
> > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is i=
n use,
> > > > > > > >>> that sounds more reasonable. E.g. someone is turning on p=
romisc,
> > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > >>
> > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > >>
> > > > > > > >>
> > > > > > > >>> things we should be careful to address then:
> > > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU=
 is stuck
> > > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > > >>>      We need to integrate with kernel/watchdog.c for good=
 results
> > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > >>
> > > > > > > >> That's fine, will consider this.
> > > > > >
> > > > > > So after some investigation, it seems the watchdog.c doesn't he=
lp. The
> > > > > > only export helper is touch_softlockup_watchdog() which tries t=
o avoid
> > > > > > triggering the lockups warning for the known slow path.
> > > > >
> > > > > I never said you can just use existing exporting APIs. You'll hav=
e to
> > > > > write new ones :)
> > > >
> > > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > > >
> > > > Btw, I wonder what kind of logic you want here. If we switch to usi=
ng
> > > > sleep, there won't be soft lockup anymore. A simple wait + timeout =
+
> > > > warning seems sufficient?
> > > >
> > > > Thanks
> > >
> > > I'd like to avoid need to teach users new APIs. So watchdog setup to =
apply
> > > to this driver. The warning can be different.
> >
> > Right, so it looks to me the only possible setup is the
> > watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> > second (as softlockup did).
> >
> > And I think it would still make sense to fail, we can start with a
> > very long timeout like 1 minutes and break the device. Does this make
> > sense?
> >
> > Thanks
>
> I'd say we need to make this manageable then.

Did you mean something like sysfs or module parameters?

> Can't we do it normally
> e.g. react to an interrupt to return to userspace?

I didn't get the meaning of this. Sorry.

Thanks

>
>
>
> > >
> > >
> > > > >
> > > > > > And before the patch, we end up with a real infinite loop which=
 could
> > > > > > be caught by RCU stall detector which is not the case of the sl=
eep.
> > > > > > What we can do is probably do a periodic netdev_err().
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > Only with a bad device.
> > > > >
> > > > > > > >>
> > > > > > > >>
> > > > > > > >>> 2- overhead. In a very common scenario when device is in =
hypervisor,
> > > > > > > >>>      programming timers etc has a very high overhead, at =
bootup
> > > > > > > >>>      lots of CVQ commands are run and slowing boot down i=
s not nice.
> > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > >>
> > > > > > > >> Then we go back to the question of choosing a good timeout=
 for poll. And
> > > > > > > >> poll seems problematic in the case of UP, scheduler might =
not have the
> > > > > > > >> chance to run.
> > > > > > > > Poll just a bit :) Seriously I don't know, but at least che=
ck once
> > > > > > > > after kick.
> > > > > > >
> > > > > > >
> > > > > > > I think it is what the current code did where the condition w=
ill be
> > > > > > > check before trying to sleep in the wait_event().
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >>> 3- suprise removal. need to wake up thread in some way. w=
hat about
> > > > > > > >>>      other cases of device breakage - is there a chance t=
his
> > > > > > > >>>      introduces new bugs around that? at least enumerate =
them please.
> > > > > > > >>
> > > > > > > >> The current code did:
> > > > > > > >>
> > > > > > > >> 1) check for vq->broken
> > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > >>
> > > > > > > >> So we won't end up with a never woke up process which shou=
ld be fine.
> > > > > > > >>
> > > > > > > >> Thanks
> > > > > > > >
> > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that=
 is a good
> > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > >
> > > > > > >
> > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > >
> > > > > > > But consider we will start from a wait first, I will limit th=
e changes
> > > > > > > in virtio-net without bothering virtio core.
> > > > > > >
> > > > > > > Thanks
> > > > > > >
> > > > > > >
> > > > > > > >
> > > > > > > >>>
> > > > >
> > >
>

