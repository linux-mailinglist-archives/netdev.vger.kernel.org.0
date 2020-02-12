Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95E5E15B44F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 00:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbgBLXCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 18:02:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729132AbgBLXCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 18:02:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581548564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8TtOzH2FmPhiDWnA9QucSvlPOnDEqTysjVLOvWon/AY=;
        b=V6HtHB5Dj3TdCIcKKFhYYCi9pvGRlMLNMZGmLobnpSrEIGUYj1xW2turD1GPB7vct73u/g
        Ub3O5Z7WnnpXsZ+MwnFBmC/U6rDCTDhKyYfp1KBYL2tl8YaBKrHrE5MBxuLsCUAthkBYxC
        GfAfEPONhbFrVIJWmF6jnXjM9ilaYs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-H74o7hHrNeeJfRLRx0fjrA-1; Wed, 12 Feb 2020 18:02:40 -0500
X-MC-Unique: H74o7hHrNeeJfRLRx0fjrA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50DEE1800D6B;
        Wed, 12 Feb 2020 23:02:38 +0000 (UTC)
Received: from krava (ovpn-204-72.brq.redhat.com [10.40.204.72])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA2195C139;
        Wed, 12 Feb 2020 23:02:34 +0000 (UTC)
Date:   Thu, 13 Feb 2020 00:02:32 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 12/14] bpf: Add trampolines to kallsyms
Message-ID: <20200212230232.GC233036@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-13-jolsa@kernel.org>
 <CAEf4BzZFBYVAs5-LowuMov86cbNFdXABkcA=XZAC2JJWg52HKg@mail.gmail.com>
 <20200212111000.GE183981@krava>
 <CAEf4BzZEVOZ36xx882WO30ReG=jkazug-gmWnXhxmA8Ka6PuhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZEVOZ36xx882WO30ReG=jkazug-gmWnXhxmA8Ka6PuhQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 08:33:49AM -0800, Andrii Nakryiko wrote:

SNIP

> > > >         tr->image = image;
> > > > +       INIT_LIST_HEAD_RCU(&tr->ksym.lnode);
> > > >  out:
> > > >         mutex_unlock(&trampoline_mutex);
> > > >         return tr;
> > > > @@ -267,6 +277,15 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(enum bpf_attach_type t)
> > > >         }
> > > >  }
> > > >
> > > > +static void bpf_trampoline_kallsyms_add(struct bpf_trampoline *tr)
> > > > +{
> > > > +       struct bpf_ksym *ksym = &tr->ksym;
> > > > +
> > > > +       snprintf(ksym->name, KSYM_NAME_LEN, "bpf_trampoline_%llu",
> > > > +                tr->key & ((u64) (1LU << 32) - 1));
> > >
> > > why the 32-bit truncation? also, wouldn't it be more trivial as (u32)tr->key?
> >
> > tr->key can have the target prog id in upper 32 bits,
> 
> True, but not clear why it's bad? It's not a security concern, because
> those IDs are already exposed (you can dump them from bpftool). On the
> other hand, by cutting out part of key, you make symbols potentially
> ambiguous, with different trampolines marked with the same name in
> kallsyms, which is just going to be confusing to users/tools.

ugh ok, I did not see the target bpf program case clearly,
will include the whole tr->key

thanks,
jirka

