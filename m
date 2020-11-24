Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B222C1DBB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 06:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgKXFti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 00:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgKXFth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 00:49:37 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB86EC0613CF;
        Mon, 23 Nov 2020 21:49:37 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id l17so6025161pgk.1;
        Mon, 23 Nov 2020 21:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uhw7TTm+4bnlZWqRapgwb4EjM+pZeg28coQzxyKfOOY=;
        b=my1V1W7eM8N2VTazKMRl2UmMUzqDAO9PdoHgNL2rmP2M3YnX1HRAn9cNhrAqXFoIOk
         syA9FNMYoNDr6kODMLb0JSGTE+FtMSQ5i7EyWCEj/GcC3MmiZGZlAbPwSaConaqGZm+A
         1bcnzvm+rI0Ml81kiUbPCPL4EsyupJkCeccc/Tm+tyq7GRVlOpgyIgJr9nU4jC9sue96
         flBT+Hd9NOesv6Sm0VqtFbXm/VQUoLmSWO3fuSmF3TM+GQUVoQHRJj50V70cD6hBEEI+
         kVW569fC8KgrWKMyMM2acii9rM+LLm1EBF1OuTSWfxiWG49viBmPcpI4+xu2jNN94S+e
         pVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uhw7TTm+4bnlZWqRapgwb4EjM+pZeg28coQzxyKfOOY=;
        b=kNa4HtZZKyRBypBqPC8xGf0A6Pg1RAdoj/RQySuN1HV34jZqSLFkmY28RaEqpEX9rD
         ymcA69Q2qpvjFNrylXuEtQ9keoniqNrQTbymxMLtA4wZaMzH5/wX2LiWMzsHRgUJeLMr
         QK4ncGw7AOCcgMl3CaFdLLiRW3r0mwAwF77wJJ9OKIqCHANib5wfg9taEd8SaIEQNboG
         D/jCn++3nNOPMSBIFccGq6CZSrtPE5WR+FMXGZJTvjwyzAsAOjxXyXDyyrMhuu8klFIJ
         KG/EavEmjhihHLAZ/Vefi8DH9PA6NP8mSJloyz6jUBswfNKvsRW/viScbTESJ9GFRIMB
         27bw==
X-Gm-Message-State: AOAM533XFLSPi/YkL+LiN3krawD9AW1Zh+buhB86EUgAraTTVMCN6w7x
        RYdhUNnZttOBMY7p/HIpNgQ=
X-Google-Smtp-Source: ABdhPJzDMPd9+rvFglewuCnZMyTaqUuJJHyRNizth43khZ5pF4czJ/SSdKka6UAjGi5BQjv7wAPOOw==
X-Received: by 2002:a17:90a:4814:: with SMTP id a20mr2924577pjh.163.1606196977260;
        Mon, 23 Nov 2020 21:49:37 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2397])
        by smtp.gmail.com with ESMTPSA id u197sm13930077pfc.127.2020.11.23.21.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 21:49:36 -0800 (PST)
Date:   Mon, 23 Nov 2020 21:49:24 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/6] bpf: fix bpf_put_raw_tracepoint()'s use of
 __module_address()
Message-ID: <20201124054924.i7zq7vig4xqmddyr@ast-mbp>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-2-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-2-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:39PM -0800, Andrii Nakryiko wrote:
> __module_address() needs to be called with preemption disabled or with
> module_mutex taken. preempt_disable() is enough for read-only uses, which is
> what this fix does.
> 
> Fixes: a38d1107f937 ("bpf: support raw tracepoints in modules")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d255bc9b2bfa..bb98a377050a 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2060,7 +2060,11 @@ struct bpf_raw_event_map *bpf_get_raw_tracepoint(const char *name)
>  
>  void bpf_put_raw_tracepoint(struct bpf_raw_event_map *btp)
>  {
> -	struct module *mod = __module_address((unsigned long)btp);
> +	struct module *mod;
> +
> +	preempt_disable();
> +	mod = __module_address((unsigned long)btp);
> +	preempt_enable();
>  
>  	if (mod)
>  		module_put(mod);

I don't understand why 'mod' cannot become dangling pointer after preempt_enable().
Either it needs a comment explaining why it's ok or module_put() should
be in preempt disabled section.
