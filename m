Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51D2324F0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgG2SzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:55:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726365AbgG2SzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 14:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596048911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HP2WV24a7sGcCziuK1Df6/63OJKTSQXyapplnTgZGYw=;
        b=SY6KRJhUE2xU+NTWyDHogU2oHRbzFNRMRlE/M7hwAUYFU5eNYD1VZ9UUESajsCKXiwPM8G
        44SaTq379m+11HGAPIWoovFwcpery9Oenw/mF6vYDQQSG8WCe4LIuYNgsRt1BAUaqrycwM
        MFsfXX13h/1pdt74uTQk2tiwHRr15EI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-8gy1ArkENoq9GT5uyYVSFw-1; Wed, 29 Jul 2020 14:55:09 -0400
X-MC-Unique: 8gy1ArkENoq9GT5uyYVSFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 877AA8005B0;
        Wed, 29 Jul 2020 18:55:07 +0000 (UTC)
Received: from krava (unknown [10.40.193.247])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5E49E100EBA4;
        Wed, 29 Jul 2020 18:55:01 +0000 (UTC)
Date:   Wed, 29 Jul 2020 20:55:00 +0200
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
Subject: Re: [PATCH v8 bpf-next 07/13] bpf: Add btf_struct_ids_match function
Message-ID: <20200729185500.GN1319041@krava>
References: <20200722211223.1055107-1-jolsa@kernel.org>
 <20200722211223.1055107-8-jolsa@kernel.org>
 <CAEf4BzacqauEc8=o29EBUsmvTMs3FZ+-Kcc4cSJ9Te4yh5-7qg@mail.gmail.com>
 <20200729160419.GM1319041@krava>
 <CAEf4BzZ26StciUpDas1Mdi1gY_LJChjkUEBvqzuZuhFuAAibLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZ26StciUpDas1Mdi1gY_LJChjkUEBvqzuZuhFuAAibLQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 10:51:26AM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 29, 2020 at 9:04 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Tue, Jul 28, 2020 at 04:35:16PM -0700, Andrii Nakryiko wrote:
> >
> > SNIP
> >
> > > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > > index bae557ff2da8..c981e258fed3 100644
> > > > --- a/include/linux/bpf.h
> > > > +++ b/include/linux/bpf.h
> > > > @@ -1306,6 +1306,8 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > > >                       const struct btf_type *t, int off, int size,
> > > >                       enum bpf_access_type atype,
> > > >                       u32 *next_btf_id);
> > > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > > +                         int off, u32 id, u32 mid);
> > > >  int btf_resolve_helper_id(struct bpf_verifier_log *log,
> > > >                           const struct bpf_func_proto *fn, int);
> > > >
> > > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > > index 1ab5fd5bf992..562d4453fad3 100644
> > > > --- a/kernel/bpf/btf.c
> > > > +++ b/kernel/bpf/btf.c
> > > > @@ -4140,6 +4140,35 @@ int btf_struct_access(struct bpf_verifier_log *log,
> > > >         return -EINVAL;
> > > >  }
> > > >
> > > > +bool btf_struct_ids_match(struct bpf_verifier_log *log,
> > > > +                         int off, u32 id, u32 mid)
> 
> just realized that if id == mid and off == 0, btf_struct_ids_match()
> will return false. Right now verifier is careful to not call
> btf_struct_ids_match in such case, but I wonder if it's better to make
> that (common) case also work?

right, also we should call btf_struct_ids_match when
IDs are equal and off != 0, which we don't do now

jirka

