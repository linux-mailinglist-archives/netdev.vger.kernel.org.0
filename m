Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292E8200458
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgFSIuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:50:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44185 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727114AbgFSIuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:50:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592556649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1y+jC8Lg9DztUVDkAm+XhejwBprH6jYk5+wN3byWs5A=;
        b=EwhJB6aASdPETOT1nbHScnrKX9oGPnmPQJj1wHfsa274KsQKJVM9A3+162+FntAvzROCAj
        V6f6oyAQqWMDQgeEaLdA3Zddb1ED4xt0IKjJccLhsREu2dg0n4wJPAUkHufrc0YhgdgSC/
        AJ3bmNsO4aQ7mXvmGRYIHxdm3aA1CXE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-_Ogs94LONIGyYHNuCqLfdA-1; Fri, 19 Jun 2020 04:50:45 -0400
X-MC-Unique: _Ogs94LONIGyYHNuCqLfdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4596A800053;
        Fri, 19 Jun 2020 08:50:43 +0000 (UTC)
Received: from krava (unknown [10.40.194.200])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8D2D35D9E5;
        Fri, 19 Jun 2020 08:50:39 +0000 (UTC)
Date:   Fri, 19 Jun 2020 10:50:38 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
Message-ID: <20200619085038.GA2447533@krava>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
 <20200618220511.jrwes44dfh7v52tt@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618220511.jrwes44dfh7v52tt@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 03:05:11PM -0700, Alexei Starovoitov wrote:
> On Thu, Jun 18, 2020 at 01:48:06PM +0200, Jiri Olsa wrote:
> > On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> > > Jiri Olsa wrote:
> > > > This way we can have trampoline on function
> > > > that has arguments with types like:
> > > > 
> > > >   kuid_t uid
> > > >   kgid_t gid
> > > > 
> > > > which unwind into small structs like:
> > > > 
> > > >   typedef struct {
> > > >         uid_t val;
> > > >   } kuid_t;
> > > > 
> > > >   typedef struct {
> > > >         gid_t val;
> > > >   } kgid_t;
> > > > 
> > > > And we can use them in bpftrace like:
> > > > (assuming d_path changes are in)
> 
> the patch doesn't seem to be related to d_path. Unless I'm missing something.

ugh, sry.. I had bpftrace example with dpath call in it,
then I removed it, but did not remove the comment ;-)

> 
> Please add a selftest. bpftrace example is nice, but selftest is still mandatory.

ok

> 
> > > > 
> > > >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> > > >   Attaching 1 probe...
> > > >   uid 0, gid 0
> > > >   uid 1000, gid 1000
> > > >   ...
> > > > 
> > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > ---
> > > >  kernel/bpf/btf.c | 12 +++++++++++-
> > > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > index 58c9af1d4808..f8fee5833684 100644
> > > > --- a/kernel/bpf/btf.c
> > > > +++ b/kernel/bpf/btf.c
> > > > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> > > >  	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> > > >  }
> > > >  
> > > > +/* type is struct and its size is within 8 bytes
> > > > + * and it can be value of function argument
> > > > + */
> > > > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > > > +{
> > > > +	return btf_type_is_struct(t) && (t->size <= sizeof(u64));
> 
> extra () are unnecessary.
> 
> the function needs different name. May btf_type_is_struct_by_value() ?

ok

> 
> > > 
> > > Can you comment on why sizeof(u64) here? The int types can be larger
> > > than 64 for example and don't have a similar check, maybe the should
> > > as well?
> > > 
> > > Here is an example from some made up program I ran through clang and
> > > bpftool.
> > > 
> > > [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> > > 
> > > We also have btf_type_int_is_regular to decide if the int is of some
> > > "regular" size but I don't see it used in these paths.
> > 
> > so this small structs are passed as scalars via function arguments,
> > so the size limit is to fit teir value into register size which holds
> > the argument
> > 
> > I'm not sure how 128bit numbers are passed to function as argument,
> > but I think we can treat them separately if there's a need
> > 
> > jirka
> > 
> > > 
> > > > +}
> > > > +
> > > >  static bool __btf_type_is_struct(const struct btf_type *t)
> > > >  {
> > > >  	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
> > > > @@ -3768,7 +3776,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> > > >  	/* skip modifiers */
> > > >  	while (btf_type_is_modifier(t))
> > > >  		t = btf_type_by_id(btf, t->type);
> > > > -	if (btf_type_is_int(t) || btf_type_is_enum(t))
> > > > +	if (btf_type_is_int(t) || btf_type_is_enum(t) || btf_type_is_struct_arg(t))
> > > >  		/* accessing a scalar */
> > > >  		return true;
> 
> It probably needs to be x86 gated?
> I don't think all archs do that for small structs.

right, but if btf_type_is_struct_arg == true in here,
the struct is in the argument value

> 
> What kind of code clang generates for bpf prog?
> I don't remember what we told clang to do for struct by value.
> That has to be carefully defined and tested.

will check,

thanks
jirka

