Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845F42AEE94
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbgKKKNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:13:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbgKKKNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 05:13:23 -0500
Received: from linux-8ccs (p57a236d4.dip0.t-ipconnect.de [87.162.54.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B33920759;
        Wed, 11 Nov 2020 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605089602;
        bh=xxLTRoJd+SPxyQexcJlzZu0LoiFHq0I4V40FKZ6INoo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsoqw4Gt+Z0PcB9erzVCdthLSJMuysR33Xo6sd8U16TU2TxIS8AKN65N3en8kZbzD
         WOG4gIg1vYYVy17PriOWMQMoiI9BTNqAbtjVqRVLdugO+fa90PIT28A9XLkxdB0VXJ
         2c+cVdtJ7cHWZi0sz8dvl7udMo5qTvLqAFO834uY=
Date:   Wed, 11 Nov 2020 11:13:17 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        linux-kernel@vger.kernel.org, rafael@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 bpf-next 4/5] bpf: load and verify kernel module BTFs
Message-ID: <20201111101316.GA5304@linux-8ccs>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-5-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201110011932.3201430-5-andrii@kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Andrii Nakryiko [09/11/20 17:19 -0800]:
[snipped]
>diff --git a/kernel/module.c b/kernel/module.c
>index a4fa44a652a7..f2996b02ab2e 100644
>--- a/kernel/module.c
>+++ b/kernel/module.c
>@@ -380,6 +380,35 @@ static void *section_objs(const struct load_info *info,
> 	return (void *)info->sechdrs[sec].sh_addr;
> }
>
>+/* Find a module section: 0 means not found. Ignores SHF_ALLOC flag. */
>+static unsigned int find_any_sec(const struct load_info *info, const char *name)
>+{
>+	unsigned int i;
>+
>+	for (i = 1; i < info->hdr->e_shnum; i++) {
>+		Elf_Shdr *shdr = &info->sechdrs[i];
>+		if (strcmp(info->secstrings + shdr->sh_name, name) == 0)
>+			return i;
>+	}
>+	return 0;
>+}
>+
>+/*
>+ * Find a module section, or NULL. Fill in number of "objects" in section.
>+ * Ignores SHF_ALLOC flag.
>+ */
>+static __maybe_unused void *any_section_objs(const struct load_info *info,
>+					     const char *name,
>+					     size_t object_size,
>+					     unsigned int *num)
>+{
>+	unsigned int sec = find_any_sec(info, name);
>+
>+	/* Section 0 has sh_addr 0 and sh_size 0. */
>+	*num = info->sechdrs[sec].sh_size / object_size;
>+	return (void *)info->sechdrs[sec].sh_addr;
>+}
>+

Hm, I see this patchset has already been applied to bpf-next, but I
guess that doesn't preclude any follow-up patches :-)

I am not a huge fan of the code duplication here, and also the fact
that they're only called in one place. any_section_objs() and
find_any_sec() are pretty much identical to section_objs() and
find_sec(), other than the fact the former drops the SHF_ALLOC check.

Moreover, since it appears that the ".BTF" section is not marked
SHF_ALLOC, I think this will leave mod->btf_data as a dangling pointer
after the module is done loading and the module's load_info has been
deallocated, since SHF_ALLOC sections are not allocated nor copied to
the module's final location in memory.

Why not simply mark the ".BTF" section in the module SHF_ALLOC? We
already do some sh_flags rewriting in rewrite_section_headers(). Then
the module loader knows to keep the section in memory and you can use
section_objs(). And since the .BTF section stays in module memory,
that might save you the memcpy() to btf->data in btf_parse_module()
(unless that is still needed for some reason).

Thanks,

Jessica

> /* Provided by the linker */
> extern const struct kernel_symbol __start___ksymtab[];
> extern const struct kernel_symbol __stop___ksymtab[];
>@@ -3250,6 +3279,9 @@ static int find_module_sections(struct module *mod, struct load_info *info)
> 					   sizeof(*mod->bpf_raw_events),
> 					   &mod->num_bpf_raw_events);
> #endif
>+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
>+	mod->btf_data = any_section_objs(info, ".BTF", 1, &mod->btf_data_size);
>+#endif
> #ifdef CONFIG_JUMP_LABEL
> 	mod->jump_entries = section_objs(info, "__jump_table",
> 					sizeof(*mod->jump_entries),
>-- 
>2.24.1
>
