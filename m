Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD264C4A99
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242933AbiBYQXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242930AbiBYQXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F78B3E41;
        Fri, 25 Feb 2022 08:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DCF6B8326B;
        Fri, 25 Feb 2022 16:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF6AC340E7;
        Fri, 25 Feb 2022 16:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645806193;
        bh=rkLjTIjcRR32zyhieMNFJ8Z8g6Br2JWE90YX1D0HpYQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PqQA6k5avulgzjLrXS55FBGglRzClfgITBEPzW/sIi1vhdrBB7DzHVsiiDyDC7tIS
         pSJyavVbhEMdNfhtl/uhpJdcezZIRqUmOeqYedIhPPgDgQddEFuAVas3F4AFMbNZfZ
         8MFDo8iejA7WO8GBInhG+K1elmW1Phxw0sSI3vRM=
Date:   Fri, 25 Feb 2022 17:23:11 +0100
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
Message-ID: <YhkCbws+csQyIDKQ@kroah.com>
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

HID selftests question for now:

On Fri, Feb 25, 2022 at 05:00:53PM +0100, Benjamin Tissoires wrote:
> > > I am not entirely clear on which plan I want to have for userspace.
> > > I'd like to have libinput on board, but right now, Peter's stance is
> > > "not in my garden" (and he has good reasons for it).
> > > So my initial plan is to cook and hold the bpf programs in hid-tools,
> > > which is the repo I am using for the regression tests on HID.
> >
> > Why isn't the hid regression tests in the kernel tree also?  That would
> > allow all of the testers out there to test things much easier than
> > having to suck down another test repo (like Linaro and 0-day and
> > kernelci would be forced to do).
> 
> 2 years ago I would have argued that the ease of development of
> gitlab.fd.o was more suited to a fast moving project.
> 
> Now... The changes in the core part of the code don't change much so
> yes, merging it in the kernel might have a lot of benefits outside of
> what you said. The most immediate one is that I could require fixes to
> be provided with a test, and merge them together, without having to
> hold them until Linus releases a new version.

Yes, having a test be required for a fix is a great idea.  Many
subsystems do this already and it helps a lot.

> If nobody complains of having the regression tests in python with
> pytest and some Python 3.6+ features, that is definitely something I
> should look for.

Look at the tools/testing/selftests/ directory today.  We already have
python3 tests in there, and as long as you follow the proper TAP output
format, all should be fine.  The tc-testing python code in the kernel
trees seems to do that and no one has complained yet :)

thanks,

greg k-h
