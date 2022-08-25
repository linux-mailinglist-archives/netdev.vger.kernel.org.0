Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C545A131C
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 16:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242014AbiHYONr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 10:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiHYONZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 10:13:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7FCB6D3A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 07:12:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1jRXfV3xmjAmcMnZQxzy9vycy9Mf9kauU0ULc8KpEiokcj0QcThqodD9z0hjGr13iuIP3ujdLBKLIY6T09zC9YzutWeSRy/lSsPimadXyAPdyAzSoXlIKioXj0LLIU0uvqxemIg2Yny4UAXc0vWp+aZC0FttrHgBdQqctEah4KOviGIiN90Jr8sg457qPnJxbkA14EXPglP6DWVNXxTRCE8bqn40rEgRaAmT4aiwWk8EcG3lmeSDcnPZ0du+OCF57x/KkbuNASAuaNaZ4MaEosPiA/3CO0xpA3xGO67DumsyanKHaJEVsh6w86Kb+1VhLxqEb/qOa8OcXr+SQ1yjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CmaqTHBucCBPimMPzHw6oHDsEbtWOerT0u0N9eU1l4=;
 b=YbBR+IuKgBedC80ExH3nFA+aRlfaLO8CGzDLf8JjKqNWFNbqCrxDqSbmpiUcB6itWDymgicNYPtB/HlvJQORXvbfr4nezwgMEgF6KEeMvvlpw6tnfv3ZQcjGiEdqMN9UB6qZI2eQC9atMsg76Vew4ZuBtYGim6n2iM1AnQfDnUZ9tcE4dVwmeqqON03loNlRVHFnxembwdGJkXOEhEqDpK+g/NlmdL72jleXgrJ2AM8YMzacYV37LmkFFryd06JCrDF3bgR9yIvbnOLObxzD/jbwuXn8VCHIADd5UsX3M58+5kR4UmFZIeoujS+JyreRo3apiWKNrIDpQYcYkt7+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CmaqTHBucCBPimMPzHw6oHDsEbtWOerT0u0N9eU1l4=;
 b=EQvshdQqId4IxuHgDQdNoOO4+mHMomKt5mq61aw7AV/jAqqKEqiwoXpZHf3hqyXT3D7ha2BMKhg6iQH6HKwo0pHxIktkFIbTH8582OeDFcl4KOXMEQ9JO52IaGPoi86wzJHptwV+7m3t0I2cHy7pJoVNGSj1vYg35HdRc1n/Xzc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5401.namprd13.prod.outlook.com (2603:10b6:a03:424::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 14:12:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a1e6:3e37:b3f3:7576%8]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 14:12:41 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 1/3] nfp: propagate port speed from management firmware
Date:   Thu, 25 Aug 2022 16:12:21 +0200
Message-Id: <20220825141223.22346-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220825141223.22346-1-simon.horman@corigine.com>
References: <20220825141223.22346-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0078.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3e89e4f-3c95-4cc7-f6df-08da86a3df36
X-MS-TrafficTypeDiagnostic: SJ0PR13MB5401:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwX5tAIVkJ54wXvMX0xx/OIZTkS+wejHrmpEM+KZE9CWAwFiFKqSMtQA043KiEiURbxcC2XYv8wi/5YWh1JXEB+PLgrdrcU0HDUikAqKkilYouqNiD+OjrHzAlZfEHy4TGldjThaLH9VbWzPkjzZf+LPfszIT1s/18gAvGfE8HS+AmEeL42RkV8Crw9vRXAr2wvFSx50sRjUxTFJaYO5VNCYW+YW9Qdjc2IkRupAWjoKoTqZ67W1rpj0O+mjscaXyeDDDie5KA3OpRcMmcD8GJ1WnyMNXlJXgN8uRQHSOYydukDUVVKqVsx2JMbVoFmHWGvrRKscsRRkep/PCMWDUt+4W96t7BiLxoKEJlOO2cfFEUaiFefnRyvE3BLnKMSK6UZgLF9Bpszuj6cLOE1KRvUtl6Sw3pRBbieMQXVYhJQUc4ZB5EKI2Ur9+nM21T1iOn4txasDMOG/vOoQ3EZwfqx2zNZu48GR5Mvyu4M2gWjLq2VWJB0X6Q4GtNLIw6xdy7ZpWvMmFzcC++G1yu7LPj60znGCiGo/NundtigabnD+LYg0nxhYxAjoFxx5Y7P/N2uCEJ4wFsYY2uSfgLdajLpXa7Kj2u4cHnFtmUupnMGUtOeA8JnEyJrm5TA7lZAMBErp26zLzk0RgTnf6rvmD2NRGw2nkksS93ShAZ5NwbJwRXVN+ls7wlsdTMKjsTofwo3KlTWcYym1XtlKbpBKRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(366004)(136003)(346002)(39840400004)(86362001)(83380400001)(38100700002)(8936002)(4326008)(66946007)(6486002)(478600001)(8676002)(66476007)(66556008)(52116002)(110136005)(316002)(44832011)(6666004)(1076003)(2906002)(6512007)(36756003)(5660300002)(107886003)(186003)(41300700001)(6506007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ERtrXMMpVbQEx21/q6tcmZw67a+A62hsMPMckYV44EGH9fBDy705DET3QvqC?=
 =?us-ascii?Q?o30WfhF2mgjW7p273d22FbY1VrIy54riWVaCJZ5b89oGX0Bx2FTmGLYDEGyj?=
 =?us-ascii?Q?Ii2WJ+jqwvc+ZLYMDIZkNy1HUxpaxOR/9tMsYjY3YeFkXbb7o4JoUo6iBDwc?=
 =?us-ascii?Q?4tinCrzFFASSFc6Q7ppF8DgEZtBrbKNApg8R3J2qcHOmk5mHTcD7PgsIVhso?=
 =?us-ascii?Q?kRGbTqwRgNsUJnngv8iMyUqQGNOvUmaJk4fxfUjds2pgPjQdFqfRjaR0ifE6?=
 =?us-ascii?Q?olmeMjhrX9cmFNnEUU47ecnAYBtQ3CugAC41vjkG8i3MqVdItuOKT+W9sV67?=
 =?us-ascii?Q?u2lRaXWUijrZEcxvx+EAaKYXUPRvsK8VxTYpq3IAfM4SIre2adkiuMbDXHHp?=
 =?us-ascii?Q?/dSIO+arLqnLFpk9nDGUE7TERYD4pYJW1aoONYl3gfWiY2nRxKFesdtHbAbb?=
 =?us-ascii?Q?eDdKd6xrDvBbqUHlg4m+kAZ+i45cvpkHAUjfSleiz5/MvapfNNG0ie9lXf4y?=
 =?us-ascii?Q?EMevH9XVaOg/SSnvBurViQRd4QICHvCKRQOnClnlX8fxEpsbzQBxPDd0WlOe?=
 =?us-ascii?Q?zzEfPd0yQanF5R3Lrm4feZ0XuhPL2PVzhQUrpFt0KekHPkNKWVXgfOefts5b?=
 =?us-ascii?Q?iLp2XondFjd2szUXbHZmf2VlbMPDBXrGK6omLYKrP9oj5EN2agHUy7JAXXVQ?=
 =?us-ascii?Q?EvDEYR7x8AkRaDBbkuyg+O5Ituy3zdErgZIvzshkhsvElxzagKhVEV/FV5Sj?=
 =?us-ascii?Q?KRxx4BwBDD9Yar8Iwb+UFgS4wrnnXzwJHjwA5jG9MwDfObDOOw1xAPPVMzEw?=
 =?us-ascii?Q?44/3gRbXq+eQ9GNm/P0MtVr2l7o5DZ2Bg9zHWXfK2u/mC3pFI9UAyiUut3+t?=
 =?us-ascii?Q?BkKp5CPQDvYCL9CnKIo9pMKQpdgGLNp1D/bKbTogCpVWGH69Ecl/ymwDtONo?=
 =?us-ascii?Q?DPlFbCwCnZwgs2iiLFArvjXIWVgXtrUERgSN2tivKjyJgxSpAp1X8k8ea+cH?=
 =?us-ascii?Q?6c6EnWwAN0Nj3Mv/7ChwoWyHd1+II9nnICJnrGFwg17xwiKj5iJnfU1Mr5q0?=
 =?us-ascii?Q?xj1HcRzPkZbewhGZJxxR6UOSfQbfwXEJaIGqQx2cHj3P3yU7Zy5Amje7mu01?=
 =?us-ascii?Q?3GPmpsKFVyde3AWBbRk/kui7HvIfSC0OcRojTbZdnO2+ZMsH3Be/iLsUvUiD?=
 =?us-ascii?Q?/BTcxjMnKATjtSmuOPucC/yfb6q/4Fe7SL9WtOhCu/3V5Lv+PpaGr03r1qJK?=
 =?us-ascii?Q?Nr0WnABbr0zndV3KFObS2zv/XELeuOY3P0oBRhGHRfwKoun52H7Ff0EQqJcO?=
 =?us-ascii?Q?jpIjyvn8BcX89eTMVk2vIU0kCEsrA9HEgdqUDPirGCr04tGCFFNegQ0WOeYu?=
 =?us-ascii?Q?C14fSjvWrTANlpbkoC/W0i8khkrWrjlzUyXC1owENNz6M1eqfGop8dh5uDuV?=
 =?us-ascii?Q?LYjIJ5/oeHm3G1aZNFtJDWNtC/5VrD+aXkErQCIPw77NOHUx/0p5V1VQBoFj?=
 =?us-ascii?Q?PdTHTi2pNN0UC4uKu4X9xdnDvMBn4pU5KU0W8gy5zvRO0FCman3sEg5Szo3f?=
 =?us-ascii?Q?aMSUnitWzeu6G/x0kxkUBweZZcQDCcFqIHT+VZ6cI1j8gJxQMGUXt+E9y4dt?=
 =?us-ascii?Q?D8sUnX3f4rXNih/Tr851jnDPhaniYAXeeDOUk6AJM0IvwDrsdrQXukNj6DXm?=
 =?us-ascii?Q?jBbeaQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3e89e4f-3c95-4cc7-f6df-08da86a3df36
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 14:12:41.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkCEsnumOu7dL9LrbRt2IzAGwiyd3e/BjOV6zAmmj2+ynkI81C9+SzCH3KVyrbwCXWAtMf41EXvyqdJ2epC23DmvmxplQtftPPXwOxdrFHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5401
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

In future releases the NIC application firmware may be indifferent to port
speeds - not built for specific port speeds - and consequently it will not
be able to report VF port speeds to the driver without first learning them.
With this change, the driver will pass the speed of physical ports from
management firmware to application firmware, and the latter will copy the
speed of port 0 to all the active VFs. So that the driver can get VF port
speed as before.

The port speed of a VF may be requested from userspace using:

  ethtool <vf-intf>

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  3 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  9 ++-
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  4 ++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c  | 30 +++-------
 .../net/ethernet/netronome/nfp/nfp_net_main.c | 55 +++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  2 +
 6 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index f56ca11de134..be3746cbc58b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -190,4 +190,7 @@ int nfp_shared_buf_pool_set(struct nfp_pf *pf, unsigned int sb,
 
 int nfp_devlink_params_register(struct nfp_pf *pf);
 void nfp_devlink_params_unregister(struct nfp_pf *pf);
+
+unsigned int nfp_net_lr2speed(unsigned int linkrate);
+unsigned int nfp_net_speed2lr(unsigned int speed);
 #endif /* NFP_MAIN_H */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index cf4d6f1129fa..fda3e77f28d2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -474,19 +474,22 @@ static void nfp_net_read_link_status(struct nfp_net *nn)
 {
 	unsigned long flags;
 	bool link_up;
-	u32 sts;
+	u16 sts;
 
 	spin_lock_irqsave(&nn->link_status_lock, flags);
 
-	sts = nn_readl(nn, NFP_NET_CFG_STS);
+	sts = nn_readw(nn, NFP_NET_CFG_STS);
 	link_up = !!(sts & NFP_NET_CFG_STS_LINK);
 
 	if (nn->link_up == link_up)
 		goto out;
 
 	nn->link_up = link_up;
-	if (nn->port)
+	if (nn->port) {
 		set_bit(NFP_PORT_CHANGED, &nn->port->flags);
+		if (nn->port->link_cb)
+			nn->port->link_cb(nn->port);
+	}
 
 	if (nn->link_up) {
 		netif_carrier_on(nn->dp.netdev);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index ac05ec34d69e..91708527a47c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -193,6 +193,10 @@
 #define   NFP_NET_CFG_STS_LINK_RATE_40G		  5
 #define   NFP_NET_CFG_STS_LINK_RATE_50G		  6
 #define   NFP_NET_CFG_STS_LINK_RATE_100G	  7
+/* NSP Link rate is a 16-bit word. It's determined by NSP and
+ * written to CFG BAR by NFP driver.
+ */
+#define NFP_NET_CFG_STS_NSP_LINK_RATE	0x0036
 #define NFP_NET_CFG_CAP			0x0038
 #define NFP_NET_CFG_MAX_TXRINGS		0x003c
 #define NFP_NET_CFG_MAX_RXRINGS		0x0040
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index eeb1455a4e5d..cd2e67185e8c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -273,20 +273,11 @@ static int
 nfp_net_get_link_ksettings(struct net_device *netdev,
 			   struct ethtool_link_ksettings *cmd)
 {
-	static const u32 ls_to_ethtool[] = {
-		[NFP_NET_CFG_STS_LINK_RATE_UNSUPPORTED]	= 0,
-		[NFP_NET_CFG_STS_LINK_RATE_UNKNOWN]	= SPEED_UNKNOWN,
-		[NFP_NET_CFG_STS_LINK_RATE_1G]		= SPEED_1000,
-		[NFP_NET_CFG_STS_LINK_RATE_10G]		= SPEED_10000,
-		[NFP_NET_CFG_STS_LINK_RATE_25G]		= SPEED_25000,
-		[NFP_NET_CFG_STS_LINK_RATE_40G]		= SPEED_40000,
-		[NFP_NET_CFG_STS_LINK_RATE_50G]		= SPEED_50000,
-		[NFP_NET_CFG_STS_LINK_RATE_100G]	= SPEED_100000,
-	};
 	struct nfp_eth_table_port *eth_port;
 	struct nfp_port *port;
 	struct nfp_net *nn;
-	u32 sts, ls;
+	unsigned int speed;
+	u16 sts;
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
@@ -319,18 +310,15 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 		return -EOPNOTSUPP;
 	nn = netdev_priv(netdev);
 
-	sts = nn_readl(nn, NFP_NET_CFG_STS);
-
-	ls = FIELD_GET(NFP_NET_CFG_STS_LINK_RATE, sts);
-	if (ls == NFP_NET_CFG_STS_LINK_RATE_UNSUPPORTED)
+	sts = nn_readw(nn, NFP_NET_CFG_STS);
+	speed = nfp_net_lr2speed(FIELD_GET(NFP_NET_CFG_STS_LINK_RATE, sts));
+	if (!speed)
 		return -EOPNOTSUPP;
 
-	if (ls == NFP_NET_CFG_STS_LINK_RATE_UNKNOWN ||
-	    ls >= ARRAY_SIZE(ls_to_ethtool))
-		return 0;
-
-	cmd->base.speed = ls_to_ethtool[ls];
-	cmd->base.duplex = DUPLEX_FULL;
+	if (speed != SPEED_UNKNOWN) {
+		cmd->base.speed = speed;
+		cmd->base.duplex = DUPLEX_FULL;
+	}
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index ca4e05650fe6..dd668520851e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -202,6 +202,9 @@ nfp_net_pf_alloc_vnics(struct nfp_pf *pf, void __iomem *ctrl_bar,
 			goto err_free_prev;
 		}
 
+		if (nn->port)
+			nn->port->link_cb = nfp_net_refresh_port_table;
+
 		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
 
 		/* Kill the vNIC if app init marked it as invalid */
@@ -523,6 +526,57 @@ static int nfp_net_pci_map_mem(struct nfp_pf *pf)
 	return err;
 }
 
+static const unsigned int lr_to_speed[] = {
+	[NFP_NET_CFG_STS_LINK_RATE_UNSUPPORTED]	= 0,
+	[NFP_NET_CFG_STS_LINK_RATE_UNKNOWN]	= SPEED_UNKNOWN,
+	[NFP_NET_CFG_STS_LINK_RATE_1G]		= SPEED_1000,
+	[NFP_NET_CFG_STS_LINK_RATE_10G]		= SPEED_10000,
+	[NFP_NET_CFG_STS_LINK_RATE_25G]		= SPEED_25000,
+	[NFP_NET_CFG_STS_LINK_RATE_40G]		= SPEED_40000,
+	[NFP_NET_CFG_STS_LINK_RATE_50G]		= SPEED_50000,
+	[NFP_NET_CFG_STS_LINK_RATE_100G]	= SPEED_100000,
+};
+
+unsigned int nfp_net_lr2speed(unsigned int linkrate)
+{
+	if (linkrate < ARRAY_SIZE(lr_to_speed))
+		return lr_to_speed[linkrate];
+
+	return SPEED_UNKNOWN;
+}
+
+unsigned int nfp_net_speed2lr(unsigned int speed)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(lr_to_speed); i++) {
+		if (speed == lr_to_speed[i])
+			return i;
+	}
+
+	return NFP_NET_CFG_STS_LINK_RATE_UNKNOWN;
+}
+
+static void nfp_net_notify_port_speed(struct nfp_port *port)
+{
+	struct net_device *netdev = port->netdev;
+	struct nfp_net *nn;
+	u16 sts;
+
+	if (!nfp_netdev_is_nfp_net(netdev))
+		return;
+
+	nn = netdev_priv(netdev);
+	sts = nn_readw(nn, NFP_NET_CFG_STS);
+
+	if (!(sts & NFP_NET_CFG_STS_LINK)) {
+		nn_writew(nn, NFP_NET_CFG_STS_NSP_LINK_RATE, NFP_NET_CFG_STS_LINK_RATE_UNKNOWN);
+		return;
+	}
+
+	nn_writew(nn, NFP_NET_CFG_STS_NSP_LINK_RATE, nfp_net_speed2lr(port->eth_port->speed));
+}
+
 static int
 nfp_net_eth_port_update(struct nfp_cpp *cpp, struct nfp_port *port,
 			struct nfp_eth_table *eth_table)
@@ -544,6 +598,7 @@ nfp_net_eth_port_update(struct nfp_cpp *cpp, struct nfp_port *port,
 	}
 
 	memcpy(port->eth_port, eth_port, sizeof(*eth_port));
+	nfp_net_notify_port_speed(port);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index d1ebe6c72f7f..6793cdf9ff11 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -46,6 +46,7 @@ enum nfp_port_flags {
  * @tc_offload_cnt:	number of active TC offloads, how offloads are counted
  *			is not defined, use as a boolean
  * @app:	backpointer to the app structure
+ * @link_cb:	callback when link status changed
  * @dl_port:	devlink port structure
  * @eth_id:	for %NFP_PORT_PHYS_PORT port ID in NFP enumeration scheme
  * @eth_forced:	for %NFP_PORT_PHYS_PORT port is forced UP or DOWN, don't change
@@ -66,6 +67,7 @@ struct nfp_port {
 	unsigned long tc_offload_cnt;
 
 	struct nfp_app *app;
+	void (*link_cb)(struct nfp_port *port);
 
 	struct devlink_port dl_port;
 
-- 
2.30.2

