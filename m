Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC78263655
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgIIS7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:59:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726728AbgIIS7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599677945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tIwdcKEFHnsM+XiZhz0XH+MlJswdkMBFHeWkGLG/J7w=;
        b=EAT7KM1M49SjQT7wfOr89p6A/IjWuPS6OYNYYFdxskgiWELxfZhJnTvOH/WY4N3+zgXhro
        /XwwEhrwcqSpfbtRG23ME/9q/y0amrpSFXu+nUrXly6Ka6w3R0knn8H36dJrojpajuGjfd
        o3LD0oo4RoBb/X7OIJq/d0gBxSpgc7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-3bMlHFfDNWqN2YT4CViSJg-1; Wed, 09 Sep 2020 14:59:01 -0400
X-MC-Unique: 3bMlHFfDNWqN2YT4CViSJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC6F2100855A;
        Wed,  9 Sep 2020 18:58:59 +0000 (UTC)
Received: from krava (unknown [10.40.192.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A41C6E70B;
        Wed,  9 Sep 2020 18:58:39 +0000 (UTC)
Date:   Wed, 9 Sep 2020 20:58:38 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eelco Chaudron <echaudro@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Fix context type resolving for
 extension programs
Message-ID: <20200909185838.GG1498025@krava>
References: <20200909151115.1559418-1-jolsa@kernel.org>
 <871rjbc5d9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <871rjbc5d9.fsf@toke.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 09, 2020 at 05:54:58PM +0200, Toke Høiland-Jørgensen wrote:
> Jiri Olsa <jolsa@kernel.org> writes:
> 
> > Eelco reported we can't properly access arguments if the tracing
> > program is attached to extension program.
> >
> > Having following program:
> >
> >   SEC("classifier/test_pkt_md_access")
> >   int test_pkt_md_access(struct __sk_buff *skb)
> >
> > with its extension:
> >
> >   SEC("freplace/test_pkt_md_access")
> >   int test_pkt_md_access_new(struct __sk_buff *skb)
> >
> > and tracing that extension with:
> >
> >   SEC("fentry/test_pkt_md_access_new")
> >   int BPF_PROG(fentry, struct sk_buff *skb)
> >
> > It's not possible to access skb argument in the fentry program,
> > with following error from verifier:
> >
> >   ; int BPF_PROG(fentry, struct sk_buff *skb)
> >   0: (79) r1 = *(u64 *)(r1 +0)
> >   invalid bpf_context access off=0 size=8
> >
> > The problem is that btf_ctx_access gets the context type for the
> > traced program, which is in this case the extension.
> >
> > But when we trace extension program, we want to get the context
> > type of the program that the extension is attached to, so we can
> > access the argument properly in the trace program.
> >
> > Reported-by: Eelco Chaudron <echaudro@redhat.com>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/bpf/btf.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index f9ac6935ab3c..37ad01c32e5a 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -3859,6 +3859,14 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >  	}
> >  
> >  	info->reg_type = PTR_TO_BTF_ID;
> > +
> > +	/* When we trace extension program, we want to get the context
> > +	 * type of the program that the extension is attached to, so
> > +	 * we can access the argument properly in the trace program.
> > +	 */
> > +	if (tgt_prog && tgt_prog->type == BPF_PROG_TYPE_EXT)
> > +		tgt_prog = tgt_prog->aux->linked_prog;
> > +
> 
> In the discussion about multi-attach for freplace we kinda concluded[0]
> that this linked_prog pointer was going away after attach. I have this
> basically working, but need to test a bit more before posting it (see
> [1] for current status).

ok, feel free to use the test case from patch 2 ;-)

> 
> But with this I guess we'll need to either do something different? Maybe
> go chase down the target via the bpf_link or something?

I'll check, could you please CC me on your next post?

thanks,
jirka

