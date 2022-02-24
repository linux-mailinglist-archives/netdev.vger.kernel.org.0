Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC814C348F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiBXSVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiBXSVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:21:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECC52556E4;
        Thu, 24 Feb 2022 10:20:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A56D60B0E;
        Thu, 24 Feb 2022 18:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78637C340E9;
        Thu, 24 Feb 2022 18:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645726833;
        bh=cLEjIETcg/OJ3fT0H+e8jwtt0eqs6MXPvVtlC2jV8PQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nyqKUgzRU2t7o/ub+aIX9fXlhdK+rfzjWeg6vo2QTWXXEN1cewKOjPJRnXe/Nx2Ou
         loZukuiIEs4ALvJflu8IX4X2HXaPHATG5b/MavRxbxOwMZJ3wpgQEbE6nNuafSBC7u
         t9TOIji+xztIIxeN2btLZqJmJZ6ub920T/uymotM=
Date:   Thu, 24 Feb 2022 19:20:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bastien Nocera <hadess@hadess.net>
Cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
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
Message-ID: <YhfMaYsS3YI9T2nT@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <f965c04f34aabe93fe8ef91bb4d1ce4d24159173.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f965c04f34aabe93fe8ef91bb4d1ce4d24159173.camel@hadess.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 06:41:18PM +0100, Bastien Nocera wrote:
> On Thu, 2022-02-24 at 12:31 +0100, Greg KH wrote:
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
> > > ship various CoRe bpf programs and have those programs loaded at
> > > boot
> > > time without having to install a new kernel (and wait 6 months for
> > > the
> > > fix to land in the distro kernel)
> > 
> > Why would a distro update such an external repo faster than they
> > update
> > the kernel?  Many sane distros update their kernel faster than other
> > packages already, how about fixing your distro?  :)
> > 
> > I'm all for the idea of using ebpf for HID devices, but now we have
> > to
> > keep track of multiple packages to be in sync here.  Is this making
> > things harder overall?
> 
> I don't quite understand how taking eBPF quirks for HID devices out of
> the kernel tree is different from taking suspend quirks out of the
> kernel tree:
> https://www.spinics.net/lists/linux-usb/msg204506.html

A list of all devices possible, and the policy decisions to make on
those devices, belongs in userspace, not in the kernel.  That's what the
hwdb contains.

Quirks in order to get the device to work properly is not a policy
decision, they are needed to get the device to work.  If you wish to
suspend it or not based on the vendor/product id, in order to possibly
save some more battery life on some types of systems, is something that
belongs in userspace.

If you want to replace the existing HID quirk tables with an ebpf
program that ships with the kernel, wonderful, I have no objection to
that.  If a user is required to download the external quirk table just
to get their device to work with the kernel, that's probably something
you don't want to do.

thanks,

greg k-h
