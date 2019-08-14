Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904098DC57
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbfHNRvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbfHNRvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 13:51:38 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52DB92173B
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565805096;
        bh=XeMnKuoQGUDkp7xm8S6UJpJjinby4CZDL2Le2Uei9CE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WiYRi47Tr2Fqlupks4B9cf+lvLB1kacoJ0Q04JCq9YaCv9hqgyNuHviPLlddlKKFU
         f2KkNF5PC/WemKlhMmwI1YaylHBLU+7Vk1tATNiaPGejyFkUlvLAkjAZmYvaSZzylD
         DuXSMoE9xkRnrxnkdlYeT8tLgOHI+Z4qXNwCdA+M=
Received: by mail-wr1-f47.google.com with SMTP id j16so9657939wrr.8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 10:51:36 -0700 (PDT)
X-Gm-Message-State: APjAAAVqKscTqBUqsHg09808/7WmEKbuNYSDnXSzzrUe9NC2CPX/G1d9
        G13r3ZZHzVh5VXQ9X93d1SEiJ9tTlqDNmZq4HsGL5Q==
X-Google-Smtp-Source: APXvYqwH5OnheHfRnPyM5sjwO/MKMub0DHKkYqC70Uco7FQaSpqnuzFvrFWzsCSoWfUt3UX22oE8QlhZVLqztu9XJxM=
X-Received: by 2002:adf:f18c:: with SMTP id h12mr952190wro.47.1565805094766;
 Wed, 14 Aug 2019 10:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com> <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp> <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp> <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
In-Reply-To: <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 14 Aug 2019 10:51:23 -0700
X-Gmail-Original-Message-ID: <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
Message-ID: <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Colascione <dancol@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:57 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:

> hmm. No. Kernel developers should not make any assumptions.
> They should guide their design by real use cases instead. That includes studing
> what people do now and hacks they use to workaround lack of interfaces.
> Effecitvely bpf is root only. There are no unpriv users.
> This root applications go out of their way to reduce privileges
> while they still want to use bpf. That is the need that /dev/bpf is solving.
>
> >
> > > Containers are not providing the level of security that is enough
> > > to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
> > > Containers are used to make production systems safer.
> > > Some people call it more 'secure', but it's clearly not secure for
> > > arbitrary code and that is what kernel.unprivileged_bpf_disabled allows.
> > > When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> > > It's been a constant source of pain. The constant blinding, randomization,
> > > verifier speculative analysis, all spectre v1, v2, v4 mitigations
> > > are simply not worth it. It's a lot of complex kernel code without users.
> >
> > Seccomp really will want eBPF some day, and it should work without
> > privilege.  Maybe it should be a restricted subset of eBPF, and
> > Spectre will always be an issue until dramatically better hardware
> > shows up, but I think people will want the ability for regular
> > programs to load eBPF seccomp programs.
>
> I'm absolutely against using eBPF in seccomp.
> Precisely due to discussions like the current one.

I still think I don't really agree with your overall premise.

If eBPF is genuinely not usable by programs that are not fully trusted
by the admin, then no kernel changes at all are needed.  Programs that
want to reduce their own privileges can easily fork() a privileged
subprocess or run a little helper to which they delegate BPF
operations.  This is far more flexible than anything that will ever be
in the kernel because it allows the helper to verify that the rest of
the program is doing exactly what it's supposed to and restrict eBPF
operations to exactly the subset that is needed.  So a container
manager or network manager that drops some provilege could have a
little bpf-helper that manages its BPF XDP, firewalling, etc
configuration.  The two processes would talk over a socketpair.

The interesting cases you're talking about really *do* involved
unprivileged or less privileged eBPF, though.  Let's see:

systemd --user: systemd --user *is not privileged at all*.  There's no
issue of reducing privilege, since systemd --user doesn't have any
privilege to begin with.  But systemd supports some eBPF features, and
presumably it would like to support them in the systemd --user case.
This is unprivileged eBPF.

Seccomp.  Seccomp already uses cBPF, which is a form of BPF although
it doesn't involve the bpf() syscall.  There are some seccomp
proposals in the works that will want some stuff from eBPF.  In
particular, the ability to call seccomp-specific bpf functions from a
seccomp program could be very nice. Similarly, the ability to use the
enhanced instruction set and maybe even *read* maps would be nice.  I
do think that seccomp will continue to want its programs to be
stateless.

So it's a bit of a chicken-and-egg situation.  There aren't major
unprivileged eBPF users because the kernel support isn't there.

>
> >
> > > Hence I prefer this /dev/bpf mechanism to be as simple a possible.
> > > The applications that will use it are going to be just as trusted as systemd.
> >
> > I still don't understand your systemd example.  systemd --users is not
> > trusted systemwide in any respect.  The main PID 1 systemd is root.
> > No matter how you dice it, granting a user systemd instance extra bpf
> > access is tantamount to granting the user extra bpf access in general.
>
> People use systemd --user while their kernel have 'undef CONFIG_USER_NS'.

I don't know what you're getting at.  I'm typing this email in a
browser running under a systemd --user instance, and there are no user
namespaces involved.

$ ps -u luto |grep systemd
 1944 ?        00:00:02 systemd
$ stat /proc/1944
...
Access: (0555/dr-xr-xr-x)  Uid: ( 1000/    luto)   Gid: ( 1000/    luto)
Context: unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
$ gdb -p 1944
[snipped tons of output, but gdb works fine like this]

systemd --user is not privileged.  Giving it /dev/bpf as imagined by
the current set of patches would be a gaping security hole.

>
> I think there should be no unprivileged bpf at all,
> because over all these years we've seen zero use cases.
> Hence all new features are root only.

You're the maintainer.  If you feel this way, then I think you should
just drop the /dev/bpf idea entirely and have userspace manage all of
this by itself.  It will remain extremely awkward for containers and
especially nested containers to use eBPF.

--Andy
