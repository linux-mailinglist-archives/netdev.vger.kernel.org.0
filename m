Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803966806B4
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjA3Hpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjA3Hpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:45:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B91A495
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 23:44:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675064680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IfsxRwrwu42vZaiOw4wSj9ooVENnKFYCWw2J/v4KL84=;
        b=jBQtryLJXJpKQDq8so4Bypy28y8OkErL1oQiesGFsTBpT+bKb5T9SBcl6KpN6SHXWdvbBm
        gcHheZSUWaKyu4K4Iv5eJAfNAvoiK/+T0+QJ57HCEOfkYVMwUNG8u9lfb8NOFAyvZGzh8H
        0YIxX0E7C2PLgaZy/O5IIESREMMisho=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-GtD0ezTuP9uk0-fWHz-cvw-1; Mon, 30 Jan 2023 02:44:36 -0500
X-MC-Unique: GtD0ezTuP9uk0-fWHz-cvw-1
Received: by mail-oi1-f198.google.com with SMTP id u132-20020aca608a000000b00364e4f26dd3so4900765oib.3
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 23:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IfsxRwrwu42vZaiOw4wSj9ooVENnKFYCWw2J/v4KL84=;
        b=h5cwcXHhUYkIuT3fjJ46hyMjWfsVxPIgglgnZ6S6EPRXY6Ja8VOROsudRMQnW6ABw3
         Yzl+5bKVyoZIVA3HP0EwyaxNyOm/aCXnDKcx815flfhg37rXHaH1m+CbdBtGdsYU1fQc
         DB2Yj0bRvz0uYpS2A80l5Yh0DbErEuaefr5+0jH13gW2eDii/Z21R3JsoyhAv2D6IAQD
         qkF9znTTt/Fy6JkdacaCNcAEEG6Uk0sRE3gkFaPJh6PJA+l79VyX041z91Iogek2kUcC
         EwyDQhzINqoGlcMETzrVBWiXIQFAG2RsFMEMSDKT9BWyFpRfyC8PgQ3JIBGSI2Obr7pq
         Q5uA==
X-Gm-Message-State: AO0yUKVXV1EUsOXUFt06zqDl5lSG9hz4HGxvKSBgtW7dDe9tFB861BuX
        ZaCM/nqYv9D6C3aWGdfVL138y2z3e1YDfR+tt0GoX51Df07uxOn+ernDGcY+6vbj5m+Gb2aZPAQ
        oSZcDg8jlLaXstymNGIEv83HdkoASm5S8
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id k30-20020a056870959e00b001639ceaeea7mr296166oao.35.1675064675626;
        Sun, 29 Jan 2023 23:44:35 -0800 (PST)
X-Google-Smtp-Source: AK7set+aQPAKyAPfHNJ0Xk76LMscbAi71N7VBp8BSAhSQ5QVi89w2CuqgyJztGEUVEEMiWNskmo6eTc++9HGfQU0UPw=
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id
 k30-20020a056870959e00b001639ceaeea7mr296160oao.35.1675064675326; Sun, 29 Jan
 2023 23:44:35 -0800 (PST)
MIME-Version: 1.0
References: <0d9f1b89-9374-747b-3fb0-b4b28ad0ace1@redhat.com>
 <CACGkMEv=+D+Es4sfde_X7F0zspVdy4Rs1Wi9qfCudsznsUrOTQ@mail.gmail.com>
 <20221229020553-mutt-send-email-mst@kernel.org> <CACGkMEs5s3Muo+4OfjaLK_P76rTdPhjQdTwykRNGOecAWnt+8g@mail.gmail.com>
 <20221229030633-mutt-send-email-mst@kernel.org> <CACGkMEukqZX=6yz1yCj+psHp5c+ZGVVuEYTUssfRCTQZgVWS6g@mail.gmail.com>
 <20230127053112-mutt-send-email-mst@kernel.org> <CACGkMEsZs=6TaeSUnu_9Rf+38uisi6ViHyM50=2+ut3Wze2S1g@mail.gmail.com>
 <20230129022809-mutt-send-email-mst@kernel.org> <CACGkMEuya+_2P8d4hokoyL_LKGdVzyCC1nDwOCdZb0=+2rjKPQ@mail.gmail.com>
 <20230130003334-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230130003334-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 30 Jan 2023 15:44:24 +0800
Message-ID: <CACGkMEu0v-kbh2vKvcDRoMsRoXwidPnQhiFetYPY-tXOAVScsg@mail.gmail.com>
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

On Mon, Jan 30, 2023 at 1:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jan 30, 2023 at 10:53:54AM +0800, Jason Wang wrote:
> > On Sun, Jan 29, 2023 at 3:30 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Sun, Jan 29, 2023 at 01:48:49PM +0800, Jason Wang wrote:
> > > > On Fri, Jan 27, 2023 at 6:35 PM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
> > > > >
> > > > > On Fri, Dec 30, 2022 at 11:43:08AM +0800, Jason Wang wrote:
> > > > > > On Thu, Dec 29, 2022 at 4:10 PM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > > > > > >
> > > > > > > On Thu, Dec 29, 2022 at 04:04:13PM +0800, Jason Wang wrote:
> > > > > > > > On Thu, Dec 29, 2022 at 3:07 PM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Wed, Dec 28, 2022 at 07:53:08PM +0800, Jason Wang wrot=
e:
> > > > > > > > > > On Wed, Dec 28, 2022 at 2:34 PM Jason Wang <jasowang@re=
dhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > =E5=9C=A8 2022/12/27 17:38, Michael S. Tsirkin =E5=86=
=99=E9=81=93:
> > > > > > > > > > > > On Tue, Dec 27, 2022 at 05:12:58PM +0800, Jason Wan=
g wrote:
> > > > > > > > > > > >> =E5=9C=A8 2022/12/27 15:33, Michael S. Tsirkin =E5=
=86=99=E9=81=93:
> > > > > > > > > > > >>> On Tue, Dec 27, 2022 at 12:30:35PM +0800, Jason W=
ang wrote:
> > > > > > > > > > > >>>>> But device is still going and will later use th=
e buffers.
> > > > > > > > > > > >>>>>
> > > > > > > > > > > >>>>> Same for timeout really.
> > > > > > > > > > > >>>> Avoiding infinite wait/poll is one of the goals,=
 another is to sleep.
> > > > > > > > > > > >>>> If we think the timeout is hard, we can start fr=
om the wait.
> > > > > > > > > > > >>>>
> > > > > > > > > > > >>>> Thanks
> > > > > > > > > > > >>> If the goal is to avoid disrupting traffic while =
CVQ is in use,
> > > > > > > > > > > >>> that sounds more reasonable. E.g. someone is turn=
ing on promisc,
> > > > > > > > > > > >>> a spike in CPU usage might be unwelcome.
> > > > > > > > > > > >>
> > > > > > > > > > > >> Yes, this would be more obvious is UP is used.
> > > > > > > > > > > >>
> > > > > > > > > > > >>
> > > > > > > > > > > >>> things we should be careful to address then:
> > > > > > > > > > > >>> 1- debugging. Currently it's easy to see a warnin=
g if CPU is stuck
> > > > > > > > > > > >>>      in a loop for a while, and we also get a bac=
ktrace.
> > > > > > > > > > > >>>      E.g. with this - how do we know who has the =
RTNL?
> > > > > > > > > > > >>>      We need to integrate with kernel/watchdog.c =
for good results
> > > > > > > > > > > >>>      and to make sure policy is consistent.
> > > > > > > > > > > >>
> > > > > > > > > > > >> That's fine, will consider this.
> > > > > > > > > >
> > > > > > > > > > So after some investigation, it seems the watchdog.c do=
esn't help. The
> > > > > > > > > > only export helper is touch_softlockup_watchdog() which=
 tries to avoid
> > > > > > > > > > triggering the lockups warning for the known slow path.
> > > > > > > > >
> > > > > > > > > I never said you can just use existing exporting APIs. Yo=
u'll have to
> > > > > > > > > write new ones :)
> > > > > > > >
> > > > > > > > Ok, I thought you wanted to trigger similar warnings as a w=
atchdog.
> > > > > > > >
> > > > > > > > Btw, I wonder what kind of logic you want here. If we switc=
h to using
> > > > > > > > sleep, there won't be soft lockup anymore. A simple wait + =
timeout +
> > > > > > > > warning seems sufficient?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > I'd like to avoid need to teach users new APIs. So watchdog s=
etup to apply
> > > > > > > to this driver. The warning can be different.
> > > > > >
> > > > > > Right, so it looks to me the only possible setup is the
> > > > > > watchdog_thres. I plan to trigger the warning every watchdog_th=
res * 2
> > > > > > second (as softlockup did).
> > > > > >
> > > > > > And I think it would still make sense to fail, we can start wit=
h a
> > > > > > very long timeout like 1 minutes and break the device. Does thi=
s make
> > > > > > sense?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > I'd say we need to make this manageable then.
> > > >
> > > > Did you mean something like sysfs or module parameters?
> > >
> > > No I'd say pass it with an ioctl.
> > >
> > > > > Can't we do it normally
> > > > > e.g. react to an interrupt to return to userspace?
> > > >
> > > > I didn't get the meaning of this. Sorry.
> > > >
> > > > Thanks
> > >
> > > Standard way to handle things that can timeout and where userspace
> > > did not supply the time is to block until an interrupt
> > > then return EINTR.
> >
> > Well this seems to be a huge change, ioctl(2) doesn't say it can
> > return EINTR now.
>
> the one on fedora 37 does not but it says:
>        No single standard.  Arguments, returns, and semantics of ioctl() =
vary according to the device driver in question (the call  is
>        used as a catch-all for operations that don't cleanly fit the UNIX=
 stream I/O model).
>
> so it depends on the device e.g. for a streams device it does:
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/ioctl.html
> has EINTR.

Ok, I saw signal(7) also mention about EINTR for ioctl(2):

"""
       If  a  blocked call to one of the following interfaces is
interrupted by a signal handler, then the call is automatically
restarted after the signal handler re=E2=80=90
       turns if the SA_RESTART flag was used; otherwise the call fails
with the error EINTR:

       * read(2), readv(2), write(2), writev(2), and ioctl(2) calls on
"slow" devices.  A "slow" device is one where the I/O call may block
for an indefinite time, for
         example,  a  terminal,  pipe, or socket.  If an I/O call on a
slow device has already transferred some data by the time it is
interrupted by a signal handler,
         then the call will return a success status (normally, the
number of bytes transferred).  Note that a (local) disk is not a slow
device according to this defi=E2=80=90
         nition; I/O operations on disk devices are not interrupted by sign=
als.
"""

>
>
>
> > Actually, a driver timeout is used by other drivers when using
> > controlq/adminq (e.g i40e). Starting from a sane value (e.g 1 minutes
> > to avoid false negatives) seems to be a good first step.
>
> Well because it's specific hardware so timeout matches what it can
> promise.  virtio spec does not give guarantees.  One issue is with
> software implementations. At the moment I can set a breakpoint in qemu
> or vhost user backend and nothing bad happens in just continues.

Yes but it should be no difference from using a kgdb to debug i40e drivers.

>
>
> > > Userspace controls the timeout by
> > > using e.g. alarm(2).
> >
> > Not used in iproute2 after a git grep.
> >
> > Thanks
>
> No need for iproute2 to do it user can just do it from shell. Or user can=
 just press CTRL-C.

Yes, but iproute2 needs to deal with EINTR, that is the challenge
part, if we simply return an error, the next cvq command might get
confused.

Thanks

>
> > >
> > >
> > > > >
> > > > >
> > > > >
> > > > > > >
> > > > > > >
> > > > > > > > >
> > > > > > > > > > And before the patch, we end up with a real infinite lo=
op which could
> > > > > > > > > > be caught by RCU stall detector which is not the case o=
f the sleep.
> > > > > > > > > > What we can do is probably do a periodic netdev_err().
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > > Only with a bad device.
> > > > > > > > >
> > > > > > > > > > > >>
> > > > > > > > > > > >>
> > > > > > > > > > > >>> 2- overhead. In a very common scenario when devic=
e is in hypervisor,
> > > > > > > > > > > >>>      programming timers etc has a very high overh=
ead, at bootup
> > > > > > > > > > > >>>      lots of CVQ commands are run and slowing boo=
t down is not nice.
> > > > > > > > > > > >>>      let's poll for a bit before waiting?
> > > > > > > > > > > >>
> > > > > > > > > > > >> Then we go back to the question of choosing a good=
 timeout for poll. And
> > > > > > > > > > > >> poll seems problematic in the case of UP, schedule=
r might not have the
> > > > > > > > > > > >> chance to run.
> > > > > > > > > > > > Poll just a bit :) Seriously I don't know, but at l=
east check once
> > > > > > > > > > > > after kick.
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > I think it is what the current code did where the con=
dition will be
> > > > > > > > > > > check before trying to sleep in the wait_event().
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >>> 3- suprise removal. need to wake up thread in som=
e way. what about
> > > > > > > > > > > >>>      other cases of device breakage - is there a =
chance this
> > > > > > > > > > > >>>      introduces new bugs around that? at least en=
umerate them please.
> > > > > > > > > > > >>
> > > > > > > > > > > >> The current code did:
> > > > > > > > > > > >>
> > > > > > > > > > > >> 1) check for vq->broken
> > > > > > > > > > > >> 2) wakeup during BAD_RING()
> > > > > > > > > > > >>
> > > > > > > > > > > >> So we won't end up with a never woke up process wh=
ich should be fine.
> > > > > > > > > > > >>
> > > > > > > > > > > >> Thanks
> > > > > > > > > > > >
> > > > > > > > > > > > BTW BAD_RING on removal will trigger dev_err. Not s=
ure that is a good
> > > > > > > > > > > > idea - can cause crashes if kernel panics on error.
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > Yes, it's better to use __virtqueue_break() instead.
> > > > > > > > > > >
> > > > > > > > > > > But consider we will start from a wait first, I will =
limit the changes
> > > > > > > > > > > in virtio-net without bothering virtio core.
> > > > > > > > > > >
> > > > > > > > > > > Thanks
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > >>>
> > > > > > > > >
> > > > > > >
> > > > >
> > >
>

