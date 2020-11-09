Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8560D2AC757
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgKIVgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:36:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIVgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:36:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2736C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 13:36:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kcEpR-0006Ja-IZ; Mon, 09 Nov 2020 22:35:57 +0100
Date:   Mon, 9 Nov 2020 22:35:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     nusiddiq@redhat.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [net-next] netfiler: conntrack: Add the option to set ct tcp
 flag - BE_LIBERAL per-ct basis.
Message-ID: <20201109213557.GE23619@breakpoint.cc>
References: <20201109072930.14048-1-nusiddiq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109072930.14048-1-nusiddiq@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nusiddiq@redhat.com <nusiddiq@redhat.com> wrote:
> From: Numan Siddique <nusiddiq@redhat.com>
> 
> Before calling nf_conntrack_in(), caller can set this flag in the
> connection template for a tcp packet and any errors in the
> tcp_in_window() will be ignored.
> 
> A helper function - nf_ct_set_tcp_be_liberal(nf_conn) is added which
> sets this flag for both the directions of the nf_conn.
> 
> openvswitch makes use of this feature so that any out of window tcp
> packets are not marked invalid. Prior to this there was no easy way
> to distinguish if conntracked packet is marked invalid because of
> tcp_in_window() check error or because it doesn't belong to an
> existing connection.
> 
> An earlier attempt (see the link) tried to solve this problem for
> openvswitch in a different way. Florian Westphal instead suggested
> to be liberal in openvswitch for tcp packets.
> 
> Link: https://patchwork.ozlabs.org/project/netdev/patch/20201006083355.121018-1-nusiddiq@redhat.com/
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Numan Siddique <nusiddiq@redhat.com>
> ---
>  include/net/netfilter/nf_conntrack_l4proto.h |  6 ++++++
>  net/netfilter/nf_conntrack_core.c            | 13 +++++++++++--
>  net/openvswitch/conntrack.c                  |  1 +
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
> index 88186b95b3c2..572ae8d2a622 100644
> --- a/include/net/netfilter/nf_conntrack_l4proto.h
> +++ b/include/net/netfilter/nf_conntrack_l4proto.h
> @@ -203,6 +203,12 @@ static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
>  {
>  	return &net->ct.nf_ct_proto.icmpv6;
>  }
> +
> +static inline void nf_ct_set_tcp_be_liberal(struct nf_conn *ct)
> +{
> +	ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> +	ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
> +}
>  #endif
>  
>  #ifdef CONFIG_NF_CT_PROTO_DCCP
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 234b7cab37c3..8290c5b04e88 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1748,10 +1748,18 @@ static int nf_conntrack_handle_packet(struct nf_conn *ct,
>  				      struct sk_buff *skb,
>  				      unsigned int dataoff,
>  				      enum ip_conntrack_info ctinfo,
> -				      const struct nf_hook_state *state)
> +				      const struct nf_hook_state *state,
> +				      union nf_conntrack_proto *tmpl_proto)

I would prefer if we could avoid adding yet another function argument.

AFAICS its enough to call the new nf_ct_set_tcp_be_liberal() helper
before nf_conntrack_confirm() in ovs_ct_commit(), e.g.:

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1235,10 +1235,13 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
        if (!nf_ct_is_confirmed(ct)) {
                err = ovs_ct_init_labels(ct, key, &info->labels.value,
                                         &info->labels.mask);
                if (err)
                        return err;
+
+               if (nf_ct_protonum(ct) == IPPROTO_TCP)
+                       nf_ct_set_tcp_be_liberal(ct);

