Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5514DD7CB
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiCRKPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiCRKPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED45103B84
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEYLBEiBqj1SXw6Iq3V0kpQba2bkmULSDX0i4GvCfiyYWn0WwixdC15P2kPwABqU317CekPgJyl8cuH0wuUJgabT6Cf1bEXZF3tT08SyrvNmeGFcBrTRqjMOO1p2aO4wRxNW1tQo31tLvrfzXnljUe7cNwt0WoyRx6qyXLuPcwLu7B1TrrTumgNKKYztMS9aBQ7koe63bG+GlLTtrkI83RPdaaq2TjhWbMkwXXIQqKxx2kszXxezIc+dZrTRljy543KXofYK1LoNHKuOwOmxl7YSYQ2M3vCv8t+39h6yPm/Jp+QvzG+WsgFiwEmCNUz6LJA4xQUhsHG1hC4gPtnZ+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+ESlUUxlHG0lg+nzcCtNuhuEB4rq/Xgfl8TDsmkiL8=;
 b=hvdCCH7B/2XPAwOdeyI2jrBVE+/1pi74+R9kAyDrzR0/k85I2dzQf8y6Ci22XUP3BPJf6NRkA6jzPg8w1dTeOq9H+hcUcwqZBZ3fCZreVZkA5KKIu480PFBYnX+ka7tOOI8Kh6gYrKVGxgp86XShC8IClqJFvHLBRgLcpZ4AMNHkjYSYZJ3sYB8Z/fitiDLyBA7kyldjLb0dbxawfIBxJgQOUNm6J5U2UvNf19T08r/nOi8oHzm5ETfs9VddWHLoKcvzXMnZAFsZq2H5lu4yHhjg8YuWizpuglzHz7XiIO/rGtnhCimydkiXjgJLbe7W9XNsSyrInUggfY/3Pdi7zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+ESlUUxlHG0lg+nzcCtNuhuEB4rq/Xgfl8TDsmkiL8=;
 b=eQmkIPvyyvaVGCnw/6ibSgcZzkp9iJ9dBeaJqnXL4Yfxv1eD8+zu+/nGSH580iT7cU4F1WYMuxkG+dFpNU7Cj9bJVGvlcjlSEyztp4gdQyWRAS2D7AS6akK5a6LolvsA3MlZAYJOa8WNc6skd7JwBFP2srfnAvKWHzor9T/J0hQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:42 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 08/10] nfp: choose data path based on version
Date:   Fri, 18 Mar 2022 11:13:00 +0100
Message-Id: <20220318101302.113419-9-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 045c4c63-3167-4546-d4f7-08da08c7fae9
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB2090739F19ABC27506111F49E8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x+hSTRldG7C19jmZQdcI3r0BR9F/Ol7jQMgSlAjEmLxLGpbeEwWD/DUvHqrBMz48gfpqD0Hu1qyR9gR0q2Qcai0e4JXWYAqyKHg8YKnRNgdc9D821THzpyBWYo8ZaX9gJi90k6sXrfop/gfmHO8aKt6+i6VKZx3Ywpwti3HobzMpEqT7FAIpY5MeTUSZyI+9IICqEM0MQOEsS+M50qFLAIRP/E316PK+NSiRONa55QKZrTJO9RZ/x/Pa09l/bgqixWpod3VIRoOoRVGzEULuiTBk+noFnQgfaGiSWBHDMWmTui40KRPb/uew3ioxGrCfthXOOCUzAu63JNwu1z8ICGxuOfqzAM45MaKdY1yRam2KPALbDWAt67LQtJnbQdLb/De94WZSP/YteUDdOLsKYCWc4C7NaJrKdQ3p99cNzuiiWLe6zLEm3m1nLOvXMhT+w5VGLV9Bvlw2gxegY1f4+cZ+a5/ldoEzRyoKjNSuZne7FiYPeZc7ifYjniBgn9wUtdEk0ZFert1I1hUFXrglhMvlz/u0OklvUorRkE1E5GQoNBO3B7u1JfOiSl659VI1SIo0C3GrggpWIriiB/JumD5LTwK9s0J+lcX5jMKQTd4yUw3cFjreK79DkSlfwH5JUM0Bx5O03Gf9FPTutNcMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dYJOSaaNvmivBZ9ImrB0P3V9vv/2GQFTgETTmPGwBhu72o3ZMZQ5ybWJKTqY?=
 =?us-ascii?Q?66JWHm7jwPXz6aQU6GK0qT/d0Ct7UI6X0pQPi2pBse5U84aIEWD8t9Uv4/Jx?=
 =?us-ascii?Q?VZ1VHaQxZzbcrqbMa6hBcP6dDyKQ/3EEeV2ut3lDENpw5Lb4TSYQkUevKLvC?=
 =?us-ascii?Q?1GN6Xj8qpqZzMuCrG+UHfG/GiTdXA73pjtU6xHJjRN8RAvPJXllaLVef4cdF?=
 =?us-ascii?Q?lVd96ZgfzbN5SvocSl3L3Uz/LrbDxSURvKHiOLOjVtjVxGfn2kbVsFe2N41o?=
 =?us-ascii?Q?DqbrYCOKWcGMepijfbbf+RSidquYcMDfaxM7prlBcGSKjY01zjyIRWlmgOTC?=
 =?us-ascii?Q?OyMVo0RTK96dKLunOKFr2Mt22q+NSlR3geWLckzVDddxisL/3XqVFsyn5Jr8?=
 =?us-ascii?Q?HDzCTJzj7/O0uwvKqpV90OUmDROOGEaL6xYlBsAOJql0USJHhU2GBX4ohvo8?=
 =?us-ascii?Q?BBeV3bkCGVV8V7Ig4FHTHr4S4qidRhM3IBe1nXMwOhSXxuAaH8mATSEWwqAW?=
 =?us-ascii?Q?32UH7O5LVWwL8G48DVq0mTb1xUwVdNG879CqXGlUSVNzLn8pvVAPwQHSGL3v?=
 =?us-ascii?Q?rIVLIzX7XfeTQf8H79RzWg9H3W1CJV+TTUJNGk6xQ7tl7wQh5Q62V07nZ28u?=
 =?us-ascii?Q?RsE89hz3mWqXhPdmcAkwLJLYN043quaxkje9BMbw/8caWTvf2CN9ySRwtCbB?=
 =?us-ascii?Q?34p/hmZOD03qi2mPh74gJrXik5snEAVTaNTocauDMpF2C4IQ7ZCtBtATWsq+?=
 =?us-ascii?Q?N88iVHyttNhJdlBekEoB2ajERcrJyqPFrG2HlQspqJDgAmNRqCEcdiVuNWkc?=
 =?us-ascii?Q?jCdNn+ET2JuuOdypjdX6Z5xhSmybywjDo+eewIslXFKDIc+5pU0i1Wn5gJYe?=
 =?us-ascii?Q?p3/XCOJ61RV/1zd7F6q4rmHxDUNI+5ayfhTTHsQJs5sZIRYshCzb5spzER0f?=
 =?us-ascii?Q?BLsPjFAPoId7LMVCz5Sw81nH/WFa4w5j+/669dJJxTJOEWM/L+ORT5aIChbm?=
 =?us-ascii?Q?0I65vAacla8vlDQVOEWVr6AljsINq4JOUDSGYXwUdZRVhCczPktCOxD78PIS?=
 =?us-ascii?Q?TAqICr3IwFAfrwXHzEYL0RiUSFZfjT07mvqin5o0UaicDnfhy4wsyDrjVwRM?=
 =?us-ascii?Q?3r5zhuCfx6e1lHp9Y1qaTpDEeJF6U6DU1Z1+4tz2KbA7Ad9NH89O+YnVoHl/?=
 =?us-ascii?Q?GgRaP5a/wCmnB90cycInSY/hOJLw7HR45+aZY8IirHRqVqu/lIO+LbH3Sv+9?=
 =?us-ascii?Q?E5xEs6ZOnz3P3QL03IqDI76/Rj+PRVqB4RUKywBYcff1T6fBK33RLQv+HDZw?=
 =?us-ascii?Q?wMIxVQucLVwOOIfhR5N43sIux6F0UfebDLaCAjLmPWWkGTEixjb4WsQ+iWKi?=
 =?us-ascii?Q?1bfjVykpGksK7czsvbMzCXkkpXxk2ee3fAaa2hv0FR3txBt+AQnDTc5TYbpZ?=
 =?us-ascii?Q?Q1oKvCC5Fobmv5C/LPKeFmKjjv0+RKEOKumEKVZB1c/EGTwyjarNXJCes2fR?=
 =?us-ascii?Q?UZ1qn8Y5KBS90qHA2X9lNFCraz4wCPKzh317se1TOZT5l1+3KM4J86+v8Q?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045c4c63-3167-4546-d4f7-08da08c7fae9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:42.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXOepJ2YFuQycenw0dfa/RidF2gkqJ4bYt0oZQa0iyhNr6BSskggqucF0MCRiDzDBXdNAiHC8XP+Cf1zTjG5eMnLlk4++Lvsv+zAV8lfbsM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

Prepare for choosing data path based on the firmware version field.
Exploit one bit from the reserved byte in the firmware version field
as the data path type.  We need the firmware version right after
vNIC is allocated, so it has to be read inside nfp_net_alloc(),
callers don't have to set it afterwards.

Following patches will bring the implementation of the second data
path.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  | 14 +++++++-----
 .../ethernet/netronome/nfp/nfp_net_common.c   | 22 +++++++++++++++----
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  4 +++-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_main.c |  9 ++++----
 .../ethernet/netronome/nfp/nfp_netvf_main.c   |  9 ++++----
 6 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 3c386972f69a..e7646377de37 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -411,13 +411,17 @@ struct nfp_net_fw_version {
 	u8 minor;
 	u8 major;
 	u8 class;
-	u8 resv;
+
+	/* This byte can be exploited for more use, currently,
+	 * BIT0: dp type, BIT[7:1]: reserved
+	 */
+	u8 extend;
 } __packed;
 
 static inline bool nfp_net_fw_ver_eq(struct nfp_net_fw_version *fw_ver,
-				     u8 resv, u8 class, u8 major, u8 minor)
+				     u8 extend, u8 class, u8 major, u8 minor)
 {
-	return fw_ver->resv == resv &&
+	return fw_ver->extend == extend &&
 	       fw_ver->class == class &&
 	       fw_ver->major == major &&
 	       fw_ver->minor == minor;
@@ -855,11 +859,11 @@ static inline void nn_ctrl_bar_unlock(struct nfp_net *nn)
 /* Globals */
 extern const char nfp_driver_version[];
 
-extern const struct net_device_ops nfp_net_netdev_ops;
+extern const struct net_device_ops nfp_nfd3_netdev_ops;
 
 static inline bool nfp_netdev_is_nfp_net(struct net_device *netdev)
 {
-	return netdev->netdev_ops == &nfp_net_netdev_ops;
+	return netdev->netdev_ops == &nfp_nfd3_netdev_ops;
 }
 
 static inline int nfp_net_coalesce_para_check(u32 usecs, u32 pkts)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 331253149f50..0aa91065a7cb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1892,7 +1892,7 @@ static int nfp_net_set_mac_address(struct net_device *netdev, void *addr)
 	return 0;
 }
 
-const struct net_device_ops nfp_net_netdev_ops = {
+const struct net_device_ops nfp_nfd3_netdev_ops = {
 	.ndo_init		= nfp_app_ndo_init,
 	.ndo_uninit		= nfp_app_ndo_uninit,
 	.ndo_open		= nfp_net_netdev_open,
@@ -1962,7 +1962,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->dp.num_tx_rings, nn->max_tx_rings,
 		nn->dp.num_rx_rings, nn->max_rx_rings);
 	nn_info(nn, "VER: %d.%d.%d.%d, Maximum supported MTU: %d\n",
-		nn->fw_ver.resv, nn->fw_ver.class,
+		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
 	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
@@ -2036,7 +2036,16 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	nn->dp.ctrl_bar = ctrl_bar;
 	nn->dev_info = dev_info;
 	nn->pdev = pdev;
-	nn->dp.ops = &nfp_nfd3_ops;
+	nfp_net_get_fw_version(&nn->fw_ver, ctrl_bar);
+
+	switch (FIELD_GET(NFP_NET_CFG_VERSION_DP_MASK, nn->fw_ver.extend)) {
+	case NFP_NET_CFG_VERSION_DP_NFD3:
+		nn->dp.ops = &nfp_nfd3_ops;
+		break;
+	default:
+		err = -EINVAL;
+		goto err_free_nn;
+	}
 
 	nn->max_tx_rings = max_tx_rings;
 	nn->max_rx_rings = max_rx_rings;
@@ -2255,7 +2264,12 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_LSO_ANY;
 
 	/* Finalise the netdev setup */
-	netdev->netdev_ops = &nfp_net_netdev_ops;
+	switch (nn->dp.ops->version) {
+	case NFP_NFD_VER_NFD3:
+		netdev->netdev_ops = &nfp_nfd3_netdev_ops;
+		break;
+	}
+
 	netdev->watchdog_timeo = msecs_to_jiffies(5 * 1000);
 
 	/* MTU range: 68 - hw-specific max */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 33fd32478905..7f04a5275a2d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -149,7 +149,9 @@
  * - define more STS bits
  */
 #define NFP_NET_CFG_VERSION		0x0030
-#define   NFP_NET_CFG_VERSION_RESERVED_MASK	(0xff << 24)
+#define   NFP_NET_CFG_VERSION_RESERVED_MASK	(0xfe << 24)
+#define   NFP_NET_CFG_VERSION_DP_NFD3		0
+#define   NFP_NET_CFG_VERSION_DP_MASK		1
 #define   NFP_NET_CFG_VERSION_CLASS_MASK  (0xff << 16)
 #define   NFP_NET_CFG_VERSION_CLASS(x)	  (((x) & 0xff) << 16)
 #define   NFP_NET_CFG_VERSION_CLASS_GENERIC	0
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 7d7150600485..61c8b450aafb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -219,7 +219,7 @@ nfp_net_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	struct nfp_net *nn = netdev_priv(netdev);
 
 	snprintf(vnic_version, sizeof(vnic_version), "%d.%d.%d.%d",
-		 nn->fw_ver.resv, nn->fw_ver.class,
+		 nn->fw_ver.extend, nn->fw_ver.class,
 		 nn->fw_ver.major, nn->fw_ver.minor);
 	strlcpy(drvinfo->bus_info, pci_name(nn->pdev),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index 09a0a2076c6e..ca4e05650fe6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -123,7 +123,6 @@ nfp_net_pf_alloc_vnic(struct nfp_pf *pf, bool needs_netdev,
 		return nn;
 
 	nn->app = pf->app;
-	nfp_net_get_fw_version(&nn->fw_ver, ctrl_bar);
 	nn->tx_bar = qc_bar + tx_base * NFP_QCP_QUEUE_ADDR_SZ;
 	nn->rx_bar = qc_bar + rx_base * NFP_QCP_QUEUE_ADDR_SZ;
 	nn->dp.is_vf = 0;
@@ -679,9 +678,11 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 	}
 
 	nfp_net_get_fw_version(&fw_ver, ctrl_bar);
-	if (fw_ver.resv || fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
+	if (fw_ver.extend & NFP_NET_CFG_VERSION_RESERVED_MASK ||
+	    fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
 		nfp_err(pf->cpp, "Unknown Firmware ABI %d.%d.%d.%d\n",
-			fw_ver.resv, fw_ver.class, fw_ver.major, fw_ver.minor);
+			fw_ver.extend, fw_ver.class,
+			fw_ver.major, fw_ver.minor);
 		err = -EINVAL;
 		goto err_unmap;
 	}
@@ -697,7 +698,7 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 			break;
 		default:
 			nfp_err(pf->cpp, "Unsupported Firmware ABI %d.%d.%d.%d\n",
-				fw_ver.resv, fw_ver.class,
+				fw_ver.extend, fw_ver.class,
 				fw_ver.major, fw_ver.minor);
 			err = -EINVAL;
 			goto err_unmap;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index 9ef226c6706e..a51eb26dd977 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -122,9 +122,11 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	}
 
 	nfp_net_get_fw_version(&fw_ver, ctrl_bar);
-	if (fw_ver.resv || fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
+	if (fw_ver.extend & NFP_NET_CFG_VERSION_RESERVED_MASK ||
+	    fw_ver.class != NFP_NET_CFG_VERSION_CLASS_GENERIC) {
 		dev_err(&pdev->dev, "Unknown Firmware ABI %d.%d.%d.%d\n",
-			fw_ver.resv, fw_ver.class, fw_ver.major, fw_ver.minor);
+			fw_ver.extend, fw_ver.class,
+			fw_ver.major, fw_ver.minor);
 		err = -EINVAL;
 		goto err_ctrl_unmap;
 	}
@@ -144,7 +146,7 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 			break;
 		default:
 			dev_err(&pdev->dev, "Unsupported Firmware ABI %d.%d.%d.%d\n",
-				fw_ver.resv, fw_ver.class,
+				fw_ver.extend, fw_ver.class,
 				fw_ver.major, fw_ver.minor);
 			err = -EINVAL;
 			goto err_ctrl_unmap;
@@ -186,7 +188,6 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	}
 	vf->nn = nn;
 
-	nn->fw_ver = fw_ver;
 	nn->dp.is_vf = 1;
 	nn->stride_tx = stride;
 	nn->stride_rx = stride;
-- 
2.30.2

