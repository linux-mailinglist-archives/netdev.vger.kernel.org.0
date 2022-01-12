Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E00E48CB71
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356367AbiALTDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiALTDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:03:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C91C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 11:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA482B82089
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 19:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A5C36AEA;
        Wed, 12 Jan 2022 19:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642014195;
        bh=bciOmWzZXdQuAzNQiPi6MUn/ym4Dv/2COMQ4f55yJLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RcytdQMtx4E1zWoRynzj0gSTjvfBHe40yoycqP89QAOps0HkQ574VprhYVHu4Ne0K
         w/a7xWlfdLpPDPq76p3jMkjU5IlaJHQSnKnTrkqq/GO8ml5jzEPquxKtiyt9PwdeOD
         zOGUl8ZsKc+NTjkQiwq5Z/Jaqx94Svf6QRvTBMJcn9mkg/ezi4Ae+AEDcpVcup/qLS
         N+2RuYuX0ulMbVkRvSwMrlKXRH6iaryAzRdjW7cCx2nyuAf3nxmo4hTBqh++T10ynE
         vdGG7xo9iUn6J1DVmea9Fgh/F3mkEa23cy426p37wUukAphIH9T9ziu7Xw004yBj/S
         tMjmM0WcXcowA==
Date:   Wed, 12 Jan 2022 11:03:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>
Subject: Re: [net-next PATCH] octeontx2-pf: Change receive buffer size using
 ethtool
Message-ID: <20220112110314.358d5295@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1642006975-17580-1-git-send-email-sbhatta@marvell.com>
References: <1642006975-17580-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 22:32:55 +0530 Subbaraya Sundeep wrote:
> ethtool rx-buf-len is for setting receive buffer size,
> support setting it via ethtool -G parameter and getting
> it via ethtool -g parameter.

I don't see a check against current MTU, in case MTU is larger than 
the buffer length the device will scatter?

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> index 61e5281..6d11cb2 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
> @@ -177,6 +177,7 @@ struct otx2_hw {
>  	u16			pool_cnt;
>  	u16			rqpool_cnt;
>  	u16			sqpool_cnt;
> +	u16			rbuf_len;
>  
>  	/* NPA */
>  	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index d85db90..a100296 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -371,6 +371,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
>  	ring->rx_pending = qs->rqe_cnt ? qs->rqe_cnt : Q_COUNT(Q_SIZE_256);
>  	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
>  	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
> +	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
>  }
>  
>  static int otx2_set_ringparam(struct net_device *netdev,
> @@ -379,6 +380,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  			      struct netlink_ext_ack *extack)
>  {
>  	struct otx2_nic *pfvf = netdev_priv(netdev);
> +	u32 rx_buf_len = kernel_ring->rx_buf_len;
>  	bool if_up = netif_running(netdev);
>  	struct otx2_qset *qs = &pfvf->qset;
>  	u32 rx_count, tx_count;
> @@ -386,6 +388,15 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
>  		return -EINVAL;
>  
> +	/* Hardware supports max size of 32k for a receive buffer
> +	 * and 1536 is typical ethernet frame size.
> +	 */
> +	if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
> +		netdev_err(netdev,
> +			   "Receive buffer range is 1536 - 32768");
> +		return -EINVAL;
> +	}
> +
>  	/* Permitted lengths are 16 64 256 1K 4K 16K 64K 256K 1M  */
>  	rx_count = ring->rx_pending;
>  	/* On some silicon variants a skid or reserved CQEs are
> @@ -403,7 +414,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  			   Q_COUNT(Q_SIZE_4K), Q_COUNT(Q_SIZE_MAX));
>  	tx_count = Q_COUNT(Q_SIZE(tx_count, 3));
>  
> -	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt)
> +	if (tx_count == qs->sqe_cnt && rx_count == qs->rqe_cnt && !rx_buf_len)

Should we use rx_buf_len = 0 as a way for users to reset the rxbuf len
to the default value? I think that would be handy.

>  	if (if_up)
> @@ -413,6 +424,10 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  	qs->sqe_cnt = tx_count;
>  	qs->rqe_cnt = rx_count;
>  
> +	if (rx_buf_len)
> +		pfvf->hw.rbuf_len = ALIGN(rx_buf_len, OTX2_ALIGN) +
> +				    OTX2_HEAD_ROOM;
> +
>  	if (if_up)
>  		return netdev->netdev_ops->ndo_open(netdev);
>  
> @@ -1207,6 +1222,7 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
>  static const struct ethtool_ops otx2_ethtool_ops = {
>  	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
>  				     ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN,
>  	.get_link		= otx2_get_link,
>  	.get_drvinfo		= otx2_get_drvinfo,
>  	.get_strings		= otx2_get_strings,
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> index 6080ebd..37afffa 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
> @@ -66,6 +66,8 @@ static int otx2_change_mtu(struct net_device *netdev, int new_mtu)
>  		    netdev->mtu, new_mtu);
>  	netdev->mtu = new_mtu;
>  
> +	pf->hw.rbuf_len = 0;

Why reset the buf len on mtu change?

>  	if (if_up)
>  		err = otx2_open(netdev);
>  
> @@ -1306,6 +1308,9 @@ static int otx2_get_rbuf_size(struct otx2_nic *pf, int mtu)
>  	int total_size;
>  	int rbuf_size;
>  
> +	if (pf->hw.rbuf_len)
> +		return pf->hw.rbuf_len;
> +
>  	/* The data transferred by NIX to memory consists of actual packet
>  	 * plus additional data which has timestamp and/or EDSA/HIGIG2
>  	 * headers if interface is configured in corresponding modes.

