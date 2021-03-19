Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D73421C4
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 17:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhCSQYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 12:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhCSQXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 12:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616171034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0B2lPoIWqRcxgr3pCkYAed34OrFsvDuJZDTRNIrlT8=;
        b=GqJ9hvdVpgvjdvb59N6uIXhyxKFuyxWwNqYryny+Hw7v0EKbwYyjhxru5K5rz0z0tAAGtW
        HVPH46OczXIL6L8FkeaJxh1n/l1WdQhkC6mC4xkpNaeCoYtx8igNv9tl6sOufkQzNqpkKG
        k+Z3Oy9Dm9hMEMoChiU79N1MTi3Kzao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-O7oqWtGiNWqXORvGPeJMdw-1; Fri, 19 Mar 2021 12:23:50 -0400
X-MC-Unique: O7oqWtGiNWqXORvGPeJMdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BA82107B7C3;
        Fri, 19 Mar 2021 16:23:49 +0000 (UTC)
Received: from krava (unknown [10.40.195.94])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2B34E19C79;
        Fri, 19 Mar 2021 16:23:48 +0000 (UTC)
Date:   Fri, 19 Mar 2021 17:23:47 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH v4 bpf-next 07/12] libbpf: add BPF static linker BTF and
 BTF.ext support
Message-ID: <YFTQExmhNhMcmNOb@krava>
References: <20210318194036.3521577-1-andrii@kernel.org>
 <20210318194036.3521577-8-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318194036.3521577-8-andrii@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 12:40:31PM -0700, Andrii Nakryiko wrote:

SNIP

> +
> +	return NULL;
> +}
> +
> +static int linker_fixup_btf(struct src_obj *obj)
> +{
> +	const char *sec_name;
> +	struct src_sec *sec;
> +	int i, j, n, m;
> +
> +	n = btf__get_nr_types(obj->btf);

hi,
I'm getting bpftool crash when building tests,

looks like above obj->btf can be NULL:

	(gdb) r gen object /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.linked1.o /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o
	Starting program: /home/jolsa/linux/tools/testing/selftests/bpf/tools/sbin/bpftool gen object /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.linked1.o /home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o

	Program received signal SIGSEGV, Segmentation fault.
	btf__get_nr_types (btf=0x0) at btf.c:425

	425             return btf->start_id + btf->nr_types - 1;
	Missing separate debuginfos, use: dnf debuginfo-install elfutils-libelf-0.182-1.fc33.x86_64 libcap-2.48-2.fc33.x86_64 zlib-1.2.11-23.fc33.x86_64
	(gdb) 
	(gdb) bt
	#0  btf__get_nr_types (btf=0x0) at btf.c:425
	#1  0x000000000043c4ba in linker_fixup_btf (obj=obj@entry=0x7fffffffda50) at linker.c:1316
	#2  0x000000000043caf7 in linker_load_obj_file (linker=linker@entry=0x8612a0, filename=filename@entry=0x7fffffffe0db "/home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o", 
	    obj=obj@entry=0x7fffffffda50) at linker.c:653
	#3  0x000000000043df43 in bpf_linker__add_file (linker=linker@entry=0x8612a0, filename=filename@entry=0x7fffffffe0db "/home/jolsa/linux/tools/testing/selftests/bpf/btf_data2.o") at linker.c:412
	#4  0x000000000040d710 in do_object (argc=0, argv=0x7fffffffdce0) at gen.c:639
	#5  0x000000000040efd7 in cmd_select (cmds=cmds@entry=0x50a600 <cmds>, argc=3, argv=0x7fffffffdcc8, help=help@entry=0x40c6f7 <do_help>) at main.c:134
	#6  0x000000000040d7c4 in do_gen (argc=<optimized out>, argv=<optimized out>) at gen.c:686
	#7  0x000000000040efd7 in cmd_select (cmds=cmds@entry=0x50b400 <cmds>, argc=4, argv=0x7fffffffdcc0, help=help@entry=0x40ee93 <do_help>) at main.c:134
	#8  0x000000000040f88e in main (argc=<optimized out>, argv=<optimized out>) at main.c:469

I'm on current bpf-next/master


jirka


> +	for (i = 1; i <= n; i++) {
> +		struct btf_var_secinfo *vi;
> +		struct btf_type *t;
> +
> +		t = btf_type_by_id(obj->btf, i);
> +		if (btf_kind(t) != BTF_KIND_DATASEC)
> +			continue;
> +
> +		sec_name = btf__str_by_offset(obj->btf, t->name_off);
> +		sec = find_src_sec_by_name(obj, sec_name);
> +		if (sec) {
> +			/* record actual section size, unless ephemeral */
> +			if (sec->shdr)
> +				t->size = sec->shdr->sh_size;
> +		} else {
> +			/* BTF can have some sections that are not represented
> +			 * in ELF, e.g., .kconfig and .ksyms, which are used
> +			 * for special extern variables.  Here we'll
> +			 * pre-create "section shells" for them to be able to
> +			 * keep track of extra per-section metadata later
> +			 * (e.g., BTF variables).
> +			 */
> +			sec = add_src_sec(obj, sec_name);
> +			if (!sec)
> +				return -ENOMEM;
> +
> +			sec->ephemeral = true;
> +			sec->sec_idx = 0; /* will match UNDEF shndx in ELF */
> +		}
> +
> +		/* remember ELF section and its BTF type ID match */
> +		sec->sec_type_id = i;
> +
> +		/* fix up variable offsets */
> +		vi = btf_var_secinfos(t);
> +		for (j = 0, m = btf_vlen(t); j < m; j++, vi++) {
> +			const struct btf_type *vt = btf__type_by_id(obj->btf, vi->type);
> +			const char *var_name = btf__str_by_offset(obj->btf, vt->name_off);
> +			int var_linkage = btf_var(vt)->linkage;
> +			Elf64_Sym *sym;
> +
> +			/* no need to patch up static or extern vars */
> +			if (var_linkage != BTF_VAR_GLOBAL_ALLOCATED)
> +				continue;
> +
> +			sym = find_sym_by_name(obj, sec->sec_idx, STT_OBJECT, var_name);
> +			if (!sym) {
> +				pr_warn("failed to find symbol for variable '%s' in section '%s'\n", var_name, sec_name);
> +				return -ENOENT;
> +			}
> +
> +			vi->offset = sym->st_value;
> +		}
> +	}
> +
> +	return 0;
> +}

SNIP

