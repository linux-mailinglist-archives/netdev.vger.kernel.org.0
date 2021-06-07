Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D2B39E662
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhFGSVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhFGSVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623089958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yjGtNlz0YSV75CHNPH9tpJ1XPnNMcmYEPEhB0Rb7CaA=;
        b=ZIIPJ66tiqCFgejXbEV89c7eeE/CPh3MLyuYaRb3aaZrfDduaRF+t1RQrcwixh3DFZF1Dx
        318kdlxKgn/Nt0sU6rGfLQkKd0sNarFDn5WaoZupIKweaeMnq7Z6XIF5yBMyLY/LTklxbj
        IK3cx0UyJQ09iEu8vmc/6+WgVlYruWk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-7qi5iDKNP3CPHBaEBypoRQ-1; Mon, 07 Jun 2021 14:19:17 -0400
X-MC-Unique: 7qi5iDKNP3CPHBaEBypoRQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 137E71020C36;
        Mon,  7 Jun 2021 18:19:01 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id DE43970139;
        Mon,  7 Jun 2021 18:18:49 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:18:48 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 11/19] bpf: Add support to load multi func tracing program
Message-ID: <YL5jCPZhmMxfFy26@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-12-jolsa@kernel.org>
 <db5c591c-c5f2-9bcc-28bf-f5890c2cf61c@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db5c591c-c5f2-9bcc-28bf-f5890c2cf61c@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 08:56:47PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > Adding support to load tracing program with new BPF_F_MULTI_FUNC flag,
> > that allows the program to be loaded without specific function to be
> > attached to.
> > 
> > The verifier assumes the program is using all (6) available arguments
> 
> Is this a verifier failure or it is due to the check in the
> beginning of function arch_prepare_bpf_trampoline()?
> 
>         /* x86-64 supports up to 6 arguments. 7+ can be added in the future
> */
>         if (nr_args > 6)
>                 return -ENOTSUPP;

yes, that's the limit.. it allows the traced program to
touch 6 arguments, because it's the maximum for JIT

> 
> If it is indeed due to arch_prepare_bpf_trampoline() maybe we
> can improve it instead of specially processing the first argument
> "ip" in quite some places?

do you mean to teach JIT to process more than 6 arguments?

> 
> > as unsigned long values. We can't add extra ip argument at this time,
> > because JIT on x86 would fail to process this function. Instead we
> > allow to access extra first 'ip' argument in btf_ctx_access.
> > 
> > Such program will be allowed to be attached to multiple functions
> > in following patches.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   include/linux/bpf.h            |  1 +
> >   include/uapi/linux/bpf.h       |  7 +++++++
> >   kernel/bpf/btf.c               |  5 +++++
> >   kernel/bpf/syscall.c           | 35 +++++++++++++++++++++++++++++-----
> >   kernel/bpf/verifier.c          |  3 ++-
> >   tools/include/uapi/linux/bpf.h |  7 +++++++
> >   6 files changed, 52 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 6cbf3c81c650..23221e0e8d3c 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -845,6 +845,7 @@ struct bpf_prog_aux {
> >   	bool sleepable;
> >   	bool tail_call_reachable;
> >   	struct hlist_node tramp_hlist;
> > +	bool multi_func;
> 
> Move this field right after "tail_call_reachable"?
> 
> >   	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
> >   	const struct btf_type *attach_func_proto;
> >   	/* function name for valid attach_btf_id */
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 2c1ba70abbf1..ad9340fb14d4 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1109,6 +1109,13 @@ enum bpf_link_type {
> >    */
> >   #define BPF_F_SLEEPABLE		(1U << 4)
> > +/* If BPF_F_MULTI_FUNC is used in BPF_PROG_LOAD command, the verifier does
> > + * not expect BTF ID for the program, instead it assumes it's function
> > + * with 6 u64 arguments. No trampoline is created for the program. Such
> > + * program can be attached to multiple functions.
> > + */
> > +#define BPF_F_MULTI_FUNC	(1U << 5)
> > +
> >   /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
> >    * the following extensions:
> >    *
> > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > index a6e39c5ea0bf..c233aaa6a709 100644
> > --- a/kernel/bpf/btf.c
> > +++ b/kernel/bpf/btf.c
> > @@ -4679,6 +4679,11 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
> >   		args++;
> >   		nr_args--;
> >   	}
> > +	if (prog->aux->multi_func) {
> > +		if (arg == 0)
> > +			return true;
> > +		arg--;
> 
> Some comments in the above to mention like "the first 'ip' argument
> is omitted" will be good.

will do, thanks

jirka

> 
> > +	}
> >   	if (arg > nr_args) {
> >   		bpf_log(log, "func '%s' doesn't have %d-th argument\n",
> [...]
> 

