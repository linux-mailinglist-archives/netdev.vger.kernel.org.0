Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E502032A4
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgFVI7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:59:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgFVI7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 04:59:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592816377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ehg/zjb8Q2TUGPWepfVX4VSAfCywde6YjingIHKbRfo=;
        b=L9QdGVERrJ15Hvr450/GE+2aYD1pXCB6NjWBr2ac76Fj0GXwrl32i00fR85ZK0AsU5uI3H
        gzXPyjdA45krvqjpNb/kwFK+6VTHQ3ZT/m1xxz5/PiI4sz6Dmj4eMb0zTyP9tGj9Ds2wk4
        DKt0Lxmv+Cd9R0TOYS6iO0tSSIrnUP8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-xQtGER3jMi-IsqBlPHuzwQ-1; Mon, 22 Jun 2020 04:59:33 -0400
X-MC-Unique: xQtGER3jMi-IsqBlPHuzwQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 371BEEC1A2;
        Mon, 22 Jun 2020 08:59:31 +0000 (UTC)
Received: from krava (unknown [10.40.193.171])
        by smtp.corp.redhat.com (Postfix) with SMTP id 60C597C1FD;
        Mon, 22 Jun 2020 08:59:27 +0000 (UTC)
Date:   Mon, 22 Jun 2020 10:59:26 +0200
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
Subject: Re: [PATCH 01/11] bpf: Add btfid tool to resolve BTF IDs in ELF
 object
Message-ID: <20200622085926.GC2556590@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-2-jolsa@kernel.org>
 <CAEf4BzbB0ZMfWHrhiPhv79sMVZ9L0gMj54uXKn_-+mTawPiBqw@mail.gmail.com>
 <20200619130354.GB2465907@krava>
 <CAEf4BzbK4q9fTTYA5Apyn_wn0tb5K1_Vm7DX_OwM133V6XHB7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbK4q9fTTYA5Apyn_wn0tb5K1_Vm7DX_OwM133V6XHB7g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:12:29AM -0700, Andrii Nakryiko wrote:

SNIP

> >
> > ok
> >
> > >
> > > > +                       root = &obj->funcs;
> > > > +                       nr = &nr_funcs;
> > > > +               } else if (BTF_INFO_KIND(type->info) == BTF_KIND_STRUCT && nr_structs) {
> > >
> > > same as above: btf_is_struct
> > >
> > > But I think you also need to support unions?
> > >
> > > Also what about typedefs? A lot of types are typedefs to struct/func_proto/etc.
> >
> > I added only types which are needed at the moment, but maybe
> > we can add the basic types now, so we don't need to bother later,
> > when we forget how this all work ;-)
> 
> yeah, exactly. Once this works, no one will want to go and revisit it,
> so I'd rather make it generic from the get go, especially that it's
> really easy in this case, right?

right, I'll add the basic types

SNIP

> > >
> > > nit: should these elf_end/close properly on error?
> >
> > I wrote in the comment above that I intentionaly do not cleanup
> > on error path.. I wanted to save some time, but actualy I think
> > that would not be so expensive, I can add it
> 
> as in save CPU time in error case? Who cares about that? If saving
> developer time, well... `goto cleanup` is common and simple pattern ;)

the sooner you see the error the better ;-) ok

jirka

