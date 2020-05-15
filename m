Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3585A1D5077
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgEOO3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726140AbgEOO3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:29:23 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF36C061A0C;
        Fri, 15 May 2020 07:29:22 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s1so2671592qkf.9;
        Fri, 15 May 2020 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dtNRvYDLFJiXxv3gO1edkx9pgOz+9ogJg6Qke0J72co=;
        b=Q03Rh3l3PaEOnIUoHwy/z/RndYeBqFW8NxPJuf+VyQrlfQfjBkUpYtoLrIs/8JBfvd
         ELK4ULr1mg5KpeWPQEGyHYGtzHA5Cb+dsIVBl+c36e90OG2IFF4rxoUynes0BiBzF0UM
         7L9osjFDgE7JNwWhp23FWc8A30tNFqj8eHloehb24su3dkl6bf+YMTle3mPB8+wBNKic
         uiG8gEcLI03SBnyc0Gjqg8AyEKWdxRkD5ZBh5HrVIbSh6P55Id/wNDTnirvmXz7RtuBC
         YWVb+1BFPBoygLWpYZTt3LGJo+YpgR+lPNCQ5PnQZFyJKki2HaWQ51RN5/ZWPtXqCPvZ
         m7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dtNRvYDLFJiXxv3gO1edkx9pgOz+9ogJg6Qke0J72co=;
        b=RSh+yDHzHIsKvk4H4bgrb+1q6PzjMGqRLKZKoHEbXxnk+yVqgRd3jY6J2I3aIJ83gB
         oLN4Ga9+QQYTb4AdiwaGJF1yjdFKT43zRJW1AbBAKi4luaBsIiVh2PxyrUkcbz07rJao
         e0QMMM1e0I4RSdWfcW4mh42+Kxm0D5Xbk+9tT+V7Wi94iwZ+0XOaMi0SFYFQ8bb+ppHp
         lO8R0hcfd/tq0IwXfJrNuVIq3WoOjHTi6xJ1JA1T/WvEMD/IVpIHD+yQsNYQv7YSIdli
         t2x4V3j4079QKPH6sJAgBZJvCnGS2kHdkUpvc2vWxHmeSaYW4VxibjZxOQAS5NyeHApr
         eaqw==
X-Gm-Message-State: AOAM5332TdqHWyps0byn0fX2geB5TrBhKwnDYk98DeC+UHRS10zQ5tiF
        u2hGYH3C9J7MEuSXFxfffGY=
X-Google-Smtp-Source: ABdhPJysGFcWv4VjZ7ky/8tpAB2PUgvUimjPJY5k3jHTJtiagHzdx0sPogoh5GKYhzi3gPxLznPFXw==
X-Received: by 2002:a05:620a:1502:: with SMTP id i2mr3502223qkk.420.1589552961490;
        Fri, 15 May 2020 07:29:21 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id t12sm1662483qkt.77.2020.05.15.07.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 07:29:20 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0AC0740AFD; Fri, 15 May 2020 11:29:18 -0300 (-03)
Date:   Fri, 15 May 2020 11:29:17 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
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
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 4/8] libbpf hashmap: Localize static hashmap__* symbols
Message-ID: <20200515142917.GT5583@kernel.org>
References: <20200515065624.21658-1-irogers@google.com>
 <20200515065624.21658-5-irogers@google.com>
 <20200515091707.GC3511648@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515091707.GC3511648@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 15, 2020 at 11:17:07AM +0200, Jiri Olsa escreveu:
> On Thu, May 14, 2020 at 11:56:20PM -0700, Ian Rogers wrote:
> > Localize the hashmap__* symbols in libbpf.a. To allow for a version in
> > libapi.
> > 
> > Before:
> > $ nm libbpf.a
> > ...
> > 000000000002088a t hashmap_add_entry
> > 000000000001712a t hashmap__append
> > 0000000000020aa3 T hashmap__capacity
> > 000000000002099c T hashmap__clear
> > 00000000000208b3 t hashmap_del_entry
> > 0000000000020fc1 T hashmap__delete
> > 0000000000020f29 T hashmap__find
> > 0000000000020c6c t hashmap_find_entry
> > 0000000000020a61 T hashmap__free
> > 0000000000020b08 t hashmap_grow
> > 00000000000208dd T hashmap__init
> > 0000000000020d35 T hashmap__insert
> > 0000000000020ab5 t hashmap_needs_to_grow
> > 0000000000020947 T hashmap__new
> > 0000000000000775 t hashmap__set
> > 00000000000212f8 t hashmap__set
> > 0000000000020a91 T hashmap__size
> > ...
> > 
> > After:
> > $ nm libbpf.a
> > ...
> > 000000000002088a t hashmap_add_entry
> > 000000000001712a t hashmap__append
> > 0000000000020aa3 t hashmap__capacity
> > 000000000002099c t hashmap__clear
> > 00000000000208b3 t hashmap_del_entry
> > 0000000000020fc1 t hashmap__delete
> > 0000000000020f29 t hashmap__find
> > 0000000000020c6c t hashmap_find_entry
> > 0000000000020a61 t hashmap__free
> > 0000000000020b08 t hashmap_grow
> > 00000000000208dd t hashmap__init
> > 0000000000020d35 t hashmap__insert
> > 0000000000020ab5 t hashmap_needs_to_grow
> > 0000000000020947 t hashmap__new
> > 0000000000000775 t hashmap__set
> > 00000000000212f8 t hashmap__set
> > 0000000000020a91 t hashmap__size
> > ...
> 
> I think this will break bpf selftests which use hashmap,
> we need to find some other way to include this
> 
> either to use it from libbpf directly, or use the api version
> only if the libbpf is not compiled in perf, we could use
> following to detect that:
> 
>       CFLAGS += -DHAVE_LIBBPF_SUPPORT
>       $(call detected,CONFIG_LIBBPF)

And have it in tools/perf/util/ instead?


- Arnaldo
