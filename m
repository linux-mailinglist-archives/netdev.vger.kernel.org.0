Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59893530E15
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiEWJM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiEWJMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:12:25 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E93C46B13;
        Mon, 23 May 2022 02:12:22 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id z17so1457477wmf.1;
        Mon, 23 May 2022 02:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=egAIJlKc/aPkVb1Biokh2hN70858f3sjkF4PZ+ty2xk=;
        b=jlngNwD7fvb2j8fMzZa6C7PglBvcnwdxcoKBqHa8PbxfI3u1FdGBxdB9QT+LYxbL0W
         nWTaqLVfmnaf3kAsA+HT5TL454IJHO2QUSsQVM6EGVT/r4lKKAXaw+4QdzG5lgwV2FL7
         dkscBWoYzXQGW2fHftKe/NXC1An6D6MvE8B+lu1XO+dO7jZFwtTNVGk5DcKzS1RX2Ibn
         l6/+q0ZcdNPlO4zIytgC5wOQX7PLSG1v1peN0PnJXdY4XC9EhF5c6xDq+JpF44udXLcG
         aTWWFpqBys1aPwetraWSNKfc6DXDwVCLXeJJ6O5HLjpjEKqiA9GMEJb2cW8dDZzOfUbk
         HjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=egAIJlKc/aPkVb1Biokh2hN70858f3sjkF4PZ+ty2xk=;
        b=DCEqxa4pnSVLqGDuF5qwYQq87ki/9YSskPZZcLopoEYm08XMpLxX0zRdTtjM223y3m
         fuwtVY1D8AMdVtQaWy2scQp41fvhYIcsgT0Kq/3cLxuQxZffkrY5iL/K8lTPqgNUw7kD
         cBTd0QpDSyD0ldViuDBqFeBexBiDOwsggIsMFK0b1jqGJNTAbMLBCZ8gUcgTQHq9Z+cK
         rGbmRTbp1vOVZXNwnCJ3rtNX+tycW24kW59A5YK+KhDnU8QpbrJufZbWrscXAYZDzohM
         wjDmU4O/j84UtW+6p7AxRt6eVuQX2nSVHTdjTVHUxBGrS31/9iCJYST09bZdikgTt9tp
         KdjA==
X-Gm-Message-State: AOAM53320+e/5PRVY0nqFF+vL+HBEWbDDp2DUFiD3rgfC1cy99NgMsj8
        ijn7KmSQ9vKV1Ai/d+AzBs0=
X-Google-Smtp-Source: ABdhPJw+BGvRP7B9Gh2h4OE/iUlpk0WVCPinxzxXS1dyh2XEg9wSxMaklDr/+VXuj00oxlOVE51USA==
X-Received: by 2002:a05:600c:2248:b0:394:31c6:b6ae with SMTP id a8-20020a05600c224800b0039431c6b6aemr19125415wmm.99.1653297140800;
        Mon, 23 May 2022 02:12:20 -0700 (PDT)
Received: from krava (net-93-65-240-241.cust.vodafonedsl.it. [93.65.240.241])
        by smtp.gmail.com with ESMTPSA id p16-20020a05600c359000b0039740903c39sm5892884wmq.7.2022.05.23.02.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 02:12:20 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 23 May 2022 11:12:16 +0200
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
Message-ID: <YotP8BrIK/dwLJLL@krava>
References: <20220520211826.1828180-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520211826.1828180-1-irogers@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 02:18:26PM -0700, Ian Rogers wrote:
> LIBBPF requires LIBELF so doing "make BUILD_BPF_SKEL=1 NO_LIBELF=1"
> fails with compiler errors about missing declarations. Similar could
> happen if libbpf feature detection fails. Prefer to error when
> BUILD_BPF_SKEL is enabled but LIBBPF isn't.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/perf/Makefile.config | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
> index d9b699ad402c..bedb734bd6f2 100644
> --- a/tools/perf/Makefile.config
> +++ b/tools/perf/Makefile.config
> @@ -664,6 +664,9 @@ ifdef BUILD_BPF_SKEL
>    ifeq ($(feature-clang-bpf-co-re), 0)
>      dummy := $(error Error: clang too old/not installed. Please install recent clang to build with BUILD_BPF_SKEL)
>    endif
> +  ifeq ($(filter -DHAVE_LIBBPF_SUPPORT, $(CFLAGS)),)
> +    dummy := $(error Error: BPF skeleton support requires libbpf)
> +  endif
>    $(call detected,CONFIG_PERF_BPF_SKEL)
>    CFLAGS += -DHAVE_BPF_SKEL
>  endif
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
