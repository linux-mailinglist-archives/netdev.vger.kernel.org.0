Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6359F11408B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 13:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfLEMJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 07:09:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:58704 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729096AbfLEMJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Dec 2019 07:09:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A6C63AB87;
        Thu,  5 Dec 2019 12:09:10 +0000 (UTC)
Date:   Thu, 5 Dec 2019 12:09:05 +0000
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Laura Abbott <labbott@redhat.com>
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191205120905.GA5127@wotan.suse.de>
References: <20191202131847.30837-1-jolsa@kernel.org>
 <CAEf4BzY_D9JHjuU6K=ciS70NSy2UvSm_uf1NfN_tmFz1445Jiw@mail.gmail.com>
 <87wobepgy0.fsf@toke.dk>
 <CAADnVQK-arrrNrgtu48_f--WCwR5ki2KGaX=mN2qmW_AcRyb=w@mail.gmail.com>
 <CAEf4BzZ+0XpH_zJ0P78vjzmFAH3kGZ21w3-LcSEG=B=+ZQWJ=w@mail.gmail.com>
 <20191204135405.3ffb9ad6@cakuba.netronome.com>
 <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
 <20191205093548.6eee1449@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205093548.6eee1449@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 09:35:48AM +0100, Jesper Dangaard Brouer wrote:
> I don't think that is a good idea.  You are creating double work and
> wasting distro developers time.  Let me explain: 
> 
> 1. First of all, GitHub libbpf does not have a stable branches (which
> makes sense, given this is a read-only clone of kernel tree). Thus,
> distro developers have to maintain that themselves, in their internal
> package tree (that is based on GitHub libbpf).
> 
> 2. Kernel BPF changes usually require updates to libbpf, as selftests
> uses libbpf.  Thus, the distro kernel backporter is already required to
> backport libbpf parts.
> 
> This is double work, the code changes to libbpf are now maintained in
> two places for the distro.

I totally agree with Jesper here.

I don't know how the situatiom with packaging libbpf and bpftool looks
like in Fedora/Centos/RHEL now, but in openSUSE we would like to build
both of them from the kernel source - use kernel-source package as a
requirement and use the kernel tree from /usr/src/linux to build those.
We do that for bpftool and perf currently.

So far we are building bpftool and perf without libbpf being dynamically
linked, so there is no dependency between those packages, although we
would like to change it as soon as we find a consensus on this series of
patches.

> The disadvantage for distros to package libbpf (+ bpftool and perf) off
> their distro kernel tree is that a fix to libbpf, requires rolling a
> new kernel minor release.  The solution to that is simply that distro
> package for libbpf have a separate (RPM) spec file, with own
> versioning, which sources points to distro kernel tree.

That's a great idea. So far, we are using the same version for kernel,
bfptool and perf, but all of these have separate RPM specs, so we can do
that.

Michal
