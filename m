Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76674682597
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjAaHdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAaHdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:33:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC7E7DA5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675150381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vcjI8WcyEgNSwCwt0JBLFv7jmWpAvBsD9wjCRPmPHk=;
        b=NFIoFlDHRKBlBkJCxsjpevOJfyzrSPmI9tmzF3IX1m3BaCkfH2qNlQXWwuYkzpJyS0EuFs
        vkGWVZewx7WlrF64G4N7+N9kB+6zkF3A5AzMmaQd66ZvE3hTCiCG7hma4ejFwmLkLRYWHX
        qycj+0c7oCzSHPzbl3WequbnEEmVUtY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-QiNn_TLpN22vVRo-2nCghA-1; Tue, 31 Jan 2023 02:32:59 -0500
X-MC-Unique: QiNn_TLpN22vVRo-2nCghA-1
Received: by mail-ed1-f72.google.com with SMTP id q20-20020a056402519400b0049e5b8c71b3so9957090edd.17
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:32:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vcjI8WcyEgNSwCwt0JBLFv7jmWpAvBsD9wjCRPmPHk=;
        b=U/DCtQxjzqwAKlG6a2IlThGuwnTTtp2J6ivObeOePYIZu8EtBWER4r7utpyFhFwXe+
         txVZ0ESBQTEof1UKLBkWa12YUr3dkOrMRzMVDw9ECuJhhe1Ju1d51s5a4R16ppS4Rjac
         VilBsOC2aNE2pAQg9IGMDjSqBiei3ej6GiIrndY9cuNt7uF7kJHM7uyxJsZATdrSL0t8
         nmy2XsiSL5UvTpVUb+r97hYROucmYXd5M+EnlqNPpXp7gvVntItmcT7aqt4VeEAK2Kyx
         zcUsCspFTT3CPYdkdfniHuXzWVEkkW6G/RZr42zpaVE77SZm9/J0zOhTC3mAz+XnWP64
         s+SQ==
X-Gm-Message-State: AO0yUKUfRo7XDXsuXibnwN604oKnz5DGy8zfU6mZE3xLb1get4/nmxgm
        OgWcwmEaMwJHdg3qEWDhVx++uqiBvxje3/fkcHiqxuD2qG5yf7m71lFi18ptBITBQkMCqYQFlzz
        gFYi7npLc/nY+lRf9
X-Received: by 2002:a17:906:8d88:b0:888:bb84:7a73 with SMTP id ry8-20020a1709068d8800b00888bb847a73mr2323042ejc.56.1675150377825;
        Mon, 30 Jan 2023 23:32:57 -0800 (PST)
X-Google-Smtp-Source: AK7set8i6aT+JNkLxIkaZoJxfephCymJE0AQYUUlT4wDejMlAXZ2t/hRXrlfU1iUYbUgmYFzVOWRBg==
X-Received: by 2002:a17:906:8d88:b0:888:bb84:7a73 with SMTP id ry8-20020a1709068d8800b00888bb847a73mr2323024ejc.56.1675150377507;
        Mon, 30 Jan 2023 23:32:57 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090668ce00b0084d3bf4498csm8129202ejr.140.2023.01.30.23.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 23:32:56 -0800 (PST)
Date:   Tue, 31 Jan 2023 02:32:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: Re: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Message-ID: <20230131023204-mutt-send-email-mst@kernel.org>
References: <20221229030633-mutt-send-email-mst@kernel.org>
 <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org>
 <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
 <20230129022809-mutt-send-email-mst@kernel.org>
 <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
 <20230130003334-mutt-send-email-mst@kernel.org>
 <CACGkMEu0v-kbh2vKvcDRoMsRoXwidPnQhiFetYPY-tXOAVScsg@mail.gmail.com>
 <20230130061437-mutt-send-email-mst@kernel.org>
 <CACGkMEsk92FSyP6uMheAzkAPbnGfdCsq387fL9XqhfF6Z=Xmew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsk92FSyP6uMheAzkAPbnGfdCsq387fL9XqhfF6Z=Xmew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:24:52AM +0800, Jason Wang wrote:
> On Mon, Jan 30, 2023 at 7:18 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Jan 30, 2023 at 03:44:24PM +0800, Jason Wang wrote:
> > > On Mon, Jan 30, 2023 at 1:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Jan 30, 2023 at 10:53:54AM +0800, Jason Wang wrote:
> > > > > On Sun, Jan 29, 2023 at 3:30 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> > > > > > > On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > > > > > > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > > > > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@redhat.com> wrote:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > 在 2022/12/27 17:38, Michael S. Tsirkin 写道:
> > > > > > > > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > >> 在 2022/12/27 15:33, Michael S. Tsirkin 写道:
> > > > > > > > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason Wang wrote:
> > > > > > > > > > > > > > >>>>> But device is still going and will later use the buffers.
> > > > > > > > > > > > > > >>>>>
> > > > > > > > > > > > > > >>>>> Same for timeout really.
> > > > > > > > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals, another is to sleep.
> > > > > > > > > > > > > > >>>> If we think the timeout is hard, we can start from the wait.
> > > > > > > > > > > > > > >>>>
> > > > > > > > > > > > > > >>>> Thanks
> > > > > > > > > > > > > > >>> If the goal is to avoid disrupting traffic while CVQ is in use,
> > > > > > > > > > > > > > >>> that sounds more reasonable. E.g. someone is turning on promisc,
> > > > > > > > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >>> things we should be careful to address then:
> > > > > > > > > > > > > > >>> 1- debugging. Currently it's easy to see a warning if CPU is stuck
> > > > > > > > > > > > > > >>>      in a loop for a while, and we also get a backtrace.
> > > > > > > > > > > > > > >>>      E.g. with this - how do we know who has the RTNL?
> > > > > > > > > > > > > > >>>      We need to integrate with kernel/watchdog.c for good results
> > > > > > > > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> That's fine, will consider this.
> > > > > > > > > > > > >
> > > > > > > > > > > > > So after some investigation, it seems the watchdog.c doesn't help. The
> > > > > > > > > > > > > only export helper is touch_softlockup_watchdog() which tries to avoid
> > > > > > > > > > > > > triggering the lockups warning for the known slow path.
> > > > > > > > > > > >
> > > > > > > > > > > > I never said you can just use existing exporting APIs. You'll have to
> > > > > > > > > > > > write new ones :)
> > > > > > > > > > >
> > > > > > > > > > > Ok, I thought you wanted to trigger similar warnings as a watchdog.
> > > > > > > > > > >
> > > > > > > > > > > Btw, I wonder what kind of logic you want here. If we switch to using
> > > > > > > > > > > sleep, there won't be soft lockup anymore. A simple wait + timeout +
> > > > > > > > > > > warning seems sufficient?
> > > > > > > > > > >
> > > > > > > > > > > Thanks
> > > > > > > > > >
> > > > > > > > > > I'd like to avoid need to teach users new APIs. So watchdog setup to apply
> > > > > > > > > > to this driver. The warning can be different.
> > > > > > > > >
> > > > > > > > > Right, so it looks to me the only possible setup is the
> > > > > > > > > watchdog_thres. I plan to trigger the warning every watchdog_thres * 2
> > > > > > > > > second (as softlockup did).
> > > > > > > > >
> > > > > > > > > And I think it would still make sense to fail, we can start with a
> > > > > > > > > very long timeout like 1 minutes and break the device. Does this make
> > > > > > > > > sense?
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > I'd say we need to make this manageable then.
> > > > > > >
> > > > > > > Did you mean something like sysfs or module parameters?
> > > > > >
> > > > > > No I'd say pass it with an ioctl.
> > > > > >
> > > > > > > > Can't we do it normally
> > > > > > > > e.g. react to an interrupt to return to userspace?
> > > > > > >
> > > > > > > I didn't get the meaning of this. Sorry.
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > Standard way to handle things that can timeout and where userspace
> > > > > > did not supply the time is to block until an interrupt
> > > > > > then return EINTR.
> > > > >
> > > > > Well this seems to be a huge change, ioctl(2) doesn't say it can
> > > > > return EINTR now.
> > > >
> > > > the one on fedora 37 does not but it says:
> > > >        No single standard.  Arguments, returns, and semantics of ioctl() vary according to the device driver in question (the call  is
> > > >        used as a catch-all for operations that don't cleanly fit the UNIX stream I/O model).
> > > >
> > > > so it depends on the device e.g. for a streams device it does:
> > > > https://pubs.opengroup.org/onlinepubs/9699919799/functions/ioctl.html
> > > > has EINTR.
> > >
> > > Ok, I saw signal(7) also mention about EINTR for ioctl(2):
> > >
> > > """
> > >        If  a  blocked call to one of the following interfaces is
> > > interrupted by a signal handler, then the call is automatically
> > > restarted after the signal handler re‐
> > >        turns if the SA_RESTART flag was used; otherwise the call fails
> > > with the error EINTR:
> > >
> > >        * read(2), readv(2), write(2), writev(2), and ioctl(2) calls on
> > > "slow" devices.  A "slow" device is one where the I/O call may block
> > > for an indefinite time, for
> > >          example,  a  terminal,  pipe, or socket.  If an I/O call on a
> > > slow device has already transferred some data by the time it is
> > > interrupted by a signal handler,
> > >          then the call will return a success status (normally, the
> > > number of bytes transferred).  Note that a (local) disk is not a slow
> > > device according to this defi‐
> > >          nition; I/O operations on disk devices are not interrupted by signals.
> > > """
> >
> >
> > And note that if you interrupt then you don't know whether ioctl
> > changed device state or not generally.
> 
> Yes.
> 
> > > >
> > > >
> > > >
> > > > > Actually, a driver timeout is used by other drivers when using
> > > > > controlq/adminq (e.g i40e). Starting from a sane value (e.g 1 minutes
> > > > > to avoid false negatives) seems to be a good first step.
> > > >
> > > > Well because it's specific hardware so timeout matches what it can
> > > > promise.  virtio spec does not give guarantees.  One issue is with
> > > > software implementations. At the moment I can set a breakpoint in qemu
> > > > or vhost user backend and nothing bad happens in just continues.
> > >
> > > Yes but it should be no difference from using a kgdb to debug i40e drivers.
> >
> > Except one of the reasons people prefer programming in userspace is
> > because debugging is so much less painful. Someone using kgdb
> > knows what driver is doing and can work around that.
> 
> Ok.
> 
> >
> > > >
> > > >
> > > > > > Userspace controls the timeout by
> > > > > > using e.g. alarm(2).
> > > > >
> > > > > Not used in iproute2 after a git grep.
> > > > >
> > > > > Thanks
> > > >
> > > > No need for iproute2 to do it user can just do it from shell. Or user can just press CTRL-C.
> > >
> > > Yes, but iproute2 needs to deal with EINTR, that is the challenge
> > > part, if we simply return an error, the next cvq command might get
> > > confused.
> > >
> > > Thanks
> >
> > You mean this:
> >         start command
> >         interrupt
> >         start next command
> >
> > ?
> >
> > next command is confused?
> > I think if you try a new command until previous
> > one finished it's ok to just return EBUSY.
> 
> That would be fine.
> 
> And we go back to somehow the idea here:
> 
> https://lore.kernel.org/all/CACGkMEvQwhOhgGW6F22+3vmR4AW90qYXF+ZO6BQZguUF2xt2SA@mail.gmail.com/T/#m2da63932eae775d7d05d93d44c2f1d115ffbcefe
> 
> Will try to do that in the next version.
> 
> Thanks

Where you wrote:
	We can put the process into interruptible sleep, then it should be fine?

	(FYI, some transport specific methods may sleep e.g ccw).

indeed.


> >
> > > >
> > > > > >
> > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > >
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > > And before the patch, we end up with a real infinite loop which could
> > > > > > > > > > > > > be caught by RCU stall detector which is not the case of the sleep.
> > > > > > > > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > > > > > > > >
> > > > > > > > > > > > > Thanks
> > > > > > > > > > > >
> > > > > > > > > > > > Only with a bad device.
> > > > > > > > > > > >
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >>> 2- overhead. In a very common scenario when device is in hypervisor,
> > > > > > > > > > > > > > >>>      programming timers etc has a very high overhead, at bootup
> > > > > > > > > > > > > > >>>      lots of CVQ commands are run and slowing boot down is not nice.
> > > > > > > > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> Then we go back to the question of choosing a good timeout for poll. And
> > > > > > > > > > > > > > >> poll seems problematic in the case of UP, scheduler might not have the
> > > > > > > > > > > > > > >> chance to run.
> > > > > > > > > > > > > > > Poll just a bit :) Seriously I don't know, but at least check once
> > > > > > > > > > > > > > > after kick.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > I think it is what the current code did where the condition will be
> > > > > > > > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > >>> 3- suprise removal. need to wake up thread in some way. what about
> > > > > > > > > > > > > > >>>      other cases of device breakage - is there a chance this
> > > > > > > > > > > > > > >>>      introduces new bugs around that? at least enumerate them please.
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> The current code did:
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> 1) check for vq->broken
> > > > > > > > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> So we won't end up with a never woke up process which should be fine.
> > > > > > > > > > > > > > >>
> > > > > > > > > > > > > > >> Thanks
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not sure that is a good
> > > > > > > > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > But consider we will start from a wait first, I will limit the changes
> > > > > > > > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > Thanks
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > >>>
> > > > > > > > > > > >
> > > > > > > > > >
> > > > > > > >
> > > > > >
> > > >
> >

