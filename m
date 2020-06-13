Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADDB1F8595
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgFMWOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFMWOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 18:14:22 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6781C20789;
        Sat, 13 Jun 2020 22:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592086461;
        bh=pYMSq2imgTOvmvL665OX5Xw/S5VmKP/5qtwZkMvOoEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X7SqHb999bhQvtvtS46PFUWV2jQv3LxTR28sZ9ADAoFKIWpYhG7PliHCQAe2ggmqK
         BK1tXC9KKHi/Tf5wCP2EjEuZPEuZ2lf+pY0BIB5T7V1FshjYz9yOcwxbS8ApkFK2OE
         S38QloZHFUcKFOq2PmJIaaCdLj6KtJ8+XLqDcpcQ=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 8B1DF40AFD; Sat, 13 Jun 2020 19:14:19 -0300 (-03)
Date:   Sat, 13 Jun 2020 19:14:19 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [RFC PATCH bpf-next 8/8] tools/bpftool: show PIDs with FDs open
 against BPF map/prog/link/btf
Message-ID: <20200613221419.GB7488@kernel.org>
References: <20200612223150.1177182-1-andriin@fb.com>
 <20200612223150.1177182-9-andriin@fb.com>
 <20200613034507.wjhd4z6dsda3pz7c@ast-mbp>
 <CAEf4BzaHVRxkiDbTGashiuakXFBRYvDsQmJ0O08xFijKXiAwSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaHVRxkiDbTGashiuakXFBRYvDsQmJ0O08xFijKXiAwSg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jun 12, 2020 at 10:57:59PM -0700, Andrii Nakryiko escreveu:
> On Fri, Jun 12, 2020 at 8:45 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Fri, Jun 12, 2020 at 03:31:50PM -0700, Andrii Nakryiko wrote:
> > > Add bpf_iter-based way to find all the processes that hold open FDs against
> > > BPF object (map, prog, link, btf). Add new flag (-o, for "ownership", given
> > > -p is already taken) to trigger collection and output of these PIDs.
> > >
> > > Sample output for each of 4 BPF objects:
> > >
> > > $ sudo ./bpftool -o prog show
> > > 1992: cgroup_skb  name egress_alt  tag 9ad187367cf2b9e8  gpl
> > >         loaded_at 2020-06-12T14:18:10-0700  uid 0
> > >         xlated 48B  jited 59B  memlock 4096B  map_ids 2074
> > >         btf_id 460
> > >         pids: 913709,913732,913733,913734
> > > 2062: cgroup_device  tag 8c42dee26e8cd4c2  gpl
> > >         loaded_at 2020-06-12T14:37:52-0700  uid 0
> > >         xlated 648B  jited 409B  memlock 4096B
> > >         pids: 1
> > >
> > > $ sudo ./bpftool -o map show
> > > 2074: array  name test_cgr.bss  flags 0x400
> > >         key 4B  value 8B  max_entries 1  memlock 8192B
> > >         btf_id 460
> > >         pids: 913709,913732,913733,913734
> > >
> > > $ sudo ./bpftool -o link show
> > > 82: cgroup  prog 1992
> > >         cgroup_id 0  attach_type egress
> > >         pids: 913709,913732,913733,913734
> > > 86: cgroup  prog 1992
> > >         cgroup_id 0  attach_type egress
> > >         pids: 913709,913732,913733,913734
> >
> > This is awesome.

Indeed.
 
> Thanks.
> 
> >
> > Why extra flag though? I think it's so useful that everyone would want to see

Agreed.
 
> No good reason apart from "being safe by default". If turned on by
> default, bpftool would need to probe for bpf_iter support first. I can
> add probing and do this by default.

I think this is the way to go.
 
> > this by default. Also the word 'pid' has kernel meaning or user space meaning?
> > Looks like kernel then bpftool should say 'tid'.
> 
> No, its process ID in user-space sense. See task->tgid in
> pid_iter.bpf.c. I figured thread ID isn't all that useful.
> 
> > Could you capture comm as well and sort it by comm, like:
> >
> > $ sudo ./bpftool link show
> > 82: cgroup  prog 1992
> >         cgroup_id 0  attach_type egress
> >         systemd(1), firewall(913709 913732), logger(913733 913734)
> 
> Yep, comm is useful, I'll add that. Grouping by comm is kind of a
> pain, though, plus usually there will be one process only. So let me
> start with doing comm (pid) for each PID independently. I think that
> will be as good in practice.

-- 

- Arnaldo
