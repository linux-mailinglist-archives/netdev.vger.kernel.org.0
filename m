Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039524B3BFB
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 16:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiBMPQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 10:16:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbiBMPQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 10:16:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1D25BD0B;
        Sun, 13 Feb 2022 07:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98230B80923;
        Sun, 13 Feb 2022 15:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D14C004E1;
        Sun, 13 Feb 2022 15:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644765387;
        bh=aGp7kWkbr372vbj+uaoixxJhotpk14CM+9+g9ENcKGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I4aiMhyKZpFno6Ge7gRgBh8qrAa89pnSx+q7agiMQg61uTjpBa26llyyXPnkhjdIt
         v+qp3H9IHUVlOBDgLiuBQyuWKr15D8tPXIU8xNxiOsyCRhjqnYyISDINkSq/KjVSuz
         zXYzsJPWDGOC3X+v5eRnBXlnezMSTRhc138/qB2mG2z2udZpygMjFAJf5hPcOqooly
         X3URKTnKnjjFk4A3vaKCA0N5iZFLLofrqd6KkwtqrslhxR5vuu4hW5rghtM2F8ypii
         0uQZfqKrit6iNJUNAY6RnEuu4smDcQn7q52mmpw1GhOdwoWETpLoqlzMioZTlE7Li9
         5qE1Por+t1DHw==
Date:   Sun, 13 Feb 2022 17:16:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Satananda Burla <sburla@marvell.com>
Subject: Re: [PATCH 2/4] octeon_ep: add support for ndo ops.
Message-ID: <YgkgxhXrXPmdAuM2@unreal>
References: <20220210213306.3599-1-vburru@marvell.com>
 <20220210213306.3599-3-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210213306.3599-3-vburru@marvell.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 01:33:04PM -0800, Veerasenareddy Burru wrote:
> Add support for ndo ops to set MAC address, change MTU, get stats.
> Add control path support to set MAC address, change MTU, get stats,
> set speed, get and set link mode.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> Signed-off-by: Abhijit Ayarekar <aayarekar@marvell.com>
> Signed-off-by: Satananda Burla <sburla@marvell.com>
> ---
>  .../marvell/octeon_ep/octep_ctrl_net.c        | 105 ++++++++++++++++++
>  .../ethernet/marvell/octeon_ep/octep_main.c   |  67 +++++++++++
>  2 files changed, 172 insertions(+)

Please don't put "." in end of patch title.

> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> index 1f0d8ba3c8ee..be9b0f31c754 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_net.c
> @@ -87,3 +87,108 @@ int octep_get_mac_addr(struct octep_device *oct, u8 *addr)
>  
>  	return 0;
>  }
> +
> +int octep_set_mac_addr(struct octep_device *oct, u8 *addr)
> +{
> +	struct octep_ctrl_mbox_msg msg = { 0 };
> +	struct octep_ctrl_net_h2f_req req = { 0 };

It is enough to write {} without 0.

> +
> +	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MAC;
> +	req.mac.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	memcpy(&req.mac.addr, addr, ETH_ALEN);
> +
> +	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> +	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MAC_REQ_SZW;
> +	msg.msg = &req;
> +	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +}
> +
> +int octep_set_mtu(struct octep_device *oct, int mtu)
> +{
> +	struct octep_ctrl_mbox_msg msg = { 0 };
> +	struct octep_ctrl_net_h2f_req req = { 0 };
> +
> +	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_MTU;
> +	req.mtu.cmd = OCTEP_CTRL_NET_CMD_SET;
> +	req.mtu.val = mtu;
> +
> +	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> +	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_MTU_REQ_SZW;
> +	msg.msg = &req;
> +	return octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +}
> +
> +int octep_get_if_stats(struct octep_device *oct)
> +{
> +	struct octep_ctrl_mbox_msg msg = { 0 };
> +	struct octep_ctrl_net_h2f_req req = { 0 };
> +	struct octep_iface_rx_stats *iface_rx_stats;
> +	struct octep_iface_tx_stats *iface_tx_stats;
> +	int err;

Reversed Christmas tree, in all functions.

> +
> +	req.hdr.cmd = OCTEP_CTRL_NET_H2F_CMD_GET_IF_STATS;
> +	req.mac.cmd = OCTEP_CTRL_NET_CMD_GET;
> +	req.get_stats.offset = oct->ctrl_mbox_ifstats_offset;
> +
> +	msg.hdr.flags = OCTEP_CTRL_MBOX_MSG_HDR_FLAG_REQ;
> +	msg.hdr.sizew = OCTEP_CTRL_NET_H2F_GET_STATS_REQ_SZW;
> +	msg.msg = &req;
> +	err = octep_ctrl_mbox_send(&oct->ctrl_mbox, &msg);
> +	if (!err) {

Please use success oriented approach, in all places.

if (err)
   return err;

....

> +		iface_rx_stats = (struct octep_iface_rx_stats *)(oct->ctrl_mbox.barmem +
> +								 oct->ctrl_mbox_ifstats_offset);
> +		iface_tx_stats = (struct octep_iface_tx_stats *)(oct->ctrl_mbox.barmem +
> +								 oct->ctrl_mbox_ifstats_offset +
> +								 sizeof(struct octep_iface_rx_stats)
> +								);
> +		memcpy(&oct->iface_rx_stats, iface_rx_stats, sizeof(struct octep_iface_rx_stats));
> +		memcpy(&oct->iface_tx_stats, iface_tx_stats, sizeof(struct octep_iface_tx_stats));
> +	}
> +
> +	return 0;
> +}
> +

Thanks
