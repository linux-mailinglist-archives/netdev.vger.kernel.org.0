Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68F63617853
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiKCIGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiKCIGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:06:03 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2533642A;
        Thu,  3 Nov 2022 01:06:00 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667462759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KXDPv2/ZwRaQ02PvgLOVXufHCivJRziSuAAjiAwQMy8=;
        b=Cl019427bsLnW5Of0TRHVTVd4jds9NwHttYU0ZlhSd+p3iDGYPOOrBv2ZlQl7agf64jehm
        A5UUnWXGAFWqw84g56bDWObPbLyo+sJoE3BRFdSPgcRgtHWw4xEb5nK8IYHy3YetDPPAjS
        lmwtU4XfvO20CNSwmMtKyTAFwHHhTs8=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     kuba@kernel.org
Cc:     Cai Huoqing <cai.huoqing@linux.dev>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Qiao Ma <mqaio@linux.alibaba.com>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v4 2/3] net: hinic: Add control command support for VF PMD driver in DPDK
Date:   Thu,  3 Nov 2022 16:05:10 +0800
Message-Id: <20221103080525.26885-2-cai.huoqing@linux.dev>
In-Reply-To: <20221103080525.26885-1-cai.huoqing@linux.dev>
References: <20221103080525.26885-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,UPPERCASE_50_75 autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HINIC has a mailbox for PF-VF communication and the VF driver
could send port control command to PF driver via mailbox.

The control command only can be set to register in PF,
so add support in PF driver for VF PMD driver control
command when VF PMD driver work with linux PF driver.

Then, no need to add handlers to nic_vf_cmd_msg_handler[],
because the host driver just forwards it to the firmware.
Actually the firmware works on a coprocessor MGMT_CPU(inside the NIC)
which will recv and deal with these commands.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
v1->v2:
	1.Update the commit messsage.
	2.Add net-next prefix.
	The comments link: https://lore.kernel.org/lkml/20221031195805.74e22089@kernel.org/
v2->v3:
	1.Merge PATCH 3/3 to this series.

 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  | 66 +++++++++++++++++++
 .../net/ethernet/huawei/hinic/hinic_sriov.c   | 18 +++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 6dae116a11f8..6b5797e69781 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -51,6 +51,9 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_ADD_VLAN = 0x3,
 	HINIC_PORT_CMD_DEL_VLAN = 0x4,
 
+	HINIC_PORT_CMD_SET_ETS = 0x7,
+	HINIC_PORT_CMD_GET_ETS = 0x8,
+
 	HINIC_PORT_CMD_SET_PFC = 0x5,
 
 	HINIC_PORT_CMD_SET_MAC = 0x9,
@@ -59,6 +62,8 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RX_MODE = 0xC,
 
+	HINIC_PORT_CMD_SET_ANTI_ATTACK_RATE = 0xD,
+
 	HINIC_PORT_CMD_GET_PAUSE_INFO = 0x14,
 	HINIC_PORT_CMD_SET_PAUSE_INFO = 0x15,
 
@@ -81,6 +86,7 @@ enum hinic_port_cmd {
 	HINIC_PORT_CMD_GET_RSS_TEMPLATE_INDIR_TBL = 0x25,
 
 	HINIC_PORT_CMD_SET_PORT_STATE = 0x29,
+	HINIC_PORT_CMD_GET_PORT_STATE = 0x30,
 
 	HINIC_PORT_CMD_SET_RSS_TEMPLATE_TBL = 0x2B,
 
@@ -100,17 +106,29 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_RSS_CFG = 0x42,
 
+	HINIC_PORT_CMD_GET_PHY_TYPE = 0x44,
+
 	HINIC_PORT_CMD_FWCTXT_INIT = 0x45,
 
 	HINIC_PORT_CMD_GET_LOOPBACK_MODE = 0x48,
 	HINIC_PORT_CMD_SET_LOOPBACK_MODE = 0x49,
 
+	HINIC_PORT_CMD_GET_JUMBO_FRAME_SIZE = 0x4A,
+	HINIC_PORT_CMD_SET_JUMBO_FRAME_SIZE = 0x4B,
+
 	HINIC_PORT_CMD_ENABLE_SPOOFCHK = 0x4E,
 
 	HINIC_PORT_CMD_GET_MGMT_VERSION = 0x58,
 
+	HINIC_PORT_CMD_GET_PORT_TYPE = 0x5B,
+
 	HINIC_PORT_CMD_SET_FUNC_STATE = 0x5D,
 
+	HINIC_PORT_CMD_GET_PORT_ID_BY_FUNC_ID = 0x5E,
+
+	HINIC_PORT_CMD_GET_DMA_CS = 0x64,
+	HINIC_PORT_CMD_SET_DMA_CS = 0x65,
+
 	HINIC_PORT_CMD_GET_GLOBAL_QPN = 0x66,
 
 	HINIC_PORT_CMD_SET_VF_RATE = 0x69,
@@ -125,25 +143,73 @@ enum hinic_port_cmd {
 
 	HINIC_PORT_CMD_SET_RQ_IQ_MAP = 0x73,
 
+	HINIC_PORT_CMD_SET_PFC_THD = 0x75,
+
 	HINIC_PORT_CMD_LINK_STATUS_REPORT = 0xA0,
 
+	HINIC_PORT_CMD_SET_LOSSLESS_ETH	= 0xA3,
+
 	HINIC_PORT_CMD_UPDATE_MAC = 0xA4,
 
 	HINIC_PORT_CMD_GET_CAP = 0xAA,
 
+	HINIC_PORT_CMD_UP_TC_ADD_FLOW = 0xAF,
+	HINIC_PORT_CMD_UP_TC_DEL_FLOW = 0xB0,
+	HINIC_PORT_CMD_UP_TC_GET_FLOW = 0xB1,
+
+	HINIC_PORT_CMD_UP_TC_FLUSH_TCAM = 0xB2,
+
+	HINIC_PORT_CMD_UP_TC_CTRL_TCAM_BLOCK = 0xB3,
+
+	HINIC_PORT_CMD_UP_TC_ENABLE = 0xB4,
+
+	HINIC_PORT_CMD_UP_TC_GET_TCAM_BLOCK = 0xB5,
+
+	HINIC_PORT_CMD_SET_IPSU_MAC = 0xCB,
+	HINIC_PORT_CMD_GET_IPSU_MAC = 0xCC,
+
+	HINIC_PORT_CMD_SET_XSFP_STATUS = 0xD4,
+
 	HINIC_PORT_CMD_GET_LINK_MODE = 0xD9,
 
 	HINIC_PORT_CMD_SET_SPEED = 0xDA,
 
 	HINIC_PORT_CMD_SET_AUTONEG = 0xDB,
 
+	HINIC_PORT_CMD_CLEAR_QP_RES = 0xDD,
+
+	HINIC_PORT_CMD_SET_SUPER_CQE = 0xDE,
+
+	HINIC_PORT_CMD_SET_VF_COS = 0xDF,
+	HINIC_PORT_CMD_GET_VF_COS = 0xE1,
+
+	HINIC_PORT_CMD_CABLE_PLUG_EVENT	= 0xE5,
+
+	HINIC_PORT_CMD_LINK_ERR_EVENT = 0xE6,
+
+	HINIC_PORT_CMD_SET_COS_UP_MAP = 0xE8,
+
+	HINIC_PORT_CMD_RESET_LINK_CFG = 0xEB,
+
 	HINIC_PORT_CMD_GET_STD_SFP_INFO = 0xF0,
 
+	HINIC_PORT_CMD_FORCE_PKT_DROP = 0xF3,
+
 	HINIC_PORT_CMD_SET_LRO_TIMER = 0xF4,
 
+	HINIC_PORT_CMD_SET_VHD_CFG = 0xF7,
+
+	HINIC_PORT_CMD_SET_LINK_FOLLOW = 0xF8,
+
 	HINIC_PORT_CMD_SET_VF_MAX_MIN_RATE = 0xF9,
 
 	HINIC_PORT_CMD_GET_SFP_ABS = 0xFB,
+
+	HINIC_PORT_CMD_Q_FILTER	= 0xFC,
+
+	HINIC_PORT_CMD_TCAM_FILTER = 0xFE,
+
+	HINIC_PORT_CMD_SET_VLAN_FILTER = 0xFF,
 };
 
 /* cmd of mgmt CPU message for HILINK module */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index f7e05b41385b..ee357088d021 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -489,6 +489,24 @@ static struct vf_cmd_check_handle nic_cmd_support_vf[] = {
 	{HINIC_PORT_CMD_UPDATE_MAC, hinic_mbox_check_func_id_8B},
 	{HINIC_PORT_CMD_GET_CAP, hinic_mbox_check_func_id_8B},
 	{HINIC_PORT_CMD_GET_LINK_MODE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_GET_VF_COS, NULL},
+	{HINIC_PORT_CMD_SET_VHD_CFG, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_VLAN_FILTER, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_Q_FILTER, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_TCAM_FILTER, NULL},
+	{HINIC_PORT_CMD_UP_TC_ADD_FLOW, NULL},
+	{HINIC_PORT_CMD_UP_TC_DEL_FLOW, NULL},
+	{HINIC_PORT_CMD_UP_TC_FLUSH_TCAM, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_UP_TC_CTRL_TCAM_BLOCK, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_UP_TC_ENABLE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_CABLE_PLUG_EVENT, NULL},
+	{HINIC_PORT_CMD_LINK_ERR_EVENT, NULL},
+	{HINIC_PORT_CMD_SET_PORT_STATE, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_ETS, NULL},
+	{HINIC_PORT_CMD_SET_ANTI_ATTACK_RATE, NULL},
+	{HINIC_PORT_CMD_RESET_LINK_CFG, hinic_mbox_check_func_id_8B},
+	{HINIC_PORT_CMD_SET_LINK_FOLLOW, NULL},
+	{HINIC_PORT_CMD_CLEAR_QP_RES, NULL},
 };
 
 #define CHECK_IPSU_15BIT	0X8000
-- 
2.25.1

