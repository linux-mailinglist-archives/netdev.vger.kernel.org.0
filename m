Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1CE42EDAE
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhJOJcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:32:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48322 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbhJOJcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:32:12 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6F0E663F25;
        Fri, 15 Oct 2021 11:28:26 +0200 (CEST)
Date:   Fri, 15 Oct 2021 11:30:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
Message-ID: <YWlKGFpHa5o5jFgJ@salvia>
References: <20211015090934.2870662-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211015090934.2870662-1-zenczykowski@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 02:09:34AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Without this it's hard to offload udp due to lack of a conntrack event
> at the appropriate time (ie. once udp stream is established and stream
> timeout is in effect).
> 
> Without this udp conntrack events 'update/assured/timeout=30'
> either need to be ignored, or polling loop needs to be <30 second
> instead of <120 second.
> 
> With this change:
>       [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
>    [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
>    [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
>    [UPDATE] udp      17 120 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
>   [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
> (the 3rd update/assured/120 event is new)

Hm, I still don't understand why do you need this extra 3rd
update/assured event event. Could you explain your usecase?

Thanks.

> Cc: Florian Westphal <fw@strlen.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: d535c8a69c19 'netfilter: conntrack: udp: only extend timeout to stream mode after 2s'
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  include/net/netfilter/nf_conntrack.h             |  1 +
>  .../uapi/linux/netfilter/nf_conntrack_common.h   |  1 +
>  net/netfilter/nf_conntrack_proto_udp.c           | 16 ++++++++++++++--
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index cc663c68ddc4..12029d616cfa 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -26,6 +26,7 @@
>  
>  struct nf_ct_udp {
>  	unsigned long	stream_ts;
> +	bool		notified;
>  };
>  
>  /* per conntrack: protocol private data */
> diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
> index 4b3395082d15..a8e91b5821fa 100644
> --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> @@ -144,6 +144,7 @@ enum ip_conntrack_events {
>  	IPCT_SECMARK,		/* new security mark has been set */
>  	IPCT_LABEL,		/* new connlabel has been set */
>  	IPCT_SYNPROXY,		/* synproxy has been set */
> +	IPCT_UDPSTREAM,		/* udp stream has been set */
>  #ifdef __KERNEL__
>  	__IPCT_MAX
>  #endif
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> index 68911fcaa0f1..f0d9869aa30f 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -97,18 +97,23 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  	if (!timeouts)
>  		timeouts = udp_get_timeouts(nf_ct_net(ct));
>  
> -	if (!nf_ct_is_confirmed(ct))
> +	if (!nf_ct_is_confirmed(ct)) {
>  		ct->proto.udp.stream_ts = 2 * HZ + jiffies;
> +		ct->proto.udp.notified = false;
> +	}
>  
>  	/* If we've seen traffic both ways, this is some kind of UDP
>  	 * stream. Set Assured.
>  	 */
>  	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
>  		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
> +		bool stream = false;
>  
>  		/* Still active after two seconds? Extend timeout. */
> -		if (time_after(jiffies, ct->proto.udp.stream_ts))
> +		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
>  			extra = timeouts[UDP_CT_REPLIED];
> +			stream = true;
> +		}
>  
>  		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
>  
> @@ -116,9 +121,16 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
>  		if (unlikely((ct->status & IPS_NAT_CLASH)))
>  			return NF_ACCEPT;
>  
> +		if (stream) {
> +			stream = !ct->proto.udp.notified;
> +			ct->proto.udp.notified = true;
> +		}
> +
>  		/* Also, more likely to be important, and not a probe */
>  		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
>  			nf_conntrack_event_cache(IPCT_ASSURED, ct);
> +		else if (stream)
> +			nf_conntrack_event_cache(IPCT_UDPSTREAM, ct);
>  	} else {
>  		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
>  	}
> -- 
> 2.33.0.1079.g6e70778dc9-goog
> 
