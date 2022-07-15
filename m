Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26089575EE1
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiGOJ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 05:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiGOJ5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 05:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92DE67B37E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657879022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8Hrnh4xSI/kevtIOtrai4yHB4Q/NHMbskcGk41P5Ttk=;
        b=Rn7fzpngq6bD7XgSZDSOvJqjFABmCn92kAMa2kfPWZ6Q7ydKqHZKYYMLL5+TqKrNKZ3Jhg
        VEUL0QVIsvnkSghjISNyPqagy0UwecfFvQCynGRmhfRl7dgAHuZ7LSNIRdUblfT7g1VucE
        WSIiaDXuk8jTtt8ITmI3W/GcW/nCx1c=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-z9exsyjUMfm6Ih-rRAEfGg-1; Fri, 15 Jul 2022 05:56:59 -0400
X-MC-Unique: z9exsyjUMfm6Ih-rRAEfGg-1
Received: by mail-pf1-f198.google.com with SMTP id u14-20020a056a00098e00b0052b433b04d6so214048pfg.12
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 02:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Hrnh4xSI/kevtIOtrai4yHB4Q/NHMbskcGk41P5Ttk=;
        b=3xc83zOFyQ4eMQPPAWJACPZUOtwIwe8gjjAZ/KLTIdp8g9GD4oYEqx6dkZGIRtFNxU
         0oHTFyIdMg7jDrbzIOJwAu4EX0RPtODFLjbDZsPQGnZHTNeRPeytZzHBpGl594ycDKpW
         +u92XMOtyrk0oZ/7F8De9eJJqJP3eGigVTzsefWqaKbR7fiP8/JChqeMMJifVZVvZoZZ
         HWz6meU4hG3rCPuDcnTFz/O1Pux8J5zCGADWGOlwfq8DylIcF2wf0wUFiT+/VDvlKKR1
         F6Tn1bNuV0RTwgSGTX5jOuBb3aPqZ+MD0OO7LO/nPQxsRDMYeFCzIaPZw/5KMUvlcoBg
         2+qA==
X-Gm-Message-State: AJIora/Aup/mVGCH8piZFsZdFctuWhWjL3St7ab3FiZpyQqGOiOnEeXB
        ZzBAmiEpHcYMoLaAHnetOA/c/i1r4lGxBUerWbveywiJD7P7pXj2AKEBVW2rXYvC5wgIMTJIqTl
        q+UA0QfpCscYBw+UK2x0pLqR+xQYcUIIb
X-Received: by 2002:a17:90a:be0c:b0:1ef:accb:23a5 with SMTP id a12-20020a17090abe0c00b001efaccb23a5mr14728440pjs.113.1657879018489;
        Fri, 15 Jul 2022 02:56:58 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vH3VKnUSifYcKOV2DL1yCJLfK4VppjP4mBn1OJIP42LQAI4oYiGA7TAcUy7OJJe7owCfc/M0euZYcsf4hCj2s=
X-Received: by 2002:a17:90a:be0c:b0:1ef:accb:23a5 with SMTP id
 a12-20020a17090abe0c00b001efaccb23a5mr14728406pjs.113.1657879018230; Fri, 15
 Jul 2022 02:56:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-13-benjamin.tissoires@redhat.com> <YtD09KwkxvJAbgCy@kroah.com>
In-Reply-To: <YtD09KwkxvJAbgCy@kroah.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 15 Jul 2022 11:56:46 +0200
Message-ID: <CAO-hwJ+d6mNO2L5kZtOC6QVrDy+LZ6ECoY2f83C93GFPKbSx7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 12/23] HID: initial BPF implementation
To:     Greg KH <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 7:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jul 12, 2022 at 04:58:39PM +0200, Benjamin Tissoires wrote:
> > --- /dev/null
> > +++ b/drivers/hid/bpf/Kconfig
> > @@ -0,0 +1,19 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +menu "HID-BPF support"
> > +     #depends on x86_64
> > +
> > +config HID_BPF
> > +     bool "HID-BPF support"
> > +     default y
>
> Things are only default y if you can't boot your machine without it.
> Perhaps just mirror what HID is to start with and do not select HID?
>
> > +     depends on BPF && BPF_SYSCALL
> > +     select HID
>
> select is rough, why not depend?

Let me try to explain this mess, maybe you can give me the piece that
I am missing:

The requirements I have (or want) are:
- HID-BPF should be "part" of HID-core (or something similar of "part"):
  I intend to have device fixes as part of the regular HID flow, so
allowing distros to opt out seems a little bit dangerous
- the HID tree is not as clean as some other trees:
  drivers/hid/ sees both core elements and leaf drivers
  transport layers are slightly better, they are in their own
subdirectories, but some transport layers are everywhere in the kernel
code or directly in drivers/hid (uhid and hid-logitech-dj for
instance)
- HID can be loaded as a module (only ubuntu is using that), and this
is less and less relevant because of all of the various transport
layers we have basically prevent a clean unloading of the module

These made me think that I should have a separate bpf subdir for
HID-BPF, to keep things separated, which means I can not include
HID-BPF in hid.ko directly, it goes into a separate driver. And then I
have a chicken and egg problem:
- HID-core needs to call functions from HID-BPF (to hook into it)
- but HID-BPF needs to also call functions from HID-core (for
accessing HID internals)

I have solved that situation with struct hid_bpf_ops but it is not the
cleanest possible way.

And that's also why I did "select HID", because HID-BPF without HID is
pointless.

One last bit I should add. hid-bpf.ko should be allowed to be compiled
in as a module, but I had issues at boot because kfuncs were not
getting registered properly (though it works for the net test driver).
So I decided to make hid-bpf a boolean instead of a tristate.

As I type all of this, I am starting to wonder if I should not tackle
the very first point and separate hid-core in its own subdir. This way
I can have a directory with only the core part, and having hid-bpf in
here wouldn't be too much of an issue.

Thoughts?

Cheers,
Benjamin

