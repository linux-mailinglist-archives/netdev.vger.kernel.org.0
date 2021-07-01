Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C003B9209
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhGANMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 09:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236589AbhGANMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 09:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C107C601FC;
        Thu,  1 Jul 2021 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625145021;
        bh=WC5jwdBx0yl8AOpn4ghT85ryBnuwBhFmc2vmYUaxdXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dIhBaqn8HDYEMV7/9iDilARj54VDRe2MA+qWp/lRtepTb0kRnXwePbzT/NzRHcet2
         e8YvgwlbFOS0/czx8D4Eq7+NcRKixr+QpOohATk6S+6baBk3EonKqFZ2CJeD9fKtBv
         df+ZTFhjsrsMMwECmyK48h7xnPIg2Buf0ZNVjDE0zcVCUpBUhqNLavJmSr+KjGiWW7
         tliRSksv6un2+lAB/cNJm7nmbJpp5gv3uRHlFVvTVc+SoMLpQppz2J/fOjPDdvdBqB
         DaK0+h4oOnnvS4mzVxjElmdIr7Fvd/ZdhPxhNU7dJ12Q7xKEeFJbrJsP0/cHHTa5g9
         lgQQMJmq7CDvA==
Date:   Thu, 1 Jul 2021 22:10:18 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 4/5] bpf: Add bpf_get_func_ip helper for kprobe
 programs
Message-Id: <20210701221018.2ce894f2eea36936d1df2ceb@kernel.org>
In-Reply-To: <YN1+9osJ4NhqZK/j@krava>
References: <20210629192945.1071862-1-jolsa@kernel.org>
        <20210629192945.1071862-5-jolsa@kernel.org>
        <9286ce63-5cba-e16a-a7db-886548a04a64@fb.com>
        <20210701085854.0f2aeafc0fce11f3ca9d52a8@kernel.org>
        <YN1+9osJ4NhqZK/j@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Jul 2021 10:38:14 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Jul 01, 2021 at 08:58:54AM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > > >   		return &bpf_override_return_proto;
> > > >   #endif
> > > > +	case BPF_FUNC_get_func_ip:
> > > > +		return &bpf_get_func_ip_proto_kprobe;
> > > >   	default:
> > > >   		return bpf_tracing_func_proto(func_id, prog);
> > > >   	}
> > > > diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> > > > index ea6178cb5e33..b07d5888db14 100644
> > > > --- a/kernel/trace/trace_kprobe.c
> > > > +++ b/kernel/trace/trace_kprobe.c
> > > > @@ -1570,6 +1570,18 @@ static int kretprobe_event_define_fields(struct trace_event_call *event_call)
> > > >   }
> > > >   
> > > >   #ifdef CONFIG_PERF_EVENTS
> > > > +/* Used by bpf get_func_ip helper */
> > > > +DEFINE_PER_CPU(u64, current_kprobe_addr) = 0;
> > > 
> > > Didn't check other architectures. But this should work
> > > for x86 where if nested kprobe happens, the second
> > > kprobe will not call kprobe handlers.
> > 
> > No problem, other architecture also does not call nested kprobes handlers.
> > However, you don't need this because you can use kprobe_running()
> > in kprobe context.
> > 
> > kp = kprobe_running();
> > if (kp)
> > 	return kp->addr;
> 
> great, that's easier
> 
> > 
> > BTW, I'm not sure why don't you use instruction_pointer(regs)?
> 
> I tried that but it returns function address + 1,
> and I thought that could be different on each arch
> and we'd need arch specific code to deal with that

Oh, I got it. Yes, since it emulates the int3 interruption, the
regs->ip must be kp->addr + 1 on x86. And indeed, it depends
on each arch.

Thank you,

> 
> thanks,
> jirka
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
