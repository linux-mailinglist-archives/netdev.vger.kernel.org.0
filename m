Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495DC3059AE
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbhA0L2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S314098AbhAZW42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:56:28 -0500
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5CC06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:55:47 -0800 (PST)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4XBi-000CBK-Nm; Tue, 26 Jan 2021 23:51:54 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4XBi-0006vH-GY; Tue, 26 Jan 2021 23:51:54 +0100
Subject: Re: [PATCH bpf-next v2 1/6] xsk: add tracepoints for packet drops
To:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
References: <20210126075239.25378-1-ciara.loftus@intel.com>
 <20210126075239.25378-2-ciara.loftus@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7100d6c0-8556-4f7e-93e7-5ba6fa549104@iogearbox.net>
Date:   Tue, 26 Jan 2021 23:51:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210126075239.25378-2-ciara.loftus@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26061/Tue Jan 26 13:29:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 8:52 AM, Ciara Loftus wrote:
> This commit introduces static perf tracepoints for AF_XDP which
> report information about packet drops, such as the netdev, qid and
> high level reason for the drop. The tracepoint can be
> enabled/disabled by toggling
> /sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable

Could you add a rationale to the commit log on why xsk diag stats dump
is insufficient here given you add tracepoints to most locations where
we also bump the counters already? And given diag infra also exposes the
ifindex, queue id, etc, why troubleshooting the xsk socket via ss tool
is not sufficient?

[...]
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 4faabd1ecfd1..9b850716630b 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -11,6 +11,7 @@
>   
>   #define pr_fmt(fmt) "AF_XDP: %s: " fmt, __func__
>   
> +#include <linux/bpf_trace.h>
>   #include <linux/if_xdp.h>
>   #include <linux/init.h>
>   #include <linux/sched/mm.h>
> @@ -158,6 +159,7 @@ static int __xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
>   	addr = xp_get_handle(xskb);
>   	err = xskq_prod_reserve_desc(xs->rx, addr, len);
>   	if (err) {
> +		trace_xsk_packet_drop(xs->dev->name, xs->queue_id, XSK_TRACE_DROP_RXQ_FULL);
>   		xs->rx_queue_full++;
>   		return err;

I presume if this will be triggered under stress you'll likely also spam
your trace event log w/ potentially mio of msgs per sec?

>   	}
> @@ -192,6 +194,7 @@ static int __xsk_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>   
>   	len = xdp->data_end - xdp->data;
>   	if (len > xsk_pool_get_rx_frame_size(xs->pool)) {
> +		trace_xsk_packet_drop(xs->dev->name, xs->queue_id, XSK_TRACE_DROP_PKT_TOO_BIG);
>   		xs->rx_dropped++;
>   		return -ENOSPC;
>   	}
> @@ -516,6 +519,8 @@ static int xsk_generic_xmit(struct sock *sk)
>   		if (err == NET_XMIT_DROP) {
>   			/* SKB completed but not sent */
>   			err = -EBUSY;
> +			trace_xsk_packet_drop(xs->dev->name, xs->queue_id,
> +					      XSK_TRACE_DROP_DRV_ERR_TX);

Is there a reason to not bump error counter here?

>   			goto out;
>   		}
>   
> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> index 8de01aaac4a0..d3c1ca83c75d 100644
> --- a/net/xdp/xsk_buff_pool.c
> +++ b/net/xdp/xsk_buff_pool.c
> @@ -1,5 +1,6 @@
>   // SPDX-License-Identifier: GPL-2.0
>   
