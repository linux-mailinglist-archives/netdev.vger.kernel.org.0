Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EBE23D51C
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 03:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgHFBam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 21:30:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725998AbgHFBal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 21:30:41 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D50A206B6;
        Thu,  6 Aug 2020 01:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596677441;
        bh=j8cz0jkeIZa3/Qm+IkMRnxzTHWlX6p/ubrCWK/DfFbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bGlBvdhV0IINzDDxY+ebHRZWc6E5LXVWNeJetqkKvZ+FGUsEtC4H4fUiPEX+vLnG7
         GStprFmbi0s1dSFEpmAAHhDNqmhclPmlpMjYfq7qA2xzZlNM9SUZNvewR2WkmZEVx1
         CrqaNCZC6yFbCKERNMfFt7gQCy6/r4k2aNLWZq/M=
Date:   Thu, 6 Aug 2020 10:30:35 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     rostedt@goodmis.org, naveen.n.rao@linux.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        sfr@canb.auug.org.au, mingo@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] kprobes: fix compiler warning for
 !CONFIG_KPROBES_ON_FTRACE
Message-Id: <20200806103035.3359153c2753e9f52d17d353@kernel.org>
In-Reply-To: <20200805172046.19066-1-songmuchun@bytedance.com>
References: <20200805172046.19066-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Aug 2020 01:20:46 +0800
Muchun Song <songmuchun@bytedance.com> wrote:

> Fix compiler warning(as show below) for !CONFIG_KPROBES_ON_FTRACE.
> 
> kernel/kprobes.c: In function 'kill_kprobe':
> kernel/kprobes.c:1116:33: warning: statement with no effect
> [-Wunused-value]
>  1116 | #define disarm_kprobe_ftrace(p) (-ENODEV)
>       |                                 ^
> kernel/kprobes.c:2154:3: note: in expansion of macro
> 'disarm_kprobe_ftrace'
>  2154 |   disarm_kprobe_ftrace(p);
> 
> Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Looks good to me.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you!

> ---
>  kernel/kprobes.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 503add629599..d36e2b017588 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -1114,9 +1114,20 @@ static int disarm_kprobe_ftrace(struct kprobe *p)
>  		ipmodify ? &kprobe_ipmodify_enabled : &kprobe_ftrace_enabled);
>  }
>  #else	/* !CONFIG_KPROBES_ON_FTRACE */
> -#define prepare_kprobe(p)	arch_prepare_kprobe(p)
> -#define arm_kprobe_ftrace(p)	(-ENODEV)
> -#define disarm_kprobe_ftrace(p)	(-ENODEV)
> +static inline int prepare_kprobe(struct kprobe *p)
> +{
> +	return arch_prepare_kprobe(p);
> +}
> +
> +static inline int arm_kprobe_ftrace(struct kprobe *p)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int disarm_kprobe_ftrace(struct kprobe *p)
> +{
> +	return -ENODEV;
> +}
>  #endif
>  
>  /* Arm a kprobe with text_mutex */
> -- 
> 2.11.0
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
