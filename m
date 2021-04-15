Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325F2360DEF
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhDOPHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:07:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:48184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbhDOPGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:06:01 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX3Yn-00097Y-J1; Thu, 15 Apr 2021 17:05:37 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lX3Yn-0006uU-Cf; Thu, 15 Apr 2021 17:05:37 +0200
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        brouer@redhat.com, song@kernel.org
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
Date:   Thu, 15 Apr 2021 17:05:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26141/Thu Apr 15 13:13:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 6:22 PM, Lorenzo Bianconi wrote:
> Rely on netif_receive_skb_list routine to send skbs converted from
> xdp_frames in cpu_map_kthread_run in order to improve i-cache usage.
> The proposed patch has been tested running xdp_redirect_cpu bpf sample
> available in the kernel tree that is used to redirect UDP frames from
> ixgbe driver to a cpumap entry and then to the networking stack.
> UDP frames are generated using pkt_gen.
> 
> $xdp_redirect_cpu  --cpu <cpu> --progname xdp_cpu_map0 --dev <eth>
> 
> bpf-next: ~2.2Mpps
> bpf-next + cpumap skb-list: ~3.15Mpps
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - fixed comment
> - rebased on top of bpf-next tree
> ---
>   kernel/bpf/cpumap.c | 11 +++++------
>   1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 0cf2791d5099..d89551a508b2 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -27,7 +27,7 @@
>   #include <linux/capability.h>
>   #include <trace/events/xdp.h>
>   
> -#include <linux/netdevice.h>   /* netif_receive_skb_core */
> +#include <linux/netdevice.h>   /* netif_receive_skb_list */
>   #include <linux/etherdevice.h> /* eth_type_trans */
>   
>   /* General idea: XDP packets getting XDP redirected to another CPU,
> @@ -257,6 +257,7 @@ static int cpu_map_kthread_run(void *data)
>   		void *frames[CPUMAP_BATCH];
>   		void *skbs[CPUMAP_BATCH];
>   		int i, n, m, nframes;
> +		LIST_HEAD(list);
>   
>   		/* Release CPU reschedule checks */
>   		if (__ptr_ring_empty(rcpu->queue)) {
> @@ -305,7 +306,6 @@ static int cpu_map_kthread_run(void *data)
>   		for (i = 0; i < nframes; i++) {
>   			struct xdp_frame *xdpf = frames[i];
>   			struct sk_buff *skb = skbs[i];
> -			int ret;
>   
>   			skb = __xdp_build_skb_from_frame(xdpf, skb,
>   							 xdpf->dev_rx);
> @@ -314,11 +314,10 @@ static int cpu_map_kthread_run(void *data)
>   				continue;
>   			}
>   
> -			/* Inject into network stack */
> -			ret = netif_receive_skb_core(skb);
> -			if (ret == NET_RX_DROP)
> -				drops++;
> +			list_add_tail(&skb->list, &list);
>   		}
> +		netif_receive_skb_list(&list);
> +
>   		/* Feedback loop via tracepoint */
>   		trace_xdp_cpumap_kthread(rcpu->map_id, n, drops, sched, &stats);

Given we stop counting drops with the netif_receive_skb_list(), we should then
also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it is rather
misleading (as in: drops actually happening, but 0 are shown from the tracepoint).
Given they are not considered stable API, I would just remove those to make it clear
to users that they cannot rely on this counter anymore anyway.

Thanks,
Daniel
