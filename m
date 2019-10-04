Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75D6CC48A
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfJDVGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:06:23 -0400
Received: from www62.your-server.de ([213.133.104.62]:34270 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbfJDVGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:06:23 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iGUmD-0006Rq-VX; Fri, 04 Oct 2019 23:06:14 +0200
Date:   Fri, 4 Oct 2019 23:06:13 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH v3 bpf-next 5/7] libbpf: move
 bpf_{helpers,endian,tracing}.h into libbpf
Message-ID: <20191004210613.GA27307@pc-66.home>
References: <20191003212856.1222735-1-andriin@fb.com>
 <20191003212856.1222735-6-andriin@fb.com>
 <da73636f-7d81-1fe0-65af-aa32f7654c57@gmail.com>
 <CAEf4BzYRJ4i05prEJF_aCQK5jnmpSUqrwTXYsj4FDahCWcNQdQ@mail.gmail.com>
 <4fcbe7bf-201a-727a-a6f1-2088aea82a33@gmail.com>
 <CAEf4BzZr9cxt=JrGYPUhDTRfbBocM18tFFaP+LiJSCF-g4hs2w@mail.gmail.com>
 <20191004113026.4c23cd41@cakuba.hsd1.ca.comcast.net>
 <CAEf4Bzbw-=NSKMYpDcTY1Pw9NfeRJ5+KpScWg4wHfoDG18dKPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbw-=NSKMYpDcTY1Pw9NfeRJ5+KpScWg4wHfoDG18dKPQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25592/Fri Oct  4 10:30:20 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 01:21:55PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 4, 2019 at 11:30 AM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> > On Fri, 4 Oct 2019 09:00:42 -0700, Andrii Nakryiko wrote:
> > > On Fri, Oct 4, 2019 at 8:44 AM David Ahern <dsahern@gmail.com> wrote:
> > >> > I'm not following you; my interpretation of your comment seems like you
> > > > are making huge assumptions.
> > > >
> > > > I build bpf programs for specific kernel versions using the devel
> > > > packages for the specific kernel of interest.
> > >
> > > Sure, and you can keep doing that, just don't include bpf_helpers.h?
> > >
> > > What I was saying, though, especially having in mind tracing BPF
> > > programs that need to inspect kernel structures, is that it's quite
> > > impractical to have to build many different versions of BPF programs
> > > for each supported kernel version and distribute them in binary form.
> > > So people usually use BCC and do compilation on-the-fly using BCC's
> > > embedded Clang.
> > >
> > > BPF CO-RE is providing an alternative, which will allow to pre-compile
> > > your program once for many different kernels you might be running your
> > > program on. There is tooling that eliminates the need for system
> > > headers. Instead we pre-generate a single vmlinux.h header with all
> > > the types/enums/etc, that are then used w/ BPF CO-RE to build portable
> > > BPF programs capable of working on multiple kernel versions.
> > >
> > > So what I was pointing out there was that this vmlinux.h would be
> > > ideally generated from latest kernel and not having latest
> > > BPF_FUNC_xxx shouldn't be a problem. But see below about situation
> > > being worse.
> >
> > Surely for distroes tho - they would have kernel headers matching the
> > kernel release they ship. If parts of libbpf from GH only work with
> > the latest kernel, distroes should ship libbpf from the kernel source,
> > rather than GH.
> >
> > > > > Nevertheless, it is a problem and thanks for bringing it up! I'd say
> > > > > for now we should still go ahead with this move and try to solve with
> > > > > issue once bpf_helpers.h is in libbpf. If bpf_helpers.h doesn't work
> > > > > for someone, it's no worse than it is today when users don't have
> > > > > bpf_helpers.h at all.
> > > > >
> > > >
> > > > If this syncs to the github libbpf, it will be worse than today in the
> > > > sense of compile failures if someone's header file ordering picks
> > > > libbpf's bpf_helpers.h over whatever they are using today.
> > >
> > > Today bpf_helpers.h don't exist for users or am I missing something?
> > > bpf_helpers.h right now are purely for selftests. But they are really
> > > useful outside that context, so I'm making it available for everyone
> > > by distributing with libbpf sources. If bpf_helpers.h doesn't work for
> > > some specific use case, just don't use it (yet?).
> > >
> > > I'm still failing to see how it's worse than situation today.
> >
> > Having a header which works today, but may not work tomorrow is going
> > to be pretty bad user experience :( No matter how many warnings you put
> > in the source people will get caught off guard by this :(
> >
> > If you define the current state as "users can use all features of
> > libbpf and nothing should break on libbpf update" (which is in my
> > understanding a goal of the project, we bent over backwards trying
> > to not break things) then adding this header will in fact make things
> > worse. The statement in quotes would no longer be true, no?
> 
> So there are few things here.
> 
> 1. About "adding bpf_helpers.h will make things worse". I
> categorically disagree, bpf_helpers.h doesn't exist in user land at
> all and it's sorely missing. So adding it is strictly better
> experience already. Right now people have to re-declare those helper
> signatures and do all kinds of unnecessary hackery just to be able to
> use BPF stuff, and they still can run into the same problem with
> having too old kernel headers.

Right, so apps tend to ship their own uapi bpf.h header and helper
signatures to avoid these issues. But question becomes once they
start using soley bpf_helper.h (also in non-tracing context which
is very reasonable to assume), then things might break with the patch
as-is once they have a newer libbpf with more signatures than their
linux/bpf.h defines (and yes, pulling from GH will have this problem),
so we'd need to have an answer to that in order to avoid breaking
compilation.

[...]
> 2. As to the problem of running bleeding-edge libbpf against older
> kernel. There are few possible solutions:
> 
> a. we hard-code all those BPF_FUNC_ constants. Super painful and not
> nice, but will work.
> 
> b. copy/paste enum bpf_func_id definition into bpf_helpers.h itself
> and try to keep it in sync with UAPI. Apart from obvious redundancy
> that involves, we also will need to make sure this doesn't conflict
> with vmlinux.h, so enum name should be different and each value should
> be different (which means some wort of additional prefix or suffix).
> 
> c. BPF UAPI header has __BPF_FUNC_MAPPER macro "iterating" over all
> defined values for a particular kernel version. We can use that and
> additional macro trickery to conditionally define helpers. Again, we
> need to keep in mind that w/ vmlinux.h there is no such macro, so this
> should work as well.
> 
> I'm happy to hear opinions about these choices (maybe there are some
> other I missed), but in any case I'd like to do it in a follow up
> patch and land this one as is. It has already quite a lot packed in
> it. I personally lean towards c) as it will have a benefit of not
> declaring helpers that are not supported by kernel we are compiling
> against, even though it requires additional macro trickery.
> 
> Opinions?

Was thinking about something like c) as well. So I tried to do a quick
hack. Here is how it could work, but it needs a small change in the
__BPF_FUNC_MAPPER(), at least I didn't find an immediate way around it:

static void (*__unspec)(void);
static void *(*__map_lookup_elem)(void *map, const void *key);
static int (*__map_update_elem)(void *map, const void *key, const void *value, unsigned long long flags);
static int (*__map_delete_elem)(void *map, const void *key);
static int (*__bpf_probe_read)(void *dst, int size, const void *unsafe_ptr);

#define __BPF_FUNC_MAPPER(FN, DELIM)    \
        FN(unspec) DELIM                \
        FN(map_lookup_elem) DELIM       \
        FN(map_update_elem) DELIM       \
        FN(map_delete_elem) DELIM

#define __BPF_ENUM_FN(x) BPF_FUNC_ ## x
enum bpf_func_id {
#define COM ,
        __BPF_FUNC_MAPPER(__BPF_ENUM_FN, COM)
        __BPF_FUNC_MAX_ID,
};
#undef __BPF_ENUM_FN

#define __BPF_ASSIGN_FN(x) typeof(__ ## x) x = (void *)BPF_FUNC_ ## x
#define SEM ;
__BPF_FUNC_MAPPER(__BPF_ASSIGN_FN, SEM)
#undef __BPF_ASSIGN_FN

int main(void)
{
        return(unsigned long)map_lookup_elem(0, 0);
}

It does seem to eat it:

$ gcc foo.c 
$

In short, libbpf's bpf_helper.h would define signatures (or better: types) as
above prefixed with __. The __BPF_FUNC_MAPPER() and the enum bpf_func_id {}
is the one in the uapi header, so out of our control from libbpf pov. But
aside from the signatures, the bpf_helper.h would have __BPF_ASSIGN_FN() and
this would avoid the breakage issue. The only thing libbpf needs to have in
the bpf_helper.h are the /latest/ signatures with /matching/ names.

Right now in the __BPF_FUNC_MAPPER() there is this comma, we probably need
to make this a parameter, at least from a quick glance I didn't see a way
to work around it.

Cheers,
Daniel
