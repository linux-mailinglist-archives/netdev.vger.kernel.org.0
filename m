Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6940165946F
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 04:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiL3DoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 22:44:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbiL3DoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 22:44:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033C1BF4E
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 19:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672371804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKYNQFF9uhdzrxgpM6RHZiv3BQxZcu9+EDqyhxaDQPg=;
        b=QVaE2coYv4NDVnNFzPeTASCTUnAwHmp6v4uxVREMa0PD/zkDUA8EMQw250p0i4aSLcyFmH
        ko1/Dkl8KcKrV09a381ODfnGA4VHjSWIjis1i2Jr4q7Y4ibvgIYJPgpZ+Y/OfpHGChRFHO
        RooLRIA9/4oPkuyW8a1WAo8W7F0+cKE=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-CgsIaOhrPOysY_6HUiHkAA-1; Thu, 29 Dec 2022 22:43:20 -0500
X-MC-Unique: CgsIaOhrPOysY_6HUiHkAA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-14fa3e986a2so7433889fac.17
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 19:43:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKYNQFF9uhdzrxgpM6RHZiv3BQxZcu9+EDqyhxaDQPg=;
        b=0fA1slGoBWg3QIZ7M/WhTVW9HT1W899X0qWII3t68K9k/YCnn0v+/vIymyX3v2uZNh
         5zLKi3uNY/Eb6XP9l3efUlesqdQf1xX+UuP84KZngEhkfOTfk1eD3UDzcrMHqU19QnwG
         Z1epVPlx03+1SXkk/sHMDfo+Jua0g7SjFKzTnHw5s0N65n0rnDIgiYws80FP1Hbi7ZbK
         D42d5/dA8LSV1fCyPpkD3b1JpKMv6/1Q1gQSQF0o11GMnXcZXbN83HFHhfZt+UC37ick
         axz+4HZBDB7PgShKDT0aATLGw0TgvBvn1l+T0CCP5d/RWuXtww/BEOKi3upHXpDYKF6t
         s2Hg==
X-Gm-Message-State: AFqh2kp+wqX3NF70/nHU+IbhjzV8kKmrPse5+97xxBh2LTtrYyxXb6fw
        pH6eav6mBK1Oq+a0Zv/VZlufZZ++a2Selip2wDS8n+Cc+vp1VJbknoCPfBP8eyNfFl3uKWYL0PG
        rY8P72fnCndmM39Pwmtjy2LBmynnUo8Ba
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id 17-20020aca1111000000b0035e7a427ab5mr1625307oir.280.1672371799935;
        Thu, 29 Dec 2022 19:43:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv4NDDUzOLaitxmb36Ed0Wi9X6Ew8PlgA0rL9oGk47+jBfyvQTDFkl+dZSEdzXlqh8l/ctTQgvTKq95bTEitYA=
X-Received: by 2002:aca:1111:0:b0:35e:7a42:7ab5 with SMTP id
 17-20020aca1111000000b0035e7a427ab5mr1625301oir.280.1672371799697; Thu, 29
 Dec 2022 19:43:19 -0800 (PST)
MIME-Version: 1.0
References: <20221226074908.8154-4-jasowang@redhat.com> <20221226183705-mutt-send-email-mst@kernel.org>
 <CACGkMEuNZLJRnWw+XNxJ-to1y8L2GrTrJkk0y0Gwb5H2YhDczQ@mail.gmail.com>
 <20221227022255-mutt-send-email-mst@kernel.org> <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org> <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org> <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221229030633-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 30 Dec 2022 11:43:08 +0800
Message-ID: <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wr=
ote:
> > > > >
> > > > >
> > > > > =E5=9C=A8 2022/12/27 17:38, Michael S. Tsirkin =E5=86=99=E9=81=93=
:
> > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > >> =E5=9C=A8 2022/12/27 15:33, Michael S. Tsirkin =E5=86=99=E9=81=
=93:
> > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > >>>>> But device is still going and will later use the buffers.
> > > > > >>>>>
> > > > > >>>>> Same for timeout really.
> > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is =
to sleep.
> > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > >>>>
> > > > > >>>> Thanks
> > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in us=
e,
> > > > > >>> that sounds more reasonable. E.g. someone is turning on promi=
sc,
> > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > >>
> > > > > >> Yes, this would be more obvious is UP is used.
> > > > > >>
> > > > > >>
> > > > > >>> things we should be careful to address then:
> > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is =
stuck
> > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > >>>      We need to integrate with kernel/watchdog.c for good res=
ults
> > > > > >>>      and to make sure policy is consistent.
> > > > > >>
> > > > > >> That's fine, will consider this.
> > > >
> > > > So after some investigation, it seems the watchdog.c doesn't help. =
The
> > > > only export helper is touch_softlockup_watchdog() which tries to av=
oid
> > > > triggering the lockups warning for the known slow path.
> > >
> > > I never said you can just use existing exporting APIs. You'll have to
> > > write new ones :)
> >
> > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> >
> > Btw, I wonder what kind of logic you want here. If we switch to using
> > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > warning seems sufficient?
> >
> > Thanks
>
> I'd like to avoid need to teach users new APIs. So watchdog setup to appl=
y
> to this driver. The warning can be different.

Right, so it looks to me the only possible setup is the
watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
second (as softlockup did).

And I think it would still make sense to fail, we can start with a
very long timeout like 1 minutes and break the device. Does this make
sense?

Thanks

>
>
> > >
> > > > And before the patch, we end up with a real infinite loop which cou=
ld
> > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > What we can do is probably do a periodic netdev_err().
> > > >
> > > > Thanks
> > >
> > > Only with a bad device.
> > >
> > > > > >>
> > > > > >>
> > > > > >>> 2- overhead. In a very common scenario when device is in hype=
rvisor,
> > > > > >>>      programming timers etc has a very high overhead, at boot=
up
> > > > > >>>      lots of CVQ commands are run and slowing boot down is no=
t nice.
> > > > > >>>      let's poll for a bit before waiting?
> > > > > >>
> > > > > >> Then we go back to the question of choosing a good timeout for=
 poll. And
> > > > > >> poll seems problematic in the case of UP, scheduler might not =
have the
> > > > > >> chance to run.
> > > > > > Poll just a bit :) Seriously I don't know, but at least check o=
nce
> > > > > > after kick.
> > > > >
> > > > >
> > > > > I think it is what the current code did where the condition will =
be
> > > > > check before trying to sleep in the wait_event().
> > > > >
> > > > >
> > > > > >
> > > > > >>> 3- suprise removal. need to wake up thread in some way. what =
about
> > > > > >>>      other cases of device breakage - is there a chance this
> > > > > >>>      introduces new bugs around that? at least enumerate them=
 please.
> > > > > >>
> > > > > >> The current code did:
> > > > > >>
> > > > > >> 1) check for vq->broken
> > > > > >> 2) wakeup during BAD_RING()
> > > > > >>
> > > > > >> So we won't end up with a never woke up process which should b=
e fine.
> > > > > >>
> > > > > >> Thanks
> > > > > >
> > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is =
a good
> > > > > > idea - can cause crashes if kernel panics on error.
> > > > >
> > > > >
> > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > >
> > > > > But consider we will start from a wait first, I will limit the ch=
anges
> > > > > in virtio-net without bothering virtio core.
> > > > >
> > > > > Thanks
> > > > >
> > > > >
> > > > > >
> > > > > >>>
> > >
>

