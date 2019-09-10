Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A0AF1CE
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 21:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfIJTUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 15:20:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38890 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbfIJTUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 15:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FnDUmCvfLVGbXEeln5LPj48JDVRy5t2H17lHntr4Za8=; b=FgG4TIJXEw37DOlekhWL0Y2G3D
        0o9Zhu3zoRcNdzwCWGSenImW5q3qzbVHnHIQtyhOZ4nwxF+qdym4/3Krl/0mcGA2Vc5kciElHkkx9
        qDnFAqMoh1sWflrZfv91UrkPw5HvWIhXypSneqEzZdAiusznmixbu7yOalYloVZn/Fdc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7lgr-0003cS-BF; Tue, 10 Sep 2019 21:20:37 +0200
Date:   Tue, 10 Sep 2019 21:20:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
Subject: Re: [PATCH net-next 03/11] net: aquantia: add basic ptp_clock
 callbacks
Message-ID: <20190910192037.GF9761@lunn.ch>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
 <8868449ec5508f498131ee141399149bf801ea94.1568034880.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8868449ec5508f498131ee141399149bf801ea94.1568034880.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static s64 ptp_clk_offset;

> +static void hw_atl_b0_get_ptp_ts(struct aq_hw_s *self, u64 *stamp)
> +{
> +	u64 ns;
> +
> +	hw_atl_pcs_ptp_clock_read_enable(self, 1);
> +	hw_atl_pcs_ptp_clock_read_enable(self, 0);
> +	ns = (get_ptp_ts_val_u64(self, 0) +
> +	      (get_ptp_ts_val_u64(self, 1) << 16)) * 1000000000llu +
> +	     (get_ptp_ts_val_u64(self, 3) +
> +	      (get_ptp_ts_val_u64(self, 4) << 16));
> +
> +	*stamp = ns + ptp_clk_offset;
> +}
> +
> +static void hw_atl_b0_adj_params_get(u64 freq, s64 adj, u32 *ns, u32 *fns)
> +{
> +	/* For accuracy, the digit is extended */
> +	s64 divisor = 0, base_ns = ((adj + 1000000000ll) * 1000000000ll) / freq;
> +	u32 nsi_frac = 0, nsi = base_ns / 1000000000ll;
> +
> +	if (base_ns != nsi * 1000000000ll) {
> +		divisor = 1000000000000000000ll /
> +			  (base_ns - nsi * 1000000000ll);
> +		nsi_frac = 0x100000000ll * 1000000000ll / divisor;
> +	}
> +
> +	*ns = nsi;
> +	*fns = nsi_frac;
> +}
> +

> +static int hw_atl_b0_adj_sys_clock(struct aq_hw_s *self, s64 delta)
> +{
> +	ptp_clk_offset += delta;
> +
> +	return 0;
> +}

Does this work when i have a box with 42 NICs in it? Does not each NIC
need its own clock offset? Just seeing code like this causes alarm
bells. So if it is correct, i would expect some sort of comment to
prevent those alarm bells.

      Andrew






> +
> +static int hw_atl_b0_set_sys_clock(struct aq_hw_s *self, u64 time, u64 ts)
> +{
> +	s64 delta = time - (ptp_clk_offset + ts);
> +
> +	return hw_atl_b0_adj_sys_clock(self, delta);
> +}
> +
> +static int hw_atl_b0_adj_clock_freq(struct aq_hw_s *self, s32 ppb)
> +{
> +	struct hw_fw_request_iface fwreq;
> +	size_t size;
> +
> +	memset(&fwreq, 0, sizeof(fwreq));
> +
> +	fwreq.msg_id = HW_AQ_FW_REQUEST_PTP_ADJ_FREQ;
> +	hw_atl_b0_adj_params_get(AQ_HW_MAC_COUNTER_HZ, ppb,
> +				 &fwreq.ptp_adj_freq.ns_mac,
> +				 &fwreq.ptp_adj_freq.fns_mac);
> +	hw_atl_b0_adj_params_get(AQ_HW_PHY_COUNTER_HZ, ppb,
> +				 &fwreq.ptp_adj_freq.ns_phy,
> +				 &fwreq.ptp_adj_freq.fns_phy);
> +	hw_atl_b0_mac_adj_param_calc(&fwreq.ptp_adj_freq,
> +				     AQ_HW_PHY_COUNTER_HZ,
> +				     AQ_HW_MAC_COUNTER_HZ);
> +
> +	size = sizeof(fwreq.msg_id) + sizeof(fwreq.ptp_adj_freq);
> +	return self->aq_fw_ops->send_fw_request(self, &fwreq, size);
> +}
> +
>  static int hw_atl_b0_hw_fl3l4_clear(struct aq_hw_s *self,
>  				    struct aq_rx_filter_l3l4 *data)
>  {
> @@ -1164,6 +1256,12 @@ const struct aq_hw_ops hw_atl_ops_b0 = {
>  	.hw_get_regs                 = hw_atl_utils_hw_get_regs,
>  	.hw_get_hw_stats             = hw_atl_utils_get_hw_stats,
>  	.hw_get_fw_version           = hw_atl_utils_get_fw_version,
> -	.hw_set_offload              = hw_atl_b0_hw_offload_set,
> +
> +	.hw_get_ptp_ts           = hw_atl_b0_get_ptp_ts,
> +	.hw_adj_sys_clock        = hw_atl_b0_adj_sys_clock,
> +	.hw_set_sys_clock        = hw_atl_b0_set_sys_clock,
> +	.hw_adj_clock_freq       = hw_atl_b0_adj_clock_freq,
> +
> +	.hw_set_offload          = hw_atl_b0_hw_offload_set,
>  	.hw_set_fc                   = hw_atl_b0_set_fc,
>  };
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> index 1149812ae463..25e7261f6a44 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
> + * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
>   */
>  
>  /* File hw_atl_llh.c: Definitions of bitfield and register access functions for
> @@ -1513,6 +1513,20 @@ void hw_atl_reg_glb_cpu_scratch_scp_set(struct aq_hw_s *aq_hw,
>  			glb_cpu_scratch_scp);
>  }
>  
> +void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
> +				      u32 ptp_clock_read_enable)
> +{
> +	aq_hw_write_reg_bit(aq_hw, HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR,
> +			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK,
> +			    HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT,
> +			    ptp_clock_read_enable);
> +}
> +
> +u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index)
> +{
> +	return aq_hw_read_reg(aq_hw, HW_ATL_PCS_PTP_TS_VAL_ADDR(index));
> +}
> +
>  void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr)
>  {
>  	aq_hw_write_reg_bit(aq_hw, HW_ATL_MCP_UP_FORCE_INTERRUPT_ADR,
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> index 0c37abbabca5..a62693e51a6b 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
> + * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
>   */
>  
>  /* File hw_atl_llh.h: Declarations of bitfield and register access functions for
> @@ -712,6 +712,12 @@ void hw_atl_msm_reg_wr_strobe_set(struct aq_hw_s *aq_hw, u32 reg_wr_strobe);
>  /* set pci register reset disable */
>  void hw_atl_pci_pci_reg_res_dis_set(struct aq_hw_s *aq_hw, u32 pci_reg_res_dis);
>  
> +/* pcs */
> +void hw_atl_pcs_ptp_clock_read_enable(struct aq_hw_s *aq_hw,
> +				      u32 ptp_clock_read_enable);
> +
> +u32 hw_atl_pcs_ptp_clock_get(struct aq_hw_s *aq_hw, u32 index);
> +
>  /* set uP Force Interrupt */
>  void hw_atl_mcp_up_force_intr_set(struct aq_hw_s *aq_hw, u32 up_force_intr);
>  
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> index c3febcdfa92e..7716e0fc22b5 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
> + * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
>   */
>  
>  /* File hw_atl_llh_internal.h: Preprocessor definitions
> @@ -2421,6 +2421,22 @@
>  /* default value of bitfield register write strobe */
>  #define HW_ATL_MSM_REG_WR_STROBE_DEFAULT 0x0
>  
> +/* register address for bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_ADR 0x00004628
> +/* bitmask for bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSK 0x00000010
> +/* inverted bitmask for bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_MSKN 0xFFFFFFEF
> +/* lower bit position of bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_SHIFT 4
> +/* width of bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_WIDTH 1
> +/* default value of bitfield PTP Digital Clock Read Enable */
> +#define HW_ATL_PCS_PTP_CLOCK_READ_ENABLE_DEFAULT 0x0
> +
> +/* register address for ptp counter reading */
> +#define HW_ATL_PCS_PTP_TS_VAL_ADDR(index) (0x00004900 + (index) * 0x4)
> +
>  /* mif soft reset bitfield definitions
>   * preprocessor definitions for the bitfield "soft reset".
>   * port="pif_glb_res_i"
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> index 32512539ae86..6fc5640065bd 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
> @@ -327,8 +327,7 @@ int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
>  	return err;
>  }
>  
> -static int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p,
> -					 u32 cnt)
> +int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32 cnt)
>  {
>  	u32 val;
>  	int err = 0;
> @@ -964,4 +963,6 @@ const struct aq_fw_ops aq_fw_1x_ops = {
>  	.set_eee_rate = NULL,
>  	.get_eee_rate = NULL,
>  	.set_flow_control = NULL,
> +	.send_fw_request = NULL,
> +	.enable_ptp = NULL,
>  };
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
> index 766e02c7fd4e..f2eb94f298e2 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.h
> @@ -279,6 +279,34 @@ struct __packed offload_info {
>  	u8 buf[0];
>  };
>  
> +/* Mailbox FW Request interface */
> +struct __packed hw_fw_request_ptp_adj_freq {
> +	u32 ns_mac;
> +	u32 fns_mac;
> +	u32 ns_phy;
> +	u32 fns_phy;
> +	u32 mac_ns_adj;
> +	u32 mac_fns_adj;
> +};
> +
> +struct __packed hw_fw_request_ptp_adj_clock {
> +	u32 ns;
> +	u32 sec;
> +	int sign;
> +};
> +
> +#define HW_AQ_FW_REQUEST_PTP_ADJ_FREQ	         0x12
> +#define HW_AQ_FW_REQUEST_PTP_ADJ_CLOCK	         0x13
> +
> +struct __packed hw_fw_request_iface {
> +	u32 msg_id;
> +	union {
> +		/* PTP FW Request */
> +		struct hw_fw_request_ptp_adj_freq ptp_adj_freq;
> +		struct hw_fw_request_ptp_adj_clock ptp_adj_clock;
> +	};
> +};
> +
>  enum hw_atl_rx_action_with_traffic {
>  	HW_ATL_RX_DISCARD,
>  	HW_ATL_RX_HOST,
> @@ -561,6 +589,8 @@ struct aq_stats_s *hw_atl_utils_get_hw_stats(struct aq_hw_s *self);
>  int hw_atl_utils_fw_downld_dwords(struct aq_hw_s *self, u32 a,
>  				  u32 *p, u32 cnt);
>  
> +int hw_atl_utils_fw_upload_dwords(struct aq_hw_s *self, u32 a, u32 *p, u32 cnt);
> +
>  int hw_atl_utils_fw_set_wol(struct aq_hw_s *self, bool wol_enabled, u8 *mac);
>  
>  int hw_atl_utils_fw_rpc_call(struct aq_hw_s *self, unsigned int rpc_size);
> diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> index da726489e3c8..8b9824b1dc5e 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>  /*
>   * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2017 aQuantia Corporation. All rights reserved
> + * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
>   */
>  
>  /* File hw_atl_utils_fw2x.c: Definition of firmware 2.x functions for
> @@ -17,14 +17,17 @@
>  #include "hw_atl_utils.h"
>  #include "hw_atl_llh.h"
>  
> -#define HW_ATL_FW2X_MPI_RPC_ADDR        0x334
> +#define HW_ATL_FW2X_MPI_RPC_ADDR         0x334
>  
> -#define HW_ATL_FW2X_MPI_MBOX_ADDR       0x360
> -#define HW_ATL_FW2X_MPI_EFUSE_ADDR	0x364
> -#define HW_ATL_FW2X_MPI_CONTROL_ADDR	0x368
> -#define HW_ATL_FW2X_MPI_CONTROL2_ADDR	0x36C
> -#define HW_ATL_FW2X_MPI_STATE_ADDR	0x370
> -#define HW_ATL_FW2X_MPI_STATE2_ADDR     0x374
> +#define HW_ATL_FW2X_MPI_MBOX_ADDR        0x360
> +#define HW_ATL_FW2X_MPI_EFUSE_ADDR       0x364
> +#define HW_ATL_FW2X_MPI_CONTROL_ADDR     0x368
> +#define HW_ATL_FW2X_MPI_CONTROL2_ADDR    0x36C
> +#define HW_ATL_FW2X_MPI_STATE_ADDR       0x370
> +#define HW_ATL_FW2X_MPI_STATE2_ADDR      0x374
> +
> +#define HW_ATL_FW3X_EXT_CONTROL_ADDR     0x378
> +#define HW_ATL_FW3X_EXT_STATE_ADDR       0x37c
>  
>  #define HW_ATL_FW2X_CAP_PAUSE            BIT(CAPS_HI_PAUSE)
>  #define HW_ATL_FW2X_CAP_ASYM_PAUSE       BIT(CAPS_HI_ASYMMETRIC_PAUSE)
> @@ -444,6 +447,54 @@ static int aq_fw2x_set_power(struct aq_hw_s *self, unsigned int power_state,
>  	return err;
>  }
>  
> +static int aq_fw2x_send_fw_request(struct aq_hw_s *self,
> +				   const struct hw_fw_request_iface *fw_req,
> +				   size_t size)
> +{
> +	u32 ctrl2, orig_ctrl2;
> +	u32 dword_cnt;
> +	int err = 0;
> +	u32 val;
> +
> +	/* Write data to drvIface Mailbox */
> +	dword_cnt = size / sizeof(u32);
> +	if (size % sizeof(u32))
> +		dword_cnt++;
> +	err = hw_atl_utils_fw_upload_dwords(self, aq_fw2x_rpc_get(self),
> +					    (void *)fw_req, dword_cnt);
> +	if (err < 0)
> +		goto err_exit;
> +
> +	/* Toggle statistics bit for FW to update */
> +	ctrl2 = aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
> +	orig_ctrl2 = ctrl2 & BIT(CAPS_HI_FW_REQUEST);
> +	ctrl2 = ctrl2 ^ BIT(CAPS_HI_FW_REQUEST);
> +	aq_hw_write_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR, ctrl2);
> +
> +	/* Wait FW to report back */
> +	err = readx_poll_timeout_atomic(aq_fw2x_state2_get, self, val,
> +					orig_ctrl2 != (val &
> +						       BIT(CAPS_HI_FW_REQUEST)),
> +					1U, 10000U);
> +
> +err_exit:
> +	return err;
> +}
> +
> +static void aq_fw3x_enable_ptp(struct aq_hw_s *self, int enable)
> +{
> +	u32 ptp_opts = aq_hw_read_reg(self, HW_ATL_FW3X_EXT_STATE_ADDR);
> +	u32 all_ptp_features = BIT(CAPS_EX_PHY_PTP_EN) |
> +						   BIT(CAPS_EX_PTP_GPIO_EN);
> +
> +	if (enable)
> +		ptp_opts |= all_ptp_features;
> +	else
> +		ptp_opts &= ~all_ptp_features;
> +
> +	aq_hw_write_reg(self, HW_ATL_FW3X_EXT_CONTROL_ADDR, ptp_opts);
> +}
> +
>  static int aq_fw2x_set_eee_rate(struct aq_hw_s *self, u32 speed)
>  {
>  	u32 mpi_opts = aq_hw_read_reg(self, HW_ATL_FW2X_MPI_CONTROL2_ADDR);
> @@ -534,19 +585,21 @@ static u32 aq_fw2x_state2_get(struct aq_hw_s *self)
>  }
>  
>  const struct aq_fw_ops aq_fw_2x_ops = {
> -	.init = aq_fw2x_init,
> -	.deinit = aq_fw2x_deinit,
> -	.reset = NULL,
> -	.renegotiate = aq_fw2x_renegotiate,
> -	.get_mac_permanent = aq_fw2x_get_mac_permanent,
> -	.set_link_speed = aq_fw2x_set_link_speed,
> -	.set_state = aq_fw2x_set_state,
> +	.init               = aq_fw2x_init,
> +	.deinit             = aq_fw2x_deinit,
> +	.reset              = NULL,
> +	.renegotiate        = aq_fw2x_renegotiate,
> +	.get_mac_permanent  = aq_fw2x_get_mac_permanent,
> +	.set_link_speed     = aq_fw2x_set_link_speed,
> +	.set_state          = aq_fw2x_set_state,
>  	.update_link_status = aq_fw2x_update_link_status,
> -	.update_stats = aq_fw2x_update_stats,
> -	.get_phy_temp = aq_fw2x_get_phy_temp,
> -	.set_power = aq_fw2x_set_power,
> -	.set_eee_rate = aq_fw2x_set_eee_rate,
> -	.get_eee_rate = aq_fw2x_get_eee_rate,
> -	.set_flow_control = aq_fw2x_set_flow_control,
> -	.get_flow_control = aq_fw2x_get_flow_control
> +	.update_stats       = aq_fw2x_update_stats,
> +	.get_phy_temp       = aq_fw2x_get_phy_temp,
> +	.set_power          = aq_fw2x_set_power,
> +	.set_eee_rate       = aq_fw2x_set_eee_rate,
> +	.get_eee_rate       = aq_fw2x_get_eee_rate,
> +	.set_flow_control   = aq_fw2x_set_flow_control,
> +	.get_flow_control   = aq_fw2x_get_flow_control,
> +	.send_fw_request    = aq_fw2x_send_fw_request,
> +	.enable_ptp         = aq_fw3x_enable_ptp,
>  };
> -- 
> 2.17.1
> 
