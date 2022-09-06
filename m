Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86D15ADCAA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 02:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiIFAsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 20:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIFAsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 20:48:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AB76A4B0
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 17:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+d8ENVyDr8WQAQSPkgQOTfNewQtJatRG6fj+veXLLLI=; b=GXKUShwKEEQCF/jgcOYIAtTIRB
        WqsHwXK9km8BNbTuftkT7+9hLeE3iJyEFCZ2yRMMKkyuOwM2poS7uAN2Vp8x/rZY4wA7PJaOBmRp3
        J4iWVd7X/rRPdNqrI1qa+djUK1Dwpus6ZV0R10KmQGVxBcbXXKjeDavg1RKsCw0TxE3w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVMl8-00Fhez-UE; Tue, 06 Sep 2022 02:48:10 +0200
Date:   Tue, 6 Sep 2022 02:48:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@net-swift.com
Subject: Re: [PATCH net-next 2] net: ngbe: sw init and hw init
Message-ID: <YxaYytbu2LyJ6edV@lunn.ch>
References: <20220905125224.2279-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905125224.2279-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void ngbe_get_mac_addr(struct ngbe_hw *hw, u8 *mac_addr)
> +{
> +	u32 rar_high;
> +	u32 rar_low;
> +	u16 i;
> +
> +	wr32(hw, NGBE_PSR_MAC_SWC_IDX, 0);
> +	rar_high = rd32(hw, NGBE_PSR_MAC_SWC_AD_H);
> +	rar_low = rd32(hw, NGBE_PSR_MAC_SWC_AD_L);
> +
> +	for (i = 0; i < 2; i++)
> +		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
> +
> +	for (i = 0; i < 4; i++)
> +		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
> +}

This looks identical to txgbe_get_mac_addr():

https://patchwork.kernel.org/project/netdevbpf/patch/20220830070454.146211-4-jiawenwu@trustnetic.com/

How similar is txgbe and ngdb? Should there be some shared code?

> +
> +/**
> + *  ngbe_validate_mac_addr - Validate MAC address
> + *  @mac_addr: pointer to MAC address.
> + *
> + *  Tests a MAC address to ensure it is a valid Individual Address
> + **/
> +static int ngbe_validate_mac_addr(u8 *mac_addr)
> +{
> +	/* Make sure it is not a multicast address */
> +	if (is_multicast_ether_addr(mac_addr))
> +		return -EINVAL;
> +	/* Not a broadcast address */
> +	else if (is_broadcast_ether_addr(mac_addr))
> +		return -EINVAL;
> +	/* Reject the zero address */
> +	else if (is_zero_ether_addr(mac_addr))
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +/**
> + *  ngbe_set_rar - Set Rx address register
> + *  @hw: pointer to hardware structure
> + *  @index: Receive address register to write
> + *  @addr: Address to put into receive address register
> + *  @pools: "pool" index
> + *  @enable_addr: set flag that address is active
> + *
> + *  Puts an ethernet address into a receive address register.
> + **/
> +static int ngbe_set_rar(struct ngbe_hw *hw, u32 index, u8 *addr, u64 pools,
> +			u32 enable_addr)
> +{

This function looks identical to txgbe_set_rar().

> +/**
> + *  ngbe_init_rx_addrs - Initializes receive address filters.
> + *  @hw: pointer to hardware structure
> + *
> + *  Places the MAC address in receive address register 0 and clears the rest
> + *  of the receive address registers. Clears the multicast table. Assumes
> + *  the receiver is in reset when the routine is called.
> + **/
> +static void ngbe_init_rx_addrs(struct ngbe_hw *hw)
> +{
> +	u32 i;
> +	u32 rar_entries = hw->mac.num_rar_entries;
> +	u32 psrctl;

Apart from txgbe_init_rx_addrs() uses is_valid_ether_addr(), this is
also identical.

> +static int ngbe_fmgr_cmd_op(struct ngbe_hw *hw, u32 cmd, u32 cmd_addr)
> +{
> +	u32 cmd_val = 0, val = 0;
> +
> +	cmd_val = (cmd << NGBE_SPI_CLK_CMD_OFFSET) |
> +		  (NGBE_SPI_CLK_DIV << NGBE_SPI_CLK_DIV_OFFSET) | cmd_addr;
> +	wr32(hw, NGBE_SPI_H_CMD_REG_ADDR, cmd_val);
> +
> +	return read_poll_timeout(rd32, val, (val & 0x1), 10, NGBE_SPI_TIME_OUT_VALUE,
> +				 false, hw, NGBE_SPI_H_STA_REG_ADDR);
> +}
> +
> +int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data)
> +{
> +	int ret = 0;
> +
> +	ret = ngbe_fmgr_cmd_op(hw, NGBE_SPI_CMD_READ_DWORD, addr);
> +	if (ret < 0)
> +		return ret;
> +	*data = rd32(hw, NGBE_SPI_H_DAT_REG_ADDR);
> +
> +	return 0;
> +}

Identical to txgbe_flash_read_dword

You need to work with Jiawen Wu <jiawe...@trustnetic.com> and pull the
common code out into a library that the two drivers share. Is
jiawenwu@net-swift.com the same person ?

       Andrew
