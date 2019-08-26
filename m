Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E448C9D432
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbfHZQka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:40:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40730 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732900AbfHZQk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:40:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id c5so148375wmb.5;
        Mon, 26 Aug 2019 09:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjxgBXa3y+uuhZsdeO1qBTZUTIy7XmFfl96V9DIMo6Q=;
        b=fP2Xk61Pf9uROtag057QqLPki/+ga9LNABXUsoDIZwVgKzbaYY+Yv54/cDTBAKId+L
         Gsa9FVVOLgcFlieoK30m+kYMru8msmE8LoggM8vJq/vdFO5xSMSr2LvZhqfkrFHXjhov
         6rD3Xh8wbBkjlyhtb6/yu5I7HY09bDnj1SpktDTI8oAOdA7J0NOLAlDbY2lLOwpdhVKk
         cgebex/jZ8OF4iLFyBI5qhK43EJK74aDyp2TI03EElLOgyt3ObsAka0s9GSEMRH+4nIE
         wzpWbuPNjYFtI1GG4jgryZIAosVXa3K6wI33LepQmdDRTSqGL6fvoKnf8pvI24SlblRD
         GsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjxgBXa3y+uuhZsdeO1qBTZUTIy7XmFfl96V9DIMo6Q=;
        b=M4eda8zIN+kaCcU6edWUZUSvD/2VlMTwfa/3KWOYvsE7JeBzkfWRIVrIf5xs1DI7Kh
         ZN/MS6cyQ2zG7yAeHrnTwnMrmdWp15fwi0+lAe1ZxTguasGUrsQqNTXCiQZPi1GCcla4
         Up84J1/a10cMc1Ovq9a81ZV7rGyfmiE7hnQmZpQPa1Wr7eCsJu4TV7NTmLvSRDP2gJ88
         HtLGRgYkAcjmi+YE524EEndPfekydRFodFxiAnwMQYSv4SGFUPc9D2Vk5RSnLC0jKpqI
         3exkyUXeISXDkTnWrJJUPO7WhgkeB3/JE2k8tA7qFrf5CM3aMRZU6Sl4LqmfwE0GVAdW
         8pzQ==
X-Gm-Message-State: APjAAAXbzUr5fNMpQFiWbxyN7IAkWna+JJDhKYPu2qMNYHs6F2vouGcU
        7T0ZrG0dkho/SvLvaYbWaelFfs5WSMT3YR0F0Cw=
X-Google-Smtp-Source: APXvYqyR0ybZtJiikv+kwAVgdY7AWb/vcdMGH7sI0c/nWNAyYF6Ch2IHDX6ee2DH+0Mm7f0lXuO3Rk/bCGgW2RweGT4=
X-Received: by 2002:a1c:e487:: with SMTP id b129mr23317012wmh.93.1566837626850;
 Mon, 26 Aug 2019 09:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
 <alpine.DEB.2.21.9999.1908231717550.25649@viisi.sifive.com> <20190826145756.GB4664@cisco>
In-Reply-To: <20190826145756.GB4664@cisco>
From:   David Abdurachmanov <david.abdurachmanov@gmail.com>
Date:   Mon, 26 Aug 2019 09:39:50 -0700
Message-ID: <CAEn-LTrtn01=fp6taBBG_QkfBtgiJyt6oUjZJOi6VN8OeXp6=g@mail.gmail.com>
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
To:     Tycho Andersen <tycho@tycho.ws>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 7:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> Hi,
>
> On Fri, Aug 23, 2019 at 05:30:53PM -0700, Paul Walmsley wrote:
> > On Thu, 22 Aug 2019, David Abdurachmanov wrote:
> >
> > > There is one failing kernel selftest: global.user_notification_signal
> >
> > Also - could you follow up with the author of this failing test to see if
> > we can get some more clarity about what might be going wrong here?  It
> > appears that the failing test was added in commit 6a21cc50f0c7f ("seccomp:
> > add a return code to trap to userspace") by Tycho Andersen
> > <tycho@tycho.ws>.
>
> Can you post an strace and a cat of /proc/$pid/stack for both tasks
> where it gets stuck? I don't have any riscv hardware, and it "works
> for me" on x86 and arm64 with 100 tries.

I don't have the a build with SECCOMP for the board right now, so it
will have to wait. I just finished a new kernel (almost rc6) for Fedora,
but it will take time to assemble new repositories and a disk image.

There is older disk image available (5.2.0-rc7 kernel with v2 SECCOMP)
for QEMU or libvirt/QEMU:

https://dl.fedoraproject.org/pub/alt/risc-v/disk-images/fedora/rawhide/20190703.n.0/Developer/
https://fedoraproject.org/wiki/Architectures/RISC-V/Installing#Boot_with_libvirt

(If you are interesting trying it locally.)

IIRC I attempted to connected with strace, but it quickly returns and fails
properly. Simply put strace unblocks whatever is stuck.

david
