Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443B1392436
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhE0BRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232187AbhE0BRn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 21:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B113361073;
        Thu, 27 May 2021 01:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622078171;
        bh=xHHivo9IMy77QFa/Xlp3gV8VKNX8gtjiQWwlOJQO4Bg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WU3+GhvfneTYV+BzAWVUA25EYaTmGzyIeapzuMJKYqBYSF39mEWKEQleuYUiuQrPn
         aQS+fuVK4dk7r/B++eyfUYHJo5ZXKtAOL+Xrt4pwejtCDKwE/LHNfGoiDkqOxuIBHQ
         qlEXAP6jn0S/oMxy7CKvmRFDzxSAuG83P5Vac3Vhnm/ZHPomzK8gqoLwUN2beCBTRs
         JW5PzLadWMzHn7x+6YwK8h+aqHvI7vB32NtbY2MPk+XXkzkqEUaQVL9N8gkwdssLIg
         qJ4whS/X2IzGZU0ULDZswL4Is71wvUHGXLkpExorMwcLLR0Ot+UIs9MT2/NstsND/D
         x8xotr0sVQRHg==
Date:   Wed, 26 May 2021 18:16:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gatis Peisenieks <gatis@mikrotik.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] atl1c: add 4 RX/TX queue support for
 Mikrotik 10/25G NIC
Message-ID: <20210526181609.1416c4eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210526075830.2959145-1-gatis@mikrotik.com>
References: <20210526075830.2959145-1-gatis@mikrotik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 May 2021 10:58:30 +0300 Gatis Peisenieks wrote:
> More RX/TX queues on a network card help spread the CPU load among
> cores and achieve higher overall networking performance. The new
> Mikrotik 10/25G NIC supports 4 RX and 4 TX queues. TX queues are
> treated with equal priority. RX queue balancing is fixed based on
> L2/L3/L4 hash.
> 
> This adds support for 4 RX/TX queues while maintaining backwards
> compatibility with older hardware.
> 
> Simultaneous TX + RX performance on AMD Threadripper 3960X
> with Mikrotik 10/25G NIC improved from 1.6Mpps to 3.2Mpps per port.
> 
> Backwards compatiblitiy was verified with AR8151 and AR8131 based
> NICs.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>

> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> index 9d70cb7544f1..0f206d08a460 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> @@ -63,7 +63,7 @@
>  
>  #define AT_MAX_RECEIVE_QUEUE    4
>  #define AT_DEF_RECEIVE_QUEUE	1
> -#define AT_MAX_TRANSMIT_QUEUE	2
> +#define AT_MAX_TRANSMIT_QUEUE  4
>  
>  #define AT_DMA_HI_ADDR_MASK     0xffffffff00000000ULL
>  #define AT_DMA_LO_ADDR_MASK     0x00000000ffffffffULL
> @@ -294,11 +294,6 @@ enum atl1c_nic_type {
>  	athr_mt,
>  };
>  
> -enum atl1c_trans_queue {
> -	atl1c_trans_normal = 0,
> -	atl1c_trans_high = 1
> -};
> -
>  struct atl1c_hw_stats {
>  	/* rx */
>  	unsigned long rx_ok;		/* The number of good packet received. */
> @@ -475,6 +470,8 @@ struct atl1c_buffer {
>  
>  /* transimit packet descriptor (tpd) ring */
>  struct atl1c_tpd_ring {
> +	struct atl1c_adapter *adapter;
> +	u16 num;

Consider moving the @num after @dma, that should avoid creating a 6B
hole (pahole is your friend).

>  	void *desc;		/* descriptor ring virtual address */
>  	dma_addr_t dma;		/* descriptor ring physical address */
>  	u16 size;		/* descriptor ring length in bytes */
> @@ -482,6 +479,7 @@ struct atl1c_tpd_ring {
>  	u16 next_to_use;
>  	atomic_t next_to_clean;
>  	struct atl1c_buffer *buffer_info;
> +	struct napi_struct napi;

Could you split the move of napi into ring structures to separate
patches (also separate rx and tx) for ease of review?

>  };
>  
>  /* receive free descriptor (rfd) ring */

> -static void atl1c_set_mac_type(struct atl1c_hw *hw)
> +static enum atl1c_nic_type atl1c_get_mac_type(struct pci_dev *pdev,
> +					      u8 __iomem *hw_addr)
>  {
> -	u32 magic;
> -	switch (hw->device_id) {
> +	switch (pdev->device) {
>  	case PCI_DEVICE_ID_ATTANSIC_L2C:
> -		hw->nic_type = athr_l2c;
> -		break;
> +		return athr_l2c;
>  	case PCI_DEVICE_ID_ATTANSIC_L1C:
> -		hw->nic_type = athr_l1c;
> -		break;
> +		return athr_l1c;
>  	case PCI_DEVICE_ID_ATHEROS_L2C_B:
> -		hw->nic_type = athr_l2c_b;
> -		break;
> +		return athr_l2c_b;
>  	case PCI_DEVICE_ID_ATHEROS_L2C_B2:
> -		hw->nic_type = athr_l2c_b2;
> -		break;
> +		return athr_l2c_b2;
>  	case PCI_DEVICE_ID_ATHEROS_L1D:
> -		hw->nic_type = athr_l1d;
> -		break;
> +		return athr_l1d;
>  	case PCI_DEVICE_ID_ATHEROS_L1D_2_0:
> -		hw->nic_type = athr_l1d_2;
> -		AT_READ_REG(hw, REG_MT_MAGIC, &magic);
> -		if (magic == MT_MAGIC)
> -			hw->nic_type = athr_mt;
> -		break;
> +		if (readl(hw_addr + REG_MT_MAGIC) == MT_MAGIC)
> +			return athr_mt;
> +		return athr_l1d_2;
>  	default:
> -		break;
> +		return athr_l1c;

Also separate patch? Hard to find callers and justification 
in a long diff.

>  	/* Note: just free tdp_ring.buffer_info,
> -	*  it contain rfd_ring.buffer_info, do not double free */
> +	 *  it contain rfd_ring.buffer_info, do not double free
> +	 */

The "it" doesn't start aligned with "Note" now.

> +	if (netif_tx_queue_stopped(txq) && netif_carrier_ok(adapter->netdev)) {
> +		netif_tx_wake_queue(txq);
>  	}

nit: no need for brackets

>  	if (total_packets < budget) {
>  		napi_complete_done(napi, total_packets);
>  		spin_lock_irqsave(&adapter->hw.intr_mask_lock, flags);
> -		adapter->hw.intr_mask |= ISR_TX_PKT;
> +		adapter->hw.intr_mask |= atl1c_qregs[tpd_ring->num].tx_isr;
>  		AT_WRITE_REG(&adapter->hw, REG_IMR, adapter->hw.intr_mask);
>  		spin_unlock_irqrestore(&adapter->hw.intr_mask_lock, flags);
>  		return total_packets;
> @@ -1583,6 +1651,38 @@ static int atl1c_clean_tx(struct napi_struct *napi, int budget)
>  	return budget;
>  }
>  
> +static void atl1c_intr_rx_tx(struct atl1c_adapter *adapter, u32 status)
> +{
> +	struct atl1c_hw *hw = &adapter->hw;
> +	int i;
> +	u32 intr_mask;

reorder @i and @intr_mask to conform to the preferred reverse xmas tree
ordering of variable declarations.

> +/**
> + * atl1c_clean_rx - NAPI Rx polling callback
> + * @napi: napi info
> + * @budget: limit of packets to clean
> + */
> +static int atl1c_clean_rx(struct napi_struct *napi, int budget)
>  {
> +	struct atl1c_rrd_ring *rrd_ring =
> +		container_of(napi, struct atl1c_rrd_ring, napi);
> +	struct atl1c_adapter *adapter = rrd_ring->adapter;
> +	int work_done = 0;
> +	unsigned long flags;
>  	u16 rfd_num, rfd_index;
> -	u16 count = 0;
>  	u16 length;
>  	struct pci_dev *pdev = adapter->pdev;
>  	struct net_device *netdev  = adapter->netdev;
> -	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring;
> -	struct atl1c_rrd_ring *rrd_ring = &adapter->rrd_ring;
> +	struct atl1c_rfd_ring *rfd_ring = &adapter->rfd_ring[rrd_ring->num];
>  	struct sk_buff *skb;
>  	struct atl1c_recv_ret_status *rrs;
>  	struct atl1c_buffer *buffer_info;
>  
> +	/* Keep link state information with original netdev */
> +	if (!netif_carrier_ok(adapter->netdev))
> +		goto quit_polling;

Interesting, I see you only move this code, but why does this driver
stop reading packets when link goes down? Surely there may be packets
already on the ring which Linux should process?

> @@ -2633,8 +2725,14 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	adapter->mii.phy_id_mask = 0x1f;
>  	adapter->mii.reg_num_mask = MDIO_CTRL_REG_MASK;
>  	dev_set_threaded(netdev, true);
> -	netif_napi_add(netdev, &adapter->napi, atl1c_clean, 64);
> -	netif_napi_add(netdev, &adapter->tx_napi, atl1c_clean_tx, 64);
> +	for (i = 0; i < adapter->rx_queue_count; ++i) {
> +		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
> +			       atl1c_clean_rx, 64);
> +	}
> +	for (i = 0; i < adapter->tx_queue_count; ++i) {
> +		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
> +			       atl1c_clean_tx, 64);
> +	}

nit: no need for brackets
