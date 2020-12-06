Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B52D0869
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbgLGABB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:01 -0500
Received: from mail-eopbgr150052.outbound.protection.outlook.com ([40.107.15.52]:29828
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727661AbgLGABA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faHcYrl5Ppt766mLNPP+GaUG/PihURsm+DoP9OcGkFrb1qbbWiiAHAz2LFdejWCeToFP8Sqv588IBhQFr9ml1uubQ5cHqgiBXlY0YQh3uXVXdj2SeoeXC9Ag/lUdL7emU46Re5OBQJmCd8g4e66UWnagliHE7hj9rWi92gNaufjtXVqRJXOlsGCts5d7lBBqCFhCw4ff4DbcEkQWvrUuwjoI1dGCajfoC0gM4sCbhVhAyY38pOtb/5Sq3lCFgOfWTtuJOziw3Nxr8LLyfUoIJhfY/eIHxUNmnomI4IKaN0JCH6supk5Ty7RBkHTgmHUQztdLvy8aPdO4SiYPERZPfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syJmnDIcP9vPDwvyxxM1qoW4SiyaCBwoBEiboGQQTds=;
 b=ekdegJsLa4upvcNK9+q8VFECu/6H0nl2QW/s3I1R3FO6WBGAzqaMNy1Z6bD1Vhg9wy9/kFQN65lkGHzC6+XDhP4N15Q9L32RjAySIJ8Qhgm+0LRK0LVsJdXJ33kxWoQgyMGvS5lls83wBR9fHGX50GKnS3fMxU8nHipUts8p80CQjO/MYxVIG6OUhEhSM4ZyxLZZSCVCpQZs3qhePMT7Kh5biyO5v0dEeez55V/4qOWlQjyfl0yJqCRF8vPuirIL4DOu/Z/5mE5lXtftAlj7/fN3myyLjr7bGl2iMpNcUubqB48owVB05wEewwN2WWJfwy4pclBN4SPdFAZ97bOuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syJmnDIcP9vPDwvyxxM1qoW4SiyaCBwoBEiboGQQTds=;
 b=S2ffH4qxcMjhDS2V4oGL1WvMrANH/9vnAuNawradGJNfmNQaDjA70pCmoIRGD88W0GYyPfJboKFGViVS8dwULTPiJ95QHPk697hhoQazvA6HvKJ+IMI1R0CZ53ZSgQJakkHzUB33o2k88SQajJyzxiomUadLGw957lsgNTzXEpI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5502.eurprd04.prod.outlook.com (2603:10a6:803:c9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:10 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:10 +0000
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
Subject: [RFC PATCH net-next 13/13] net: remove obsolete comments about ndo_get_stats64 context from eth drivers
Date:   Mon,  7 Dec 2020 01:59:19 +0200
Message-Id: <20201206235919.393158-14-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9b0d924-4aa9-4486-635c-08d89a431065
X-MS-TrafficTypeDiagnostic: VI1PR04MB5502:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5502AF1AB9DDEF4447AC42ACE0CE0@VI1PR04MB5502.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +wdKwk7xuQJL7Rv2Ax5N9psUtHLioz7yuGyi1tXQdDGShHGQLPIHJdsKEMVINCmPyW51St/uKLeXE9v6qcPp6TUXmD3tnsihK6eLAAXt/pUOV2qegoI+4NPDX5u+v0wgR6fkrjbe4So7C59t6GtAN8I+CccyyQDcXZFQT9Y4fIpoVAQqleStjlNCFwfbrbiqDtHp5VWf6uWv6V5KI+ZzoC8/kOGDYz9GYUMVnuJsjZeqWxDX2QS8SMrS0hIUfb031yDOCOd4OsdcXnCyWPaNWlq7ZziTzS8qnQ838OCv1M+yvcVg66xlN0sUpFCnnS6VqPxTLYEY8P64moRHS4b33Y8Z1XTnfaSesNSB8RNW68/XT1I1E6y0jqrxJMxZMYq8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(26005)(478600001)(8936002)(5660300002)(8676002)(6512007)(6486002)(186003)(36756003)(52116002)(16526019)(4326008)(1076003)(956004)(66476007)(2616005)(110136005)(54906003)(69590400008)(66556008)(2906002)(44832011)(66946007)(86362001)(83380400001)(6506007)(316002)(7416002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?BeHhn+bpVvlaiux1A0c3JfmcO2eOzWDFChJK1Ms9e3koXR3if+/Ziw4CCjav?=
 =?us-ascii?Q?cmAx3wgK3MtArwf5/l0xrw68gsey5jmuEdbnbvr1UZhqoWQ14oav/TrjjPze?=
 =?us-ascii?Q?yfZTA8hKMvKUHDGw6hLrnUdO2ic2BI2/kSAP708N3e5q2yNKGlur7A4maeyU?=
 =?us-ascii?Q?C1+VG6syII0IdczKMDyiijxJGEWEyxNhzfmKBN1sqyUk+O8GUf/c3EPKKcHq?=
 =?us-ascii?Q?D60phLGsNWhQNgjtDJDkVwV/ZPwb9mo3Q0h53N1SIPyldnpqXy5oecM92HFr?=
 =?us-ascii?Q?Mt7qo/GRSxeoiPsdDZTBdy+KxZcfwY5i0ko6tVEZqRml6nmvR5mKBbUOQr3R?=
 =?us-ascii?Q?oiDNw3pxhRmaA0Sfofm7Dif2BOxk05wVJax206TRrC9Z72xYnHhWBapWLwAz?=
 =?us-ascii?Q?Jy2C32WZJ8H2iRs06jsrn03idIl62Kb8F3PWbXiMXktJYeaBgnTRbHXbhYRP?=
 =?us-ascii?Q?oPgWV7hMdL/ed0bV4drJ/ZWygBxfO2x+wiUgPM5Kzve15eXbiFMKVYA0xIX7?=
 =?us-ascii?Q?zN63sDYWsxyZ9AQnxgWS+Ot2xnsk0I4M6Z3qF3fCRXHo83CmtLIVO3ZMJRrY?=
 =?us-ascii?Q?FMvua3ivDrA613JdqmNU+cqhrsTW+XBR6Oqo7y+2afvTHx8BDB0AlxckVigo?=
 =?us-ascii?Q?HAJY6mjxi4k6RXlz8uE+JbOHoSKtWoju/Xv7/KXPSh5JpNPzDjob5gm6Fp24?=
 =?us-ascii?Q?CH/edX7mVIg1gdH9QZ2y0kbYXnR69d2FIWypjWLprhhZHJHBO/r76HosuovM?=
 =?us-ascii?Q?pcaowhWpQQor2S21DzPEs5r6C1b6/0GiO3V6oEHV8sVjKLJY0XffUmGn5+b2?=
 =?us-ascii?Q?+gCWXF8vTh7wNpSn2mYl7emOhrZrcckw9uFSLJZD5ivgLkUdtw5SborWfG1a?=
 =?us-ascii?Q?7YVXOq2fFUq3yqhzPu4gciO66t9zQIsMEEi2GehRp4BKV6gBF3Y1ABXf80UP?=
 =?us-ascii?Q?3EUJNHe1q1L7OKlyUG9F+VvRe7iHS+tod3s2RTkmIQDoSP6BdB3UFCWHxF5c?=
 =?us-ascii?Q?cYZq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b0d924-4aa9-4486-635c-08d89a431065
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:10.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EgklLesF53VFzqXIShzHCiu3fCljxTWZQGePBUOkowS6X5LGXW6GbNATZsVZslKkkYqHIpicJ7Eh+24iJapJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a good summary in Documentation/networking/netdevices.rst,
these comments serve no purpose and are actually distracting/confusing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 1 -
 drivers/net/ethernet/nvidia/forcedeth.c     | 2 --
 drivers/net/ethernet/sfc/efx_common.c       | 1 -
 drivers/net/ethernet/sfc/falcon/efx.c       | 1 -
 4 files changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index fb269d587b74..7425f94f9091 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -870,7 +870,6 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-/* dev_base_lock rwlock held, nominally process context */
 static void enic_get_stats(struct net_device *netdev,
 			   struct rtnl_link_stats64 *net_stats)
 {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9ed02..8fa254dc64e9 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1761,8 +1761,6 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
 /*
  * nv_get_stats64: dev->ndo_get_stats64 function
  * Get latest stats value from the nic.
- * Called with read_lock(&dev_base_lock) held for read -
- * only synchronized against unregister_netdevice.
  */
 static void
 nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..4d8047b35fb2 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -596,7 +596,6 @@ void efx_stop_all(struct efx_nic *efx)
 	efx_stop_datapath(efx);
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f8979991970e..6db2b6583dec 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2096,7 +2096,6 @@ int ef4_net_stop(struct net_device *net_dev)
 	return 0;
 }
 
-/* Context: process, dev_base_lock or RTNL held, non-blocking. */
 static void ef4_net_stats(struct net_device *net_dev,
 			  struct rtnl_link_stats64 *stats)
 {
-- 
2.25.1

