Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B351FF0F3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 13:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgFRLsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 07:48:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47231 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728291AbgFRLsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 07:48:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592480894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uyIvvPBF+MpYQOOLrTvfIr/WJu5YGMFAZyoz1bbDjzM=;
        b=JcH9EXyZ8qoXMbLpX6zyMtPZ02cUNq92OD1QASjitEl0ST4mk83HkfL2Z/JnUm04u7UtY4
        4lKi/gVRx72L7zx08WAQdXtrGqKkKaQF4rHmygh/K/8CbGNk4OddG0y3502W6rz36ZEsD3
        imQqk9MfJjqBetkNnjREFrxD2G+rX6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-kRUP0nEkOZKbB_4tCwG95A-1; Thu, 18 Jun 2020 07:48:13 -0400
X-MC-Unique: kRUP0nEkOZKbB_4tCwG95A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9DB81800D42;
        Thu, 18 Jun 2020 11:48:10 +0000 (UTC)
Received: from krava (unknown [10.40.194.92])
        by smtp.corp.redhat.com (Postfix) with SMTP id 677E41001E91;
        Thu, 18 Jun 2020 11:48:07 +0000 (UTC)
Date:   Thu, 18 Jun 2020 13:48:06 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20200618114806.GA2369163@krava>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> Jiri Olsa wrote:
> > This way we can have trampoline on function
> > that has arguments with types like:
> > 
> >   kuid_t uid
> >   kgid_t gid
> > 
> > which unwind into small structs like:
> > 
> >   typedef struct {
> >         uid_t val;
> >   } kuid_t;
> > 
> >   typedef struct {
> >         gid_t val;
> >   } kgid_t;
> > 
> > And we can use them in bpftrace like:
> > (assuming d_path changes are in)
> > 
> >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> >   Attaching 1 probe...
> >   uid 0, gid 0
> >   uid 1000, gid 1000
> >   ...
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/btf.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 58c9af1d4808..f8fee5833684 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> >  	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> >  }
> >  
> > +/* type is struct and its size is within 8 bytes
> > + * and it can be value of function argument
> > + */
> > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > +{
> > +	return btf_type_is_struct(t) && (t->size <= sizeof(u64));
> 
> Can you comment on why sizeof(u64) here? The int types can be larger
> than 64 for example and don't have a similar check, maybe the should
> as well?
> 
> Here is an example from some made up program I ran through clang and
> bpftool.
> 
> [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> 
> We also have btf_type_int_is_regular to decide if the int is of some
> "regular" size but I don't see it used in these paths.

so this small structs are passed as scalars via function arguments,
so the size limit is to fit teir value into register size which holds
the argument

I'm not sure how 128bit numbers are passed to function as argument,
but I think we can treat them separately if there's a need

jirka

> 
> > +}
> > +
> >  static bool __btf_type_is_struct(const struct btf_type *t)
> >  {
> >  	return BTF_INFO_KIND(t->info) == BTF_KIND_STRUCT;
> > @@ -3768,7 +3776,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >  	/* skip modifiers */
> >  	while (btf_type_is_modifier(t))
> >  		t = btf_type_by_id(btf, t->type);
> > -	if (btf_type_is_int(t) || btf_type_is_enum(t))
> > +	if (btf_type_is_int(t) || btf_type_is_enum(t) || btf_type_is_struct_arg(t))
> >  		/* accessing a scalar */
> >  		return true;
> >  	if (!btf_type_is_ptr(t)) {
> > @@ -4161,6 +4169,8 @@ static int __get_type_size(struct btf *btf, u32 btf_id,
> >  		return sizeof(void *);
> >  	if (btf_type_is_int(t) || btf_type_is_enum(t))
> >  		return t->size;
> > +	if (btf_type_is_struct_arg(t))
> > +		return t->size;
> >  	*bad_type = t;
> >  	return -EINVAL;
> >  }
> > -- 
> > 2.25.4
> > 
> 
> 

