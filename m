Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5AB52FFA1
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346688AbiEUViG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346622AbiEUViD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:03 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4489552B37
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iQGr0E4ttP3wgEe5b9KUZNa/Jn83/ifTFZlEles+E4qdo3gSLGObE+vRVwhfFw5SBnOAPFVxjptZqATfRwlL3GJ5S91F42eTNOGgBr/+9decbyj2dpP3iNuKvs8sVRr1JPZHfHaH+QeAacujtSYjAU4ZBwgTjr6Fc4GrYJHqiyyzTeslDnjNK8TIwPoJqoFuFCvxFE6IP1+aFx5zpTochLjRoIDiKZfetcoqrMoe9AGFy/MGmqoxi5011mApZciX5X3xUm4QeeNWfYPikZvKlYDMAUsKEgFMNlEK4j9aT4mZVeTlb0XvAB3qL/+xyY5bhDhGPhS5xczxCZLu6tQ84A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHHaPd4FmBCV6rapFMDun+drIxR6g+mTOGqd1IaAYIg=;
 b=ETmH8GZyLPnQXE6H+Qg6NZseCOMjUIrJwjiQSvg2CITXMU75WFFbSvloos8QoG1xjnWIcsqjmizwpxOloVIQgbtX85i+FqAWct9js4jLvU8s2vgOyuygyf7b/7+uRftIJyp2QpfJZp7sKiWJVU1Vd+whiBHMatYgE7uzSZq/V2FR3jwwD+npnTbRoMrLgzq9OlTEeGWMDioqtbSCGXAIXew/s66Ur9Ao8kz0cAny2CFJWSL6RZ/eUwG3rJyRo9D9g478h7ZAacXQrDgmVxUPANXn2YYzHA8YhbCE+dWpwmtvWc+ZBNTdJSGb/+caeGtN4rP0OgajEEaUCZvd7ZfaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHHaPd4FmBCV6rapFMDun+drIxR6g+mTOGqd1IaAYIg=;
 b=cjmxLJL4BaHN8RKtvrTYf524cFg3H/M7bFo0ipraQQS5QTbKBdydzIo9ThEW0mCJrC57BlC5ajb4+6nAFbZ38Kyq73N0fRKdKdrjKahoY6+BjHBVj+n4w4YCNZfUFWYjJV45PYP/4Alc51P4h0Dls4SfGpKAac0opUOk58AEfvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:37:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:37:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/6] net: dsa: fix missing adjustment of host broadcast flooding
Date:   Sun, 22 May 2022 00:37:38 +0300
Message-Id: <20220521213743.2735445-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21853cb1-22d8-453a-a3d0-08da3b722c9b
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6275938F86B05ACB7FC450B8E0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgkm9TrpAaJkhLrWJP8fgBl3h9zc0PZN1rTIGkBh0BpJ6soczhT+A2HtgFwD+36MtHOLCWEnWJjfTaTyiMd9BVuRwBTAZPAaFj2vzR0mPpNtDGu3MUnZjU6rzZpKXdWFbAWVEFhhbtMI6DT3cjWctOHFuiM0Q0s4HDEqJEJ7DRadYZJ2U9NFCVrwPBWrhLvjVnF0oXgx4ofG+CqSIh/N5d+fzQ9TbG/oMayihgSFFSmj8dZS1kEpwjcKE63+JkME81+UKt0jVA4LU79ahAULsglLT+yOR7Rc4qb1YLBeucBJqWAxpfS62EF6lVO7uOsUkV/LlKZIl2GArR1i8l/qUPzRqNlN0Bh6qSIoTgHp1YhzAdphEfz2sXBYNdkjpOZtOp71JR0mkL7ENtDFZGZmhBTCvVbDOgDJ3kV45mRXXtxDasFTpKSX+h7exWxAuOV+/SeAL6ZeoKZgneXhne45IL1KlvBkA2t7eIR53/fC1jTxHI6dZWeChYsB5rkQqRdVTnIm/bKR7pBvdxQViWTDHRnRYNd1aheYCrscbeoL9LIeqEpVVuf/SAJAmVcN8dKrlTQ05ZRyrWBJM6ANjxp8cU2rZ0gBwl1gjUJPTXR17N0wCOZwq5+dVw5G5NwhvBgTNXSWXbb1DFTVV0XsFr6y6W92umMi3+2ZjeAi4k4byzposkZdHMhaCbkna66wyll3MylGc1qXEc5VEXC8RliPqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AQC47HrnfGJl+MOagv24tbFs8o2XmT6tMS6HliWTR5aq3GMS2y75il2pgWnp?=
 =?us-ascii?Q?khYVqKymxhrkwh/fz8LsW2DT4Ovj+ZGBFq72x8wY4LydLIySEIgyyRhWSt21?=
 =?us-ascii?Q?LOpL96bUzYBAC40Gp6Jsj4QT9uTOq6KdcyZGAsag28W0a5i58MM/TxPbiJKG?=
 =?us-ascii?Q?kQZiUzL5N50yctvsXO9IJ4q1rXNfkkV/xr5wyQ+Z2R5RBZ/hMMHefeD7sZoJ?=
 =?us-ascii?Q?GPbZj/q2k01I0ZoAj7hLLtAw1woKv5Tvr4GGsxtQSPcNp/uX26FK0M4NwCxF?=
 =?us-ascii?Q?ea0hNTw6M/hiHKHiiTN5Qs1aaVdY8s/tFy2ZWNXWvCyjtVp+5CdofYtgRZe+?=
 =?us-ascii?Q?m3bx3K2zAgXrh/NxASVTD59pi/H+tBvLacOfiXwdJ/CydgyvnF++A+w8z1cb?=
 =?us-ascii?Q?bX9gQiObZ21LmkTUIz7X0wch1LTGA80mu1ZBa87dTipFhjBulfqmaWOgEiU3?=
 =?us-ascii?Q?js99IxIadqoa7xNI/K+XZsvWVaCgGyzeyaZnb5of7+0ZFN74b1ScNTe9vVrY?=
 =?us-ascii?Q?zPJKrhmfyGZZekzVDzgXcyeFE2DvCKAiHEAqcmEP71EuQN07TMp2SfaheJZu?=
 =?us-ascii?Q?1yAEmuXUrm4j//RbqTQ6MGxKN/zHMgj8DBhdkCwFY6BT2B/oRPdMyGV54KCr?=
 =?us-ascii?Q?MchQbjk2i/2wymIXh+JIlmq7V3RzPgQ8wKqMoRB2ztkWGb1HksBVbCo0+qCQ?=
 =?us-ascii?Q?21Z2kvX9TEUuyYLhGIUa9sMXVVECApxmJbznx49cB16nFy6kdqHkVLs/EGee?=
 =?us-ascii?Q?KDz/j3H/wc/hxpxyK8DmIFIPVyy2ceNHke3oIa3SzM66gFt5vVfTTOXJrfWi?=
 =?us-ascii?Q?APXriI/5B7ZzzksI1RlUWljaf4cZy3n04x3slX5qECjjRTUGIueM5nVOdAM+?=
 =?us-ascii?Q?muC+VlNS8QbMW54lMzXlXfLBosFNRAJo6aCEqq9OHKC3f2Easoqt5AWzv2fd?=
 =?us-ascii?Q?ctQqUhzcSjcmKjga0Tz/Nh096XhUYGLJf0UiGyTI+KcfWeU2zFm9nNFTJZu4?=
 =?us-ascii?Q?jMvFRCvc/WO4cehcnB+sxaXMTndSPoUTl0Iokjs+TX4Nh8xAcGxY3yMt/ylb?=
 =?us-ascii?Q?2U0E8jpcn8O8sJRz2vUC33S+Fa9c2J+rIAqFmh6tIEsjlwWP3+JpEseuA7sn?=
 =?us-ascii?Q?2DajwuwkdnI12sGjYtST47UNjIfMTBawGFnkNbjw2SM6fcsa33zUqQyZFQt1?=
 =?us-ascii?Q?NTsBZnvoV7fKEzI/g/mSNLoi4XjP9/yxfPKMXatT689NuwfNlSsukFRAsq9h?=
 =?us-ascii?Q?LnoeiBj7kST6uEEsRKsimpimgeAo0ErUHc6mkBBBwtfMaj/hDwS1HcmYpBxj?=
 =?us-ascii?Q?HH+1u01yMkkDOA3Lsd+Y2Nf15z1VZxfOjLYfvLZwlNee7KdXkNelFrwfme8/?=
 =?us-ascii?Q?w2oQ0t3zhmOVKyEQNg11VR8wU11xzVy8p8UmkSgluNExdLzqe7kIcdwKgkJ+?=
 =?us-ascii?Q?vHHTLVkPxjkZG4HyltHwGK9O7HJOnq/rrCwcfAoAJttAu4TSeTTFk2rDDdj6?=
 =?us-ascii?Q?yeuaDQ4alIMa1CTxGrFTJwqnh4CB1XYI2A8bhddrZhHxNgxLAjlr5kKyzGQ9?=
 =?us-ascii?Q?73bNdXF48WMep7bCgLbET1X8Dk6+6jZrXfw9tj6jLpX3J3rN4JJ0RRqnwSCc?=
 =?us-ascii?Q?0UNvpGFAhqttJNYJCtAykahuJsEXFqBX3BcJBevjk55ZG0DaiSeGz5Indcp5?=
 =?us-ascii?Q?enZXlioHaw64SSoB8BOc6cFLlE39Lt3wU7vQA6EDJtE+CykaItppEs/KQAEN?=
 =?us-ascii?Q?RI5+AHztFXbQ5yB23BHNS9v09ki8XTY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21853cb1-22d8-453a-a3d0-08da3b722c9b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:37:58.8929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LI/gbznlXzHm1jXHtJ2YWBFtKXXKekw975IJkRa2zqVTpBJxavYA+9cpBRKwPeZvTK1eKY8SuUmpVM6FUwIoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PGID_BC is configured statically by ocelot_init() to flood towards the
CPU port module, and dynamically by ocelot_port_set_bcast_flood()
towards all user ports.

When the tagging protocol changes, the intention is to turn off flooding
towards the old pipe towards the host, and to turn it on towards the new
pipe.

Due to a recent change which removed the adjustment of PGID_BC from
felix_set_host_flood(), 3 things happen.

- when we change from NPI to tag_8021q mode: in this mode, the CPU port
  module is accessed via registers, and used to read PTP packets with
  timestamps. We fail to disable broadcast flooding towards the CPU port
  module, and to enable broadcast flooding towards the physical port
  that serves as a DSA tag_8021q CPU port.

- from tag_8021q to NPI mode: in this mode, the CPU port module is
  redirected to a physical port. We fail to disable broadcast flooding
  towards the physical tag_8021q CPU port, and to enable it towards the
  CPU port module at ocelot->num_phys_ports.

- when the ports are put in promiscuous mode, we also fail to update
  PGID_BC towards the host pipe of the current protocol.

First issue means that felix_check_xtr_pkt() has to do extra work,
because it will not see only PTP packets, but also broadcasts. It needs
to dequeue these packets just to drop them.

Third issue is inconsequential, since PGID_BC is allocated from the
nonreserved multicast PGID space, and these PGIDs are conveniently
initialized to 0x7f (i.e. flood towards all ports except the CPU port
module). Broadcasts reach the NPI port via ocelot_init(), and reach the
tag_8021q CPU port via the hardware defaults.

Second issue is also inconsequential, because we fail both at disabling
and at enabling broadcast flooding on a port, so the defaults mentioned
above are preserved, and they are fine except for the performance impact.

Fixes: 7a29d220f4c0 ("net: dsa: felix: reimplement tagging protocol change with function pointers")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d38258a39d07..78c32b7de185 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -534,6 +534,9 @@ static void felix_set_host_flood(struct dsa_switch *ds, unsigned long mask,
 	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MC);
 	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV4);
 	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_MCIPV6);
+
+	val = bc ? mask : 0;
+	ocelot_rmw_rix(ocelot, val, mask, ANA_PGID_PGID, PGID_BC);
 }
 
 static void
-- 
2.25.1

