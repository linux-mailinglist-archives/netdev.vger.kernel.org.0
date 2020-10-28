Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F3229D7FE
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbgJ1W1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733230AbgJ1W1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:27:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AvhIM0ZTutEsCzTPCsR2z619Aqyf5G1DMNl8HJokJSU=;
        b=Dp9R0z6jX+R8RKkEOp0brMhgw7OHK+bgw8bNU7L1hYzuT0i4UO2C1GMYYiwN4pij9CuWYK
        3COPMFr23GISPzL6bZlEfbtVmZGtg9/NrHt7ejSHE4JK7SaZ2cTL+khy68gaSplJ8VDd1L
        o41H2K72B9EhySTIDGKa2sZwH9Z66S8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-SlB6xF8XMY2TThljNqF-Mg-1; Wed, 28 Oct 2020 14:25:58 -0400
X-MC-Unique: SlB6xF8XMY2TThljNqF-Mg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9A13DCF986;
        Wed, 28 Oct 2020 18:25:55 +0000 (UTC)
Received: from krava (unknown [10.40.192.64])
        by smtp.corp.redhat.com (Postfix) with SMTP id BBB6360C04;
        Wed, 28 Oct 2020 18:25:35 +0000 (UTC)
Date:   Wed, 28 Oct 2020 19:25:34 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name
 search
Message-ID: <20201028182534.GS2900849@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-8-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022082138.2322434-8-jolsa@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> The kallsyms_expand_symbol function showed in several bpf related
> profiles, because it's doing linear search.
> 
> Before:
> 
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
>    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> 
>      2,535,458,767      cycles:k                         ( +-  0.55% )
>        940,046,382      cycles:u                         ( +-  0.27% )
> 
>              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> 
> Loading all the vmlinux symbols in rbtree and and switch to rbtree
> search in kallsyms_lookup_name function to save few cycles and time.
> 
> After:
> 
>  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
>    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> 
>      2,199,433,771      cycles:k                         ( +-  0.55% )
>        936,105,469      cycles:u                         ( +-  0.37% )
> 
>              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> 
> Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> used for 115285 symbols.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

FYI there's init_kprobes dependency on kallsyms_lookup_name in early
init call, so this won't work as it is :-\ will address this in v2

also I'll switch to sorted array and bsearch, because kallsyms is not
dynamically updated

jirka

> ---
>  kernel/kallsyms.c | 95 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 86 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 4fb15fa96734..107c8284170e 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -50,6 +50,36 @@ extern const u16 kallsyms_token_index[] __weak;
>  
>  extern const unsigned int kallsyms_markers[] __weak;
>  
> +static struct kmem_cache *symbol_cachep;
> +
> +struct symbol {
> +	char		name[KSYM_NAME_LEN];
> +	unsigned long	addr;
> +	struct rb_node	rb_node;
> +};
> +
> +static struct rb_root symbols_root = RB_ROOT;
> +
> +static struct symbol *find_symbol(const char *name)
> +{
> +	struct symbol *sym;
> +	struct rb_node *n;
> +	int err;
> +
> +	n = symbols_root.rb_node;
> +	while (n) {
> +		sym = rb_entry(n, struct symbol, rb_node);
> +		err = strcmp(name, sym->name);
> +		if (err < 0)
> +			n = n->rb_left;
> +		else if (err > 0)
> +			n = n->rb_right;
> +		else
> +			return sym;
> +	}
> +	return NULL;
> +}
> +
>  /*
>   * Expand a compressed symbol data into the resulting uncompressed string,
>   * if uncompressed string is too long (>= maxlen), it will be truncated,
> @@ -164,16 +194,12 @@ static unsigned long kallsyms_sym_address(int idx)
>  /* Lookup the address for this symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name)
>  {
> -	char namebuf[KSYM_NAME_LEN];
> -	unsigned long i;
> -	unsigned int off;
> +	struct symbol *sym;
>  
> -	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> -		off = kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
> +	sym = find_symbol(name);
> +	if (sym)
> +		return sym->addr;
>  
> -		if (strcmp(namebuf, name) == 0)
> -			return kallsyms_sym_address(i);
> -	}
>  	return module_kallsyms_lookup_name(name);
>  }
>  
> @@ -743,9 +769,60 @@ static const struct proc_ops kallsyms_proc_ops = {
>  	.proc_release	= seq_release_private,
>  };
>  
> +static bool __init add_symbol(struct symbol *new)
> +{
> +	struct rb_node *parent = NULL;
> +	struct rb_node **p;
> +	struct symbol *sym;
> +	int err;
> +
> +	p = &symbols_root.rb_node;
> +
> +	while (*p != NULL) {
> +		parent = *p;
> +		sym = rb_entry(parent, struct symbol, rb_node);
> +		err = strcmp(new->name, sym->name);
> +		if (err < 0)
> +			p = &(*p)->rb_left;
> +		else if (err > 0)
> +			p = &(*p)->rb_right;
> +		else
> +			return false;
> +	}
> +
> +	rb_link_node(&new->rb_node, parent, p);
> +	rb_insert_color(&new->rb_node, &symbols_root);
> +	return true;
> +}
> +
> +static int __init kallsyms_name_search_init(void)
> +{
> +	bool sym_added = true;
> +	struct symbol *sym;
> +	unsigned int off;
> +	unsigned long i;
> +
> +	symbol_cachep = KMEM_CACHE(symbol, SLAB_PANIC|SLAB_ACCOUNT);
> +
> +	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
> +		if (sym_added) {
> +			sym = kmem_cache_alloc(symbol_cachep, GFP_KERNEL);
> +			if (!sym)
> +				return -ENOMEM;
> +		}
> +		off = kallsyms_expand_symbol(off, sym->name, ARRAY_SIZE(sym->name));
> +		sym->addr = kallsyms_sym_address(i);
> +		sym_added = add_symbol(sym);
> +	}
> +
> +	if (!sym_added)
> +		kmem_cache_free(symbol_cachep, sym);
> +	return 0;
> +}
> +
>  static int __init kallsyms_init(void)
>  {
>  	proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
> -	return 0;
> +	return kallsyms_name_search_init();
>  }
>  device_initcall(kallsyms_init);
> -- 
> 2.26.2
> 

