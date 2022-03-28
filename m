Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A4F4E9A36
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 16:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244118AbiC1O6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 10:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiC1O6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 10:58:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A9E5045F;
        Mon, 28 Mar 2022 07:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4622612AF;
        Mon, 28 Mar 2022 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1698AC340EC;
        Mon, 28 Mar 2022 14:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648479429;
        bh=9YwHEefT/8n642NDOj7aMWqFjD9D0kwdA+iwhOsxgKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A7sSe11BZ8CRURZzyxUZUZLVxxz/XZrSnSClgoO9h/EDRPX7aAQn1QyoEw42cPk7/
         70CE95JDQ4XbauwLiyEBvEldF4/VxIg11RS9XXywtJ5Qg4tb5Hmv0oBSmJEbNt50ST
         +vyLhGybSew0v14bkwQucLO6yVJzb7/VjigP8cW5ojn0sxPjAF7PlPTo6+PulTJJpV
         GK2YFRKY56ail00RdFIyuxXHMaOknXDnyW4CJsHbKH0bUccZA28wnNg9y2n/Tvv5iQ
         LPukK2yUW6x/J0JCkdFTg8TynHIZQF7CRJ7W3wW3HeLHd1HUikv9TYPrtRL+Um/GrW
         irHrXvsz0KCAQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9F59A40407; Mon, 28 Mar 2022 11:57:05 -0300 (-03)
Date:   Mon, 28 Mar 2022 11:57:05 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH] bpftool: Fix generated code in codegen_asserts
Message-ID: <YkHMwZJAV+vtQLo5@kernel.org>
References: <20220328083703.2880079-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220328083703.2880079-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Mar 28, 2022 at 10:37:03AM +0200, Jiri Olsa escreveu:
> Arnaldo reported perf compilation fail with:
> 
>   $ make -k BUILD_BPF_SKEL=1 CORESIGHT=1 PYTHON=python3
>   ...
>   In file included from util/bpf_counter.c:28:
>   /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h: In function ‘bperf_leader_bpf__assert’:
>   /tmp/build/perf//util/bpf_skel/bperf_leader.skel.h:351:51: error: unused parameter ‘s’ [-Werror=unused-parameter]
>     351 | bperf_leader_bpf__assert(struct bperf_leader_bpf *s)
>         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~^
>   cc1: all warnings being treated as errors
> 
> If there's nothing to generate in the new assert function,
> we will get unused 's' warn/error, adding 'unused' attribute to it.

We need some Makefile dependency to trigger the skels to be regenerated
when bpftool is updated.

And before that to notice that the bpftool source code changed and thus
the bootstrap bpftool needs to be rebuilt.

So, after a full tools/perf/ build from scratch it works:

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Ah, and to wire up a tools/perf/ build when doing a selftests build
perhaps so that libbpf developers can check if in-kernel tools linking
against it still builds when they change libbpf/bpftool?

Regards,

- Arnaldo
 
> Cc: Delyan Kratunov <delyank@fb.com>
> Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Fixes: 08d4dba6ae77 ("bpftool: Bpf skeletons assert type sizes")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/bpf/bpftool/gen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index 7ba7ff55d2ea..91af2850b505 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -477,7 +477,7 @@ static void codegen_asserts(struct bpf_object *obj, const char *obj_name)
>  	codegen("\
>  		\n\
>  		__attribute__((unused)) static void			    \n\
> -		%1$s__assert(struct %1$s *s)				    \n\
> +		%1$s__assert(struct %1$s *s __attribute__((unused)))	    \n\
>  		{							    \n\
>  		#ifdef __cplusplus					    \n\
>  		#define _Static_assert static_assert			    \n\
> -- 
> 2.35.1

-- 

- Arnaldo
