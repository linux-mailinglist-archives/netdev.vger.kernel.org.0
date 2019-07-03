Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745415DEE4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGCH2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCH2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4FCE21881;
        Wed,  3 Jul 2019 07:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562138913;
        bh=OeqvpDr6SqDF9S5PemchZSyKCt59rWmCuSrPnN5bq5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=buCeIWtlR3ZCycmtXG5RC0tHta8wJWRBa53zuXOINBX15AOSGtC6BfAhIwC7v1CY/
         dopDx4nq1Y8bB7kzSITWuTWUy0Hq/ZBDRfSZUgqfylkIpwJ2ZSKAGqEzdxSwMgpIim
         gYmT8QdrBUpSJSeYFJ5ht+Pw8B/dPqPxZS1HVGZw=
Date:   Wed, 3 Jul 2019 09:28:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190703072830.GE3033@kroah.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <CAEf4Bzb4ASMSNR0h+xgQHKEPryCtQnqFxtLnPvKuT4ME0eoe1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb4ASMSNR0h+xgQHKEPryCtQnqFxtLnPvKuT4ME0eoe1Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 02, 2019 at 12:22:56PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 27, 2019 at 1:20 PM Song Liu <songliubraving@fb.com> wrote:
> >
> > This patch introduce unprivileged BPF access. The access control is
> > achieved via device /dev/bpf. Users with write access to /dev/bpf are able
> > to call sys_bpf().
> >
> > Two ioctl command are added to /dev/bpf:
> >
> > The two commands enable/disable permission to call sys_bpf() for current
> > task. This permission is noted by bpf_permitted in task_struct. This
> > permission is inherited during clone(CLONE_THREAD).
> >
> > Helper function bpf_capable() is added to check whether the task has got
> > permission via /dev/bpf.
> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > ---
> >  Documentation/ioctl/ioctl-number.txt |  1 +
> >  include/linux/bpf.h                  | 11 +++++
> >  include/linux/sched.h                |  3 ++
> >  include/uapi/linux/bpf.h             |  6 +++
> >  kernel/bpf/arraymap.c                |  2 +-
> >  kernel/bpf/cgroup.c                  |  2 +-
> >  kernel/bpf/core.c                    |  4 +-
> >  kernel/bpf/cpumap.c                  |  2 +-
> >  kernel/bpf/devmap.c                  |  2 +-
> >  kernel/bpf/hashtab.c                 |  4 +-
> >  kernel/bpf/lpm_trie.c                |  2 +-
> >  kernel/bpf/offload.c                 |  2 +-
> >  kernel/bpf/queue_stack_maps.c        |  2 +-
> >  kernel/bpf/reuseport_array.c         |  2 +-
> >  kernel/bpf/stackmap.c                |  2 +-
> >  kernel/bpf/syscall.c                 | 71 +++++++++++++++++++++-------
> >  kernel/bpf/verifier.c                |  2 +-
> >  kernel/bpf/xskmap.c                  |  2 +-
> >  kernel/fork.c                        |  5 ++
> >  net/core/filter.c                    |  6 +--
> >  20 files changed, 99 insertions(+), 34 deletions(-)
> >
> > diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> > index c9558146ac58..19998b99d603 100644
> > --- a/Documentation/ioctl/ioctl-number.txt
> > +++ b/Documentation/ioctl/ioctl-number.txt
> > @@ -327,6 +327,7 @@ Code  Seq#(hex)     Include File            Comments
> >  0xB4   00-0F   linux/gpio.h            <mailto:linux-gpio@vger.kernel.org>
> >  0xB5   00-0F   uapi/linux/rpmsg.h      <mailto:linux-remoteproc@vger.kernel.org>
> >  0xB6   all     linux/fpga-dfl.h
> > +0xBP   01-02   uapi/linux/bpf.h        <mailto:bpf@vger.kernel.org>
> 
> should this be 0xBF?

Why?  It can be whatever the developer wants :)

thanks,

greg k-h
