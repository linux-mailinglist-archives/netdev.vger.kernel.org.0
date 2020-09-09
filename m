Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F99262865
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgIIHVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 03:21:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20875 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgIIHVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 03:21:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599636066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yiH+x94EcrDjaJ/4+l07upDx3I8qG7SJjDhjeOX+txQ=;
        b=fvnw/7o8FDHx/7MKYeysysbkhsfk6hXf/nryntMP82jspqUQghKWovH2I085zfHbuXz8Mx
        WT312VI9DsaWghUdGfKGTi8B5yhJ2gOlaDRNti6WloGEtCH4xT5N17C64gfKQox8v3S1f8
        gleDORQfNCBxv82W2z6/Dx7x3DEp6IA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-fv_6LOWXMyOJkU8d3XytzA-1; Wed, 09 Sep 2020 03:21:04 -0400
X-MC-Unique: fv_6LOWXMyOJkU8d3XytzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70F8410BBED3;
        Wed,  9 Sep 2020 07:21:03 +0000 (UTC)
Received: from krava (unknown [10.40.194.91])
        by smtp.corp.redhat.com (Postfix) with SMTP id B26157E187;
        Wed,  9 Sep 2020 07:21:01 +0000 (UTC)
Date:   Wed, 9 Sep 2020 09:21:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, acme@kernel.org, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next] perf: stop using deprecated bpf_program__title()
Message-ID: <20200909072100.GB1498025@krava>
References: <20200908180127.1249-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908180127.1249-1-andriin@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 11:01:27AM -0700, Andrii Nakryiko wrote:
> Switch from deprecated bpf_program__title() API to
> bpf_program__section_name(). Also drop unnecessary error checks because
> neither bpf_program__title() nor bpf_program__section_name() can fail or
> return NULL.
> 
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  tools/perf/util/bpf-loader.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index 2feb751516ab..0374adcb223c 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -328,12 +328,6 @@ config_bpf_program(struct bpf_program *prog)
>  	probe_conf.no_inlines = false;
>  	probe_conf.force_add = false;
>  
> -	config_str = bpf_program__title(prog, false);
> -	if (IS_ERR(config_str)) {
> -		pr_debug("bpf: unable to get title for program\n");
> -		return PTR_ERR(config_str);
> -	}
> -
>  	priv = calloc(sizeof(*priv), 1);
>  	if (!priv) {
>  		pr_debug("bpf: failed to alloc priv\n");
> @@ -341,6 +335,7 @@ config_bpf_program(struct bpf_program *prog)
>  	}
>  	pev = &priv->pev;
>  
> +	config_str = bpf_program__section_name(prog);
>  	pr_debug("bpf: config program '%s'\n", config_str);
>  	err = parse_prog_config(config_str, &main_str, &is_tp, pev);
>  	if (err)
> @@ -454,10 +449,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
>  	if (err) {
>  		const char *title;
>  
> -		title = bpf_program__title(prog, false);
> -		if (!title)
> -			title = "[unknown]";
> -
> +		title = bpf_program__section_name(prog);
>  		pr_debug("Failed to generate prologue for program %s\n",
>  			 title);
>  		return err;
> -- 
> 2.24.1
> 

