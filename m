Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BFA3EC3FA
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbhHNQ5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 12:57:33 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:44377 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbhHNQ5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 12:57:32 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 95F99C3CF5
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 16:57:01 +0000 (UTC)
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id E30A2C0004;
        Sat, 14 Aug 2021 16:56:33 +0000 (UTC)
Date:   Sat, 14 Aug 2021 18:56:33 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 06/10] net: mscc: ocelot: split register
 definitions to a separate file
Message-ID: <YRf1wbHyS4EFt4Jn@piout.net>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-7-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814025003.2449143-7-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 13/08/2021 19:49:59-0700, Colin Foster wrote:
> Moving these to a separate file will allow them to be shared to other
> drivers.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/net/ethernet/mscc/Makefile         |   1 +
>  drivers/net/ethernet/mscc/ocelot_regs.c    | 309 +++++++++++++++++++++

Maybe this should be named
drivers/net/ethernet/mscc/ocelot_vsc7514_regs.c in the case we had more
chips later on. The naming we chose is that ocelot refers generically to
the switch IP instead of a specific implementation.

>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 295 +-------------------
>  include/soc/mscc/ocelot_regs.h             |  20 ++
>  4 files changed, 331 insertions(+), 294 deletions(-)
>  create mode 100644 drivers/net/ethernet/mscc/ocelot_regs.c
>  create mode 100644 include/soc/mscc/ocelot_regs.h
> 
> diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
> index 722c27694b21..d539a231a478 100644
> --- a/drivers/net/ethernet/mscc/Makefile
> +++ b/drivers/net/ethernet/mscc/Makefile
> @@ -7,6 +7,7 @@ mscc_ocelot_switch_lib-y := \
>  	ocelot_vcap.o \
>  	ocelot_flower.o \
>  	ocelot_ptp.o \
> +	ocelot_regs.o \
>  	ocelot_devlink.o
>  mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
>  obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
> diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
> new file mode 100644
> index 000000000000..b7ba137a7c90
> --- /dev/null
> +++ b/drivers/net/ethernet/mscc/ocelot_regs.c
> @@ -0,0 +1,309 @@
> +// SPDX-License-Identifier: (GPL-2.0 OR MIT)
> +/*
> + * Microsemi Ocelot Switch driver
> + *
> + * Copyright (c) 2017 Microsemi Corporation
> + */
> +#include "ocelot.h"
> +
> +const u32 ocelot_ana_regmap[] = {
> +	REG(ANA_ADVLEARN,				0x009000),
> +	REG(ANA_VLANMASK,				0x009004),
> +	REG(ANA_PORT_B_DOMAIN,				0x009008),
> +	REG(ANA_ANAGEFIL,				0x00900c),
> +	REG(ANA_ANEVENTS,				0x009010),
> +	REG(ANA_STORMLIMIT_BURST,			0x009014),
> +	REG(ANA_STORMLIMIT_CFG,				0x009018),
> +	REG(ANA_ISOLATED_PORTS,				0x009028),
> +	REG(ANA_COMMUNITY_PORTS,			0x00902c),
> +	REG(ANA_AUTOAGE,				0x009030),
> +	REG(ANA_MACTOPTIONS,				0x009034),
> +	REG(ANA_LEARNDISC,				0x009038),
> +	REG(ANA_AGENCTRL,				0x00903c),
> +	REG(ANA_MIRRORPORTS,				0x009040),
> +	REG(ANA_EMIRRORPORTS,				0x009044),
> +	REG(ANA_FLOODING,				0x009048),
> +	REG(ANA_FLOODING_IPMC,				0x00904c),
> +	REG(ANA_SFLOW_CFG,				0x009050),
> +	REG(ANA_PORT_MODE,				0x009080),
> +	REG(ANA_PGID_PGID,				0x008c00),
> +	REG(ANA_TABLES_ANMOVED,				0x008b30),
> +	REG(ANA_TABLES_MACHDATA,			0x008b34),
> +	REG(ANA_TABLES_MACLDATA,			0x008b38),
> +	REG(ANA_TABLES_MACACCESS,			0x008b3c),
> +	REG(ANA_TABLES_MACTINDX,			0x008b40),
> +	REG(ANA_TABLES_VLANACCESS,			0x008b44),
> +	REG(ANA_TABLES_VLANTIDX,			0x008b48),
> +	REG(ANA_TABLES_ISDXACCESS,			0x008b4c),
> +	REG(ANA_TABLES_ISDXTIDX,			0x008b50),
> +	REG(ANA_TABLES_ENTRYLIM,			0x008b00),
> +	REG(ANA_TABLES_PTP_ID_HIGH,			0x008b54),
> +	REG(ANA_TABLES_PTP_ID_LOW,			0x008b58),
> +	REG(ANA_MSTI_STATE,				0x008e00),
> +	REG(ANA_PORT_VLAN_CFG,				0x007000),
> +	REG(ANA_PORT_DROP_CFG,				0x007004),
> +	REG(ANA_PORT_QOS_CFG,				0x007008),
> +	REG(ANA_PORT_VCAP_CFG,				0x00700c),
> +	REG(ANA_PORT_VCAP_S1_KEY_CFG,			0x007010),
> +	REG(ANA_PORT_VCAP_S2_CFG,			0x00701c),
> +	REG(ANA_PORT_PCP_DEI_MAP,			0x007020),
> +	REG(ANA_PORT_CPU_FWD_CFG,			0x007060),
> +	REG(ANA_PORT_CPU_FWD_BPDU_CFG,			0x007064),
> +	REG(ANA_PORT_CPU_FWD_GARP_CFG,			0x007068),
> +	REG(ANA_PORT_CPU_FWD_CCM_CFG,			0x00706c),
> +	REG(ANA_PORT_PORT_CFG,				0x007070),
> +	REG(ANA_PORT_POL_CFG,				0x007074),
> +	REG(ANA_PORT_PTP_CFG,				0x007078),
> +	REG(ANA_PORT_PTP_DLY1_CFG,			0x00707c),
> +	REG(ANA_OAM_UPM_LM_CNT,				0x007c00),
> +	REG(ANA_PORT_PTP_DLY2_CFG,			0x007080),
> +	REG(ANA_PFC_PFC_CFG,				0x008800),
> +	REG(ANA_PFC_PFC_TIMER,				0x008804),
> +	REG(ANA_IPT_OAM_MEP_CFG,			0x008000),
> +	REG(ANA_IPT_IPT,				0x008004),
> +	REG(ANA_PPT_PPT,				0x008ac0),
> +	REG(ANA_FID_MAP_FID_MAP,			0x000000),
> +	REG(ANA_AGGR_CFG,				0x0090b4),
> +	REG(ANA_CPUQ_CFG,				0x0090b8),
> +	REG(ANA_CPUQ_CFG2,				0x0090bc),
> +	REG(ANA_CPUQ_8021_CFG,				0x0090c0),
> +	REG(ANA_DSCP_CFG,				0x009100),
> +	REG(ANA_DSCP_REWR_CFG,				0x009200),
> +	REG(ANA_VCAP_RNG_TYPE_CFG,			0x009240),
> +	REG(ANA_VCAP_RNG_VAL_CFG,			0x009260),
> +	REG(ANA_VRAP_CFG,				0x009280),
> +	REG(ANA_VRAP_HDR_DATA,				0x009284),
> +	REG(ANA_VRAP_HDR_MASK,				0x009288),
> +	REG(ANA_DISCARD_CFG,				0x00928c),
> +	REG(ANA_FID_CFG,				0x009290),
> +	REG(ANA_POL_PIR_CFG,				0x004000),
> +	REG(ANA_POL_CIR_CFG,				0x004004),
> +	REG(ANA_POL_MODE_CFG,				0x004008),
> +	REG(ANA_POL_PIR_STATE,				0x00400c),
> +	REG(ANA_POL_CIR_STATE,				0x004010),
> +	REG(ANA_POL_STATE,				0x004014),
> +	REG(ANA_POL_FLOWC,				0x008b80),
> +	REG(ANA_POL_HYST,				0x008bec),
> +	REG(ANA_POL_MISC_CFG,				0x008bf0),
> +};
> +EXPORT_SYMBOL(ocelot_ana_regmap);
> +
> +const u32 ocelot_qs_regmap[] = {
> +	REG(QS_XTR_GRP_CFG,				0x000000),
> +	REG(QS_XTR_RD,					0x000008),
> +	REG(QS_XTR_FRM_PRUNING,				0x000010),
> +	REG(QS_XTR_FLUSH,				0x000018),
> +	REG(QS_XTR_DATA_PRESENT,			0x00001c),
> +	REG(QS_XTR_CFG,					0x000020),
> +	REG(QS_INJ_GRP_CFG,				0x000024),
> +	REG(QS_INJ_WR,					0x00002c),
> +	REG(QS_INJ_CTRL,				0x000034),
> +	REG(QS_INJ_STATUS,				0x00003c),
> +	REG(QS_INJ_ERR,					0x000040),
> +	REG(QS_INH_DBG,					0x000048),
> +};
> +EXPORT_SYMBOL(ocelot_qs_regmap);
> +
> +const u32 ocelot_qsys_regmap[] = {
> +	REG(QSYS_PORT_MODE,				0x011200),
> +	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
> +	REG(QSYS_STAT_CNT_CFG,				0x011264),
> +	REG(QSYS_EEE_CFG,				0x011268),
> +	REG(QSYS_EEE_THRES,				0x011294),
> +	REG(QSYS_IGR_NO_SHARING,			0x011298),
> +	REG(QSYS_EGR_NO_SHARING,			0x01129c),
> +	REG(QSYS_SW_STATUS,				0x0112a0),
> +	REG(QSYS_EXT_CPU_CFG,				0x0112d0),
> +	REG(QSYS_PAD_CFG,				0x0112d4),
> +	REG(QSYS_CPU_GROUP_MAP,				0x0112d8),
> +	REG(QSYS_QMAP,					0x0112dc),
> +	REG(QSYS_ISDX_SGRP,				0x011400),
> +	REG(QSYS_TIMED_FRAME_ENTRY,			0x014000),
> +	REG(QSYS_TFRM_MISC,				0x011310),
> +	REG(QSYS_TFRM_PORT_DLY,				0x011314),
> +	REG(QSYS_TFRM_TIMER_CFG_1,			0x011318),
> +	REG(QSYS_TFRM_TIMER_CFG_2,			0x01131c),
> +	REG(QSYS_TFRM_TIMER_CFG_3,			0x011320),
> +	REG(QSYS_TFRM_TIMER_CFG_4,			0x011324),
> +	REG(QSYS_TFRM_TIMER_CFG_5,			0x011328),
> +	REG(QSYS_TFRM_TIMER_CFG_6,			0x01132c),
> +	REG(QSYS_TFRM_TIMER_CFG_7,			0x011330),
> +	REG(QSYS_TFRM_TIMER_CFG_8,			0x011334),
> +	REG(QSYS_RED_PROFILE,				0x011338),
> +	REG(QSYS_RES_QOS_MODE,				0x011378),
> +	REG(QSYS_RES_CFG,				0x012000),
> +	REG(QSYS_RES_STAT,				0x012004),
> +	REG(QSYS_EGR_DROP_MODE,				0x01137c),
> +	REG(QSYS_EQ_CTRL,				0x011380),
> +	REG(QSYS_EVENTS_CORE,				0x011384),
> +	REG(QSYS_CIR_CFG,				0x000000),
> +	REG(QSYS_EIR_CFG,				0x000004),
> +	REG(QSYS_SE_CFG,				0x000008),
> +	REG(QSYS_SE_DWRR_CFG,				0x00000c),
> +	REG(QSYS_SE_CONNECT,				0x00003c),
> +	REG(QSYS_SE_DLB_SENSE,				0x000040),
> +	REG(QSYS_CIR_STATE,				0x000044),
> +	REG(QSYS_EIR_STATE,				0x000048),
> +	REG(QSYS_SE_STATE,				0x00004c),
> +	REG(QSYS_HSCH_MISC_CFG,				0x011388),
> +};
> +EXPORT_SYMBOL(ocelot_qsys_regmap);
> +
> +const u32 ocelot_rew_regmap[] = {
> +	REG(REW_PORT_VLAN_CFG,				0x000000),
> +	REG(REW_TAG_CFG,				0x000004),
> +	REG(REW_PORT_CFG,				0x000008),
> +	REG(REW_DSCP_CFG,				0x00000c),
> +	REG(REW_PCP_DEI_QOS_MAP_CFG,			0x000010),
> +	REG(REW_PTP_CFG,				0x000050),
> +	REG(REW_PTP_DLY1_CFG,				0x000054),
> +	REG(REW_DSCP_REMAP_DP1_CFG,			0x000690),
> +	REG(REW_DSCP_REMAP_CFG,				0x000790),
> +	REG(REW_STAT_CFG,				0x000890),
> +	REG(REW_PPT,					0x000680),
> +};
> +EXPORT_SYMBOL(ocelot_rew_regmap);
> +
> +const u32 ocelot_sys_regmap[] = {
> +	REG(SYS_COUNT_RX_OCTETS,			0x000000),
> +	REG(SYS_COUNT_RX_UNICAST,			0x000004),
> +	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
> +	REG(SYS_COUNT_RX_BROADCAST,			0x00000c),
> +	REG(SYS_COUNT_RX_SHORTS,			0x000010),
> +	REG(SYS_COUNT_RX_FRAGMENTS,			0x000014),
> +	REG(SYS_COUNT_RX_JABBERS,			0x000018),
> +	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,		0x00001c),
> +	REG(SYS_COUNT_RX_SYM_ERRS,			0x000020),
> +	REG(SYS_COUNT_RX_64,				0x000024),
> +	REG(SYS_COUNT_RX_65_127,			0x000028),
> +	REG(SYS_COUNT_RX_128_255,			0x00002c),
> +	REG(SYS_COUNT_RX_256_1023,			0x000030),
> +	REG(SYS_COUNT_RX_1024_1526,			0x000034),
> +	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
> +	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
> +	REG(SYS_COUNT_RX_CONTROL,			0x000040),
> +	REG(SYS_COUNT_RX_LONGS,				0x000044),
> +	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
> +	REG(SYS_COUNT_TX_OCTETS,			0x000100),
> +	REG(SYS_COUNT_TX_UNICAST,			0x000104),
> +	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
> +	REG(SYS_COUNT_TX_BROADCAST,			0x00010c),
> +	REG(SYS_COUNT_TX_COLLISION,			0x000110),
> +	REG(SYS_COUNT_TX_DROPS,				0x000114),
> +	REG(SYS_COUNT_TX_PAUSE,				0x000118),
> +	REG(SYS_COUNT_TX_64,				0x00011c),
> +	REG(SYS_COUNT_TX_65_127,			0x000120),
> +	REG(SYS_COUNT_TX_128_511,			0x000124),
> +	REG(SYS_COUNT_TX_512_1023,			0x000128),
> +	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
> +	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
> +	REG(SYS_COUNT_TX_AGING,				0x000170),
> +	REG(SYS_RESET_CFG,				0x000508),
> +	REG(SYS_CMID,					0x00050c),
> +	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
> +	REG(SYS_PORT_MODE,				0x000514),
> +	REG(SYS_FRONT_PORT_MODE,			0x000548),
> +	REG(SYS_FRM_AGING,				0x000574),
> +	REG(SYS_STAT_CFG,				0x000578),
> +	REG(SYS_SW_STATUS,				0x00057c),
> +	REG(SYS_MISC_CFG,				0x0005ac),
> +	REG(SYS_REW_MAC_HIGH_CFG,			0x0005b0),
> +	REG(SYS_REW_MAC_LOW_CFG,			0x0005dc),
> +	REG(SYS_CM_ADDR,				0x000500),
> +	REG(SYS_CM_DATA,				0x000504),
> +	REG(SYS_PAUSE_CFG,				0x000608),
> +	REG(SYS_PAUSE_TOT_CFG,				0x000638),
> +	REG(SYS_ATOP,					0x00063c),
> +	REG(SYS_ATOP_TOT_CFG,				0x00066c),
> +	REG(SYS_MAC_FC_CFG,				0x000670),
> +	REG(SYS_MMGT,					0x00069c),
> +	REG(SYS_MMGT_FAST,				0x0006a0),
> +	REG(SYS_EVENTS_DIF,				0x0006a4),
> +	REG(SYS_EVENTS_CORE,				0x0006b4),
> +	REG(SYS_CNT,					0x000000),
> +	REG(SYS_PTP_STATUS,				0x0006b8),
> +	REG(SYS_PTP_TXSTAMP,				0x0006bc),
> +	REG(SYS_PTP_NXT,				0x0006c0),
> +	REG(SYS_PTP_CFG,				0x0006c4),
> +};
> +EXPORT_SYMBOL(ocelot_sys_regmap);
> +
> +const u32 ocelot_vcap_regmap[] = {
> +	/* VCAP_CORE_CFG */
> +	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
> +	REG(VCAP_CORE_MV_CFG,				0x000004),
> +	/* VCAP_CORE_CACHE */
> +	REG(VCAP_CACHE_ENTRY_DAT,			0x000008),
> +	REG(VCAP_CACHE_MASK_DAT,			0x000108),
> +	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
> +	REG(VCAP_CACHE_CNT_DAT,				0x000308),
> +	REG(VCAP_CACHE_TG_DAT,				0x000388),
> +	/* VCAP_CONST */
> +	REG(VCAP_CONST_VCAP_VER,			0x000398),
> +	REG(VCAP_CONST_ENTRY_WIDTH,			0x00039c),
> +	REG(VCAP_CONST_ENTRY_CNT,			0x0003a0),
> +	REG(VCAP_CONST_ENTRY_SWCNT,			0x0003a4),
> +	REG(VCAP_CONST_ENTRY_TG_WIDTH,			0x0003a8),
> +	REG(VCAP_CONST_ACTION_DEF_CNT,			0x0003ac),
> +	REG(VCAP_CONST_ACTION_WIDTH,			0x0003b0),
> +	REG(VCAP_CONST_CNT_WIDTH,			0x0003b4),
> +	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
> +	REG(VCAP_CONST_IF_CNT,				0x0003bc),
> +};
> +EXPORT_SYMBOL(ocelot_vcap_regmap);
> +
> +const u32 ocelot_ptp_regmap[] = {
> +	REG(PTP_PIN_CFG,				0x000000),
> +	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
> +	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
> +	REG(PTP_PIN_TOD_NSEC,				0x00000c),
> +	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
> +	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
> +	REG(PTP_CFG_MISC,				0x0000a0),
> +	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
> +	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
> +};
> +EXPORT_SYMBOL(ocelot_ptp_regmap);
> +
> +const u32 ocelot_dev_gmii_regmap[] = {
> +	REG(DEV_CLOCK_CFG,				0x0),
> +	REG(DEV_PORT_MISC,				0x4),
> +	REG(DEV_EVENTS,					0x8),
> +	REG(DEV_EEE_CFG,				0xc),
> +	REG(DEV_RX_PATH_DELAY,				0x10),
> +	REG(DEV_TX_PATH_DELAY,				0x14),
> +	REG(DEV_PTP_PREDICT_CFG,			0x18),
> +	REG(DEV_MAC_ENA_CFG,				0x1c),
> +	REG(DEV_MAC_MODE_CFG,				0x20),
> +	REG(DEV_MAC_MAXLEN_CFG,				0x24),
> +	REG(DEV_MAC_TAGS_CFG,				0x28),
> +	REG(DEV_MAC_ADV_CHK_CFG,			0x2c),
> +	REG(DEV_MAC_IFG_CFG,				0x30),
> +	REG(DEV_MAC_HDX_CFG,				0x34),
> +	REG(DEV_MAC_DBG_CFG,				0x38),
> +	REG(DEV_MAC_FC_MAC_LOW_CFG,			0x3c),
> +	REG(DEV_MAC_FC_MAC_HIGH_CFG,			0x40),
> +	REG(DEV_MAC_STICKY,				0x44),
> +	REG(PCS1G_CFG,					0x48),
> +	REG(PCS1G_MODE_CFG,				0x4c),
> +	REG(PCS1G_SD_CFG,				0x50),
> +	REG(PCS1G_ANEG_CFG,				0x54),
> +	REG(PCS1G_ANEG_NP_CFG,				0x58),
> +	REG(PCS1G_LB_CFG,				0x5c),
> +	REG(PCS1G_DBG_CFG,				0x60),
> +	REG(PCS1G_CDET_CFG,				0x64),
> +	REG(PCS1G_ANEG_STATUS,				0x68),
> +	REG(PCS1G_ANEG_NP_STATUS,			0x6c),
> +	REG(PCS1G_LINK_STATUS,				0x70),
> +	REG(PCS1G_LINK_DOWN_CNT,			0x74),
> +	REG(PCS1G_STICKY,				0x78),
> +	REG(PCS1G_DEBUG_STATUS,				0x7c),
> +	REG(PCS1G_LPI_CFG,				0x80),
> +	REG(PCS1G_LPI_WAKE_ERROR_CNT,			0x84),
> +	REG(PCS1G_LPI_STATUS,				0x88),
> +	REG(PCS1G_TSTPAT_MODE_CFG,			0x8c),
> +	REG(PCS1G_TSTPAT_STATUS,			0x90),
> +	REG(DEV_PCS_FX100_CFG,				0x94),
> +	REG(DEV_PCS_FX100_STATUS,			0x98),
> +};
> +EXPORT_SYMBOL(ocelot_dev_gmii_regmap);
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> index 4bd7e9d9ec61..ef1bf24f51b5 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -16,303 +16,10 @@
>  #include <net/switchdev.h>
>  
>  #include <soc/mscc/ocelot_vcap.h>
> +#include <soc/mscc/ocelot_regs.h>
>  #include <soc/mscc/ocelot_hsio.h>
>  #include "ocelot.h"
>  
> -static const u32 ocelot_ana_regmap[] = {
> -	REG(ANA_ADVLEARN,				0x009000),
> -	REG(ANA_VLANMASK,				0x009004),
> -	REG(ANA_PORT_B_DOMAIN,				0x009008),
> -	REG(ANA_ANAGEFIL,				0x00900c),
> -	REG(ANA_ANEVENTS,				0x009010),
> -	REG(ANA_STORMLIMIT_BURST,			0x009014),
> -	REG(ANA_STORMLIMIT_CFG,				0x009018),
> -	REG(ANA_ISOLATED_PORTS,				0x009028),
> -	REG(ANA_COMMUNITY_PORTS,			0x00902c),
> -	REG(ANA_AUTOAGE,				0x009030),
> -	REG(ANA_MACTOPTIONS,				0x009034),
> -	REG(ANA_LEARNDISC,				0x009038),
> -	REG(ANA_AGENCTRL,				0x00903c),
> -	REG(ANA_MIRRORPORTS,				0x009040),
> -	REG(ANA_EMIRRORPORTS,				0x009044),
> -	REG(ANA_FLOODING,				0x009048),
> -	REG(ANA_FLOODING_IPMC,				0x00904c),
> -	REG(ANA_SFLOW_CFG,				0x009050),
> -	REG(ANA_PORT_MODE,				0x009080),
> -	REG(ANA_PGID_PGID,				0x008c00),
> -	REG(ANA_TABLES_ANMOVED,				0x008b30),
> -	REG(ANA_TABLES_MACHDATA,			0x008b34),
> -	REG(ANA_TABLES_MACLDATA,			0x008b38),
> -	REG(ANA_TABLES_MACACCESS,			0x008b3c),
> -	REG(ANA_TABLES_MACTINDX,			0x008b40),
> -	REG(ANA_TABLES_VLANACCESS,			0x008b44),
> -	REG(ANA_TABLES_VLANTIDX,			0x008b48),
> -	REG(ANA_TABLES_ISDXACCESS,			0x008b4c),
> -	REG(ANA_TABLES_ISDXTIDX,			0x008b50),
> -	REG(ANA_TABLES_ENTRYLIM,			0x008b00),
> -	REG(ANA_TABLES_PTP_ID_HIGH,			0x008b54),
> -	REG(ANA_TABLES_PTP_ID_LOW,			0x008b58),
> -	REG(ANA_MSTI_STATE,				0x008e00),
> -	REG(ANA_PORT_VLAN_CFG,				0x007000),
> -	REG(ANA_PORT_DROP_CFG,				0x007004),
> -	REG(ANA_PORT_QOS_CFG,				0x007008),
> -	REG(ANA_PORT_VCAP_CFG,				0x00700c),
> -	REG(ANA_PORT_VCAP_S1_KEY_CFG,			0x007010),
> -	REG(ANA_PORT_VCAP_S2_CFG,			0x00701c),
> -	REG(ANA_PORT_PCP_DEI_MAP,			0x007020),
> -	REG(ANA_PORT_CPU_FWD_CFG,			0x007060),
> -	REG(ANA_PORT_CPU_FWD_BPDU_CFG,			0x007064),
> -	REG(ANA_PORT_CPU_FWD_GARP_CFG,			0x007068),
> -	REG(ANA_PORT_CPU_FWD_CCM_CFG,			0x00706c),
> -	REG(ANA_PORT_PORT_CFG,				0x007070),
> -	REG(ANA_PORT_POL_CFG,				0x007074),
> -	REG(ANA_PORT_PTP_CFG,				0x007078),
> -	REG(ANA_PORT_PTP_DLY1_CFG,			0x00707c),
> -	REG(ANA_OAM_UPM_LM_CNT,				0x007c00),
> -	REG(ANA_PORT_PTP_DLY2_CFG,			0x007080),
> -	REG(ANA_PFC_PFC_CFG,				0x008800),
> -	REG(ANA_PFC_PFC_TIMER,				0x008804),
> -	REG(ANA_IPT_OAM_MEP_CFG,			0x008000),
> -	REG(ANA_IPT_IPT,				0x008004),
> -	REG(ANA_PPT_PPT,				0x008ac0),
> -	REG(ANA_FID_MAP_FID_MAP,			0x000000),
> -	REG(ANA_AGGR_CFG,				0x0090b4),
> -	REG(ANA_CPUQ_CFG,				0x0090b8),
> -	REG(ANA_CPUQ_CFG2,				0x0090bc),
> -	REG(ANA_CPUQ_8021_CFG,				0x0090c0),
> -	REG(ANA_DSCP_CFG,				0x009100),
> -	REG(ANA_DSCP_REWR_CFG,				0x009200),
> -	REG(ANA_VCAP_RNG_TYPE_CFG,			0x009240),
> -	REG(ANA_VCAP_RNG_VAL_CFG,			0x009260),
> -	REG(ANA_VRAP_CFG,				0x009280),
> -	REG(ANA_VRAP_HDR_DATA,				0x009284),
> -	REG(ANA_VRAP_HDR_MASK,				0x009288),
> -	REG(ANA_DISCARD_CFG,				0x00928c),
> -	REG(ANA_FID_CFG,				0x009290),
> -	REG(ANA_POL_PIR_CFG,				0x004000),
> -	REG(ANA_POL_CIR_CFG,				0x004004),
> -	REG(ANA_POL_MODE_CFG,				0x004008),
> -	REG(ANA_POL_PIR_STATE,				0x00400c),
> -	REG(ANA_POL_CIR_STATE,				0x004010),
> -	REG(ANA_POL_STATE,				0x004014),
> -	REG(ANA_POL_FLOWC,				0x008b80),
> -	REG(ANA_POL_HYST,				0x008bec),
> -	REG(ANA_POL_MISC_CFG,				0x008bf0),
> -};
> -
> -static const u32 ocelot_qs_regmap[] = {
> -	REG(QS_XTR_GRP_CFG,				0x000000),
> -	REG(QS_XTR_RD,					0x000008),
> -	REG(QS_XTR_FRM_PRUNING,				0x000010),
> -	REG(QS_XTR_FLUSH,				0x000018),
> -	REG(QS_XTR_DATA_PRESENT,			0x00001c),
> -	REG(QS_XTR_CFG,					0x000020),
> -	REG(QS_INJ_GRP_CFG,				0x000024),
> -	REG(QS_INJ_WR,					0x00002c),
> -	REG(QS_INJ_CTRL,				0x000034),
> -	REG(QS_INJ_STATUS,				0x00003c),
> -	REG(QS_INJ_ERR,					0x000040),
> -	REG(QS_INH_DBG,					0x000048),
> -};
> -
> -static const u32 ocelot_qsys_regmap[] = {
> -	REG(QSYS_PORT_MODE,				0x011200),
> -	REG(QSYS_SWITCH_PORT_MODE,			0x011234),
> -	REG(QSYS_STAT_CNT_CFG,				0x011264),
> -	REG(QSYS_EEE_CFG,				0x011268),
> -	REG(QSYS_EEE_THRES,				0x011294),
> -	REG(QSYS_IGR_NO_SHARING,			0x011298),
> -	REG(QSYS_EGR_NO_SHARING,			0x01129c),
> -	REG(QSYS_SW_STATUS,				0x0112a0),
> -	REG(QSYS_EXT_CPU_CFG,				0x0112d0),
> -	REG(QSYS_PAD_CFG,				0x0112d4),
> -	REG(QSYS_CPU_GROUP_MAP,				0x0112d8),
> -	REG(QSYS_QMAP,					0x0112dc),
> -	REG(QSYS_ISDX_SGRP,				0x011400),
> -	REG(QSYS_TIMED_FRAME_ENTRY,			0x014000),
> -	REG(QSYS_TFRM_MISC,				0x011310),
> -	REG(QSYS_TFRM_PORT_DLY,				0x011314),
> -	REG(QSYS_TFRM_TIMER_CFG_1,			0x011318),
> -	REG(QSYS_TFRM_TIMER_CFG_2,			0x01131c),
> -	REG(QSYS_TFRM_TIMER_CFG_3,			0x011320),
> -	REG(QSYS_TFRM_TIMER_CFG_4,			0x011324),
> -	REG(QSYS_TFRM_TIMER_CFG_5,			0x011328),
> -	REG(QSYS_TFRM_TIMER_CFG_6,			0x01132c),
> -	REG(QSYS_TFRM_TIMER_CFG_7,			0x011330),
> -	REG(QSYS_TFRM_TIMER_CFG_8,			0x011334),
> -	REG(QSYS_RED_PROFILE,				0x011338),
> -	REG(QSYS_RES_QOS_MODE,				0x011378),
> -	REG(QSYS_RES_CFG,				0x012000),
> -	REG(QSYS_RES_STAT,				0x012004),
> -	REG(QSYS_EGR_DROP_MODE,				0x01137c),
> -	REG(QSYS_EQ_CTRL,				0x011380),
> -	REG(QSYS_EVENTS_CORE,				0x011384),
> -	REG(QSYS_CIR_CFG,				0x000000),
> -	REG(QSYS_EIR_CFG,				0x000004),
> -	REG(QSYS_SE_CFG,				0x000008),
> -	REG(QSYS_SE_DWRR_CFG,				0x00000c),
> -	REG(QSYS_SE_CONNECT,				0x00003c),
> -	REG(QSYS_SE_DLB_SENSE,				0x000040),
> -	REG(QSYS_CIR_STATE,				0x000044),
> -	REG(QSYS_EIR_STATE,				0x000048),
> -	REG(QSYS_SE_STATE,				0x00004c),
> -	REG(QSYS_HSCH_MISC_CFG,				0x011388),
> -};
> -
> -static const u32 ocelot_rew_regmap[] = {
> -	REG(REW_PORT_VLAN_CFG,				0x000000),
> -	REG(REW_TAG_CFG,				0x000004),
> -	REG(REW_PORT_CFG,				0x000008),
> -	REG(REW_DSCP_CFG,				0x00000c),
> -	REG(REW_PCP_DEI_QOS_MAP_CFG,			0x000010),
> -	REG(REW_PTP_CFG,				0x000050),
> -	REG(REW_PTP_DLY1_CFG,				0x000054),
> -	REG(REW_DSCP_REMAP_DP1_CFG,			0x000690),
> -	REG(REW_DSCP_REMAP_CFG,				0x000790),
> -	REG(REW_STAT_CFG,				0x000890),
> -	REG(REW_PPT,					0x000680),
> -};
> -
> -static const u32 ocelot_sys_regmap[] = {
> -	REG(SYS_COUNT_RX_OCTETS,			0x000000),
> -	REG(SYS_COUNT_RX_UNICAST,			0x000004),
> -	REG(SYS_COUNT_RX_MULTICAST,			0x000008),
> -	REG(SYS_COUNT_RX_BROADCAST,			0x00000c),
> -	REG(SYS_COUNT_RX_SHORTS,			0x000010),
> -	REG(SYS_COUNT_RX_FRAGMENTS,			0x000014),
> -	REG(SYS_COUNT_RX_JABBERS,			0x000018),
> -	REG(SYS_COUNT_RX_CRC_ALIGN_ERRS,		0x00001c),
> -	REG(SYS_COUNT_RX_SYM_ERRS,			0x000020),
> -	REG(SYS_COUNT_RX_64,				0x000024),
> -	REG(SYS_COUNT_RX_65_127,			0x000028),
> -	REG(SYS_COUNT_RX_128_255,			0x00002c),
> -	REG(SYS_COUNT_RX_256_1023,			0x000030),
> -	REG(SYS_COUNT_RX_1024_1526,			0x000034),
> -	REG(SYS_COUNT_RX_1527_MAX,			0x000038),
> -	REG(SYS_COUNT_RX_PAUSE,				0x00003c),
> -	REG(SYS_COUNT_RX_CONTROL,			0x000040),
> -	REG(SYS_COUNT_RX_LONGS,				0x000044),
> -	REG(SYS_COUNT_RX_CLASSIFIED_DROPS,		0x000048),
> -	REG(SYS_COUNT_TX_OCTETS,			0x000100),
> -	REG(SYS_COUNT_TX_UNICAST,			0x000104),
> -	REG(SYS_COUNT_TX_MULTICAST,			0x000108),
> -	REG(SYS_COUNT_TX_BROADCAST,			0x00010c),
> -	REG(SYS_COUNT_TX_COLLISION,			0x000110),
> -	REG(SYS_COUNT_TX_DROPS,				0x000114),
> -	REG(SYS_COUNT_TX_PAUSE,				0x000118),
> -	REG(SYS_COUNT_TX_64,				0x00011c),
> -	REG(SYS_COUNT_TX_65_127,			0x000120),
> -	REG(SYS_COUNT_TX_128_511,			0x000124),
> -	REG(SYS_COUNT_TX_512_1023,			0x000128),
> -	REG(SYS_COUNT_TX_1024_1526,			0x00012c),
> -	REG(SYS_COUNT_TX_1527_MAX,			0x000130),
> -	REG(SYS_COUNT_TX_AGING,				0x000170),
> -	REG(SYS_RESET_CFG,				0x000508),
> -	REG(SYS_CMID,					0x00050c),
> -	REG(SYS_VLAN_ETYPE_CFG,				0x000510),
> -	REG(SYS_PORT_MODE,				0x000514),
> -	REG(SYS_FRONT_PORT_MODE,			0x000548),
> -	REG(SYS_FRM_AGING,				0x000574),
> -	REG(SYS_STAT_CFG,				0x000578),
> -	REG(SYS_SW_STATUS,				0x00057c),
> -	REG(SYS_MISC_CFG,				0x0005ac),
> -	REG(SYS_REW_MAC_HIGH_CFG,			0x0005b0),
> -	REG(SYS_REW_MAC_LOW_CFG,			0x0005dc),
> -	REG(SYS_CM_ADDR,				0x000500),
> -	REG(SYS_CM_DATA,				0x000504),
> -	REG(SYS_PAUSE_CFG,				0x000608),
> -	REG(SYS_PAUSE_TOT_CFG,				0x000638),
> -	REG(SYS_ATOP,					0x00063c),
> -	REG(SYS_ATOP_TOT_CFG,				0x00066c),
> -	REG(SYS_MAC_FC_CFG,				0x000670),
> -	REG(SYS_MMGT,					0x00069c),
> -	REG(SYS_MMGT_FAST,				0x0006a0),
> -	REG(SYS_EVENTS_DIF,				0x0006a4),
> -	REG(SYS_EVENTS_CORE,				0x0006b4),
> -	REG(SYS_CNT,					0x000000),
> -	REG(SYS_PTP_STATUS,				0x0006b8),
> -	REG(SYS_PTP_TXSTAMP,				0x0006bc),
> -	REG(SYS_PTP_NXT,				0x0006c0),
> -	REG(SYS_PTP_CFG,				0x0006c4),
> -};
> -
> -static const u32 ocelot_vcap_regmap[] = {
> -	/* VCAP_CORE_CFG */
> -	REG(VCAP_CORE_UPDATE_CTRL,			0x000000),
> -	REG(VCAP_CORE_MV_CFG,				0x000004),
> -	/* VCAP_CORE_CACHE */
> -	REG(VCAP_CACHE_ENTRY_DAT,			0x000008),
> -	REG(VCAP_CACHE_MASK_DAT,			0x000108),
> -	REG(VCAP_CACHE_ACTION_DAT,			0x000208),
> -	REG(VCAP_CACHE_CNT_DAT,				0x000308),
> -	REG(VCAP_CACHE_TG_DAT,				0x000388),
> -	/* VCAP_CONST */
> -	REG(VCAP_CONST_VCAP_VER,			0x000398),
> -	REG(VCAP_CONST_ENTRY_WIDTH,			0x00039c),
> -	REG(VCAP_CONST_ENTRY_CNT,			0x0003a0),
> -	REG(VCAP_CONST_ENTRY_SWCNT,			0x0003a4),
> -	REG(VCAP_CONST_ENTRY_TG_WIDTH,			0x0003a8),
> -	REG(VCAP_CONST_ACTION_DEF_CNT,			0x0003ac),
> -	REG(VCAP_CONST_ACTION_WIDTH,			0x0003b0),
> -	REG(VCAP_CONST_CNT_WIDTH,			0x0003b4),
> -	REG(VCAP_CONST_CORE_CNT,			0x0003b8),
> -	REG(VCAP_CONST_IF_CNT,				0x0003bc),
> -};
> -
> -static const u32 ocelot_ptp_regmap[] = {
> -	REG(PTP_PIN_CFG,				0x000000),
> -	REG(PTP_PIN_TOD_SEC_MSB,			0x000004),
> -	REG(PTP_PIN_TOD_SEC_LSB,			0x000008),
> -	REG(PTP_PIN_TOD_NSEC,				0x00000c),
> -	REG(PTP_PIN_WF_HIGH_PERIOD,			0x000014),
> -	REG(PTP_PIN_WF_LOW_PERIOD,			0x000018),
> -	REG(PTP_CFG_MISC,				0x0000a0),
> -	REG(PTP_CLK_CFG_ADJ_CFG,			0x0000a4),
> -	REG(PTP_CLK_CFG_ADJ_FREQ,			0x0000a8),
> -};
> -
> -static const u32 ocelot_dev_gmii_regmap[] = {
> -	REG(DEV_CLOCK_CFG,				0x0),
> -	REG(DEV_PORT_MISC,				0x4),
> -	REG(DEV_EVENTS,					0x8),
> -	REG(DEV_EEE_CFG,				0xc),
> -	REG(DEV_RX_PATH_DELAY,				0x10),
> -	REG(DEV_TX_PATH_DELAY,				0x14),
> -	REG(DEV_PTP_PREDICT_CFG,			0x18),
> -	REG(DEV_MAC_ENA_CFG,				0x1c),
> -	REG(DEV_MAC_MODE_CFG,				0x20),
> -	REG(DEV_MAC_MAXLEN_CFG,				0x24),
> -	REG(DEV_MAC_TAGS_CFG,				0x28),
> -	REG(DEV_MAC_ADV_CHK_CFG,			0x2c),
> -	REG(DEV_MAC_IFG_CFG,				0x30),
> -	REG(DEV_MAC_HDX_CFG,				0x34),
> -	REG(DEV_MAC_DBG_CFG,				0x38),
> -	REG(DEV_MAC_FC_MAC_LOW_CFG,			0x3c),
> -	REG(DEV_MAC_FC_MAC_HIGH_CFG,			0x40),
> -	REG(DEV_MAC_STICKY,				0x44),
> -	REG(PCS1G_CFG,					0x48),
> -	REG(PCS1G_MODE_CFG,				0x4c),
> -	REG(PCS1G_SD_CFG,				0x50),
> -	REG(PCS1G_ANEG_CFG,				0x54),
> -	REG(PCS1G_ANEG_NP_CFG,				0x58),
> -	REG(PCS1G_LB_CFG,				0x5c),
> -	REG(PCS1G_DBG_CFG,				0x60),
> -	REG(PCS1G_CDET_CFG,				0x64),
> -	REG(PCS1G_ANEG_STATUS,				0x68),
> -	REG(PCS1G_ANEG_NP_STATUS,			0x6c),
> -	REG(PCS1G_LINK_STATUS,				0x70),
> -	REG(PCS1G_LINK_DOWN_CNT,			0x74),
> -	REG(PCS1G_STICKY,				0x78),
> -	REG(PCS1G_DEBUG_STATUS,				0x7c),
> -	REG(PCS1G_LPI_CFG,				0x80),
> -	REG(PCS1G_LPI_WAKE_ERROR_CNT,			0x84),
> -	REG(PCS1G_LPI_STATUS,				0x88),
> -	REG(PCS1G_TSTPAT_MODE_CFG,			0x8c),
> -	REG(PCS1G_TSTPAT_STATUS,			0x90),
> -	REG(DEV_PCS_FX100_CFG,				0x94),
> -	REG(DEV_PCS_FX100_STATUS,			0x98),
> -};
> -
>  static const u32 *ocelot_regmap[TARGET_MAX] = {
>  	[ANA] = ocelot_ana_regmap,
>  	[QS] = ocelot_qs_regmap,
> diff --git a/include/soc/mscc/ocelot_regs.h b/include/soc/mscc/ocelot_regs.h
> new file mode 100644
> index 000000000000..d4508eb9e04a
> --- /dev/null
> +++ b/include/soc/mscc/ocelot_regs.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> +/*
> + * Microsemi Ocelot Switch driver
> + *
> + * Copyright (c) 2021 Innovative Advantage Inc.
> + */
> +
> +#ifndef OCELOT_REGS_H
> +#define OCELOT_REGS_H
> +
> +extern const u32 ocelot_ana_regmap[];
> +extern const u32 ocelot_qs_regmap[];
> +extern const u32 ocelot_qsys_regmap[];
> +extern const u32 ocelot_rew_regmap[];
> +extern const u32 ocelot_sys_regmap[];
> +extern const u32 ocelot_vcap_regmap[];
> +extern const u32 ocelot_ptp_regmap[];
> +extern const u32 ocelot_dev_gmii_regmap[];
> +
> +#endif
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
