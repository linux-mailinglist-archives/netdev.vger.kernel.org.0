Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115EB49C5CC
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiAZJG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:06:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiAZJG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:06:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 478E16148C;
        Wed, 26 Jan 2022 09:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C9C340E3;
        Wed, 26 Jan 2022 09:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643187987;
        bh=915lXUlz+7KXHUvlQ+F2n82DHNWW5u2VIKGWr3z3SnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UxpSclEb4Az39DweLKoJHfII764GLFs4Q0e3un9/vyR0im00VDpOJqyHFrFuAfhMn
         oXERpK2vPOAnSQg/c0BCv159rTi5iAD8IIn5vLhLv2THWq7ReZfG3OaszOTgvZhT+p
         HXWYp5u4eCZf8AKeFLV5uTMx9XNsUvhZexmiUK+Z2PcRGmTBmzay7WJJGrGFGZoyC8
         jTWT+2d4vbvARNKFIRkWbsaAt1puaxcmbyPEPXWMq6N/sc7bfW6JwPFS0kRHhEteTp
         XXiU/mh4mTI8/1+cLR58z73TtI1fBiOh8FQm6msSqO3qBXxAlOSwSusXS0V3C9S01u
         p6pfgOVz1IhzQ==
Date:   Wed, 26 Jan 2022 18:06:23 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 2/9] fprobe: Add ftrace based probe APIs
Message-Id: <20220126180623.52c4da59c7996b27dd56e01f@kernel.org>
In-Reply-To: <20220125112123.515b7450@gandalf.local.home>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311271777.1933078.9066058105807126444.stgit@devnote2>
        <20220125112123.515b7450@gandalf.local.home>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 11:21:23 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 25 Jan 2022 21:11:57 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > The fprobe is a wrapper API for ftrace function tracer.
> > Unlike kprobes, this probes only supports the function entry, but
> > it can probe multiple functions by one fprobe. The usage is almost
> > same as the kprobe, user will specify the function names by
> > fprobe::syms, the number of syms by fprobe::nentry,
> > and the user handler by fprobe::entry_handler.
> > 
> > struct fprobe fp = { 0 };
> > const char *targets[] = { "func1", "func2", "func3"};
> > 
> > fp.handler = user_handler;
> > fp.nentry = ARRAY_SIZE(targets);
> > fp.syms = targets;
> > 
> > ret = register_fprobe(&fp);
> > 
> > CAUTION: if user entry handler changes registers including
> > ip address, it will be applied when returns from the
> > entry handler. So user handler must recover it.
> 
> Can you rephrase the above, I'm not sure what you mean by it.

OK, but I think this should be written in the document.
I meant entry_handler can change the regs, but that will change
the execution path. So for some reason if it needs to change the
registers, those should be recovered in the same entry_handler.

[SNIP]
> > +/* Convert ftrace location address from symbols */
> > +static int convert_func_addresses(struct fprobe *fp)
> > +{
> > +	unsigned long addr, size;
> > +	unsigned int i;
> > +
> > +	/* Convert symbols to symbol address */
> > +	if (fp->syms) {
> > +		fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
> > +		if (!fp->addrs)
> > +			return -ENOMEM;
> > +
> > +		for (i = 0; i < fp->nentry; i++) {
> > +			fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
> > +			if (!fp->addrs[i])	/* Maybe wrong symbol */
> > +				goto error;
> > +		}
> > +	}
> 
> I wonder if we should just copy the addrs when fp->syms is not set, and
> not have to worry about not freeing addrs (see below). This will make
> things easier to maintain. Or better yet, have the syms and addrs passed
> in, and then we assign it.
> 
> static int convert_func_addresses(struct fprobe *fp, const char **syms,
> 				  unsigned long *addrs)
> {
> 	unsigned int i;
> 
> 	fp->addrs = kcalloc(fp->nentry, sizeof(*fp->addrs), GFP_KERNEL);
> 	if (!fp->addrs)
> 		return -ENOMEM;
> 
> 	if (syms) {
> 		for (i = 0; i < fp->nentry; i++) {
> 			fp->addrs[i] = kallsyms_lookup_name(fp->syms[i]);
> 			if (!fp->addrs[i])	/* Maybe wrong symbol */
> 				goto error;
> 		}
> 	} else {
> 		memcpy(fp->addrs, addrs, fp->nentry * sizeof(*addrs));
> 	}

Actually, since fprobe doesn't touch the addrs and syms except for the
registering time, instead of changing the fp->addrs, I would like
to make a temporary address array just for ftrace_filter_ips(). Then
we don't need to free it later.

> 
> > +
> > +	/* Convert symbol address to ftrace location. */
> > +	for (i = 0; i < fp->nentry; i++) {
> > +		if (!kallsyms_lookup_size_offset(fp->addrs[i], &size, NULL))
> > +			size = MCOUNT_INSN_SIZE;
> > +		addr = ftrace_location_range(fp->addrs[i], fp->addrs[i] + size);
> > +		if (!addr) /* No dynamic ftrace there. */
> > +			goto error;
> > +		fp->addrs[i] = addr;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	kfree(fp->addrs);
> 
> The above doesn't check if fp->syms was set, so if it wasn't we just freed
> the addrs that was passed in. Again, I think these should be passed into
> the register function as separate parameters and not via the fp handle.

Agreed. I also would like to remove those params from struct fprobe.

> 
> > +	fp->addrs = NULL;
> > +	return -ENOENT;
> > +}
> > +
> > +/**
> > + * register_fprobe() - Register fprobe to ftrace
> > + * @fp: A fprobe data structure to be registered.
> > + *
> > + * This expects the user set @fp::entry_handler, @fp::syms or @fp:addrs,
> > + * and @fp::nentry. If @fp::addrs are set, that will be updated to point
> > + * the ftrace location. If @fp::addrs are NULL, this will generate it
> > + * from @fp::syms.
> > + * Note that you do not set both of @fp::addrs and @fp::syms.
> 
> Again, I think this should pass in the syms and addrs as parameters.

That's good to me :)

Thank you,

> 
> -- Steve
> 
> > + */
> > +int register_fprobe(struct fprobe *fp)
> > +{
> > +	int ret;
> > +
> > +	if (!fp || !fp->nentry || (!fp->syms && !fp->addrs) ||
> > +	    (fp->syms && fp->addrs))
> > +		return -EINVAL;
> > +
> > +	ret = convert_func_addresses(fp);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	fp->nmissed = 0;
> > +	fp->ops.func = fprobe_handler;
> > +	fp->ops.flags = FTRACE_OPS_FL_SAVE_REGS;
> > +
> > +	ret = ftrace_set_filter_ips(&fp->ops, fp->addrs, fp->nentry, 0, 0);
> > +	if (!ret)
> > +		ret = register_ftrace_function(&fp->ops);
> > +
> > +	if (ret < 0 && fp->syms) {
> > +		kfree(fp->addrs);
> > +		fp->addrs = NULL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(register_fprobe);
> > +
> > +/**
> > + * unregister_fprobe() - Unregister fprobe from ftrace
> > + * @fp: A fprobe data structure to be unregistered.
> > + *
> > + * Unregister fprobe (and remove ftrace hooks from the function entries).
> > + * If the @fp::addrs are generated by register_fprobe(), it will be removed
> > + * automatically.
> > + */
> > +int unregister_fprobe(struct fprobe *fp)
> > +{
> > +	int ret;
> > +
> > +	if (!fp || !fp->nentry || !fp->addrs)
> > +		return -EINVAL;
> > +
> > +	ret = unregister_ftrace_function(&fp->ops);
> > +
> > +	if (!ret && fp->syms) {
> > +		kfree(fp->addrs);
> > +		fp->addrs = NULL;
> > +	}
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(unregister_fprobe);
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
