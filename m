Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A106E23CF3B
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgHER7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:59:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728856AbgHER6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596650326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P4GwPGZ/qA7/1Etd6zeUZoWHTvIjf2vNyQGUeZrsaF4=;
        b=iqHpIW2Lppm7D7Jla9dGQSpOR10PhvzSWrcz3BoXs2z2e58ga8ctJ6fZ3K38WYULkuK6EF
        mQdwLlUt4IZBQ61wiZ6NVH02+XgbLNTYARWdGl4tq3QmaUzKQJw4YgD3fQnTxCn+oGJgze
        a2ao10oNQ4BEzq9xtCBaoDoYgl07FLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-kUmyyq7uMuSzYrSO1dv1WQ-1; Wed, 05 Aug 2020 13:57:01 -0400
X-MC-Unique: kUmyyq7uMuSzYrSO1dv1WQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0063A3485D;
        Wed,  5 Aug 2020 17:56:56 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id C4F2F1024879;
        Wed,  5 Aug 2020 17:56:52 +0000 (UTC)
Date:   Wed, 5 Aug 2020 19:56:51 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v9 bpf-next 08/14] bpf: Add btf_struct_ids_match function
Message-ID: <20200805175651.GC319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-9-jolsa@kernel.org>
 <CAEf4BzaWGZT-6h8axOupzQ6Z2UiCakgv+v284PuXDZ6_VF5M9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaWGZT-6h8axOupzQ6Z2UiCakgv+v284PuXDZ6_VF5M9Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:27:55PM -0700, Andrii Nakryiko wrote:

SNIP

> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 7bacc2f56061..ba05b15ad599 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4160,6 +4160,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >         return -EINVAL;
> >  }
> >
> > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > +                         int off, u32 id, u32 need_type_id)
> > +{
> > +       const struct btf_type *type;
> > +       int err;
> > +
> > +       /* Are we already done? */
> > +       if (need_type_id == id && off == 0)
> > +               return true;
> > +
> > +again:
> > +       type = btf_type_by_id(btf_vmlinux, id);
> > +       if (!type)
> > +               return false;
> > +       err = btf_struct_walk(log, type, off, 1, &id);
> 
> nit: this size=1 looks a bit artificial, seems like btf_struct_walk()
> will work with size==0 just as well, no?

right, it will work the same for 0 ... not sure why I put
originaly 1 byte for size.. probably got mixed up by some
condition in btf_struct_walk that I thought 0 wouldn't pass,
but it should work, I'll change it, it's less tricky

> 
> > +       if (err != WALK_STRUCT)
> > +               return false;
> > +
> > +       /* We found nested struct object. If it matches
> > +        * the requested ID, we're done. Otherwise let's
> > +        * continue the search with offset 0 in the new
> > +        * type.
> > +        */
> > +       if (need_type_id != id) {
> > +               off = 0;
> > +               goto again;
> > +       }
> > +
> > +       return true;
> > +}
> > +
> >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> >                           const struct bpf_func_proto *fn, int arg)
> >  {
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index b6ccfce3bf4c..bb6ca19f282d 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -3960,16 +3960,21 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
> >                                 goto err_type;
> >                 }
> >         } else if (arg_type == ARG_PTR_TO_BTF_ID) {
> > +               bool ids_match = false;
> > +
> >                 expected_type = PTR_TO_BTF_ID;
> >                 if (type != expected_type)
> >                         goto err_type;
> >                 if (!fn->check_btf_id) {
> > -                       if (reg->btf_id != meta->btf_id) {
> > -                               verbose(env, "Helper has type %s got %s in R%d\n",
> > -                                       kernel_type_name(meta->btf_id),
> > -                                       kernel_type_name(reg->btf_id), regno);
> > -
> > -                               return -EACCES;
> > +                       if (reg->btf_id != meta->btf_id || reg->off) {
> 
> Will it ever succeed if reg->btf_id == meta->btf_id, but reg->off > 0?
> That would require recursively nested type, which is not possible,
> right? Or what am I missing? Is it just a simplification of the error
> handling path?

ok, I wanted to cover all possible cases, but did not realized this
one is not possible ;-) will revert it to previous version

thanks,
jirka

