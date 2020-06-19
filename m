Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931E1200A21
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732663AbgFSN3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:29:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58795 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729080AbgFSN3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592573380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Lphv2upattCVCs19VxW8/BytC2untc5aXazNPJHF1w=;
        b=TDbI+YgF1qnM7MPByaaj0x0DWK1DfFRIIGDtblL6aP4/XhOGBTuwd6dfxw7iqqufpWEeIR
        cLtOw6rNtfgBABFxNIaO1yMHOoU7EP1ZXYPyq6/VXlnXuyFfe8aQ/hoAcYWwjAr3n3J6gK
        AhZ+Q2ZUJB17yoCk/t1OziM4fWDmEOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-eKORCN7AMVe-Ikzf4MQCVA-1; Fri, 19 Jun 2020 09:29:36 -0400
X-MC-Unique: eKORCN7AMVe-Ikzf4MQCVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F20D801503;
        Fri, 19 Jun 2020 13:29:34 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id DDFC960BE1;
        Fri, 19 Jun 2020 13:29:30 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:29:29 +0200
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
Subject: Re: [PATCH 08/11] bpf: Add BTF whitelist support
Message-ID: <20200619132929.GI2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-9-jolsa@kernel.org>
 <CAEf4Bzaj-t0UYLiJh9czenqVtsi5UuviX_AqgpEq=gJx6WCHrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzaj-t0UYLiJh9czenqVtsi5UuviX_AqgpEq=gJx6WCHrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:29:58PM -0700, Andrii Nakryiko wrote:

SNIP

> > @@ -4669,3 +4670,15 @@ u32 btf_id(const struct btf *btf)
> >  {
> >         return btf->id;
> >  }
> > +
> > +static int btf_id_cmp_func(const void *a, const void *b)
> > +{
> > +       const int *pa = a, *pb = b;
> > +
> > +       return *pa - *pb;
> > +}
> > +
> > +bool btf_whitelist_search(int id, int list[], int cnt)
> 
> whitelist is a bit too specific, this functionality can be used for
> blacklisting as well, no?
> 
> How about instead of "open coding" separately int list[] + int cnt, we
> define a struct:
> 
> struct btf_id_set {
>     u32 cnt;
>     u32 ids[];
> };
> 
> and pass that around?
> 
> This function then can be generic
> 
> bool btf_id_set_contains(struct btf_id_set *set, u32 id);
> 
> Then it's usable for both whitelist and blacklist? _contains also
> clearly implies what's the return result, while _search isn't so clear
> in that regard.

yep, looks better this way, will change

> 
> 
> > +{
> > +       return bsearch(&id, list, cnt, sizeof(int), btf_id_cmp_func) != NULL;
> > +}
> > diff --git a/kernel/bpf/btf_ids.h b/kernel/bpf/btf_ids.h
> > index 68aa5c38a37f..a90c09faa515 100644
> > --- a/kernel/bpf/btf_ids.h
> > +++ b/kernel/bpf/btf_ids.h
> > @@ -67,4 +67,42 @@ asm(                                                 \
> >  #name ":;                                      \n"     \
> >  ".popsection;                                  \n");
> >
> > +
> > +/*
> > + * The BTF_WHITELIST_ENTRY/END macros pair defines sorted
> > + * list of BTF IDs plus its members count, with following
> > + * layout:
> > + *
> > + * BTF_WHITELIST_ENTRY(list2)
> > + * BTF_ID(type1, name1)
> > + * BTF_ID(type2, name2)
> > + * BTF_WHITELIST_END(list)
> 
> It kind of sucks you need two separate ENTRY/END macro (btw, START/END
> or BEGIN/END would be a bit more "paired"), and your example clearly

ok, START/END it is

> shows why: it is not self-consistent (list2 on start, list on end ;).

ugh ;-)

> But doing variadic macro like this would be a nightmare as well,
> unfortunately. :(
> 
> > + *
> > + * __BTF_ID__sort__list:
> > + * list2_cnt:
> > + * .zero 4
> > + * list2:
> > + * __BTF_ID__type1__name1__3:
> > + * .zero 4
> > + * __BTF_ID__type2__name2__4:
> > + * .zero 4
> > + *
> > + */
> > +#define BTF_WHITELIST_ENTRY(name)                      \
> > +asm(                                                   \
> > +".pushsection " SECTION ",\"a\";               \n"     \
> > +".global __BTF_ID__sort__" #name ";            \n"     \
> > +"__BTF_ID__sort__" #name ":;                   \n"     \
> 
> I mentioned in the previous patch already, I think "sort" is a bad
> name, consider "set" (or "list", but you used list name already for a
> slightly different macro).

yes, I replied to this in another email

> 
> > +".global " #name "_cnt;                        \n"     \
> > +#name "_cnt:;                                  \n"     \
> 
> This label/symbol isn't necessary, why polluting the symbol table?

XXX_cnt variable is used in search function, but isn't needed
if we use that 'struct btf_id_set' you proposed

> 
> > +".zero 4                                       \n"     \
> > +".popsection;                                  \n");   \
> > +BTF_ID_LIST(name)
> > +
> > +#define BTF_WHITELIST_END(name)                                \
> > +asm(                                                   \
> > +".pushsection " SECTION ",\"a\";              \n"      \
> > +".size __BTF_ID__sort__" #name ", .-" #name " \n"      \
> > +".popsection;                                 \n");
> > +
> >  #endif
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index bee3da2cd945..5a9a6fd72907 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -4633,6 +4633,11 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> >                 return -EINVAL;
> >         }
> >
> > +       if (fn->allowed && !fn->allowed(env->prog)) {
> > +               verbose(env, "helper call is not allowed in probe\n");
> 
> nit: probe -> program, or just drop "in probe" part altogether

ok

thnaks,
jirka

