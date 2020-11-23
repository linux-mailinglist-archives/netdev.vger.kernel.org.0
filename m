Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31712C133B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733305AbgKWSc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730117AbgKWSc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 13:32:58 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7C2C0613CF;
        Mon, 23 Nov 2020 10:32:58 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1khGdx-0006GV-Dv; Mon, 23 Nov 2020 19:32:53 +0100
Date:   Mon, 23 Nov 2020 19:32:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     kuba@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, roopa@nvidia.com, nikolay@nvidia.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, sbrivio@redhat.com
Subject: Re: [PATCH net-next] netfilter: bridge: reset skb->pkt_type after
 NF_INET_POST_ROUTING traversal
Message-ID: <20201123183253.GA2730@breakpoint.cc>
References: <20201123174902.622102-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201123174902.622102-1-atenart@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Antoine Tenart <atenart@kernel.org> wrote:
> Netfilter changes PACKET_OTHERHOST to PACKET_HOST before invoking the
> hooks as, while it's an expected value for a bridge, routing expects
> PACKET_HOST. The change is undone later on after hook traversal. This
> can be seen with pairs of functions updating skb>pkt_type and then
> reverting it to its original value:
> 
> For hook NF_INET_PRE_ROUTING:
>   setup_pre_routing / br_nf_pre_routing_finish
> 
> For hook NF_INET_FORWARD:
>   br_nf_forward_ip / br_nf_forward_finish
> 
> But the third case where netfilter does this, for hook
> NF_INET_POST_ROUTING, the packet type is changed in br_nf_post_routing
> but never reverted. A comment says:
> 
>   /* We assume any code from br_dev_queue_push_xmit onwards doesn't care
>    * about the value of skb->pkt_type. */

[..]
> But when having a tunnel (say vxlan) attached to a bridge we have the
> following call trace:

> In this specific case, this creates issues such as when an ICMPv6 PTB
> should be sent back. When CONFIG_BRIDGE_NETFILTER is enabled, the PTB
> isn't sent (as skb_tunnel_check_pmtu checks if pkt_type is PACKET_HOST
> and returns early).
> 
> If the comment is right and no one cares about the value of
> skb->pkt_type after br_dev_queue_push_xmit (which isn't true), resetting
> it to its original value should be safe.

That comment is 18 years old, safe bet noone thought of
ipv6-in-tunnel-interface-added-as-bridge-port back then.

Reviewed-by: Florian Westphal <fw@strlen.de>
