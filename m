Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC1E49B9CC
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350459AbiAYRJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:09:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38026 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359219AbiAYRII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:08:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B047561155;
        Tue, 25 Jan 2022 17:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F60C340E0;
        Tue, 25 Jan 2022 17:08:05 +0000 (UTC)
Date:   Tue, 25 Jan 2022 12:08:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
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
Subject: Re: [PATCH v5 7/9] fprobe: Add exit_handler support
Message-ID: <20220125120804.595afd8b@gandalf.local.home>
In-Reply-To: <164311277634.1933078.2632008023256564980.stgit@devnote2>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
        <164311277634.1933078.2632008023256564980.stgit@devnote2>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 21:12:56 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Add exit_handler to fprobe. fprobe + rethook allows us
> to hook the kernel function return without fgraph tracer.
> Eventually, the fgraph tracer will be generic array based
> return hooking and fprobe may use it if user requests.
> Since both array-based approach and list-based approach
> have Pros and Cons, (e.g. memory consumption v.s. less
> missing events) it is better to keep both but fprobe
> will provide the same exit-handler interface.

Again the 55 character width ;-)

> 
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  Changes in v5:
>   - Add dependency for HAVE_RETHOOK.
>  Changes in v4:
>   - Check fprobe is disabled in the exit handler.
>  Changes in v3:
>   - Make sure to clear rethook->data before free.
>   - Handler checks the data is not NULL.
>   - Free rethook only if the rethook is using.
> ---

> @@ -82,6 +117,7 @@ static int convert_func_addresses(struct fprobe *fp)
>   */
>  int register_fprobe(struct fprobe *fp)
>  {
> +	unsigned int i, size;
>  	int ret;
>  
>  	if (!fp || !fp->nentry || (!fp->syms && !fp->addrs) ||
> @@ -96,10 +132,29 @@ int register_fprobe(struct fprobe *fp)
>  	fp->ops.func = fprobe_handler;
>  	fp->ops.flags = FTRACE_OPS_FL_SAVE_REGS;
>  
> +	/* Initialize rethook if needed */
> +	if (fp->exit_handler) {
> +		size = fp->nentry * num_possible_cpus() * 2;
> +		fp->rethook = rethook_alloc((void *)fp, fprobe_exit_handler);

Shouldn't we check if fp->rethook succeeded to be allocated?

> +		for (i = 0; i < size; i++) {
> +			struct rethook_node *node;
> +
> +			node = kzalloc(sizeof(struct fprobe_rethook_node), GFP_KERNEL);
> +			if (!node) {
> +				rethook_free(fp->rethook);
> +				ret = -ENOMEM;
> +				goto out;
> +			}
> +			rethook_add_node(fp->rethook, node);
> +		}
> +	} else
> +		fp->rethook = NULL;
> +
>  	ret = ftrace_set_filter_ips(&fp->ops, fp->addrs, fp->nentry, 0, 0);
>  	if (!ret)
>  		ret = register_ftrace_function(&fp->ops);
>  
> +out:
>  	if (ret < 0 && fp->syms) {
>  		kfree(fp->addrs);
>  		fp->addrs = NULL;
> @@ -125,8 +180,16 @@ int unregister_fprobe(struct fprobe *fp)
>  		return -EINVAL;
>  
>  	ret = unregister_ftrace_function(&fp->ops);
> +	if (ret < 0)
> +		return ret;

If we fail to unregister the fp->ops, we do not free the allocated nodes
above?

-- Steve

>  
> -	if (!ret && fp->syms) {
> +	if (fp->rethook) {
> +		/* Make sure to clear rethook->data before freeing. */
> +		WRITE_ONCE(fp->rethook->data, NULL);
> +		barrier();
> +		rethook_free(fp->rethook);
> +	}
> +	if (fp->syms) {
>  		kfree(fp->addrs);
>  		fp->addrs = NULL;
>  	}

