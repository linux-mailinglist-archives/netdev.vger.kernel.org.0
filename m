Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABABD5EF113
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbiI2I7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbiI2I7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:59:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2117.outbound.protection.outlook.com [40.107.223.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6377C13EAF4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:59:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlmtalSLSAG2i1A0/mDLIeH2B9SKvCK2SQSEaOKFNCu5ju34YXB3Fp9zg5BAJpBExoXip/uhNO23vM07oPodbKyhU1JTdREwG9tZCKt0T1KiZZfSrh7RUVH8OaxoNJm6Ceb0SvAfEjUeAvw/KkZEcqYZ4cLzeuXpR9+VEFCje8d3WnLKwbVgbm7ax0M/L/Z/+5W8L/XzIau79OtlXW8Y3IQPXmQNXQOX7scXIh+ZoIq3ZbqvLA5SCQO+flsBiYQQHWgYfsz93Ft2bHGTpYOqe32nJ8CGs2kncDopIQu1VxXFvGO15Vr0+6pTIXah2XEoKfmeeuUR2Fl7lKLLOsguhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clhz0dJs2A9w8BZrPYGZ6A9jedoEeB893xPGevx0jX0=;
 b=DTRUSm0Wc0EuE+YTOCJhd83sL1hIeUhm126sNI6eE0JgNhCIzwLJPn75beX12sgyspaXVUqBeecWrL69g8io4/+awIO31DwTJ0VjejI0Fj3v3d80Tz9bp7kU+lVJrZo+2slfmKaJ9HJqdUpyjX0JLrQmgL9PNc5RauYr82P8kLrWa62MhnzBRUw6vWtETAg4oUOfiIlus9yc5WltP37j6STxUYHBCbUUuwwbKIYyU2C2zHcL+4sWKaevZD5PJDBRzw23qTVU016e6qXbDjT22/cmpFYzFfWGNT0WYI875wwxXBQ2Yba64OpSCa60+U0pOpkn8AQPw4Jabl9jai1xGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clhz0dJs2A9w8BZrPYGZ6A9jedoEeB893xPGevx0jX0=;
 b=ez3ikjSue8iXaWp3cWCtWG0fZSRWXkGxRDsyKan3J9jO988zpzYbJyqj3nj/6axmNTyEEnAQlsu6BzXpkQRfgM686BBz7DFD0fEudu8MYgiHzI0Nk2tAOi9vAWswRFdKlBa6XxD0Th/VjmLD5O4ki9gZLl+jHPDB/fijwo/mvU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:58:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:58:59 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 4/5] nfp: add support for link auto negotiation
Date:   Thu, 29 Sep 2022 10:58:31 +0200
Message-Id: <20220929085832.622510-5-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: c4be5d6a-ec7c-4e97-1598-08daa1f8d928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WC3KyEN1Re/lqXZ4JzoPgsYOrt+wm2m+p/RJ5FQdQAomLOGa0WhKIuU40ySeRJC292cPcDz4y5kVPBwrei2Y7UxC6O6beOPsiBbyCHG6au6bDMAIXzNx7xIyDxcAPJq3MNCLAlo+5TEN9Mj36YQmrT3FUeqQf/y5JKP7BN8xjwJVjrnrAvV957z1qVePQ3H+aS1/Lql9i5hRnLjskAd9Fjlkc2dKHsiYyN/F+G0BV4L4RGYTqEGrJnqek5N2I3PHuJu83euDPfoTJcNR9jJtLOlwVed+gLR2nvGICwbsU46KVyOczWxCcmoZsCifXH2ftvksuiAYKFqIJPtjnLwGb/K3EqMA5fLfcmq2KBPNp/Yp5qL6bQPBmOifhk1m9YlVxxULDQ8YXBUgEPrmAVWhuIl097LjcnAK311duUmZu41T1vVUfZYx9VGl4JJQ97+c67qkHWveXSFLsmVTPtWrdWhKU8yIzxulHBlGFHN+hNSaQwIjPfb7PqAqdWShFZ0e67BGF2Y5s0/4vtUj4nfnUd+8ZczzgrvnAlfo9QCG2cqJ1ljacjlYY+WhfhZWKFzn9gegs3vkgbvhZTVAXMlYVdsDAQdho1OOgoN5JRtJK31h2nalU4ayrZ6zS1Mzq5YFwTGbcnBjIKGyh7gj7to2Vhr5qlUgwj47ziIM8IF/nYP3gLrdpbqWiuApOzSuMBlq/qmubEAj35Ldgnz3svAW8AgfQ2i8UKJF3sZ3eF4UtJpaeCq2aPoulP0XLJfJ5bM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(83380400001)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HSSJCX18+uTwTlycjs4fbXSAszBv81VaO6Vv5ROHH3VFgUojtWoG2baBCGfg?=
 =?us-ascii?Q?4lSJ4WGIGovAVX9crbkN8GMI6qD4ZBCjtk6eFESsLnH1SDso9v/5MX2XbCkl?=
 =?us-ascii?Q?tPr0WDjj9Vr1Sxo6VNX8Ynjrwnu0DZZqg7PYRMfPtw451FDpQblSxwkNhLdZ?=
 =?us-ascii?Q?opb2rSkUVua0Ys31dRRr2Ss/hntGcjoSSlXIpkDw1rhSnjOXfMPin15GXAZX?=
 =?us-ascii?Q?St3qmqSgfre4jcUQPRYBVeNO6qYnHnxyUYe6XpkxAZekPpNdm+7sjJytjdf8?=
 =?us-ascii?Q?DPWb/rGtYX05T9K3k1qKIALnA4Wn08T39an0qW15aZZz47UQ8DGyD5Oale0n?=
 =?us-ascii?Q?CGAvsgdtxeDLqvdpvqVE95tzbzfN57QH1b1PYbgSznAncEs12JOKFjM2IfcF?=
 =?us-ascii?Q?EDJ/P52FhkM6cw6zMbEEnHv5+092k7L+1YGFX2Z/mHqFK5rVtynvRtwgr6Wa?=
 =?us-ascii?Q?E0Ca/WpHEEKK4RYy7Ug4rETa0PpL3sWimC+A/mv3jPNDcgf9ndls3xCZh22N?=
 =?us-ascii?Q?DPhQark6z8Mt3fMyGf5de1HT5dlSmHgxe9SvScD2K0RByLFY/H6CN5QIZ+L+?=
 =?us-ascii?Q?FAkBiQvS0UFegv4M+eZ145uBAXQy8dHOqiN4QhFVZiZYcGsY9dR2fI+Aid+K?=
 =?us-ascii?Q?iMSQzG4BqAlyBWN7tQqRD0CCrsyHVgJYEpd4/3WQij8UkF1N+SLSHRmP/iPc?=
 =?us-ascii?Q?hbAnClP7NlNAimJH2Lksu3B82vG8XNP8KSdZtoGaxtY5fRyz+sGlPWq6nCM8?=
 =?us-ascii?Q?wMRJw2B4TC3KTi4HyhMAIi8XfDEnReAXDdC3g8O2wYcD6FNyKF9eDvJ83UoB?=
 =?us-ascii?Q?ezPLMaf/+hoS/Z5mLsikFZ7ryELq0V6hY0fLv9lRMEwzco6oAZU20G1b2p4q?=
 =?us-ascii?Q?XQQr+eIu4Lpl+usgjxO4N/z3PgfOIyzAjUBYpc0PEz3yMLz8/9uarILXWXer?=
 =?us-ascii?Q?E+vjQG/ROqzku7u3eipDNGZ9df8pdEuHvcxKECJFVxYMdIf7QFvCUoOgvap6?=
 =?us-ascii?Q?1piwFvA1+aCUIgZhud/a5WdRk2UhDNycWI5lZPJq9z3InsdaS0xxJUxaPBH1?=
 =?us-ascii?Q?7s1CI0k6VVeL3KO9bDK/BZe+qTBXB913U/kTPfDUMLPcx6z7l5OX4FOgJQpQ?=
 =?us-ascii?Q?YudBTv4Ce4B6n+8RKP0YeVCVJ8sJioOeLMf3j6CU8fWbXZV/b7ZU21dc8JLa?=
 =?us-ascii?Q?F8WIA/oYLaWy2YTMU29CuKf9VDuMaOu576cdPvhU7tkoBOH0pwKsoZv97C7B?=
 =?us-ascii?Q?67E5k8nr1fw/WrKwddHAN9hsH3Y5dqgmshitZCJr5j2qOK6M3WDfPGL8hwgg?=
 =?us-ascii?Q?9zgY5UKsBzcPDUfWkyQDKziH/eoq8bg3sWcLqcheOhgcHp4SPV1yXFBnKW/G?=
 =?us-ascii?Q?aK/muDmTp93cb39tR96QzwRkXNNiEk6VvMVUIGrwyMpNNLz5kGE9kQauZC7y?=
 =?us-ascii?Q?GumhIsszEnZDuxVfHWfUZW0yIXSscYVhcR9i37SENCl85GYSjotTJG/H1h24?=
 =?us-ascii?Q?Y5K7+iWoc0yGCem4G4vqniIfEm15aXowROsf9/Unjlf19NiWnAcekazuPxSJ?=
 =?us-ascii?Q?CdSidPh13m40/R9whPzMNPKLoDjT9ugw7SUt6j29FPlUpd4qpsRuu3RwdDxq?=
 =?us-ascii?Q?h3FxV7RnHfKCVGfO5oBrCcAhhNV7PVydA7f0syLra+Zqy2JSZILfy9wkMEdU?=
 =?us-ascii?Q?oQ9vxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4be5d6a-ec7c-4e97-1598-08daa1f8d928
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:58:59.4840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +oXLEjxloiTW700mOAGSoUuzHUuq03WOw0NxUauS0rz5YznV8EOgzwfEtfp3fsSYhseOuXO3PnBm2FMTlSUEswVJ0P+GoGQuhDHx264AAxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Report the auto negotiation capability if it's supported
in management firmware, and advertise it if it's enabled.
Changing port speed is not allowed when autoneg is enabled.

The ethtool <intf> command displays the auto-neg capability:

  # ethtool enp1s0np0
  Settings for enp1s0np0:
          Supported ports: [ FIBRE ]
          Supported link modes:   Not reported
          Supported pause frame use: Symmetric
          Supports auto-negotiation: Yes
          Supported FEC modes: None        RS      BASER
          Advertised link modes:  Not reported
          Advertised pause frame use: Symmetric
          Advertised auto-negotiation: Yes
          Advertised FEC modes: None       RS      BASER
          Speed: 25000Mb/s
          Duplex: Full
          Auto-negotiation: on
          Port: FIBRE
          PHYAD: 0
          Transceiver: internal
          Link detected: yes

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c |  9 ++++++-
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 26 ++++++++++++++++---
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp.h  |  1 +
 .../netronome/nfp/nfpcore/nfp_nsp_eth.c       |  2 ++
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 91063f19c97d..e66e548919d4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -729,8 +729,15 @@ static int nfp_pf_cfg_hwinfo(struct nfp_pf *pf, bool sp_indiff)
 	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
 	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
 	/* Not a fatal error, no need to return error to stop driver from loading */
-	if (err)
+	if (err) {
 		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
+	} else {
+		/* Need reinit eth_tbl since the eth table state may change
+		 * after sp_indiff is configured.
+		 */
+		kfree(pf->eth_tbl);
+		pf->eth_tbl = __nfp_eth_read_ports(pf->cpp, nsp);
+	}
 
 	nfp_nsp_close(nsp);
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index d50af23642a2..678cea0fd274 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -290,8 +290,13 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	if (eth_port) {
 		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
 		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
-		cmd->base.autoneg = eth_port->aneg != NFP_ANEG_DISABLED ?
-			AUTONEG_ENABLE : AUTONEG_DISABLE;
+		if (eth_port->supp_aneg) {
+			ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+			if (eth_port->aneg == NFP_ANEG_AUTO) {
+				ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
+				cmd->base.autoneg = AUTONEG_ENABLE;
+			}
+		}
 		nfp_net_set_fec_link_mode(eth_port, cmd);
 	}
 
@@ -327,6 +332,7 @@ static int
 nfp_net_set_link_ksettings(struct net_device *netdev,
 			   const struct ethtool_link_ksettings *cmd)
 {
+	bool req_aneg = (cmd->base.autoneg == AUTONEG_ENABLE);
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
 	struct nfp_nsp *nsp;
@@ -346,13 +352,25 @@ nfp_net_set_link_ksettings(struct net_device *netdev,
 	if (IS_ERR(nsp))
 		return PTR_ERR(nsp);
 
-	err = __nfp_eth_set_aneg(nsp, cmd->base.autoneg == AUTONEG_ENABLE ?
-				 NFP_ANEG_AUTO : NFP_ANEG_DISABLED);
+	if (req_aneg && !eth_port->supp_aneg) {
+		netdev_warn(netdev, "Autoneg is not supported.\n");
+		err = -EOPNOTSUPP;
+		goto err_bad_set;
+	}
+
+	err = __nfp_eth_set_aneg(nsp, req_aneg ? NFP_ANEG_AUTO : NFP_ANEG_DISABLED);
 	if (err)
 		goto err_bad_set;
+
 	if (cmd->base.speed != SPEED_UNKNOWN) {
 		u32 speed = cmd->base.speed / eth_port->lanes;
 
+		if (req_aneg) {
+			netdev_err(netdev, "Speed changing is not allowed when working on autoneg mode.\n");
+			err = -EINVAL;
+			goto err_bad_set;
+		}
+
 		err = __nfp_eth_set_speed(nsp, speed);
 		if (err)
 			goto err_bad_set;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
index 52465670a01e..992d72ac98d3 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h
@@ -174,6 +174,7 @@ struct nfp_eth_table {
 		bool enabled;
 		bool tx_enabled;
 		bool rx_enabled;
+		bool supp_aneg;
 
 		bool override_changed;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 18ba7629cdc2..bb64efec4c46 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -27,6 +27,7 @@
 #define NSP_ETH_PORT_PHYLABEL		GENMASK_ULL(59, 54)
 #define NSP_ETH_PORT_FEC_SUPP_BASER	BIT_ULL(60)
 #define NSP_ETH_PORT_FEC_SUPP_RS	BIT_ULL(61)
+#define NSP_ETH_PORT_SUPP_ANEG		BIT_ULL(63)
 
 #define NSP_ETH_PORT_LANES_MASK		cpu_to_le64(NSP_ETH_PORT_LANES)
 
@@ -178,6 +179,7 @@ nfp_eth_port_translate(struct nfp_nsp *nsp, const union eth_table_entry *src,
 		return;
 
 	dst->act_fec = FIELD_GET(NSP_ETH_STATE_ACT_FEC, state);
+	dst->supp_aneg = FIELD_GET(NSP_ETH_PORT_SUPP_ANEG, port);
 }
 
 static void
-- 
2.30.2

