Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1395760BE
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiGOLoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiGOLn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:43:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976F01A390;
        Fri, 15 Jul 2022 04:43:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05600B82BAD;
        Fri, 15 Jul 2022 11:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5981C3411E;
        Fri, 15 Jul 2022 11:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657885432;
        bh=hNuEABddL7x5vN/uTy0dXWm4VUZCQSWhovOb0u9EKmw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VppUYKXdj2C5bnDrc6tbxaHQwx/IVjiAatDyq+Y0Fj3y1NmpwajyHYRktIof1qZd6
         z8rnMS7Rl4tuvoSNHZRyaXyxmfFMqzClpdPyRjbzL6ThBs8MAXb8rQZcTshnrhl8G4
         ArOtP/n1bcLuIawHaomRrSL0rPKd/zOWo2VjD61Y=
Date:   Fri, 15 Jul 2022 13:43:49 +0200
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH bpf-next v6 12/23] HID: initial BPF implementation
Message-ID: <YtFS9UeLF8ZefT/F@kroah.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-13-benjamin.tissoires@redhat.com>
 <YtD09KwkxvJAbgCy@kroah.com>
 <CAO-hwJ+d6mNO2L5kZtOC6QVrDy+LZ6ECoY2f83C93GFPKbSx7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJ+d6mNO2L5kZtOC6QVrDy+LZ6ECoY2f83C93GFPKbSx7g@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 11:56:46AM +0200, Benjamin Tissoires wrote:
> On Fri, Jul 15, 2022 at 7:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jul 12, 2022 at 04:58:39PM +0200, Benjamin Tissoires wrote:
> > > --- /dev/null
> > > +++ b/drivers/hid/bpf/Kconfig
> > > @@ -0,0 +1,19 @@
> > > +# SPDX-License-Identifier: GPL-2.0-only
> > > +menu "HID-BPF support"
> > > +     #depends on x86_64
> > > +
> > > +config HID_BPF
> > > +     bool "HID-BPF support"
> > > +     default y
> >
> > Things are only default y if you can't boot your machine without it.
> > Perhaps just mirror what HID is to start with and do not select HID?
> >
> > > +     depends on BPF && BPF_SYSCALL
> > > +     select HID
> >
> > select is rough, why not depend?
> 
> Let me try to explain this mess, maybe you can give me the piece that
> I am missing:
> 
> The requirements I have (or want) are:
> - HID-BPF should be "part" of HID-core (or something similar of "part"):
>   I intend to have device fixes as part of the regular HID flow, so
> allowing distros to opt out seems a little bit dangerous
> - the HID tree is not as clean as some other trees:
>   drivers/hid/ sees both core elements and leaf drivers
>   transport layers are slightly better, they are in their own
> subdirectories, but some transport layers are everywhere in the kernel
> code or directly in drivers/hid (uhid and hid-logitech-dj for
> instance)
> - HID can be loaded as a module (only ubuntu is using that), and this
> is less and less relevant because of all of the various transport
> layers we have basically prevent a clean unloading of the module
> 
> These made me think that I should have a separate bpf subdir for
> HID-BPF, to keep things separated, which means I can not include
> HID-BPF in hid.ko directly, it goes into a separate driver. And then I
> have a chicken and egg problem:
> - HID-core needs to call functions from HID-BPF (to hook into it)
> - but HID-BPF needs to also call functions from HID-core (for
> accessing HID internals)
> 
> I have solved that situation with struct hid_bpf_ops but it is not the
> cleanest possible way.
> 
> And that's also why I did "select HID", because HID-BPF without HID is
> pointless.
> 
> One last bit I should add. hid-bpf.ko should be allowed to be compiled
> in as a module, but I had issues at boot because kfuncs were not
> getting registered properly (though it works for the net test driver).
> So I decided to make hid-bpf a boolean instead of a tristate.
> 
> As I type all of this, I am starting to wonder if I should not tackle
> the very first point and separate hid-core in its own subdir. This way
> I can have a directory with only the core part, and having hid-bpf in
> here wouldn't be too much of an issue.

We've had this problem with the USB core in the past, and yes, that was
the simplest solution (see drivers/usb/core/)

Otherwise you could do:
	default HID
as the dependancy here, but that might get messy if hid can be a module.

Try splitting the hid core out first, you want to do that anyway and
that should make this simpler as you found out :)

thanks,

greg k-h
