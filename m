Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEED3F1B78
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbhHSOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:18:49 -0400
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:22711
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240490AbhHSOSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:18:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRKwTjxlyZAYXS2Ah8C+1cfYNLasHnRXMd6OTj7L+unoMpdZNlWqpTejqcjZRL+IF5UW9xLyzXkUJKARKB8LfhfZw7CsoEAv3i6kIJh0aShkQolAA413NbbDb62+AW9koxHP7DUsbNysNG+Oyog0/EWeGSZQVePz37GrmeV4oAz/MdmnbQ90ssf1pgXyFCEKNPZHy4QZB8I4m8q2M5vBuTxeNAROC8/xsSTA6et2oYRY8VBqFk4ffr+hpPdMCAsGp5xCcPFvtAhK4VZ/mZpVWBMpFeDCO2leIAEVewh/JwqCOKKY5TWiO0n7UJ58Zf01sWfMiOlChQhV0TsHoCYYXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aie8SP03NdruGhQa1Vgqm6kygGbr5v82iVSG52HFcI4=;
 b=NRkg9VN3rz1vRINIteVk7i1kskTBk0wUjv/U3AXovT+tYclJeVF18lIbWAhKE26GdjUrCZlv3xrYMHjtOdGYrN3m/JycS/y1cLRcmpqJxpKsrQKHsuT8dsRKLUe5XDAlbRNKcF3snx3Km3KFoodbwS87hc8SAR8ybxlAJazJP+DsFddVF1Z0Wu702jFTZcClFvGxOJfzoXiQOr4gGy9WeGlD9vUf2miqLhScVQZppGKHl9PpgjiqVuLrY9D8d1l6QV/SbaE+G9bUjX39xGJkcvAiv6CgQiQNpIXmn4Sfpjl+crMzFvIT5w2AtsVYMpWcfkUlXMxWdHUbWt34Or2Snw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aie8SP03NdruGhQa1Vgqm6kygGbr5v82iVSG52HFcI4=;
 b=j/Is1J5hdKybnPAqsGLPk56NOnZgBdJ1X2gSmyHtqS+Njto1OFBqNq7ISjn5DTrniP3OfHUFMtohrLT9UMEbw29F/mZ8AKY7fv+KF+SVjsYtxpMo6MwONOv/BnSRrSaMWmQAOXoTwk2fj9Wqgwrkw1npftpoAqONrocCzHqDUHw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 19 Aug
 2021 14:18:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 14:18:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net] net: dpaa2-switch: disable the control interface on error path
Date:   Thu, 19 Aug 2021 17:17:55 +0300
Message-Id: <20210819141755.1931423-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0181.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR02CA0181.eurprd02.prod.outlook.com (2603:10a6:20b:28e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 14:18:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29fecd4f-7b2a-45eb-5999-08d9631c2bd4
X-MS-TrafficTypeDiagnostic: VE1PR04MB6640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6640924C9A8E074CE2885E94E0C09@VE1PR04MB6640.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AzVCwzvIJBswjLQYbBlhKxJ5+mLgUZEKFyZqLyJzEpdVGeeG5gAY8rsMXbO0Z3sQMDAuynwL2XswUuz63XWaE4qwjcQvizsT9arkTV6hdhXPV0iPuEmoZa6VwX6EZN1hA5pI6OmzC+QZOHUj6whx8SpNDUzE1/K+kw3a6rf7rI3OeIGgF4vWNPl09RuusMlbq16Jew6fo0JC7JBgEeXOs1aLIqe3rqY4fmzyIRaX78QBdV5sePs/v11HNW3VCtPPFjzjlt8Z3CWpKXb217jC1X/mXO+wXVNORNarvCWkUuWG5E2hya9XGiG2BXvvUnGTIzrEKbgdZO5NrkqLPE+W5j9e4zwaOvSKltmu5pZr8s9LLRUkYOrTjo4kjED7cdhamKCarlQjeoNqw5pme/+r/DVioMloTCdUttlUG0j50NiWhX/7j+T4mKvaWXEsfcbGYbjDe9DxaThoC14s0JPCk370TYCC4IpcExfXKV4/EJG6jfBdFlf6xfoTu1bvs80qkTtIGoNeRqQk26pbTYXq95l8m3g9UBHYepbHYRGAcxfwbxbRTqPZ/dDdK8YNmZUpg3sSREFsid4xvqaACuSUe0ya6yq7MK9/rVp+iCPgOtinnpayxPqUzj/kp3TJZrUuxykZ2e7rcgp59cbB28C7xdSheu8xTgsx+T+HO8pWlroboAE7C+HkI5BziZTzorl9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(6512007)(8676002)(6506007)(6486002)(316002)(86362001)(52116002)(5660300002)(36756003)(83380400001)(478600001)(8936002)(2616005)(956004)(6666004)(38350700002)(186003)(4326008)(66946007)(110136005)(66556008)(2906002)(1076003)(66476007)(26005)(44832011)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dh8mKhEsxuRkGzdBoK9Q9+1oelwx+Lt/KlkOqV66gzXZFmukjLVtRpj0QpP?=
 =?us-ascii?Q?7pkwASTJp9Ny/vVgNRgjJjJ+0TQOOr75dCu0eI4ofT+esMXTxy1PGD9RB6p1?=
 =?us-ascii?Q?XRKrmwhphzLp5jojnd2qBdARZxWIPwXy81SewEzhtC7SdvWrkb8xkoV07fTu?=
 =?us-ascii?Q?Sn8FYx/EYLRflxzxGYe2smsU6oX9DU0T4zZfSAXCA41IYUxP+LrSMfP6jhFx?=
 =?us-ascii?Q?gsv6FifDB1zJ+Uz55LeMnP4xzQuY/cqRpuL9+DVw3Y9vLHME+yVSCd5bLeSA?=
 =?us-ascii?Q?5F6Eea6GYNHUFsd4BQz4K3f1AAU7MVawo8oD4seU6N+7i/9rSCn87M0lL+lW?=
 =?us-ascii?Q?w1vgxwC2TgMeCNAPrnRzfvS2DSxau3NFzvL86t0nOShk+BufMhzFKB6SE0l3?=
 =?us-ascii?Q?sOZA40C/tgoHHSoCz9QzC/V7/Q83N0KLyzg/gnV2eukLG+zE6NZtj4Vae7MY?=
 =?us-ascii?Q?ayht9LlyQ+lyis4dx4gqyVmTxdmhBQwDC3BWHDVqpZ13zj5LEC3Ic5K5Ww3I?=
 =?us-ascii?Q?l72DQzzrO37VcygKvAV0rzuPeLxzcqYJEmACHFQUcJaHkFAhntKyj1un5IpQ?=
 =?us-ascii?Q?8P/cFthYlRVmeuVEKi4gTbugROSe1MRtXpqtwpZg15pl3rguyGdcSEmK+7mH?=
 =?us-ascii?Q?tQp/hBasG5i8VjsgX0pmXIzmFslS0yExmaqgi8+ef3NVrOtDNQFiKJtcoOzi?=
 =?us-ascii?Q?qOOtFI7fc3dvkzcWkK2qPpGTy43tIDqUV3v2mKAFAv8nf++sVbZMRkZ58h4n?=
 =?us-ascii?Q?ZrA6D+SgMASLWxSPhaFbjOTPmSsRTYcNsKZoZAZuTMj5mOrr2jzKkZZYSjL5?=
 =?us-ascii?Q?9t/PRLa2x66hyuIOWMZhOV/pmmC1c2QF99n9r38HmKVpYrWM+PpE02XkNhpE?=
 =?us-ascii?Q?LErKmF4txLan8XAvlrG7RE9ML8wEBniKaizhq+R9eu4Y11Ag59z29sZTktE1?=
 =?us-ascii?Q?RBwXVPBsoM/fMtr9fS+YIy1u8fLuGWUlcYVPF8HJZZlH91OGguFw27Xex8mc?=
 =?us-ascii?Q?IVtRgkQrPhK6fVzb3PxWAfb6QySh8ZenvDcdy83YSkmWMYUnbwv5udLiDhs7?=
 =?us-ascii?Q?O7iZcGCKspByBOZnfxNXyXwmJht/o1OZ1ti8cOLWjOWtrf8wdd8mrPL+EEh5?=
 =?us-ascii?Q?r+CQhaSxIaT1bg6eq3ONmeBq6/AgL7M2O3SuG/wsGQXl9OYWcCvxLnqNGDoq?=
 =?us-ascii?Q?nDVcVNSBOvN9/MJzNUlGOlfwa1Ox3nBI2ZvjQMi5v9HAqqd/sPMnDLjEiFzi?=
 =?us-ascii?Q?kbR7SEjRYxIJJrJgPJTBuFZSbxzFviBRBTBWABDnWpMVreur5AgDRAUig4eP?=
 =?us-ascii?Q?9ZfCE0mWB5YE7Cw5G0RuJdTw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29fecd4f-7b2a-45eb-5999-08d9631c2bd4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 14:18:09.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 295tBelcBXxk4G3S5IOqTY5WTYdPNi3LLzA2MiNk53kpSx7iMe1vKZurFjT4d4H+DmZ+y+ALmbGJdzz/AxdPHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dpaa2_switch_takedown has a funny name and does not do the
opposite of dpaa2_switch_init, which makes probing fail when we need to
handle an -EPROBE_DEFER.

A sketch of what dpaa2_switch_init does:

	dpsw_open

	dpaa2_switch_detect_features

	dpsw_reset

	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
		dpsw_if_disable

		dpsw_if_set_stp

		dpsw_vlan_remove_if_untagged

		dpsw_if_set_tci

		dpsw_vlan_remove_if
	}

	dpsw_vlan_remove

	alloc_ordered_workqueue

	dpsw_fdb_remove

	dpaa2_switch_ctrl_if_setup

When dpaa2_switch_takedown is called from the error path of
dpaa2_switch_probe(), the control interface, enabled by
dpaa2_switch_ctrl_if_setup from dpaa2_switch_init, remains enabled,
because dpaa2_switch_takedown does not call
dpaa2_switch_ctrl_if_teardown.

Since dpaa2_switch_probe might fail due to EPROBE_DEFER of a PHY, this
means that a second probe of the driver will happen with the control
interface directly enabled.

This will trigger a second error:

[   93.273528] fsl_dpaa2_switch dpsw.0: dpsw_ctrl_if_set_pools() failed
[   93.281966] fsl_dpaa2_switch dpsw.0: fsl_mc_driver_probe failed: -13
[   93.288323] fsl_dpaa2_switch: probe of dpsw.0 failed with error -13

Which if we investigate the /dev/dpaa2_mc_console log, we find out is
caused by:

[E, ctrl_if_set_pools:2211, DPMNG]  ctrl_if must be disabled

So make dpaa2_switch_takedown do the opposite of dpaa2_switch_init (in
reasonable limits, no reason to change STP state, re-add VLANs etc), and
rename it to something more conventional, like dpaa2_switch_teardown.

Fixes: 613c0a5810b7 ("staging: dpaa2-switch: enable the control interface")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 68b78642c045..98cc0133c343 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3038,26 +3038,30 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	return err;
 }
 
-static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
+static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
+{
+	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
+	dpaa2_switch_free_dpio(ethsw);
+	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_drain_bp(ethsw);
+	dpaa2_switch_free_dpbp(ethsw);
+}
+
+static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
 	int err;
 
+	dpaa2_switch_ctrl_if_teardown(ethsw);
+
+	destroy_workqueue(ethsw->workqueue);
+
 	err = dpsw_close(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
-static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
-{
-	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	dpaa2_switch_free_dpio(ethsw);
-	dpaa2_switch_destroy_rings(ethsw);
-	dpaa2_switch_drain_bp(ethsw);
-	dpaa2_switch_free_dpbp(ethsw);
-}
-
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
@@ -3068,8 +3072,6 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	dev = &sw_dev->dev;
 	ethsw = dev_get_drvdata(dev);
 
-	dpaa2_switch_ctrl_if_teardown(ethsw);
-
 	dpaa2_switch_teardown_irqs(sw_dev);
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
@@ -3084,9 +3086,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	kfree(ethsw->acls);
 	kfree(ethsw->ports);
 
-	dpaa2_switch_takedown(sw_dev);
-
-	destroy_workqueue(ethsw->workqueue);
+	dpaa2_switch_teardown(sw_dev);
 
 	fsl_mc_portal_free(ethsw->mc_io);
 
@@ -3199,7 +3199,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
 		err = -ENOMEM;
-		goto err_takedown;
+		goto err_teardown;
 	}
 
 	ethsw->fdbs = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->fdbs),
@@ -3270,8 +3270,8 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 err_free_ports:
 	kfree(ethsw->ports);
 
-err_takedown:
-	dpaa2_switch_takedown(sw_dev);
+err_teardown:
+	dpaa2_switch_teardown(sw_dev);
 
 err_free_cmdport:
 	fsl_mc_portal_free(ethsw->mc_io);
-- 
2.25.1

