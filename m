Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD2D52FE9C
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 19:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245228AbiEURoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 13:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiEURoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 13:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47385D5F3;
        Sat, 21 May 2022 10:44:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB4A160C85;
        Sat, 21 May 2022 17:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBBFC385AA;
        Sat, 21 May 2022 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653155049;
        bh=Np0xS6FQYFY106jdncJgwjACC/cSt92txCtwznhMn00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n6J8kNBiF4RRCyXrOBgwU42drXWpKiOzpqbTKVmUPeLHtBWbHCougGGiKmSXoI+zm
         azchHrxBcse+n5YRzEaDdhGOMlnLzCTwhIPHW5KqSZ2ouqw7AGkZYqQCaDFsApE8/6
         +MnlJw2EkD7XC/U54QJRs5tIRPNXIbrSlIl+Fn4ZBMnKNvoJci1qFfAySACHlEPFoE
         R5ckzFTEJ6zoWRGvDd3syWa1O+bWt3g/sH1aXS2Lw9CsEb32Fw2me7XNUXUYdKf9nX
         KnoFa3x5BEe2iaowQETRQBQ3tsAkc0g2tOX+fDOYe4Jt7ysyVJj09IW+y6UUQOm5lL
         crwhutdNC5Vgw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4FD6C400B1; Sat, 21 May 2022 14:44:05 -0300 (-03)
Date:   Sat, 21 May 2022 14:44:05 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
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
Subject: Re: [PATCHv2 0/3] perf tools: Fix prologue generation
Message-ID: <Yokk5XRxBd72fqoW@kernel.org>
References: <20220510074659.2557731-1-jolsa@kernel.org>
 <CAEf4BzbK9zgetgE1yKkCANTZqizUrXgamJa2X0f0XmzQUdFrCQ@mail.gmail.com>
 <YntnRixbfQ1HCm9T@krava>
 <Ynv+7iaaAbyM38B6@kernel.org>
 <CAEf4BzaQsF31f3WuU32wDCzo6bw7eY8E9zF6Lo218jfw-VQmcA@mail.gmail.com>
 <YoTAhC+6j4JshqN8@krava>
 <YoYj6cb0aPNN/olH@krava>
 <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzaa60kZJbWT0xAqcDMyXBzbg98ShuizJAv7x+8_3X0ZBg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 20, 2022 at 02:46:49PM -0700, Andrii Nakryiko escreveu:
> On Thu, May 19, 2022 at 4:03 AM Jiri Olsa <olsajiri@gmail.com> wrote:
> > On Wed, May 18, 2022 at 11:46:44AM +0200, Jiri Olsa wrote:
> > > On Tue, May 17, 2022 at 03:02:53PM -0700, Andrii Nakryiko wrote:
> > > > Jiri, libbpf v0.8 is out, can you please re-send your perf patches?

> > > yep, just made new fedora package.. will resend the perf changes soon

> > fedora package is on the way, but I'll need perf/core to merge
> > the bpf_program__set_insns change.. Arnaldo, any idea when this
> > could happen?

> Can we land these patches through bpf-next to avoid such complicated
> cross-tree dependencies? As I started removing libbpf APIs I also
> noticed that perf is still using few other deprecated APIs:
>   - bpf_map__next;
>   - bpf_program__next;
>   - bpf_load_program;
>   - btf__get_from_id;
 
> It's trivial to fix up, but doing it across few trees will delay
> libbpf work as well.
 
> So let's land this through bpf-next, if Arnaldo doesn't mind?

Yeah, that should be ok, the only consideration is that I'm submitting
this today to Linus:

https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/commit/?h=tmp.perf/urgent&id=0ae065a5d265bc5ada13e350015458e0c5e5c351

To address this:

https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com/

- Arnaldo
