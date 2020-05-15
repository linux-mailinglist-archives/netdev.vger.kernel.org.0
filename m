Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 619C71D5613
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgEOQbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgEOQbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:31:52 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39571C061A0C;
        Fri, 15 May 2020 09:31:52 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id z18so2472970qto.2;
        Fri, 15 May 2020 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qWJplWQlnWRC9afl46qOWJcxiXlm4NEUM51q0ljY+vQ=;
        b=Qr7qtHrVlXDmY1zII6GIwRjsAZeo97nUvw9Pl6LHydipbHKZKOsREcDCWb/Nehay4q
         HPkyqmI3IOEbsYBhDpaXJrq16Vws8qxRXrJ7rzjlK+TvVhG2vNj/H5DHsLtQV0Kwk8vT
         L/0YqzgiFJoF5h4P3F8wa0c2Xt8FgX9EE0E+WMwb4AtPRxSzuWRK4rNlZ1eZXo+yjnRI
         UvG/FV0zTQwPi6Z0zcoCkDbZP6wa8zFXAQ4VnisEKYCHJIjuMHxKZamuv0112f1jymoA
         URx7xPYWkI7UqEkCP3ketlR0BEfAmPKepvS3QrMDHW5/elG9jrzQSimb/0HKyCfQqAp1
         d7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qWJplWQlnWRC9afl46qOWJcxiXlm4NEUM51q0ljY+vQ=;
        b=XFm5KdwulzFJ24owl2tJmAr2u9z+3jB5LbLiPDcZw+jwFbpoVqAryWom5MJJltwdTk
         yCSSUHYuFWzsHCJgwP2NQ6HNAxhXDqXHKmGu6sGaDJZkMqgfmXwdNgZmsc/CIwXXWYoI
         lkh3Fk8szMaJCh9iYdMoqS0H2folV6S4kQRzDWYV131SKnamDFc+TniAL38FJ3jF1nGq
         2v8S1FjRM1NXa9jWDal+8DKkmt5+nSIcTWI16+aRActE/DR3P/lADmZ6qxw0w3nk/V0b
         xc99kLgTQ1CPflt9O7w77OaHbnHx4p9zabEyI4GyxotlnFY+o7gboGaLxJbbZRaQ+LUq
         FiiA==
X-Gm-Message-State: AOAM532ewzMJkAPSMtXuO/m595ku9SuIo7UoHoZKeiR75AGdCJRgkCse
        /UZSi4sjRYYVsh7nLKdba+8=
X-Google-Smtp-Source: ABdhPJxTfV2SqcByVx6TzfUx3zWMgaeTTZ2afzCvX+IBk+67/nhyHvYXCNEKrESdgwDQxNoPU0z89A==
X-Received: by 2002:ac8:2f50:: with SMTP id k16mr4474062qta.392.1589560311093;
        Fri, 15 May 2020 09:31:51 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id e23sm1896496qkm.63.2020.05.15.09.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:31:49 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E013840AFD; Fri, 15 May 2020 13:31:46 -0300 (-03)
Date:   Fri, 15 May 2020 13:31:46 -0300
To:     Ian Rogers <irogers@google.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/8] libbpf hashmap: Localize static hashmap__* symbols
Message-ID: <20200515163146.GA9335@kernel.org>
References: <20200515065624.21658-1-irogers@google.com>
 <20200515065624.21658-5-irogers@google.com>
 <20200515091707.GC3511648@krava>
 <20200515142917.GT5583@kernel.org>
 <CAP-5=fXtXgnb4nrVtsoxQ6vj8YtzPicFsad6+jB5UUFqMzg4mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fXtXgnb4nrVtsoxQ6vj8YtzPicFsad6+jB5UUFqMzg4mw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 15, 2020 at 07:53:33AM -0700, Ian Rogers escreveu:
> On Fri, May 15, 2020 at 7:29 AM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> > Em Fri, May 15, 2020 at 11:17:07AM +0200, Jiri Olsa escreveu:
> > > On Thu, May 14, 2020 at 11:56:20PM -0700, Ian Rogers wrote:
> > > > Localize the hashmap__* symbols in libbpf.a. To allow for a version in
> > > > libapi.
> > > >
> > > > Before:
> > > > $ nm libbpf.a
> > > > ...
> > > > 000000000002088a t hashmap_add_entry
> > > > 000000000001712a t hashmap__append
> > > > 0000000000020aa3 T hashmap__capacity
> > > > 000000000002099c T hashmap__clear
> > > > 00000000000208b3 t hashmap_del_entry
> > > > 0000000000020fc1 T hashmap__delete
> > > > 0000000000020f29 T hashmap__find
> > > > 0000000000020c6c t hashmap_find_entry
> > > > 0000000000020a61 T hashmap__free
> > > > 0000000000020b08 t hashmap_grow
> > > > 00000000000208dd T hashmap__init
> > > > 0000000000020d35 T hashmap__insert
> > > > 0000000000020ab5 t hashmap_needs_to_grow
> > > > 0000000000020947 T hashmap__new
> > > > 0000000000000775 t hashmap__set
> > > > 00000000000212f8 t hashmap__set
> > > > 0000000000020a91 T hashmap__size
> > > > ...
> > > >
> > > > After:
> > > > $ nm libbpf.a
> > > > ...
> > > > 000000000002088a t hashmap_add_entry
> > > > 000000000001712a t hashmap__append
> > > > 0000000000020aa3 t hashmap__capacity
> > > > 000000000002099c t hashmap__clear
> > > > 00000000000208b3 t hashmap_del_entry
> > > > 0000000000020fc1 t hashmap__delete
> > > > 0000000000020f29 t hashmap__find
> > > > 0000000000020c6c t hashmap_find_entry
> > > > 0000000000020a61 t hashmap__free
> > > > 0000000000020b08 t hashmap_grow
> > > > 00000000000208dd t hashmap__init
> > > > 0000000000020d35 t hashmap__insert
> > > > 0000000000020ab5 t hashmap_needs_to_grow
> > > > 0000000000020947 t hashmap__new
> > > > 0000000000000775 t hashmap__set
> > > > 00000000000212f8 t hashmap__set
> > > > 0000000000020a91 t hashmap__size
> > > > ...
> > >
> > > I think this will break bpf selftests which use hashmap,
> > > we need to find some other way to include this
> > >
> > > either to use it from libbpf directly, or use the api version
> > > only if the libbpf is not compiled in perf, we could use
> > > following to detect that:
> > >
> > >       CFLAGS += -DHAVE_LIBBPF_SUPPORT
> > >       $(call detected,CONFIG_LIBBPF)
> >
> > And have it in tools/perf/util/ instead?
 
> *sigh*
 
> $ make -C tools/testing/selftests/bpf test_hashmap
> make: Entering directory
> '/usr/local/google/home/irogers/kernel-trees/kernel.org/tip/tools/testing/s
> elftests/bpf'
>  BINARY   test_hashmap
> /usr/bin/ld: /tmp/ccEGGNw5.o: in function `test_hashmap_generic':
> /usr/local/google/home/irogers/kernel-trees/kernel.org/tip/tools/testing/selftests/bpf/test_hashmap.
> c:61: undefined reference to `hashmap__new'
> ...
 
> My preference was to make hashmap a sharable API in tools, to benefit

That is my preference as well, I'm not defending having it in
tools/perf/util/, just saying that that is a possible way to make
progress with the current situation...

> not just perf but say things like libsymbol, libperf, etc. Moving it
> into perf and using conditional compilation is kinda gross but having
> libbpf tests depend on libapi also isn't ideal I guess. It is tempting
> to just cut a hashmap from fresh cloth to avoid this and to share
> among tools/. I don't know if the bpf folks have opinions?
> 
> I'll do a v2 using conditional compilation to see how bad it looks.

Cool, lets see how it looks.

- Arnaldo
