Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551DC67FD5E
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 08:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbjA2HbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 02:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjA2HbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 02:31:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E107919F35
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 23:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674977410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ov+1IIBAWUO4cVMGk1jfLqe88PNWYaRlwb1nxeeSoz8=;
        b=cwTPQVEZHEM2t+/HF0Oa12n4Ip6JWPHduaDIsZQNoOppZupEfyBVlorOcVF5V8Gy2rdV4c
        Vj2mFUgdn9YvISqbGrAB0OwtSD4ct/vB/PzadSjXRMUIiZ8OBkR1uTKogx928QW8jxljTQ
        cA4Pan3QaMwP1opKZkZwv3JyoaeStSE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-JSncMWpGOp-WqF5-G_UzlA-1; Sun, 29 Jan 2023 02:30:08 -0500
X-MC-Unique: JSncMWpGOp-WqF5-G_UzlA-1
Received: by mail-wm1-f71.google.com with SMTP id l5-20020a1ced05000000b003db300f2e1cso2550726wmh.0
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 23:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ov+1IIBAWUO4cVMGk1jfLqe88PNWYaRlwb1nxeeSoz8=;
        b=GkC797Mqnt3R4PhuO0Rri8RIkN97XM1O3sVnUjUzs8uIzG9FFrmlx67p/lHqUqOb1x
         YxKesem8YP7EjRch3/MyIiWtu7ZUEC+lxEd4Yaexp9RuM1B+aHMEYdmM5xRanElc1D0W
         d1qq15x860SQfOL015Lbshr3u6vrBC0ZXWX+MdoDhhlGo6SAhDBh3ctHx+V4mfhVe1ui
         3+pbr74BzwHIq5jU/XlluDYgroPBzrJGwZq6BZNDBxlt+dAjTKLa7+5sNyVwvIPRih/M
         9H3JH/QHhvxUmHZRPQSJT5H4fKqQ0KT2yr0+yIb7xfTbY8LAJlnrpPQU6EXweZnsyVWm
         N9RQ==
X-Gm-Message-State: AO0yUKXHkSjJDTvUBp8pIjSzjOCa6bY4LhF3Tdc5ABm0KjA48n+pnqHU
        Ou/ABfrCHA0zYKQ710/z+sjd6bR2MrRqeK48eo/MImTAfq7ARcualSyfaiuSfpPtx6pGSltD1LV
        eU5YdKSqlP8Kdutiw
X-Received: by 2002:a5d:6088:0:b0:2bf:e533:3158 with SMTP id w8-20020a5d6088000000b002bfe5333158mr1886320wrt.20.1674977407430;
        Sat, 28 Jan 2023 23:30:07 -0800 (PST)
X-Google-Smtp-Source: AK7set9LsUvsi2F0Rhe6agjXYMxH1Bd/kDEDU1j0Zr9SlfykK9KgWHLBzwN6kTKcmrPBAf0LiiWnSA==
X-Received: by 2002:a5d:6088:0:b0:2bf:e533:3158 with SMTP id w8-20020a5d6088000000b002bfe5333158mr1886305wrt.20.1674977407110;
        Sat, 28 Jan 2023 23:30:07 -0800 (PST)
Received: from redhat.com ([2.52.20.248])
        by smtp.gmail.com with ESMTPSA id z2-20020a5d6542000000b00267bcb1bbe5sm8398974wrv.56.2023.01.28.23.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 23:30:06 -0800 (PST)
Date:   Sun, 29 Jan 2023 02:30:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20230129022809-mutt-send-email-mst@kernel.org>
References: <d77bc1ce-b73f-1ba8-f04f-b3bffeb731c3@redhat.com>
 <20221227043148-mutt-send-email-mst@kernel.org>
 <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org>
 <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org>
 <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org>
 <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > >
> > > > > > > >
> > > > > > > > 在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > > > >> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > > > > >>>>> But device is still going and will later use the buffers.
> > > > > > > > >>>>>
> > > > > > > > >>>>> Same for timeout really.
> > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > > > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > > > > >>>>
> > > > > > > > >>>> Thanks
> > > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> > > > > > > > >>> that sounds more reasonable. E.g. someone is turning on promisc,
> > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > >>
> > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > >>
> > > > > > > > >>
> > > > > > > > >>> things we should be careful to address then:
> > > > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> > > > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > > > >>>      We need to integrate with kernel/watchdog.c for good results
> > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > >>
> > > > > > > > >> That's fine, will consider this.
> > > > > > >
> > > > > > > So after some investigation, it seems the watchdog.c doesn't help. The
> > > > > > > only export helper is touch_softlockup_watchdog() which tries to avoid
> > > > > > > triggering the lockups warning for the known slow path.
> > > > > >
> > > > > > I never said you can just use existing exporting APIs. You'll have to
> > > > > > write new ones :)
> > > > >
> > > > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > > > >
> > > > > Btw, I wonder what kind of logic you want here. If we switch to using
> > > > > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > > > > warning seems sufficient?
> > > > >
> > > > > Thanks
> > > >
> > > > I'd like to avoid need to teach users new APIs. So watchdog setup to apply
> > > > to this driver. The warning can be different.
> > >
> > > Right, so it looks to me the only possible setup is the
> > > watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> > > second (as softlockup did).
> > >
> > > And I think it would still make sense to fail, we can start with a
> > > very long timeout like 1 minutes and break the device. Does this make
> > > sense?
> > >
> > > Thanks
> >
> > I'd say we need to make this manageable then.
> 
> Did you mean something like sysfs or module parameters?

No I'd say pass it with an ioctl.

> > Can't we do it normally
> > e.g. react to an interrupt to return to userspace?
> 
> I didn't get the meaning of this. Sorry.
> 
> Thanks

Standard way to handle things that can timeout and where userspace
did not supply the time is to block until an interrupt
then return EINTR. Userspace controls the timeout by
using e.g. alarm(2).


> >
> >
> >
> > > >
> > > >
> > > > > >
> > > > > > > And before the patch, we end up with a real infinite loop which could
> > > > > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > Only with a bad device.
> > > > > >
> > > > > > > > >>
> > > > > > > > >>
> > > > > > > > >>> 2- overhead. In a very common scenario when device is in hypervisor,
> > > > > > > > >>>      programming timers etc has a very high overhead, at bootup
> > > > > > > > >>>      lots of CVQ commands are run and slowing boot down is not nice.
> > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > >>
> > > > > > > > >> Then we go back to the question of choosing a good timeout for poll. And
> > > > > > > > >> poll seems problematic in the case of UP, scheduler might not have the
> > > > > > > > >> chance to run.
> > > > > > > > > Poll just a bit :) Seriously I don't know, but at least check once
> > > > > > > > > after kick.
> > > > > > > >
> > > > > > > >
> > > > > > > > I think it is what the current code did where the condition will be
> > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > >>> 3- suprise removal. need to wake up thread in some way. what about
> > > > > > > > >>>      other cases of device breakage - is there a chance this
> > > > > > > > >>>      introduces new bugs around that? at least enumerate them please.
> > > > > > > > >>
> > > > > > > > >> The current code did:
> > > > > > > > >>
> > > > > > > > >> 1) check for vq->broken
> > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > >>
> > > > > > > > >> So we won't end up with a never woke up process which should be fine.
> > > > > > > > >>
> > > > > > > > >> Thanks
> > > > > > > > >
> > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > >
> > > > > > > >
> > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > >
> > > > > > > > But consider we will start from a wait first, I will limit the changes
> > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > >
> > > > > > > > Thanks
> > > > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > >>>
> > > > > >
> > > >
> >

