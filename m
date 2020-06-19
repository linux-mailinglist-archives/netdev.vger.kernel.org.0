Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01704200A2F
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732690AbgFSNbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:31:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41001 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731492AbgFSNbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592573496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sZ9FPLuxgTbVXZVBspWqIt950orFJGux6lJYT8o58ec=;
        b=AALW0mpZM9lb75XzS1bUkDVbUdicSZz6/47wMj6qt9ZKMsmTUKn48Y/YdkAtq/fpcPQ9F4
        qiSuEmdMmjgzgySc6FwQ6zi+lPVzYVFDYlMoQJ2M+xMysx4VhrecNLcYvjVuZnllzD3XNL
        bEvYuZ8/eoCqC721P712y9raJlPjl2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-EErLBOzgPtqqR7DbkHfYtQ-1; Fri, 19 Jun 2020 09:31:31 -0400
X-MC-Unique: EErLBOzgPtqqR7DbkHfYtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDEFD8035CA;
        Fri, 19 Jun 2020 13:31:28 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id 7B5E510013C4;
        Fri, 19 Jun 2020 13:31:25 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:31:24 +0200
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
Message-ID: <20200619133124.GJ2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-10-jolsa@kernel.org>
 <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY=d5y_-fXvomG7SjkbK7DZn5=-f+sdCYRdZh9qeynQrQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:35:10PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:07 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding d_path helper function that returns full path
> > for give 'struct path' object, which needs to be the
> > kernel BTF 'path' object.
> >
> > The helper calls directly d_path function.
> >
> > Updating also bpf.h tools uapi header and adding
> > 'path' to bpf_helpers_doc.py script.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h            |  4 ++++
> >  include/uapi/linux/bpf.h       | 14 ++++++++++++-
> >  kernel/bpf/btf_ids.c           | 11 ++++++++++
> >  kernel/trace/bpf_trace.c       | 38 ++++++++++++++++++++++++++++++++++
> >  scripts/bpf_helpers_doc.py     |  2 ++
> >  tools/include/uapi/linux/bpf.h | 14 ++++++++++++-
> >  6 files changed, 81 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index a94e85c2ec50..d35265b6c574 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -1752,5 +1752,9 @@ extern int bpf_skb_output_btf_ids[];
> >  extern int bpf_seq_printf_btf_ids[];
> >  extern int bpf_seq_write_btf_ids[];
> >  extern int bpf_xdp_output_btf_ids[];
> > +extern int bpf_d_path_btf_ids[];
> > +
> > +extern int btf_whitelist_d_path[];
> > +extern int btf_whitelist_d_path_cnt;
> 
> So with suggestion from previous patch, this would be declared as:
> 
> extern const struct btf_id_set btf_whitelist_d_path;

yes

SNIP

> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/bpf/btf_ids.c b/kernel/bpf/btf_ids.c
> > index d8d0df162f04..853c8fd59b06 100644
> > --- a/kernel/bpf/btf_ids.c
> > +++ b/kernel/bpf/btf_ids.c
> > @@ -13,3 +13,14 @@ BTF_ID(struct, seq_file)
> >
> >  BTF_ID_LIST(bpf_xdp_output_btf_ids)
> >  BTF_ID(struct, xdp_buff)
> > +
> > +BTF_ID_LIST(bpf_d_path_btf_ids)
> > +BTF_ID(struct, path)
> > +
> > +BTF_WHITELIST_ENTRY(btf_whitelist_d_path)
> > +BTF_ID(func, vfs_truncate)
> > +BTF_ID(func, vfs_fallocate)
> > +BTF_ID(func, dentry_open)
> > +BTF_ID(func, vfs_getattr)
> > +BTF_ID(func, filp_close)
> > +BTF_WHITELIST_END(btf_whitelist_d_path)
> 
> Oh, so that's why you added btf_ids.c. Do you think centralizing all
> those BTF ID lists in one file is going to be more convenient? I lean
> towards keeping them closer to where they are used, as it was with all
> those helper BTF IDS. But I wonder what others think...

either way works for me, but then BTF_ID_* macros needs to go
to include/linux/btf_ids.h header right?

jirka

> 
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index c1866d76041f..0ff5d8434d40 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -1016,6 +1016,42 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
> >         .arg1_type      = ARG_ANYTHING,
> >  };
> >
> 
> [...]
> 

