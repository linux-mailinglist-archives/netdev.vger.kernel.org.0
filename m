Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CB7502D49
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 17:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355619AbiDOPtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 11:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355610AbiDOPtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 11:49:09 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2057.outbound.protection.outlook.com [40.107.20.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AAB985B7
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 08:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MISUaT1/4QK1i11c6mniehWrS0Erfod+VJu14qr7J3IhI5OKZKWYQGQaDvVvWQDr+Ntlx9Fwp8z51q7GS0+s0/1CQsHNTX/DuwetDeulv2XYFqkT1B8tH55fLIWXijWoMlj5xb4hIkZN7slB2+VuJYPPjuneKJ+uL0nMhnYDFEQA6a7VweOL/gm6AM0LfspS0O5/sBVMuv/oouoC/0R1+HZ+0LBQoGJw+lSeMLEw644DDa+CFgPkD/Id+gy9r6JBkQAgC1kynqBAOS4WcHGeaDYPrzSAFhLifkvTOmSzubFz5JJIHxikYu6OxlCv04NZ9oArDWpPer93VGf+S6XFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wlp8F7gBLf4zPGgPvGWkUjxYsqi34bIhR+HGFlq7XBY=;
 b=MY25wKEn29Ax2Kq7fmLohzdZs/e2Td2dAHm2nm8OWjOy4M9UkDgLqPf3+h1Ws8HS49fPhJ8clxkjKNjSKGmGEE3zITuSD2X9HiWqEDXuyIH0vGAiM81jlELzqsBFoLDKf8BBJ5sVng2LWuHT3zvefwbd6UUle7k+PFYG+EMjFQpON0sPC3ttPohJXb4dLIgPXbeN9E5gNf6LFKRXdm3mjcNY/d+V0LZVcTzM7s/UXsNMARzLGYpxsm6Y26UYR3jDt04X3jK0Znf++Fx4j6uQNMS6Y2pPRIL9FOLcg8SXPkslurpC18aQylQz5gsKNNtZkQul1VDkQaeUNXIZt+8YAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wlp8F7gBLf4zPGgPvGWkUjxYsqi34bIhR+HGFlq7XBY=;
 b=RujB89fhkxUrMOLvVUVhqYD8mhc1p9wDVXYlKv/VMTnm4K/bsNxJ5JsQs50EZ89AkogaL+z07a3934e14S5gSWrFl0qQArEfOXiV1Hbcq50+CnlIS88w2QNbt0N4JPPoItLzO63XBvf9GMg9BY5qb6/Qj757myCCG3R+kZ65Ze8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB7715.eurprd04.prod.outlook.com (2603:10a6:20b:285::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 15:46:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Fri, 15 Apr 2022
 15:46:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/6] net: dsa: use dsa_tree_for_each_user_port in dsa_slave_change_mtu
Date:   Fri, 15 Apr 2022 18:46:23 +0300
Message-Id: <20220415154626.345767-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415154626.345767-1-vladimir.oltean@nxp.com>
References: <20220415154626.345767-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0091.eurprd06.prod.outlook.com
 (2603:10a6:803:8c::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a768e56d-145d-4389-945d-08da1ef71fae
X-MS-TrafficTypeDiagnostic: AM9PR04MB7715:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB771548945629F16784467FCEE0EE9@AM9PR04MB7715.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdxvAhSgT77XqVV6bNDOo6dKB8b//DhJnxEx3fia/2C5Q3iWxZK1GRYGhBZN4Nho5Io00F+Mx5MYsWLBPi2jeE+g/9bt8AOtRUQQiy0EL3jExrc7wq9r11SsW4V7j2WoZOnd+EtpNq3632UFqvU7t+RZl89GnidDiIOCWExIHV1/OCLzNRLz4ClmLOYzdwCu4j9/KEfbQAyxNs/TMpgyq0/4JntyZK1NIlz3JD6rhuaaUvxkLiP9keVjsB5PiEnB8vdMRv1BwoCD8K9WxeG5XfGjY9SKDrqGBIe645h2TMv/bdTF0Dtjj+qMQLOORCP9O/wcGY4OPRWfvASyW5kDYS0G99YCTtmCdOU0fDuUS3zUxNtE6puqqKwXhnkrIl5S9HGYzh6BENcN9J0bRc77/fhvX93eYRwhyoXlu3fbZakR+k7tb50Jto6ySS8KtWe9+SFzWBNptcH6ffPcxRXsFsquVgCKyQ5HPQpwsqfxKCCVAlG5Pr6XQ4uwvTTo7ysqgFI0SmqPPXDMlMErhr6YGRRDnXJp+NXpUHq9dRHAdhQ6UiRWhbo9GKykPmZgBLVQ2FFiwMaTiF/2fC63Z2ZC2PTYNhPLdmqjeK4i9LCmpZ0uthU/nIGS4LK3QHoTfWVGdunCWvxjm+I6a156UwnPQYxASHnsJ7sAU5RT8LhaQ+GxzVwupKtkI6vpHbB42vJEMt/L3qKBi0Dzf2UQ9mzLSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(38100700002)(54906003)(6916009)(8936002)(38350700002)(316002)(86362001)(26005)(6486002)(2616005)(1076003)(66946007)(66556008)(66476007)(8676002)(4326008)(6512007)(6666004)(83380400001)(2906002)(186003)(52116002)(6506007)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3oKiKeG11rB+dqiZVG3wgF50Gb/dacLthbeKFD+Rep5qVKF0vVZ5InbHOKTT?=
 =?us-ascii?Q?V3mJoZ8q7JM4DZ9WR2iiQwm2oHYxWKkh+RQVADBZcMTkaRgVau7RorgOI0gZ?=
 =?us-ascii?Q?IozcylsgRm14Unw+DB27dI0G5HBEoGCim51E0uAlxGlPbTnCpUHmvVrTLjlh?=
 =?us-ascii?Q?e3mY25hQxPFvWl868ATDr7CtaKmKLre2Mi6XL08d/aiSbaDPVtxQtJsz5oNP?=
 =?us-ascii?Q?m1uPOD/dNtlquz2Y+RLhEcpM13HpvfeKJA8N7CBGwTVsFIs6ab2uPR9i3AUu?=
 =?us-ascii?Q?7kSs1sSyfA9cTrVB+nyXl55z2uVlUJtVyIHtrsLzCnqD2ZvoaMWSvdPTWIpV?=
 =?us-ascii?Q?Pl4BxoWNuFLFgxbAb6L9XRlVmjZps+ApV6AdlClhPTZyKp08a9/5CJUgpa4+?=
 =?us-ascii?Q?KKhMLEUMjSkRliWE06+Kdlw/wkBW2s5jZl85Z6uFLC7znnZLia/skMSJisBB?=
 =?us-ascii?Q?eiC5wztmI7du+4yX0G4msL5OHelFAGQNfrurtgDz37nC/VvEWuMql7LumTUR?=
 =?us-ascii?Q?y1/Pv/5oCNRc74jAUgOYIUppoSqPzE9UGEcmAcA99eA97BY1NezKQcW63mHd?=
 =?us-ascii?Q?tMY2OS4Uhm/UEzSA2vusgZB6zBivls5F7YWjnN3E5DECsMFXoi79mLd9meNX?=
 =?us-ascii?Q?9ejOeAGTItbvZszvxbeWx5duRjarjmKdBgbTkMrqtWr8Hs35T6ce3AXfGATT?=
 =?us-ascii?Q?TJ/wlmaaWXtGqOgXuzQDBmXSobjElVR2EKCL0UMXStgQbtLUGfuXl1LQ3+6Z?=
 =?us-ascii?Q?9Dae5U21wUIu/qepevTIfZ8h4UeJtJhAjIS83iRUMDB8yafTs/kMrB3jmmiA?=
 =?us-ascii?Q?10lsWxObp9Aisptuuvrin2bdCRDb1UBueMqtzwXUuBUiUcBno4ZD1sPbUsco?=
 =?us-ascii?Q?FRO0Ia2nmDMa8pWfxU1wLQCEBipkiR4IcgJltjMCPTFcrt+D9ZDPI6QC7XFO?=
 =?us-ascii?Q?s+MaPRqwgS/aN2uxM3Uxpxymusu4FIag0ynF/KbEh2vel8Jkb/GYSMbuGsWh?=
 =?us-ascii?Q?246BDgWN9z0ANx8YfVkPjZmxsAGM718p7prWlhvISjndc5Wvb4VjbTPRxxFr?=
 =?us-ascii?Q?y202+OzoRY3PBMKvOVEzME/cKwNdmfxCAFXls6QiF1NmkkS4pEkUYpYYcICj?=
 =?us-ascii?Q?JvVkPckEo/4QY7FIaLYX3u29w0GrjBbFpY7EHdStoRnUxmrMR1a3XxRJmLrn?=
 =?us-ascii?Q?DSTRt8tqygk/UVT72Bt97pL3j0NV4hNG6z7sYXKcMW6ISZ9rPTRZtR9wqMOu?=
 =?us-ascii?Q?SitHHXFoYJRIBbVbCIRG6DtasbVBm2tyd/KdMC4q8E9d8o4ZAQ3Igg2YPAJu?=
 =?us-ascii?Q?/AOogCRyG23cEXh5oKdHk24aY7NIMSfCVTw8L0mq/Dp3NyhNczvU2deFOiXW?=
 =?us-ascii?Q?l+582yVkb5KhGLYPxxriDYU+ZB9j5aVaJefwpWAfy3CctdK4ZCMIRqwdOwGg?=
 =?us-ascii?Q?oCjG7CvRaPpKT14W6NM/XO36BcsP5rHnjvsoPmuetMmxzZbXtXdxx7/REmO7?=
 =?us-ascii?Q?49a0ACpnPS7t4lSM85JPcGvl7SxOZEBPlrqV0bRUf+pyuojtbPX+GFZHmC25?=
 =?us-ascii?Q?sUtrBfzWxzFoDSUWvNSBrfBP8qXPYcIcdB4MOR94/fg17OvRyQdZ2ndvdF3t?=
 =?us-ascii?Q?xJf0it8XaLy6LcKEIcivmqX2eLMd5OQpVmDdcOEggxl5ExhSigTDmX8izh6Q?=
 =?us-ascii?Q?17WoPkLIHsHrGWtiTcjbOUe35bRRx6kGZwBV5Isqorq+444p1iz5XC5+clH8?=
 =?us-ascii?Q?6qSPWDrSq87q8eUnte8bJZGckx5J4H8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a768e56d-145d-4389-945d-08da1ef71fae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 15:46:36.5043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QibAV9aIkmVlywh5WUdXQ4Qa+4L1m/CPfcoM3A/ShWDqVNh1pmgcC1M8UK2pvsPoo4Pgt8vd1rBTBbMqiJl1lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7715
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the more conventional iterator over user ports instead of explicitly
ignoring them, and use the more conventional name "other_dp" instead of
"dp_iter", for readability.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41c69a6e7854..da234c4b7daa 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1808,7 +1808,7 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct dsa_slave_priv *p = netdev_priv(dev);
 	struct dsa_switch *ds = p->dp->ds;
-	struct dsa_port *dp_iter;
+	struct dsa_port *other_dp;
 	struct dsa_port *cpu_dp;
 	int port = p->dp->index;
 	int largest_mtu = 0;
@@ -1821,26 +1821,23 @@ int dsa_slave_change_mtu(struct net_device *dev, int new_mtu)
 	if (!ds->ops->port_change_mtu)
 		return -EOPNOTSUPP;
 
-	list_for_each_entry(dp_iter, &ds->dst->ports, list) {
+	dsa_tree_for_each_user_port(other_dp, ds->dst) {
 		int slave_mtu;
 
-		if (!dsa_port_is_user(dp_iter))
-			continue;
-
 		/* During probe, this function will be called for each slave
 		 * device, while not all of them have been allocated. That's
 		 * ok, it doesn't change what the maximum is, so ignore it.
 		 */
-		if (!dp_iter->slave)
+		if (!other_dp->slave)
 			continue;
 
 		/* Pretend that we already applied the setting, which we
 		 * actually haven't (still haven't done all integrity checks)
 		 */
-		if (dp_iter == dp)
+		if (dp == other_dp)
 			slave_mtu = new_mtu;
 		else
-			slave_mtu = dp_iter->slave->mtu;
+			slave_mtu = other_dp->slave->mtu;
 
 		if (largest_mtu < slave_mtu)
 			largest_mtu = slave_mtu;
-- 
2.25.1

