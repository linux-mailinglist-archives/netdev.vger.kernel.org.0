Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C92271185
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 02:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgITAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 20:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgITAO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 20:14:56 -0400
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C971E2311D
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600560896;
        bh=hFlNFuPTeOm0L/kdCL4zZ1r5D8O6dPLmjujTGrKOlYM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JdpTFUSGe1SVP3GYoHMA/1+WAOgDwyAZh592KmHbxVYan4JptN2Ey4qtv/JhhMmdD
         4/+2hOJn0bB2vl1+CA1vsA98Zss+NNVMyBMeVtqPcslQ6drhtIH53blqmBsy4rTawx
         5AYjLp/I2l7q6tcX617SK/tanVf0CoYUpDb3JlE0=
Received: by mail-lf1-f48.google.com with SMTP id d15so10123721lfq.11
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 17:14:55 -0700 (PDT)
X-Gm-Message-State: AOAM532MGJ7bl27ZFILWCBdQYL0D/qq41P3Vcv9tyD6vuepUIzxC7wRq
        TswHeKE6O3+Ht2qaPrOs2ENpMduc/rsHNhqroV1HTQ==
X-Google-Smtp-Source: ABdhPJwNa+g9tI1uon0gRHcB2mOJvq7bEiosz+i+17dS26MXBg9h+I1xFom2CJCFuIf/wJaqwzsOPjK0guk9bG2/Zms=
X-Received: by 2002:adf:a3c3:: with SMTP id m3mr251480wrb.70.1600560893353;
 Sat, 19 Sep 2020 17:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200919224122.GJ3421308@ZenIV.linux.org.uk> <36CF3DE7-7B4B-41FD-9818-FDF8A5B440FB@amacapital.net>
 <20200919232411.GK3421308@ZenIV.linux.org.uk>
In-Reply-To: <20200919232411.GK3421308@ZenIV.linux.org.uk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 19 Sep 2020 17:14:41 -0700
X-Gmail-Original-Message-ID: <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
Message-ID: <CALCETrViwOdFia_aX4p4riE8aqop1zoOqVfiQtSAZEzheC+Ozg@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:24 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sat, Sep 19, 2020 at 03:53:40PM -0700, Andy Lutomirski wrote:
>
> > > It would not be a win - most of the syscalls don't give a damn
> > > about 32bit vs. 64bit...
> >
> > Any reasonable implementation would optimize it out for syscalls that d=
on=E2=80=99t care.  Or it could be explicit:
> >
> > DEFINE_MULTIARCH_SYSCALL(...)
>
> 1) what would that look like?

In effect, it would work like this:

/* Arch-specific, but there's a generic case for sane architectures. */
enum syscall_arch {
  SYSCALL_NATIVE,
  SYSCALL_COMPAT,
  SYSCALL_X32,
};

DEFINE_MULTIARCH_SYSCALLn(args, arch)
{
  args are the args here, and arch is the arch.
}

> 2) have you counted the syscalls that do and do not need that?

No.

> 3) how many of those realistically *can* be unified with their
> compat counterparts?  [hint: ioctl(2) cannot]

There would be no requirement to unify anything.  The idea is that
we'd get rid of all the global state flags.

For ioctl, we'd have a new file_operation:

long ioctl(struct file *, unsigned int, unsigned long, enum syscall_arch);

I'm not saying this is easy, but I think it's possible and the result
would be more obviously correct than what we have now.
