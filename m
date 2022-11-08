Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BBE621E40
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 22:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKHVLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 16:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiKHVLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 16:11:00 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8163C6FE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 13:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Il38uwNFzWQDtPqTiFsb+ZKwsOIqHOsTTcguwEVs1uc=; b=cngXAmXgkcmaxNe8Gi95R7KDG4
        Re5oWRAjgxyuVwmKOYmWpw5jeAeLLmf1GrPmip3HV5T9W3Gf5qtLz6VUCXvSsfruDr+cW0pFRIIEi
        v3uSMA51ioR/4n7RtivbwjUDyOYfoEkuSIW70pPpMDwsP6uolhNoAV6GvKrMlAqaKt2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osVs1-001rKX-PG; Tue, 08 Nov 2022 22:10:57 +0100
Date:   Tue, 8 Nov 2022 22:10:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 4/5] net: ngbe: Initialize phy information
Message-ID: <Y2rF4bucPjOsYvra@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-5-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108111907.48599-5-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + *  ngbe_phy_read_reg_mdi - Reads a val from an external PHY register
> + *  @hw: pointer to hardware structure
> + *  @reg_addr: 32 bit address of PHY register to read
> + **/
> +static u16 ngbe_phy_read_reg_mdi(struct ngbe_hw *hw, u32 reg_addr)
> +{
> +	u32 command = 0, device_type = 0;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 phy_addr = 0;
> +	u16 phy_data = 0;
> +	u32 val = 0;
> +	int ret = 0;
> +
> +	/* setup and write the address cycle command */
> +	command = NGBE_MSCA_RA(reg_addr) |
> +		  NGBE_MSCA_PA(phy_addr) |
> +		  NGBE_MSCA_DA(device_type);
> +	wr32(wxhw, NGBE_MSCA, command);
> +
> +	command = NGBE_MSCC_CMD(NGBE_MSCA_CMD_READ) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wxhw, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
> +				20000, false, wxhw, NGBE_MSCC);
> +	if (ret)
> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> +
> +	/* read data from MSCC */
> +	phy_data = (u16)rd32(wxhw, NGBE_MSCC);
> +
> +	return phy_data;
> +}
> +
> +/**
> + *  ngbe_phy_write_reg_mdi - Writes a val to external PHY register
> + *  @hw: pointer to hardware structure
> + *  @reg_addr: 32 bit PHY register to write
> + *  @phy_data: Data to write to the PHY register
> + **/
> +static void ngbe_phy_write_reg_mdi(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
> +{
> +	u32 command = 0, device_type = 0;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 phy_addr = 0;
> +	int ret = 0;
> +	u16 val = 0;
> +
> +	/* setup and write the address cycle command */
> +	command = NGBE_MSCA_RA(reg_addr) |
> +		  NGBE_MSCA_PA(phy_addr) |
> +		  NGBE_MSCA_DA(device_type);
> +	wr32(wxhw, NGBE_MSCA, command);
> +
> +	command = phy_data |
> +		  NGBE_MSCC_CMD(NGBE_MSCA_CMD_WRITE) |
> +		  NGBE_MSCC_BUSY |
> +		  NGBE_MDIO_CLK(6);
> +	wr32(wxhw, NGBE_MSCC, command);
> +
> +	/* wait to complete */
> +	ret = read_poll_timeout(rd32, val, val & NGBE_MSCC_BUSY, 1000,
> +				20000, false, wxhw, NGBE_MSCC);
> +	if (ret)
> +		wx_dbg(wxhw, "PHY address command did not complete.\n");
> +}

This appears to be an MDIO bus? Although you seem to be limited to
just 1 of the 32 addresses? Anyway, please create a standard Linux
MDIO bus driver. The Linux PHY drivers will then drive the PHYs for
you. You can throw most of this file away.

	Andrew
