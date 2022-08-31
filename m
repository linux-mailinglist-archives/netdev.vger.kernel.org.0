Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A035B5A7322
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 03:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiHaBDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 21:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiHaBDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 21:03:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A8CAED9A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 18:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qYqw6VSKtlKVEGy0FhBct//rmCUZLswT8PktK7XAxdk=; b=isaU12zhc6iL4qJ6MWmnKkpioD
        9zwxno2sbgayGiW7gCndARfoRIqstmPSNsJ/mLnYaJwajf7msyNTvdk7hRxH7/cUmDmhzL1zz4TXX
        ZIR6RSZRtqqWX55Xxy3BLsPl5WuuyKXNWS7uoPxwlIxyqqLfJwxaj1uH3EUrIPxQ/JyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTC7y-00F93v-P1; Wed, 31 Aug 2022 03:02:46 +0200
Date:   Wed, 31 Aug 2022 03:02:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v2 03/16] net: txgbe: Set MAC address and
 register netdev
Message-ID: <Yw6zNh+TTGyfBzSV@lunn.ch>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com>
 <20220830070454.146211-4-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830070454.146211-4-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct txgbe_ring {
> +	u8 reg_idx;
> +} ____cacheline_internodealigned_in_smp;

Am i right in thinking that is one byte actually takes up one L3 cache
line?

>  struct txgbe_adapter {
>  	u8 __iomem *io_addr;    /* Mainly for iounmap use */
> @@ -18,11 +35,33 @@ struct txgbe_adapter {
>  	struct net_device *netdev;
>  	struct pci_dev *pdev;
>  
> +	/* Tx fast path data */
> +	int num_tx_queues;
> +
> +	/* TX */
> +	struct txgbe_ring *tx_ring[TXGBE_MAX_TX_QUEUES] ____cacheline_aligned_in_smp;
> +

I assume this causes tx_ring to be aligned to a cache line. Have you
use pahole to see how much space you are wasting? Can some of the
other members be moved around to reduce the waste? Generally, try to
arrange everything for RX on one cache line, everything for TX on
another cache line.

> +void txgbe_set_rar(struct txgbe_hw *hw, u32 index, u8 *addr, u64 pools,
> +		   u32 enable_addr)
> +{
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +	u32 rar_low, rar_high;
> +
> +	/* Make sure we are using a valid rar index range */
> +	if (index >= rar_entries) {
> +		txgbe_info(hw, "RAR index %d is out of range.\n", index);
> +		return;
> +	}
> +
> +	/* select the MAC address */
> +	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, index);
> +
> +	/* setup VMDq pool mapping */
> +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, pools & 0xFFFFFFFF);
> +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, pools >> 32);
> +
> +	/* HW expects these in little endian so we reverse the byte
> +	 * order from network order (big endian) to little endian

And what happens when the machine is already little endian?

> + *  txgbe_clear_rar - Remove Rx address register
> + *  @hw: pointer to hardware structure
> + *  @index: Receive address register to write
> + *
> + *  Clears an ethernet address from a receive address register.
> + **/
> +void txgbe_clear_rar(struct txgbe_hw *hw, u32 index)
> +{
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +
> +	/* Make sure we are using a valid rar index range */
> +	if (index >= rar_entries) {
> +		txgbe_info(hw, "RAR index %d is out of range.\n", index);

dev_err()?

> +		return;

Should this be a void function. It obviously can go wrong, so don't
you want to return an error code?

> +	}
> +
> +	/* Some parts put the VMDq setting in the extra RAH bits,
> +	 * so save everything except the lower 16 bits that hold part
> +	 * of the address and the address valid bit.
> +	 */
> +	wr32(hw, TXGBE_PSR_MAC_SWC_IDX, index);
> +
> +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_L, 0);
> +	wr32(hw, TXGBE_PSR_MAC_SWC_VM_H, 0);
> +
> +	wr32(hw, TXGBE_PSR_MAC_SWC_AD_L, 0);
> +	wr32m(hw, TXGBE_PSR_MAC_SWC_AD_H,
> +	      (TXGBE_PSR_MAC_SWC_AD_H_AD(~0) |
> +	       TXGBE_PSR_MAC_SWC_AD_H_ADTYPE(~0) |
> +	       TXGBE_PSR_MAC_SWC_AD_H_AV),
> +	      0);
> +}
> +
> +/**
> + *  txgbe_init_rx_addrs - Initializes receive address filters.
> + *  @hw: pointer to hardware structure
> + *
> + *  Places the MAC address in receive address register 0 and clears the rest
> + *  of the receive address registers. Clears the multicast table. Assumes
> + *  the receiver is in reset when the routine is called.
> + **/
> +void txgbe_init_rx_addrs(struct txgbe_hw *hw)
> +{
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +	u32 psrctl;
> +	u32 i;
> +
> +	/* If the current mac address is valid, assume it is a software override
> +	 * to the permanent address.
> +	 * Otherwise, use the permanent address from the eeprom.
> +	 */
> +	if (!is_valid_ether_addr(hw->mac.addr)) {
> +		/* Get the MAC address from the RAR0 for later reference */
> +		hw->mac.ops.get_mac_addr(hw, hw->mac.addr);
> +
> +		txgbe_dbg(hw, "Keeping Current RAR0 Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
> +			  hw->mac.addr[0], hw->mac.addr[1],
> +			  hw->mac.addr[2], hw->mac.addr[3],
> +			  hw->mac.addr[4], hw->mac.addr[5]);

You can use %pM here, to print a MAC address.

> +	} else {
> +		/* Setup the receive address. */
> +		txgbe_dbg(hw, "Overriding MAC Address in RAR[0]\n");
> +		txgbe_dbg(hw, "New MAC Addr =%.2X %.2X %.2X %.2X %.2X %.2X\n",
> +			  hw->mac.addr[0], hw->mac.addr[1],
> +			  hw->mac.addr[2], hw->mac.addr[3],
> +			  hw->mac.addr[4], hw->mac.addr[5]);

Same here.

> +void txgbe_get_san_mac_addr(struct txgbe_hw *hw, u8 *san_mac_addr)
> +{
> +	u8 i;
> +
> +	/* No addresses available in this EEPROM.  It's not an
> +	 * error though, so just wipe the local address and return.
> +	 */
> +	for (i = 0; i < 6; i++)

ETH_ALEN

	Andrew
