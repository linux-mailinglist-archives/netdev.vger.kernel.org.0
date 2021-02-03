Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEDB30D0CB
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhBCBaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 20:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhBCBaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 20:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 264E664E3D;
        Wed,  3 Feb 2021 01:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612315760;
        bh=vosx4JH15veIveNb+50DKtCa0cHZifhgUeN1VEmiuzA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k7q/6d+EEQOXGQgF92sEipnrq3BaA2YhbyCauHwzxWebHOrzd6k0kjh5JUh9bWb5o
         YUcweAP5m58Yla2fpYNYKSepzdmQMiamJm0USsxVeoFK0DVJj9Fsp0CX0afTjVkbCo
         rz9AIfSYkQdBi2KM/NCyRnzTsA1WvtQA17dWSF5ueR80YBnTd1oHAiqM4bK2yjSJya
         XcRAioLiPVC9QRURUcN/Dwo8+SR4zquJ087aUv/5mL9im97STpsZKkgI2cNw0hOuWk
         2b01od4W9TkW4NgQr2kdGN/dCJFQnv2XiFV3heqhJdJRhq5bXqpCkTCNKliVc+eMGC
         DQQSWfNVLQDwA==
Date:   Tue, 2 Feb 2021 17:29:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <willemdebruijn.kernel@gmail.com>,
        <andrew@lunn.ch>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>
Subject: Re: [Patch v3 net-next 7/7] octeontx2-pf: ethtool physical link
 configuration
Message-ID: <20210202172919.466bddcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612098665-187767-8-git-send-email-hkelam@marvell.com>
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
        <1612098665-187767-8-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jan 2021 18:41:05 +0530 Hariprasad Kelam wrote:
> From: Christina Jacob <cjacob@marvell.com>
> 
> Register set_link_ksetting callback with driver such that
> link configurations parameters like advertised mode,speed, duplex
> and autoneg can be configured.
> 
> below command
> ethtool -s eth0 advertise 0x1 speed 10 duplex full autoneg on
> 
> Signed-off-by: Christina Jacob <cjacob@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> ---
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 67 ++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index d637815..74a62de 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -1170,6 +1170,72 @@ static int otx2_get_link_ksettings(struct net_device *netdev,
>  	return 0;
>  }
>  
> +static void otx2_get_advertised_mode(const struct ethtool_link_ksettings *cmd,
> +				     u64 *mode)
> +{
> +	u32 bit_pos;
> +
> +	/* Firmware does not support requesting multiple advertised modes
> +	 * return first set bit
> +	 */
> +	bit_pos = find_first_bit(cmd->link_modes.advertising,
> +				 __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	if (bit_pos != __ETHTOOL_LINK_MODE_MASK_NBITS)
> +		*mode = bit_pos;
> +}
> +
> +static int otx2_set_link_ksettings(struct net_device *netdev,
> +				   const struct ethtool_link_ksettings *cmd)
> +{
> +	struct otx2_nic *pf = netdev_priv(netdev);
> +	struct ethtool_link_ksettings req_ks;
> +	struct ethtool_link_ksettings cur_ks;
> +	struct cgx_set_link_mode_req *req;
> +	struct mbox *mbox = &pf->mbox;
> +	int err = 0;
> +
> +	/* save requested link settings */
> +	memcpy(&req_ks, cmd, sizeof(struct ethtool_link_ksettings));

Why do you make this copy? The comment above does not help at all.

> +	memset(&cur_ks, 0, sizeof(struct ethtool_link_ksettings));
> +
> +	if (!ethtool_validate_speed(cmd->base.speed) ||
> +	    !ethtool_validate_duplex(cmd->base.duplex))
> +		return -EINVAL;
> +
> +	if (cmd->base.autoneg != AUTONEG_ENABLE &&
> +	    cmd->base.autoneg != AUTONEG_DISABLE)
> +		return -EINVAL;
> +
> +	otx2_get_link_ksettings(netdev, &cur_ks);
> +
> +	/* Check requested modes against supported modes by hardware */
> +	if (!bitmap_subset(req_ks.link_modes.advertising,
> +			   cur_ks.link_modes.supported,
> +			   __ETHTOOL_LINK_MODE_MASK_NBITS))
> +		return -EINVAL;
> +
> +	mutex_lock(&mbox->lock);
> +	req = otx2_mbox_alloc_msg_cgx_set_link_mode(&pf->mbox);
> +	if (!req) {
> +		err = -ENOMEM;
> +		goto end;
> +	}
> +
> +	req->args.speed = req_ks.base.speed;
> +	/* firmware expects 1 for half duplex and 0 for full duplex
> +	 * hence inverting
> +	 */
> +	req->args.duplex = req_ks.base.duplex ^ 0x1;
> +	req->args.an = req_ks.base.autoneg;
> +	otx2_get_advertised_mode(&req_ks, &req->args.mode);

But that only returns the first bit set. What does the device actually
do? What if the user cleared a middle bit?

> +	err = otx2_sync_mbox_msg(&pf->mbox);
> +end:
> +	mutex_unlock(&mbox->lock);
> +	return err;
> +}
> +
>  static const struct ethtool_ops otx2_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES,
> @@ -1200,6 +1266,7 @@ static const struct ethtool_ops otx2_ethtool_ops = {
>  	.get_fecparam		= otx2_get_fecparam,
>  	.set_fecparam		= otx2_set_fecparam,
>  	.get_link_ksettings     = otx2_get_link_ksettings,
> +	.set_link_ksettings     = otx2_set_link_ksettings,
>  };
>  
>  void otx2_set_ethtool_ops(struct net_device *netdev)

