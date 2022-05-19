Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3452CE35
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 10:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbiESIVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 04:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiESIVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 04:21:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94242AE264;
        Thu, 19 May 2022 01:20:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DD68B8237F;
        Thu, 19 May 2022 08:20:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A14C385AA;
        Thu, 19 May 2022 08:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652948438;
        bh=p5BYeBj/v9QmnZ2DUiNgA11xOl2jDT6ZwzbYzb4aCWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0+7Lt7r1FFykWgBMkBazf6jcV7p6/lzvHzsZkHW+Faj7/4TgqaB8QYE9MEpuicdj
         t/LiVq6QeT7xbfSIeC7Gb0hbjYq1DP9ZBGhXIdVCDfhQgjMp+3qGqCBZI7jTopZ3hI
         xYrlrHCAGRwQqvezCqnnJHEKR9eqQ+KTc/uvozJc=
Date:   Thu, 19 May 2022 10:20:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@infradead.org>
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
Message-ID: <YoX904CAFOAfWeJN@kroah.com>
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
 <YoX7iHddAd4FkQRQ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoX7iHddAd4FkQRQ@infradead.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 01:10:48AM -0700, Christoph Hellwig wrote:
> > The logic is the following (see also the last patch for some more
> > documentation):
> > - hid-bpf first preloads a BPF program in the kernel that does a few
> >   things:
> >    * find out which attach_btf_id are associated with our trace points
> >    * adds a bpf_tail_call() BPF program that I can use to "call" any
> >      other BPF program stored into a jump table
> >    * monitors the releases of struct bpf_prog, and when there are no
> >      other users than us, detach the bpf progs from the HID devices
> > - users then declare their tracepoints and then call
> >   hid_bpf_attach_prog() in a SEC("syscall") program
> > - hid-bpf then calls multiple time the bpf_tail_call() program with a
> >   different index in the jump table whenever there is an event coming
> >   from a matching HID device
> 
> So driver abstractions like UDI are now perfectly fine as long as they
> are written using a hip new VM?

Ugh, don't mention UDI, that's a bad flashback...

> This whole idea seems like a bad idea, against the Linux spirit and
> now actually useful - it is totally trivial to write a new HID
> driver alreay, and if it isn't in some cases we need to fix that.
> 
> So a big fat NAK to the idea of using eBPF for actual driver logic.

I thought the goal here was to move a lot of the quirk handling and
"fixup the broken HID decriptors in this device" out of kernel .c code
and into BPF code instead, which this patchset would allow.

So that would just be exception handling.  I don't think you can write a
real HID driver here at all, but I could be wrong as I have not read the
new patchset (older versions of this series could not do that.)

thanks,

greg k-h
