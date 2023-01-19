Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E82673876
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjASM3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjASM2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:28:00 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAC561881;
        Thu, 19 Jan 2023 04:27:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYXtayTZCzOdUK1jkN8UttvOTefqzqNmm5memK2j8JOVO+fJKbKgxQCi7JMl80QPoM34YuS+8MdMPIvLeFnTPP5PFb7WUTHahGMldqBARKnHYPZKDWFKaCXH7jBKbtkaOVTglF3cakxHisRx56zsbn6HFAsbpfGJQ+64AIf55HMcjiyo09Tjh08D+0NQP4QPoFCLrAUR6lvskMwkLIe0RCh2beKSI0AL1HWW3K1bC3qzQzLNonsjB7zNTHeXEUCJdPDZHNNRW8iLMkJA1B7lHTQp3MxnUNtfXLHFw7FYfPXKDPMZGl3jWwT0aziR3p2STV5pqORSDddAepk3vH3vSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPIcQvi5NyHzktP2rGc9ZArsLGcxMx4VnLiCAyCPHG0=;
 b=kC81kyEDbIhXN6zYcIho/NlGUwbC+S0hKTEgMcthsjj13huMfX3nM1j3ZA/QOeMzYPTB0zBEBeRqP+PC1dgTqo83wSqxxAOZBbMhX1LJA7Ej1UTCrRE/iNtQi5nYQepxNkPsNAgjDzQI/3hf6joCp3YIcyVuQMwGMuFIEckaqdxPH9fQSB5vaz2aWU6s/+YuDsyawszuXT07E8mBYFKZphmPQ1haZCnYeahHghKs/yFUYLnpmGOgFR4OTIeDWx+h0W324fstfnwR8Ayn7P2Vk4ZErEu64AaBRfbDRmDVC9W3Jb3GFPEJ0EeRHenT8QXRXV7nf3v7R2HK0hnREUPM9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sPIcQvi5NyHzktP2rGc9ZArsLGcxMx4VnLiCAyCPHG0=;
 b=rc9RlvrpD5PTkZDQUB/17bYyUWE5jYVevCPnl+g87SUp7IDC30Xps+2RNBHW0bp8zL7GLBaT9EjUkg1Ugj9YkYZVOzyrUz5jU3wgYxGRgtzx04vU7TAOiXcxUPer0sG/N/WMuG+5iey8w0ECOelRs3Fd6T/cBTUOFSdRZ1jqbG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 08/12] net: dsa: add plumbing for changing and getting MAC merge layer state
Date:   Thu, 19 Jan 2023 14:27:00 +0200
Message-Id: <20230119122705.73054-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eee1fef-81da-4433-ca0b-08dafa189783
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjoeoFpcVaQTnu9DVHYqIhuj2bwzfzfUk0Z+2dsfWMyhnuZqr/ad2N7NuORauDq5b6mbGnGmvVZbK/wgdlg1Kzz0JRciIDjJSoT3jSXSqni6Du9hWBnb1sGgA1/1Z9hlQ36AXkPTEV7WvOPJXO/ikR01fAcTM1ibiqMJ/xKmPwHAWTr9xWeEfsUiPTlUAflyoTMg7oh/sHhlB47lVHT0yU6dRS2ry+zcST4afFZdiaOpkjEnczPQHh6ah7lRphb0wjhEXGm4cv6zXCUlSX6jtwBi8Q+66No2+9GSRxYUvRENWro+2As1AVf+05B046eyJ1BaLUmBtznEwh8B/TLK5xsDfXrSFe0YbhuzpVSLQAv9pBI8y97lTyKQ4++s5KjIvo/YuKRn4013lq9IKQD+DhkTSrIQQE543zzP72cpcEepPuvRbyaVBge/D9RxaXYLeNY5lDzn7M3ZxP/AvvesAP+7JI5Cnviq6d/GUdThfcpoqkGIz5fEARCu2Ru4IwromFFN0oMgKJQFEv3tuVEeZziqVAVfManmybm9pMTzp2oenHLhQUp89hYAq/Di21yrk3LvMbvw5Lz4e4NlgzciNVbNlkUc8o6r4iV0yZgcpXVhBs+iGhOiGmGZa8wFN8Ik1lRKcvQdnYL2yLMTZvGViay2miwwcEZ6Houecj3VSlMwTU99Y7LwY2P8wElTMXG+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ddfmVmLknLXrJO1IXHgLgCzh7G1sgmnz13VP0Y/AovAkpnJ7FO/NRucx7eX7?=
 =?us-ascii?Q?tFh7zmVFyitgSLNGogll9NlPi0WdFpQkarM3hgsBjoblfOax6SVCy9t4cYv/?=
 =?us-ascii?Q?6/3NRr2W64lkk9uckdGwH38bzlcEjwYhhLO9idMvFqSLN5An9+CpRGf5NkBg?=
 =?us-ascii?Q?xddOM+rOK5G5NKu9Cvnl9vn7/vm7dKSu69xeNhgmxgtAqkPXgjGqhmBB+7Y4?=
 =?us-ascii?Q?jHTn1nzcd/l+Z/vNN1er5GWStCeMaHHhY9EQq3HiwtI8NmUT901bEtsN3DCv?=
 =?us-ascii?Q?xuLaP3AOupjF7KwGPrJIoBviHTzWYV82NZP2OQqvI8xFutuSl5UoXLmUDXP2?=
 =?us-ascii?Q?Daca5ng5gN2qMawNZXHVtCI1U+cKkA0qQwi8+BZb/OOuoqYi6nswqdAU8/JU?=
 =?us-ascii?Q?bGeEosxVgD3PR5v/6lO8TXF6YmY246WN6mp9N5CVeLY1WmsiPIbgnUpvtgC/?=
 =?us-ascii?Q?7SAlYpytmEl4ikE4r6pDA1nSrXruZqu0UXRi7NMyZJW7wi+wPVaKe5997IOR?=
 =?us-ascii?Q?lJxrkHo8CcnCsuKc8wHOhoHYyXIgKcyPuX/NWSdW+DqkE3OwAFGsw74EPXpC?=
 =?us-ascii?Q?lTkwdiCSew87QIk441/ao9DTejZEyBpOO4eQ//Pxxl5gkVOCyVEUOhCaIWSx?=
 =?us-ascii?Q?/e7vXRR6GTskak9GM8voe93BtRh8YMlTamimS/MkmkgtdJxx9TcZxKy2n1yj?=
 =?us-ascii?Q?bUd6gy1YDHJOenbLNk9maL1iAPe0NcbXYm4FnY7gK8mMpZV2LUwommTraVnK?=
 =?us-ascii?Q?4Zgwh25H2OlcJNkTZZZfnltxRc/+kRCEJeGxjxu0ogXmyrNqcsOQoIPe6YGW?=
 =?us-ascii?Q?aIsMv/puesECtIFk0S8B8oE8b3C5XiYTaScBVG9q2ImFph9cIB4Aw9zBYp1v?=
 =?us-ascii?Q?BkuIwWiZcokXR/EYeEk9u2RfqNQX7hPRbDxE4xQf633f6lZ+YzlEJXn5Sx+2?=
 =?us-ascii?Q?GPjKyuFwm2IVHkBVJrQZcKrZ2jfkt/XhntXCzr19kqbtnAo4XNf0/dXZ7nPL?=
 =?us-ascii?Q?W06JZX2Vuzix9NlwO8I+BJLdlzCWDMGijhgo9khK7OJ85C5kOopEQuaLMDhs?=
 =?us-ascii?Q?7Xt71YUeRTT2L2q5hfxW78I8hbjjj4wrpyhjDN+uvgF2CrW5TDKiNm3/+Pz/?=
 =?us-ascii?Q?f7GNKbNGtbaRXnZ7IYtL+9s+fRV/Z72SRXIUD3rsmOJuIi9qcKR0fz43Hm1m?=
 =?us-ascii?Q?ssMO4mRHKiPgEhwzs4Cvdx4GqV+k8JuAft8TDMFlgXwKcX0bv5hKLyapaakM?=
 =?us-ascii?Q?jmbyEbtlwqlmBVycPEdMZqTZwV4Vyj0jmSmWc2PEcNEQSkQYljq+DVbJlPrt?=
 =?us-ascii?Q?czgOS1dBg4RMuBsdLgEQsljHzkrccILEy2slMb2KKBmG4VI+g4fV0IP38g5h?=
 =?us-ascii?Q?mv1J6UROdPxhvoTMstTm4QquArU1d5GCcEEKbNnzyDI8FJjlDWHytQkXXP6m?=
 =?us-ascii?Q?X4uf6kCIHua3jocKeCFLAvVWHV6EJwCQdTpvxHFI8Uh9pMCewrhzAxhmv2Vo?=
 =?us-ascii?Q?Gj0W9dC8CeDxk6ouNfSjnlH2qeaW2UvZ7i1kv4+th3UnJ6NldbFxzms1v5/f?=
 =?us-ascii?Q?lXpiVkdJyfAsQeL0J4ErWpqKKCUXrD4BisMkd67/w0ab18Z9d/Tg17UCIVQH?=
 =?us-ascii?Q?nQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eee1fef-81da-4433-ca0b-08dafa189783
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:55.7470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcPdSK7vC7KHWqyFmcVdS2TcNBkUz6Hf//PeqiJhNYDfbiCxc7nbSP5remNXaYNiNpx1puc8l3jx+Y7wfFwbpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core is in charge of the ethtool_ops of the net devices
associated with switch ports, so in case a hardware driver supports the
MAC merge layer, DSA must pass the callbacks through to the driver.
Add support for precisely that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3: get_mm now returns int
v1->v2: patch is new

 include/net/dsa.h | 11 +++++++++++
 net/dsa/slave.c   | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96086289aa9b..a15f17a38eca 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -937,6 +937,17 @@ struct dsa_switch_ops {
 	int	(*get_ts_info)(struct dsa_switch *ds, int port,
 			       struct ethtool_ts_info *ts);
 
+	/*
+	 * ethtool MAC merge layer
+	 */
+	int	(*get_mm)(struct dsa_switch *ds, int port,
+			  struct ethtool_mm_state *state);
+	int	(*set_mm)(struct dsa_switch *ds, int port,
+			  struct ethtool_mm_cfg *cfg,
+			  struct netlink_ext_ack *extack);
+	void	(*get_mm_stats)(struct dsa_switch *ds, int port,
+				struct ethtool_mm_stats *stats);
+
 	/*
 	 * DCB ops
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index aab79c355224..6014ac3aad34 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1117,6 +1117,40 @@ static void dsa_slave_net_selftest(struct net_device *ndev,
 	net_selftest(ndev, etest, buf);
 }
 
+static int dsa_slave_get_mm(struct net_device *dev,
+			    struct ethtool_mm_state *state)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->get_mm)
+		return -EOPNOTSUPP;
+
+	return ds->ops->get_mm(ds, dp->index, state);
+}
+
+static int dsa_slave_set_mm(struct net_device *dev, struct ethtool_mm_cfg *cfg,
+			    struct netlink_ext_ack *extack)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (!ds->ops->set_mm)
+		return -EOPNOTSUPP;
+
+	return ds->ops->set_mm(ds, dp->index, cfg, extack);
+}
+
+static void dsa_slave_get_mm_stats(struct net_device *dev,
+				   struct ethtool_mm_stats *stats)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (ds->ops->get_mm_stats)
+		ds->ops->get_mm_stats(ds, dp->index, stats);
+}
+
 static void dsa_slave_get_wol(struct net_device *dev, struct ethtool_wolinfo *w)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -2205,6 +2239,9 @@ static const struct ethtool_ops dsa_slave_ethtool_ops = {
 	.set_rxnfc		= dsa_slave_set_rxnfc,
 	.get_ts_info		= dsa_slave_get_ts_info,
 	.self_test		= dsa_slave_net_selftest,
+	.get_mm			= dsa_slave_get_mm,
+	.set_mm			= dsa_slave_set_mm,
+	.get_mm_stats		= dsa_slave_get_mm_stats,
 };
 
 static const struct dcbnl_rtnl_ops __maybe_unused dsa_slave_dcbnl_ops = {
-- 
2.34.1

