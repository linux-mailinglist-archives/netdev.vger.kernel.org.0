Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C476A1D52B3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgEOO5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 10:57:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43773 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726197AbgEOO5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 10:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589554671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgPkv6IFPRsniYQZjM7AMygqfcLBL8j/W5B628JMVHI=;
        b=PN5gIjHE7Ob+jdWSUGYJagphp2ff2FuWfyxp+tsrYffirpDsxk1eEgH5omvx66YHjZcpAU
        iZZ6vMc3Kxwg4CRhUa2PxCM4ofy5/eHWFBE04Zth/VKN+h9JZ5MlMgt3nvC1GdH78TNu3o
        H9B5UkRPzEDRS1GImZO0lvO/BxsmTBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-dfGd3awrOGW4qS6_Tnq9eA-1; Fri, 15 May 2020 10:57:47 -0400
X-MC-Unique: dfGd3awrOGW4qS6_Tnq9eA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE48718FE866;
        Fri, 15 May 2020 14:57:44 +0000 (UTC)
Received: from krava (unknown [10.40.194.127])
        by smtp.corp.redhat.com (Postfix) with SMTP id 45DBF5C1D6;
        Fri, 15 May 2020 14:57:41 +0000 (UTC)
Date:   Fri, 15 May 2020 16:57:40 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 7/9] bpf: Compile the BTF id whitelist data in vmlinux
Message-ID: <20200515145740.GB3565839@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava>
 <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:
> On Thu, May 14, 2020 at 1:05 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Wed, May 13, 2020 at 11:29:40AM -0700, Alexei Starovoitov wrote:
> >
> > SNIP
> >
> > > > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > > > index d09ab4afbda4..dee91c6bf450 100755
> > > > --- a/scripts/link-vmlinux.sh
> > > > +++ b/scripts/link-vmlinux.sh
> > > > @@ -130,16 +130,26 @@ gen_btf()
> > > >     info "BTF" ${2}
> > > >     LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
> > > >
> > > > -   # Create ${2} which contains just .BTF section but no symbols. Add
> > > > +   # Create object which contains just .BTF section but no symbols. Add
> > > >     # SHF_ALLOC because .BTF will be part of the vmlinux image. --strip-all
> > > >     # deletes all symbols including __start_BTF and __stop_BTF, which will
> > > >     # be redefined in the linker script. Add 2>/dev/null to suppress GNU
> > > >     # objcopy warnings: "empty loadable segment detected at ..."
> > > >     ${OBJCOPY} --only-section=.BTF --set-section-flags .BTF=alloc,readonly \
> > > > -           --strip-all ${1} ${2} 2>/dev/null
> > > > -   # Change e_type to ET_REL so that it can be used to link final vmlinux.
> > > > -   # Unlike GNU ld, lld does not allow an ET_EXEC input.
> > > > -   printf '\1' | dd of=${2} conv=notrunc bs=1 seek=16 status=none
> > > > +           --strip-all ${1} 2>/dev/null
> > > > +
> > > > +   # Create object that contains just .BTF_whitelist_* sections generated
> > > > +   # by bpfwl. Same as BTF section, BTF_whitelist_* data will be part of
> > > > +   # the vmlinux image, hence SHF_ALLOC.
> > > > +   whitelist=.btf.vmlinux.whitelist
> > > > +
> > > > +   ${BPFWL} ${1} kernel/bpf/helpers-whitelist > ${whitelist}.c
> > > > +   ${CC} -c -o ${whitelist}.o ${whitelist}.c
> > > > +   ${OBJCOPY} --only-section=.BTF_whitelist* --set-section-flags .BTF=alloc,readonly \
> > > > +                --strip-all ${whitelist}.o 2>/dev/null
> > > > +
> > > > +   # Link BTF and BTF_whitelist objects together
> > > > +   ${LD} -r -o ${2} ${1} ${whitelist}.o
> > >
> > > Thank you for working on it!
> > > Looks great to me overall. In the next rev please drop RFC tag.
> > >
> > > My only concern is this extra linking step. How many extra seconds does it add?
> >
> > I did not meassure, but I haven't noticed any noticable delay,
> > I'll add meassurements to the next post
> >
> > >
> > > Also in patch 3:
> > > +               func = func__find(str);
> > > +               if (func)
> > > +                       func->id = id;
> > > which means that if somebody mistyped the name or that kernel function
> > > got renamed there will be no warnings or errors.
> > > I think it needs to fail the build instead.
> >
> > it fails later on, when generating the array:
> >
> >      if (!func->id) {
> >              fprintf(stderr, "FAILED: '%s' function not found in BTF data\n",
> >                      func->name);
> >              return -1;
> >      }
> >
> > but it can clearly fail before that.. I'll change that
> 
> I also means that whitelist can't contain functions that can be
> conditionally compiled out, right? I guess we can invent some naming
> convention to handle that, e.g: ?some_func will mean it's fine if we
> didn't find it?

right.. I did not think of functions which won't be compiled in
because of disabled config options, in that case build falsly fails 

> 
> >
> > >
> > > If additional linking step takes another 20 seconds it could be a reason
> > > to move the search to run-time.
> > > We already have that with struct bpf_func_proto->btf_id[].
> > > Whitelist could be something similar.
> > > I think this mechanism will be reused for unstable helpers and other
> > > func->btf_id mappings, so 'bpfwl' name would change eventually.
> > > It's not white list specific. It generates a mapping of names to btf_ids.
> > > Doing it at build time vs run-time is a trade off and it doesn't have
> > > an obvious answer.
> >
> > I was thinking of putting the names in __init section and generate the BTF
> > ids on kernel start, but the build time generation seemed more convenient..
> > let's see the linking times with 'real size' whitelist and we can reconsider
> >
> 
> Being able to record such places where to put BTF ID in code would be
> really nice, as Alexei mentioned. There are many potential use cases
> where it would be good to have BTF IDs just put into arbitrary
> variables/arrays. This would trigger compilation error, if someone
> screws up the name, or function is renamed, or if function can be
> compiled out under some configuration. E.g., assuming some reasonable
> implementation of the macro
> 
> static const u32 d_path_whitelist[] = {
>     BTF_ID_FUNC(vfs_fallocate),
> #ifdef CONFIG_WHATEVER
>     BTF_ID_FUNC(do_truncate),
> #endif
> };
> 
> Would be nice and very explicit. Given this is not going to be sorted,
> you won't be able to use binary search, but if whitelists are
> generally small, it should be fine as is. If not, hashmap could be
> built in runtime and would be, probably, faster than binary search for
> longer sets of BTF IDs.
> 
> I wonder if we can do some assembly magic with generating extra
> symbols and/or relocations to achieve this? What do you think? Is it
> doable/desirable/better?

so assuming this is doable bpfwl could be a generic tool for both
whitelist and bpf_func_proto->btf_id cases

and we would solve the issue with missing function due to disable CONFIG

and the name could change to something event more generic ;-)

sounds like good idea ;-)

I'll check and see if I can find some reasonable way for BTF_ID_FUNC

thanks,
jirka

