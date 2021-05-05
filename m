Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2BA373BA1
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhEEMny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 08:43:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232156AbhEEMny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 08:43:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620218577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mACDaNKuFsQiSrOafQEeeFQZn+8+UCkvYXgXRovm9Yw=;
        b=cEMxmK/spFyqnjH6CAi9HP5iFdzHN+wZP8uC1MkJ9DLxcKt5Ti8WFtGl5ogxDGJk1vAfuL
        DxpkaKmSuCNtSfGJGdIOKfRWUvOhOXsnkoer2RzypnJSKqUVet3pFB8fa6kSYqIMA3XDOR
        niLm2etXwv2wUr1rPLIhqKXVlog+Hs8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-8f8kTu8APFeAHM60J5fjhw-1; Wed, 05 May 2021 08:42:53 -0400
X-MC-Unique: 8f8kTu8APFeAHM60J5fjhw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 850888049C5;
        Wed,  5 May 2021 12:42:51 +0000 (UTC)
Received: from krava (unknown [10.40.195.238])
        by smtp.corp.redhat.com (Postfix) with SMTP id 8FB2D1062249;
        Wed,  5 May 2021 12:42:48 +0000 (UTC)
Date:   Wed, 5 May 2021 14:42:47 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH RFC] bpf: Fix trampoline for functions with variable
 arguments
Message-ID: <YJKSx9qLB432dCWs@krava>
References: <20210429212834.82621-1-jolsa@kernel.org>
 <YI8WokIxTkZvzVuP@krava>
 <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com>
 <YJFLpAbUiwIu0I4H@krava>
 <CAEf4BzYz3G4aRWT4YTrnKaVCsE_A2UGGn6jVvqOuK8ZLU-sN8g@mail.gmail.com>
 <CAADnVQ+V=2qOqkVMaC72uhQKEbC=2uFa80J57xdF_4ffoZHYNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+V=2qOqkVMaC72uhQKEbC=2uFa80J57xdF_4ffoZHYNQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 09:11:26PM -0700, Alexei Starovoitov wrote:

SNIP

> > > > >
> > > > > actualy looks like we need to disable functions with variable arguments
> > > > > completely, because we don't know how many arguments to save
> > > > >
> > > > > I tried to disable them in pahole and it's easy fix, will post new fix
> > > >
> > > > Can we still allow access to fixed arguments for such functions and
> > > > just disallow the vararg ones?
> > >
> > > the problem is that we should save all the registers for arguments,
> > > which is probably doable.. but if caller uses more than 6 arguments,
> > > we need stack data, which will be wrong because of the extra stack
> > > frame we do in bpf trampoline.. so we could crash
> > >
> > > the patch below prevents to attach these functions directly in kernel,
> > > so we could keep these functions in BTF
> > >
> > > jirka
> > >
> > >
> > > ---
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 0600ed325fa0..f9709dc08c44 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -5213,6 +5213,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
> > >                                 tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
> > >                         return -EINVAL;
> > >                 }
> > > +               if (ret == 0) {
> > > +                       bpf_log(log,
> > > +                               "The function %s has variable args, it's unsupported.\n",
> > > +                               tname);
> > > +                       return -EINVAL;
> > > +
> > > +               }
> >
> > this will work, but the explicit check for vararg should be `i ==
> > nargs - 1 && args[i].type == 0`. Everything else (if it happens) is
> > probably a bad BTF data.
> 
> Jiri,
> could you please resubmit with the check like Andrii suggested?
> Thanks!
> 

yes, will send it later today

jirka

