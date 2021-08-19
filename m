Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F7C3F1BC3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 16:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbhHSOlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 10:41:10 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:12417
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240502AbhHSOlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 10:41:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2fRgJF8bAW+WZ0xvXCahvDDK9uVrpag/KW+R6uQK5iIuaCbvc2XDmm3tc0+7EMu+R/sVDSEa8a+NDQaDr/a3uVRYye+q9JAjwfEHysNjhD2S5HXU/pnd2JPbMn7KQ0jTwXEXWox/MvMAjEAWbKpx8FGdcAtvPQ8JE0edyJ9q7MOwoEL/ZagpZnid7GnjlsTkG8qXU+7QaOpHZZ/ZAk8+Aug53Wi0QRt+/7a2RPbHpA8k1tzrKy8X9s3Sa4gO0hawFcnKYYFnzQinLvJCoherwyA1oIGXyFuPxhIacVGUgJcHnuMWRijRx3Zn3+4QIlz59tV5/1+m4NZnwdebqA2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGyySDfjarJHWzJji1aR9wy62mG5p0lJK8r0issRozU=;
 b=RtLBU5OVp5LaiZEm8Doh6oAc2vt5o4/lZAB8zk3C1MesjfPxtHTKeZxFphM7rK0MRFmMiPvdWVyH2axKTLm+7SHaFe0FxqVlNar54ElX+ldbQIQRFT16cfzHMECTlckQTMFTj1PEx6J4zvXRnthwAVb6Tk5VnNReWsjiD/KBJ4C7ojku4oqNaf5BGZVoRWoq6BCGxSI1dJRQ05kAJHgWNTSGwGKMxpP12wdhGsy0Lp6FBPZvKddpBgdQjFqYV54+IhGgMhjL3MVch9Dm4dOxTQHsmbrHj449bfFU9OKggl7PeGw8UBb3QPPE0yqU6LcT6qRDeDr6DrH/F8UZFg7m+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGyySDfjarJHWzJji1aR9wy62mG5p0lJK8r0issRozU=;
 b=AqbdsZPb1y+BKtSBuSCODleQqEp59PXPDl62O5WkcZYo3IQibAq1Co1LuRXr/Ne5MFj2imaB9S6GAfIi9/vz9ECZm99wbqccLK7bREMo8mLY668DNO/JdPg39VxfyfBe2/w4Ilqk8AUKCeyBNFssa273Wq7V6SbfT9wZV8ywYME=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4430.eurprd04.prod.outlook.com (2603:10a6:803:65::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Thu, 19 Aug
 2021 14:40:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 14:40:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/2] net: dpaa2-switch: phylink_disconnect_phy needs rtnl_lock
Date:   Thu, 19 Aug 2021 17:40:18 +0300
Message-Id: <20210819144019.2013052-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
References: <20210819144019.2013052-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4P190CA0011.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 14:40:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02f41a4d-01e0-481f-1fef-08d9631f4b35
X-MS-TrafficTypeDiagnostic: VI1PR04MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB44308E851A0B30001803A688E0C09@VI1PR04MB4430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgVKgNaEctFedjQWaa6e7MReiP3/qttOYfIFuK+0Ev4cHaMIacdSq487avtvsjP45BeSFJVYwc1BA1oWNwJ7AfNHoXf4nWlmw1WNv5ZulIGmpi84Lug05PfEC4ENon5vS7QWCwsEbMYyx9S7igbYYsmefwwdtilrIMvdkiBWskasdu1PV5Vn7ujj+DhE96mxH9LWMyHQ5Y0sy8BDVQhiVJHZGGaFvrzsO3ad+E0v9L3w7/CR/xgpUtVWo4/Syp0FBzXp+ta/sVR8Pju49+/0noUPpuzfCpHvJqI0ZYL7WojPhjj16mGgBw6lxnc23CuOWRwKg4QQQ5NdUDiLDvplPhf0GYCbs5oaCczZrf0x0QXJQFyABkN7k5w10Uy/gjBIba6rHYEZVEbLea4tNpdXpOT84RVURv2ZhuJGlIUUhZpqegpZRB35DwyW4gauCttOlHHJYW1E7ECAFgNyLiPZoBJM1aJWpqcu8a6oPPsOxkAFRgwgtBdyYK9RzI8REEmOPC65oci57fKiuwgKtnu4hqnND2HLXNv2kZyaectKRgNu9gA3BOLmKCSTt8f+juke3wlLbVF3QBuOOFkC38sAjGpoSXA1VlWBBfxnPq7fNT0SfRbC/We2pcLrXwL0DPC2q3HZ59vDpte3vq9lLvwB6vX30EzrunMRZFA++ie4ne/puhiLU/RVYSZouLuzwoVfpubb//guDpF8OlqleEVoSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39850400004)(52116002)(83380400001)(6506007)(956004)(6486002)(36756003)(316002)(38100700002)(186003)(8676002)(1076003)(38350700002)(6666004)(86362001)(110136005)(6512007)(2616005)(66946007)(478600001)(66556008)(26005)(5660300002)(8936002)(4326008)(2906002)(66476007)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PROAXSJ2oJxHmkSySxsHCDEOBomGDDaUwddYi5+a1mSoKNMA1ZhFVflvPo9A?=
 =?us-ascii?Q?2qsjpyxotkk+oQWgGxWbZXqmqGxlY/21USPkAZIssMUrEI0XhLePGJWh8G4/?=
 =?us-ascii?Q?SpNqAHHsFLQ3mVagL9bXD4/gRQ+EstjCr4guipdQRf7//LwIQa1Fow08U6O5?=
 =?us-ascii?Q?3CElebzc0Ds2yK8YiU1mg0kj2gC2Wbm2cPKi8fIMkLIPVIRfnrYTmNhqT0Nk?=
 =?us-ascii?Q?qQTcBMyCho8Bk/gRFWvjrJ4afkfR6O31djkij4UZTK2ht+FtQCEU6kx4oyKo?=
 =?us-ascii?Q?Z4cORuO+i72oPWMdyNc6lcXUA7faimZfGYUksp4aVSCPedX1KgdayUdMr3zq?=
 =?us-ascii?Q?znai9u2ClSODmVnU94gSU49wrPU121c5i1aqBOrR9EQpevX8mHJnHPDpkRZv?=
 =?us-ascii?Q?ZjgwBR6L0JPxN+ypjZHUb4TPxaLmYsJp+knYUmhQtgG2quEQk9P5Hijve6fX?=
 =?us-ascii?Q?k8tfLLJ/0QNqQCZ+Og+3GMhiRxb/A6iOVK4GnK+VJqIjITUEQiphgDflyFvC?=
 =?us-ascii?Q?W6h/I53SqhOSiXfB1yQB0XR7J330IKFzcKnB7Ly9jv2a3yKFMjhOkaiEN1Na?=
 =?us-ascii?Q?7Y5C1wEbkSRpDZjLrfsTmO2m9W44VxOXtTRihkmtXDYWwN8MyPR30oqbzTqi?=
 =?us-ascii?Q?kRhje46s22z2NLUE/HodHEsQmQTv99f502wnEXoULONglHREieLPkhhGf9w6?=
 =?us-ascii?Q?vyuPGoM2ahbHB0N5kjhvvtCS1LE9+oYNKnJdWvgXGotT8f41dSda42CT4+Il?=
 =?us-ascii?Q?FheDfQ1zkyxQ3HiTP19xiK4jE8z2hsBgv/S4J4eKXkumhT7YXiJjVJj1nLtt?=
 =?us-ascii?Q?Yi6PNRFBpKOoE5RQW7NvWOp9najV0JASWdYht9buXNbUAbaAL2T+QZ9jSB55?=
 =?us-ascii?Q?CJN19qb2hyqNxjuT5EHy4iGar15EXNVReMCK+tGixpAdx9lFU/uDWfb6aWCu?=
 =?us-ascii?Q?YAx83Mp77CansYBFdj0DEc/COBqsLZkpbh9b8zUD+twbrP2NsBmE0Hj79gBP?=
 =?us-ascii?Q?g/Lxs5FPGNNffD5ZJ4GVw3cp5/QOl/e6x1Vbbg22CUQRbUL2/I0DFAgPPeTt?=
 =?us-ascii?Q?bLTOIPid4Pt1cfcP8666AqnyPKQoicw/cWnTF1Na0yc3iEPcYflIdE6tDdOK?=
 =?us-ascii?Q?UPugidacq7vofjhQuFGsxPpKfZuj1i6tPPk5KK9S+YyMLBUJmyhkJ4ITUhPN?=
 =?us-ascii?Q?FbQS8GMexezCB5h5qDY9btkrNVr9q1xi9+LxugrpUy8Ef8lwbmep2k+QdWqu?=
 =?us-ascii?Q?yQpaXklm/Nd+t3gOzU8FQHFldz1xkjH7lNm/Z4Ns4D9Qszi4LE6Gm6w3FxLT?=
 =?us-ascii?Q?Bjlrzh+TfJiNgDjRm4DboEDb?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f41a4d-01e0-481f-1fef-08d9631f4b35
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 14:40:30.7783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJsCeKy0rrkVi9+LbHNJAExs0y2gela/mo4yVb8pslk1doWft4uNsi7n0bhE7HzYWGzcBuJmtz8JmsLGqvWGiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an ASSERT_RTNL in phylink_disconnect_phy which triggers
whenever dpaa2_switch_port_disconnect_mac is called.

To follow the pattern established by dpaa2_eth_disconnect_mac, take the
rtnl_mutex every time we call dpaa2_switch_port_disconnect_mac.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index d260993ab2dc..d27c5b841c84 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1508,10 +1508,12 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if (status & DPSW_IRQ_EVENT_ENDPOINT_CHANGED) {
+		rtnl_lock();
 		if (dpaa2_switch_port_has_mac(port_priv))
 			dpaa2_switch_port_disconnect_mac(port_priv);
 		else
 			dpaa2_switch_port_connect_mac(port_priv);
+		rtnl_unlock();
 	}
 
 out:
@@ -3199,7 +3201,9 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
 		port_priv = ethsw->ports[i];
 		unregister_netdev(port_priv->netdev);
+		rtnl_lock();
 		dpaa2_switch_port_disconnect_mac(port_priv);
+		rtnl_unlock();
 		free_netdev(port_priv->netdev);
 	}
 
-- 
2.25.1

