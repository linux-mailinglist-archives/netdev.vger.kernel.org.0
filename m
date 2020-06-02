Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87C91EB72D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 10:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgFBIQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 04:16:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39980 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725900AbgFBIQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 04:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591085810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5fjn1LT3OUXoQ+qo6mOFTzip+J62UlIvmtArBLfCL5Q=;
        b=GxDKn+oh0GG9CycImClAMxS4UOuGkEqPrs0eT2OxAOwDOXYS5fFhF5oISO5l10U3gNWR4w
        rZGKvTsL4PHxC4CR0Su9RyzyO7mfRg0c/6g0h/y0U4z+9P6oFlmbRgrbATbPPQhoIiiEkl
        XGX9xU5KkecfpN3LVruukoZTnlik4Bc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-TcA8xkvTOJmlXQQbqXXxpg-1; Tue, 02 Jun 2020 04:16:46 -0400
X-MC-Unique: TcA8xkvTOJmlXQQbqXXxpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC77107ACF6;
        Tue,  2 Jun 2020 08:16:44 +0000 (UTC)
Received: from krava (unknown [10.40.195.39])
        by smtp.corp.redhat.com (Postfix) with SMTP id 744C65C1D6;
        Tue,  2 Jun 2020 08:16:40 +0000 (UTC)
Date:   Tue, 2 Jun 2020 10:16:39 +0200
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
Message-ID: <20200602081639.GD1112120@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava>
 <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
 <20200528172349.GA506785@krava>
 <CAEf4BzbM-5-_QzDhrJDFJefo-m0OWDhvjsK_F1vA-ja4URVE9Q@mail.gmail.com>
 <20200531151039.GA881900@krava>
 <CAEf4BzZTyzMaXbpDOCUHyWV7hotwaT3DdHuDxrK=0bfOMLQ5AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZTyzMaXbpDOCUHyWV7hotwaT3DdHuDxrK=0bfOMLQ5AQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 12:06:34PM -0700, Andrii Nakryiko wrote:
> On Sun, May 31, 2020 at 8:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Fri, May 29, 2020 at 01:48:58PM -0700, Andrii Nakryiko wrote:
> > > On Thu, May 28, 2020 at 10:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > >
> > > > On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:
> > > >
> > > > SNIP
> > > >
> > > > > > I was thinking of putting the names in __init section and generate the BTF
> > > > > > ids on kernel start, but the build time generation seemed more convenient..
> > > > > > let's see the linking times with 'real size' whitelist and we can reconsider
> > > > > >
> > > > >
> > > > > Being able to record such places where to put BTF ID in code would be
> > > > > really nice, as Alexei mentioned. There are many potential use cases
> > > > > where it would be good to have BTF IDs just put into arbitrary
> > > > > variables/arrays. This would trigger compilation error, if someone
> > > > > screws up the name, or function is renamed, or if function can be
> > > > > compiled out under some configuration. E.g., assuming some reasonable
> > > > > implementation of the macro
> > > >
> > > > hi,
> > > > I'm struggling with this part.. to get some reasonable reference
> > > > to function/name into 32 bits? any idea? ;-)
> > > >
> > >
> > > Well, you don't have to store actual pointer, right? E.g, emitting
> > > something like this in assembly:
> > >
> > > .global __BTF_ID___some_function
> > > .type __BTF_ID___some_function, @object
> > > .size __BTF_ID___some_function, 4
> > > __BTF_ID___some_function:
> > > .zero  4
> > >
> > > Would reserve 4 bytes and emit __BTF_ID___some_function symbol. If we
> > > can then post-process vmlinux image and for all symbols starting with
> > > __BTF_ID___ find some_function BTF type id and put it into those 4
> > > bytes, that should work, no?
> > >
> > > Maybe generalize it to __BTF_ID__{func,struct,typedef}__some_function,
> > > whatever, not sure. Just an idea.
> >
> > nice, so something like below?
> >
> > it'd be in .S file, or perhaps in inline asm, assuming I'll be
> > able to pass macro arguments to asm("")
> 
> I'd do inline asm, there are no arguments you need to pass into
> asm("") itself, everything can be done through macro string
> interpolation, I think. Having everything in .c file would be way more
> convenient and obvious.

wil will do it in inline asm

thanks,
jirka

