Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356FEC4AD0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 11:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfJBJvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 05:51:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:51898 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJBJvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 05:51:44 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFbII-0003CR-Mo; Wed, 02 Oct 2019 11:51:38 +0200
Date:   Wed, 2 Oct 2019 11:51:38 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Message-ID: <20191002095138.GB6226@pc-66.home>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <20191001224535.GB10044@pc-63.home>
 <CAEf4BzZQ=NNK42yOu7_H+yuqZ_1npBxDaTuQwsrmJoQUiMfd7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZQ=NNK42yOu7_H+yuqZ_1npBxDaTuQwsrmJoQUiMfd7A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25590/Wed Oct  2 10:31:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 04:31:27PM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 1, 2019 at 3:45 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Mon, Sep 30, 2019 at 11:58:51AM -0700, Andrii Nakryiko wrote:
> > > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > > are installed along the other libbpf headers.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > [...]
> > > new file mode 100644
> > > index 000000000000..fbe28008450f
> > > --- /dev/null
> > > +++ b/tools/lib/bpf/bpf_endian.h
> > > @@ -0,0 +1,72 @@
> > > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > > +#ifndef __BPF_ENDIAN__
> > > +#define __BPF_ENDIAN__
> > > +
> 
> [...]
> 
> > > +#define bpf_cpu_to_be64(x)                   \
> > > +     (__builtin_constant_p(x) ?              \
> > > +      __bpf_constant_cpu_to_be64(x) : __bpf_cpu_to_be64(x))
> > > +#define bpf_be64_to_cpu(x)                   \
> > > +     (__builtin_constant_p(x) ?              \
> > > +      __bpf_constant_be64_to_cpu(x) : __bpf_be64_to_cpu(x))
> >
> > Nit: if we move this into a public API for libbpf, we should probably
> > also define for sake of consistency a bpf_cpu_to_be{64,32,16}() and
> > bpf_be{64,32,16}_to_cpu() and have the latter two point to the existing
> > bpf_hton{l,s}() and bpf_ntoh{l,s}() macros.
> 
> I think these deserve better tests before we add more stuff, both from
> BPF-side and userland-side (as they are supposed to be includeable
> from both, right)? I'm hesitant adding new unfamiliar macro/builtins
> without tests, but I don't want to get distracted with that right now,
> especially this patch set already becomes bigger than I'd hope.
> 
> Given we are talking about adding new stuff which is not breaking
> change, we can add it later after we move this as is, agree?

Sure, we can add it later, I only meant to say adding things like
define bpf_cpu_to_be32 pointing to bpf_htonl and so on, so no new
extra helpers, but just to make it more consistent API wise and
from usability side.

> > > +#endif /* __BPF_ENDIAN__ */
> >
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > > new file mode 100644
> > > index 000000000000..a1d9b97b8e15
> > > --- /dev/null
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -0,0 +1,527 @@
> > > +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> > > +#ifndef __BPF_HELPERS__
> > > +#define __BPF_HELPERS__
> > > +
> > > +#define __uint(name, val) int (*name)[val]
> > > +#define __type(name, val) val *name
> > > +
> > > +/* helper macro to print out debug messages */
> > > +#define bpf_printk(fmt, ...)                         \
> > > +({                                                   \
> > > +     char ____fmt[] = fmt;                           \
> > > +     bpf_trace_printk(____fmt, sizeof(____fmt),      \
> > > +                      ##__VA_ARGS__);                \
> > > +})
> >
> > Did you double check if by now via .rodata we can have the fmt as
> > const char * and add __attribute__ ((format (printf, 1, 2))) to it?
> > If that works we should avoid having to copy the string as above in
> > the API.
> 
> This doesn't work still, unfortunately. Eventually, though, we'll be
> able to essentially nop it out with direct call to bpf_trace_printk,
> so I'm not concerned about future API burden.
> 
> > > +/* helper macro to place programs, maps, license in
> > > + * different sections in elf_bpf file. Section names
> > > + * are interpreted by elf_bpf loader
> > > + */
> > > +#define SEC(NAME) __attribute__((section(NAME), used))
> > > +
> > > +/* helper functions called from eBPF programs written in C */
> >
> > As mentioned earlier, the whole helper function description below
> > should get a big cleanup in here when moved into libbpf API.
> 
> Right, I just recalled that today, sorry I didn't do it for this version.
> 
> There were two things you mentioned on that thread that you wanted to clean up:
> 1. using __u32 instead int and stuff like that
> 2. using macro to hide some of the ugliness of (void *) = BPF_FUNC_xxx
> 
> So with 1) I'm concerned that we can't just assume that __u32 is
> always going to be defined. Also we need bpf_helpers.h to be usable
> both with including system headers, as well as auto-generated
> vmlinux.h. In first case, I don't think we can assume that typedef is
> always defined, in latter case we can't really define it on our own.
> So I think we should just keep it as int, unsigned long long, etc.
> Thoughts?

Long time ago in Cilium I tried to clean up the mess a bit [0] for most
of the helpers we're using. I was using types from stdint.h actually,
haven't heard of any issues so far.

The __u* types which you mentioned is shipped in linux/types.h, these
are typically used in uapi headers like linux/bpf.h and match kernel
side u* counterpart, so they should generally be available as well as
an alternative.

  [0] https://github.com/cilium/cilium/blob/master/bpf/include/bpf/api.h

> For 2), I'm doing that right now, but it's not that much cleaner, let's see.
> 
> Am I missing something else?
> 
> > > +static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> > > +     (void *) BPF_FUNC_map_lookup_elem;
> > > +static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
> > > +                               unsigned long long flags) =
> > [...]
> > > +
> > > +/* llvm builtin functions that eBPF C program may use to
> > > + * emit BPF_LD_ABS and BPF_LD_IND instructions
> > > + */
> > > +struct sk_buff;
> > > +unsigned long long load_byte(void *skb,
> > > +                          unsigned long long off) asm("llvm.bpf.load.byte");
> > > +unsigned long long load_half(void *skb,
> > > +                          unsigned long long off) asm("llvm.bpf.load.half");
> > > +unsigned long long load_word(void *skb,
> > > +                          unsigned long long off) asm("llvm.bpf.load.word");
> >
> > These should be removed from the public API, no point in adding legacy/
> > deprecated stuff in there.
> 
> Oh, cool, never knew what that stuff is anyway :)
> 
> > > +/* a helper structure used by eBPF C program
> > > + * to describe map attributes to elf_bpf loader
> > > + */
> > > +struct bpf_map_def {
> > > +     unsigned int type;
> > > +     unsigned int key_size;
> > > +     unsigned int value_size;
> > > +     unsigned int max_entries;
> > > +     unsigned int map_flags;
> > > +     unsigned int inner_map_idx;
> > > +     unsigned int numa_node;
> > > +};
> > > +
> > > +#define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)               \
> > > +     struct ____btf_map_##name {                             \
> > > +             type_key key;                                   \
> > > +             type_val value;                                 \
> > > +     };                                                      \
> > > +     struct ____btf_map_##name                               \
> > > +     __attribute__ ((section(".maps." #name), used))         \
> > > +             ____btf_map_##name = { }
> >
> > Same here.
> 
> We still use it in few selftests, I'll move it into selftests-only header.

Yes, all the legacy stuff we don't want exposed in libbpf as API should
be kept in samples or selftests only header until it's fully converted
one day where we can remove that temporary header entirely.

> > > +static int (*bpf_skb_load_bytes)(void *ctx, int off, void *to, int len) =
> > > +     (void *) BPF_FUNC_skb_load_bytes;
> > [...]
> >
> > Given we already move bpf_endian.h to a separate header, I'd do the
> > same for all tracing specifics as well, e.g. bpf_tracing.h.
> 
> You mean all the stuff below, right? I'll extract it into separate
> header, no problem.

Sounds good. We should probably get this more in order as well if it
becomes API. My worry is that potentially PT_REGS_* names may clash
in future, but this cleanup can be done in a second step as long as
its done in this development cycle and not officially released yet.

> What about CO-RE stuff. It's not strictly for tracing, so does it make
> sense to keep it here?

Yes, as it's core and has a use-case beyond tracing, I'd keep it here.

> > > +/* Scan the ARCH passed in from ARCH env variable (see Makefile) */
> > > +#if defined(__TARGET_ARCH_x86)
> > > +     #define bpf_target_x86
> > > +     #define bpf_target_defined
> > > +#elif defined(__TARGET_ARCH_s390)
> 
> [...]
