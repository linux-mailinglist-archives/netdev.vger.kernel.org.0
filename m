Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7929B679B98
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 15:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbjAXOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 09:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbjAXOVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 09:21:20 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E11697
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 06:21:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKguVZA9eX9EF4xR+7/QECpayidnNraNqyeHN3IlMrUOkkx4MH2yGpRYgURYwsY1Y8Q9Ug15Qt2+vYLiaqwiiqiSqFMYwkHkNfDWPwu/tGSY+E2NXQEdMbQX7ZyKrminUxCyvLzsm+vYyuth+lN97fCUaIZdd87S8P7jePfSxp0aEhQGzpkpgQUuFbrHD4f8+CNDXk7O2Pu9eoFVD2ixKb8G/0NLYDrHD/hV6aIbixXamqGGgnGx/wHMrpmamdPP/9DR6c7GbpM3NMO//h90Rau2WnAjCd1sOHZAwX7NNx1nW9yjcvjmU/RWx3wKLS4CfXWA2p5v9m8YVpoc2OJxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrI/dG+kVPWANNMXcDWzTjojRombnNMstcu5har+HJA=;
 b=IX4liCghrvWgtIwldwB6HEvNcd8o8JMI6twWJtUK/n1iAgLyOkuDBVRr0O/wFUPNANXmj6bpT5Cm6KDFchYRVVfMMA3ynQmAxxdA+TwnyZgJYg1vR9z83NhVKTD0z1FLjN9uGl2PdO/JW7piFhnd0CkWzPiJYux3UlBR8G5JrLk9rmBfdNRl3q5Q21ua2voMuFf8GP5FQ0mfeNdIpGSTdVGoZ3+tMtDQbg+ZU1tsDelTzLVMpGHlqiLSkvk6xHjwwyuY1BnneBLJtLHE5v8Aw04+1m+fM19qrpIdFABYchTpRmfJVmYdKVhBdAfID/s5yYiJDFR7vGBokRcQuA5Onw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrI/dG+kVPWANNMXcDWzTjojRombnNMstcu5har+HJA=;
 b=gQx2zLpyIazBLoIAZg/kd53L01K4suSRAS9FiLK7lGgTsKE84H5NcEsFIxRqUlHlLFU6Q2AYabqWBWHMbuyfVdAEQ9z+8tDC2D2qTXCGmP8d2POyWWRvK9OveH9NhI1+C6SMepPCTwbG3IczTVXVpu+WYEWVA+BtHkTWHOxIcnM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7024.eurprd04.prod.outlook.com (2603:10a6:800:124::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 14:21:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 14:21:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 ethtool 1/5] uapi: add kernel headers for MAC merge layer
Date:   Tue, 24 Jan 2023 16:20:52 +0200
Message-Id: <20230124142056.3778131-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
References: <20230124142056.3778131-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0158.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: 08dd4562-2bc3-46ef-9cee-08dafe163cb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wwe96Otm4lH2bbwHyNJ3iOdYeS/J0QAARL69LZmODHHoGQBEQQ9h8pv3h4oT6HyAWgupljenadB6vnd6q7stSx1r0MgBZQ42HhW4vwa9pZxk00avlv9GXcyhlQGfTotCIwASK63GlSdAu3QqjQMoQMfxa8/zqnzTyRkGXRP3bszb7rgHw9dorI2Vihtzjrr29pLdDO6yC3bvuhslRIPrpdGSAER5TeJ7aZpxNZzbQv/9cXUWFo+k5s2YRIaF6WTwYMSmeQCJ6PDfVmJbFqhXj+oKXhPkQhkdtL2oFc51TJ3aqz1S1HSEEJdZsoSVD8MO18Wh1Pu3pwZxYnTZ1nx6aUOCU3CasKoBJEvg4tuX5rrPwj6sw0IZ2bvXLu/ODtWbIimM3R2Ubj3MlSUlXxETOSTshpaDEObZ7p//kuzmItlCSqyr78COpqk7R9PLkXhMC0ZMyAqkpt8Mgusc4ViVXYsCXnzXaeP0EB0y/Y5UhYIHTS7R8jswk8C8uJPqf/TR1cXuWLVOjViwNIL4f7WD5rF58rXmcGTIyPvbp+xr4jQI7edmOBq70lIUJ/s6eYLtDJJbZ8i80Tc5drUdbX4vbsRBiADbq3I29ocmz0NR4c3EqyWhE+fQr64lLu3FtNFAZrw61Fchdl/HOTycu1FQGmS27o2g3XxVHf6pG6dT8J9GYIAcQDSExLx9H7ko5y3J0aQJ1AOxkeatDdTbt2aU9CVfI2XcxPruFRf49Xs+U4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(83380400001)(38100700002)(38350700002)(2906002)(86362001)(44832011)(8936002)(5660300002)(41300700001)(4326008)(186003)(6916009)(8676002)(6512007)(26005)(6506007)(316002)(6666004)(66556008)(2616005)(66476007)(54906003)(1076003)(66946007)(478600001)(6486002)(52116002)(36756003)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Qdy3EIdldvE2SnItA15vLlUjr1YZ7R2KHb/vzV+P9nogk61MvK+prlTiHI4r?=
 =?us-ascii?Q?qElhCBmAybcZgTXslbXoIeuWMIFZkLPWnW0rR2LyaGkId4UNNFnAJYRlVKRm?=
 =?us-ascii?Q?bLqWsSNAqiqonUnKagY6t6BoeNj9bmqqOWYrn3MaldoiadfQBJrnAczrdGac?=
 =?us-ascii?Q?99g4VsnjB/z7X4M9VppbGA1IZKpzR/DNruBaQtnvDMCuFTpKji1gsRhVyKSK?=
 =?us-ascii?Q?KeYyiRFjMO6S4luCCRVIWUie7jYy5RczifrTPk6e338Mk0p1Gt2RXPZOATBX?=
 =?us-ascii?Q?Owi0+NnU5BJtpoHyRtnOcZ/6r3oWTHpIPl6Ei03aIL4d4jLht1DS/qLVLeoh?=
 =?us-ascii?Q?7XG4ZhGTh1IK39vYPMgaZfvnqHkIJ47D5LkxqU+Qx+0XM4Ao2UhaiWVfxuQE?=
 =?us-ascii?Q?Bs44WkXwQ54NmBwkf8PgiOMvpyoArH8GwotlCjyOQjZXeK1AVoyWZVMkbgBq?=
 =?us-ascii?Q?IMp/N+QLd8onp/21SfBrkbLJkqicXDJff7Jc/OxrWuNwJmshHFi9ZnMQBNLo?=
 =?us-ascii?Q?LEGmLKrPr5HZTWlKnUBGtJqvPz0yUB2ueO4sAqksbsvTnTeJ5MhwUYlrnQm0?=
 =?us-ascii?Q?7WOIWbPetlrN1ZU0Acipo+K/h6gFly3KFgLr80yXnKxxNeTz7u1H6P8mRnLu?=
 =?us-ascii?Q?RVLLpWTBC1AFL4Chm/SNkW9+daEJ7GWIMrbBDU62o+9zvyt0/4tywps+ri7i?=
 =?us-ascii?Q?WHWMJLwNRDdawZwMZlRbYm/jADaLk92RLnHKeNU4/QCYWTjOeoXliJV62OUQ?=
 =?us-ascii?Q?xEqRx25YOtQ1ijY6/orXk4f2ddL2ph62W8yhnlbW5+urZ8YNtIdSXeDCrCdZ?=
 =?us-ascii?Q?PPOjbSiDZYNmjuv71EoyIUZfVBf3YxXHpdpNSl9yh4zUB5GXmJO2i3CzfIvI?=
 =?us-ascii?Q?lFEOi0tl2cK1G4hrFShGDzO/3RecYNzAnAmPIcrAtgs1oahd31BXLC0Of7Xk?=
 =?us-ascii?Q?0TBvRVm8/OM7JfHWN6DzjkkfnJEjdsZSgz4d+8JJX7oxEgXn/dOnSXAJKTBB?=
 =?us-ascii?Q?e34LjA27DDWF6d6mjO35lCuN6Y55bLEu9CJs2lgdR14dsGLrAbNr0e033Fr2?=
 =?us-ascii?Q?YonvIACmECENYiyc6jm+Q2MxlkSkae3VipChuNPxkAHyzQpab3jlvSNvXOS+?=
 =?us-ascii?Q?a1Q4HAjTAHUk3WKScz6+630m7nsSCLHP4NlcU5s4k5qSb1vP961si6EWgKqu?=
 =?us-ascii?Q?jl07S68ET0A76Fnf9DZPDOwVojoDfiZLEbELjhcDd19WJigwwuYsjwf5/kAi?=
 =?us-ascii?Q?CNHGCQ9fzJwVLZfXlrTlMZJGpnlPCnwGrDqCQE8UX3lKDWrynskiO7kXdlRM?=
 =?us-ascii?Q?lKZ6uGyvI2hiRVItXYNZqip3j0dmQykUJ11twr3sEI8+0XBeCnRQylvenpNh?=
 =?us-ascii?Q?unZ6whu0RJ/Qgl5uc+4XGAT8pk4ALOj2JK47TKG+7Q9khJ/BDDLwzyFI0TNV?=
 =?us-ascii?Q?xdLLEuUqXR7Ivc+nBAlqd3sfcgSuD0ZfICTdZT2R9uRLOIs9O95zacLf+SJt?=
 =?us-ascii?Q?vcKYlVfvBGo+doobGjbSLggd5u13VdyTr4JVp6KlLN4YbauoD4Q9Ao0CUbav?=
 =?us-ascii?Q?P91K3dd8rYGl3OC/WuPwI/DITpYgOgmwZLmdpDPGHRXy9sfVQY0OI0eULRSG?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08dd4562-2bc3-46ef-9cee-08dafe163cb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 14:21:09.5378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Y89HY7MJl+4aSakiELKKTp0bI+6u1vcXumD8dSi1usVsHkGcjUKK4LUTjF53u+8zPlFpm2HRnHzV+IQWLRZLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Import new ethtool netlink definitions for netlink messages and
attributes having to do with getting and setting the MAC Merge layer
configuration, as well as its counters (plus individual eMAC/pMAC
counters).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- rebase on top of PLCA changes
- ETHTOOL_STATS_SRC* macro names changed to ETHTOOL_MAC_STATS_SRC*
- ETHTOOL_A_MM_ADD_FRAG_SIZE became ETHTOOL_A_MM_TX_MIN_FRAG_SIZE
- ETHTOOL_A_MM_RX_MIN_FRAG_SIZE was introduced
- ETHTOOL_A_MM_SUPPORTED disappeared

 uapi/linux/ethtool.h         | 43 +++++++++++++++++++++++++++++++
 uapi/linux/ethtool_netlink.h | 50 ++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index eb20bf873109..1d0731b3d289 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -709,6 +709,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_mac_stats_src - source of ethtool MAC statistics
+ * @ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_mac_stats_src {
+	ETHTOOL_MAC_STATS_SRC_AGGREGATE,
+	ETHTOOL_MAC_STATS_SRC_EMAC,
+	ETHTOOL_MAC_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
@@ -777,6 +795,31 @@ enum ethtool_podl_pse_pw_d_status {
 	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
 };
 
+/**
+ * enum ethtool_mm_verify_status - status of MAC Merge Verify function
+ * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
+ *	verification status is unknown
+ * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+ *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
+ * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+ *	the Verify State diagram is in the state VERIFICATION_IDLE,
+ *	SEND_VERIFY or WAIT_FOR_RESPONSE
+ * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+ *	indicates that the Verify State diagram is in the state VERIFIED
+ * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
+ *	the Verify State diagram is in the state VERIFY_FAIL
+ * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+ *	verification of preemption operation is disabled
+ */
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index a6d899cd7f3a..fced517c2e73 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -55,6 +55,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG,
 	ETHTOOL_MSG_PLCA_SET_CFG,
 	ETHTOOL_MSG_PLCA_GET_STATUS,
+	ETHTOOL_MSG_MM_GET,
+	ETHTOOL_MSG_MM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -105,6 +107,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
 	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
 	ETHTOOL_MSG_PLCA_NTF,
+	ETHTOOL_MSG_MM_GET_REPLY,
+	ETHTOOL_MSG_MM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -421,6 +425,7 @@ enum {
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
 	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
+	ETHTOOL_A_PAUSE_STATS_SRC,			/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
@@ -737,6 +742,8 @@ enum {
 
 	ETHTOOL_A_STATS_GRP,			/* nest - _A_STATS_GRP_* */
 
+	ETHTOOL_A_STATS_SRC,			/* u32 */
+
 	/* add new constants above here */
 	__ETHTOOL_A_STATS_CNT,
 	ETHTOOL_A_STATS_MAX = (__ETHTOOL_A_STATS_CNT - 1)
@@ -919,6 +926,49 @@ enum {
 	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
 };
 
+/* MAC Merge (802.3) */
+
+enum {
+	ETHTOOL_A_MM_STAT_UNSPEC,
+	ETHTOOL_A_MM_STAT_PAD,
+
+	/* aMACMergeFrameAssErrorCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
+	/* aMACMergeFrameSmdErrorCount */
+	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
+	/* aMACMergeFrameAssOkCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
+	/* aMACMergeFragCountRx */
+	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeFragCountTx */
+	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeHoldCount */
+	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_STAT_CNT,
+	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MM_UNSPEC,
+	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_MM_PMAC_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ACTIVE,			/* u8 */
+	ETHTOOL_A_MM_TX_MIN_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_RX_MIN_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_VERIFY_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_MAX_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_CNT,
+	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
-- 
2.34.1

