Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8167773D
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 08:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbfG0GZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 02:25:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46334 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfG0GZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 02:25:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id r4so40629013qkm.13;
        Fri, 26 Jul 2019 23:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJOu94qjfiAZ9L2kBdJOUILcF5P3phV9aH56/+2xTnA=;
        b=t1YjTRH1lCVXXZjfpz6Hr2Y5+wNA63/bKQAgnB5O/hfSqxYcriJCi0NeXlpmJu39TU
         XsvzUcKZYMMPxuIn9UD75CsnaSALHjxoHR+5CtQMVQXqfif0Hvtrwj8VFmDnIC2Iw4By
         SAFu42gpU9mLAoYPIhclqqCj5AkjUhx9141j7pfvMdGWWPL0jOFSNxW4rUJd4DxHXYbV
         EfnEpgMiGwGUo7Iu8OsjklCN//jdMSq/+bfonPaXImU106XGaChJLQN3LCKsm10Dg9/R
         CIQX5mbV9jAhvjNgFVhgyO8u35kB5NNMjBLinfYVcj9TlhRfzfrtsgoFu6NHZPpHN/Jf
         Qttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJOu94qjfiAZ9L2kBdJOUILcF5P3phV9aH56/+2xTnA=;
        b=tkHuk8LgCgE8zfAQRoB2iruE8sh51wKYjiZHOmlLNE8SYSZjpW2Q7KOCuwgbsUMUMN
         S7rNC1i2sNugUN5GTSznKhXrMubSqPZm06H2aSQNqUg/mx6BTFjfcTVSjzmCK1OAU6u4
         9rGlrzI4tTmyAIa/3/ZUedJdqyULwZCmGi1+uiXgSJbhDew2oiu9wNXXsqeW+gh4vKyH
         Owof2yCN4GVbIxJljk2D6m0Hqz0OwC8MG2Wd+3HVKl3GRKtd0CMvmYBMcYIEGBzGOiVF
         QNkxA1VlGHnkkOHXGKN57e4BoedU9ITfu+cjO9k1t73t4Fm5XxH/Hs7Q1tyTPVN+N6Jc
         AzoA==
X-Gm-Message-State: APjAAAWggV+JYPZrU12LrdXnJpwy0PeluXn37mKu3QwpoFM3cI7jup6e
        Y0SOcOnW88q795Tz4jHLCM5fdNBVic4BauI7eF0=
X-Google-Smtp-Source: APXvYqxg4kHfID+IINdNTgoepLtyOSPF+bA4JNrAdJk9N2BMBVFoGd0i/L+c8vGzxj6dP36/enSjs/QH2kHQQG3elns=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr65265820qkj.39.1564208747000;
 Fri, 26 Jul 2019 23:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-3-andriin@fb.com>
 <20190725231831.7v7mswluomcymy2l@ast-mbp>
In-Reply-To: <20190725231831.7v7mswluomcymy2l@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jul 2019 23:25:36 -0700
Message-ID: <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 4:18 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jul 24, 2019 at 12:27:34PM -0700, Andrii Nakryiko wrote:
> > This patch implements the core logic for BPF CO-RE offsets relocations.
> > All the details are described in code comments.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 866 ++++++++++++++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.h |   1 +
> >  2 files changed, 861 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 8741c39adb1c..86d87bf10d46 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -38,6 +38,7 @@
> >  #include <sys/stat.h>
> >  #include <sys/types.h>
> >  #include <sys/vfs.h>
> > +#include <sys/utsname.h>
> >  #include <tools/libc_compat.h>
> >  #include <libelf.h>
> >  #include <gelf.h>
> > @@ -47,6 +48,7 @@
> >  #include "btf.h"
> >  #include "str_error.h"
> >  #include "libbpf_internal.h"
> > +#include "hashmap.h"
> >
> >  #ifndef EM_BPF
> >  #define EM_BPF 247
> > @@ -1013,16 +1015,22 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
> >  }
> >
> >  static const struct btf_type *skip_mods_and_typedefs(const struct btf *btf,
> > -                                                  __u32 id)
> > +                                                  __u32 id,
> > +                                                  __u32 *res_id)
>
> I think it would be more readable to format it like:
> static const struct btf_type *
> skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)

Ok.

>
> > +     } else if (class == BPF_ST && BPF_MODE(insn->code) == BPF_MEM) {
> > +             if (insn->imm != orig_off)
> > +                     return -EINVAL;
> > +             insn->imm = new_off;
> > +             pr_debug("prog '%s': patched insn #%d (ST | MEM) imm %d -> %d\n",
> > +                      bpf_program__title(prog, false),
> > +                      insn_idx, orig_off, new_off);
>
> I'm pretty sure llvm was not capable of emitting BPF_ST insn.
> When did that change?

I just looked at possible instructions that could have 32-bit
immediate value. This is `*(rX) = offsetof(struct s, field)`, which I
though is conceivable. Do you think I should drop it?

>
> > +/*
> > + * CO-RE relocate single instruction.
> > + *
> > + * The outline and important points of the algorithm:
> > + * 1. For given local type, find corresponding candidate target types.
> > + *    Candidate type is a type with the same "essential" name, ignoring
> > + *    everything after last triple underscore (___). E.g., `sample`,
> > + *    `sample___flavor_one`, `sample___flavor_another_one`, are all candidates
> > + *    for each other. Names with triple underscore are referred to as
> > + *    "flavors" and are useful, among other things, to allow to
> > + *    specify/support incompatible variations of the same kernel struct, which
> > + *    might differ between different kernel versions and/or build
> > + *    configurations.
>
> "flavors" is a convention of bpftool btf2c converter, right?
> May be mention it here with pointer to the code?

Yes, btf2c converter generates "flavors" on type name conflict (adding
___2, ___3), but it's not the only use case. It's a general way to
have independent incompatible definitions for the same target type.
E.g., locally in your BPF program you can define two thread_structs to
accommodate field rename between kernel version changes:

struct thread_struct___before_47 {
    long fs;
};

struct thread_struct___after_47 {
    long fsbase;
};

Then with conditional relocations you'll use one of them to "extract"
it from real kernel's thread_struct:

void *fsbase;

if (LINUX_VERSION < 407)
    BPF_CORE_READ(&fsbase, sizeof(fsbase),
                  &((struct thread_struct___before_47 *)&thread)->fs);
else
    BPF_CORE_READ(&fsbase, sizeof(fsbase),
                  &((struct thread_struct___after_47 *)&thread)->fsbase);

So it works both ways (for local and target types) by design. I can
mention that btf2c converter uses this convention for types with
conflicting names, but btf2c is not a definition of what flavor is.

>
> > +     pr_debug("prog '%s': relo #%d: insn_off=%d, [%d] (%s) + %s\n",
> > +              prog_name, relo_idx, relo->insn_off,
> > +              local_id, local_name, spec_str);
> > +
> > +     err = bpf_core_spec_parse(local_btf, local_id, spec_str, &local_spec);
> > +     if (err) {
> > +             pr_warning("prog '%s': relo #%d: parsing [%d] (%s) + %s failed: %d\n",
> > +                        prog_name, relo_idx, local_id, local_name, spec_str,
> > +                        err);
> > +             return -EINVAL;
> > +     }
> > +     pr_debug("prog '%s': relo #%d: [%d] (%s) + %s is off %u, len %d, raw_len %d\n",
> > +              prog_name, relo_idx, local_id, local_name, spec_str,
> > +              local_spec.offset, local_spec.len, local_spec.raw_len);
>
> one warn and two debug that print more or less the same info seems like overkill.

Only one of them will ever be emitted, though. And this information is
and will be invaluable to debug issues/explain behavior in the future
once adoption starts. So I'm inclined to keep them, at least for now.
But I think I'll extract spec formatting into a separate reusable
function, which will make this significantly less verbose.

>
> > +     for (i = 0, j = 0; i < cand_ids->len; i++) {
> > +             cand_id = cand_ids->data[j];
> > +             cand_type = btf__type_by_id(targ_btf, cand_id);
> > +             cand_name = btf__name_by_offset(targ_btf, cand_type->name_off);
> > +
> > +             err = bpf_core_spec_match(&local_spec, targ_btf,
> > +                                       cand_id, &cand_spec);
> > +             if (err < 0) {
> > +                     pr_warning("prog '%s': relo #%d: failed to match spec [%d] (%s) + %s to candidate #%d [%d] (%s): %d\n",
> > +                                prog_name, relo_idx, local_id, local_name,
> > +                                spec_str, i, cand_id, cand_name, err);
> > +                     return err;
> > +             }
> > +             if (err == 0) {
> > +                     pr_debug("prog '%s': relo #%d: candidate #%d [%d] (%s) doesn't match spec\n",
> > +                              prog_name, relo_idx, i, cand_id, cand_name);
> > +                     continue;
> > +             }
> > +
> > +             pr_debug("prog '%s': relo #%d: candidate #%d ([%d] %s) is off %u, len %d, raw_len %d\n",
> > +                      prog_name, relo_idx, i, cand_id, cand_name,
> > +                      cand_spec.offset, cand_spec.len, cand_spec.raw_len);
>
> have the same feeling about 3 printfs above.
>

Same as above.
