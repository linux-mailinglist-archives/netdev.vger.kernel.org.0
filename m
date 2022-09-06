Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 235815ADD44
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 04:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIFCZ6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Sep 2022 22:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIFCZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 22:25:57 -0400
Received: from smtpbg.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3EE61D5A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 19:25:50 -0700 (PDT)
X-QQ-mid: bizesmtp85t1662431136tey1wkvp
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 06 Sep 2022 10:25:34 +0800 (CST)
X-QQ-SSF: 00400000000000L0L000000A0000000
X-QQ-FEAT: SX/WFj88WPUy5sCwVVBXTy31Av9IUSf8I6elYJjGjKnK50LjvYdstMkJsrRoi
        cwLMHTRIjsvv2VrPP9zwLsYfwAY+Lnk8+2tGeD5+tUCyERUecW1tc67IsRhQuBd8Sx04XV9
        yUFGncI16xYDj1cIv6gB8oIhBUPpkKWs0B1vh7njwRXhDwKvDjZH/aeE/vSEs3kJVbkoPeZ
        TBt5BTDOQrYZh1gLG1wdRt74ZD0inVIz9aqGyBjkL9QUVx7bGJeIfdsUfjTVsSAa1T54W5c
        3pSCS8YOOreCCynHa7hijO4HJD3opcrBrvgz3WjkLbN5p2JCXC+ubfkCfNZQPcX2MkRzhXN
        lzpzrSFJwIVcvj9W0CqfRGG8sN2DrD4g96ej8yT92qLmVUsxRM30IqWVMYSqA==
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 2] net: ngbe: sw init and hw init
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <YxaYytbu2LyJ6edV@lunn.ch>
Date:   Tue, 6 Sep 2022 10:25:34 +0800
Cc:     netdev@vger.kernel.org, Jiawen Wu <jiawenwu@trustnetic.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <DC1F2305-9590-4107-8BB5-366B6E978F82@net-swift.com>
References: <20220905125224.2279-1-mengyuanlou@net-swift.com>
 <YxaYytbu2LyJ6edV@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

They are the same person。
<jiawenwu@net-swift.com>
<jiawenwu@trustnetic.com>
> 2022年9月6日 08:48，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>> +static void ngbe_get_mac_addr(struct ngbe_hw *hw, u8 *mac_addr)
>> +{
>> +	u32 rar_high;
>> +	u32 rar_low;
>> +	u16 i;
>> +
>> +	wr32(hw, NGBE_PSR_MAC_SWC_IDX, 0);
>> +	rar_high = rd32(hw, NGBE_PSR_MAC_SWC_AD_H);
>> +	rar_low = rd32(hw, NGBE_PSR_MAC_SWC_AD_L);
>> +
>> +	for (i = 0; i < 2; i++)
>> +		mac_addr[i] = (u8)(rar_high >> (1 - i) * 8);
>> +
>> +	for (i = 0; i < 4; i++)
>> +		mac_addr[i + 2] = (u8)(rar_low >> (3 - i) * 8);
>> +}
> 
> This looks identical to txgbe_get_mac_addr():
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220830070454.146211-4-jiawenwu@trustnetic.com/
> 
> How similar is txgbe and ngdb? Should there be some shared code?

> 
>> +
>> +/**
>> + *  ngbe_validate_mac_addr - Validate MAC address
>> + *  @mac_addr: pointer to MAC address.
>> + *
>> + *  Tests a MAC address to ensure it is a valid Individual Address
>> + **/
>> +static int ngbe_validate_mac_addr(u8 *mac_addr)
>> +{
>> +	/* Make sure it is not a multicast address */
>> +	if (is_multicast_ether_addr(mac_addr))
>> +		return -EINVAL;
>> +	/* Not a broadcast address */
>> +	else if (is_broadcast_ether_addr(mac_addr))
>> +		return -EINVAL;
>> +	/* Reject the zero address */
>> +	else if (is_zero_ether_addr(mac_addr))
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> +/**
>> + *  ngbe_set_rar - Set Rx address register
>> + *  @hw: pointer to hardware structure
>> + *  @index: Receive address register to write
>> + *  @addr: Address to put into receive address register
>> + *  @pools: "pool" index
>> + *  @enable_addr: set flag that address is active
>> + *
>> + *  Puts an ethernet address into a receive address register.
>> + **/
>> +static int ngbe_set_rar(struct ngbe_hw *hw, u32 index, u8 *addr, u64 pools,
>> +			u32 enable_addr)
>> +{
> 
> This function looks identical to txgbe_set_rar().
> 
>> +/**
>> + *  ngbe_init_rx_addrs - Initializes receive address filters.
>> + *  @hw: pointer to hardware structure
>> + *
>> + *  Places the MAC address in receive address register 0 and clears the rest
>> + *  of the receive address registers. Clears the multicast table. Assumes
>> + *  the receiver is in reset when the routine is called.
>> + **/
>> +static void ngbe_init_rx_addrs(struct ngbe_hw *hw)
>> +{
>> +	u32 i;
>> +	u32 rar_entries = hw->mac.num_rar_entries;
>> +	u32 psrctl;
> 
> Apart from txgbe_init_rx_addrs() uses is_valid_ether_addr(), this is
> also identical.
> 
>> +static int ngbe_fmgr_cmd_op(struct ngbe_hw *hw, u32 cmd, u32 cmd_addr)
>> +{
>> +	u32 cmd_val = 0, val = 0;
>> +
>> +	cmd_val = (cmd << NGBE_SPI_CLK_CMD_OFFSET) |
>> +		  (NGBE_SPI_CLK_DIV << NGBE_SPI_CLK_DIV_OFFSET) | cmd_addr;
>> +	wr32(hw, NGBE_SPI_H_CMD_REG_ADDR, cmd_val);
>> +
>> +	return read_poll_timeout(rd32, val, (val & 0x1), 10, NGBE_SPI_TIME_OUT_VALUE,
>> +				 false, hw, NGBE_SPI_H_STA_REG_ADDR);
>> +}
>> +
>> +int ngbe_flash_read_dword(struct ngbe_hw *hw, u32 addr, u32 *data)
>> +{
>> +	int ret = 0;
>> +
>> +	ret = ngbe_fmgr_cmd_op(hw, NGBE_SPI_CMD_READ_DWORD, addr);
>> +	if (ret < 0)
>> +		return ret;
>> +	*data = rd32(hw, NGBE_SPI_H_DAT_REG_ADDR);
>> +
>> +	return 0;
>> +}
> 
> Identical to txgbe_flash_read_dword
> 
> You need to work with Jiawen Wu <jiawe...@trustnetic.com> and pull the
> common code out into a library that the two drivers share. Is
> jiawenwu@net-swift.com the same person ?

Is it necessary to pull the common code out into a library?
There are some differences in register configuration.
It is not convenient for customers to use.
Thanks.

> 
>       Andrew
> 

