Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F9920097D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgFSNE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:04:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48771 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731062AbgFSNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:04:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592571842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H6YsdkKpEnRoRC9WP0tVXaHDjzV1XLjvtqhwopcwKSc=;
        b=dZVbAHmzFqjoSDqBcBeAL97GmabEHkTkqdSvZOxyjVhi7wx7RYQh8QxozMso+Yv8K51JMe
        HUFF7yGS8Avtn/o267v+B6OCiLtLCv4dO+0H3Gp7amUdK8VSKTVw09Js9kDbuLWnuTyUIh
        J6Daym1bbGblxrJm5oeYqazH6vp0KgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-dxs724m3Nge-fDUozn2otA-1; Fri, 19 Jun 2020 09:04:00 -0400
X-MC-Unique: dxs724m3Nge-fDUozn2otA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F5788035C3;
        Fri, 19 Jun 2020 13:03:58 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id EFB8B60F89;
        Fri, 19 Jun 2020 13:03:54 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:03:54 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 01/11] bpf: Add btfid tool to resolve BTF IDs in ELF
 object
Message-ID: <20200619130354.GB2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-2-jolsa@kernel.org>
 <CAEf4BzbB0ZMfWHrhiPhv79sMVZ9L0gMj54uXKn_-+mTawPiBqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbB0ZMfWHrhiPhv79sMVZ9L0gMj54uXKn_-+mTawPiBqw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 05:38:03PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The btfid tool scans Elf object for .BTF_ids section and
> > resolves its symbols with BTF IDs.
> 
> naming is hard and subjective, I know. But given this actively
> modifies ELF file it probably should indicate this in the name. So
> something like patch_btfids or resolve_btfids would be a bit more
> accurate and for people not in the know will still trigger the
> "warning, tool can modify something" flag, if there are any problems.

resolve_btfids sounds good to me

> 
> >
> > It will be used to during linking time to resolve arrays
> > of BTF IDs used in verifier, so these IDs do not need to
> > be resolved in runtime.
> >
> > The expected layout of .BTF_ids section is described
> > in btfid.c header. Related kernel changes are coming in
> > following changes.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/btfid/Build    |  26 ++
> >  tools/bpf/btfid/Makefile |  71 +++++
> >  tools/bpf/btfid/btfid.c  | 627 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 724 insertions(+)
> >  create mode 100644 tools/bpf/btfid/Build
> >  create mode 100644 tools/bpf/btfid/Makefile
> >  create mode 100644 tools/bpf/btfid/btfid.c
> >
> 
> [...]
> 
> > diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
> > new file mode 100644
> > index 000000000000..7cdf39bfb150
> > --- /dev/null
> > +++ b/tools/bpf/btfid/btfid.c
> > @@ -0,0 +1,627 @@
> > +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> > +#define  _GNU_SOURCE
> > +
> > +/*
> > + * btfid scans Elf object for .BTF_ids section and resolves
> > + * its symbols with BTF IDs.
> > + *
> > + * Each symbol points to 4 bytes data and is expected to have
> > + * following name syntax:
> > + *
> > + * __BTF_ID__<type>__<symbol>[__<id>]
> 
> This ___<id> thingy is just disambiguation between multiple places in
> the code that could have BTF_ID macro, right? Or it has extra meaning?

it's there so you could multiple BTF_ID instances with the same
symbol name

> 
> > + *
> > + * type is:
> > + *
> > + *   func   - lookup BTF_KIND_FUNC symbol with <symbol> name
> > + *            and put its ID into its data
> > + *
> > + *             __BTF_ID__func__vfs_close__1:
> > + *             .zero 4
> > + *
> > + *   struct - lookup BTF_KIND_STRUCT symbol with <symbol> name
> > + *            and put its ID into its data
> > + *
> > + *             __BTF_ID__struct__sk_buff__1:
> > + *             .zero 4
> > + *
> > + *   sort   - put symbol size into data area and sort following
> 
> Oh, I finally got what "put symbol size" means :) It's quite unclear,
> to be honest. Also, is this size in bytes or number of IDs? Clarifying
> would be helpful (I'll probably get this from reading further down the
> code, but still..)

I 'put' ;-) the documentation mainly to kernel/bpf/btf_ids.h,

so there are 2 types of lists, first one defines
just IDs as they go:

 BTF_ID_LIST(list1)
 BTF_ID(type1, name1)
 BTF_ID(type2, name2)

and it's used for helpers btf_id array

2nd one provides count and is sorted:

 BTF_WHITELIST_ENTRY(list2)
 BTF_ID(type1, name1)
 BTF_ID(type2, name2)
 BTF_WHITELIST_END(list)

and it's used for d_path whitelist so far

SNIP

> > +               if (sym.st_shndx != obj->efile.idlist_shndx)
> > +                       continue;
> > +
> > +               name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
> > +                                 sym.st_name);
> > +
> > +               if (!is_btf_id(name))
> > +                       continue;
> > +
> > +               /*
> > +                * __BTF_ID__TYPE__vfs_truncate__0
> > +                * prefix =  ^
> > +                */
> > +               prefix = name + sizeof(BTF_ID) - 1;
> > +
> > +               if (!strncmp(prefix, BTF_STRUCT, sizeof(BTF_STRUCT) - 1)) {
> > +                       id = add_struct(obj, prefix);
> > +               } else if (!strncmp(prefix, BTF_FUNC, sizeof(BTF_FUNC) - 1)) {
> > +                       id = add_func(obj, prefix);
> > +               } else if (!strncmp(prefix, BTF_SORT, sizeof(BTF_SORT) - 1)) {
> > +                       id = add_sort(obj, prefix);
> > +
> > +                       /*
> > +                        * SORT objects store list's count, which is encoded
> > +                        * in symbol's size.
> > +                        */
> > +                       if (id)
> > +                               id->cnt = sym.st_size / sizeof(int);
> 
> doesn't sym.st_size also include extra 4 bytes for length prefix?

no, count is excluded from the size

SNIP

> > +       btf = btf__parse_elf(obj->path, NULL);
> > +       err = libbpf_get_error(btf);
> > +       if (err) {
> > +               pr_err("FAILED: load BTF from %s: %s",
> > +                       obj->path, strerror(err));
> > +               return -1;
> > +       }
> > +
> > +       nr = btf__get_nr_types(btf);
> > +
> > +       /*
> > +        * Iterate all the BTF types and search for collected symbol IDs.
> > +        */
> > +       for (type_id = 0; type_id < nr; type_id++) {
> 
> common gotcha: type_id <= nr, you can also skip type_id == 0 (always VOID)

ugh, yep.. thanks ;-)

> 
> > +               const struct btf_type *type;
> > +               struct rb_root *root = NULL;
> > +               struct btf_id *id;
> > +               const char *str;
> > +               int *nr;
> > +
> > +               type = btf__type_by_id(btf, type_id);
> > +               if (!type)
> > +                       continue;
> 
> This ought to be an error...

ok, something like "BTF malformed error"

> 
> > +
> > +               /* We support func/struct types. */
> > +               if (BTF_INFO_KIND(type->info) == BTF_KIND_FUNC && nr_funcs) {
> 
> see libbpf's btf.h: btf_is_func(type)

ok 

> 
> > +                       root = &obj->funcs;
> > +                       nr = &nr_funcs;
> > +               } else if (BTF_INFO_KIND(type->info) == BTF_KIND_STRUCT && nr_structs) {
> 
> same as above: btf_is_struct
> 
> But I think you also need to support unions?
> 
> Also what about typedefs? A lot of types are typedefs to struct/func_proto/etc.

I added only types which are needed at the moment, but maybe
we can add the basic types now, so we don't need to bother later,
when we forget how this all work ;-)

> 
> > +                       root = &obj->structs;
> > +                       nr = &nr_structs;
> > +               } else {
> > +                       continue;
> > +               }
> > +
> > +               str = btf__name_by_offset(btf, type->name_off);
> > +               if (!str)
> > +                       continue;
> 
> error, shouldn't happen

ok

> 
> > +
> > +               id = btf_id__find(root, str);
> > +               if (id) {
> 
> isn't it an error, if not found?

no, at this point we are checking if this BTF type was collected
as a symbol for struct/func in some list.. if not, we continue the
iteration to next BTF type

> 
> > +                       id->id = type_id;
> > +                       (*nr)--;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> 
> [...]
> 
> > +
> > +       /*
> > +        * We do proper cleanup and file close
> > +        * intentionally only on success.
> > +        */
> > +       if (elf_collect(&obj))
> > +               return -1;
> > +
> > +       if (symbols_collect(&obj))
> > +               return -1;
> > +
> > +       if (symbols_resolve(&obj))
> > +               return -1;
> > +
> > +       if (symbols_patch(&obj))
> > +               return -1;
> 
> nit: should these elf_end/close properly on error?

I wrote in the comment above that I intentionaly do not cleanup
on error path.. I wanted to save some time, but actualy I think
that would not be so expensive, I can add it

thanks,
jirka

> 
> 
> > +
> > +       elf_end(obj.efile.elf);
> > +       close(obj.efile.fd);
> > +       return 0;
> > +}
> > --
> > 2.25.4
> >
> 

