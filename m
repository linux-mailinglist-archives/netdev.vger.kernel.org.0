Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA9E270F73
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 18:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgISQWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 12:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgISQV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 12:21:58 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97DB623719
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600532517;
        bh=tnnKVle7uGlb4ye6ETfPhESD0icbWeK+NnxFIW79sro=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QrIUAAqT1dp8+jrXrF0kfdV5PIOJITY8xSkYh8pnrNFPmM98EPjnnqgiUheWM3Zz4
         0qTg36uFIa2gFwlgsZXnXxJdaWIK0Dls7hdq0zd60qlpvRgxcHCvRNqCi9kc1myB6l
         slKQU2ILvCXePIOP8ZGSdUV9ciTDnkbyjJ8h5bj0=
Received: by mail-ed1-f49.google.com with SMTP id l17so8855786edq.12
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 09:21:57 -0700 (PDT)
X-Gm-Message-State: AOAM533XgJbH8B0Be+7VFHZiU1mF04wnIOfdCV3p0dgNwiN3kr6EIun3
        ywWxJ6qutFoIqPhaDcfMB7EGbPObSCpPL8eMWGTu8g==
X-Google-Smtp-Source: ABdhPJwBFQKjUG5Ajrf8DpZFR91CZN4BHC9/gKbhMJfUTwAnV0GCUbZx28T5SkvcVSnD9FMlBdmx1p4waD7HgdNSIPM=
X-Received: by 2002:a5d:5281:: with SMTP id c1mr43283094wrv.184.1600532515963;
 Sat, 19 Sep 2020 09:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200918134012.GY3421308@ZenIV.linux.org.uk> <20200918134406.GA17064@lst.de>
 <20200918135822.GZ3421308@ZenIV.linux.org.uk> <20200918151615.GA23432@lst.de>
In-Reply-To: <20200918151615.GA23432@lst.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 19 Sep 2020 09:21:44 -0700
X-Gmail-Original-Message-ID: <CALCETrW=BzodXeTAjSvpCoUQoL+MKaKPEeSTRWnB=-C9jMotbQ@mail.gmail.com>
Message-ID: <CALCETrW=BzodXeTAjSvpCoUQoL+MKaKPEeSTRWnB=-C9jMotbQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 8:16 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> > Said that, why not provide a variant that would take an explicit
> > "is it compat" argument and use it there?  And have the normal
> > one pass in_compat_syscall() to that...
>
> That would help to not introduce a regression with this series yes.
> But it wouldn't fix existing bugs when io_uring is used to access
> read or write methods that use in_compat_syscall().  One example that
> I recently ran into is drivers/scsi/sg.c.

Aside from the potentially nasty use of per-task variables, one thing
I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're
going to have a generic mechanism for this, shouldn't we allow a full
override of the syscall arch instead of just allowing forcing compat
so that a compat syscall can do a non-compat operation?
