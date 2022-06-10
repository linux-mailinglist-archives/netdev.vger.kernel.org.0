Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE32546C97
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346887AbiFJSin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346484AbiFJSim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC81639141;
        Fri, 10 Jun 2022 11:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 912346220F;
        Fri, 10 Jun 2022 18:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93423C34114;
        Fri, 10 Jun 2022 18:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654886317;
        bh=2CfENGwSV7+ZrGlzU0bl1HwjpvH/2wzomg7Wf7Ie3bA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCn2VMisZAhUooGZwgoNK9bDxHpHcg9cRQmL3tkcqJB9MjLPrgwEcKMtESGWKZqxg
         Bn4pzQEdaz8asb+aWaaX56ZMsFmqzCCQTi5XoK6AhZEpnNMxJTcvL5epmqYZ+ytvOn
         DGqkCPVVIdGghCAdPPv0HSZZn++VKF5yohCOhRMO1dhw/CAYEHgknyZTqEhjSr3gNg
         GEpHPmXoSivK8Px4hWuvO6Rr37PA99t7FH7/Cpj20k4w2QrQ5eejyo53UM4qUEdI0c
         Juo5oX1Mn9bNBjJ+9QQSYC2hdpwtzQocAEhX+PGm9SIcpTyrSdJgJyVhprkqh+Aiv4
         59ulaj/StVHYA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 129774096F; Fri, 10 Jun 2022 15:38:35 -0300 (-03)
Date:   Fri, 10 Jun 2022 15:38:35 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
Message-ID: <YqOPq3g7lwtGefRn@kernel.org>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqOOsL8EbbO3lhmC@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jun 10, 2022 at 03:34:24PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jun 09, 2022 at 01:31:52PM -0700, Andrii Nakryiko escreveu:
> > On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > sending change we discussed some time ago [1] to get rid of
> > > some deprecated functions we use in perf prologue code.
> > >
> > > Despite the gloomy discussion I think the final code does
> > > not look that bad ;-)
> > >
> > > This patchset removes following libbpf functions from perf:
> > >   bpf_program__set_prep
> > >   bpf_program__nth_fd
> > >   struct bpf_prog_prep_result
> > >
> > > v4 changes:
> > >   - fix typo [Andrii]
> > >
> > > v3 changes:
> > >   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
> > >     because it's not needed [Andrii]
> > >   - rebased/post on top of bpf-next/master which now has
> > >     all the needed perf/core changes
> > >
> > > v2 changes:
> > >   - use fallback section prog handler, so we don't need to
> > >     use section prefix [Andrii]
> > >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> > >   - squash patch 1 from previous version with
> > >     bpf_program__set_insns change [Daniel]
> > >   - patch 3 already merged [Arnaldo]
> > >   - added more comments
> > >
> > > thanks,
> > > jirka
> > >
> > 
> > Arnaldo, can I get an ack from you for this patch set? Thank you!
> 
> So, before these patches:
> 
> [acme@quaco perf-urgent]$ git log --oneline -5
> 22905f78d181f446 (HEAD) libperf evsel: Open shouldn't leak fd on failure
> a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> 874c8ca1e60b2c56 netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
> 3d9f55c57bc3659f Merge tag 'fs_for_v5.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf -v
> perf version 5.19.rc1.g22905f78d181
> [root@quaco ~]# perf test 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : Ok
>  42.2: BPF pinning                                                   : Ok
>  42.3: BPF prologue generation                                       : Ok
> [root@quaco ~]#
> 
> And after:
> 
> [acme@quaco perf-urgent]$ git log --oneline -5
> f8ec656242acf2de (HEAD -> perf/urgent) perf tools: Rework prologue generation code
> a750a8dd7e5d2d4b perf tools: Register fallback libbpf section handler
> d28f2a8ad42af160 libperf evsel: Open shouldn't leak fd on failure
> a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
> 785cb9e85e8ba66f perf unwind: Fix uninitialized variable
> [acme@quaco perf-urgent]$ sudo su -
> [root@quaco ~]# perf -v
> perf version 5.19.rc1.gf8ec656242ac
> [root@quaco ~]# perf test 42
>  42: BPF filter                                                      :
>  42.1: Basic BPF filtering                                           : FAILED!
>  42.2: BPF pinning                                                   : FAILED!
>  42.3: BPF prologue generation                                       : Ok
> [root@quaco ~]# 
> 
> Jiri, can you try reproducing these? Do this require some other work
> that is in bpf-next/master? Lemme try...

No:

[acme@quaco perf-urgent]$ git log --oneline -5
d324948b907b292e (HEAD -> bpf-next-master) perf tools: Rework prologue generation code
911fc51320e09283 perf tools: Register fallback libbpf section handler
fe92833524e368e5 (bpf-next/master, bpf-next/for-next) libbpf: Fix uprobe symbol file offset calculation logic
492f99e4190a4574 bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"
0b817059a8830b8b bpftool: Fix bootstrapping during a cross compilation
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf -v
perf version 5.18.gd324948b907b
[root@quaco ~]# perf test 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : FAILED!
 42.2: BPF pinning                                                   : FAILED!
 42.3: BPF prologue generation                                       : Ok
[root@quaco ~]#

Removing these two patches:

[acme@quaco perf-urgent]$ git log --oneline -5
fe92833524e368e5 (HEAD -> bpf-next-master, bpf-next/master, bpf-next/for-next) libbpf: Fix uprobe symbol file offset calculation logic
492f99e4190a4574 bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"
0b817059a8830b8b bpftool: Fix bootstrapping during a cross compilation
d352bd889b6a9c97 Merge branch 'bpf: Add 64bit enum value support'
61dbd5982964074f docs/bpf: Update documentation for BTF_KIND_ENUM64 support
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf -v
perf version 5.18.gfe92833524e3
[root@quaco ~]# perf test 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : Ok
 42.2: BPF pinning                                                   : Ok
 42.3: BPF prologue generation                                       : Ok
[root@quaco ~]# 

- Arnaldo
