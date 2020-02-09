Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94105156C80
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 22:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBIVDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 16:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727404AbgBIVDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Feb 2020 16:03:15 -0500
Received: from localhost (unknown [38.98.37.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 340BE20733;
        Sun,  9 Feb 2020 21:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581282195;
        bh=KC9IpAGE6KGFjiHbtyoLHb96L0+56asDYIPJpJQvbuo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k5qUnLm9zBT8RXXizch89Ontj4w33hU/m0SljoAKD9XibfRY/ItzOBv/im72ZELai
         oHYifNCSyQhdyMzy+x2Khe08K5bi/TAWVaa4PO2VSCrOOh82jieVxDfDqIwKvorowN
         aR8ZFRcKLxUm41A9x4ob3K/BlnG00M0zcRQKkm4Y=
Date:   Sun, 9 Feb 2020 22:03:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
Message-ID: <20200209210303.GA50543@kroah.com>
References: <20191212013521.1689228-1-andriin@fb.com>
 <CA+G9fYtAQGwf=OoEvHwbJpitcfhpfhy-ar+6FRrWC_-ti7sUTg@mail.gmail.com>
 <CAEf4BzbEfuDNVr_gfEu13GvBAvdE1Qdw6nOxOJENzm69=iyUgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbEfuDNVr_gfEu13GvBAvdE1Qdw6nOxOJENzm69=iyUgg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 09, 2020 at 10:32:43AM -0800, Andrii Nakryiko wrote:
> On Sun, Feb 9, 2020 at 9:18 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Thu, 12 Dec 2019 at 07:05, Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > This patch set fixes perf_buffer__new() behavior on systems which have some of
> > > the CPUs offline/missing (due to difference between "possible" and "online"
> > > sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> > > perf_event only on CPUs present and online at the moment of perf_buffer
> > > creation. Without this logic, perf_buffer creation has no chances of
> > > succeeding on such systems, preventing valid and correct BPF applications from
> > > starting.
> > >
> > > Andrii Nakryiko (4):
> > >   libbpf: extract and generalize CPU mask parsing logic
> > >   selftests/bpf: add CPU mask parsing tests
> > >   libbpf: don't attach perf_buffer to offline/missing CPUs
> >
> > perf build failed on stable-rc 5.5 branch.
> >
> > libbpf.c: In function '__perf_buffer__new':
> > libbpf.c:6159:8: error: implicit declaration of function
> > 'parse_cpu_mask_file'; did you mean 'parse_uint_from_file'?
> > [-Werror=implicit-function-declaration]
> >   err = parse_cpu_mask_file(online_cpus_file, &online, &n);
> >         ^~~~~~~~~~~~~~~~~~~
> >         parse_uint_from_file
> > libbpf.c:6159:8: error: nested extern declaration of
> > 'parse_cpu_mask_file' [-Werror=nested-externs]
> >
> > build log,
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/11/console
> >
> 
> Thanks for reporting!
> 
> These changes depend on commit 6803ee25f0ea ("libbpf: Extract and
> generalize CPU mask parsing logic"), which weren't backported to
> stable. Greg, can you please pull that one as well? Thanks!

Now applied, thanks!

greg k-h
