Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D44A23CD8A
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgHERhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:37:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41934 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728867AbgHERhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596649031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oMaXr6AjoRreIUBU+G85r8nZDJYOJ3q1LtahtihDE/0=;
        b=dSwKQJeLu9IiD5H7LW2tn6p/DhisUSxvd1Bibq3O3FHE73fMnDqY0BleGmjSpL+UUiV4fl
        dV0d7uM79NU4w+3Gd7cpDU1jb5p8eOaR+ZbI1Di9KhP3r53FDWO2HeBVEY33JyHPTbMjG2
        YAPZzW2z4RwMF3XqnIbjhuD95ufU2ww=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-jpzXJGi1N-K01UX5gt3qkA-1; Wed, 05 Aug 2020 13:37:07 -0400
X-MC-Unique: jpzXJGi1N-K01UX5gt3qkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31A628015F4;
        Wed,  5 Aug 2020 17:37:03 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9E45F87A46;
        Wed,  5 Aug 2020 17:36:59 +0000 (UTC)
Date:   Wed, 5 Aug 2020 19:36:58 +0200
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
Subject: Re: [PATCH v9 bpf-next 06/14] bpf: Remove recursion call in
 btf_struct_access
Message-ID: <20200805173658.GB319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-7-jolsa@kernel.org>
 <CAEf4BzYtO+ELTpBVwWmWRkmgOCmCnCWU6iZzYjfNRHvb7rgEJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYtO+ELTpBVwWmWRkmgOCmCnCWU6iZzYjfNRHvb7rgEJg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:12:49PM -0700, Andrii Nakryiko wrote:
> On Sat, Aug 1, 2020 at 10:04 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Andrii suggested we can simply jump to again label
> > instead of making recursion call.
> >
> > Suggested-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/btf.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index bc05a24f7361..0f995038b589 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3931,14 +3931,13 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >                 /* Only allow structure for now, can be relaxed for
> >                  * other types later.
> >                  */
> > -               elem_type = btf_type_skip_modifiers(btf_vmlinux,
> > -                                                   array_elem->type, NULL);
> > -               if (!btf_type_is_struct(elem_type))
> > +               t = btf_type_skip_modifiers(btf_vmlinux, array_elem->type,
> > +                                           NULL);
> > +               if (!btf_type_is_struct(t))
> >                         goto error;
> >
> > -               off = (off - moff) % elem_type->size;
> > -               return btf_struct_access(log, elem_type, off, size, atype,
> > -                                        next_btf_id);
> > +               off = (off - moff) % t->size;
> > +               goto again;
> 
> Transformation looks good, thanks. So:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> But this '% t->size' makes me wonder what will happen when we have an
> array of zero-sized structs or multi-dimensional arrays with
> dimensions of size 0... I.e.:
> 
> struct {} arr[123];
> 
> or
> 
> int arr[0][0]0];
> 
> We should probably be more careful with division here.

right, definitely..  I'll send follow up patch for that

thanks,
jirka

