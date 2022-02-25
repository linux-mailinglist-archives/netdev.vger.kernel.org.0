Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E124C4A8E
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242931AbiBYQWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239145AbiBYQWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:22:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7C3186442;
        Fri, 25 Feb 2022 08:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9D60B83281;
        Fri, 25 Feb 2022 16:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74395C340E7;
        Fri, 25 Feb 2022 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645806108;
        bh=5qCpPhBzCG6EzwR24kqTZdJuF47gyfzZc+1BXmKEf6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pwM1Xt6gJz0gy6cniVfgiIJmJRbym2PDFc7fvMhX7O78a9KimPFkL1OlSiMRznl2v
         43t+J1tF1dp6drJ9uHzOSFsQwjcLNrvxCTTpAp3RdEkoCeRZAG09vk+ilKDGahSdav
         1dR6n4cxuaKBLu+rDv0brby5moN8WaD1cLgadAZw=
Date:   Fri, 25 Feb 2022 17:19:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
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
Message-ID: <YhkBqTWts97lS3jW@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <YhdsgokMMSEQ0Yc8@kroah.com>
 <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com>
 <ed97e5e8-f2b8-569f-5319-36cd3d2b79b3@fb.com>
 <CAO-hwJ+CJkPqdOE+OpZHOscMk3HHZb4qVtXjF-bkOweU0QjppA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO-hwJ+CJkPqdOE+OpZHOscMk3HHZb4qVtXjF-bkOweU0QjppA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 05:06:32PM +0100, Benjamin Tissoires wrote:
> On Thu, Feb 24, 2022 at 6:21 PM Yonghong Song <yhs@fb.com> wrote:
> >
> >
> >
> > On 2/24/22 5:49 AM, Benjamin Tissoires wrote:
> > > Hi Greg,
> > >
> > > Thanks for the quick answer :)
> > >
> > > On Thu, Feb 24, 2022 at 12:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >>
> > >> On Thu, Feb 24, 2022 at 12:08:22PM +0100, Benjamin Tissoires wrote:
> > >>> Hi there,
> > >>>
> > >>> This series introduces support of eBPF for HID devices.
> > >>>
> > >>> I have several use cases where eBPF could be interesting for those
> > >>> input devices:
> > >>>
> > >>> - simple fixup of report descriptor:
> > >>>
> > >>> In the HID tree, we have half of the drivers that are "simple" and
> > >>> that just fix one key or one byte in the report descriptor.
> > >>> Currently, for users of such devices, the process of fixing them
> > >>> is long and painful.
> > >>> With eBPF, we could externalize those fixups in one external repo,
> > >>> ship various CoRe bpf programs and have those programs loaded at boot
> > >>> time without having to install a new kernel (and wait 6 months for the
> > >>> fix to land in the distro kernel)
> > >>
> > >> Why would a distro update such an external repo faster than they update
> > >> the kernel?  Many sane distros update their kernel faster than other
> > >> packages already, how about fixing your distro?  :)
> > >
> > > Heh, I'm going to try to dodge the incoming rhel bullet :)
> > >
> > > It's true that thanks to the work of the stable folks we don't have to
> > > wait 6 months for a fix to come in. However, I think having a single
> > > file to drop in a directory would be easier for development/testing
> > > (and distribution of that file between developers/testers) than
> > > requiring people to recompile their kernel.
> > >
> > > Brain fart: is there any chance we could keep the validated bpf
> > > programs in the kernel tree?
> >
> > Yes, see kernel/bpf/preload/iterators/iterators.bpf.c.
> 
> Thanks. This is indeed interesting.
> I am not sure the exact usage of it though :)
> 
> One thing I wonder too while we are on this topic, is it possible to
> load a bpf program from the kernel directly, in the same way we can
> request firmwares?

We used to be able to do that, putting bpf programs inside a module.
But that might have gotten removed because no one actually used it.  I
thought it was a nice idea.

> Because if we can do that, in my HID use case we could replace simple
> drivers with bpf programs entirely and reduce the development cycle to
> a bare minimum.

How would the development cycle change?  You could get rid of many
in-kernel hid drivers and replace them with bpf code perhaps?  Maybe
that's a good use case :)

thanks,

greg k-h
