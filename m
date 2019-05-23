Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBC127DC9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfEWNMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729430AbfEWNMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 09:12:47 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C99ACA1FF;
        Thu, 23 May 2019 13:12:47 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC186620D2;
        Thu, 23 May 2019 13:12:39 +0000 (UTC)
Date:   Thu, 23 May 2019 15:12:37 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next 2/3] xdp: Add tracepoint for bulk XDP_TX
Message-ID: <20190523151237.190fe76e@carbon>
In-Reply-To: <1558609008-2590-3-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
        <1558609008-2590-3-git-send-email-makita.toshiaki@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 23 May 2019 13:12:47 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 19:56:47 +0900
Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> wrote:

> This is introduced for admins to check what is happening on XDP_TX when
> bulk XDP_TX is in use.
> 
> Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> ---
>  include/trace/events/xdp.h | 25 +++++++++++++++++++++++++
>  kernel/bpf/core.c          |  1 +
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index e95cb86..e06ea65 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -50,6 +50,31 @@
>  		  __entry->ifindex)
>  );
>  
> +TRACE_EVENT(xdp_bulk_tx,
> +

You are using this tracepoint like/instead of trace_xdp_devmap_xmit if
I understand correctly?  Or maybe the trace_xdp_redirect tracepoint.

The point is that is will be good if the tracepoints can share the
TP_STRUCT layout beginning, as it allows for attaching and reusing eBPF
code that is only interested in the top part of the struct.

I would also want to see some identifier, that trace programs can use
to group and corrolate these events, you do have ifindex, but most
other XDP tracepoints also have "prog_id".

> +	TP_PROTO(const struct net_device *dev,
> +		 int sent, int drops, int err),
> +
> +	TP_ARGS(dev, sent, drops, err),
> +
> +	TP_STRUCT__entry(
> +		__field(int, ifindex)
> +		__field(int, drops)
> +		__field(int, sent)
> +		__field(int, err)
> +	),

The xdp_redirect_template have:

	TP_STRUCT__entry(
		__field(int, prog_id)
		__field(u32, act)
		__field(int, ifindex)
		__field(int, err)
		__field(int, to_ifindex)
		__field(u32, map_id)
		__field(int, map_index)
	),

And e.g. TRACE_EVENT xdp_exception have:

	TP_STRUCT__entry(
		__field(int, prog_id)
		__field(u32, act)
		__field(int, ifindex)
	),


> +
> +	TP_fast_assign(
> +		__entry->ifindex	= dev->ifindex;
> +		__entry->drops		= drops;
> +		__entry->sent		= sent;
> +		__entry->err		= err;
> +	),
> +
> +	TP_printk("ifindex=%d sent=%d drops=%d err=%d",
> +		  __entry->ifindex, __entry->sent, __entry->drops, __entry->err)
> +);
> +
>  DECLARE_EVENT_CLASS(xdp_redirect_template,
>  
>  	TP_PROTO(const struct net_device *dev,
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 242a643..7687488 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2108,3 +2108,4 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
>  #include <linux/bpf_trace.h>
>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_exception);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(xdp_bulk_tx);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
