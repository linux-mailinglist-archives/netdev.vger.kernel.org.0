Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04372D086A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbgLGABC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:02 -0500
Received: from mail-eopbgr80049.outbound.protection.outlook.com ([40.107.8.49]:17892
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728660AbgLGABC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vapw5e+2uRkKGIbZOxupO+vjK8V7IoraCq6djLnzoVj+iNT9wLMHBOcUgICx/L2kOnVWPhGcNSHy4Mx1ncPllDv18leh4m0zX56RrfZVQIZBdX5aaTryiJfTdTkkmCXpgn34bA5HP1+1rU1ymIX0PrxJQ4GKQ2Uwv+I3/aCm7k6V5mcj9WN+TUQw1lmE05u7E2/0riKru/vFQB1Zip9DtH0xdZpQobE8UfxSs+Y4VJXpza23N15KA6qJFIOB9LWEyGd4ricBBu1xhILiBzDYZ2uGTSMQkMPiPqdLVnrjn3JBm9fLpYqKtDCoBt1J2klqUUlMiWi5T0qoUW8hMh8XEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InZDUjB2Yptqic8dtqVlEoAc88AHwGBKZuhguQm1BB0=;
 b=NSzbAw69iuheyVBbZF1EZyoyQtU9tdIGhHyexhoaxw2orrYUmSlHJoHfiXw1Oy4mic3lVlMna18MQ1a7hI2upTyuxDjLXLiO6x+dJC3x4T7iLrpvH66T3TaQcOXAHdmgYrfJ8Mf9DAD0Cf/NU72djOBRh8GlLWJIVMgoDkZmzBdC8QyUckpi+qlJUMNNFSerNEi7EwnGpdB8FtQUPV+NyugUSaRj+sMO5lqLFNN0TL2UxHw8JQSaypw0Fxl47SViTDvQiw7JmgrRvLddxlXWm5v2OSPwT3xYpFE6FtBirAXTzoZHsyYvRFAmJSGYsiE2ALOTolebkLnoWuBbiSmt+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=InZDUjB2Yptqic8dtqVlEoAc88AHwGBKZuhguQm1BB0=;
 b=ieICDkcSNK9jZBFXEN3b5NTOzFieS9/xeqVzUykS5HLFNGaKjh5ExjJ7WV5MO1APNac4VDqioHZe3JkI75REEWEhchj10vBqIRinl0Jn7DmSRu3QbB0h/l1qP5yHE8/cuOtUiouQNj5vvlLblzeNg0a5L8H3tr3gpwoQ2hETL1o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:00 +0000
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
Subject: [RFC PATCH net-next 02/13] net: mark dev_base_lock for deprecation
Date:   Mon,  7 Dec 2020 01:59:08 +0200
Message-Id: <20201206235919.393158-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Sun, 6 Dec 2020 23:59:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9b70b48-7509-466b-debb-08d89a430a75
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB663787939A8A27E70824C6B9E0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7lonmbxlzIutfPcx8CSR2Yq92WR+OW14JgOsc3JJxXYd3y+428baKnWPVVZ9NzFxGKhxlbpce7IPDyebBqc4ZhGAdipAadbvDgdHR/pzJVrpsNcYeC95TvmqzM8Tjfn22NKPJO30uvXXN0idJ8F5zN7Jw9uV1WDtCPcCmnnuiqNciLv2wPFPOPlR0WBFfQu4KdoA9gDwSHaZ3p0sJcmzJRuF2ftklPu+o0D1OGfERTxdOKW+j9m1uC5604fThXQaV0BvNTn/7+sfbx0ylZK7C4ZOOkevI/KpuAqQILCg1L60OpZJmwAZ6jQ/omkp391JbSXJF1ZuzlNc35Xhuiax8Oo+ROEffMwYDlDIIg0ODFIT0p3I9vIYiYRh2Q/9k27d2u3lnHApHLXIw4kvSCGKOdzCW1IiJ3KPAKMQbqGmu20dWgb6Frg5TmFlbWmrh8/RJ3+7lcOQ24MoSEI4ibwSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(966005)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VP7cE8xEYOBt1czK77S4WhWnr2tNzwjnolmAxyi0ZXWFlKsmW01h1lSKf3gu?=
 =?us-ascii?Q?jDYKBkSJfmEcwSPtDSkH95SdH01meQNm5wV+VzldY+koPYrYR0UjkOUKhovm?=
 =?us-ascii?Q?Ue7zDMlG/II/OBmaxVjEIPSClZhz1Cvj6RHFFXssjsjW20u/QneKQWh1A4R4?=
 =?us-ascii?Q?YiVuzru/fHjELXY/oQZrXu3+7oAuBJ/vhCQ6Cckx6o//lD90//XCihQR468T?=
 =?us-ascii?Q?hxmk0r3K43BC6BkF7fGA5eynuUGNp4THdJovIaRmr4JOQuMrItqstFX0en8+?=
 =?us-ascii?Q?McMAzK9WhodNB0m8/sjVC7Pmycm3kchH1cGqvMsdwbKBnMp/uahbAchYMt4c?=
 =?us-ascii?Q?9+LrnmrL32WL1cXgiK3lbCMjKhbvLE4ZIY0ZKGGkMj0Qi72WcFziu1sBj/QH?=
 =?us-ascii?Q?AlRg/pX82F1R7Yn9bMmzghmd0LprTGeVb9usYNe7szSnc09hxjtFckJZu6eY?=
 =?us-ascii?Q?oOOUvklFnWDr6yo1DhL4IWX1Z4IY8aL888AscymkQ864eX9nW6yGgaTQxQBp?=
 =?us-ascii?Q?OE3lXIi5Dcs75hGz1xusRCu7jZewKtDaZZT02XNXA/E1kZHhn6nHd6Xmd+BK?=
 =?us-ascii?Q?olEo/nweFTaPM0Tbim5b3rIwVbNYfSZNmvMy2ftUJfTu2rMledN4fTR0EbAI?=
 =?us-ascii?Q?UwuvFPo1K6ESI+y64n8jUikAncedA71Dwjbr4V2rNw0gMVp7bwVVlVIq5jTm?=
 =?us-ascii?Q?a/DPEMlynA7091G+jeWedEN7Yf2aOdKHODMJABDXTKnGDR7Z95kAoFZIfT0m?=
 =?us-ascii?Q?0AaOyWFE+0wpFmPdzS6wnD2XYQkmzXstmsv3Gi9eZHrEQ2xSgGABNrEIMdcQ?=
 =?us-ascii?Q?7wA3BwGOLsA9020XH1Mu0EVl3Bs3nFr2V/jJtr4GjTx/fMlqUlgULtvnWz+T?=
 =?us-ascii?Q?M3gVSBxBDUyGc7k8gm1/WDMgxC4XDUSADWErwiuaqgh4VImDPEmau8rED1dd?=
 =?us-ascii?Q?Zlrd+P+R21FPUArmAT3iGxTpzVS97tYqD0R+2FqbQ8k=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b70b48-7509-466b-debb-08d89a430a75
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:00.3687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KRedQ6wfL1cP/+tblQmRTM9si2wo7Bw2g+vH7qWFblcJHLSbXOagFXTxYezF2qvuxNmbKTID+DFOaEu48T8nMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a movement to eliminate the usage of dev_base_lock, which
exists since as far as I could track the kernel history down (the
"7a2deb329241 Import changeset" commit from the bitkeeper branch).

The dev_base_lock approach has multiple issues:
- It is global and not per netns.
- Its meaning has mutated over the years and the vast majority of
  current users is using it to protect against changes of network device
  state, as opposed to changes of the interface list.
- It is overlapping with other protection mechanisms introduced in the
  meantime, which have higher performance for readers, like RCU
  introduced in 2009 by Eric Dumazet for kernel 2.6.

The old comment that I just deleted made this distinction: writers
protect only against readers by holding dev_base_lock, whereas they need
to protect against other writers by holding the RTNL mutex. This is
slightly confusing/incorrect, since a rwlock_t cannot have more than one
concurrently running writer, so that explanation does not justify why
the RTNL mutex would be necessary.

Instead, Stephen Hemminger makes this clarification here:
https://lore.kernel.org/netdev/20201129211230.4d704931@hermes.local/T/#u

| There are really two different domains being covered by locks here.
|
| The first area is change of state of network devices. This has traditionally
| been covered by RTNL because there are places that depend on coordinating
| state between multiple devices. RTNL is too big and held too long but getting
| rid of it is hard because there are corner cases (like state changes from userspace
| for VPN devices).
|
| The other area is code that wants to do read access to look at list of devices.
| These pure readers can/should be converted to RCU by now. Writers should hold RTNL.

This patch edits the comment for dev_base_lock, minimizing its role in
the protection of network interface lists, and clarifies that it is has
other purposes as well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/core/dev.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d33099fd7a20..701a326682e8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -169,23 +169,22 @@ static int call_netdevice_notifiers_extack(unsigned long val,
 static struct napi_struct *napi_by_id(unsigned int napi_id);
 
 /*
- * The @dev_base_head list is protected by @dev_base_lock and the rtnl
- * semaphore.
- *
- * Pure readers hold dev_base_lock for reading, or rcu_read_lock()
- *
- * Writers must hold the rtnl semaphore while they loop through the
- * dev_base_head list, and hold dev_base_lock for writing when they do the
- * actual updates.  This allows pure readers to access the list even
- * while a writer is preparing to update it.
- *
- * To put it another way, dev_base_lock is held for writing only to
- * protect against pure readers; the rtnl semaphore provides the
- * protection against other writers.
- *
- * See, for example usages, register_netdevice() and
- * unregister_netdevice(), which must be called with the rtnl
- * semaphore held.
+ * The network interface list of a netns (@net->dev_base_head) and the hash
+ * tables per ifindex (@net->dev_index_head) and per name (@net->dev_name_head)
+ * are protected using the following rules:
+ *
+ * Pure readers should hold rcu_read_lock() which should protect them against
+ * concurrent changes to the interface lists made by the writers. Pure writers
+ * must serialize by holding the RTNL mutex while they loop through the list
+ * and make changes to it.
+ *
+ * It is also possible to hold the global rwlock_t @dev_base_lock for
+ * protection (holding its read side as an alternative to rcu_read_lock, and
+ * its write side as an alternative to the RTNL mutex), however this should not
+ * be done in new code, since it is deprecated and pending removal.
+ *
+ * One other role of @dev_base_lock is to protect against changes in the
+ * operational state of a network interface.
  */
 DEFINE_RWLOCK(dev_base_lock);
 EXPORT_SYMBOL(dev_base_lock);
-- 
2.25.1

