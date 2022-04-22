Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3940650BDD7
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348198AbiDVRGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbiDVRGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:06:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F236FA04;
        Fri, 22 Apr 2022 10:03:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34347B8311D;
        Fri, 22 Apr 2022 17:03:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3083C385A4;
        Fri, 22 Apr 2022 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650647007;
        bh=Xo8DuXhvaecEdzq/s8yjTmStQeqLUDbXLz2tAC/LGqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vmsk6spFqgx2kreMHrxlERhR0MBxeBvbV7QnMgMeCTIl5gO7NqR9d113MN3bGAM5e
         1ELKycDB9FrZPBPi7ewwTgfYiSNnpfllnAL9+yjV0XHz0fZSomiFdG0BRZmX3raWiX
         rGXxWZl4fO9k0sQJny2FaV0wEOaJpPg9nDEWKYyY496WG+tm3Aw5v184UYu6FZsVU2
         +0l4ui3HX/8yuiUqjCEntLdjCLGmmpdFtuuRJ03BL5tl/HwILCVWjlzIhuLE+P+xBb
         XVbkz4v55jIRBjLcu3U2Z+jlB4+kirXYz/9/CSmoLstcEwzSCSmg0GtHpnjoTLaSgp
         RCZs/g4E3bVOA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 35AD6400B1; Fri, 22 Apr 2022 14:03:24 -0300 (-03)
Date:   Fri, 22 Apr 2022 14:03:24 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCH perf/core 3/5] perf tools: Move libbpf init in
 libbpf_init function
Message-ID: <YmLf3PQ9ws2C/Myu@kernel.org>
References: <20220422100025.1469207-1-jolsa@kernel.org>
 <20220422100025.1469207-4-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422100025.1469207-4-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Apr 22, 2022 at 12:00:23PM +0200, Jiri Olsa escreveu:
> Moving the libbpf init code into single function,
> so we have single place doing that.

Cherry picked this one, waiting for Andrii to chime in wrt the libbpf
changes, if its acceptable, how to proceed, i.e. in what tree to carry
these?

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-loader.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index b72cef1ae959..f8ad581ea247 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -99,16 +99,26 @@ static int bpf_perf_object__add(struct bpf_object *obj)
>  	return perf_obj ? 0 : -ENOMEM;
>  }
>  
> +static int libbpf_init(void)
> +{
> +	if (libbpf_initialized)
> +		return 0;
> +
> +	libbpf_set_print(libbpf_perf_print);
> +	libbpf_initialized = true;
> +	return 0;
> +}
> +
>  struct bpf_object *
>  bpf__prepare_load_buffer(void *obj_buf, size_t obj_buf_sz, const char *name)
>  {
>  	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = name);
>  	struct bpf_object *obj;
> +	int err;
>  
> -	if (!libbpf_initialized) {
> -		libbpf_set_print(libbpf_perf_print);
> -		libbpf_initialized = true;
> -	}
> +	err = libbpf_init();
> +	if (err)
> +		return ERR_PTR(err);
>  
>  	obj = bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
>  	if (IS_ERR_OR_NULL(obj)) {
> @@ -135,14 +145,13 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
>  {
>  	LIBBPF_OPTS(bpf_object_open_opts, opts, .object_name = filename);
>  	struct bpf_object *obj;
> +	int err;
>  
> -	if (!libbpf_initialized) {
> -		libbpf_set_print(libbpf_perf_print);
> -		libbpf_initialized = true;
> -	}
> +	err = libbpf_init();
> +	if (err)
> +		return ERR_PTR(err);
>  
>  	if (source) {
> -		int err;
>  		void *obj_buf;
>  		size_t obj_buf_sz;
>  
> -- 
> 2.35.1

-- 

- Arnaldo
