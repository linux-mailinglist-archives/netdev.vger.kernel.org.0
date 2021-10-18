Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F115B4322BB
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJRPYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:22 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:36421
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232682AbhJRPYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUiS3FUFmvBwMsXpjoPTdMetbNs+D1Sex5OlWDnvFARkTm2gZN+swfsPKw2sGOpTxAxRL0b+uhqlDsglPWY9XeRruE9poC2N0iua8zTixag3Ogxda1JbsxKLLAGeXQggVHc2Rwd8qWyaKTKysYkpTr651n1c9VTyTnPU2j3YP5rtdX3fcw1TxB2U+EfRt+gVjJTYCzkK9fL78B6WCEVXda3pSB+lMrPU2N0jbJMf+8J2T3JyXshLPznG0u4d5yJ1YQIb71C0dH9Ih+yYrFIhRu/VqVv4zDR6CHhdTnroV/MYm67Z/3jel0hz0ju+Fgt6kiV17nlG4nh733ZcprnB4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNvwJfTmE6gGbL2cgO/LVCNohn4sHWF+l2Bx/AZImgE=;
 b=WO0i7hwIjH+IG6vCU4UmgbjqYejB3qrw+wnQ/HYRvr672KyeKYSejWDUUXbEe6Wxfxi3tetK8rToE3HaxUcsK7XhkediGa0P5+j/Mw7H87DdeLWtFg9N50a6hC2zoDRQ2WKLwqaUR6rByt5DbiAaewEhlOXteXQO02A/80DQXwmb+O84hoj48luiFxMGrMUprIhUUnsYxy8q6O8SKMpWgMxqO214B0LLsLTi04K8+cHGmhajtD0QDSFGadWR5O2b+ld5wffBSddDUOy5fh78QD0Hu7aCnPFpj9dfMsMu54SYN+C1/zlNs6N3iRhemp6hp+Z/1eSjRWieJ4zLMiYHUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNvwJfTmE6gGbL2cgO/LVCNohn4sHWF+l2Bx/AZImgE=;
 b=TVIqGoWNxvyxuQa2flQfmGb2h3KpjI8fc/rSXOXSrS4bj7U58YnL4GoNDwCw9tjJw3aPq+by14RTEDbZWvv8OnjTfbqP+zSjwBDEmhYjouhLrtCVbxqBBNwRsvgZy12W2WznMzZur3MNfAYXUUK+uJAKAJHMnSSwdQvmegnurk4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 4/7] net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
Date:   Mon, 18 Oct 2021 18:21:33 +0300
Message-Id: <20211018152136.2595220-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c226f6c-4176-44ba-2c24-08d9924b060c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB268825D3612B234E1F680E07E0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sg0STPpGf2RP3XwpJo/KsXTlYaSiq4rJmRr8Gs0uI7KKYF/qQyGo5tWfO3K1pnvnYHZ1nw+ZBx3aZRUXGYe0tgyEqfHgKrJyg69pONX3CASZ0xi5NGyc1UaKGmewLdeLoaEAMWkVF5Lqq2d5Z7FPHpMlQUkTVgyEDJnUscQwPn0RyWfWnthklvBoocZ2p+qQson86zQkaOW2AXvSbCbjZU4+JRL09BSk2DzASwwpV64d60aVbzZoHPBRZcdOH07Qxbh7fazTXX2snUW+qTcxex0dtOvEIjV5Ajsd+ALr6OfEoHBHsRYyXt2BBAWzFtVnT1/lvHblhTmoMA8u5mtl+kOiOojFP2ij5CP5gBKSvFLaT4y5OWAK8v9jj1gUlMaieMzNtfmXnaCXN2ZD/yssjliRCwsINyqBG5XUfmVUO1Rj0X7+o9KP0VeVNc+bCfgW7wTkx8uFg13C3ASvCJ/aZje+dj52RTsqZjRywlkVAnhdBFKHcXixaI+L6n8bRyYxzR4SxXjDsFJDeVKLr3Rq8mD5wc/TkVIyAPrnlrpudCblNzTVzju50zkkhJO433lzcH+X/tdQ7ZJqWMGi9YR4x9nIcM0dKLIcjmtVDLIqGEU49FyOsfQtbVPw0mDWhLYeOn0f3wwHchB6xTXaGD1DkzneiGrpcfQuHBPmuZ5FS+i8gOxBFgGSv8D1EohOyJElQRQpiPoNHuh8cV6XNERQ5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(83380400001)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBE2Dshasqs670wuB9CwRxtOH0DY4CDYPIug1RBL8Om2+wSXydOZSQ1xzhBN?=
 =?us-ascii?Q?Q57buMz+uJoY9ERJ7JtWi3xhO4eKbmKl1ENKsj+kZY2bQ9YeWXVJTc6jgT2D?=
 =?us-ascii?Q?yXDfzSKie8tt6YMCyZRRKvPXeI6ZgR1wNXJDl9UCOvqBOQrxv9ax2ZNBUU8M?=
 =?us-ascii?Q?gNtKJiPlhBD2/x7cVDLIOdk02ic9QIbPZmSFh/xHpfDpMwtAdVQQ71UkfhFp?=
 =?us-ascii?Q?U1Gragap8aY8Hjtmi9dFin9zg6AIy66m4C5VE51LtZ514ZdXfryjv6uLmZJg?=
 =?us-ascii?Q?X7LbswDiKQ5L81pKA0Jfyu1xIJysHQk57BaCoxQu7O+OQvdVs8EIZLbVzVta?=
 =?us-ascii?Q?ulARB5vkFoHasgKgwxVSzxN8A4Hl76ZlrE2u4bhGr0A3Npeoyop+sGi3k20T?=
 =?us-ascii?Q?AlpwEjdTdsP9LCAxg9X9DnybChwzZdBmRo5PYY96XNrrf780Jq+kSYso59yv?=
 =?us-ascii?Q?1P+4vEcUAI2scs+rGwl7+BWHE1Zp5F6cB8C99zxHbHeinW4R9Q5ZDH5EsYwE?=
 =?us-ascii?Q?ayXxQFuvXdMXSxhcBTD0MoKBxVXzXiMhbgBhKIt8BftEguoIJZbWXWQBHxEn?=
 =?us-ascii?Q?vf+Lss7OJf4T+Co9GwfywluvrMG4xxCEnbBVtxyVRMabEDu+Byd46iOicDeI?=
 =?us-ascii?Q?q26AjbCYmhiB1ywme++w+cP4SbDj8vA4IIaTh/D81cgtYplMm0ahDK+PVmZb?=
 =?us-ascii?Q?CtHyVNYtcg4dERUbSigIwv2nxBM/7pk9FaeZxsf4MBYrE33JtPaOLs83wd7j?=
 =?us-ascii?Q?AsohP59zguXe8aSbrTSq38XPK/pv1TxDXPhVRR/kKM3gJUFFe2NzxuoPDeTD?=
 =?us-ascii?Q?lgQWnqkZGJMWjJ6tBsVjWywf7EwnFvRI+OKY+109hfYacTQf+v0MwEr5iN/E?=
 =?us-ascii?Q?wkrs/i9fKguk9POfreILDCE8GgoHcqS9nIEYx3vv3HmVgsJQ3GsFADw2jhef?=
 =?us-ascii?Q?3Niiw6oOXmU0L4UaG9H6yMsp/PE1DZaCRBxBa/6QEALyf38Jtivh9ugokTLa?=
 =?us-ascii?Q?nZaplTdnVMws+zK5HW4UjVUFmy8SW91rCuf9Fnf70QGztbEMUDSayuAPDEKT?=
 =?us-ascii?Q?75wmdU/BgxyqA5svkuepYvR5329YqzJEjypYsWshYDKUizfHLNQFo7YKsyoZ?=
 =?us-ascii?Q?BnIXb55+ODHAmQNaX0jCf98ab2BZCI092v/GptvYeD+tUiVY6DYJrfKgioG7?=
 =?us-ascii?Q?p54IjQJUAV4aSYfy+crbxgB8llHlXDHUz7aGG+Wx91GB2glFJahtsRJVNYgO?=
 =?us-ascii?Q?sJaEn9fgfuxTMaz6A9iy7/fmALJXTw1fCYIEWftvIUbhBVJ/KVvdv6DXVRfN?=
 =?us-ascii?Q?5fsN9zFKBytdmJbsJZhXrfOk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c226f6c-4176-44ba-2c24-08d9924b060c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:57.2868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: weXDgrzpmqXJCKRxgaFzH+4c1fywT8JLiUkX+7FLwHYsBr/Zkg9yNGLM/HK4z5aWvCO1zU7m/EfoWOkTZQ0BWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the occurrences of dsa_is_{user,dsa,cpu}_port where a struct
dsa_port *dp was already available in the function scope, and replace
them with the dsa_port_is_{user,dsa,cpu} equivalent function which uses
that dp directly and does not perform another hidden dsa_to_port().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3b14c9b6a922..bf671306b560 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -523,7 +523,7 @@ static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
 	 * enter an inconsistent state: deny changing the VLAN awareness state
 	 * as long as we have 8021q uppers.
 	 */
-	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
+	if (vlan_filtering && dsa_port_is_user(dp)) {
 		struct net_device *upper_dev, *slave = dp->slave;
 		struct net_device *br = dp->bridge_dev;
 		struct list_head *iter;
@@ -1038,7 +1038,7 @@ static void dsa_port_phylink_mac_link_down(struct phylink_config *config,
 	struct phy_device *phydev = NULL;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dsa_is_user_port(ds, dp->index))
+	if (dsa_port_is_user(dp))
 		phydev = dp->slave->phydev;
 
 	if (!ds->ops->phylink_mac_link_down) {
-- 
2.25.1

