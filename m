Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABC7B61072B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 03:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiJ1BVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 21:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiJ1BVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 21:21:14 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C612B27A;
        Thu, 27 Oct 2022 18:21:12 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mz4PV6TrPzmVcv;
        Fri, 28 Oct 2022 09:16:14 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 09:21:09 +0800
Message-ID: <491aea68-bee6-3bd5-903d-1071b6c1cb73@huawei.com>
Date:   Fri, 28 Oct 2022 09:21:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
To:     Cai Huoqing <cai.huoqing@linux.dev>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bin Chen <bin.chen@corigine.com>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
 <20221026125922.34080-2-cai.huoqing@linux.dev>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221026125922.34080-2-cai.huoqing@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/26 20:59, Cai Huoqing wrote:
> HINIC has a mailbox for PF-VF communication and the VF driver
> could send port control command to PF driver via mailbox.
> 
> The control command only can be set to register in PF,
> so add support in PF driver for VF PMD driver control
> command when VF PMD driver work with linux PF driver.
> 
> Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
> ---
>   .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 64 +++++++++++++++++++
>   .../net/ethernet/huawei/hinic/hinic_sriov.c   | 18 ++++++
>   2 files changed, 82 insertions(+)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> index abffd967a791..4f561e4e849a 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
> @@ -53,11 +53,15 @@ enum hinic_port_cmd {
>   
>   	HINIC_PORT_CMD_SET_PFC = 0x5,
>   
> +	HINIC_PORT_CMD_SET_ETS = 0x7,
> +	HINIC_PORT_CMD_GET_ETS = 0x8,
> +
>   	HINIC_PORT_CMD_SET_MAC = 0x9,
>   	HINIC_PORT_CMD_GET_MAC = 0xA,
>   	HINIC_PORT_CMD_DEL_MAC = 0xB,
>   
>   	HINIC_PORT_CMD_SET_RX_MODE = 0xC,
> +	HINIC_PORT_CMD_SET_ANTI_ATTACK_RATE = 0xD,
>   
>   	HINIC_PORT_CMD_GET_PAUSE_INFO = 0x14,
>   	HINIC_PORT_CMD_SET_PAUSE_INFO = 0x15,
> @@ -81,6 +85,7 @@ enum hinic_port_cmd {
>   	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 0x25,
>   
>   	HINIC_PORT_CMD_SET_PORT_STATE = 0x29,
> +	HINIC_PORT_CMD_GET_PORT_STATE = 0x30,
>   
>   	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 0x2B,
>   	HINIC_PORT_CMD_GET_RSS_TEMPLATE_TBL = 0x2C,
> @@ -97,17 +102,29 @@ enum hinic_port_cmd {
>   
>   	HINIC_PORT_CMD_RSS_CFG = 0x42,
>   
> +	HINIC_PORT_CMD_GET_PHY_TYPE = 0x44,
> +
>   	HINIC_PORT_CMD_FWCTXT_INIT = 0x45,
>   
>   	HINIC_PORT_CMD_GET_LOOPBACK_MODE = 0x48,
>   	HINIC_PORT_CMD_SET_LOOPBACK_MODE = 0x49,
>   
> +	HINIC_PORT_CMD_GET_JUMBO_FRAME_SIZE = 0x4A,
> +	HINIC_PORT_CMD_SET_JUMBO_FRAME_SIZE = 0x4B,
> +
>   	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 0x4E,
>   
>   	HINIC_PORT_CMD_GET_MGMT_VERSION = 0x58,
>   
> +	HINIC_PORT_CMD_GET_PORT_TYPE = 0x5B,
> +
>   	HINIC_PORT_CMD_SET_FUNC_STATE = 0x5D,
>   
> +	HINIC_PORT_CMD_GET_PORT_ID_BY_FUNC_ID = 0x5E,
> +
> +	HINIC_PORT_CMD_GET_DMA_CS = 0x64,
> +	HINIC_PORT_CMD_SET_DMA_CS = 0x65,
> +
>   	HINIC_PORT_CMD_GET_GLOBAL_QPN = 0x66,
>   
>   	HINIC_PORT_CMD_SET_VF_RATE = 0x69,
> @@ -121,25 +138,72 @@ enum hinic_port_cmd {
>   
>   	HINIC_PORT_CMD_SET_RQ_IQ_MAP = 0x73,
>   
> +	HINIC_PORT_CMD_SET_PFC_THD = 0x75,
> +
>   	HINIC_PORT_CMD_LINK_STATUS_REPORT = 0xA0,
>   
> +	HINIC_PORT_CMD_SET_LOSSLESS_ETH	= 0xA3,
> +
>   	HINIC_PORT_CMD_UPDATE_MAC = 0xA4,
>   
>   	HINIC_PORT_CMD_GET_CAP = 0xAA,
>   
> +	HINIC_PORT_CMD_UP_TC_ADD_FLOW = 0xAF,
> +	HINIC_PORT_CMD_UP_TC_DEL_FLOW = 0xB0,
> +	HINIC_PORT_CMD_UP_TC_GET_FLOW = 0xB1,
> +
> +	HINIC_PORT_CMD_UP_TC_FLUSH_TCAM = 0xB2,
> +
> +	HINIC_PORT_CMD_UP_TC_CTRL_TCAM_BLOCK = 0xB3,
> +
> +	HINIC_PORT_CMD_UP_TC_ENABLE = 0xB4,
> +
> +	HINIC_PORT_CMD_UP_TC_GET_TCAM_BLOCK = 0xB5,
> +
> +	HINIC_PORT_CMD_SET_IPSU_MAC = 0xCB,
> +	HINIC_PORT_CMD_GET_IPSU_MAC = 0xCC,
> +
> +	HINIC_PORT_CMD_SET_XSFP_STATUS = 0xD4,
>   	HINIC_PORT_CMD_GET_LINK_MODE = 0xD9,
>   
>   	HINIC_PORT_CMD_SET_SPEED = 0xDA,
>   
>   	HINIC_PORT_CMD_SET_AUTONEG = 0xDB,
>   
> +	HINIC_PORT_CMD_CLEAR_QP_RES = 0xDD,
> +
> +	HINIC_PORT_CMD_SET_SUPER_CQE = 0xDE,
> +
> +	HINIC_PORT_CMD_SET_VF_COS = 0xDF,
> +	HINIC_PORT_CMD_GET_VF_COS = 0xE1,
> +
> +	HINIC_PORT_CMD_CABLE_PLUG_EVENT	= 0xE5,
> +
> +	HINIC_PORT_CMD_LINK_ERR_EVENT = 0xE6,
> +
> +	HINIC_PORT_CMD_SET_COS_UP_MAP = 0xE8,
> +
> +	HINIC_PORT_CMD_RESET_LINK_CFG = 0xEB,
> +
>   	HINIC_PORT_CMD_GET_STD_SFP_INFO = 0xF0,
>   
> +	HINIC_PORT_CMD_FORCE_PKT_DROP = 0xF3,
> +
>   	HINIC_PORT_CMD_SET_LRO_TIMER = 0xF4,
>   
> +	HINIC_PORT_CMD_SET_VHD_CFG = 0xF7,
> +
> +	HINIC_PORT_CMD_SET_LINK_FOLLOW = 0xF8,
> +
>   	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 0xF9,
>   
>   	HINIC_PORT_CMD_GET_SFP_ABS = 0xFB,
> +
> +	HINIC_PORT_CMD_Q_FILTER	= 0xFC,
> +
> +	HINIC_PORT_CMD_TCAM_FILTER = 0xFE,
> +
> +	HINIC_PORT_CMD_SET_VLAN_FILTER = 0xFF
>   };
>   
>   /* cmd of mgmt CPU message for HILINK module */
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> index a5f08b969e3f..bba41994dee6 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> @@ -489,6 +489,24 @@ static struct vf_cmd_check_handle nic_cmd_support_vf[] = {
>   	{HINIC_PORT_CMD_UPDATE_MAC, hinic_mbox_check_func_id_8B},
>   	{HINIC_PORT_CMD_GET_CAP, hinic_mbox_check_func_id_8B},
>   	{HINIC_PORT_CMD_GET_LINK_MODE, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_GET_VF_COS, NULL},
> +	{HINIC_PORT_CMD_SET_VHD_CFG, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_SET_VLAN_FILTER, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_Q_FILTER, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_TCAM_FILTER, NULL},
> +	{HINIC_PORT_CMD_UP_TC_ADD_FLOW, NULL},
> +	{HINIC_PORT_CMD_UP_TC_DEL_FLOW, NULL},
> +	{HINIC_PORT_CMD_UP_TC_FLUSH_TCAM, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_UP_TC_CTRL_TCAM_BLOCK, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_UP_TC_ENABLE, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_CABLE_PLUG_EVENT, NULL},
> +	{HINIC_PORT_CMD_LINK_ERR_EVENT, NULL},
> +	{HINIC_PORT_CMD_SET_PORT_STATE, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_SET_ETS, NULL},
> +	{HINIC_PORT_CMD_SET_ANTI_ATTACK_RATE, NULL},
> +	{HINIC_PORT_CMD_RESET_LINK_CFG, hinic_mbox_check_func_id_8B},
> +	{HINIC_PORT_CMD_SET_LINK_FOLLOW, NULL},
> +	{HINIC_PORT_CMD_CLEAR_QP_RES, NULL},
>   };
>   
>   #define CHECK_IPSU_15BIT	0X8000
Hi Cai:
	I guess how do you get the opcodes of these commands? Have they
all been tested? Is the test result consistent with the driver released
on the Huawei support website?

Zhengchao Shao
