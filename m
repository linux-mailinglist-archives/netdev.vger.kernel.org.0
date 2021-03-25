Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3860D349BC0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhCYVkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230461AbhCYVjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616708380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qKGZ4GxdANeA/68pqARSSE65XVufZgY7DXoZ34pi4Tk=;
        b=cWUhLtt05YSIB37qgcd/vDIvCLKg055X8AjR28dVtgct/Q2KeZk7V8QIw/KzYAmNCHhCKC
        tLQfJUeaABhzRHSEINYfmREPenbYgc1yKFKRWmrP8oFYz/QY2BCQF0TR8+EyCcv4rRpK1t
        vfv96b+axM6SSGy6WLve/s9JzNNtLkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-KoJOslzTOcKLVX9u6s4h8g-1; Thu, 25 Mar 2021 17:39:36 -0400
X-MC-Unique: KoJOslzTOcKLVX9u6s4h8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D34EA10AF38C;
        Thu, 25 Mar 2021 21:39:34 +0000 (UTC)
Received: from krava (unknown [10.40.193.25])
        by smtp.corp.redhat.com (Postfix) with SMTP id 505E35D9CA;
        Thu, 25 Mar 2021 21:39:31 +0000 (UTC)
Date:   Thu, 25 Mar 2021 22:39:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv2] bpf: Take module reference for trampoline in module
Message-ID: <YF0DEq7KBuk79bBq@krava>
References: <20210324174030.2053353-1-jolsa@kernel.org>
 <7cc5c310-c764-99bb-ad59-5ac04402bd5d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cc5c310-c764-99bb-ad59-5ac04402bd5d@iogearbox.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 10:26:32PM +0100, Daniel Borkmann wrote:
> On 3/24/21 6:40 PM, Jiri Olsa wrote:
> > Currently module can be unloaded even if there's a trampoline
> > register in it. It's easily reproduced by running in parallel:
> > 
> >    # while :; do ./test_progs -t module_attach; done
> >    # while :; do rmmod bpf_testmod; sleep 0.5; done
> > 
> > Taking the module reference in case the trampoline's ip is
> > within the module code. Releasing it when the trampoline's
> > ip is unregistered.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > v2 changes:
> >    - fixed ip_module_put to do preempt_disable/preempt_enable
> > 
> >   kernel/bpf/trampoline.c | 31 +++++++++++++++++++++++++++++++
> >   1 file changed, 31 insertions(+)
> > 
> > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > index 1f3a4be4b175..39e4280f94e4 100644
> > --- a/kernel/bpf/trampoline.c
> > +++ b/kernel/bpf/trampoline.c
> > @@ -87,6 +87,26 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> >   	return tr;
> >   }
> > +static struct module *ip_module_get(unsigned long ip)
> > +{
> > +	struct module *mod;
> > +	int err = 0;
> > +
> > +	preempt_disable();
> > +	mod = __module_text_address(ip);
> > +	if (mod && !try_module_get(mod))
> > +		err = -ENOENT;
> > +	preempt_enable();
> > +	return err ? ERR_PTR(err) : mod;
> > +}
> > +
> > +static void ip_module_put(unsigned long ip)
> > +{
> > +	preempt_disable();
> > +	module_put(__module_text_address(ip));
> > +	preempt_enable();
> 
> Could we cache the mod pointer in tr instead of doing another addr search
> for dropping the ref?

right.. I moved it from the ftrace layer where this was not an option,
so I did not realize bpf_trampoline could get extended, will send new
version

thanks,
jirka

> 
> > +}
> > +
> >   static int is_ftrace_location(void *ip)
> >   {
> >   	long addr;
> > @@ -108,6 +128,9 @@ static int unregister_fentry(struct bpf_trampoline *tr, void *old_addr)
> >   		ret = unregister_ftrace_direct((long)ip, (long)old_addr);
> >   	else
> >   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, old_addr, NULL);
> > +
> > +	if (!ret)
> > +		ip_module_put((unsigned long) ip);
> >   	return ret;
> >   }
> > @@ -126,6 +149,7 @@ static int modify_fentry(struct bpf_trampoline *tr, void *old_addr, void *new_ad
> >   /* first time registering */
> >   static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
> >   {
> > +	struct module *mod;
> >   	void *ip = tr->func.addr;
> >   	int ret;
> > @@ -134,10 +158,17 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
> >   		return ret;
> >   	tr->func.ftrace_managed = ret;
> > +	mod = ip_module_get((unsigned long) ip);
> > +	if (IS_ERR(mod))
> > +		return -ENOENT;
> > +
> >   	if (tr->func.ftrace_managed)
> >   		ret = register_ftrace_direct((long)ip, (long)new_addr);
> >   	else
> >   		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> > +
> > +	if (ret)
> > +		module_put(mod);
> >   	return ret;
> >   }
> > 
> 

