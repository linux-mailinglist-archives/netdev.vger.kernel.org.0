Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276202AA073
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgKFWdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:33:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:47224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgKFWdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:33:13 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920C620704;
        Fri,  6 Nov 2020 22:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701992;
        bh=d86fYDpRno9xToQsZDXPrqiZzTMKBXqk/kOjoUJFWq4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=THMbBV0sWqJcBZ/dlGorrBPqbqiDHMWO6SmiOKNKEoziWrROD4SyAlj4Flss5JPcd
         bqyoREJ2vbn9jpvxbXJoge60+8H8ZZOz6eR9nyZfoa8HlQnvRkg9rcudMnEP0eXG35
         RNNVfQNQtrWR/p4o8Jw66AYBUXlNbt83ilYbMr5M=
Message-ID: <97db181208531f427a03c877b9e2cd0cb1105bd1.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 09/13] octeontx2-pf: Implement
 ingress/egress VLAN offload
From:   Saeed Mahameed <saeed@kernel.org>
To:     Naveen Mamindlapalli <naveenm@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Date:   Fri, 06 Nov 2020 14:33:10 -0800
In-Reply-To: <20201105092816.819-10-naveenm@marvell.com>
References: <20201105092816.819-1-naveenm@marvell.com>
         <20201105092816.819-10-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-05 at 14:58 +0530, Naveen Mamindlapalli wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> This patch implements egress VLAN offload by appending NIX_SEND_EXT_S
> header to NIX_SEND_HDR_S. The VLAN TCI information is specified
> in the NIX_SEND_EXT_S. The VLAN offload in the ingress path is
> implemented by configuring the NIX_RX_VTAG_ACTION_S to strip and
> capture the outer vlan fields. The NIX PF allocates one MCAM entry
> for Rx VLAN offload.
> 
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> ---

..

> @@ -56,6 +58,8 @@ void otx2_mcam_flow_del(struct otx2_nic *pf)
>  int otx2_alloc_mcam_entries(struct otx2_nic *pfvf)
>  {
>  	struct otx2_flow_config *flow_cfg = pfvf->flow_cfg;
> +	netdev_features_t wanted = NETIF_F_HW_VLAN_STAG_RX |
> +				   NETIF_F_HW_VLAN_CTAG_RX;
>  	struct npc_mcam_alloc_entry_req *req;
>  	struct npc_mcam_alloc_entry_rsp *rsp;
>  	int i;
> @@ -88,15 +92,22 @@ int otx2_alloc_mcam_entries(struct otx2_nic
> *pfvf)
>  	if (rsp->count != req->count) {
>  		netdev_info(pfvf->netdev, "number of rules truncated to
> %d\n",
>  			    rsp->count);
> +		netdev_info(pfvf->netdev,
> +			    "Disabling RX VLAN offload due to non-
> availability of MCAM space\n");
>  		/* support only ntuples here */
>  		flow_cfg->ntuple_max_flows = rsp->count;
>  		flow_cfg->ntuple_offset = 0;
>  		pfvf->netdev->priv_flags &= ~IFF_UNICAST_FLT;
>  		pfvf->flags &= ~OTX2_FLAG_UCAST_FLTR_SUPPORT;
> +		pfvf->flags &= ~OTX2_FLAG_RX_VLAN_SUPPORT;
> +		pfvf->netdev->features &= ~wanted;
> +		pfvf->netdev->hw_features &= ~wanted;

Drivers are not allowed to change own features dynamically.

please see:
https://www.kernel.org/doc/html/latest/networking/netdev-features.html

Features dependencies must be resolved via: 
ndo_fix_features() and netdev_update_features();

 
> +static netdev_features_t
> +otx2_features_check(struct sk_buff *skb, struct net_device *dev,
> +		    netdev_features_t features)
> +{
> +	return features;
> +}
> +

what is the point of no-op features_check ?


