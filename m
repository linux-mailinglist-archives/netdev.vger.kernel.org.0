Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83551E9862
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 17:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEaPKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 11:10:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30689 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727781AbgEaPKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 11:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590937851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5PzQOC014IOVx9/TNBcKObA8/fHxBl+Fe3amH29hNfc=;
        b=ggwN0U6Ka/LlUK6ggVW40kmL9UkwiDRAh/f6mMZzgEzy5HkgwnnPxPkCGNbu8rjy7dWZta
        q/byj3707YltZm0fsC93ZJEnE+Ut9HnILP70xQAntPNDQTax/NsJLaVTNkPXVCXu9XTTPk
        Yon+Fdwi0X87i3OkqJxu5y4+ANgmiYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-32icELIcMk6POeBgo6jIlA-1; Sun, 31 May 2020 11:10:47 -0400
X-MC-Unique: 32icELIcMk6POeBgo6jIlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 981091005510;
        Sun, 31 May 2020 15:10:44 +0000 (UTC)
Received: from krava (unknown [10.40.192.36])
        by smtp.corp.redhat.com (Postfix) with SMTP id 72DDA610AB;
        Sun, 31 May 2020 15:10:40 +0000 (UTC)
Date:   Sun, 31 May 2020 17:10:39 +0200
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
Message-ID: <20200531151039.GA881900@krava>
References: <20200506132946.2164578-1-jolsa@kernel.org>
 <20200506132946.2164578-8-jolsa@kernel.org>
 <20200513182940.gil7v5vkthhwck3t@ast-mbp.dhcp.thefacebook.com>
 <20200514080515.GH3343750@krava>
 <CAEf4BzbZ6TYxVTJx3ij1WXy5AvVQio9Ht=tePO+xQf=JLigoog@mail.gmail.com>
 <20200528172349.GA506785@krava>
 <CAEf4BzbM-5-_QzDhrJDFJefo-m0OWDhvjsK_F1vA-ja4URVE9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbM-5-_QzDhrJDFJefo-m0OWDhvjsK_F1vA-ja4URVE9Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:48:58PM -0700, Andrii Nakryiko wrote:
> On Thu, May 28, 2020 at 10:24 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, May 14, 2020 at 03:46:26PM -0700, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > I was thinking of putting the names in __init section and generate the BTF
> > > > ids on kernel start, but the build time generation seemed more convenient..
> > > > let's see the linking times with 'real size' whitelist and we can reconsider
> > > >
> > >
> > > Being able to record such places where to put BTF ID in code would be
> > > really nice, as Alexei mentioned. There are many potential use cases
> > > where it would be good to have BTF IDs just put into arbitrary
> > > variables/arrays. This would trigger compilation error, if someone
> > > screws up the name, or function is renamed, or if function can be
> > > compiled out under some configuration. E.g., assuming some reasonable
> > > implementation of the macro
> >
> > hi,
> > I'm struggling with this part.. to get some reasonable reference
> > to function/name into 32 bits? any idea? ;-)
> >
> 
> Well, you don't have to store actual pointer, right? E.g, emitting
> something like this in assembly:
> 
> .global __BTF_ID___some_function
> .type __BTF_ID___some_function, @object
> .size __BTF_ID___some_function, 4
> __BTF_ID___some_function:
> .zero  4
> 
> Would reserve 4 bytes and emit __BTF_ID___some_function symbol. If we
> can then post-process vmlinux image and for all symbols starting with
> __BTF_ID___ find some_function BTF type id and put it into those 4
> bytes, that should work, no?
> 
> Maybe generalize it to __BTF_ID__{func,struct,typedef}__some_function,
> whatever, not sure. Just an idea.

nice, so something like below?

it'd be in .S file, or perhaps in inline asm, assuming I'll be
able to pass macro arguments to asm("")

with externs defined in some header file:

  extern const int bpf_skb_output_btf_ids[];
  extern const int btf_whitelist_d_path[];

  $ objdump -x ./kernel/bpf/whitelist.o
  ...
  0000000000000000 l     O .data  0000000000000004 __BTF_ID__func__vfs_truncate
  0000000000000004 l     O .data  0000000000000004 __BTF_ID__func__vfs_fallocate
  0000000000000008 l     O .data  0000000000000004 __BTF_ID__func__krava
  0000000000000010 l     O .data  0000000000000004 __BTF_ID__struct__sk_buff
  0000000000000000 g       .data  0000000000000000 btf_whitelist_d_path
  0000000000000010 g       .data  0000000000000000 bpf_skb_output_btf_ids

also it'd be nice to get rid of BTF_ID__ symbols in the final link

thanks,
jirka


---
#define BTF_ID(prefix, name)                    \
.local __BTF_ID__##prefix##__##name;            \
.type __BTF_ID__##prefix##__##name, @object;    \
.size __BTF_ID__##prefix##__##name, 4;          \
__BTF_ID__##prefix##__##name:                   \
.zero 4

#define BTF_ID_LIST(name)                       \
.global name;                                   \
name:                

#define ZERO .zero 4

.data

BTF_ID_LIST(btf_whitelist_d_path)
BTF_ID(func, vfs_truncate)
BTF_ID(func, vfs_fallocate)
BTF_ID(func, krava)
ZERO

BTF_ID_LIST(bpf_skb_output_btf_ids)
BTF_ID(struct, sk_buff)

