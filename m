Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B476B63C216
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiK2ON7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiK2ONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:31 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2045.outbound.protection.outlook.com [40.107.14.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8DE59857;
        Tue, 29 Nov 2022 06:12:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvaytg86KEmfw2iqDWXhG1pkdUzRqivJ/b9/qHc7OVolaU7PjCzuemyzJQK20zn2v6cyh3UYaBbqBIawZ0wZ9+5cGQMjpzp9uZXVtEoHcSrqicDLEgOlA3qyY9z72d6OpM8W7nSzrXjoP4l/g8sDCzkN3rVNNjOcF125xprU5GgVAaoRDaBhJjeQIO5GeWJw+cLX5MQx13KrIjclHda9M9y4DAP8hPRcxTru2D9QUF+PD49mDskbvp6qlyV9w2XJ/s1ujpNZv8UCb4c27MON8pDcaqm9dvQqJcexCmThjy4htZ1hP9QekBHwowa/2aKvU5bDJCXLiJy/X8K6MB11Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cfHpGI86KpnGpe6EaQDZo0YxeBHYEAjuAWqJ4/TUNAE=;
 b=TyZwwrAxFWqJly45NF/22iYvgbo34hKlz+ON13cmf2/MdBFEoTi75jIPd9EidTpZIiNka7MhX2bSPyiWcS2h2p8Xpz5l1nMcwwPhDRha2ZTVTBTJOiA8/8acqSqFwPOMRPFbJxltYYUF8DkWerpdKehAO1fKETGj38fdOq5Nm+6mRjMGsnXyl2zEmNhFhOwd05zKlzLlOA+NJwJZOv7JRNLU3uPnQQQBpVQ3gwt9uSAblTx+WzmqdTQZ/KiJkiSnzxyFPNRLsWiPtmYQMXpChauaVrM1sOXAO0ea8HEVOaY8mf2xV21x5FF3OlKpfZWL9FkDrRFb2QxDcVs3Upqm7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfHpGI86KpnGpe6EaQDZo0YxeBHYEAjuAWqJ4/TUNAE=;
 b=kdQeDgU22rhnIfm9V35N3T3m4WM0Zm9L7+95bRRjNTSm1qTVUNkFOH8xNM0ZE1BuuCj6t5E1UgW9MeJmpiGpm5JbD6h45S0Hyc35mmet3v7s+FcQL5CczM5RvbMQoXWOeEDdXfVhx30yM4+vcH9r1HtBneTI2SrP2ZaTk2hvd0Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/12] net: dpaa2-mac: remove defensive check in dpaa2_mac_disconnect()
Date:   Tue, 29 Nov 2022 16:12:13 +0200
Message-Id: <20221129141221.872653-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: ec5e3543-45f5-437d-48cb-08dad213c43e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5jMzcbbBWFWt7MDnSWaXHWtS3XEufFjBQL/zFk689+GvFh46RSDQwu1b5taST4a9zXnvRdgS+Ai4HTtWf50y6bPC9aE5+OtOzXgLAurdRgyYUTYdPnW7xsz2VJmo+walm+DknNnEy0+l7RDOYNHLe0ckJXxXSnzOxpfIqpNEAJBTPB5JA9tv5vF/eZpgbimsBv7MnEVDtVw2s1OLbUQJKJU1cO5tiRQ8sDr3x7fwbtLwynEcHNA97IYrA0CcuZux4GhKxrejQW/wze1z9esnqAjFx6t0S9v0FWUCHN1XOGDXp5tlsl4I9fMS2XHK02N/VSKKojvkCcb80LTGOQ3o9743JG7ZOO6TZNzZMFH4vmX9jn5c8KN/o27p0LhXXx90xhao7oiiaogAIcM92K6rEcbG9xF+9SBUAs6kC7/u5U+q2JSkc9PwDvFUQf0w973guX+xZcYXo10RRwO0WfTnWTqOsDge5N+7sZeQOzDzHE8NuoeyReIM62srncSPUj92ZiSqxmi3CdvQeT+Y733jxYRFuN43ci1peY7ZASlc0MFfzJFUIXs54JIudiyDvb0O3MSVnsMbVVvvyEY3uM/B9NPZaQhxOLL3YW/70KvubUT46DygzSnsTwW/aOqzR9DAGGPCu8of7hcm7eu1EbIpSM9pE6+B6i7yhPzYC+zDzgrnMELeDjWO9dHVQlg0BozP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DV8jF1ip69Iv5OiNcwTThbaXKFb74rAvI5a7Z1mGL897CC0c+AgyM5Q6piby?=
 =?us-ascii?Q?NQD9ppxg2CsM/jIWAJJXd+AlT7GuzQpxhMcgSvcUlT2uZw2ZF5iNSUgSPh0E?=
 =?us-ascii?Q?JgBRg1te70B6GcZXCtHv+KLz5bWngugAodxNxle74vi+7lU9nGLTvwd5Vwp+?=
 =?us-ascii?Q?3Gz3Q+nNHt3VoPphcaidl3/NrXyF+TTxaaKQ53/K3gaS1n4eKS1hvFOAiwkk?=
 =?us-ascii?Q?5aUhtiMNrVwaB3JorpkMWDPTkzFthG9kR81mRf0MCe4kxCd3wtdD0hOiZkF7?=
 =?us-ascii?Q?6o5vKv83GmJtYCkZ9xSbnmffY4ssRrI3tc+/n4QRw74ZlOz4CUdjz5Sg0auY?=
 =?us-ascii?Q?T28T3mTttO1aAyF4y5mrwAyA20pUaOWkONCGIprHAYcauwTgkIP/IHaRJY7e?=
 =?us-ascii?Q?At3EGwUgUZlDaAqH/3fgkMc8G1E0pG8kpDGx0EQujiOuP1Uo0oiojGedx8mB?=
 =?us-ascii?Q?QR1q6HPpJn+jsmqLs+/zEpmjJsT2y+7sKP2G2eMy7rLnejNrQWUZvuFdAe8q?=
 =?us-ascii?Q?5z6kNxfEQa1KaOMGg5gob6+eQ2uNQ1lOVXO5llJrYPLkJ/9ii8q5AuWozg/j?=
 =?us-ascii?Q?7/mlAPIuy2JOgNk9oO+2D9TOHQ6seM+DMSWDlxSFiiM2aw3oLXmc/TKtzKOe?=
 =?us-ascii?Q?+hhKa48QTFTNoDFMQl4/QRXq/ClfcSsuju9NG45L2OBZS5Wfhc4bLxAsNSF1?=
 =?us-ascii?Q?va5k3dbpWYQgPmJeLEjRjifgR9RADsr10DZhJ5rgBDKcfvVh9k8xzuDFhupz?=
 =?us-ascii?Q?Mti+/Zbo5K1DjixrfFj4vowzQKtPDEQwbxDTzizcE4n8T9NftIqXGTmoIawF?=
 =?us-ascii?Q?KXnitkfOGW1X5CFfM9C3CUHshIN2ufNpOblD4W3rYZBsOaVvOmj2Ronmqp69?=
 =?us-ascii?Q?Bb1LNxJQHqOli69ubKT/xn144QSmVW8N7DLEUZhEhAL7bwz4OQHXpfqnf9IM?=
 =?us-ascii?Q?jrQJ79WR4etB3H/z9HVpVqueyo5AOCR1A3scmKkVKitXqT1V4g+7xZ3C/S/W?=
 =?us-ascii?Q?5Hj2nijmwzFuZwp0OYjoPY/H7CmdCvSFckq/lf7Sao1999boqjz9GCpahZLF?=
 =?us-ascii?Q?mzum9ZEZOfaoRb8xOMCl/1UxRTAr8TWBzoQ49PxU7sSY7dgzu/rAGASqxdWH?=
 =?us-ascii?Q?BqsMZxgMPei9Zx2ju3O63ZmdwWkYgGQIc4Xmprff/UajwmbcJSUQFQkl73Kl?=
 =?us-ascii?Q?k5cJFvpxvjF9HgtJi5n7Nw3zZ2oKJJnIvfNpqf/qxN7TZkaJ/Zc8Pl0/hOAR?=
 =?us-ascii?Q?Vbb83U7U7QoOvSkpGFIw52sqE9+hAQBwLZEmXZTf2ot7hAopGdC/eKh2mLz+?=
 =?us-ascii?Q?GvQ4dC7m8fxkuMF6HxPF/PmkZHcMcGaPd1DYmjln4ZU1uKWoE8uayKXNMdMF?=
 =?us-ascii?Q?lyxhxi0Frzr2Go406F+2ySEtLWH5JioImK7ZuuJhbzqXuGu/KOairpZtS9I3?=
 =?us-ascii?Q?Vm4Eg5083AdDFRBn55IdNDbip05fpIx8KJNDP51AAtyGs3bSe+zYR9iioc0F?=
 =?us-ascii?Q?LdKSen3IHaU7lSdFhpsz+r9BdIlXZFtDuLOT2qmX07tm6Cp6zpBv2xu7m2U+?=
 =?us-ascii?Q?tGh6ROwf2FDR6ZTfPbb6FW2st1iZ/7dy6N4WErBDjjLrue+m/gE8Mv/q8p7/?=
 =?us-ascii?Q?eQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec5e3543-45f5-437d-48cb-08dad213c43e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:36.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9HN/QajR0yfJkAZLeUoAPTgh/mgQxUeN6PlsuvfRMLbwG2KnF5EyOT8qq+nEWPv4RDJzBXzPj5/LESp7hKvGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpaa2_mac_disconnect() will only be called with a NULL mac->phylink if
dpaa2_mac_connect() failed, or was never called.

The callers are these:

dpaa2_eth_disconnect_mac():

	if (dpaa2_eth_is_type_phy(priv))
		dpaa2_mac_disconnect(priv->mac);

dpaa2_switch_port_disconnect_mac():

	if (dpaa2_switch_port_is_type_phy(port_priv))
		dpaa2_mac_disconnect(port_priv->mac);

priv->mac can be NULL, but in that case, dpaa2_eth_is_type_phy() returns
false, and dpaa2_mac_disconnect() is never called. Similar for
dpaa2-switch.

When priv->mac is non-NULL, it means that dpaa2_mac_connect() returned
zero (success), and therefore, priv->mac->phylink is also a valid
pointer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c22ce1c871f3..9d1e7026eaef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -449,9 +449,6 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 {
-	if (!mac->phylink)
-		return;
-
 	phylink_disconnect_phy(mac->phylink);
 	phylink_destroy(mac->phylink);
 	dpaa2_pcs_destroy(mac);
-- 
2.34.1

