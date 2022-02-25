Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950164C4ACC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243019AbiBYQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243011AbiBYQdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:33:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A32717F6BB;
        Fri, 25 Feb 2022 08:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98906B82BA4;
        Fri, 25 Feb 2022 16:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0342C340E7;
        Fri, 25 Feb 2022 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645806765;
        bh=nmnDc+36Xrw59fFSgr5Xbdk3JLUugb9ySIi917EU0MY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UXOy76J8Q8dxU/qCnJRWXoroO5i0QLTb9kYbpdfKrxXnGD3CfL26k+0WPiYtoPekp
         2cctTN8wDVStO9BqxITJKtLg10oAXrKQI9GIvtQ140kVLpZVlqxWrM/Z940wzV/2cf
         iiUuFC4FaCE9DV9j/pnS9nDnFfp8Bgu1IqS8B0SU=
Date:   Fri, 25 Feb 2022 17:32:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Peter Hutterer <peter.hutterer@redhat.com>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
Message-ID: <YhkEqpF6QSYeoMQn@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <YhjbzxxgxtSxFLe/@kroah.com>
 <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 05:00:53PM +0100, Benjamin Tissoires wrote:
> > > I plan on building a systemd intrinsic that would detect the HID
> > > VID/PID and then load the various BPF programs associated with the
> > > small fixes.
> > > Note that everything can not be fixed through eBPF, simply because at
> > > boot we don't always have the root partition mounted.
> >
> > Root partitions are now on HID devices?  :)
> 
> Sorry for not being clear :)
> 
> I mean that if you need a bpf program to be loaded from userspace at
> boot to make your keyboard functional, then you need to have the root
> partition mounted (or put the program in the initrd) so udev can load
> it. Now if your keyboard is supposed to give the password used to
> decrypt your root partition but you need a bpf program on that said
> partition to make it functional, you are screwed :)

True, but that's why the HID boot protocol was designed for keyboards
and mice, so that they "always" work.  Yeah, I know many devices ignore
it, oh well...

Anyway, the requirement of "if you need it to boot, don't make it a bpf
program" is fine, unless you can put the bpf program in a kernel module
(see my other response for that.)

> > > > > - Universal Stylus Interface (or any other new fancy feature that
> > > > >   requires a new kernel API)
> > > > >
> > > > > See [0].
> > > > > Basically, USI pens are requiring a new kernel API because there are
> > > > > some channels of communication our HID and input stack are not capable
> > > > > of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
> > > > > on eBPF to have the kernel API controlled by the consumer and to not
> > > > > impact the performances by waking up userspace every time there is an
> > > > > event.
> > > >
> > > > How is userspace supposed to interact with these devices in a unified
> > > > way then?  This would allow random new interfaces to be created, one
> > > > each for each device, and again, be a pain to track for a distro to keep
> > > > in sync.  And how are you going to keep the ebpf interface these
> > > > provides in sync with the userspace program?
> > >
> > > Right now, the idea we have is to export the USI specifics through
> > > dbus. This has a couple of advantages: we are not tied to USI and can
> > > "emulate" those parameters by storing them on disk instead of in the
> > > pen, and this is easily accessible from all applications directly.
> > >
> > > I am trying to push to have one implementation of that dbus service
> > > with the Intel and ChromeOS folks so general linux doesn't have to
> > > recreate it. But if you look at it, with hidraw nothing prevents
> > > someone from writing such a library/daemon in its own world without
> > > sharing it with anybody.
> > >
> > > The main advantage of eBPF compared to hidraw is that you can analyse
> > > the incoming event without waking userspace and only wake it up when
> > > there is something noticeable.
> >
> > That is a very good benefit, and one that many battery-powered devices
> > would like.
> >
> > > In terms of random interfaces, yes, this is a good point. But the way
> > > I see it is that we can provide one kernel API (eBPF for HID) which we
> > > will maintain and not have to maintain forever a badly designed kernel
> > > API for a specific device. Though also note that USI is a HID standard
> > > (I think there is a second one), so AFAICT, the same bpf program
> > > should be able to be generic enough to be cross vendor. So there will
> > > be one provider only for USI.
> >
> > Ok, that's good to know.
> >
> > <good stuff snipped>
> >
> > > Yeah, I completely understand the view. However, please keep in mind
> > > that most of it (though not firewall and some corner cases of tracing)
> > > is already possible to do through hidraw.
> > > One other example of that is SDL. We got Sony involved to create a
> > > nice driver for the DualSense controller (the PS5 one), but they
> > > simply ignore it and use plain HID (through hidraw). They have the
> > > advantage of this being cross-platform and can provide a consistent
> > > experience across platforms. And as a result, in the kernel, we have
> > > to hands up the handling of the device whenever somebody opens a
> > > hidraw node for those devices (Steam is also doing the same FWIW).
> > >
> > > Which reminds me that I also have another use-case: joystick
> > > dead-zone. You can have a small filter that configures the dead zone
> > > and doesn't even wake up userspace for those hardware glitches...
> >
> > hidraw is a big issue, and I understand why vendors use that and prefer
> > it over writing a kernel driver.  They can control it and ship it to
> > users and it makes life easier for them.  It's also what Windows has
> > been doing for decades now, so it's a comfortable interface for them to
> > write their code in userspace.
> >
> > But, now you are going to ask them to use bpf instead?  Why would they
> > switch off of hidraw to use this api?  What benefit are you going to
> > provide them here for that?
> 
> Again, there are 2 big classes of users of hid-bpf ("you" here is a
> developer in general):
> 1. you need to fix your device
> 2. you need to add a new kernel API
> 
> 2. can be entirely done with hidraw:
> - you open the hidraw node
> - you parse every incoming event
> - out of that you build up your high level API
> 
> This is what we are doing in libratbag for instance to support gaming
> mice that need extra features. We try to not read every single event,
> but some mice are done in a way we don't have a choice.
> 
> With bpf, you could:
> - load the bpf program
> - have the kernel (bpf program) parse the incoming report without
> waking up user space
> - when something changes (a given button is pressed) the bpf program
> notifies userspace with an event
> - then userspace builds its own API on top of it (forward that change
> through dbus for example)
> 
> As far as 1., the aim is not to replace hidraw but the kernel drivers
> themselves:
> instead of having a formal driver loaded in the kernel, you can rely
> on a bpf program to do whatever needs to be done to make the device
> working.
> 
> If the FW is wrong and the report descriptor messes up a button
> mapping, you can change that with bpf instead of having a specific
> driver for it.
> And of course, using hidraw for that just doesn't work because the
> event stream you get from hidraw is for the process only. In BPF, we
> can change the event flow for anybody, which allows much more power
> (but this is scarier too).
> 
> This class of bpf program should actually reside in the kernel tree so
> everybody can benefit from it (circling back to your first point).
> 
> So I am not deprecating hidraw nor I am not asking them to use bpf instead.
> But when you are interested in just one byte in the report, bpf allows
> you to speed up your program and save battery.

Ah, so really you are using bpf here as a "filter" for the HID events
that you care about to send to userspace or act apon in some way.  That
makes a lot more sense to me, sorry for not realizing it sooner.

So yes, I agree, HID control with bpf does make sense.  You can fix up
and filter out only the events you want without getting userspace
involved if it does not match.  That should make people's lives easier
(hopefully) and based on your example code you provide in this patch
series, it doesn't look all that complex.

Along this line, now I think I know what we can do for USB with bpf as
well.  Much the same thing, like a smart filter, which is what bpf was
designed for.  USB is just a stream of data like a network connection
with pipes and the like, so it will work quite well for this.

Ok, thanks for the explanations, you've sold me, nice work :)

One comment about the patch series.  You might want to break the patches
up a bit smaller, having the example code in a separate commit from the
"add this feature" commit, as it was hard to pick out what was kernel
changes, and what was test changes from it.  That way I can complain
about the example code and tests without having to worry about the
kernel patches.

thanks,

greg k-h
