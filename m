Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63B882D0879
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgLGACE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:02:04 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:57805
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728632AbgLGACE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:02:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvYFJ04jeOzHl9YpRAHjkJTXazjl+ZS9mmP1ta88mkK7yl7FTKqcf3Tu03eLtAB2pPbqeS/6HmtWPzGJq2XzAGn/e5WlzU/Mf+BPEJXItY1J7WOugUbcb05lgMBPufcHcHGtcDVrFLUP6eWoVHh9tOWDPy73Os2TxFiKiSIoc9R8bat2LAaN0aMjZYYMDp53rAcRM3++3UwWvT/Erfu+8m+0cydoG9YCVR4E42HeW0kCM0GGTIoaapfvj6eWnF3PA0woiEltW2AjEMWxmS7IEY+dxo0A4Xy3r7M66tOnIZGlpTcNayY4GTYORgURoaHhmrrlgdlfsoIzefuoqMmX2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwx+FYPRMg3O5R99oiba+alxiCgFfXMdLjcnG53F6xY=;
 b=j2xu1jqiQZM9pEWpBtX68jVzRIeNIpvsAITkcUZGe9UULBCFuNGXRpo22hde/ivsRqjVJ/fUMscFMWlAswij+yDn5wo9m1CIVQ4cZO4iDpZVCmKwLIa9ILTCNJT8PWlQBSXHO8pzUdT4/XUq+iBe2YFpHGuLOdSZVo31fbTUq6w8f+mYb0uJVB+ytyk5cgbjGrTAwViO3+boa4Y50yujKIUOmTrck0l3qSeAX6phxpdG02gs03ojJhZ/pfJwGxB36Mhu8IWbOgihxybJB+//7dSlyAr5laLoBegA1+zqTkw7P8LKhOYJ/lZT4+EHFSd4oZjrxGHuf3Bpg6ob3btyOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwx+FYPRMg3O5R99oiba+alxiCgFfXMdLjcnG53F6xY=;
 b=Z6DwRxjGRtgMwboXMupRdcPFGbfzFoK7JMgm/B5cz2aljVJpbNKBhr77DwJYZXmyizVvPPLyfazhgIEjq1zPudegzYiVcMEMjxdJcvGnUTKPFISBXYUeMxkJ0CemkLcxy1UNN5XOhDDNCws8dNJ1NRU0l6w4ujCJiVqB9nXdGy0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 12/13] net: mark ndo_get_stats64 as being able to sleep
Date:   Mon,  7 Dec 2020 01:59:18 +0200
Message-Id: <20201206235919.393158-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ee4c55d-41f1-4c22-6991-08d89a430fce
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637CF36C3515635A947F3E1E0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yOHW0fa4TkDhKns3i6Zia0ZJJ6MidA7o41QQTbn9yXKvJ31uYmNDRfIL/jWMm/7Ex/nicHSvUEzjKZbIYPZvY1Fe4z5qm9ORdpy+x9EbFmj2vX3Q1J9k+0kiULh0NVo+UO2VekhHmSncQPYlTtSHacQRbbx/bdX/P3aRn7T76XjEPgUrLZY3UAL4B3Zu+KRng2oZLluRF5iAmDvBy5zLHsSnblh7SeVIYIy6TZmQHwiJ9q+Nag6Gx/xAtHxclvHEGrHInOZLY2hINZa1eiCZadV6LzNP6RcZvKQEgT0aHo4jInn6HalS4B0mCa49Q3HwGwl3SExMEa5snYfYRr9fkhST4iJXkMBG4xuSk3cNdj8h/QGi1c3U0gdOBTCV0UvQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?2Lx+rK31YWMlwRgLxSVW0I8oo9epZl0FdZ0c8Xfmf3kW1dZtuDJU94Ui0Bf6?=
 =?us-ascii?Q?wWpv4cJldojLxA/tN0/SFvQeGmmwl179Oo47P0ehHOk+FjdKOmEn2hhEVjQw?=
 =?us-ascii?Q?StCGqLBQeFiM0MTARQ525Oj1xOJmvwFwtpFQXD7Uhf171uEyQM2Pf35gnDCA?=
 =?us-ascii?Q?5O5SxVhua/pKw/dpMHAzJcJIFvxUqkKuOK9Mj22Ad2KkcE24x/ABKKxJCo4F?=
 =?us-ascii?Q?o4GFTJ08th4X7UXRt6i+c3ogQmLjuOlmRXtNmRF0A4RrkP/mB959yVEyKquA?=
 =?us-ascii?Q?z9LmFIZN+XUc/PODPB9QTG/eYUBtFoCtw2zH/LiOhd/T+CQCUbeOr6HcEDC8?=
 =?us-ascii?Q?+wZdQjG24897mDEIL0L+6oG5A5SuyfbGMgFpGNJNoHnZBeNxXgmK4lkkQxbn?=
 =?us-ascii?Q?TjzaF2cBeibrlgo99WSmKuH4r6nmPVfe0AaTe53H2hkLTGb1o7OwLekIEWCB?=
 =?us-ascii?Q?eeEOLcQbb/1sWONYYtkytqEeYrCSJDCm7qNRq8RbFvRGkIxaliyBetkC1pva?=
 =?us-ascii?Q?G0wVkX4p65w1Tby6NW0jdc2K8tZ1X47lckeiIhAGAmL9lh44Feo8PRkAxkTF?=
 =?us-ascii?Q?1hv9/t6xIlLUmR5I26P/NhF32+pDCJc8I8PPdCjCr3ny94F6GoaA6Cl2fDlc?=
 =?us-ascii?Q?iay3hYwyZcu2ho25EBDjVpSY5D0ZXr98NlIg5x6loAw85RdP/Muk2cNN8Jj2?=
 =?us-ascii?Q?t978iVRZ6VYPmatpDPb7Cht/hp+/Tgs0TUg1sXIyPXja6JTXkzTOLSva0iwL?=
 =?us-ascii?Q?Jk2yVZUsWHYMFp/MlNZmNMXSLLDzElmU+PaeRRu+J/59jBn+o1zilMtG25gT?=
 =?us-ascii?Q?RrbdU21QsXLr9VIjbZ7UldhqY1KiJD6iwOaXJRmDywFeYZtaxIGQZF/n39Ik?=
 =?us-ascii?Q?XRk6SHmPztsB/bqU+eq5oZtA6PcJR03tho3zLvEifhu0Z1VLSikk7BbhlEVP?=
 =?us-ascii?Q?Q+Jye5Qt5EIwQdWr2szpnE8QC/0N43W8mpkHjoRFSTplbvNJj+dhx5Bjf46Q?=
 =?us-ascii?Q?qWfR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ee4c55d-41f1-4c22-6991-08d89a430fce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:09.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mPyvHZPu8fdBZyjKnzRNhG+ibc8uZ2fFGy7XAo8URTSLvzTBYw0viFfPKEs7ayBfpLlOESIcTo7CuAfUlkL3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all callers have been converted to not use atomic context when
calling dev_get_stats, it is time to update the documentation and put a
notice in the function that it expects process context.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/netdevices.rst | 4 ++--
 Documentation/networking/statistics.rst | 9 ++++-----
 net/core/dev.c                          | 2 ++
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index 5a85fcc80c76..9d005cbf84f7 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -64,8 +64,8 @@ ndo_do_ioctl:
 	Context: process
 
 ndo_get_stats:
-	Synchronization: dev_base_lock rwlock.
-	Context: nominally process, but don't sleep inside an rwlock
+	Synchronization: none. rtnl_lock() might be held, but not guaranteed.
+	Context: process
 
 ndo_start_xmit:
 	Synchronization: __netif_tx_lock spinlock.
diff --git a/Documentation/networking/statistics.rst b/Documentation/networking/statistics.rst
index 234abedc29b2..ad3e353df0dd 100644
--- a/Documentation/networking/statistics.rst
+++ b/Documentation/networking/statistics.rst
@@ -155,11 +155,10 @@ Drivers must ensure best possible compliance with
 Please note for example that detailed error statistics must be
 added into the general `rx_error` / `tx_error` counters.
 
-The `.ndo_get_stats64` callback can not sleep because of accesses
-via `/proc/net/dev`. If driver may sleep when retrieving the statistics
-from the device it should do so periodically asynchronously and only return
-a recent copy from `.ndo_get_stats64`. Ethtool interrupt coalescing interface
-allows setting the frequency of refreshing statistics, if needed.
+Drivers may sleep when retrieving the statistics from the device, or they might
+read the counters periodically and only return in `.ndo_get_stats64` a recent
+copy collected asynchronously. In the latter case, the ethtool interrupt
+coalescing interface allows setting the frequency of refreshing statistics.
 
 Retrieving ethtool statistics is a multi-syscall process, drivers are advised
 to keep the number of statistics constant to avoid race conditions with
diff --git a/net/core/dev.c b/net/core/dev.c
index 18904acb7797..45a845526b64 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10367,6 +10367,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
+	might_sleep();
+
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
 		ops->ndo_get_stats64(dev, storage);
-- 
2.25.1

