Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A082032AD
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgFVJCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:02:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbgFVJCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592816536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=le78y5frfkNmsXZTYDe6cPJby+DCPkzGDKyYNl1SlEc=;
        b=RUm7n4zyyfWZPkTPMFieCrplQOPMPQnXp8BSU1sClCGPXraK3Uyy89T0In72VMfCLG0nrx
        ZuaxKb2ITGtYL24p3z218aUZiWDk0lmUCfdlM69+EXOsjsQDl4zKd/9tvYX97xZZYOboVF
        GkGMAjgXacZQTWFDh5v6rs90eJrHYdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-9M2q-_1-NjyluP2mb3xrrA-1; Mon, 22 Jun 2020 05:02:12 -0400
X-MC-Unique: 9M2q-_1-NjyluP2mb3xrrA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E1C835B40;
        Mon, 22 Jun 2020 09:02:10 +0000 (UTC)
Received: from krava (unknown [10.40.193.171])
        by smtp.corp.redhat.com (Postfix) with SMTP id 64F6C7166E;
        Mon, 22 Jun 2020 09:02:06 +0000 (UTC)
Date:   Mon, 22 Jun 2020 11:02:05 +0200
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
Subject: Re: [PATCH 09/11] bpf: Add d_path helper
Message-ID: <20200622090205.GD2556590@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
 <20200619133124.GJ2465907@krava>
 <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZDCtW-5r5rN+ufZi1hUXjw8QCF+CiyT5sOvQQEEOqtiQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:25:27AM -0700, Andrii Nakryiko wrote:

SNIP

> > > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > > >   * function eBPF program intends to call
> > > > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > > > index d8d0df162f04..853c8fd59b06 100644
> > > > --- a/kernel/bpf/btf_ids.c
> > > > +++ b/kernel/bpf/btf_ids.c
> > > > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> > > >
> > > >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> > > >  BTF_ID(struct, xdp_buff)
> > > > +
> > > > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > > > +BTF_ID(struct, path)
> > > > +
> > > > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > > > +BTF_ID(func, vfs_truncate)
> > > > +BTF_ID(func, vfs_fallocate)
> > > > +BTF_ID(func, dentry_open)
> > > > +BTF_ID(func, vfs_getattr)
> > > > +BTF_ID(func, filp_close)
> > > > +BTF_WHITELIST_END(btf_whitelist_d_path)
> > >
> > > Oh, so that's why you added btf_ids.c. Do you think centralizing all
> > > those BTF ID lists in one file is going to be more convenient? I lean
> > > towards keeping them closer to where they are used, as it was with all
> > > those helper BTF IDS. But I wonder what others think...
> >
> > either way works for me, but then BTF_ID_* macros needs to go
> > to include/linux/btf_ids.h header right?
> >
> 
> given it's internal API, I'd probably just put it in
> include/linux/btf.h or include/linux/bpf.h, don't think we need extra
> header just for these

actually, I might end up with extra header, so it's possible
to add selftest for this

jirka

