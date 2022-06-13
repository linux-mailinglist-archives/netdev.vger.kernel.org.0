Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DE754A045
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 22:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350897AbiFMUyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350928AbiFMUxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 16:53:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CC06270;
        Mon, 13 Jun 2022 13:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03931B815A5;
        Mon, 13 Jun 2022 20:15:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91801C341C6;
        Mon, 13 Jun 2022 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655151334;
        bh=b/8VMS48rFYiEviowVXeqT6J9SY5rNVLT0UgxTwZTUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j1AAlI7QMYzRjcQuw42ItWMpK2AttkPHZp8P1GQUuTvJXflLhvE4pUT6tGStt02iN
         YjCHVIJir3qRC1IwRKDDebXM7DWBqejfFJoi/NgaWA4KFae6rwbVDdUq1C2YfvU3j4
         2NesundUnuMkMp90Bmy0m+/HvvU2jdmLkCV8SEoYBGvQvCR/kMl8qPMvM7Dmi1Vzm/
         GsSCm3re8ZHeyapw0hPLcZq2XpCDWKQihLk0o+iZ6OiJDSP3lpx63fT8dbv3M7g3I5
         Y0+6wpOFJfWxBmyHRZhhse8Llaj7jNTvo6JP0s3a4hKjQs/0LDrRkbpcuQKILnmUuZ
         n1i9zGu6JdNEQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B8F434096F; Mon, 13 Jun 2022 17:15:30 -0300 (-03)
Date:   Mon, 13 Jun 2022 17:15:30 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <Yqea4oMxjcnKbPdx@kernel.org>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
 <YqOvYo1tp32gKviM@krava>
 <YqYTZVa44Y6RQ11W@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqYTZVa44Y6RQ11W@krava>
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

Em Sun, Jun 12, 2022 at 06:25:09PM +0200, Jiri Olsa escreveu:
> On Fri, Jun 10, 2022 at 10:53:57PM +0200, Jiri Olsa wrote:
> > On Fri, Jun 10, 2022 at 11:45:48AM -0700, Andrii Nakryiko wrote:
> > > On Fri, Jun 10, 2022 at 11:34 AM Arnaldo Carvalho de Melo
> > > > libbpf: map 'flip_table': created successfully, fd=4
> > > > libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invalid argument
> > > > libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
> > > > Invalid insn code at line_info[11].insn_off

> > > Mismatched line_info.

> > > Jiri, I think we need to clear func_info and line_info in
> > > bpf_program__set_insns() because at that point func/line info can be
> > > mismatched and won't correspond to the actual set of instructions.

> so the problem is that we prepend init proglogue instructions
> for each program not just for the one that needs it, so it will
> mismatch later on.. the fix below makes it work for me

> Arnaldo,
> I squashed and pushed the change below changes to my bpf/depre
> branch, could you please retest?

I'll check.

- Arnaldo
