Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54A724C46BA
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 14:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbiBYNjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 08:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiBYNjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 08:39:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3F41DAC54;
        Fri, 25 Feb 2022 05:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A540B830B9;
        Fri, 25 Feb 2022 13:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47125C340E7;
        Fri, 25 Feb 2022 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645796305;
        bh=SXy+1+eBw7B60nCfnbDG6PFGGDDD4JeadcvuGUO51h8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e6HBPKExY2v9I/A3xmaxhTiWlN1qQ+dTiDgJflanOwf+1H9vWG7gBXlq7iWpcpU18
         u+KncoLteagq406KuzV05+5L8VEqEz4v/qMTlB9v2w/CcC2mJC2GqqKcopybvYFZ14
         Bvm3ZSpUcHMHJX3r7PbV09So/7Vecuy+7UYCe/oM=
Date:   Fri, 25 Feb 2022 14:38:23 +0100
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
Message-ID: <YhjbzxxgxtSxFLe/@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 02:49:21PM +0100, Benjamin Tissoires wrote:
> Hi Greg,
> 
> Thanks for the quick answer :)
> 
> On Thu, Feb 24, 2022 at 12:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
> > > Hi there,
> > >
> > > This series introduces support of eBPF for HID devices.
> > >
> > > I have several use cases where eBPF could be interesting for those
> > > input devices:
> > >
> > > - simple fixup of report descriptor:
> > >
> > > In the HID tree, we have half of the drivers that are "simple" and
> > > that just fix one key or one byte in the report descriptor.
> > > Currently, for users of such devices, the process of fixing them
> > > is long and painful.
> > > With eBPF, we could externalize those fixups in one external repo,
> > > ship various CoRe bpf programs and have those programs loaded at boot
> > > time without having to install a new kernel (and wait 6 months for the
> > > fix to land in the distro kernel)
> >
> > Why would a distro update such an external repo faster than they update
> > the kernel?  Many sane distros update their kernel faster than other
> > packages already, how about fixing your distro?  :)
> 
> Heh, I'm going to try to dodge the incoming rhel bullet :)
> 
> It's true that thanks to the work of the stable folks we don't have to
> wait 6 months for a fix to come in. However, I think having a single
> file to drop in a directory would be easier for development/testing
> (and distribution of that file between developers/testers) than
> requiring people to recompile their kernel.
> 
> Brain fart: is there any chance we could keep the validated bpf
> programs in the kernel tree?

That would make the most sense to me.  And allow "slow" distros to
override the HID bpf quirks easily if they need to.  If you do that,
then most of my objections of the "now the code is in two places that
you have to track" goes away :)

> > I'm all for the idea of using ebpf for HID devices, but now we have to
> > keep track of multiple packages to be in sync here.  Is this making
> > things harder overall?
> 
> Probably, and this is also maybe opening a can of worms. Vendors will
> be able to say "use that bpf program for my HID device because the
> firmware is bogus".
> 
> OTOH, as far as I understand, you can not load a BPF program in the
> kernel that uses GPL-declared functions if your BPF program is not
> GPL. Which means that if firmware vendors want to distribute blobs
> through BPF, either it's GPL and they have to provide the sources, or
> it's not happening.

You can make the new HID bpf api only availble to GPL programs, and if I
were you, that's what I would do just to keep any legal issues from
coming up.  Also bundling it with the kernel makes it easier.

> I am not entirely clear on which plan I want to have for userspace.
> I'd like to have libinput on board, but right now, Peter's stance is
> "not in my garden" (and he has good reasons for it).
> So my initial plan is to cook and hold the bpf programs in hid-tools,
> which is the repo I am using for the regression tests on HID.

Why isn't the hid regression tests in the kernel tree also?  That would
allow all of the testers out there to test things much easier than
having to suck down another test repo (like Linaro and 0-day and
kernelci would be forced to do).

> I plan on building a systemd intrinsic that would detect the HID
> VID/PID and then load the various BPF programs associated with the
> small fixes.
> Note that everything can not be fixed through eBPF, simply because at
> boot we don't always have the root partition mounted.

Root partitions are now on HID devices?  :)

> > > - Universal Stylus Interface (or any other new fancy feature that
> > >   requires a new kernel API)
> > >
> > > See [0].
> > > Basically, USI pens are requiring a new kernel API because there are
> > > some channels of communication our HID and input stack are not capable
> > > of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
> > > on eBPF to have the kernel API controlled by the consumer and to not
> > > impact the performances by waking up userspace every time there is an
> > > event.
> >
> > How is userspace supposed to interact with these devices in a unified
> > way then?  This would allow random new interfaces to be created, one
> > each for each device, and again, be a pain to track for a distro to keep
> > in sync.  And how are you going to keep the ebpf interface these
> > provides in sync with the userspace program?
> 
> Right now, the idea we have is to export the USI specifics through
> dbus. This has a couple of advantages: we are not tied to USI and can
> "emulate" those parameters by storing them on disk instead of in the
> pen, and this is easily accessible from all applications directly.
> 
> I am trying to push to have one implementation of that dbus service
> with the Intel and ChromeOS folks so general linux doesn't have to
> recreate it. But if you look at it, with hidraw nothing prevents
> someone from writing such a library/daemon in its own world without
> sharing it with anybody.
> 
> The main advantage of eBPF compared to hidraw is that you can analyse
> the incoming event without waking userspace and only wake it up when
> there is something noticeable.

That is a very good benefit, and one that many battery-powered devices
would like.

> In terms of random interfaces, yes, this is a good point. But the way
> I see it is that we can provide one kernel API (eBPF for HID) which we
> will maintain and not have to maintain forever a badly designed kernel
> API for a specific device. Though also note that USI is a HID standard
> (I think there is a second one), so AFAICT, the same bpf program
> should be able to be generic enough to be cross vendor. So there will
> be one provider only for USI.

Ok, that's good to know.

<good stuff snipped>

> Yeah, I completely understand the view. However, please keep in mind
> that most of it (though not firewall and some corner cases of tracing)
> is already possible to do through hidraw.
> One other example of that is SDL. We got Sony involved to create a
> nice driver for the DualSense controller (the PS5 one), but they
> simply ignore it and use plain HID (through hidraw). They have the
> advantage of this being cross-platform and can provide a consistent
> experience across platforms. And as a result, in the kernel, we have
> to hands up the handling of the device whenever somebody opens a
> hidraw node for those devices (Steam is also doing the same FWIW).
> 
> Which reminds me that I also have another use-case: joystick
> dead-zone. You can have a small filter that configures the dead zone
> and doesn't even wake up userspace for those hardware glitches...

hidraw is a big issue, and I understand why vendors use that and prefer
it over writing a kernel driver.  They can control it and ship it to
users and it makes life easier for them.  It's also what Windows has
been doing for decades now, so it's a comfortable interface for them to
write their code in userspace.

But, now you are going to ask them to use bpf instead?  Why would they
switch off of hidraw to use this api?  What benefit are you going to
provide them here for that?

This is why I've delayed doing bpf for USB.  Right now we have a nice
cross-platform way to write userspace USB drivers using usbfs/libusb.
All a bpf api to USB would be doing is much the same thing that libusb
does, for almost no real added benefit that I can tell.

USB, is a really "simple" networking like protocol (send/recieve
packets).  So it ties into the bpf model well.  But the need to use bpf
for USB so far I don't have a real justification.

And the same thing here.  Yes it is cool, and personally I love it, but
what is going to get people off of hidraw to use this instead?  You
can'd drop hidraw now (just like I can't drop usbfs), so all this means
is we have yet-another-way to do something on the system.  Is that a
good idea?  I don't know.

Also you mention dbus as the carrier for the HID information to
userspace programs.  Is dbus really the right thing for sending streams
of input data around?  Yes it will probably work, but I don't think it
was designed for that at all, so the overhead involved might just
overshadow any of the improvements you made using bpf.  And also, you
could do this today with hidraw, right?

> Anyway, IOW, I think the bpf approach will allow kernel-like
> performances of hidraw applications, and I would be more inclined to
> ask people to move their weird issue in userspace thanks to that.

I like this from a "everyone should use bpf" point of view, but how are
you going to tell people "use bpf over hidraw" in a way that gets them
to do so?  If you have a good answer for that, I might just steal it for
the bpf-USB interface as well :)

thanks,

greg k-h
