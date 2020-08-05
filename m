Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376EF23D39E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 23:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgHEVcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 17:32:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24668 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725920AbgHEVcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 17:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596663169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hrYzbsbkUJqRh8UB3Rf9hLYq/J78NU+rtLB4ERSzskA=;
        b=CXNvJBw8gAJjkzBe7FzFyhOcEMLWJHznfjRdPizXevMw90S868fe3QRo+9fHebOtVV5QiF
        6zP4ff2h+LHsP/KntIQa3ZqdpU+V+AK5FY0LVdnhV39y9ed06BiJRpv/RDyiLjEUQl60zX
        z4NulVJRQw9cDX6p9vds7TlYCRKeZxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-xGP-JgLpOQ-AfmlXGAhZIA-1; Wed, 05 Aug 2020 17:31:43 -0400
X-MC-Unique: xGP-JgLpOQ-AfmlXGAhZIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2D420800685;
        Wed,  5 Aug 2020 21:31:41 +0000 (UTC)
Received: from krava (unknown [10.40.192.11])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9340487A41;
        Wed,  5 Aug 2020 21:31:37 +0000 (UTC)
Date:   Wed, 5 Aug 2020 23:31:36 +0200
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
Message-ID: <20200805213136.GG319954@krava>
References: <20200801170322.75218-1-jolsa@kernel.org>
 <20200801170322.75218-9-jolsa@kernel.org>
 <CAEf4BzaWGZT-6h8axOupzQ6Z2UiCakgv+v284PuXDZ6_VF5M9Q@mail.gmail.com>
 <20200805175651.GC319954@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805175651.GC319954@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 07:56:51PM +0200, Jiri Olsa wrote:
> On Tue, Aug 04, 2020 at 11:27:55PM -0700, Andrii Nakryiko wrote:
> 
> SNIP
> 
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 7bacc2f56061..ba05b15ad599 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -4160,6 +4160,37 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > >         return -EINVAL;
> > >  }
> > >
> > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > +                         int off, u32 id, u32 need_type_id)
> > > +{
> > > +       const struct btf_type *type;
> > > +       int err;
> > > +
> > > +       /* Are we already done? */
> > > +       if (need_type_id == id && off == 0)
> > > +               return true;
> > > +
> > > +again:
> > > +       type = btf_type_by_id(btf_vmlinux, id);
> > > +       if (!type)
> > > +               return false;
> > > +       err = btf_struct_walk(log, type, off, 1, &id);
> > 
> > nit: this size=1 looks a bit artificial, seems like btf_struct_walk()
> > will work with size==0 just as well, no?
> 
> right, it will work the same for 0 ... not sure why I put
> originaly 1 byte for size.. probably got mixed up by some
> condition in btf_struct_walk that I thought 0 wouldn't pass,
> but it should work, I'll change it, it's less tricky

ok, I found why it's 1 ;-) it's this condition in btf_struct_walk:

        for_each_member(i, t, member) {
                /* offset of the field in bytes */
                moff = btf_member_bit_offset(t, member) / 8;
                if (off + size <= moff)
                        /* won't find anything, field is already too far */
                        break;

I originaly chose to use 'size = 1' not to medle with this (and probably causing
other issues) and in any case we expect that anything we find have at least byte
size, so it has some logic ;-)

we could make 0 size a special case and don't break the loop for it,
but I wonder there's already someone calling it with zero and is
expecting it to fail

jirka

