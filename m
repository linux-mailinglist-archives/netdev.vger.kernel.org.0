Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCBE680BC6
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbjA3LT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236528AbjA3LTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:19:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BAF27486
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 03:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675077523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuwxhmjWIAN3v39gRLVBeac9rDc0P4cxVL+DwOXcc6U=;
        b=fQPkRGQckR4qp8Nfphj06XwcU+2hnOF1NBORjRY5SEHUW4KOPWkUiIOteMqlQtE+M0l2CA
        XhX4dlzBSJkkw9pGhgKhQjSb6h4M3zkbXvl1qOpfCN2u1/cC6x9HtjzXWa2ilDztXoVufz
        8Tzwe/y7lC5eTbbL2BBmOIpbDJL2di4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-HYEBqdouPNWzo0BghfO84Q-1; Mon, 30 Jan 2023 06:18:42 -0500
X-MC-Unique: HYEBqdouPNWzo0BghfO84Q-1
Received: by mail-wm1-f71.google.com with SMTP id l8-20020a05600c1d0800b003dc25f6bb5dso7427978wms.0
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 03:18:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uuwxhmjWIAN3v39gRLVBeac9rDc0P4cxVL+DwOXcc6U=;
        b=fWTzvRIXaxSt/a1NKaC+tOvjfztAZa/XaisDuOfxgVh7gGwh9eH5oGX5Hxli62dGhI
         qs/VxWZD1m5wAvY+ohQWmFPtpvzi8PcB32x0XPbQOZaSi26v0IpK8LuzKVA19tgFKSRT
         XfZIyUEPuvjs7FPx+A6VGrXi+aPpZQTWD52DNwkf6J+7iCmAMZyGXYUUF7J/gJsVYumY
         iI5O4eF+4nSKj5oUZVUGzZsXaUG2A9N5ed97eT2YEp3aiZVhu56NlyoRmkatHdHBBQbO
         PUk98hfZIE3MZPHVyIALAjimQnCPvecRkf6ERSNU7Xmt0/zJemR6AMX7zyZhkaP970Vn
         Yx8g==
X-Gm-Message-State: AFqh2krEZ40FZxwwDrFT/caKXoE0FIgy+ocaU4gjCqs+P6UF809vt4uX
        xbJ04+iGInhUCqVlJuVNPvSwwwiBNyqZCz3n8jor/naEuYaYaViAb9RFsDB1wTYs63Zf8mjla9e
        UFlMig6TftC66ugUe
X-Received: by 2002:a1c:6a10:0:b0:3da:f665:5b66 with SMTP id f16-20020a1c6a10000000b003daf6655b66mr52243120wmc.6.1675077518877;
        Mon, 30 Jan 2023 03:18:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt+t1LRVdTlv287q42Qivh7SsCezdlogXmrqsEUH3G2u/ZO2WZs98t1J3QnaD2f+l4Rzybnng==
X-Received: by 2002:a1c:6a10:0:b0:3da:f665:5b66 with SMTP id f16-20020a1c6a10000000b003daf6655b66mr52243095wmc.6.1675077518600;
        Mon, 30 Jan 2023 03:18:38 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id y21-20020a05600c341500b003da28dfdedcsm6645556wmp.5.2023.01.30.03.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 03:18:38 -0800 (PST)
Date:   Mon, 30 Jan 2023 06:18:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20230130061437-mutt-send-email-mst@kernel.org>
References: <20221229020553-mutt-send-email-mst@kernel.org>
 <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org>
 <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org>
 <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
 <20230129022809-mutt-send-email-mst@kernel.org>
 <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
 <20230130003334-mutt-send-email-mst@kernel.org>
 <CACGkMEu0v-kbh2vKvcDRoMsRoXwidPnQhiFetYPY-tXOAVScsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu0v-kbh2vKvcDRoMsRoXwidPnQhiFetYPY-tXOAVScsg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 03:44:24PM +0800, Jason Wang wrote:
> On Mon, Jan 30, 2023 at 1:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 10:53:54AM +0800, Jason Wang wrote:
> > > On Sun, Jan 29, 2023 at 3:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> > > > > On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > > > > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > 在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> > > > > > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > > > > > > > >> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > > > > > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > > > > > > > > >>>>> But device is still going and will later use the buffers.
> > > > > > > > > > > > >>>>>
> > > > > > > > > > > > >>>>> Same for timeout really.
> > > > > > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > > > > > > > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > > > > > > > > >>>>
> > > > > > > > > > > > >>>> Thanks
> > > > > > > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> > > > > > > > > > > > >>> that sounds more reasonable. E.g. someone is turning on promisc,
> > > > > > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > > > > > >>
> > > > > > > > > > > > >>
> > > > > > > > > > > > >>> things we should be careful to address then:
> > > > > > > > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> > > > > > > > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > > > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > > > > > > > >>>      We need to integrate with kernel/watchdog.c for good results
> > > > > > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> That's fine, will consider this.
> > > > > > > > > > >
> > > > > > > > > > > So after some investigation, it seems the watchdog.c doesn't help. The
> > > > > > > > > > > only export helper is touch_softlockup_watchdog() which tries to avoid
> > > > > > > > > > > triggering the lockups warning for the known slow path.
> > > > > > > > > >
> > > > > > > > > > I never said you can just use existing exporting APIs. You'll have to
> > > > > > > > > > write new ones :)
> > > > > > > > >
> > > > > > > > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > > > > > > > >
> > > > > > > > > Btw, I wonder what kind of logic you want here. If we switch to using
> > > > > > > > > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > > > > > > > > warning seems sufficient?
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > I'd like to avoid need to teach users new APIs. So watchdog setup to apply
> > > > > > > > to this driver. The warning can be different.
> > > > > > >
> > > > > > > Right, so it looks to me the only possible setup is the
> > > > > > > watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> > > > > > > second (as softlockup did).
> > > > > > >
> > > > > > > And I think it would still make sense to fail, we can start with a
> > > > > > > very long timeout like 1 minutes and break the device. Does this make
> > > > > > > sense?
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > I'd say we need to make this manageable then.
> > > > >
> > > > > Did you mean something like sysfs or module parameters?
> > > >
> > > > No I'd say pass it with an ioctl.
> > > >
> > > > > > Can't we do it normally
> > > > > > e.g. react to an interrupt to return to userspace?
> > > > >
> > > > > I didn't get the meaning of this. Sorry.
> > > > >
> > > > > Thanks
> > > >
> > > > Standard way to handle things that can timeout and where userspace
> > > > did not supply the time is to block until an interrupt
> > > > then return EINTR.
> > >
> > > Well this seems to be a huge change, ioctl(2) doesn't say it can
> > > return EINTR now.
> >
> > the one on fedora 37 does not but it says:
> >        No single standard.  Arguments, returns, and semantics of ioctl() vary according to the device driver in question (the call  is
> >        used as a catch-all for operations that don't cleanly fit the UNIX stream I/O model).
> >
> > so it depends on the device e.g. for a streams device it does:
> > https://pubs.opengroup.org/onlinepubs/9699919799/functions/ioctl.html
> > has EINTR.
> 
> Ok, I saw signal(7) also mention about EINTR for ioctl(2):
> 
> """
>        If  a  blocked call to one of the following interfaces is
> interrupted by a signal handler, then the call is automatically
> restarted after the signal handler re‐
>        turns if the SA_RESTART flag was used; otherwise the call fails
> with the error EINTR:
> 
>        * read(2), readv(2), write(2), writev(2), and ioctl(2) calls on
> "slow" devices.  A "slow" device is one where the I/O call may block
> for an indefinite time, for
>          example,  a  terminal,  pipe, or socket.  If an I/O call on a
> slow device has already transferred some data by the time it is
> interrupted by a signal handler,
>          then the call will return a success status (normally, the
> number of bytes transferred).  Note that a (local) disk is not a slow
> device according to this defi‐
>          nition; I/O operations on disk devices are not interrupted by signals.
> """


And note that if you interrupt then you don't know whether ioctl
changed device state or not generally.
> >
> >
> >
> > > Actually, a driver timeout is used by other drivers when using
> > > controlq/adminq (e.g i40e). Starting from a sane value (e.g 1 minutes
> > > to avoid false negatives) seems to be a good first step.
> >
> > Well because it's specific hardware so timeout matches what it can
> > promise.  virtio spec does not give guarantees.  One issue is with
> > software implementations. At the moment I can set a breakpoint in qemu
> > or vhost user backend and nothing bad happens in just continues.
> 
> Yes but it should be no difference from using a kgdb to debug i40e drivers.

Except one of the reasons people prefer programming in userspace is
because debugging is so much less painful. Someone using kgdb
knows what driver is doing and can work around that.

> >
> >
> > > > Userspace controls the timeout by
> > > > using e.g. alarm(2).
> > >
> > > Not used in iproute2 after a git grep.
> > >
> > > Thanks
> >
> > No need for iproute2 to do it user can just do it from shell. Or user can just press CTRL-C.
> 
> Yes, but iproute2 needs to deal with EINTR, that is the challenge
> part, if we simply return an error, the next cvq command might get
> confused.
> 
> Thanks

You mean this:
	start command
	interrupt
	start next command

?

next command is confused?
I think if you try a new command until previous
one finished it's ok to just return EBUSY.

> >
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > And before the patch, we end up with a real infinite loop which could
> > > > > > > > > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > > > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > > > > > >
> > > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > > Only with a bad device.
> > > > > > > > > >
> > > > > > > > > > > > >>
> > > > > > > > > > > > >>
> > > > > > > > > > > > >>> 2- overhead. In a very common scenario when device is in hypervisor,
> > > > > > > > > > > > >>>      programming timers etc has a very high overhead, at bootup
> > > > > > > > > > > > >>>      lots of CVQ commands are run and slowing boot down is not nice.
> > > > > > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> Then we go back to the question of choosing a good timeout for poll. And
> > > > > > > > > > > > >> poll seems problematic in the case of UP, scheduler might not have the
> > > > > > > > > > > > >> chance to run.
> > > > > > > > > > > > > Poll just a bit :) Seriously I don't know, but at least check once
> > > > > > > > > > > > > after kick.
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > I think it is what the current code did where the condition will be
> > > > > > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > >>> 3- suprise removal. need to wake up thread in some way. what about
> > > > > > > > > > > > >>>      other cases of device breakage - is there a chance this
> > > > > > > > > > > > >>>      introduces new bugs around that? at least enumerate them please.
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> The current code did:
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> 1) check for vq->broken
> > > > > > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> So we won't end up with a never woke up process which should be fine.
> > > > > > > > > > > > >>
> > > > > > > > > > > > >> Thanks
> > > > > > > > > > > > >
> > > > > > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > > > > > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > > > > > >
> > > > > > > > > > > > But consider we will start from a wait first, I will limit the changes
> > > > > > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks
> > > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > >>>
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > >
> >

