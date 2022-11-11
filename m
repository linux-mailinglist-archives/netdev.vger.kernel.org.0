Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D0062515A
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiKKDOC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Nov 2022 22:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiKKDNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:13:45 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FC715A32
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 19:13:27 -0800 (PST)
X-QQ-mid: bizesmtp62t1668136382tjn8bhj7
Received: from smtpclient.apple ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 11 Nov 2022 11:13:00 +0800 (CST)
X-QQ-SSF: 00400000000000M0M000000A0000000
X-QQ-FEAT: SFhf6fKhx/9/yLYvV2vFjx3pEbN1np9C6Q3R5LHCfjSiE3Jm/zlfk2xyC7IPe
        jhP8EcVRh1JFOCcwcDTmLOn3VxT0LGmCiTRC0oo+8imDGwtSNPw8KwUfCv5hw0RU0TfOVVt
        OFnnREHmiQaagy9jSfA8B0WYNFz3OlFmUB4eXhhAUIfzAt0mWC1WzFRKAbivN2NAavzitPW
        VZvj1K2cRsHvEnDUSf3P9jNxJ71sWEtLsulrX70IuFhevMQW3vAFj4kbwp74bPiNpVFnDFO
        2u+nBHjPm79/GLZeYyMvTvVHkn4Y+FMJ3waTFDfgnQls3icRJaBm6ceTdlwSm0FySSjkKBV
        9UFxY1hLXY2CPWrH4kZLaKociZ868a1Xb7naDPiYbFGZqDVI9eDhoHyac8BpW9HWpTiiChC
X-QQ-GoodBg: 2
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH net-next 4/5] net: ngbe: Initialize phy information
From:   "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
In-Reply-To: <Y2rF4bucPjOsYvra@lunn.ch>
Date:   Fri, 11 Nov 2022 11:13:00 +0800
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Content-Transfer-Encoding: 8BIT
Message-Id: <DCB25D6D-98E5-49EF-9ACC-C7F39BAA7172@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-5-mengyuanlou@net-swift.com> <Y2rF4bucPjOsYvra@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2022年11月9日 05:10，Andrew Lunn <andrew@lunn.ch> 写道：
> 
>> +/**
>> + *  ngbe_phy_read_reg_mdi - Reads a val from an external PHY register
>> + *  @hw: pointer to hardware structure
>> + *  @reg_addr: 32 bit address of PHY register to read
>> + **/
>> +static u16 ngbe_phy_read_reg_mdi(struct ngbe_hw *hw, u32 reg_addr)
>> +{
>> +	u32 command = 0, device_type = 0;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	u32 phy_addr = 0;
>> +	u16 phy_data = 0;
>> +	u32 val = 0;
>> +	int ret = 0;
>> +
>> +	/* setup and write the address cycle command */
>> +	command = NGBE_MSCA_RA(reg_addr) |
>> +		  NGBE_MSCA_PA(phy_addr) |
>> +		  NGBE_MSCA_DA(device_type);
>> +	wr32(wxhw, NGBE_MSCA, command);
>> +
>> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
>> +		  NGBE_MSCC_BUSY |
>> +		  NGBE_MDIO_CLK(6);
>> +	wr32(wxhw, NGBE_MSCC, command);
>> +
>> +	/* wait to complete */
>> +	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
>> +				20000, false, wxhw, NGBE_MSCC);
>> +	if (ret)
>> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
>> +
>> +	/* read data from MSCC */
>> +	phy_data = (u16)rd32(wxhw, NGBE_MSCC);
>> +
>> +	return phy_data;
>> +}
>> +
>> +/**
>> + *  ngbe_phy_write_reg_mdi - Writes a val to external PHY register
>> + *  @hw: pointer to hardware structure
>> + *  @reg_addr: 32 bit PHY register to write
>> + *  @phy_data: Data to write to the PHY register
>> + **/
>> +static void ngbe_phy_write_reg_mdi(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
>> +{
>> +	u32 command = 0, device_type = 0;
>> +	struct wx_hw *wxhw = &hw->wxhw;
>> +	u32 phy_addr = 0;
>> +	int ret = 0;
>> +	u16 val = 0;
>> +
>> +	/* setup and write the address cycle command */
>> +	command = NGBE_MSCA_RA(reg_addr) |
>> +		  NGBE_MSCA_PA(phy_addr) |
>> +		  NGBE_MSCA_DA(device_type);
>> +	wr32(wxhw, NGBE_MSCA, command);
>> +
>> +	command = phy_data |
>> +		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
>> +		  NGBE_MSCC_BUSY |
>> +		  NGBE_MDIO_CLK(6);
>> +	wr32(wxhw, NGBE_MSCC, command);
>> +
>> +	/* wait to complete */
>> +	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
>> +				20000, false, wxhw, NGBE_MSCC);
>> +	if (ret)
>> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
>> +}
> 
> This appears to be an MDIO bus? Although you seem to be limited to
> just 1 of the 32 addresses? Anyway, please create a standard Linux
> MDIO bus driver. The Linux PHY drivers will then drive the PHYs for
> you. You can throw most of this file away.
> 
> 	Andrew
If mdio bus is not directly connected to the cpu mac, but can only be converted through the mac chip.
If we need to add an mdio bus driver, how can we provide access to mdio bus the mdio bus driver?
I haven't found the code in for reference at the moment, could you please provide some reference。
sincere thanks。
	Mengyuan Lou

> 

