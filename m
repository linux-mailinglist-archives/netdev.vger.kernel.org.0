Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7051219F2
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 20:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfLPT3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 14:29:42 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:33940 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLPT3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 14:29:41 -0500
Received: by mail-qv1-f68.google.com with SMTP id o18so3207951qvf.1;
        Mon, 16 Dec 2019 11:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOHezvRSZ+7ZRTUa8QvzcFLSHoQVoZDvxUThESxsDzc=;
        b=GxonX0UyfzeW4WCXF1IldjtjlX7BivLydmV/pxU4To6LJcCHhxYf/BDSpMeB+WyAL0
         mYm76XvX9vCYyuHLDaCisLfYjO5L4x5pITWCz8OKprqSl8SgTmg+XegkhcceWBi1nMSY
         R4XYWvFS2i4T7dBYHSxOzy3FlG5a0ro0aLXSV2N7j28MzHqNEBVaRksoAzcsi4TK4Eaj
         MwJImh6Apxxk9hgZCajzaka2/jR4F+easTrORTOIFLOvqh7mhVPhNKVS50lHUYWmp7yC
         LhLROv4Ow4gGKV+DXXh+nr+9y5eeevw9S3yNbb8Q12uqhvBxDk6ln34uxVJ2g+06Xqw3
         0Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOHezvRSZ+7ZRTUa8QvzcFLSHoQVoZDvxUThESxsDzc=;
        b=k5a4m9TQbBbVtUN2vxiR2C3+0RXloeCTYuWUjw+bJlor/ukrLcMGjCj+v8eCx0JBjc
         OT2IaJ8nSlxMujes5a4QtM8SSS4CTWF/scSZ8231abpVd01LKU+yDUQvn/dVjik6LMFv
         3oIOPu+UAtTSEXbFu/EeVbGt/1G+pOXE39NNOt3kJrvIrXoJ7z4jnyLdjmQlv+p0DTBo
         vTmObY/zsDWE6LjyRSl8rsg9mswOWkUTO1Amys2+xQ/oEcNnXZ07u8pfDL0RwN61BNC2
         iZPN8V4XUXDAPpSFogDUCFE/PMOKfh8lCfS+/k4ECVJTL68G7OE7ku/Gd39ZBrvea4/l
         NhWQ==
X-Gm-Message-State: APjAAAU8HQ7wueHk+S2rpwIRcemnEp+6aseloHBU2axCMTTrWUSlluog
        VythYFCeuZQDAC2vVI97l8uTjxQx9bNoOf2tsLnhWQ==
X-Google-Smtp-Source: APXvYqxrmMp63f1O8Kplrw9Jdv721WVo3w/gUEtg3lyOfPB0xFyOr6clGQ2jShj+VpRceOfryDeoKkte6Okqbls+QMA=
X-Received: by 2002:ad4:514e:: with SMTP id g14mr989113qvq.196.1576524580338;
 Mon, 16 Dec 2019 11:29:40 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box>
In-Reply-To: <20191216111736.GA14887@linux.fritz.box>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Dec 2019 11:29:29 -0800
Message-ID: <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 3:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Fri, Dec 13, 2019 at 05:47:08PM -0800, Andrii Nakryiko wrote:
> > Add support for extern variables, provided to BPF program by libbpf. Currently
> > the following extern variables are supported:
> >   - LINUX_KERNEL_VERSION; version of a kernel in which BPF program is
> >     executing, follows KERNEL_VERSION() macro convention, can be 4- and 8-byte
> >     long;
> >   - CONFIG_xxx values; a set of values of actual kernel config. Tristate,
> >     boolean, strings, and integer values are supported.
> >
> [...]
> >
> > All detected extern variables, are put into a separate .extern internal map.
> > It, similarly to .rodata map, is marked as read-only from BPF program side, as
> > well as is frozen on load. This allows BPF verifier to track extern values as
> > constants and perform enhanced branch prediction and dead code elimination.
> > This can be relied upon for doing kernel version/feature detection and using
> > potentially unsupported field relocations or BPF helpers in a CO-RE-based BPF
> > program, while still having a single version of BPF program running on old and
> > new kernels. Selftests are validating this explicitly for unexisting BPF
> > helper.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> [...]
> > +static int bpf_object__resolve_externs(struct bpf_object *obj,
> > +                                    const char *config_path)
> > +{
> > +     bool need_config = false;
> > +     struct extern_desc *ext;
> > +     int err, i;
> > +     void *data;
> > +
> > +     if (obj->nr_extern == 0)
> > +             return 0;
> > +
> > +     data = obj->maps[obj->extern_map_idx].mmaped;
> > +
> > +     for (i = 0; i < obj->nr_extern; i++) {
> > +             ext = &obj->externs[i];
> > +
> > +             if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
> > +                     void *ext_val = data + ext->data_off;
> > +                     __u32 kver = get_kernel_version();
> > +
> > +                     if (!kver) {
> > +                             pr_warn("failed to get kernel version\n");
> > +                             return -EINVAL;
> > +                     }
> > +                     err = set_ext_value_num(ext, ext_val, kver);
> > +                     if (err)
> > +                             return err;
> > +                     pr_debug("extern %s=0x%x\n", ext->name, kver);
> > +             } else if (strncmp(ext->name, "CONFIG_", 7) == 0) {
> > +                     need_config = true;
> > +             } else {
> > +                     pr_warn("unrecognized extern '%s'\n", ext->name);
> > +                     return -EINVAL;
> > +             }
>
> I don't quite like that this is (mainly) tracing-only specific, and that
> for everything else we just bail out - there is much more potential than
> just completing above vars. But also, there is also no way to opt-out
> for application developers of /this specific/ semi-magic auto-completion
> of externs.

What makes you think it's tracing only? While non-tracing apps
probably don't need to care about LINUX_KERNEL_VERSION, all of the
CONFIG_ stuff is useful and usable for any type of application.

As for opt-out, you can easily opt out by not using extern variables.

>
> bpf_object__resolve_externs() should be changed instead to invoke a
> callback obj->resolve_externs(). Former can be passed by the application
> developer to allow them to take care of extern resolution all by themself,
> and if no callback has been passed, then we default to the one above
> being set as obj->resolve_externs.

Can you elaborate on the use case you have in mind? The way I always
imagined BPF applications provide custom read-only parameters to BPF
side is through using .rodata variables. With skeleton it's super easy
to initialize them before BPF program is loaded, and their values will
be well-known by verifier and potentially optimized.

E.g., with skeleton, it becomes trivial. E.g., on BPF side:


const volatile int custom_ipv4;
const volatile bool feature_X_enabled;

...

if (custom_ipv4 && in_ipv4 != custom_ipv4)
  return 0;

if (feature_X_enabled) {
  /* do something fancy */
}

Then on userspace side:

/* instantiate skeleton */
skel = my_prog__open();

skel->rodata->custom_ipv4 = IP_AS_INT(1, 2, 3, 4);
if (/* should enable feature X*/)
    skel->rodata->feature_X_enabled = true;

my_prog__load(); /* load, verify, eliminate dead code and optimize */

So for application-specific stuff, there isn't really a need to use
externs to do that. Furthermore, I think allowing using externs as
just another way to specify application-specific configuration is
going to create a problem, potentially, as we'll have higher
probability of collisions with kernel-provided extersn (variables
and/or functions), or even externs provided by other
dynamically/statically linked BPF programs (once we have dynamic and
static linking, of course).

So if you still insist we need user to provide custom extern-parsing
logic, can you please elaborate on the use case details?

BTW, from discussion w/ Alexei on another thread, I think I'm going to
change kconfig_path option to just `kconfig`, which will specify
additional config in Kconfig format. This could be used by
applications to provide their own config, augmenting Kconfig with
custom overrides.


>
> > +     }
> > +     if (need_config) {
> > +             err = bpf_object__read_kernel_config(obj, config_path, data);
> > +             if (err)
> > +                     return -EINVAL;
> > +     }
> > +     for (i = 0; i < obj->nr_extern; i++) {
> > +             ext = &obj->externs[i];
> > +
> > +             if (!ext->is_set && !ext->is_weak) {
> > +                     pr_warn("extern %s (strong) not resolved\n", ext->name);
> > +                     return -ESRCH;
> > +             } else if (!ext->is_set) {
> > +                     pr_debug("extern %s (weak) not resolved, defaulting to zero\n",
> > +                              ext->name);
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
> >  {
> >       struct bpf_object *obj;
> > @@ -4126,6 +4753,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
> >       obj->loaded = true;
> >
> >       err = bpf_object__probe_caps(obj);
> > +     err = err ? : bpf_object__resolve_externs(obj, obj->kconfig_path);
> >       err = err ? : bpf_object__sanitize_and_load_btf(obj);
> >       err = err ? : bpf_object__sanitize_maps(obj);
> >       err = err ? : bpf_object__create_maps(obj);
> [...]
