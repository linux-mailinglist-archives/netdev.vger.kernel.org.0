Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435E3479EC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbhCXNs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235407AbhCXNsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616593698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QHQRvsM7dTA+mGVVFFUUQLQlWpIhbOfd5Hm9ljWiRQs=;
        b=PjSaQrtSa+EbclITbYNRbr71r/Y7VUaR1EpIMUdyanq7jDfPnZHKl1E7K/USeQI82CP7Q7
        CzT9vspl8foTJWGBFG0slRV6peYSI8rYreZI6+lFKx/BagoxkDRXWNhgGWpxrD8mMKVIJ4
        GEn3GOK/MySX+vuvMie075EvxWXvXJE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-VvCc3_a7Mh2f1hyAmOYYAA-1; Wed, 24 Mar 2021 09:48:14 -0400
X-MC-Unique: VvCc3_a7Mh2f1hyAmOYYAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C383BFF97;
        Wed, 24 Mar 2021 13:47:44 +0000 (UTC)
Received: from krava (unknown [10.40.196.25])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4E1EE843E8;
        Wed, 24 Mar 2021 13:47:41 +0000 (UTC)
Date:   Wed, 24 Mar 2021 14:47:40 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH bpf] bpf: Take module reference for ip in module code
Message-ID: <YFtC/O399QhHZtpb@krava>
References: <20210323211533.1931242-1-jolsa@kernel.org>
 <20210324012237.65pf4s52oqlicea3@ast-mbp>
 <YFsjGkIwpXm5IYdR@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFsjGkIwpXm5IYdR@krava>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 12:31:42PM +0100, Jiri Olsa wrote:
> On Tue, Mar 23, 2021 at 06:22:37PM -0700, Alexei Starovoitov wrote:
> > On Tue, Mar 23, 2021 at 10:15:33PM +0100, Jiri Olsa wrote:
> > > Currently module can be unloaded even if there's a trampoline
> > > register in it. It's easily reproduced by running in parallel:
> > > 
> > >   # while :; do ./test_progs -t module_attach; done
> > >   # while :; do ./test_progs -t fentry_test; done
> > > 
> > > Taking the module reference in case the trampoline's ip is
> > > within the module code. Releasing it when the trampoline's
> > > ip is unregistered.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/bpf/trampoline.c | 32 ++++++++++++++++++++++++++++++++
> > >  1 file changed, 32 insertions(+)
> > > 
> > > diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> > > index 1f3a4be4b175..f6cb179842b2 100644
> > > --- a/kernel/bpf/trampoline.c
> > > +++ b/kernel/bpf/trampoline.c
> > > @@ -87,6 +87,27 @@ static struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
> > >  	return tr;
> > >  }
> > >  
> > > +static struct module *ip_module_get(unsigned long ip)
> > > +{
> > > +	struct module *mod;
> > > +	int err = 0;
> > > +
> > > +	preempt_disable();
> > > +	mod = __module_text_address(ip);
> > > +	if (mod && !try_module_get(mod))
> > > +		err = -ENOENT;
> > > +	preempt_enable();
> > > +	return err ? ERR_PTR(err) : mod;
> > > +}
> > > +
> > > +static void ip_module_put(unsigned long ip)
> > > +{
> > > +	struct module *mod = __module_text_address(ip);
> > 
> > Conceptually looks correct, but how did you test it?!
> > Just doing your reproducer:
> > while :; do ./test_progs -t module_attach; done & while :; do ./test_progs -t fentry_test; done
> > 
> > I immediately hit:
> > [   19.461162] WARNING: CPU: 1 PID: 232 at kernel/module.c:264 module_assert_mutex_or_preempt+0x2e/0x40
> > [   19.477126] Call Trace:
> > [   19.477464]  __module_address+0x28/0xf0
> > [   19.477865]  ? __bpf_trace_bpf_testmod_test_write_bare+0x10/0x10 [bpf_testmod]
> > [   19.478711]  __module_text_address+0xe/0x60
> > [   19.479156]  bpf_trampoline_update+0x2ff/0x470
> 
> I don't have lockdep enabled.. ah the module_mutex is held
> during module init, that's why all the code I was using as
> a reference did not take it.. sorry, will fix

ah it's the missing preempt_disable ;-) ok

jirka

> 
> > 
> > Which points to an obvious bug above.
> > 
> > How did you debug it to this module going away issue?
> > Why does test_progs -t fentry_test help to repro?
> > Or does it?
> > It doesn't touch anything in modules.
> 
> test_prog also loads/unloads that module, but it could be
> just insmod/rmmod instead, will change
> 
> jirka

