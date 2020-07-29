Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30080231DB2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgG2Lyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:54:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:27138 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgG2Lyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 07:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596023679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpsTSYXjeeeVqBmEzFVl5yuK75B5cM9L+lalZA+cwK8=;
        b=MKJTLbps4F7aPCBRGR7YjuPiX4sX1ezZbpM557W/JGE9DLyujRToosW00rA4UuCbClnhL2
        T6b3xX4fuoEPYnn7w09cXnv+mrt7+agkrjdG8qS04stGEwacM+FKr8YaVNuSfnQz1Li+rb
        Lnh2BTBouP4HDy6EyF9LfkfMkYhKIKc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-Fd7Tv3aDPPiqvyzxZT_YWQ-1; Wed, 29 Jul 2020 07:54:37 -0400
X-MC-Unique: Fd7Tv3aDPPiqvyzxZT_YWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D29E5800460;
        Wed, 29 Jul 2020 11:54:34 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id E4E7775559;
        Wed, 29 Jul 2020 11:54:30 +0000 (UTC)
Date:   Wed, 29 Jul 2020 13:54:29 +0200
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
Subject: Re: [PATCH v8 bpf-next 08/13] bpf: Add BTF_SET_START/END macros
Message-ID: <20200729115429.GI1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-9-jolsa@kernel.org>
 <CAEf4BzbwJ+FXYWOK2k6UZ8X1f-2XQP1rRLFAFO6_OyK2iKv8Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbwJ+FXYWOK2k6UZ8X1f-2XQP1rRLFAFO6_OyK2iKv8Eg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:39:06PM -0700, Andrii Nakryiko wrote:

SNIP

> 
> [...]
> 
> > +#define BTF_SET_START(name)                            \
> > +__BTF_ID_LIST(name, local)                             \
> > +asm(                                                   \
> > +".pushsection " BTF_IDS_SECTION ",\"a\";       \n"     \
> > +".local __BTF_ID__set__" #name ";              \n"     \
> > +"__BTF_ID__set__" #name ":;                    \n"     \
> > +".zero 4                                       \n"     \
> > +".popsection;                                  \n");
> > +
> > +#define BTF_SET_END(name)                              \
> > +asm(                                                   \
> > +".pushsection " BTF_IDS_SECTION ",\"a\";      \n"      \
> > +".size __BTF_ID__set__" #name ", .-" #name "  \n"      \
> > +".popsection;                                 \n");    \
> > +extern struct btf_id_set name;
> > +
> >  #else
> 
> This local symbol assumption will probably at some point bite us.
> Yonghong already did global vs static variants for BTF ID list, we'll
> end up doing something like that for sets of BTF IDs as well. Let's do
> this similarly from the get go.

sure, will add that

> 
> >
> >  #define BTF_ID_LIST(name) static u32 name[5];
> >  #define BTF_ID(prefix, name)
> >  #define BTF_ID_UNUSED
> >  #define BTF_ID_LIST_GLOBAL(name) u32 name[1];
> > +#define BTF_SET_START(name) static struct btf_id_set name = { 0 };
> 
> nit: this zero is unnecessary and misleading (it's initialized for
> only the first member of a struct). Just {} is enough.

ok

> 
> > +#define BTF_SET_END(name)
> >
> >  #endif /* CONFIG_DEBUG_INFO_BTF */
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index 562d4453fad3..06714cdda0a9 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/btf_ids.h>
> >  #include <linux/skmsg.h>
> >  #include <linux/perf_event.h>
> > +#include <linux/bsearch.h>
> > +#include <linux/btf_ids.h>
> >  #include <net/sock.h>
> >
> >  /* BTF (BPF Type Format) is the meta data format which describes
> > @@ -4740,3 +4742,15 @@ u32 btf_id(const struct btf *btf)
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
> > +bool btf_id_set_contains(struct btf_id_set *set, u32 id)
> > +{
> > +       return bsearch(&id, set->ids, set->cnt, sizeof(int), btf_id_cmp_func) != NULL;
> 
> very nit ;) sizeof(__u32)

sure ;-)

thanks,
jirka

