Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29835310B4
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235572AbiEWMgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiEWMeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:34:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C667542A39;
        Mon, 23 May 2022 05:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D134B80FF4;
        Mon, 23 May 2022 12:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0082C385AA;
        Mon, 23 May 2022 12:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653309251;
        bh=IqR90Auy8+tT5aBpfUUHrQsHhH/KbDi15pMJuDCIMFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=imDXnGyIkgwwzqBvghc35XlYOcVmZcIlk/acnHhC5QP+tPXLaT8oHoiSYIRyVJiOp
         MjSi1ss6NJPbXhE9hGfUWHWL1MOfG4qc5LxnLDw0w4tcnmiiRYIm0IxnHgGXg+mllw
         he3OmR83kipEPT9BP9NqKRyXpeYO7O4IKFJr2Lh/I51p9s0ra41n1V8FoBJbsIQxpG
         GIOECSmMZgDGeYPkDIMXu4g7nEypp+EsvLa9+J+Ni3aqsNqq6S/LBuZGhecVcuPOW3
         StAfBCcMyRNiC7BDd+arC80MCOsv832gnMGvOgz8sTqTF+rHuoqTWoAKFlyfOX7Aab
         TrjYb0mcY4Izg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 02E33400B1; Mon, 23 May 2022 09:34:07 -0300 (-03)
Date:   Mon, 23 May 2022 09:34:07 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Error for BPF skeletons without LIBBPF
Message-ID: <Yot/P/QO0sAK2iwg@kernel.org>
References: <20220520211826.1828180-1-irogers@google.com>
 <YotP8BrIK/dwLJLL@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YotP8BrIK/dwLJLL@krava>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, May 23, 2022 at 11:12:16AM +0200, Jiri Olsa escreveu:
> On Fri, May 20, 2022 at 02:18:26PM -0700, Ian Rogers wrote:
> > LIBBPF requires LIBELF so doing "make BUILD_BPF_SKEL=1 NO_LIBELF=1"
> > fails with compiler errors about missing declarations. Similar could
> > happen if libbpf feature detection fails. Prefer to error when
> > BUILD_BPF_SKEL is enabled but LIBBPF isn't.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@kernel.org>

Thanks, applied.

- Arnaldo

 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/Makefile.config | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> > index d9b699ad402c..bedb734bd6f2 100644
> > --- a/tools/perf/Makefile.config
> > +++ b/tools/perf/Makefile.config
> > @@ -664,6 +664,9 @@ ifdef BUILD_BPF_SKEL
> >    ifeq ($(feature-clang-bpf-co-re), 0)
> >      dummy := $(error Error: clang too old/not installed. Please install recent clang to build with BUILD_BPF_SKEL)
> >    endif
> > +  ifeq ($(filter -DHAVE_LIBBPF_SUPPORT, $(CFLAGS)),)
> > +    dummy := $(error Error: BPF skeleton support requires libbpf)
> > +  endif
> >    $(call detected,CONFIG_PERF_BPF_SKEL)
> >    CFLAGS += -DHAVE_BPF_SKEL
> >  endif
> > -- 
> > 2.36.1.124.g0e6072fb45-goog
> > 

-- 

- Arnaldo
