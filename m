Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CF33CAEA8
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 23:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhGOVjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 17:39:25 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43466 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGOVjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 17:39:23 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2584664228;
        Thu, 15 Jul 2021 23:36:09 +0200 (CEST)
Date:   Thu, 15 Jul 2021 23:36:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
Message-ID: <20210715213626.GA19271@salvia>
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name>
 <20210713185641.GB26070@salvia>
 <ceee6c30-adc1-3a79-31c3-983fe848699c@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ceee6c30-adc1-3a79-31c3-983fe848699c@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:26:08AM +0200, Felix Fietkau wrote:
> On 2021-07-13 20:56, Pablo Neira Ayuso wrote:
[...]
> >> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >> @@ -10,6 +10,7 @@
> >>  #include <net/pkt_cls.h>
> >>  #include <net/dsa.h>
> >>  #include "mtk_eth_soc.h"
> >> +#include "mtk_wed.h"
> >>  
> >>  struct mtk_flow_data {
> >>  	struct ethhdr eth;
> >> @@ -39,6 +40,7 @@ struct mtk_flow_entry {
> >>  	struct rhash_head node;
> >>  	unsigned long cookie;
> >>  	u16 hash;
> >> +	s8 wed_index;
> >>  };
> >>  
> >>  static const struct rhashtable_params mtk_flow_ht_params = {
> >> @@ -127,35 +129,38 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
> >>  }
> >>  
> >>  static int
> >> -mtk_flow_get_dsa_port(struct net_device **dev)
> >> +mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
> >> +			   struct net_device *dev, const u8 *dest_mac,
> >> +			   int *wed_index)
> >>  {
> >> -#if IS_ENABLED(CONFIG_NET_DSA)
> >> -	struct dsa_port *dp;
> >> -
> >> -	dp = dsa_port_from_netdev(*dev);
> >> -	if (IS_ERR(dp))
> >> -		return -ENODEV;
> >> -
> >> -	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
> >> -		return -ENODEV;
> >> +	struct net_device_path_ctx ctx = {
> >> +		.dev    = dev,
> >> +		.daddr  = dest_mac,
> >> +	};
> >> +	struct net_device_path path = {};
> >> +	int pse_port;
> >>  
> >> -	*dev = dp->cpu_dp->master;
> >> +	if (!dev->netdev_ops->ndo_fill_forward_path ||
> >> +	    dev->netdev_ops->ndo_fill_forward_path(&ctx, &path) < 0)
> >> +		path.type = DEV_PATH_ETHERNET;
> > 
> > Maybe expose this through flow offload API so there is no need to call
> > ndo_fill_forward_path again from the driver?
>
> Can you give me a pseudo-code example? I'm not sure how you want it to
> be exposed through the flow offload API.

in a few steps:

1) Extend nft_dev_path_info() to deal with DEV_PATH_WDMA, it will
   just actually fetch a pointer to structure that is allocated
   by the driver.

- Update the net_device_path structure with this layout:

        struct flow_action_wdma {
                enum wdma_type type;    // MTK_WDMA goes here
                union {
                        struct {
                                ...;
                        } mtk;
                };
        } wdma;

Add:
        struct flow_action_wdma         *wdma;

to net_device_path.

2) Pass on this pointer to structure to the nf_flow_route
   wheelbarrow.

3) Store this information in the struct flow_offload_tuple,
   in a new struct flow_offload_hw *field to store all hardware
   offload specific information (not needed by software path). There
   is already hw_outdev that can be placed there.

4) Add a FLOW_ACTION_WDMA action to the flow offload API to
   pass on the flow_action_wdma structure.

It's a bit of work the first time to accomodate the requirements of
new API, but then all drivers will benefit from this.

It's also a bit of layering, but with more drivers in the tree, this
API can be simplified incrementally.

I can take a stab at it and send you a patch.

> To me it seems easier and cleaner to just have a single
> ndo_fill_forward_path call for the final output device to check the
> device types that don't have any corresponding sw offload.

It's simpler yes, but this results in two calls for
ndo_fill_forward_path, one from the core and another from the driver.
I think it's better there's a single point to call to
ndo_fill_forward_path for consolidation.

My proposal requires a bit more plumbing, but all drivers will
get the information that represents the offload in the same way.
