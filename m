Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7A62133D1
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 08:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgGCGCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 02:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCGCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 02:02:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E82F220771;
        Fri,  3 Jul 2020 06:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593756130;
        bh=HIbJqRSFMbUgRkZxtvG3aCNp0wd5skVeN76Mqr6ZKlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ks5iQI9moJ0UD4VvJm9ozWnH28lwPOVOnLsnopJbPFPBQsEaiok8uVnUYwa7UR9Em
         zT/zdo82iWrWjIV6wKofQC1UNdIGd6arNQdcSpV/VEzGzCyBuTWsW+bcVIydzXWYF+
         qweWZjyKubece8hBub0Wh9BvVjYTG8pxDay2iy7Q=
Date:   Fri, 3 Jul 2020 08:02:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Dominik Czarnota <dominik.czarnota@trailofbits.com>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] module: Refactor section attr into bin attribute
Message-ID: <20200703060207.GA6344@kroah.com>
References: <20200702232638.2946421-1-keescook@chromium.org>
 <20200702232638.2946421-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702232638.2946421-3-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 04:26:35PM -0700, Kees Cook wrote:
> In order to gain access to the open file's f_cred for kallsym visibility
> permission checks, refactor the module section attributes to use the
> bin_attribute instead of attribute interface. Additionally removes the
> redundant "name" struct member.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/module.c | 45 ++++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index a5022ae84e50..9e2954519259 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1510,8 +1510,7 @@ static inline bool sect_empty(const Elf_Shdr *sect)
>  }
>  
>  struct module_sect_attr {
> -	struct module_attribute mattr;
> -	char *name;
> +	struct bin_attribute battr;
>  	unsigned long address;
>  };
>  
> @@ -1521,11 +1520,16 @@ struct module_sect_attrs {
>  	struct module_sect_attr attrs[];
>  };
>  
> -static ssize_t module_sect_show(struct module_attribute *mattr,
> -				struct module_kobject *mk, char *buf)
> +static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
> +				struct bin_attribute *battr,
> +				char *buf, loff_t pos, size_t count)
>  {
>  	struct module_sect_attr *sattr =
> -		container_of(mattr, struct module_sect_attr, mattr);
> +		container_of(battr, struct module_sect_attr, battr);
> +
> +	if (pos != 0)
> +		return -EINVAL;
> +
>  	return sprintf(buf, "0x%px\n", kptr_restrict < 2 ?
>  		       (void *)sattr->address : NULL);
>  }
> @@ -1535,7 +1539,7 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
>  	unsigned int section;
>  
>  	for (section = 0; section < sect_attrs->nsections; section++)
> -		kfree(sect_attrs->attrs[section].name);
> +		kfree(sect_attrs->attrs[section].battr.attr.name);
>  	kfree(sect_attrs);
>  }
>  
> @@ -1544,42 +1548,41 @@ static void add_sect_attrs(struct module *mod, const struct load_info *info)
>  	unsigned int nloaded = 0, i, size[2];
>  	struct module_sect_attrs *sect_attrs;
>  	struct module_sect_attr *sattr;
> -	struct attribute **gattr;
> +	struct bin_attribute **gattr;
>  
>  	/* Count loaded sections and allocate structures */
>  	for (i = 0; i < info->hdr->e_shnum; i++)
>  		if (!sect_empty(&info->sechdrs[i]))
>  			nloaded++;
>  	size[0] = ALIGN(struct_size(sect_attrs, attrs, nloaded),
> -			sizeof(sect_attrs->grp.attrs[0]));
> -	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
> +			sizeof(sect_attrs->grp.bin_attrs[0]));
> +	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.bin_attrs[0]);
>  	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);
>  	if (sect_attrs == NULL)
>  		return;
>  
>  	/* Setup section attributes. */
>  	sect_attrs->grp.name = "sections";
> -	sect_attrs->grp.attrs = (void *)sect_attrs + size[0];
> +	sect_attrs->grp.bin_attrs = (void *)sect_attrs + size[0];
>  
>  	sect_attrs->nsections = 0;
>  	sattr = &sect_attrs->attrs[0];
> -	gattr = &sect_attrs->grp.attrs[0];
> +	gattr = &sect_attrs->grp.bin_attrs[0];
>  	for (i = 0; i < info->hdr->e_shnum; i++) {
>  		Elf_Shdr *sec = &info->sechdrs[i];
>  		if (sect_empty(sec))
>  			continue;
> +		sysfs_bin_attr_init(&sattr->battr);
>  		sattr->address = sec->sh_addr;
> -		sattr->name = kstrdup(info->secstrings + sec->sh_name,
> -					GFP_KERNEL);
> -		if (sattr->name == NULL)
> +		sattr->battr.attr.name =
> +			kstrdup(info->secstrings + sec->sh_name, GFP_KERNEL);
> +		if (sattr->battr.attr.name == NULL)
>  			goto out;
>  		sect_attrs->nsections++;
> -		sysfs_attr_init(&sattr->mattr.attr);
> -		sattr->mattr.show = module_sect_show;
> -		sattr->mattr.store = NULL;
> -		sattr->mattr.attr.name = sattr->name;
> -		sattr->mattr.attr.mode = S_IRUSR;
> -		*(gattr++) = &(sattr++)->mattr.attr;
> +		sattr->battr.read = module_sect_read;
> +		sattr->battr.size = 3 /* "0x", "\n" */ + (BITS_PER_LONG / 4);
> +		sattr->battr.attr.mode = 0400;
> +		*(gattr++) = &(sattr++)->battr;
>  	}
>  	*gattr = NULL;
>  
> @@ -1669,7 +1672,7 @@ static void add_notes_attrs(struct module *mod, const struct load_info *info)
>  			continue;
>  		if (info->sechdrs[i].sh_type == SHT_NOTE) {
>  			sysfs_bin_attr_init(nattr);
> -			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
> +			nattr->attr.name = mod->sect_attrs->attrs[loaded].battr.attr.name;
>  			nattr->attr.mode = S_IRUGO;
>  			nattr->size = info->sechdrs[i].sh_size;
>  			nattr->private = (void *) info->sechdrs[i].sh_addr;
> -- 
> 2.25.1
> 

They get a correct "size" value now, nice!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
