Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E9E57D520
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 22:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiGUUvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 16:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiGUUva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 16:51:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09298F52C;
        Thu, 21 Jul 2022 13:51:29 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y4so3639890edc.4;
        Thu, 21 Jul 2022 13:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6vGrA0nNuCMZeyTertcq3i3Pav7G1W9MuISFp9Y13/E=;
        b=Q5tLlnqSkJp2N9i8gaTXHwGSFc8mgaRW2jaI948gVDzJn33enWzEyYNKK/qnek96G7
         Clj/TK5p3RYF0rsp8LUGVapH5Gdg9Dm/hS2Bb6OS/SaX+Z9/8B3E6kbEHeT+iTFBCLyV
         otLw4TYi+nkkGJxIEjQo5pEfEfidYUZoOJ+mgd4ezuvZQ2osf7mZmE213jeK61Gs346d
         lDX+GpczwDY5mTqP4FX1lgKD3gHteBcytsudyI/9tiTL+kPtfY025qGYs0qfo6pAwwx2
         rZ257wl41ckTxCLUMLwR98CYFeTL2zMupDdRWC0frb44/9ZP8//Oz5DtYXsih9bUEMuq
         kDNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6vGrA0nNuCMZeyTertcq3i3Pav7G1W9MuISFp9Y13/E=;
        b=6Ca79X9fw/DUm2nd6DgU9HrkMrypt+9Mcd5+4ig5zm0SaQqxzpG9ES32k4xuLdIkbR
         ZPu85Tk39aU5uAleSEmi2vJhkNRpfyZOdAN3+mbcMzvh0D+XlFYRQipIqiIOLcpzTpEZ
         S0VXsT0/m8cebtT6247W1f/u58pw5wCK6YOF0hUP2QowpztXS/fM3bvR7xXE8Su2wacd
         VrnBSV23sjMTFEY6s89UREV6UON6rskAU76/FqBwFz2hD0ATKPOpUEo+lbeKOYCVBhkI
         aQI7CmzDgx0OoYLM3N1aL7NRmIetH2cegm3pcY+cIfiZXwoOiPKCQjlmKN7rckkZwoBy
         LEBQ==
X-Gm-Message-State: AJIora8E0WOM0Jab4d7+TfSwdub0fRtwXmGVYUArniIZapIYZj+HT2aE
        kKJyEr2Cwo/6qiohuc+ziU4=
X-Google-Smtp-Source: AGRyM1sejFx2dIvgh7pJ2wm4ypgEIBeC/PBjq+5YRwLWBGz/qmyT4pWgbajntb6KxSE9TgNo7OVv8A==
X-Received: by 2002:a05:6402:1546:b0:43b:bc2a:36ad with SMTP id p6-20020a056402154600b0043bbc2a36admr203308edx.330.1658436688135;
        Thu, 21 Jul 2022 13:51:28 -0700 (PDT)
Received: from krava ([83.240.60.135])
        by smtp.gmail.com with ESMTPSA id n2-20020a056402060200b0043a87e6196esm1576295edv.6.2022.07.21.13.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 13:51:27 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 21 Jul 2022 22:51:24 +0200
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 02/13] tools/resolve_btfids: Add support for
 8-byte BTF sets
Message-ID: <Ytm8TCggRg6xJe/q@krava>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-3-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721134245.2450-3-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 03:42:34PM +0200, Kumar Kartikeya Dwivedi wrote:
> A flag is a 4-byte symbol that may follow a BTF ID in a set8. This is
> used in the kernel to tag kfuncs in BTF sets with certain flags. Add
> support to adjust the sorting code so that it passes size as 8 bytes
> for 8-byte BTF sets.
> 
> Cc: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> ---
>  tools/bpf/resolve_btfids/main.c | 40 ++++++++++++++++++++++++++++-----
>  1 file changed, 34 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 5d26f3c6f918..80cd7843c677 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -45,6 +45,19 @@
>   *             .zero 4
>   *             __BTF_ID__func__vfs_fallocate__4:
>   *             .zero 4
> + *
> + *   set8    - store symbol size into first 4 bytes and sort following
> + *             ID list
> + *
> + *             __BTF_ID__set8__list:
> + *             .zero 8
> + *             list:
> + *             __BTF_ID__func__vfs_getattr__3:
> + *             .zero 4
> + *	       .word (1 << 0) | (1 << 2)
> + *             __BTF_ID__func__vfs_fallocate__5:
> + *             .zero 4
> + *	       .word (1 << 3) | (1 << 1) | (1 << 2)
>   */
>  
>  #define  _GNU_SOURCE
> @@ -72,6 +85,7 @@
>  #define BTF_TYPEDEF	"typedef"
>  #define BTF_FUNC	"func"
>  #define BTF_SET		"set"
> +#define BTF_SET8	"set8"
>  
>  #define ADDR_CNT	100
>  
> @@ -84,6 +98,7 @@ struct btf_id {
>  	};
>  	int		 addr_cnt;
>  	bool		 is_set;
> +	bool		 is_set8;
>  	Elf64_Addr	 addr[ADDR_CNT];
>  };
>  
> @@ -231,14 +246,14 @@ static char *get_id(const char *prefix_end)
>  	return id;
>  }
>  
> -static struct btf_id *add_set(struct object *obj, char *name)
> +static struct btf_id *add_set(struct object *obj, char *name, bool is_set8)
>  {
>  	/*
>  	 * __BTF_ID__set__name
>  	 * name =    ^
>  	 * id   =         ^
>  	 */
> -	char *id = name + sizeof(BTF_SET "__") - 1;
> +	char *id = name + (is_set8 ? sizeof(BTF_SET8 "__") : sizeof(BTF_SET "__")) - 1;
>  	int len = strlen(name);
>  
>  	if (id >= name + len) {
> @@ -444,9 +459,21 @@ static int symbols_collect(struct object *obj)
>  		} else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
>  			obj->nr_funcs++;
>  			id = add_symbol(&obj->funcs, prefix, sizeof(BTF_FUNC) - 1);
> +		/* set8 */
> +		} else if (!strncmp(prefix, BTF_SET8, sizeof(BTF_SET8) - 1)) {
> +			id = add_set(obj, prefix, true);
> +			/*
> +			 * SET8 objects store list's count, which is encoded
> +			 * in symbol's size, together with 'cnt' field hence
> +			 * that - 1.
> +			 */
> +			if (id) {
> +				id->cnt = sym.st_size / sizeof(uint64_t) - 1;
> +				id->is_set8 = true;
> +			}
>  		/* set */
>  		} else if (!strncmp(prefix, BTF_SET, sizeof(BTF_SET) - 1)) {
> -			id = add_set(obj, prefix);
> +			id = add_set(obj, prefix, false);
>  			/*
>  			 * SET objects store list's count, which is encoded
>  			 * in symbol's size, together with 'cnt' field hence
> @@ -571,7 +598,8 @@ static int id_patch(struct object *obj, struct btf_id *id)
>  	int *ptr = data->d_buf;
>  	int i;
>  
> -	if (!id->id && !id->is_set)
> +	/* For set, set8, id->id may be 0 */
> +	if (!id->id && !id->is_set && !id->is_set8)
>  		pr_err("WARN: resolve_btfids: unresolved symbol %s\n", id->name);
>  
>  	for (i = 0; i < id->addr_cnt; i++) {
> @@ -643,13 +671,13 @@ static int sets_patch(struct object *obj)
>  		}
>  
>  		idx = idx / sizeof(int);
> -		base = &ptr[idx] + 1;
> +		base = &ptr[idx] + (id->is_set8 ? 2 : 1);
>  		cnt = ptr[idx];
>  
>  		pr_debug("sorting  addr %5lu: cnt %6d [%s]\n",
>  			 (idx + 1) * sizeof(int), cnt, id->name);
>  
> -		qsort(base, cnt, sizeof(int), cmp_id);
> +		qsort(base, cnt, id->is_set8 ? sizeof(uint64_t) : sizeof(int), cmp_id);
>  
>  		next = rb_next(next);
>  	}
> -- 
> 2.34.1
> 
