Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEC2456001
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 16:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhKRQA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:00:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232079AbhKRQA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:00:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5093C6152B;
        Thu, 18 Nov 2021 15:57:55 +0000 (UTC)
Date:   Thu, 18 Nov 2021 10:57:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, davem@davemloft.net, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        ycheng@google.com, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: snmp: add tracepoint support for
 snmp
Message-ID: <20211118105752.1d46e990@gandalf.local.home>
In-Reply-To: <20211118124812.106538-2-imagedong@tencent.com>
References: <20211118124812.106538-1-imagedong@tencent.com>
        <20211118124812.106538-2-imagedong@tencent.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 20:48:11 +0800
menglong8.dong@gmail.com wrote:

> From: Menglong Dong <imagedong@tencent.com>
> 
> snmp is the network package statistics module in kernel, and it is
> useful in network issue diagnosis, such as packet drop.
> 
> However, it is hard to get the detail information about the packet.
> For example, we can know that there is something wrong with the
> checksum of udp packet though 'InCsumErrors' of UDP protocol in
> /proc/net/snmp, but we can't figure out the ip and port of the packet
> that this error is happening on.
> 
> Add tracepoint for snmp. Therefor, users can use some tools (such as
> eBPF) to get the information of the exceptional packet.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> v2:
> - use a single event, instead of creating events for every protocols
> ---
>  include/trace/events/snmp.h | 44 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/snmp.h   | 21 ++++++++++++++++++
>  net/core/net-traces.c       |  3 +++
>  3 files changed, 68 insertions(+)
>  create mode 100644 include/trace/events/snmp.h
> 
> diff --git a/include/trace/events/snmp.h b/include/trace/events/snmp.h
> new file mode 100644
> index 000000000000..1fa2e31056e0
> --- /dev/null
> +++ b/include/trace/events/snmp.h
> @@ -0,0 +1,44 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM snmp
> +
> +#if !defined(_TRACE_SNMP_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_SNMP_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/skbuff.h>
> +#include <linux/snmp.h>

Add:

#define TRACE_MIB_VALUES			\
	EM(TRACE_MIB_NUM,	NUM)		\
	EM(TRACE_MIB_IP,	IP)		\
	EM(TRACE_MIB_IPV6,	IPV6)		\
	EM(TRACE_MIB_TCP,	TCP)		\
	EM(TRACE_MIB_NET,	NET)		\
	EM(TRACE_MIB_ICMP,	ICMP)		\
	EM(TRACE_MIB_ICMPV6,	ICMPV6)		\
	EM(TRACE_MIB_ICMPMSG,	ICMPMSG)	\
	EM(TRACE_MIB_ICMPV6MSG,	ICMPV6MSG)	\
	EM(TRACE_MIB_UDP,	UDP)		\
	EM(TRACE_MIB_UDPV6,	UDPV6)		\
	EM(TRACE_MIB_UDPLITE,	UDPLITE)	\
	EM(TRACE_MIB_UDPV6LITE,	UDPV6LITE)	\
	EM(TRACE_MIB_XFRM,	XFRM)		\
	EM(TRACE_MIB_TLS,	TLS)		\
	EMe(TRACE_MIB_MPTCP,	MPTCP)

#define TRACE_UDP_MIB_VALUES				\
	EM(UDP_MIB_NUM,		NUM)			\
	EM(UDP_MIB_INDATAGRAMS,		INDATAGRAMS)	\
	EM(UDP_MIB_NOPORTS,		NOPORTS)	\
	EM(UDP_MIB_INERRORS,		INERRORS)	\
	EM(UDP_MIB_OUTDATAGRAMS,	OUTDATAGRAMS)	\
	EM(UDP_MIB_RCVBUFERRORS,	RCVBUFERRORS)	\
	EM(UDP_MIB_SNDBUFERRORS,	SNDBUFERRORS)	\
	EM(UDP_MIB_CSUMERRORS,		CSUMERRORS)	\
	EM(UDP_MIB_IGNOREDMULTI,	IGNOREDMULTI)	\
	EMe(UDP_MIB_MEMERRORS,		MEMERRORS)

#undef EM
#undef EMe
#define EM(a, b)        TRACE_DEFINE_ENUM(a);
#define EMe(a, b)       TRACE_DEFINE_ENUM(a);

TRACE_MIB_VALUES
TRACE_UDP_MIB_VALES

#undef EM
#undef EMe
#define EM(a,b)		{ a , #b },
#define EMe(a,b)	{ a , #b }

> +
> +DECLARE_EVENT_CLASS(snmp_template,
> +
> +	TP_PROTO(struct sk_buff *skb, int type, int field, int val),
> +
> +	TP_ARGS(skb, type, field, val),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, skbaddr)
> +		__field(int, type)
> +		__field(int, field)
> +		__field(int, val)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->skbaddr = skb;
> +		__entry->type = type;
> +		__entry->field = field;
> +		__entry->val = val;
> +	),
> +
> +	TP_printk("skbaddr=%p, type=%d, field=%d, val=%d",

Then have here:

	__enrty->skbaddr, __print_symbolic(__entry->type, TRACE_MIB_VALUES),
	__print_symbolic(__entry->field, TRACE_UDP_MIB_VALUES),
	__print_symbolic(__entry->val, { 0, "Decrease" }, { 1, "Increase" })

And then the output will have the proper English terms and not have to rely
on the user knowing what the numbers represent. Also, it allows them to
change in the future.

-- Steve

> +		  __entry->skbaddr, __entry->type,
> +		  __entry->field, __entry->val)
> +);
> +
> +DEFINE_EVENT(snmp_template, snmp,
> +	TP_PROTO(struct sk_buff *skb, int type, int field, int val),
> +	TP_ARGS(skb, type, field, val)
> +);
> +
> +#endif
> +
> +#include <trace/define_trace.h>
> diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
> index 904909d020e2..b96077e09a58 100644
> --- a/include/uapi/linux/snmp.h
> +++ b/include/uapi/linux/snmp.h
> @@ -347,4 +347,25 @@ enum
>  	__LINUX_MIB_TLSMAX
>  };
>  
> +/* mib type definitions for trace event */
> +enum {
> +	TRACE_MIB_NUM = 0,
> +	TRACE_MIB_IP,
> +	TRACE_MIB_IPV6,
> +	TRACE_MIB_TCP,
> +	TRACE_MIB_NET,
> +	TRACE_MIB_ICMP,
> +	TRACE_MIB_ICMPV6,
> +	TRACE_MIB_ICMPMSG,
> +	TRACE_MIB_ICMPV6MSG,
> +	TRACE_MIB_UDP,
> +	TRACE_MIB_UDPV6,
> +	TRACE_MIB_UDPLITE,
> +	TRACE_MIB_UDPV6LITE,
> +	TRACE_MIB_XFRM,
> +	TRACE_MIB_TLS,
> +	TRACE_MIB_MPTCP,
> +	__TRACE_MIB_MAX
> +};
> +
>  #endif	/* _LINUX_SNMP_H */
> diff --git a/net/core/net-traces.c b/net/core/net-traces.c
> index c40cd8dd75c7..e291c0974438 100644
> --- a/net/core/net-traces.c
> +++ b/net/core/net-traces.c
> @@ -35,6 +35,7 @@
>  #include <trace/events/tcp.h>
>  #include <trace/events/fib.h>
>  #include <trace/events/qdisc.h>
> +#include <trace/events/snmp.h>
>  #if IS_ENABLED(CONFIG_BRIDGE)
>  #include <trace/events/bridge.h>
>  EXPORT_TRACEPOINT_SYMBOL_GPL(br_fdb_add);
> @@ -61,3 +62,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(napi_poll);
>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_send_reset);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(tcp_bad_csum);
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(snmp);

