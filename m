Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E866E117
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 15:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjAQOnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 09:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjAQOmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 09:42:50 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B014D3D093;
        Tue, 17 Jan 2023 06:42:48 -0800 (PST)
Date:   Tue, 17 Jan 2023 15:42:45 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8az5ecHLgE611hJ@salvia>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-2-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230113165548.2692720-2-vladbu@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Fri, Jan 13, 2023 at 05:55:42PM +0100, Vlad Buslov wrote:
> In order to offload connections in other states besides "established" the
> driver offload callbacks need to have access to connection conntrack info.
> Extend flow offload intermediate representation data structure
> flow_action_entry->ct_metadata with new enum ip_conntrack_info field and
> fill it in tcf_ct_flow_table_add_action_meta() callback.
> 
> Reject offloading IP_CT_NEW connections for now by returning an error in
> relevant driver callbacks based on value of ctinfo. Support for offloading
> such connections will need to be added to the drivers afterwards.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
> 
> Notes:
>     Changes V1 -> V2:
>     
>     - Add missing include that caused compilation errors on certain configs.
>     
>     - Change naming in nfp driver as suggested by Simon and Baowen.
> 
>  .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
>  .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++++++++++++++
>  include/net/flow_offload.h                    |  2 ++
>  net/sched/act_ct.c                            |  1 +
>  4 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 313df8232db7..8cad5cf3305d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -1077,7 +1077,7 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
>  	int err;
>  
>  	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
> -	if (!meta_action)
> +	if (!meta_action || meta_action->ct_metadata.ctinfo == IP_CT_NEW)
>  		return -EOPNOTSUPP;
>  
>  	spin_lock_bh(&ct_priv->ht_lock);
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> index f693119541d5..f7569584b9d8 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
> @@ -1964,6 +1964,23 @@ int nfp_fl_ct_stats(struct flow_cls_offload *flow,
>  	return 0;
>  }
>  
> +static bool
> +nfp_fl_ct_offload_nft_supported(struct flow_cls_offload *flow)
> +{
> +	struct flow_rule *flow_rule = flow->rule;
> +	struct flow_action *flow_action =
> +		&flow_rule->action;
> +	struct flow_action_entry *act;
> +	int i;
> +
> +	flow_action_for_each(i, act, flow_action) {
> +		if (act->id == FLOW_ACTION_CT_METADATA)
> +			return act->ct_metadata.ctinfo != IP_CT_NEW;
> +	}
> +
> +	return false;
> +}
> +
>  static int
>  nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offload *flow)
>  {
> @@ -1976,6 +1993,9 @@ nfp_fl_ct_offload_nft_flow(struct nfp_fl_ct_zone_entry *zt, struct flow_cls_offl
>  	extack = flow->common.extack;
>  	switch (flow->command) {
>  	case FLOW_CLS_REPLACE:
> +		if (!nfp_fl_ct_offload_nft_supported(flow))
> +			return -EOPNOTSUPP;
> +
>  		/* Netfilter can request offload multiple times for the same
>  		 * flow - protect against adding duplicates.
>  		 */
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 0400a0ac8a29..a6adaffb68fb 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -4,6 +4,7 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/netlink.h>
> +#include <linux/netfilter/nf_conntrack_common.h>
>  #include <net/flow_dissector.h>
>  
>  struct flow_match {
> @@ -288,6 +289,7 @@ struct flow_action_entry {
>  		} ct;
>  		struct {
>  			unsigned long cookie;
> +			enum ip_conntrack_info ctinfo;

Maybe you can use a bool here, only possible states that make sense
are new and established.

>  			u32 mark;
>  			u32 labels[4];
>  			bool orig_dir;
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 0ca2bb8ed026..515577f913a3 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -187,6 +187,7 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
>  	/* aligns with the CT reference on the SKB nf_ct_set */
>  	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
>  	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
> +	entry->ct_metadata.ctinfo = ctinfo;
>  
>  	act_ct_labels = entry->ct_metadata.labels;
>  	ct_labels = nf_ct_labels_find(ct);
> -- 
> 2.38.1
> 
