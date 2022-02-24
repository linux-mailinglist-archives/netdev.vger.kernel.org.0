Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 362244C2AF9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiBXLbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiBXLbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:31:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B12294FE6;
        Thu, 24 Feb 2022 03:31:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E1A761775;
        Thu, 24 Feb 2022 11:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0122CC340E9;
        Thu, 24 Feb 2022 11:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645702277;
        bh=ROyzaggUh4Lbnoq0CGgj+rVYyRl1j3Fnbe8TafmpJ44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfoGSXm4DHLAdWImMth3fgtl+ZDXpjUUDAQcNaWzPrpWhan6LYiC7gNyK6lx5tkoX
         5/hl3dR90OiswNILwYBjPLE6JTEd/GwFNV4S1nA6MvAQJJzfPAedYPHoE3uOllaL6v
         9iJ16hwV2vbvtyVRjES5rZUi7rMheKTKckzfCKbs=
Date:   Thu, 24 Feb 2022 12:31:14 +0100
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
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
Message-ID: <YhdsgokMMSEQ0Yc8@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
> Hi there,
> 
> This series introduces support of eBPF for HID devices.
> 
> I have several use cases where eBPF could be interesting for those
> input devices:
> 
> - simple fixup of report descriptor:
> 
> In the HID tree, we have half of the drivers that are "simple" and
> that just fix one key or one byte in the report descriptor.
> Currently, for users of such devices, the process of fixing them
> is long and painful.
> With eBPF, we could externalize those fixups in one external repo,
> ship various CoRe bpf programs and have those programs loaded at boot
> time without having to install a new kernel (and wait 6 months for the
> fix to land in the distro kernel)

Why would a distro update such an external repo faster than they update
the kernel?  Many sane distros update their kernel faster than other
packages already, how about fixing your distro?  :)

I'm all for the idea of using ebpf for HID devices, but now we have to
keep track of multiple packages to be in sync here.  Is this making
things harder overall?

> - Universal Stylus Interface (or any other new fancy feature that
>   requires a new kernel API)
> 
> See [0].
> Basically, USI pens are requiring a new kernel API because there are
> some channels of communication our HID and input stack are not capable
> of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
> on eBPF to have the kernel API controlled by the consumer and to not
> impact the performances by waking up userspace every time there is an
> event.

How is userspace supposed to interact with these devices in a unified
way then?  This would allow random new interfaces to be created, one
each for each device, and again, be a pain to track for a distro to keep
in sync.  And how are you going to keep the ebpf interface these
provides in sync with the userspace program?

> - Surface Dial
> 
> This device is a "puck" from Microsoft, basically a rotary dial with a
> push button. The kernel already exports it as such but doesn't handle
> the haptic feedback we can get out of it.
> Furthermore, that device is not recognized by userspace and so it's a
> nice paperwight in the end.
> 
> With eBPF, we can morph that device into a mouse, and convert the dial
> events into wheel events.

Why can't we do this in the kernel today?

> Also, we can set/unset the haptic feedback
> from userspace. The convenient part of BPF makes it that the kernel
> doesn't make any choice that would need to be reverted because that
> specific userspace doesn't handle it properly or because that other
> one expects it to be different.

Again, what would the new api for the haptic device be?  Who is going to
mantain that on the userspace side?  What library is going to use this?
Is libinput going to now be responsible for interacting this way with
the kernel?

> - firewall
> 
> What if we want to prevent other users to access a specific feature of a
> device? (think a possibly bonker firmware update entry popint)
> With eBPF, we can intercept any HID command emitted to the device and
> validate it or not.

This I like.

> This also allows to sync the state between the userspace and the
> kernel/bpf program because we can intercept any incoming command.
> 
> - tracing
> 
> The last usage I have in mind is tracing events and all the fun we can
> do we BPF to summarize and analyze events.
> Right now, tracing relies on hidraw. It works well except for a couple
> of issues:
>  1. if the driver doesn't export a hidraw node, we can't trace anything
>     (eBPF will be a "god-mode" there, so it might raise some eyebrows)
>  2. hidraw doesn't catch the other process requests to the device, which
>     means that we have cases where we need to add printks to the kernel
>     to understand what is happening.

Tracing is also nice, I like this too.

Anyway, I like the idea, I'm just worried we are pushing complexity out
into userspace which would make it "someone else's problem."  The job of
a kernel is to provide a way to abstract devices in a standard way.  To
force userspace to write a "new program per input device" would be a
total mess and a step backwards.

thanks,

greg k-h
