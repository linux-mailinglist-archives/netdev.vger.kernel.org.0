Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244D331D0B9
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBPTJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:09:45 -0500
Received: from mail-bn8nam12on2064.outbound.protection.outlook.com ([40.107.237.64]:26688
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231254AbhBPTJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 14:09:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSiJ2QSuBWrOMrPbyshyCrmgE+Lqn1bbtMJ6szRDYH70dcpZBfEDvW2r6oSL3ehq21JKY2OAEV2AfcvzR5n8IlCXCvVn9GbkOgiuHLJdTX0DKWYnxLb0K78Q2J7w+6k9IDCpU7+rT/Oc1VX7C/q57WoyzwERiwCPArOTOL4y16GbMfx4biLooISmZzX3c/6jZuhDEoATZemwi4Dt+1YOyzvvyIUBWelbojdp1lRuz6LIhXpwN3uCugA7yKhm1eqLZqnaieQ13vSY1556wCBUCF2nUkiSnqHXY2vBGjUuOA8t4Hr+k/LQ1laMasY+XIHSI6qcq5rd+0ty6aDKA3VpHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKQApd0mf6MLiz+QFWvbOF9BGGxhNSaGblNTzHzxCsk=;
 b=RAFLeab8/ha1AcLqbZ10UZlr5pA5+cCL8gxZCX/QsAEVJzV1L0Sel6IKNS9K81S4vacqJCOcQDBC3fomZ90CSqgWciUvTOcSR3fRHfIzdd5j2qTzsjNSood0SyZ7/80rCWU072B/f1aLI0GQOKftNDqY29p5EzJ5en4Pwmlcl1DguR7+/2ePq/kx9jOerpl/bWrObP63m5yujnD9K0udOaI+f+ikBfPw7dllcUIPkx24nE/xbU8QTPmZUkEvRZ3nLAsZTQDGL8/U215bk/H+WZKW9jlky3yvu4qVIbtKByybWL4xatf5JAjO9pgUzdVsZMcMmmsgWbRjbpZvO6rl3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKQApd0mf6MLiz+QFWvbOF9BGGxhNSaGblNTzHzxCsk=;
 b=sdd2OB+QctKv3wblRh37LDMpllOb0777lelJ02pB2EjInaOPPidlhj+Rnh1PBlyRCyqGbNCg5g87M5UPo50pqL/WVMAZVhBZ15hDGVkNtJUPSYAsOr+MBgelpDruU6wwKNlmxOQ70CZ7ZgTp4mjb4tY2TzkQPYoL2xfc9OGxD24=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from BL0PR12MB2484.namprd12.prod.outlook.com (2603:10b6:207:4e::19)
 by MN2PR12MB4112.namprd12.prod.outlook.com (2603:10b6:208:19a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Tue, 16 Feb
 2021 19:08:15 +0000
Received: from BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2]) by BL0PR12MB2484.namprd12.prod.outlook.com
 ([fe80::5883:dfcd:a28:36f2%6]) with mapi id 15.20.3846.031; Tue, 16 Feb 2021
 19:08:14 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>
Subject: [net,v2, 3/4] net: amd-xgbe: Reset link when the link never comes back
Date:   Wed, 17 Feb 2021 00:37:09 +0530
Message-Id: <20210216190710.2911856-4-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
References: <20210216190710.2911856-1-Shyam-sundar.S-k@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::16) To BL0PR12MB2484.namprd12.prod.outlook.com
 (2603:10b6:207:4e::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 16 Feb 2021 19:08:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1b894ba-1ef0-4b5a-48ac-08d8d2ae3613
X-MS-TrafficTypeDiagnostic: MN2PR12MB4112:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR12MB411255227443494CF1B4890B9A879@MN2PR12MB4112.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4AKReY/kZOdY7StxKXDJxBFgHYJPR9R/XwMwpxuiMcMOMCigtmfKoGc7CtvPoyAULTEBSXTj/LLCaBUeBgQklkvHjGmxzlqFUoz/g5/iYSnmc5yIkCbo/AigBx7g3DX90F7s8u6peXY5Jv2Fni2Z6Pg7PLnd3YFz/uVAnl2kVb6Rb76M1ysXUsN65G2FEUhU85YP1SUKJyPhCacwWk8F/NuiBeIOjb9abeQhnHZ2WDVG3oAu9a3ex4hCPrrxkoTzPA7J9GPsnwPVUFlzMXdzUweMA1F+1vBT2SmqixA7hbdPjk/n9zTQXVAQ4fjAECw5krg0tjc+UXQ5YGkf0L/+pDQIgqivxg+QTudFhU/EPw/EOPlRmL8EzxXRutktvocE11r3z926zqSRSvzuvHnnHZTlybyzALbfoXYT04DB7qHH4KalVAKoVerHAi71/e2lOOyct256nsY0ZZi9DbE0XRhqrSvEbxQ4sxlgU2cd/ZRjeCl2n3j9wYQSwLzCqA55Czw1EZj/D3Vyolhp6A88w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2484.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(7696005)(54906003)(1076003)(83380400001)(8936002)(86362001)(6666004)(66476007)(2906002)(4326008)(8676002)(52116002)(5660300002)(478600001)(110136005)(186003)(26005)(956004)(66946007)(2616005)(316002)(16526019)(66556008)(36756003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?TghOvwHDMS2nVH38UpTDZ+rFzS+Qemxo5jg1hS1sH8qAnbC3BcjP/ZhKbVaY?=
 =?us-ascii?Q?pOtDlAWjGl2AJCC62m1h9cmSUd6XtShT9cf1+6KB1/h0401VcJv3rzZZrWXu?=
 =?us-ascii?Q?tAHdOLytda4urluJVrVuCb5KVeam086M8wjOybRg4eakjS8oTWs9U/jyI7NU?=
 =?us-ascii?Q?4p+CgmSRjn1TdFbp9npvxHqIt4YrZTHm2SOYHf9JD8R/8tYfg0fs+UQePREW?=
 =?us-ascii?Q?+GlHDWueEptUhaa0H8giY9k3xhEJpCO9WosYTyhX9bW6OpT4hShC4OGO0SOm?=
 =?us-ascii?Q?zpp0taJS2cP3Jpjqxz5ob544ghcRGwK1jF8swU7Iu9kY14ybW13bFrtlvOqO?=
 =?us-ascii?Q?Z5UYmEchvgLQybW1U/ZVR617zsL51GBS9Kk3ghTRdt7GRRkPKGtvxQp/VyFg?=
 =?us-ascii?Q?bbVsgZ6ZSbtuT1p3pt+OrY6FC0BEk7XZFgxkFvEYrlG7SJNdpzeuDOqPqg9r?=
 =?us-ascii?Q?c+ForEGosBLTGaCuoHVZ4jfIxTO60WcibnOhBLNjqDPS/fuYNP6aqn/es37/?=
 =?us-ascii?Q?zHZDK7rihquO1+b3r68CFh7v7uoDUkBt1ansOnU5NpynYBRjuFVg7Q2YTCdA?=
 =?us-ascii?Q?n/24/BopSifVPaWHRJtJMVCj71k2w+FmScTQUs/vXLAFE6xxYrfdCYFsF5tn?=
 =?us-ascii?Q?f6Zp1yzbAzslMfqhlCJWmbczhkSG1C6VhIse6+SK/I7hlNQuPgz7Kbo4GnNb?=
 =?us-ascii?Q?COpVNboIHDy5fv8j1AIsasJXp9+4E9Su1Ej2zTKX5jGxWyOIRqk/66POfeDs?=
 =?us-ascii?Q?qBI5GVr0oNi8bTsfnTx51MotPpCk8BIKI4LK4+xNOXIQvq9/1KFVGgw8MqLe?=
 =?us-ascii?Q?CHgT0naPjjRlHeSPB2iy4pHFhvoPpZa8FRcKR64hvzzt0X7kpojeG5kBt3GK?=
 =?us-ascii?Q?kH8Bcb2X6aV8q8hTozDQwxc8cWiwlCSTJYj0qFXyZi1ddwwR+1Z3QtOQlH6e?=
 =?us-ascii?Q?9bQRiezsJQlFW8QgwE9OFT5kAa+fs+kShXoIwlaAAzfSSSNIiEDdk51kQwAW?=
 =?us-ascii?Q?09+GSSq/GfDAWfRI/xOcqDTXDbAnRuprvxxbsZ7VVUswkKZecU775KBAl4gK?=
 =?us-ascii?Q?qupbqoDV12jcFzvpNORiwauE+kfFIr4gO1xwxiJU29wb8JJaL3a4+s55GX3V?=
 =?us-ascii?Q?6i0ILJEJLobKaEsFDzphNK9KdW3eVzi4Qj2FUpT+0/0Sb4RXOCgbUWLYQhAw?=
 =?us-ascii?Q?JGaqQ6wrbTtE26KIfYM3sZjzEfQsVs1sQrocA9H/ijFuGPJcLG/72BZ6THln?=
 =?us-ascii?Q?kG3vTw/fxAeiwcZt0rJVsUbV6l1GSXgW9DMzQGBle2IXMz5Ej0zaOKzYN6NR?=
 =?us-ascii?Q?Pudq94TgbtEYfJBTgCLL4vnq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b894ba-1ef0-4b5a-48ac-08d8d2ae3613
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2484.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 19:08:14.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DA4xlFqSHr3BuHLDBu0DfHzOPD3hy/axAPz0yk1n/cxodKCbjqQmxBdwnU+HoR2ic/qQR7acp1EB7uW2k+Yfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Normally, auto negotiation and reconnect should be automatically done by
the hardware. But there seems to be an issue where auto negotiation has
to be restarted manually. This happens because of link training and so
even though still connected to the partner the link never "comes back".
This needs an auto-negotiation restart.

Also, a change in xgbe-mdio is needed to get ethtool to recognize the
link down and get the link change message. This change is only
required in a backplane connection mode.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
---
v1->v2:
- Commit message changes
- Add Co-Developed-by: and Fixes: tag

 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   | 2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 19ee4db0156d..4e97b4869522 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1345,7 +1345,7 @@ static void xgbe_phy_status(struct xgbe_prv_data *pdata)
 							     &an_restart);
 	if (an_restart) {
 		xgbe_phy_config_aneg(pdata);
-		return;
+		goto adjust_link;
 	}
 
 	if (pdata->phy.link) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 087948085ae1..d3f72faecd1d 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -2610,6 +2610,14 @@ static int xgbe_phy_link_status(struct xgbe_prv_data *pdata, int *an_restart)
 	if (reg & MDIO_STAT1_LSTATUS)
 		return 1;
 
+	if (pdata->phy.autoneg == AUTONEG_ENABLE &&
+	    phy_data->port_mode == XGBE_PORT_MODE_BACKPLANE) {
+		if (!test_bit(XGBE_LINK_INIT, &pdata->dev_state)) {
+			netif_carrier_off(pdata->netdev);
+			*an_restart = 1;
+		}
+	}
+
 	/* No link, attempt a receiver reset cycle */
 	if (phy_data->rrc_count++ > XGBE_RRC_FREQUENCY) {
 		phy_data->rrc_count = 0;
-- 
2.25.1

