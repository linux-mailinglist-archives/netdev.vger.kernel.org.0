Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A55F5DA51
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbfGCBIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfGCBIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 21:08:05 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31E56218D3
        for <netdev@vger.kernel.org>; Tue,  2 Jul 2019 21:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562103141;
        bh=oo48P7da1GzWeluudUYctbEpvdM/m1EpFSK8+9E2e2E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dHnq5JcwBwPzy+t1r9zUImCrtgzYH0YcYBctxd3dBGpNfM4KEyiIO86yL6PHkvKLX
         pUQ/hXlzOCTEXvzoVxMw7HXPCc88EoXafejfTaK1fE+i4se82IB35KgyATM/s8VIsI
         EvHefSsSjR0OEKsG86DrJrmyy9rsE21Oz+4VH3SE=
Received: by mail-wm1-f45.google.com with SMTP id 207so91059wma.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 14:32:21 -0700 (PDT)
X-Gm-Message-State: APjAAAUb/hom0L5kOvklQx4e0cNk01ddBC+BrDIupEcVEaZYkrl+S9Ca
        CsEoQXfpxa6LKpFFXBBfNVvrpS4gBD5AhcQ5vkSo7A==
X-Google-Smtp-Source: APXvYqwEYykzJyo2X3/CbH/kvAgSmUZebU6W1B7E+n5sQRNxQub2D4+Me5+8DrjgrkPBi0sxkT1a36it03xxJT340H8=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr4339807wme.173.1562103139731;
 Tue, 02 Jul 2019 14:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com> <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com> <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com> <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
In-Reply-To: <201907021115.DCD56BBABB@keescook>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 2 Jul 2019 14:32:08 -0700
X-Gmail-Original-Message-ID: <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
Message-ID: <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Kees Cook <keescook@chromium.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 2:04 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jul 01, 2019 at 06:59:13PM -0700, Andy Lutomirski wrote:
> > I think I'm understanding your motivation.  You're not trying to make
> > bpf() generically usable without privilege -- you're trying to create
> > a way to allow certain users to access dangerous bpf functionality
> > within some limits.
> >
> > That's a perfectly fine goal, but I think you're reinventing the
> > wheel, and the wheel you're reinventing is quite complicated and
> > already exists.  I think you should teach bpftool to be secure when
> > installed setuid root or with fscaps enabled and put your policy in
> > bpftool.  If you want to harden this a little bit, it would seem
> > entirely reasonable to add a new CAP_BPF_ADMIN and change some, but
> > not all, of the capable() checks to check CAP_BPF_ADMIN instead of the
> > capabilities that they currently check.
>
> If finer grained controls are wanted, it does seem like the /dev/bpf
> path makes the most sense. open, request abilities, use fd. The open can
> be mediated by DAC and LSM. The request can be mediated by LSM. This
> provides a way to add policy at the LSM level and at the tool level.
> (i.e. For tool-level controls: leave LSM wide open, make /dev/bpf owned
> by "bpfadmin" and bpftool becomes setuid "bpfadmin". For fine-grained
> controls, leave /dev/bpf wide open and add policy to SELinux, etc.)
>
> With only a new CAP, you don't get the fine-grained controls. (The
> "request abilities" part is the key there.)

Sure you do: the effective set.  It has somewhat bizarre defaults, but
I don't think that's a real problem.  Also, this wouldn't be like
CAP_DAC_READ_SEARCH -- you can't accidentally use your BPF caps.

I think that a /dev capability-like object isn't totally nuts, but I
think we should do it well, and this patch doesn't really achieve
that.  But I don't think bpf wants fine-grained controls like this at
all -- as I pointed upthread, a fine-grained solution really wants
different treatment for the different capable() checks, and a bunch of
them won't resemble capabilities or /dev/bpf at all.
