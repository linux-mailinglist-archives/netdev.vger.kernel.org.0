Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D56E22A01A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 21:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgGVTXA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 22 Jul 2020 15:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVTXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 15:23:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB39C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 12:23:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jyKKK-0002O8-6v; Wed, 22 Jul 2020 21:22:52 +0200
Date:   Wed, 22 Jul 2020 21:22:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 2/2] net: openvswitch: make masks cache size
 configurable
Message-ID: <20200722192252.GC23458@breakpoint.cc>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
 <159540647223.619787.13052866492035799125.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <159540647223.619787.13052866492035799125.stgit@ebuild>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron <echaudro@redhat.com> wrote:
> This patch makes the masks cache size configurable, or with
> a size of 0, disable it.
> 
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  include/uapi/linux/openvswitch.h |    1 
>  net/openvswitch/datapath.c       |   11 +++++
>  net/openvswitch/flow_table.c     |   86 ++++++++++++++++++++++++++++++++++----
>  net/openvswitch/flow_table.h     |   10 ++++
>  4 files changed, 98 insertions(+), 10 deletions(-)
> 
> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> index 7cb76e5ca7cf..8300cc29dec8 100644
> --- a/include/uapi/linux/openvswitch.h
> +++ b/include/uapi/linux/openvswitch.h
> @@ -86,6 +86,7 @@ enum ovs_datapath_attr {
>  	OVS_DP_ATTR_MEGAFLOW_STATS,	/* struct ovs_dp_megaflow_stats */
>  	OVS_DP_ATTR_USER_FEATURES,	/* OVS_DP_F_*  */
>  	OVS_DP_ATTR_PAD,
> +	OVS_DP_ATTR_MASKS_CACHE_SIZE,

This new attr should probably get an entry in
datapath.c datapath_policy[].

> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1535,6 +1535,10 @@ static int ovs_dp_cmd_fill_info(struct datapath *dp, struct sk_buff *skb,
>  	if (nla_put_u32(skb, OVS_DP_ATTR_USER_FEATURES, dp->user_features))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, OVS_DP_ATTR_MASKS_CACHE_SIZE,
> +			ovs_flow_tbl_masks_cache_size(&dp->table)))
> +		goto nla_put_failure;
> +
>  	genlmsg_end(skb, ovs_header);
>  	return 0;


ovs_dp_cmd_msg_size() should add another nla_total_size(sizeof(u32))
to make sure there is enough space.

> +	if (a[OVS_DP_ATTR_MASKS_CACHE_SIZE]) {
> +		u32 cache_size;
> +
> +		cache_size = nla_get_u32(a[OVS_DP_ATTR_MASKS_CACHE_SIZE]);
> +		ovs_flow_tbl_masks_cache_resize(&dp->table, cache_size);
> +	}

I see a 0 cache size is legal (turns it off) and that the allocation
path has a few sanity checks as well.

Would it make sense to add min/max policy to datapath_policy[] for this
as well?
