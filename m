Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF92869F0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgJGVNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:13:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:35211 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgJGVNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 17:13:52 -0400
IronPort-SDR: 9ilKvOG2cVw6p2FpoM4276qYODBFsODqKwEysK63feovhPUEMMh/CN8q41bQp3asRbGtUBjn2R
 aa1eg5Hqx+8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="164358307"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="164358307"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 14:13:52 -0700
IronPort-SDR: wHyGVH/JtGjfRKq9/6gWjX5L7dCn8rcEFQ7EHJcxVa47SkQmSVrLV9lTsdIoYx5TLiaA69qxKq
 1cFs613qAW0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="311931450"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 07 Oct 2020 14:13:49 -0700
Date:   Wed, 7 Oct 2020 23:06:15 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     sven.auhagen@voleatech.de
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com
Subject: Re: [PATCH 2/7] igb: take vlan double header into account
Message-ID: <20201007210615.GA48010@ranger.igk.intel.com>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
 <20201007152506.66217-3-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007152506.66217-3-sven.auhagen@voleatech.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 05:25:01PM +0200, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Increase the packet header padding to include double VLAN tagging.
> This patch uses a macro for this.
> 
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> ---
>  drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
>  drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
> index 0286d2fceee4..7afb67cf9b94 100644
> --- a/drivers/net/ethernet/intel/igb/igb.h
> +++ b/drivers/net/ethernet/intel/igb/igb.h
> @@ -138,6 +138,8 @@ struct vf_mac_filter {
>  /* this is the size past which hardware will drop packets when setting LPE=0 */
>  #define MAXIMUM_ETHERNET_VLAN_SIZE 1522
>  
> +#define IGB_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
> +
>  /* Supported Rx Buffer Sizes */
>  #define IGB_RXBUFFER_256	256
>  #define IGB_RXBUFFER_1536	1536
> @@ -247,6 +249,9 @@ enum igb_tx_flags {
>  #define IGB_SFF_ADDRESSING_MODE		0x4
>  #define IGB_SFF_8472_UNSUP		0x00
>  
> +/* TX ressources are shared between XDP and netstack
> + * and we need to tag the buffer type to distinguish them
> + */

s/ressources/resources/

This comment sort of does not belong to this commit but I'm not sure what
place would be better.

>  enum igb_tx_buf_type {
>  	IGB_TYPE_SKB = 0,
>  	IGB_TYPE_XDP,
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 08cc6f59aa2e..0a9198037b98 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -2826,7 +2826,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
>  
>  static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>  {
> -	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> +	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
>  	struct igb_adapter *adapter = netdev_priv(dev);
>  	bool running = netif_running(dev);
>  	struct bpf_prog *old_prog;
> @@ -3950,8 +3950,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
>  	/* set default work limits */
>  	adapter->tx_work_limit = IGB_DEFAULT_TX_WORK;
>  
> -	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
> -				  VLAN_HLEN;
> +	adapter->max_frame_size = netdev->mtu + IGB_ETH_PKT_HDR_PAD;
>  	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
>  
>  	spin_lock_init(&adapter->nfc_lock);
> @@ -6491,7 +6490,7 @@ static void igb_get_stats64(struct net_device *netdev,
>  static int igb_change_mtu(struct net_device *netdev, int new_mtu)
>  {
>  	struct igb_adapter *adapter = netdev_priv(netdev);
> -	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
> +	int max_frame = new_mtu + IGB_ETH_PKT_HDR_PAD;
>  
>  	if (adapter->xdp_prog) {
>  		int i;
> -- 
> 2.20.1
> 
