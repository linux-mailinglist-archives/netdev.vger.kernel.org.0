Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB34B4872D0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 06:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiAGFm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 00:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiAGFm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 00:42:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90D3C061245;
        Thu,  6 Jan 2022 21:42:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF4A3B824DA;
        Fri,  7 Jan 2022 05:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85692C36AE9;
        Fri,  7 Jan 2022 05:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641534174;
        bh=a1MizlBW2TF0dnN8rkq7UcavB85V1091/Nkz6UsWonU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V5H/uO3ODGv6QkGOUWQBUJF4XMV0sxnXq2xjUUTmKTUe0vsWBql7vlNUZ7RSys2rj
         pvccdrtIbegd3qcW1xsCwUKw9fDMVJtF8PREWFFudd8LGHmwi6uLpW/b/ChvAzHfMj
         Xg3WruUWIxVaobM2lSrSyvNfkpocrWTBLyvznd+fQrsQQ0brguJRfooA8icOZlpuhh
         yIkJrGV0Ill8Sj7lfzKxuML2FEeSN+DALtI3TgtI1vxFXSl4+9Y80iQClnhJgO4LrA
         SLevGjbof6n1SS2vp6Xng6Ms8E9td8nlbsQDCLR39wVQMaBZ12wGYeRDXTo4r5O2DQ
         9ZfQvYeY8FBBA==
Date:   Fri, 7 Jan 2022 14:42:47 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC 00/13] kprobe/bpf: Add support to attach multiple kprobes
Message-Id: <20220107144247.caf007b0c080de6a26acbf96@kernel.org>
In-Reply-To: <YdcDRqmgOeOMmyoM@krava>
References: <20220104080943.113249-1-jolsa@kernel.org>
        <20220106002435.d73e4010c93462fbee9ef074@kernel.org>
        <YdaoTuWjEeT33Zzm@krava>
        <20220106225943.87701fcc674202dc3e172289@kernel.org>
        <YdcDRqmgOeOMmyoM@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 15:57:10 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Thu, Jan 06, 2022 at 10:59:43PM +0900, Masami Hiramatsu wrote:
> 
> SNIP
> 
> > > > 
> > > > Hmm, I think there may be a time to split the "kprobe as an 
> > > > interface for the software breakpoint" and "kprobe as a wrapper
> > > > interface for the callbacks of various instrumentations", like
> > > > 'raw_kprobe'(or kswbp) and 'kprobes'.
> > > > And this may be called as 'fprobe' as ftrace_ops wrapper.
> > > > (But if the bpf is enough flexible, this kind of intermediate layer
> > > >  may not be needed, it can use ftrace_ops directly, eventually)
> > > > 
> > > > Jiri, have you already considered to use ftrace_ops from the
> > > > bpf directly? Are there any issues?
> > > > (bpf depends on 'kprobe' widely?)
> > > 
> > > at the moment there's not ftrace public interface for the return
> > > probe merged in, so to get the kretprobe working I had to use
> > > kprobe interface
> > 
> > Yeah, I found that too. We have to ask Steve to salvage it ;)
> 
> I got those patches rebased like half a year ago upstream code,
> so should be easy to revive them

Nice! :)

> 
> > 
> > > but.. there are patches Steven shared some time ago, that do that
> > > and make graph_ops available as kernel interface
> > > 
> > > I recall we considered graph_ops interface before as common attach
> > > layer for trampolines, which was bad, but it might actually make
> > > sense for kprobes
> > 
> > I started working on making 'fprobe' which will provide multiple
> > function probe with similar interface of kprobes. See attached
> > patch. Then you can use it in bpf, maybe with an union like
> > 
> > union {
> > 	struct kprobe kp;	// for function body
> > 	struct fprobe fp;	// for function entry and return
> > };
> > 
> > At this moment, fprobe only support entry_handler, but when we
> > re-start the generic graph_ops interface, it is easy to expand
> > to support exit_handler.
> > If this works, I think kretprobe can be phased out, since at that
> > moment, kprobe_event can replace it with the fprobe exit_handler.
> > (This is a benefit of decoupling the instrumentation layer from
> > the event layer. It can choose the best way without changing
> > user interface.)
> > 
> 
> I can resend out graph_ops patches if you want to base
> it directly on that

Yes, that's very helpful. Now I'm considering to use it (or via fprobe)
from kretprobes like ftrace-based kprobe.

> > > I'll need to check it in more details but I think both graph_ops and
> > > kprobe do about similar thing wrt hooking return probe, so it should
> > > be comparable.. and they are already doing the same for the entry hook,
> > > because kprobe is mostly using ftrace for that
> > > 
> > > we would not need to introduce new program type - kprobe programs
> > > should be able to run from ftrace callbacks just fine
> > 
> > That seems to bind your mind. The program type is just a programing
> > 'model' of the bpf. You can choose the best implementation to provide
> > equal functionality. 'kprobe' in bpf is just a name that you call some
> > instrumentations which can probe kernel code.
> 
> I don't want to introduce new type, there's some dependencies
> in bpf verifier and helpers code we'd need to handle for that
> 
> I'm looking for solution for current kprobe bpf program type
> to be registered for multiple addresses quickly

Yes, as I replied to Alex, the bpf program type itself keeps 'kprobe'.
For example, you've introduced bpf_kprobe_link at [8/13], 

struct bpf_kprobe_link {
	struct bpf_link link;
	union {
		struct kretprobe rp;
		struct fprobe fp;
	};
	bool is_return;
	bool is_fentry;
	kprobe_opcode_t **addrs;
	u32 cnt;
	u64 bpf_cookie;
};

If all "addrs" are function entry, ::fp will be used.
If cnt == 1 then use ::rp.

> > > so we would have:
> > >   - kprobe type programs attaching to:
> > >   - new BPF_LINK_TYPE_FPROBE link using the graph_ops as attachment layer
> > > 
> > > jirka
> > > 
> > 
> > 
> > -- 
> > Masami Hiramatsu <mhiramat@kernel.org>
> 
> > From 269b86597c166d6d4c5dd564168237603533165a Mon Sep 17 00:00:00 2001
> > From: Masami Hiramatsu <mhiramat@kernel.org>
> > Date: Thu, 6 Jan 2022 15:40:36 +0900
> > Subject: [PATCH] fprobe: Add ftrace based probe APIs
> > 
> > The fprobe is a wrapper API for ftrace function tracer.
> > Unlike kprobes, this probes only supports the function entry, but
> > it can probe multiple functions by one fprobe. The usage is almost
> > same as the kprobe, user will specify the function names by
> > fprobe::syms, the number of syms by fprobe::nsyms, and the user
> > handler by fprobe::handler.
> > 
> > struct fprobe = { 0 };
> > const char *targets[] = {"func1", "func2", "func3"};
> > 
> > fprobe.handler = user_handler;
> > fprobe.nsyms = ARRAY_SIZE(targets);
> > fprobe.syms = targets;
> > 
> > ret = register_fprobe(&fprobe);
> > ...
> > 
> > 
> > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > ---
> >  include/linux/fprobes.h |  52 ++++++++++++++++
> >  kernel/trace/Kconfig    |  10 ++++
> >  kernel/trace/Makefile   |   1 +
> >  kernel/trace/fprobes.c  | 128 ++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 191 insertions(+)
> >  create mode 100644 include/linux/fprobes.h
> >  create mode 100644 kernel/trace/fprobes.c
> > 
> > diff --git a/include/linux/fprobes.h b/include/linux/fprobes.h
> > new file mode 100644
> > index 000000000000..22db748bf491
> > --- /dev/null
> > +++ b/include/linux/fprobes.h
> > @@ -0,0 +1,52 @@
> > +#ifndef _LINUX_FPROBES_H
> > +#define _LINUX_FPROBES_H
> > +/* Simple ftrace probe wrapper */
> > +
> > +#include <linux/compiler.h>
> > +#include <linux/ftrace.h>
> > +
> > +struct fprobe {
> > +	const char		**syms;
> > +	unsigned long		*addrs;
> 
> could you add array of user data for each addr/sym?

OK, something like this?

	void	**user_data;

But note that you need O(N) to search the entry corresponding to
a specific address. To reduce the overhead, we may need to sort
the array in advance (e.g. when registering it).

> 
> SNIP
> 
> > +static int populate_func_addresses(struct fprobe *fp)
> > +{
> > +	unsigned int i;
> > +
> > +	fp->addrs = kmalloc(sizeof(void *) * fp->nsyms, GFP_KERNEL);
> > +	if (!fp->addrs)
> > +		return -ENOMEM;
> > +
> > +	for (i = 0; i < fp->nsyms; i++) {
> > +		fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
> > +		if (!fp->addrs[i]) {
> > +			kfree(fp->addrs);
> > +			fp->addrs = NULL;
> > +			return -ENOENT;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * register_fprobe - Register fprobe to ftrace
> > + * @fp: A fprobe data structure to be registered.
> > + *
> > + * This expects the user set @fp::syms or @fp::addrs (not both),
> > + * @fp::nsyms (number of entries of @fp::syms or @fp::addrs) and
> > + * @fp::handler. Other fields are initialized by this function.
> > + */
> > +int register_fprobe(struct fprobe *fp)
> > +{
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	if (!fp)
> > +		return -EINVAL;
> > +
> > +	if (!fp->nsyms || (!fp->syms && !fp->addrs) || (fp->syms && fp->addrs))
> > +		return -EINVAL;
> > +
> > +	if (fp->syms) {
> > +		ret = populate_func_addresses(fp);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	fp->ftrace.func = fprobe_handler;
> > +	fp->ftrace.flags = FTRACE_OPS_FL_SAVE_REGS;
> > +
> > +	for (i = 0; i < fp->nsyms; i++) {
> > +		ret = ftrace_set_filter_ip(&fp->ftrace, fp->addrs[i], 0, 0);
> > +		if (ret < 0)
> > +			goto error;
> > +	}
> 
> I introduced ftrace_set_filter_ips, because loop like above was slow:
>   https://lore.kernel.org/bpf/20211118112455.475349-4-jolsa@kernel.org/

Ah, thanks for noticing!

Thank you,

> 
> thanks,
> jirka
> 
> > +
> > +	fp->nmissed = 0;
> > +	ret = register_ftrace_function(&fp->ftrace);
> > +	if (!ret)
> > +		return ret;
> > +
> > +error:
> > +	if (fp->syms) {
> > +		kfree(fp->addrs);
> > +		fp->addrs = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> > + * unregister_fprobe - Unregister fprobe from ftrace
> > + * @fp: A fprobe data structure to be unregistered.
> > + */
> > +int unregister_fprobe(struct fprobe *fp)
> > +{
> > +	int ret;
> > +
> > +	if (!fp)
> > +		return -EINVAL;
> > +
> > +	if (!fp->nsyms || !fp->addrs)
> > +		return -EINVAL;
> > +
> > +	ret = unregister_ftrace_function(&fp->ftrace);
> > +
> > +	if (fp->syms) {
> > +		/* fp->addrs is allocated by register_fprobe() */
> > +		kfree(fp->addrs);
> > +		fp->addrs = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> > -- 
> > 2.25.1
> > 
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
