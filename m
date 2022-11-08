Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700F6621E0F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiKHUw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiKHUwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:52:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2C25B857
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/gZAFgYJ/RuaxasHl+mWHX/XSVOzCrqlCtFdV86igpk=; b=yPBzMrfpHql//jRFnrG48dei5r
        zxOo2+9GOPhWxpzh5f90F6KFt580k994Qrwoqh0coD1T/RuOKR0QhaDvnFFk6ylhtitchXE5/wtGr
        13Q/2AyNLOkYXzh+p4Ft2vZgZoihcDJAkOoYf+bE3RQEONkV9Ct6kZixOoy8U7HCkHyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osVaV-001rDx-2g; Tue, 08 Nov 2022 21:52:51 +0100
Date:   Tue, 8 Nov 2022 21:52:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Message-ID: <Y2rBo3KI2LmjS55y@lunn.ch>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com>
 <20221108111907.48599-2-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108111907.48599-2-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + *  txgbe_identify_sfp_module - Identifies SFP modules
> + *  @hw: pointer to hardware structure
> + *
> + *  Searches for and identifies the SFP module and assigns appropriate PHY type.
> + **/
> +static int txgbe_identify_sfp_module(struct txgbe_hw *hw)
> +{
> +	u8 oui_bytes[3] = {0, 0, 0};
> +	u8 comp_codes_10g = 0;
> +	u8 comp_codes_1g = 0;
> +	int status = -EFAULT;
> +	u32 vendor_oui = 0;
> +	u8 identifier = 0;
> +	u8 cable_tech = 0;
> +	u8 cable_spec = 0;
> +
> +	/* LAN ID is needed for I2C access */
> +	txgbe_init_i2c(hw);
> +
> +	status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_IDENTIFIER, &identifier);
> +	if (status != 0)
> +		goto err_read_i2c_eeprom;
> +
> +	if (identifier != TXGBE_SFF_IDENTIFIER_SFP) {
> +		hw->phy.type = txgbe_phy_sfp_unsupported;
> +		status = -ENODEV;
> +	} else {
> +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_1GBE_COMP_CODES,
> +					       &comp_codes_1g);
> +		if (status != 0)
> +			goto err_read_i2c_eeprom;
> +
> +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_10GBE_COMP_CODES,
> +					       &comp_codes_10g);
> +		if (status != 0)
> +			goto err_read_i2c_eeprom;
> +
> +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_CABLE_TECHNOLOGY,
> +					       &cable_tech);
> +		if (status != 0)
> +			goto err_read_i2c_eeprom;
> +
> +		 /* ID Module
> +		  * =========
> +		  * 1   SFP_DA_CORE
> +		  * 2   SFP_SR/LR_CORE
> +		  * 3   SFP_act_lmt_DA_CORE
> +		  * 4   SFP_1g_cu_CORE
> +		  * 5   SFP_1g_sx_CORE
> +		  * 6   SFP_1g_lx_CORE
> +		  */

So it looks like you have Linux driving the SFP, not firmware. In that
case, please throw all this code away. Implement a standard Linux I2C
bus master driver, and make use of driver/net/phy/sfp*.[ch].

    Andrew
