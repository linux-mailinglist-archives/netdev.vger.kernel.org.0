Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A8A501C70
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiDNUQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiDNUQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:16:14 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130111.outbound.protection.outlook.com [40.107.13.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B176E886D;
        Thu, 14 Apr 2022 13:13:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNTqw8rf7IeF+VpKb2wY+tfU10eh/BYCXyEgNBo3N/P23NUp27PokfJdFu5CBKQj55ugYTKd7JubCo+UovKSkv/B1LcGep4D6OPXKaslk+X06aawevulba953jpWrotflY1OESKdvh8NgkJWd0HxFFXgQzUTrrBHsg4cTiSz9SlFMC6L1jUonuFWpEJ7KOGXfrJPLeofDI6DlLzbOOYd0raFEfnVb5gfqTIS1k+r9FUFeVEL5DRDlCQuXZFdMazi1Cj/wfxa0X7bIepQCap2Zcm3Ys2pFCCuZbP+EPZ3nE+o8SX5ivTVwDYs3FKXUEcU9P80aplbDtS7yzFNDD7IAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyGDLMupMgVfKsis6OZOueOFEV3Twd99DpJYLCdcO6o=;
 b=WGj+K60Z3m3LHHyEP8pfCxcoBHOb/idGZa7yuRrZSaesECoAjbyqz82PymU9CWC28otSN8pktK2A44gKKSfS53skxS3NRA39wqjlYlYAHUrrwcRTuFzt2l8FJjuL4v8BlvpLpkoY8rqkBzoqaWdUCfQInswKsZ3hRg1BLbuFZXwFW4jVC93lAKmsjPqsFuOo7dXnwQ5YjENfRzMbdxtRNBsOMLokaxldOpC2t68hTlraJhjakzErYLJWqsSyspgE/LKX55TXWNqG9v9bsqbd0YGmt0mXrpcUZ4uC4O3F/hDxukHszwPA1ahgMU2tuOVnniaLfzaVFk6anNt6p0L7lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyGDLMupMgVfKsis6OZOueOFEV3Twd99DpJYLCdcO6o=;
 b=uthvjuzKFVsqkua/DCFIaqoGQbKSCU712zvCY8wRZ0l+IuAYJD/TsHsbLe9EGKB6T1N9XgNVNRZNKkp7gJsourjzlmzwQ6zw9EhhzAQrWt2FfRxIHXUBVPCGYjd9KG5OxKoVGeGSgy+2NbK27VcblmtpV3lR13b7jZhU6Qtcms8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 20:13:44 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::5dd5:47e1:1cef:cc4e]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::5dd5:47e1:1cef:cc4e%6]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 20:13:43 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] ixgbe: Treat 1G Cu SFPs as 1G SX for X550EM
Date:   Thu, 14 Apr 2022 16:13:29 -0400
Message-Id: <20220414201329.27714-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414172020.22396-1-jeffd@silicom-usa.com>
References: <20220414172020.22396-1-jeffd@silicom-usa.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:208:178::44) To VI1PR0402MB3517.eurprd04.prod.outlook.com
 (2603:10a6:803:b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 841b780d-2cf5-45b5-ea53-08da1e534625
X-MS-TrafficTypeDiagnostic: DB7PR04MB5227:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5227065FA424CAE83ABDCB79EAEF9@DB7PR04MB5227.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eASFcoOKXBUGGUt4mnmiDf53kh2bA6QiFszg1nK78iZ3ME17B45dKgrcLAgFHJjZDOoaOXTadKa/6ao4zq9g0Yfo4esGjkR7UAm2+bsKtkzaigDNNWo5f2jLhScPC3Igrp2gUElR3ZRa5OqfAukc4ugy2zQq63vqTqGop35p8B4hbqlvOXCwMEOqjoJBPFmHkiNp0gx0JXfo6Uxn8W79D7us0BOQIMSyaFCkLNi9WzWsjMwZ4K+V3quSOYwid6N8xwPFm0OQ3Fz/igwcybOBm3uIB6kWbBrooQ4YxCfybmqeJjxlcoYMixFLGFa7OGK7kGQWA2v6fxPJ2prq1hK2AiFMf2OUT1cY9XZFPsOJ5JuhUUG0BxgwDUOiqDLWXVNJq90X9aQ8hKJHx2lzqsQyPYA/Zv8L6SOGux6ef2nclm/ieIYYHrGTMgJI4uKo4tFL4ldHVVcFB7wzYehcKxBMkjb5XmajXQlUgj/aq+lzCRf1WS4aB80/r8VfY0i/Ow4b2l/iH66vyLP11gUcFx5Q+iaxs7DNK4ZxSC0BFQTFG8k1LwQ75FcuqIbn1CO7wPZil3PZSNo+Cse8KtngbLsFNcKbRWDpLF2Mf4kwjIzfwNFmSBZyXDvjiJiWf+Kb1YvApKu8pXuvi8Iw9Jl0yK5MpjCR/CfM25QquyqEPj7Rk0Wb+ToVXW/YoYa4uzoVaOO81szCtUk2CONIrEP9uHBKDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(6666004)(54906003)(6506007)(316002)(83380400001)(6512007)(2906002)(6486002)(36756003)(52116002)(508600001)(1076003)(26005)(186003)(66946007)(66476007)(66556008)(8676002)(2616005)(86362001)(8936002)(38350700002)(38100700002)(5660300002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?40CTr4c3Ywt29RC5XaDuyypsPGAzbeyKGuDTbZT2nUM0SKVj3dqYiisoAYhu?=
 =?us-ascii?Q?E+Gqq5oiAOASbGPw5gZ9NjqT2AlGAOsN2Tr/84mDFlgZ6C/sXj1RzB/m7uvf?=
 =?us-ascii?Q?6SkJCSmfwFnVYBUMV+GbvTL5xQJfnRCwMTGf4VZMTvupbiqQAOP1J4sll7Nn?=
 =?us-ascii?Q?isUFAgkmel3WZqOTCsz3iU7L782EWhyVrGCOzCII+V1la3Wlg7MfonHN3HjH?=
 =?us-ascii?Q?nSBiID3jWhURBGLDP/70mGSesgcneg8FfhtU2wCif5oi8mXW/PYL3yJ+0klO?=
 =?us-ascii?Q?W95sYDUxiLoUybX9zrWJH3maXXmQar6NglqzEW0XJmDEmp40oWTuUO7G6/Ou?=
 =?us-ascii?Q?wUJCJmv+cATgVAHeiOIS616UYc6jNorVyfgRVdhOqDMnRCtSb0VKwx8z8U6N?=
 =?us-ascii?Q?tZGka2ZyJIGmGAx8hLC53TAY7ZrkT3gMyIR7Qo/PXE2qt7Lyp0YrXx850jqP?=
 =?us-ascii?Q?ByfKuavCdcbTjFjTaf5/jYHCaa2SNCFJ5lZ5cjyA4ES1bnO26U5dNeFR3sEg?=
 =?us-ascii?Q?vDU/hJwP1TMLk/TuOUAbIIkBF0DnhOEeF+XiEew+8xoRboGgTox86qhR3q4f?=
 =?us-ascii?Q?y5LvXbdyYEVq9VXzLSHxM/1cqE/ao1U7ERhoiH6H/+IGLnv5zEJVmk5ordWP?=
 =?us-ascii?Q?DU3wSpPzI8roCx23AwKoXICzpocgqP4mcoQ4T43GRps6sdZBHkVnh0fO1hD/?=
 =?us-ascii?Q?KGSdvG2Q9ScsPFEXgyRIyN57xSTI1aQqAhFIRDO+vuIs5O1eo8SdHWXIgf5h?=
 =?us-ascii?Q?NwF4LBZmwrI/Lc332TFjem83miUiOBY5yrOvWkX9jmnh2JCK9puLPDprQrUQ?=
 =?us-ascii?Q?TW7B5d6sDXlL5vVhXlDGtzRzzsOf+N5oMlAh+0S+54x3KpFVSbN3Hpq/egaL?=
 =?us-ascii?Q?tTD5KI/I9ERCZA7seJNZma3XLxU65q1tTW7xKnGrewn4cq77de9Xne+L4u2f?=
 =?us-ascii?Q?hUaSgmWXhrvDHtofLLvR0inA50rE1YBG8FvgTzS+PU23tcLBVsXSkr3sRB0w?=
 =?us-ascii?Q?WKNmCAa/2AveZW+Hfxr+awyJJ/2dQlzU7VBlFoaZeorF1Ovj5mhg5Tqz1hjp?=
 =?us-ascii?Q?oyPIqeae0rqx3DSwVBlYJWkqQeZUZ8rZtUTukl5T4YT/87zgeqJb4XPiTSmK?=
 =?us-ascii?Q?okWGFxaJBkqnhlwwfpw2nZK36c4D3HgXp+022vl77M8Y8irH4kF9bGgV0Rsz?=
 =?us-ascii?Q?R3L1oJbGsRyyfmp58fG0L7dyV4X16noxfXNJt31u24EVcr2TOcflUaF/2B6T?=
 =?us-ascii?Q?ufQyRO7qldWKbeMg+nORKD7AEMqbySM+Md74FFIdhXqYH8UH5IJ1dh1xPGiY?=
 =?us-ascii?Q?W4/6rI6Ipd4OE+QwfX1DPqxFf24h8Cr/NZHiUF5SLqLtWLqpE3JXdZxejhO5?=
 =?us-ascii?Q?dPpl41l3HKRnsKwEEx22dqdPmC79/XFHuq7RGTAM7kebHJt/dy8DENODHT36?=
 =?us-ascii?Q?8qFGA3KVyq8jaXm1wXEYHl6ZBDhh5J002bK1ofoaFUuKJWQaALqh1rFlD6uI?=
 =?us-ascii?Q?H2BUVyWos86AJzwv2DPXHEj4wE1icWtPcJIPaSSX6AtQnmGmFmxarNnUTWtx?=
 =?us-ascii?Q?WIorr9uQxVDoLbguBO9IbdcpNL4dJsNFHucj6tZnjaPS1Amzj6QjRd48N2m8?=
 =?us-ascii?Q?R//ub1A2QWnmaTuqPjtw2R1NrzmU6xLciZNkrn1irYARAksfFMEpqaPQrTaC?=
 =?us-ascii?Q?Fh13VgzzqVTa25EbCexeT3rNLWtjD0gGNGKGNwvHZNPz6vgn+1W+aOqOruj3?=
 =?us-ascii?Q?4+piOH5+0w=3D=3D?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841b780d-2cf5-45b5-ea53-08da1e534625
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 20:13:43.6230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1XpB5J7rInTAR/SFnAsCIft2nUWM2RO8CInumNcZkVOHNL0QxGJ3Ur1gG3fT6w1kLO2e/vazqx+DdEuRIlJXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

X550EM NICs do not support 1G Cu SFPs by default from Intel, this patch
enables treating these SFPs as 1G SX SFPs via a module parameter similar to
the parameter that allows the driver to be able to recognize unsupported
(by Intel) SFPs.

Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>

---

v2:
* Make module_param option a boolean, fix commit message.
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  8 ++++++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 16 +++++++++++++++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..b02345b82cae 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -156,6 +156,11 @@ module_param(allow_unsupported_sfp, uint, 0);
 MODULE_PARM_DESC(allow_unsupported_sfp,
 		 "Allow unsupported and untested SFP+ modules on 82599-based adapters");
 
+static bool cu_sfp_as_sx;
+module_param(cu_sfp_as_sx, bool, 0);
+MODULE_PARM_DESC(cu_sfp_as_sx,
+		 "Allow treating 1G Cu SFP modules as 1G SX modules on X550-based adapters");
+
 #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV|NETIF_MSG_PROBE|NETIF_MSG_LINK)
 static int debug = -1;
 module_param(debug, int, 0);
@@ -10814,6 +10819,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (allow_unsupported_sfp)
 		hw->allow_unsupported_sfp = allow_unsupported_sfp;
 
+	if (cu_sfp_as_sx)
+		hw->cu_sfp_as_sx = cu_sfp_as_sx;
+
 	/* reset_hw fills in the perm_addr as well */
 	hw->phy.reset_if_overtemp = true;
 	err = hw->mac.ops.reset_hw(hw);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 6da9880d766a..0ffe09c0d5a8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3645,6 +3645,7 @@ struct ixgbe_hw {
 	bool				allow_unsupported_sfp;
 	bool				wol_enabled;
 	bool				need_crosstalk_fix;
+	bool				cu_sfp_as_sx;
 };
 
 struct ixgbe_info {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index e4b50c7781ff..aa12d589c39b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1609,6 +1609,8 @@ static s32 ixgbe_setup_ixfi_x550em(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
  */
 static s32 ixgbe_supported_sfp_modules_X550em(struct ixgbe_hw *hw, bool *linear)
 {
+	struct ixgbe_adapter *adapter = hw->back;
+
 	switch (hw->phy.sfp_type) {
 	case ixgbe_sfp_type_not_present:
 		return IXGBE_ERR_SFP_NOT_PRESENT;
@@ -1626,9 +1628,21 @@ static s32 ixgbe_supported_sfp_modules_X550em(struct ixgbe_hw *hw, bool *linear)
 	case ixgbe_sfp_type_1g_lx_core1:
 		*linear = false;
 		break;
-	case ixgbe_sfp_type_unknown:
 	case ixgbe_sfp_type_1g_cu_core0:
+		if (hw->cu_sfp_as_sx) {
+			e_warn(drv, "WARNING: Treating Cu SFP modules as SX modules is unsupported by Intel and may cause unstable operation or damage to the module or the adapter.  Intel Corporation is not responsible for any harm caused by using Cu modules in this way with this adapter.\n");
+			*linear = false;
+			hw->phy.sfp_type = ixgbe_sfp_type_1g_sx_core0;
+			break;
+		}
 	case ixgbe_sfp_type_1g_cu_core1:
+		if (hw->cu_sfp_as_sx) {
+			e_warn(drv, "WARNING: Treating Cu SFP modules as SX modules is unsupported by Intel and may cause unstable operation or damage to the module or the adapter.  Intel Corporation is not responsible for any harm caused by using Cu modules in this way with this adapter.\n");
+			*linear = false;
+			hw->phy.sfp_type = ixgbe_sfp_type_1g_sx_core1;
+			break;
+		}
+	case ixgbe_sfp_type_unknown:
 	default:
 		return IXGBE_ERR_SFP_NOT_SUPPORTED;
 	}
-- 
2.25.1

