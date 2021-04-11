Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1389835B33F
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 12:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235169AbhDKK6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 06:58:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45860 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhDKK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 06:58:46 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 832DC63E6E;
        Sun, 11 Apr 2021 12:58:05 +0200 (CEST)
Date:   Sun, 11 Apr 2021 12:58:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next 1/1] netfilter: flowtable: Make sure dst_cache
 is valid before using it
Message-ID: <20210411105826.GB21185@salvia>
References: <20210411081334.1994938-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20210411081334.1994938-1-roid@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Roi,

On Sun, Apr 11, 2021 at 11:13:34AM +0300, Roi Dayan wrote:
> It could be dst_cache was not set so check it's not null before using
> it.

Could you give a try to this fix?

net/sched/act_ct.c leaves the xmit_type as FLOW_OFFLOAD_XMIT_UNSPEC
since it does not cache a route.

Thanks.

> Fixes: 8b9229d15877 ("netfilter: flowtable: dst_check() from garbage collector path")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 76573bae6664..e426077aaed1 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -410,6 +410,8 @@ static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
>  	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
>  	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
>  		dst = tuple->dst_cache;
> +		if (!dst)
> +			return false;
>  		if (!dst_check(dst, tuple->dst_cookie))
>  			return true;
>  	}
> -- 
> 2.26.2
> 

--tThc/1wpZn/ma/RB
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 583b327d8fc0..9b42c6523b4d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -90,7 +90,8 @@ enum flow_offload_tuple_dir {
 #define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
 enum flow_offload_xmit_type {
-	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
+	FLOW_OFFLOAD_XMIT_UNSPEC	= 0,
+	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 76573bae6664..ea23a36dc14e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -130,6 +130,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
+	case FLOW_OFFLOAD_XMIT_UNSPEC:
+		WARN_ON_ONCE(1);
+		break;
 	}
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
 

--tThc/1wpZn/ma/RB--
