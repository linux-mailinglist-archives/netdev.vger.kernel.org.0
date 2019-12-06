Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84307114FD8
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbfLFLhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:37:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLFLhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=foh8sYJrdum0Ho42b+mlrYDufX7AamENKofApbl1AEg=; b=KYM39cH4jEKdclgEJ1qkQHJPQ
        +/QHjpZVq6r/29pcBL3EozkNq46gmVniAgF5M8nyQ0V+Bg2kbtt1Cnc6KjmeKM64bnq1mcF2JhF+2
        3rCZa/sQ+TbMWsBTF8J11g6bXe+pTDe+g6fvS+vckoWBcQ08PXSjAhdbZ3EQ176tY0QcCaybePILB
        3FFr8Mb/mn1A+0H8a9wSjP9ufAEJmfGiDczWjbcqvRV6QLBmdHjCPVJfdC1c+BIrxZsJn6aPN1dj1
        A9yPXXzrr0K4phXygt5xCVWCp0FDQcH1vQH++xA2nhhz1tXN0S349ROT8ixZL6jmnuRTpk0zQQ2FY
        SkSPO6o8A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1idBvT-0000jF-Lq; Fri, 06 Dec 2019 11:37:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7B2A330025A;
        Fri,  6 Dec 2019 12:36:15 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DAEE42B26E210; Fri,  6 Dec 2019 12:37:32 +0100 (CET)
Date:   Fri, 6 Dec 2019 12:37:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf] bpf: Add LBR data to BPF_PROG_TYPE_PERF_EVENT prog
 context
Message-ID: <20191206113732.GF2844@hirez.programming.kicks-ass.net>
References: <20191206001226.67825-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206001226.67825-1-dxu@dxuuu.xyz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 04:12:26PM -0800, Daniel Xu wrote:
> Last-branch-record is an intel CPU feature that can be configured to
> record certain branches that are taken during code execution. This data
> is particularly interesting for profile guided optimizations. perf has
> had LBR support for a while but the data collection can be a bit coarse
> grained.
> 
> We (Facebook) have recently run a lot of experiments with feeding
> filtered LBR data to various PGO pipelines. We've seen really good
> results (+2.5% throughput with lower cpu util and lower latency) by
> feeding high request latency LBR branches to the compiler on a
> request-oriented service. We used bpf to read a special request context
> ID (which is how we associate branches with latency) from a fixed
> userspace address. Reading from the fixed address is why bpf support is
> useful.
> 
> Aside from this particular use case, having LBR data available to bpf
> progs can be useful to get stack traces out of userspace applications
> that omit frame pointers.
> 
> This patch adds support for LBR data to bpf perf progs.
> 
> Some notes:
> * We use `__u64 entries[BPF_MAX_LBR_ENTRIES * 3]` instead of
>   `struct perf_branch_entry[BPF_MAX_LBR_ENTRIES]` because checkpatch.pl
>   warns about including a uapi header from another uapi header
> 
> * We define BPF_MAX_LBR_ENTRIES as 32 (instead of using the value from
>   arch/x86/events/perf_events.h) because including arch specific headers
>   seems wrong and could introduce circular header includes.
> 
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
> ---
>  include/uapi/linux/bpf_perf_event.h |  5 ++++
>  kernel/trace/bpf_trace.c            | 39 +++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf_perf_event.h b/include/uapi/linux/bpf_perf_event.h
> index eb1b9d21250c..dc87e3d50390 100644
> --- a/include/uapi/linux/bpf_perf_event.h
> +++ b/include/uapi/linux/bpf_perf_event.h
> @@ -10,10 +10,15 @@
>  
>  #include <asm/bpf_perf_event.h>
>  
> +#define BPF_MAX_LBR_ENTRIES 32
> +
>  struct bpf_perf_event_data {
>  	bpf_user_pt_regs_t regs;
>  	__u64 sample_period;
>  	__u64 addr;
> +	__u64 nr_lbr;
> +	/* Cast to struct perf_branch_entry* before using */
> +	__u64 entries[BPF_MAX_LBR_ENTRIES * 3];
>  };

Note how perf has avoided actually using the LBR name and size in its
ABI. There's other architectures that can do branch stacks (PowerPC) and
given historic precedent, the current size (32) might once again change
(we started at 4 with Intel Core IIRC).

