Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE48A35839
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 09:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFEH7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 03:59:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbfFEH7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 03:59:44 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8322EB59B1;
        Wed,  5 Jun 2019 07:59:43 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F7475D9CD;
        Wed,  5 Jun 2019 07:59:32 +0000 (UTC)
Date:   Wed, 5 Jun 2019 09:59:31 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>, brouer@redhat.com,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] xdp: Add tracepoint for bulk XDP_TX
Message-ID: <20190605095931.5d90b69c@carbon>
In-Reply-To: <20190605053613.22888-2-toshiaki.makita1@gmail.com>
References: <20190605053613.22888-1-toshiaki.makita1@gmail.com>
        <20190605053613.22888-2-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 05 Jun 2019 07:59:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Jun 2019 14:36:12 +0900
Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:

> This is introduced for admins to check what is happening on XDP_TX when
> bulk XDP_TX is in use, which will be first introduced in veth in next
> commit.

Is the plan that this tracepoint 'xdp:xdp_bulk_tx' should be used by
all drivers?

(more below)

> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
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
> +	TP_PROTO(const struct net_device *dev,
> +		 int sent, int drops, int err),
> +
> +	TP_ARGS(dev, sent, drops, err),
> +
> +	TP_STRUCT__entry(

All other tracepoints in this file starts with:

		__field(int, prog_id)
		__field(u32, act)
or
		__field(int, map_id)
		__field(u32, act)

Could you please add those?

> +		__field(int, ifindex)
> +		__field(int, drops)
> +		__field(int, sent)
> +		__field(int, err)
> +	),

The reason is that this make is easier to attach to multiple
tracepoints, and extract the same value.

Example with bpftrace oneliner:

$ sudo bpftrace -e 'tracepoint:xdp:xdp_* { @action[args->act] = count(); }'
Attaching 8 probes...
^C

@action[4]: 30259246
@action[0]: 34489024

XDP_ABORTED = 0 	 
XDP_REDIRECT= 4


> +
> +	TP_fast_assign(

		__entry->act		= XDP_TX;

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

Other fun bpftrace stuff:

sudo bpftrace -e 'tracepoint:xdp:xdp_*map* { @map_id[comm, args->map_id] = count(); }'
Attaching 5 probes...
^C

@map_id[swapper/2, 113]: 1428
@map_id[swapper/0, 113]: 2085
@map_id[ksoftirqd/4, 113]: 2253491
@map_id[ksoftirqd/2, 113]: 25677560
@map_id[ksoftirqd/0, 113]: 29004338
@map_id[ksoftirqd/3, 113]: 31034885


$ bpftool map list id 113
113: devmap  name tx_port  flags 0x0
	key 4B  value 4B  max_entries 100  memlock 4096B


p.s. People should look out for Brendan Gregg's upcoming book on BPF
performance tools, from which I learned to use bpftrace :-)
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
