Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E421451E781
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiEGNt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 09:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiEGNt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 09:49:56 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20083.outbound.protection.outlook.com [40.107.2.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C632408A
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 06:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4fu/uT1AD+ECdmxxQyTNWst5y+ubNOWX3v573oe1b3RV/UtQZpIa0bajC+hDvpnBcN3IbV2yyhjWUMG+krqguiOOuYKPMZ5BzFUuQ8Ta7Vkjz/c1cWGoyJ3z5lyRYGawVZvbUQ89oiXsvOpdmyzCIm03ZesieOR6AOcqeVvJnanX3GuOJ3HXk8tFMPQ6ApMCSlNkZEP0ULNs18dG/rHcMRuzJURc4ZdH06sjG2IqhcE4bOH0zBTfpXFig6Av/2bJwM2dylq9cyut+u+yNXbrUKxzMxHWaXPbwZx/vW/m+3HTopAi7/cxVcFaMFC4J4xwd7w2Lp4Oxo05aafZxaKYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GqSCwOkCx6ZSejCJ7VCKRV7KuYOWmOOGquaAzalgfQU=;
 b=a/HZoWxbj9fWR4khC+2hkN73DVRAxpUvG26rsdd0D19R+oE1JRQ1fetT17VwbaiFXt68h0p2Wt2j44ndaazfe4VXNQv63+OBR2+l0CWPNgxZQMmfFye0mPy4mUtjVGvlQ2dIP4jOxuIV3LN/GNz1VfKxzqfInkJfyswmVCjRPasNNDTyFaxXqU+Mi00K6yHG23yX6D0QNlB/TwC4RWBGoSEzPzFRm0GXfjSNtKnV7bVTIUHXKkyYJ4OG+YTVl6OYYz4RMwZVsn/YU4EUnKwYpcH/KXy2gsvBlf+i6Btk74GKdTCj947zNIJdSs+XIYFSqY9AJ99LiY4I1+1wHqIqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GqSCwOkCx6ZSejCJ7VCKRV7KuYOWmOOGquaAzalgfQU=;
 b=P0xUqUIeUlk9WNjutbHIjyqV4JWRQ8eNr7yTniPWOOL+3PtL0IZJkHWq2c7Rj76qMWskC2nRYsMfVEkefc7j8tICMcxmhVo4BtkZbfn7+1872/nQPnoPUZZ942SbqbrCQuCLlUgS18s9TKchsOJ6HRI7geJAYyOEVM9qjMkYkZU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB5929.eurprd04.prod.outlook.com (2603:10a6:10:a2::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sat, 7 May
 2022 13:46:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5227.018; Sat, 7 May 2022
 13:46:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: flush switchdev workqueue on bridge join error path
Date:   Sat,  7 May 2022 16:45:50 +0300
Message-Id: <20220507134550.1849834-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0005.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1ad649a-12dc-48e8-fae4-08da302fede4
X-MS-TrafficTypeDiagnostic: DB8PR04MB5929:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB59291F434C1B29FBF77ABAA7E0C49@DB8PR04MB5929.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 221svgwOwlrosbdM90FY9bDyGUzI3flBw8lSJEtdpEPTiG6PRiGWp2AP6aO5ZtDaQrcOpuXSTEzh+NiqSZj546ih5rRd4e2tWTFTiV8f2WZTV+T3N/dIMV6EyYw/c17qbgh8LxM2qRjV8SLWYaRVvawyt86WhpIJLOlHJLaHy7KVL+MlrKPVYVbnBxX3fwTAx9GqvjlEj8gOxfUMfMhsbJRXCNBf4RsbacIhEnSfkbmxq2d8qksE++H85ub65yOcG4IVn7V717e+XEBvUZ7fwMuQNCep6macZjFe9RdmT9wKZp2zMN9CVe1DHocG2UfnuW6K7R3nzPEL9VdhED4Rae+WPS7U834vfzMeckT5hQFAzCDCAwGHl/90/mJAj0HwgiD8H1XAa5dYKyV+gz+go0xMzdNoxaKSt7W/15z5wDzDvz+4afylOrsVRHI/Jv47tlWHBMnA3POr1v82Ec3wz/6jr5WyRF0oV1X9S6KnwVEwLCpUJLB2D0CTkgh8WZ/dvI9AoOhR8DtOygkXAvOyFfTgvANs41plKRriwHQk2Vb3RWtIsSXfaL89S2ibDktT37XHGlz6aCLa20V6iTGUBxcvPQ+BP+u4unRzVb5JZTpe9WMjgNqBtXEzAFItPj42dYfRKtYlI8bwwA+YlxkkYHeWTxZb6UvDIc8X4UC2F851lyVB6hPFSp/UEa3v7/fC9DeX0vxdTTLBgXWP+xzXzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(66556008)(6512007)(26005)(66946007)(38350700002)(38100700002)(6506007)(86362001)(8936002)(6486002)(5660300002)(44832011)(2906002)(508600001)(52116002)(6666004)(54906003)(6916009)(2616005)(316002)(36756003)(1076003)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzWywKpX5n92B51MkBaY+bW6GTMtbhxql5HKsY9xxAuAGWU79gMC4gc6kwX2?=
 =?us-ascii?Q?6sM3dytLWxYJltHID6Gf4W0Wps5lO74qpCrqZH9LzYrWFr4pD6XKrUXUZ+1Y?=
 =?us-ascii?Q?jLuemyXBjJnLydGk/IJVs4030y49RM08YwOHNCSoDNIbPt7ooFumpwQb1R+i?=
 =?us-ascii?Q?vczk+QrRPS8J1lptcWN6TWc6cHhBkOi7BXIz6Bn/xu7A9RIWO7F33tjOX3Po?=
 =?us-ascii?Q?fWUp6qUZvgaODGgFZ9uSAC/TQGC8jW/ueVAteCgLJjTtIA+bxCsFNxP/EBGD?=
 =?us-ascii?Q?TKwMkL+PdJX/vpF+dUxKQmA0q6HiTjdlPn47PpoGm5XhQwRIX/5WyTKENNUm?=
 =?us-ascii?Q?Hz25as9n5aRa0wogy3b1fc3Ouxwkzieg25RvMXo1JXcheEL7mPgGWNpBSDYK?=
 =?us-ascii?Q?Etq5ZTP0MM0i1rQtiahBmv2YQXr662n/wWlB31lGHoLpxQceb4sfLYoz7rnL?=
 =?us-ascii?Q?gapylovhcWDwpXNoWvfPhIyS91wIuL7w9Ei1TyO4FP+fdUrFcH8yDezZjOTq?=
 =?us-ascii?Q?+Cej/ZizPCGxx3hSRkwCntVElq5gBHCWKNSqCKYkluexIWRdZ8JMi2oVhhKT?=
 =?us-ascii?Q?8143zfv8aTwHW2BncbK4Dd6nL7XD6/osWUN/CXLK33/wPVmrhQ49irxmnwIE?=
 =?us-ascii?Q?Khf5LN4n9WiFKs5ufWGwCJRlvIkoCrBjvTycGEUpOKXLFA4dPO+WfA4gFXtn?=
 =?us-ascii?Q?SsDE70s/yBFncNrz2VnsIkuSLUXs5pvIG9jGvNX01Jxa5YITQ4nHf+zrC+mj?=
 =?us-ascii?Q?EX/mkHgv7T9H3eVd9k57tGMAxKWADwAwWli4ROgsXNwm1CTKJwqvTLcPp1QM?=
 =?us-ascii?Q?fZMd0CPMT/PYd+jHuxu2c8UbY9TOOcOq8kTBOg2AuF5FCVqKwsecZ0OXfDO4?=
 =?us-ascii?Q?lGI/g0d6jR4+N1nYz2wlyKish4SQ8tiG+h+tk9SCQ1JrsX/yS161hE0ADi7P?=
 =?us-ascii?Q?xPkmKUBE7xawrc4FqzmOrS16+rUG1x/cOFmwPbCq4N0as6AlRuv8MtzXuo+X?=
 =?us-ascii?Q?NsmEiPYaCouoNq91zaj/NcLC98KyJrL4EUJed18E7Wr/Nct5m4jcfPxbEiLs?=
 =?us-ascii?Q?Hmlg2VcUJtnuek1T8qSwud7OKGzNRBY1aaM2Z3TkvWbhyJDfTTHRFLKCDa68?=
 =?us-ascii?Q?BZYmucxUiV/xwQ8dtQReJrVjGM5m4mTWsUop1UNZ6UGX7c28/YVb0kaz4sKz?=
 =?us-ascii?Q?zO41U8LjlFZ3k/UDtPyh8qzWbyHmsC9yzy5+4u0dmISpGNgqISCe+REzh1MU?=
 =?us-ascii?Q?1HrNdbu1Lzj2YQworJqhmUAWpovIZVYfwnBeaVt9lW9NK8heheBoc++Sp8+3?=
 =?us-ascii?Q?MV+QPII+MaV9zvltIisBEzTM0+1k04vHmAfno2H5XfDxvIXFj8vsQD+lOXtp?=
 =?us-ascii?Q?ZLo0Ol+mKEawkXBgysmpzo4fwAGaxBoS2ds9Oqr4208RzY3/wVCj6wSsGg7s?=
 =?us-ascii?Q?XMWBIPzRXkJirkx8q+0+C1tLZdK1Z6LWDGm5d3qG+e5SZKIDzD/UZOTqlRBf?=
 =?us-ascii?Q?C54lHSLmupU/Teyj1m5vaC/roGBlVybyFvotb2cD4JXOLpe5LBrMoQVhL7RP?=
 =?us-ascii?Q?vRgGEDZA85jv7mJIrneHjUuHN14HavTbscbFWKch1PSk29kLbB0+aibii7jX?=
 =?us-ascii?Q?gyT0NuoIce6kQWMkAX193PdAXMhZmBHiheCLUolgEAiSkQXQMxwmOheVt1vw?=
 =?us-ascii?Q?FlWqHS1jKzWtY27BdQfkon6eNLRaUok8JnNTIjbX1Sarn/LOgJHiqPBeAr/r?=
 =?us-ascii?Q?4bZ2vl6AHYL7GbwTHDzzBva1D3VnlXk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ad649a-12dc-48e8-fae4-08da302fede4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2022 13:46:04.1492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sCILqslT9b6cd086R/vmLXrCKCsrRxLOWNdr9f/lW6vH3sPc+3yWZkRPgkvNo+39Raq0xG0CKmIJ1FuDRD0+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5929
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a race between switchdev_bridge_port_offload() and the
dsa_port_switchdev_sync_attrs() call right below it.

When switchdev_bridge_port_offload() finishes, FDB entries have been
replayed by the bridge, but are scheduled for deferred execution later.

However dsa_port_switchdev_sync_attrs -> dsa_port_can_apply_vlan_filtering()
may impose restrictions on the vlan_filtering attribute and refuse
offloading.

When this happens, the delayed FDB entries will dereference dp->bridge,
which is a NULL pointer because we have stopped the process of
offloading this bridge.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Workqueue: dsa_ordered dsa_slave_switchdev_event_work
pc : dsa_port_bridge_host_fdb_del+0x64/0x100
lr : dsa_slave_switchdev_event_work+0x130/0x1bc
Call trace:
 dsa_port_bridge_host_fdb_del+0x64/0x100
 dsa_slave_switchdev_event_work+0x130/0x1bc
 process_one_work+0x294/0x670
 worker_thread+0x80/0x460
---[ end trace 0000000000000000 ]---
Error: dsa_core: Must first remove VLAN uppers having VIDs also present in bridge.

Fix the bug by doing what we do on the normal bridge leave path as well,
which is to wait until the deferred FDB entries complete executing, then
exit.

The placement of dsa_flush_workqueue() after switchdev_bridge_port_unoffload()
guarantees that both the FDB additions and deletions on rollback are waited for.

Fixes: d7d0d423dbaa ("net: dsa: flush switchdev workqueue when leaving the bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 9a51398865b4..45d0da2dbb9b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -504,6 +504,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
+	dsa_flush_workqueue();
 out_rollback_unbridge:
 	dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 out_rollback:
-- 
2.25.1

