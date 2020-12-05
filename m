Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81852CFF93
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 23:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbgLEWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 17:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:38702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEWzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 17:55:39 -0500
Date:   Sat, 5 Dec 2020 14:54:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607208898;
        bh=Lxw7fEwMx6fUBFMy5Q1tbFfxLIBq+XcohlfcqNVHltQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzo1pthmW4KeCL2lEJmGto7jAkCPopi64od8cdgDRVfDjUDd9eRLHFgDyK1jq39G9
         v6JsdH9hua26uNztf7ycaFEs8Gz0O8liFUwqE23wtZb1gcu2kYSkghLcf1mxhG3saw
         lS8JLlePyoPoJyV7kf3d3DyF9/4IjYaTwjGwr5Ik8uAFCW8ISV92v0+wPB1xZGMu3Y
         6P1GShsbEkn5z0fXYc1Lj9OlADpnbz1ZrvuOy3rrm84yxp0DaX6b/hVh6c1GqXnu1O
         zr/uAWjldRl7RZAraqVAJNYJgqNBZ/8MCCifCGdoR21xTHJBrSwTlMObNY8ezEsZZk
         2pMWfqFl59mbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, davem@davemloft.net, sbhatta@marvell.com
Subject: Re: [PATCH] octeontx2-pf: Add RSS multi group support
Message-ID: <20201205145456.704f6061@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <1607073891-96670-1-git-send-email-gakula@marvell.com>
References: <1607073891-96670-1-git-send-email-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 14:54:51 +0530 Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS groups/contexts
> and use the same as destination for flow steering rules.
> 
> usage:
> To steer the traffic to RQ 2,3
> 
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
> 
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> 
> To delete the context
> ethtool -X eth0 context 1 delete
> 
> When an RSS context is removed, the active classification
> rules using this context are also removed.
> 
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>

Looks good, minor coding nits below.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 73fb94d..0c84dcf 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -270,14 +270,17 @@ int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
>  	return err;
>  }
>  
> -int otx2_set_rss_table(struct otx2_nic *pfvf)
> +int otx2_set_rss_table(struct otx2_nic *pfvf, int ctx_id)
>  {
>  	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
> +	int index = rss->rss_size * ctx_id;

const?

>  	struct mbox *mbox = &pfvf->mbox;
> +	struct otx2_rss_ctx *rss_ctx;
>  	struct nix_aq_enq_req *aq;
>  	int idx, err;
>  
>  	mutex_lock(&mbox->lock);
> +	rss_ctx = rss->rss_ctx[ctx_id];
>  	/* Get memory to put this msg */
>  	for (idx = 0; idx < rss->rss_size; idx++) {
>  		aq = otx2_mbox_alloc_msg_nix_aq_enq(mbox);

> +/* RSS context configuration */
> +static int otx2_set_rxfh_context(struct net_device *dev, const u32 *indir,
> +				 const u8 *hkey, const u8 hfunc,
> +				 u32 *rss_context, bool delete)
> +{
>  	struct otx2_nic *pfvf = netdev_priv(dev);
> +	struct otx2_rss_ctx *rss_ctx;
> +	struct otx2_rss_info *rss;
> +	int ret, idx;
> +
> +	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
> +
> +	rss = &pfvf->hw.rss_info;
>  
> -	return pfvf->hw.rss_info.rss_size;
> +	if (!rss->enable) {
> +		netdev_err(dev, "RSS is disabled, cannot change settings\n");
> +		return -EIO;
> +	}
> +
> +	if (hkey) {
> +		memcpy(rss->key, hkey, sizeof(rss->key));
> +		otx2_set_rss_key(pfvf);
> +	}
> +	if (delete)
> +		return otx2_rss_ctx_delete(pfvf, *rss_context);
> +
> +	if (*rss_context == ETH_RXFH_CONTEXT_ALLOC) {
> +		ret = otx2_rss_ctx_create(pfvf, rss_context);
> +		if (ret)
> +			return ret;
> +	}
> +	if (indir) {
> +		rss_ctx = rss->rss_ctx[*rss_context];
> +		for (idx = 0; idx < rss->rss_size; idx++)
> +			rss_ctx->ind_tbl[idx] = indir[idx];
> +	}
> +	otx2_set_rss_table(pfvf, *rss_context);
> +
> +	return 0;
> +}
> +
> +static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
> +				 u8 *hkey, u8 *hfunc, u32 rss_context)
> +{
> +	struct otx2_nic *pfvf = netdev_priv(dev);
> +	struct otx2_rss_ctx *rss_ctx;
> +	struct otx2_rss_info *rss;
> +	int idx;
> +
> +	rss = &pfvf->hw.rss_info;
> +
> +	if (!rss->enable) {
> +		netdev_err(dev, "RSS is disabled\n");
> +		return -EIO;
> +	}
> +	if (rss_context >= MAX_RSS_GROUPS)
> +		return -EINVAL;
> +
> +	rss_ctx = rss->rss_ctx[rss_context];
> +	if (!rss_ctx)
> +		return -EINVAL;
> +
> +	if (indir) {
> +		for (idx = 0; idx < rss->rss_size; idx++)
> +			indir[idx] = rss_ctx->ind_tbl[idx];
> +	}
> +	if (hkey)
> +		memcpy(hkey, rss->key, sizeof(rss->key));
> +
> +	if (hfunc)
> +		*hfunc = ETH_RSS_HASH_TOP;
> +
> +	return 0;
>  }

Can the old callbacks not be converted to something like:

static int otx2_get_rxfh(...)
{
	return otx2_get_rxfh_context(..., DEFAULT_RSS_CONTEXT_GROUP);
}

?

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> index be8ccfc..e5f6b4a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
> @@ -17,6 +17,7 @@ struct otx2_flow {
>  	u16 entry;
>  	bool is_vf;
>  	int vf;
> +	u8 rss_ctx_id;

If you put it next to the bool it will make the structure smaller (less
padding).

>  };
>  
>  int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)

> @@ -521,7 +523,6 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
>  		mutex_unlock(&pfvf->mbox.lock);
>  		return err;
>  	}
> -

Unrelated whitespace change.

>  	req->entry = flow->entry;
>  	req->intf = NIX_INTF_RX;
>  	req->set_cntr = 1;

> @@ -555,9 +560,10 @@ static int otx2_add_flow_msg(struct otx2_nic *pfvf, struct otx2_flow *flow)
>  	return err;
>  }
>  
> -int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rx_flow_spec *fsp)
> +int otx2_add_flow(struct otx2_nic *pfvf, struct ethtool_rxnfc *nfc)
>  {
>  	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
> +	struct ethtool_rx_flow_spec *fsp = &nfc->fs;
>  	u32 ring = ethtool_get_flow_spec_ring(fsp->ring_cookie);

Please keep variable decl lines sorted longest to shortest.

>  	struct otx2_flow *flow;
>  	bool new = false;

> @@ -643,10 +652,27 @@ int otx2_remove_flow(struct otx2_nic *pfvf, u32 location)
>  	list_del(&flow->list);
>  	kfree(flow);
>  	flow_cfg->nr_flows--;
> -

Unrelated whitespace change.

>  	return 0;
>  }
>  
> +void  otx2_rss_ctx_flow_del(struct otx2_nic *pfvf, int ctx_id)

Double space after void

> +{
> +	struct otx2_flow *flow, *tmp;
> +	int err;
> +
> +	list_for_each_entry_safe(flow, tmp, &pfvf->flow_cfg->flow_list, list) {
> +		if (!flow)
> +			return;

I don't think you can possibly have a NULL entry on a standard list.

> +		if (flow->rss_ctx_id != ctx_id)
> +			continue;
> +		err = otx2_remove_flow(pfvf, flow->location);
> +		if (err)
> +			netdev_warn(pfvf->netdev,
> +				    "Can't delete the rule %d associated with this rss group",
> +				    flow->location);

Printing the error code could be useful : %d", ..., err);

> +	}
> +}
