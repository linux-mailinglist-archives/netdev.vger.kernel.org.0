Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6C2365DF7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbhDTQ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:56:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232916AbhDTQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618937735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VX5nIkOjQFrnQnPvJLFtPSaZjbDSX89pb1f05vmUZA=;
        b=ZI11MW+ECVm1SzIvWzIA+WHWPS0Bi+bkQTsjjJkYiK24kUL0Xtfifzf0W91EgJzObINmZE
        2o2qSEZizznXpt6X5uNlk+BLTfhVtc6z0d8VbW2u13QnkGw7oEl8ltjpz+xWvYy2HVhYKH
        osX9q6t3GCjBmcIC5HSlya1WnulsPaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-igJoo5lHPumzic6YEpVmzA-1; Tue, 20 Apr 2021 12:55:32 -0400
X-MC-Unique: igJoo5lHPumzic6YEpVmzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D537C80F05C;
        Tue, 20 Apr 2021 16:54:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDE9618A60;
        Tue, 20 Apr 2021 16:54:41 +0000 (UTC)
Date:   Tue, 20 Apr 2021 18:54:40 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, song@kernel.org,
        toke@redhat.com, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next] cpumap: bulk skb using
 netif_receive_skb_list
Message-ID: <20210420185440.1dfcf71c@carbon>
In-Reply-To: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
References: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Apr 2021 16:05:14 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen. Packets are discarded by the
> UDP layer.
> 
> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
> 
> bpf-next: ~2.35Mpps
> bpf-next + cpumap skb-list: ~2.72Mpps
> 
> Since netif_receive_skb_list does not return number of discarded packets,
> remove drop counter from xdp_cpumap_kthread tracepoint and update related
> xdp samples.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v2:
> - remove drop counter and update related xdp samples
> - rebased on top of bpf-next
> 
> Changes since v1:
> - fixed comment
> - rebased on top of bpf-next tree
> ---
>  include/trace/events/xdp.h          | 14 +++++---------
>  kernel/bpf/cpumap.c                 | 16 +++++++---------
>  samples/bpf/xdp_monitor_kern.c      |  6 ++----
>  samples/bpf/xdp_monitor_user.c      | 14 ++++++--------
>  samples/bpf/xdp_redirect_cpu_kern.c | 12 +++++-------
>  samples/bpf/xdp_redirect_cpu_user.c | 10 ++++------
>  6 files changed, 29 insertions(+), 43 deletions(-)
> 
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index fcad3645a70b..52ecfe9c7e25 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -184,16 +184,15 @@ DEFINE_EVENT(xdp_redirect_template, xdp_redirect_map_err,
>  
>  TRACE_EVENT(xdp_cpumap_kthread,
>  
> -	TP_PROTO(int map_id, unsigned int processed,  unsigned int drops,
> -		 int sched, struct xdp_cpumap_stats *xdp_stats),
> +	TP_PROTO(int map_id, unsigned int processed, int sched,
> +		 struct xdp_cpumap_stats *xdp_stats),
>  
> -	TP_ARGS(map_id, processed, drops, sched, xdp_stats),
> +	TP_ARGS(map_id, processed, sched, xdp_stats),
>  
>  	TP_STRUCT__entry(
>  		__field(int, map_id)
>  		__field(u32, act)
>  		__field(int, cpu)
> -		__field(unsigned int, drops)
>  		__field(unsigned int, processed)

So, struct member @processed will takeover the room for @drops.

Can you please test how an old xdp_monitor program will react to this?
Will it fail, or extract and show wrong values?

The xdp_mointor tool is in several external git repos:

 https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samples/bpf/xdp_monitor_kern.c
 https://github.com/xdp-project/xdp-tutorial/tree/master/tracing02-xdp-monitor

Do you have any plans for fixing those tools?


>  		__field(int, sched)
>  		__field(unsigned int, xdp_pass)
> @@ -205,7 +204,6 @@ TRACE_EVENT(xdp_cpumap_kthread,
>  		__entry->map_id		= map_id;
>  		__entry->act		= XDP_REDIRECT;
>  		__entry->cpu		= smp_processor_id();
> -		__entry->drops		= drops;
>  		__entry->processed	= processed;
>  		__entry->sched	= sched;
>  		__entry->xdp_pass	= xdp_stats->pass;
> @@ -215,13 +213,11 @@ TRACE_EVENT(xdp_cpumap_kthread,
>  
>  	TP_printk("kthread"
>  		  " cpu=%d map_id=%d action=%s"
> -		  " processed=%u drops=%u"
> -		  " sched=%d"
> +		  " processed=%u sched=%u"
>  		  " xdp_pass=%u xdp_drop=%u xdp_redirect=%u",
>  		  __entry->cpu, __entry->map_id,
>  		  __print_symbolic(__entry->act, __XDP_ACT_SYM_TAB),
> -		  __entry->processed, __entry->drops,
> -		  __entry->sched,
> +		  __entry->processed, __entry->sched,
>  		  __entry->xdp_pass, __entry->xdp_drop, __entry->xdp_redirect)
>  );



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

