Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B376284D0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiKNQQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbiKNQQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:16:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE0F24F38
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 08:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668442574; x=1699978574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CiKs+dRzhy/5TxfxthpW7eDhRu3XgYqHb5P4nlBaBeI=;
  b=TiSjyGzNXYM7c8tbBLfcMTC1DuRqKkDHVTI9LbajQwN/DCtlQ6Llm6nQ
   zPfS7ZIfYN0kIBGtChyzg8muopuppu24fW7H9aaStNM81XNu53idlQxM3
   VtFnOw702MOqauguQ7LhXIAsAZatV+ekxJ1k220GXjZTK7JkCw+Q8rvgy
   pnjClX9AnE/CgpsPcIA6dEx3/j/pNSLcDY1chg26YimapdhUYsG8YNDnV
   Lk8j43zJeEGH2L5brmuREtVS7i7SW3gIk+ZbExefhieWp6Py8GEXcLFB2
   9lYTA9PoqCFoBJmJHKnrqJnYFAsqHk+YhR8dJaEfa+BATzKNojD9niZ8i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="338799644"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="338799644"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 08:16:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="744199083"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="744199083"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 14 Nov 2022 08:16:13 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AEGGC6A003837;
        Mon, 14 Nov 2022 16:16:12 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next 4/5] net: ngbe: Initialize phy information
Date:   Mon, 14 Nov 2022 17:16:09 +0100
Message-Id: <20221114161609.705435-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108111907.48599-5-mengyuanlou@net-swift.com>
References: <20221108111907.48599-1-mengyuanlou@net-swift.com> <20221108111907.48599-5-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mengyuan Lou <mengyuanlou@net-swift.com>
Date: Tue,  8 Nov 2022 19:19:06 +0800

> Initialize phy media type.
> Initialize phy ops functions.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---

[...]

> +int ngbe_phy_led_oem_hostif(struct ngbe_hw *hw, u32 *data)
> +{
> +	struct wx_hic_read_shadow_ram buffer;
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	int status;
> +
> +	buffer.hdr.req.cmd = NGBE_FW_PHY_LED_CONF;
> +	buffer.hdr.req.buf_lenh = 0;
> +	buffer.hdr.req.buf_lenl = 0;
> +	buffer.hdr.req.checksum = NGBE_FW_CMD_DEFAULT_CHECKSUM;
> +
> +	/* convert offset from words to bytes */
> +	buffer.address = 0;
> +	/* one word */
> +	buffer.length = 0;

Just declare @buffer with `= { };` and you won't need to initialize
4 fields (2 in req, 2 here) at runtime.

> +
> +	status = wx_host_interface_command(wxhw, (u32 *)&buffer, sizeof(buffer),

Please don't cast structures to scalars. Can it be done via a union
or so?

> +					   WX_HI_COMMAND_TIMEOUT, false);
> +
> +	if (status)
> +		return status;
> +
> +	*data = rd32a(wxhw, WX_MNG_MBOX, 1);
> +	if (*data == NGBE_FW_CMD_ST_PASS)
> +		*data = rd32a(wxhw, WX_MNG_MBOX, 2);
> +	else
> +		*data = 0xffffffff;

Why perform the first read into @data if it will be overwritten in
100% cases? Would just that work

	if (rd32a(...) == NGBE_...)
		*data = rd32a(...);
	else
		*data = 0xffffffff;

	return 0;

?

> +
> +	return 0;
> +}
> +
>  static int ngbe_reset_misc(struct ngbe_hw *hw)
>  {
>  	struct wx_hw *wxhw = &hw->wxhw;

[...]

> +static u16 ngbe_phy_read_reg_internal(struct ngbe_hw *hw, u32 reg_addr)
> +{
> +	u16 phy_data = 0;
> +
> +	phy_data = (u16)rd32(&hw->wxhw, NGBE_PHY_CONFIG(reg_addr));
> +	return phy_data;

static u16 ngbe_...(...)
{
	return rd32(&hw->wxhw, ...);
}

and that's it.

> +}
> +
> +static void ngbe_phy_write_reg_internal(struct ngbe_hw *hw, u32 reg_addr, u16 phy_data)
> +{
> +	wr32(&hw->wxhw, NGBE_PHY_CONFIG(reg_addr), phy_data);
> +}

[...]

> +static u16 ngbe_phy_read_reg_ext_yt(struct ngbe_hw *hw,
> +				    u32 reg_addr)
> +{
> +	u16 val = 0;
> +
> +	ngbe_phy_write_reg_mdi(hw, 0x1e, reg_addr);
> +	val = ngbe_phy_read_reg_mdi(hw, 0x1f);
> +
> +	return val;

Same here:

{
	ngbe_phy_write_...(...);
	return ngbe_phy_read_...(...);
}

> +}
> +
> +static void ngbe_phy_write_reg_ext_yt(struct ngbe_hw *hw,
> +				      u32 reg_addr,
> +				      u16 phy_data)
> +{
> +	ngbe_phy_write_reg_mdi(hw, 0x1e, reg_addr);
> +	ngbe_phy_write_reg_mdi(hw, 0x1f, phy_data);
> +}
> +
> +static u16 ngbe_phy_read_reg_sds_ext_yt(struct ngbe_hw *hw,
> +					u32 reg_addr)
> +{
> +	u16 val = 0;

"val assigned to a value which is never used" -- you don't need to
initialize it with 0 since it's overwritten two lines below.

> +
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
> +	val = ngbe_phy_read_reg_ext_yt(hw, reg_addr);
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
> +
> +	return val;
> +}
> +
> +static void ngbe_phy_write_reg_sds_ext_yt(struct ngbe_hw *hw,
> +					  u32 reg_addr,
> +					  u16 phy_data)
> +{
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
> +	ngbe_phy_write_reg_ext_yt(hw, reg_addr, phy_data);
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
> +}
> +
> +static u16 ngbe_phy_read_reg_sds_mii_yt(struct ngbe_hw *hw,
> +					u32 reg_addr)
> +{
> +	u16 val = 0;

^

> +
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
> +	val = ngbe_phy_read_reg_mdi(hw, reg_addr);
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
> +
> +	return val;
> +}
> +
> +static void ngbe_phy_write_reg_sds_mii_yt(struct ngbe_hw *hw,
> +					  u32 reg_addr,
> +					  u16 phy_data)
> +{
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x02);
> +	ngbe_phy_write_reg_mdi(hw, reg_addr, phy_data);
> +	ngbe_phy_write_reg_ext_yt(hw, 0xa000, 0x00);
> +}
> +
> +static void ngbe_phy_led_ctrl_mv(struct ngbe_hw *hw)
> +{
> +	u16 val = 0;

^

> +
> +	if (hw->led_conf == 0xffffffff) {

	if (hw->led_conf != 0xffffffff)
		return;

Saves one indent level.

> +		/* LED control */
> +		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 3);
> +		val = ngbe_phy_read_reg(hw, NGBE_PHY_LED_FUNC_CTRL_REG_MV);
> +		val &= ~0x00FF;
> +		val |= (NGBE_LED1_CONF_MV << 4) | NGBE_LED0_CONF_MV;

I think you could use smth like u32_replace_bits() to do that in a
more robust way.

> +		ngbe_phy_write_reg(hw, NGBE_PHY_LED_FUNC_CTRL_REG_MV, val);
> +		val = ngbe_phy_read_reg(hw, NGBE_PHY_LED_POL_CTRL_REG_MV);
> +		val &= ~0x000F;
> +		val |= (NGBE_LED1_POL_MV << 2) | NGBE_LED0_POL_MV;
> +		ngbe_phy_write_reg(hw, NGBE_PHY_LED_POL_CTRL_REG_MV, val);
> +	}
> +}
> +
> +static void ngbe_phy_led_ctrl_internal(struct ngbe_hw *hw)
> +{
> +	u16 val = 0;

^ (don't initialize)

> +
> +	if (hw->led_conf != 0xffffffff)
> +		val = hw->led_conf & 0xffff;
> +	else
> +		val = 0x205B;

[...]

> +static int ngbe_gphy_wait_mdio_access_on(struct ngbe_hw *hw)
> +{
> +	u16 val = 0;
> +	int ret = 0;

^, @ret can be left uninitialized.

> +
> +	/* select page to 0xa43*/
> +	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa43);
> +	/* wait to phy can access */
> +	ret = read_poll_timeout(ngbe_phy_read_reg, val, val & 0x20, 1000,
> +				100000, false, hw, 0x1d);
> +
> +	if (ret)
> +		wx_dbg(&hw->wxhw, "Access to phy timeout\n");
> +
> +	return ret;
> +}
> +
> +static int ngbe_phy_init_m88e1512(struct ngbe_hw *hw)
> +{
> +	u16 val = 0;
> +	int ret = 0;

^, both of them can be left uninitialized.

> +
> +	/* select page to 0x2 */
> +	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x2);
> +	val = ngbe_phy_read_reg(hw, 0x15);
> +	val &= ~NGBE_RGM_TTC_MV;
> +	val |= NGBE_RGM_RTC_MV;
> +	ngbe_phy_write_reg(hw, 0x15, val);
> +
> +	/* phy reset */
> +	ret = ngbe_phy_reset(hw);
> +	if (!ret)
> +		return ret;

Is it correct that if the function returns 0, you bail out? Not
`if (ret) return ret`? If it is intended, return 0 here then.

> +
> +	/* set LED2 to interrupt output and INTn active low */
> +	/* select page to 0x3 */
> +	ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x3);
> +	val = ngbe_phy_read_reg(hw, NGBE_PHY_INTM_REG);
> +	val |= NGBE_INT_EN_MV;
> +	val &= ~(NGBE_INT_POL_MV);
> +	ngbe_phy_write_reg(hw, NGBE_PHY_INTM_REG, val);
> +
> +	return 0;
> +}

[...]

> +static void ngbe_check_phy_id(struct ngbe_hw *hw)
> +{
> +	u16 phy_id_high = 0, phy_id_low = 0;
> +	u32 phy_id = 0xffffffff;

All three of them don't need to be initialized.

> +
> +	phy_id_high = ngbe_phy_read_reg(hw, NGBE_PHY_ID1_REG);
> +	phy_id_low = ngbe_phy_read_reg(hw, NGBE_PHY_ID2_REG);
> +
> +	phy_id = phy_id_high << 6;
> +	phy_id |= (phy_id_low & NGBE_PHY_ID_MASK) >> 10;
> +
> +	/* for yt 8521s phy id is 0 */
> +	if (!phy_id) {
> +		if (phy_id_low)
> +			hw->phy.id = phy_id_low;
> +		else
> +			wx_dbg(&hw->wxhw, "Can not get phy id.\n");
> +	}
> +	hw->phy.id = phy_id;
> +}

[...]

> +static int ngbe_phy_identify(struct ngbe_hw *hw)
> +{
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u32 phy_id = 0;
> +	int ret = 0;
> +
> +	if (hw->phy.id)
> +		return ret;

		return 0; // would look more digestible

> +	switch (hw->phy.type) {
> +	case ngbe_phy_internal:
> +	case ngbe_phy_internal_yt_sfi:
> +		ngbe_gphy_wait_mdio_access_on(hw);
> +		phy_id = NGBE_PHY_ID_INTERNAL;
> +		break;
> +	case ngbe_phy_m88e1512:
> +	case ngbe_phy_m88e1512_sfi:
> +	case ngbe_phy_m88e1512_mix:
> +		phy_id = NGBE_PHY_ID_MV;
> +		break;
> +	case ngbe_phy_yt_mix:
> +		phy_id = NGBE_PHY_ID_YT8521S | NGBE_PHY_ID_YT8531S;
> +		break;
> +	default:
> +		ret =  -EINVAL;

Shouldn't we exit here with -%EINVAL if it's not supported anyway?

> +	}
> +
> +	ngbe_check_phy_id(hw);
> +	if ((hw->phy.id & phy_id) != hw->phy.id) {
> +		wx_err(wxhw, "Phy id 0x%x not supported.\n", phy_id);
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +/**
> + *  ngbe_phy_init - PHY specific init
> + *  @hw: pointer to hardware structure
> + *
> + *  Check phy id, Initialize phy mode and media type, Enable the required interrupt.
> + **/
> +int ngbe_phy_init(struct ngbe_hw *hw)
> +{
> +	int ret = 0;

	int ret;

> +	u16 val = 0;
> +
> +	/* Identify the PHY*/
> +	ret = ngbe_phy_identify(hw);
> +	if (ret)
> +		return ret;
> +
> +	ret = ngbe_get_phy_media_type(hw);
> +	if (ret) {
> +		wx_err(&hw->wxhw, "The phy mode is not supported.\n");
> +		return ret;
> +	}
> +
> +	switch (hw->phy.type) {
> +	case ngbe_phy_internal:
> +	case ngbe_phy_internal_yt_sfi:
> +		val = NGBE_PHY_INT_STATUS_LSC_INTERNAL |
> +		      NGBE_PHY_INT_STATUS_ANC_INTERNAL;
> +		/* select page to 0xa42 */
> +		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_INTERNAL, 0xa42);
> +		break;
> +	case ngbe_phy_m88e1512:
> +		ngbe_phy_init_m88e1512(hw);
> +		/* select page to 0x0 */
> +		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x0);
> +		/* enable link status change and AN complete interrupts */
> +		val = NGBE_PHY_INT_STATUS_ANC_MV | NGBE_PHY_INT_STATUS_LSC_MV;
> +		break;
> +	case ngbe_phy_m88e1512_sfi:
> +		ngbe_phy_init_m88e1512(hw);
> +		/* select page to 0x1 */
> +		ngbe_phy_write_reg(hw, NGBE_PHY_PAGE_ACCESS_MV, 0x1);
> +		val = ngbe_phy_read_reg(hw, 0x10);
> +		val &= ~0x4;
> +		ngbe_phy_write_reg(hw, 0x10, val);
> +
> +		/* enable link status change and AN complete interrupts */
> +		val = NGBE_PHY_INT_STATUS_ANC_MV | NGBE_PHY_INT_STATUS_LSC_MV;
> +		break;
> +	case ngbe_phy_yt_mix:
> +		/* select sds area register */
> +		ngbe_phy_write_reg(hw, 0x1e, 0xa000);
> +		ngbe_phy_write_reg(hw, 0x1f, 0x0);
> +
> +		/* enable interrupt */
> +		val = NGBE_PHY_INT_STATUS_SDSLNKUP_YT |
> +		      NGBE_PHY_INT_STATUS_SDSLNKDN_YT |
> +		      NGBE_PHY_INT_STATUS_UTPLNKUP_YT |
> +		      NGBE_PHY_INT_STATUS_UTPLNKDN_YT;
> +		break;
> +	default:
> +		ret =  -EINVAL;

Same?

> +	}
> +	/* write interrupts bits to register */
> +	ngbe_phy_write_reg(hw, NGBE_PHY_INTM_REG, val);
> +
> +	return ret;
> +}

[...]

> +static int ngbe_gphy_efuse_calibration(struct ngbe_hw *hw)
> +{
> +	u32 efuse[2] = {0, 0};

You can always just use `= { };` next time, for both arrays and
structures. So that you wouldn't need to adjust initializer when
adding new fields or elements (to avoid
-Wmissing-field-initializers).

> +
> +	ngbe_gphy_wait_mdio_access_on(hw);
> +
> +	efuse[0] = hw->phy.gphy_efuse[0];
> +	efuse[1] = hw->phy.gphy_efuse[1];

Nevermind, you don't need to initialize the array at all since you
overwrite both elements.

> +
> +	if (!efuse[0] && !efuse[1]) {
> +		efuse[0] = 0xFFFFFFFF;
> +		efuse[1] = 0xFFFFFFFF;
> +	}

[...]

> +static void ngbe_phy_setup_powerup(struct ngbe_hw *hw)
> +{
> +	struct wx_hw *wxhw = &hw->wxhw;
> +	u16 val = 0;
> +	int ret = 0;

Ok here I got tired of cosplaying a compiler / semantic checker,
could you please maybe recheck all your code and remove initializers
when they aren't needed? You can use `make W=1` if needed to make
sure you didn't miss anything.

> +
> +	ret = read_poll_timeout(rd32, val,
> +				!(val & (BIT(9) << wxhw->bus.func)), 1000,
> +				100000, false, wxhw, 0x10028);
> +
> +	if (ret)
> +		wx_dbg(wxhw, "Lan reset exceeds maximum times.\n");

[...]

> +		/* open auto sensing */
> +		val = ngbe_phy_read_reg_sds_ext_yt(hw, 0xA5);
> +		val |= 0x8000;

Can such magic values be defined somewhere with some meaningful
names? Like

#define NGBE_SDS_EXT_SOMETHING	BIT(15)

> +		ngbe_phy_write_reg_sds_ext_yt(hw, 0xA5, val);
> +
> +		val = ngbe_phy_read_reg_ext_yt(hw, 0xA006);
> +		val |= 0x1;
> +		ngbe_phy_write_reg_ext_yt(hw, 0xA006, val);
> +skip_an_fiber:
> +		/* RGMII_Config1 : Config rx and tx training delay */
> +		ngbe_phy_write_reg_ext_yt(hw, 0xA003, 0x3cf1);
> +		ngbe_phy_write_reg_ext_yt(hw, 0xA001, 0x8041);

[...]

> @@ -122,9 +216,16 @@ struct ngbe_phy_info {
>  
>  	u32 addr;
>  	u32 id;
> +	u8 phy_mode;

+ a 3-byte hole. Maybe at least combine with ::autoneg?

	u32 gphy_efuse[2];
	u8 phy_mode;

	u8 autoneg:1;
	u32 autoneg_advertised;

This would give you a 2-byte hole instead of 3 and 7 free bits to
store some more flags.

> +	u32 gphy_efuse[2];
>  
> -	bool reset_if_overtemp;
> +	bool autoneg;
> +	u32 autoneg_advertised;
> +};
>  
> +enum ngbe_pf_flags {
> +	NGBE_FLAG_NEED_LINK_UPDATE,
> +	NGBE_FLAGS_NBITS		/* must be last */
>  };
>  
>  struct ngbe_hw {
> @@ -135,5 +236,7 @@ struct ngbe_hw {
>  	bool wol_enabled;
>  	bool ncsi_enabled;
>  	bool gpio_ctrl;
> +
> +	u32 led_conf;
>  };
>  #endif /* _NGBE_TYPE_H_ */
> -- 
> 2.38.1

Thanks,
Olek
