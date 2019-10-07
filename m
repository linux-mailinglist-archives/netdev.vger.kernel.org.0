Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E9CCDDDC
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 11:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfJGJAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 05:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfJGJAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 05:00:35 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 720AE10CC1E0;
        Mon,  7 Oct 2019 09:00:34 +0000 (UTC)
Received: from carbon (ovpn-200-24.brq.redhat.com [10.40.200.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F29CD19C7F;
        Mon,  7 Oct 2019 09:00:21 +0000 (UTC)
Date:   Mon, 7 Oct 2019 11:00:20 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Eric Sage <eric@sage.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        xdp-newbies@vger.kernel.org, brouer@redhat.org, ast@kernel.org,
        brouer@redhat.com, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] samples/bpf: make xdp_monitor use raw_tracepoints
Message-ID: <20191007110020.6bf8dbc2@carbon>
In-Reply-To: <20191007045726.21467-1-eric@sage.org>
References: <20191007045726.21467-1-eric@sage.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 07 Oct 2019 09:00:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon,  7 Oct 2019 04:57:26 +0000 Eric Sage <eric@sage.org> wrote:

> raw_tracepoints are an eBPF alternative to standard tracepoints which
> attach to a tracepoint without the perf layer being executed, making
> them faster.
> 
> Since xdp_monitor is supposed to have as little impact on the system as
> possible it is switched to using them by append raw_ to the SEC names.
> 
> There was also a small issues with 'samples/bpf/bpf_load' - it was
> loading the raw_tracepoints with the tracing subsystem name still
> attached, which the bpf syscall rejects with a No such file or directory
> error. This is now fixed.
> 
> Signed-off-by: Eric Sage <eric@sage.org>
> ---
>  samples/bpf/bpf_load.c         |  5 +++--
>  samples/bpf/xdp_monitor_kern.c | 26 +++++++++++++-------------
>  2 files changed, 16 insertions(+), 15 deletions(-)

If there is an issue in the loader 'samples/bpf/bpf_load.c' then we
should of-cause fix it, but you should be aware that we are in general
trying to deprecate this loader, and we want to convert users over to
libbpf.

This patch seems like a good first step forward.  Longer term, I would
like to see this converted into using libbpf.  The library are missing
attach helpers for regular tracepoints, but for raw_tracepoints it does
contain bpf_raw_tracepoint_open().

You can see an example of how xdp_monitor have been converted into
using libbpf and raw_tracepoints here (by Jiri Olsa):

 https://github.com/xdp-project/xdp-tutorial/blob/master/tracing02-xdp-monitor/trace_prog_kern.c


> diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
> index 4574b1939e49..6f57eee8e913 100644
> --- a/samples/bpf/bpf_load.c
> +++ b/samples/bpf/bpf_load.c
> @@ -156,9 +156,10 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
>  	}
>  
>  	if (is_raw_tracepoint) {
> -		efd = bpf_raw_tracepoint_open(event + 15, fd);
> +		efd = bpf_raw_tracepoint_open(event + 19, fd);
>  		if (efd < 0) {
> -			printf("tracepoint %s %s\n", event + 15, strerror(errno));
> +			printf("tracepoint %s %s\n", event + 19,
> +						strerror(errno));

Are you sure this is the correct fix?

You might break: test_overhead_raw_tp_kern.c


>  			return -1;
>  		}
>  		event_fd[prog_cnt - 1] = efd;
> diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
> index ad10fe700d7d..6f67c38468b9 100644
> --- a/samples/bpf/xdp_monitor_kern.c
> +++ b/samples/bpf/xdp_monitor_kern.c
> @@ -23,10 +23,10 @@ struct bpf_map_def SEC("maps") exception_cnt = {
>  };
>  
>  /* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
> + * Notice: For raw_tracepoints first 8 bytes are not part of 'format' struct
>   * Code in:                kernel/include/trace/events/xdp.h
>   */
>  struct xdp_redirect_ctx {
> -	u64 __pad;		// First 8 bytes are not accessible by bpf code
>  	int prog_id;		//	offset:8;  size:4; signed:1;
>  	u32 act;		//	offset:12  size:4; signed:0;
>  	int ifindex;		//	offset:16  size:4; signed:1;
> @@ -65,44 +65,44 @@ int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
>  	 */
>  }
>  
> -SEC("tracepoint/xdp/xdp_redirect_err")
> +SEC("raw_tracepoint/xdp/xdp_redirect_err")
>  int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
>  {
>  	return xdp_redirect_collect_stat(ctx);
>  }
>  
>  
> -SEC("tracepoint/xdp/xdp_redirect_map_err")
> +SEC("raw_tracepoint/xdp/xdp_redirect_map_err")
>  int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
>  {
>  	return xdp_redirect_collect_stat(ctx);
>  }
>  
>  /* Likely unloaded when prog starts */
> -SEC("tracepoint/xdp/xdp_redirect")
> +SEC("raw_tracepoint/xdp/xdp_redirect")
>  int trace_xdp_redirect(struct xdp_redirect_ctx *ctx)
>  {
>  	return xdp_redirect_collect_stat(ctx);
>  }
>  
>  /* Likely unloaded when prog starts */
> -SEC("tracepoint/xdp/xdp_redirect_map")
> +SEC("raw_tracepoint/xdp/xdp_redirect_map")
>  int trace_xdp_redirect_map(struct xdp_redirect_ctx *ctx)
>  {
>  	return xdp_redirect_collect_stat(ctx);
>  }
>  
>  /* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
> + * Notice: For raw_tracepoints first 8 bytes are not part of 'format' struct
>   * Code in:                kernel/include/trace/events/xdp.h
>   */
>  struct xdp_exception_ctx {
> -	u64 __pad;	// First 8 bytes are not accessible by bpf code
>  	int prog_id;	//	offset:8;  size:4; signed:1;
>  	u32 act;	//	offset:12; size:4; signed:0;
>  	int ifindex;	//	offset:16; size:4; signed:1;
>  };
>  
> -SEC("tracepoint/xdp/xdp_exception")
> +SEC("raw_tracepoint/xdp/xdp_exception")
>  int trace_xdp_exception(struct xdp_exception_ctx *ctx)
>  {
>  	u64 *cnt;
> @@ -144,10 +144,10 @@ struct bpf_map_def SEC("maps") cpumap_kthread_cnt = {
>  };
>  
>  /* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
> + * Notice: For raw_tracepoints first 8 bytes are not part of 'format' struct
>   * Code in:         kernel/include/trace/events/xdp.h
>   */
>  struct cpumap_enqueue_ctx {
> -	u64 __pad;		// First 8 bytes are not accessible by bpf code
>  	int map_id;		//	offset:8;  size:4; signed:1;
>  	u32 act;		//	offset:12; size:4; signed:0;
>  	int cpu;		//	offset:16; size:4; signed:1;
> @@ -156,7 +156,7 @@ struct cpumap_enqueue_ctx {
>  	int to_cpu;		//	offset:28; size:4; signed:1;
>  };
>  
> -SEC("tracepoint/xdp/xdp_cpumap_enqueue")
> +SEC("raw_tracepoint/xdp/xdp_cpumap_enqueue")
>  int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
>  {
>  	u32 to_cpu = ctx->to_cpu;
> @@ -179,10 +179,10 @@ int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
>  }
>  
>  /* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
> + * Notice: For raw_tracepoints first 8 bytes are not part of 'format' struct
>   * Code in:         kernel/include/trace/events/xdp.h
>   */
>  struct cpumap_kthread_ctx {
> -	u64 __pad;		// First 8 bytes are not accessible by bpf code
>  	int map_id;		//	offset:8;  size:4; signed:1;
>  	u32 act;		//	offset:12; size:4; signed:0;
>  	int cpu;		//	offset:16; size:4; signed:1;
> @@ -191,7 +191,7 @@ struct cpumap_kthread_ctx {
>  	int sched;		//	offset:28; size:4; signed:1;
>  };
>  
> -SEC("tracepoint/xdp/xdp_cpumap_kthread")
> +SEC("raw_tracepoint/xdp/xdp_cpumap_kthread")
>  int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
>  {
>  	struct datarec *rec;
> @@ -218,10 +218,10 @@ struct bpf_map_def SEC("maps") devmap_xmit_cnt = {
>  };
>  
>  /* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
> + * Notice: For raw_tracepoints first 8 bytes are not part of 'format' struct
>   * Code in:         kernel/include/trace/events/xdp.h
>   */
>  struct devmap_xmit_ctx {
> -	u64 __pad;		// First 8 bytes are not accessible by bpf code
>  	int map_id;		//	offset:8;  size:4; signed:1;
>  	u32 act;		//	offset:12; size:4; signed:0;
>  	u32 map_index;		//	offset:16; size:4; signed:0;
> @@ -232,7 +232,7 @@ struct devmap_xmit_ctx {
>  	int err;		//	offset:36; size:4; signed:1;
>  };
>  
> -SEC("tracepoint/xdp/xdp_devmap_xmit")
> +SEC("raw_tracepoint/xdp/xdp_devmap_xmit")
>  int trace_xdp_devmap_xmit(struct devmap_xmit_ctx *ctx)
>  {
>  	struct datarec *rec;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
