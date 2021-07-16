Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863F03CB235
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 08:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhGPGMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 02:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhGPGMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 02:12:34 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B11C06175F;
        Thu, 15 Jul 2021 23:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rHxVMuUJUfdCqmA6JXmZIZSNi3VNgFpNTCKRuswm7zg=; b=MqAH+mJwVPa3XWB+8MD5U7KT/x
        bQupkTjZNC5/U5QmYulpT2fnXFnXgrL32NGzED+Z/FsGC2H0WTFKpUOP75feP2xrNfylrwK66ZToc
        QhMrOjuu1WgxSdHu4Ftx3utYMzPbmz3iW5NFmQNPI4Qa+J5zzBwTmOl2n0BC3991g2DY=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m4H2W-0000ll-J9; Fri, 16 Jul 2021 08:09:36 +0200
Subject: Re: [RFC 3/7] net: ethernet: mtk_eth_soc: implement flow offloading
 to WED devices
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        ryder.lee@mediatek.com
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-4-nbd@nbd.name> <20210713185641.GB26070@salvia>
 <ceee6c30-adc1-3a79-31c3-983fe848699c@nbd.name>
 <20210715213626.GA19271@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <c6887708-6f75-bc05-1934-ddffa2f395a0@nbd.name>
Date:   Fri, 16 Jul 2021 08:09:36 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210715213626.GA19271@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-07-15 23:36, Pablo Neira Ayuso wrote:
> On Wed, Jul 14, 2021 at 10:26:08AM +0200, Felix Fietkau wrote:
>> On 2021-07-13 20:56, Pablo Neira Ayuso wrote:
> [...]
>> >> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> >> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> >> @@ -10,6 +10,7 @@
>> >>  #include <net/pkt_cls.h>
>> >>  #include <net/dsa.h>
>> >>  #include "mtk_eth_soc.h"
>> >> +#include "mtk_wed.h"
>> >>  
>> >>  struct mtk_flow_data {
>> >>  	struct ethhdr eth;
>> >> @@ -39,6 +40,7 @@ struct mtk_flow_entry {
>> >>  	struct rhash_head node;
>> >>  	unsigned long cookie;
>> >>  	u16 hash;
>> >> +	s8 wed_index;
>> >>  };
>> >>  
>> >>  static const struct rhashtable_params mtk_flow_ht_params = {
>> >> @@ -127,35 +129,38 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
>> >>  }
>> >>  
>> >>  static int
>> >> -mtk_flow_get_dsa_port(struct net_device **dev)
>> >> +mtk_flow_set_output_device(struct mtk_eth *eth, struct mtk_foe_entry *foe,
>> >> +			   struct net_device *dev, const u8 *dest_mac,
>> >> +			   int *wed_index)
>> >>  {
>> >> -#if IS_ENABLED(CONFIG_NET_DSA)
>> >> -	struct dsa_port *dp;
>> >> -
>> >> -	dp = dsa_port_from_netdev(*dev);
>> >> -	if (IS_ERR(dp))
>> >> -		return -ENODEV;
>> >> -
>> >> -	if (dp->cpu_dp->tag_ops->proto != DSA_TAG_PROTO_MTK)
>> >> -		return -ENODEV;
>> >> +	struct net_device_path_ctx ctx = {
>> >> +		.dev    = dev,
>> >> +		.daddr  = dest_mac,
>> >> +	};
>> >> +	struct net_device_path path = {};
>> >> +	int pse_port;
>> >>  
>> >> -	*dev = dp->cpu_dp->master;
>> >> +	if (!dev->netdev_ops->ndo_fill_forward_path ||
>> >> +	    dev->netdev_ops->ndo_fill_forward_path(&ctx, &path) < 0)
>> >> +		path.type = DEV_PATH_ETHERNET;
>> > 
>> > Maybe expose this through flow offload API so there is no need to call
>> > ndo_fill_forward_path again from the driver?
>>
>> Can you give me a pseudo-code example? I'm not sure how you want it to
>> be exposed through the flow offload API.
> 
> in a few steps:
> 
> 1) Extend nft_dev_path_info() to deal with DEV_PATH_WDMA, it will
>    just actually fetch a pointer to structure that is allocated
>    by the driver.
> 
> - Update the net_device_path structure with this layout:
> 
>         struct flow_action_wdma {
>                 enum wdma_type type;    // MTK_WDMA goes here
>                 union {
>                         struct {
>                                 ...;
>                         } mtk;
>                 };
>         } wdma;
> 
> Add:
>         struct flow_action_wdma         *wdma;
> 
> to net_device_path.
> 
> 2) Pass on this pointer to structure to the nf_flow_route
>    wheelbarrow.
> 
> 3) Store this information in the struct flow_offload_tuple,
>    in a new struct flow_offload_hw *field to store all hardware
>    offload specific information (not needed by software path). There
>    is already hw_outdev that can be placed there.
> 
> 4) Add a FLOW_ACTION_WDMA action to the flow offload API to
>    pass on the flow_action_wdma structure.
I think it should probably be called FLOW_ACTION_MTK_WDMA (and be
mediatek specific), or we should pick a more generic name for it.

> It's a bit of work the first time to accomodate the requirements of
> new API, but then all drivers will benefit from this.
> 
> It's also a bit of layering, but with more drivers in the tree, this
> API can be simplified incrementally.
> 
> I can take a stab at it and send you a patch.
Thanks. If we do this for WDMA, shouldn't we also do it for DSA to keep
things consistent?

- Felix
