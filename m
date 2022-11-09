Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0596223FB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 07:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKIGdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 01:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiKIGda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 01:33:30 -0500
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F9262EA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 22:33:25 -0800 (PST)
X-QQ-mid: Yeas52t1667975579t822t51482
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Mengyuan Lou'" <mengyuanlou@net-swift.com>
Cc:     <netdev@vger.kernel.org>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-2-mengyuanlou@net-swift.com> <Y2rBo3KI2LmjS55y@lunn.ch>
In-Reply-To: <Y2rBo3KI2LmjS55y@lunn.ch>
Subject: RE: [PATCH net-next 1/5] net: txgbe: Identify PHY and SFP module
Date:   Wed, 9 Nov 2022 14:32:58 +0800
Message-ID: <02a901d8f405$1c21a350$5464e9f0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEDYkxFLCrX910mDyZZwuk/z1QniAJnx28nAUaCYTevw8+iQA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, November 9, 2022 4:53 AM, Andrew Lunn wrote:
> > +/**
> > + *  txgbe_identify_sfp_module - Identifies SFP modules
> > + *  @hw: pointer to hardware structure
> > + *
> > + *  Searches for and identifies the SFP module and assigns appropriate PHY type.
> > + **/
> > +static int txgbe_identify_sfp_module(struct txgbe_hw *hw) {
> > +	u8 oui_bytes[3] = {0, 0, 0};
> > +	u8 comp_codes_10g = 0;
> > +	u8 comp_codes_1g = 0;
> > +	int status = -EFAULT;
> > +	u32 vendor_oui = 0;
> > +	u8 identifier = 0;
> > +	u8 cable_tech = 0;
> > +	u8 cable_spec = 0;
> > +
> > +	/* LAN ID is needed for I2C access */
> > +	txgbe_init_i2c(hw);
> > +
> > +	status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_IDENTIFIER, &identifier);
> > +	if (status != 0)
> > +		goto err_read_i2c_eeprom;
> > +
> > +	if (identifier != TXGBE_SFF_IDENTIFIER_SFP) {
> > +		hw->phy.type = txgbe_phy_sfp_unsupported;
> > +		status = -ENODEV;
> > +	} else {
> > +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_1GBE_COMP_CODES,
> > +					       &comp_codes_1g);
> > +		if (status != 0)
> > +			goto err_read_i2c_eeprom;
> > +
> > +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_10GBE_COMP_CODES,
> > +					       &comp_codes_10g);
> > +		if (status != 0)
> > +			goto err_read_i2c_eeprom;
> > +
> > +		status = txgbe_read_i2c_eeprom(hw, TXGBE_SFF_CABLE_TECHNOLOGY,
> > +					       &cable_tech);
> > +		if (status != 0)
> > +			goto err_read_i2c_eeprom;
> > +
> > +		 /* ID Module
> > +		  * =========
> > +		  * 1   SFP_DA_CORE
> > +		  * 2   SFP_SR/LR_CORE
> > +		  * 3   SFP_act_lmt_DA_CORE
> > +		  * 4   SFP_1g_cu_CORE
> > +		  * 5   SFP_1g_sx_CORE
> > +		  * 6   SFP_1g_lx_CORE
> > +		  */
> 
> So it looks like you have Linux driving the SFP, not firmware. In that case, please throw all this
code away.
> Implement a standard Linux I2C bus master driver, and make use of driver/net/phy/sfp*.[ch].
> 
>     Andrew
> 

I don't quite understand how to use driver/net/phy/sfp* files. In txgbe driver, I2C infos are read
from CAB registers, then SFP type identified.
Perhaps implement 'struct sfp_upstream_ops' ? And could you please guide me an example driver of
some docs?


