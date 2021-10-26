Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A244343AF0E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhJZJ3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:29:32 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:6192
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235192AbhJZJ3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:29:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zz602RJ6Lqgu31RhtkPqOmY9aWOGVxwSJbZY+wFzsqY/5HOl8PTxh/F9lDoq6DjVgxtjisi6ioIfRMWCurY62yxaSjoocA1P5Xtapa5uJT54cJYLgLcGJW/ZZIfMaOLXIGLys1eAqBw/YzSQ2PjBwbrOboo1TnKyV0dLjqEaRdq7zuRMrplp5Ld6jcFP5sQUjlP9TY6wbBRfmug4kS8Mf703+dPi1XlCZhmd4Q2jhjUeieLrAsim7cDj355DPu/dByFS+l9EAG2YORvlh5bPxvkOH7xqrzAzJa1TwMh0vsO4hKceA8effNX7PcmM8at9if4TMneHhsF/Viwj4JZcRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KxUD6sr454H+LtvHmFnSfU1Wc0xuQyUT+NXqvyVM+Y0=;
 b=oS/dIiP3vIsd0sf4U11qdX+CfbF6IV3mJVK5cxDZMN6dnUYb46uKeIPyeYpLSiJq2o3zl6Mr7q3/KZgZxeL7YtPqsf0Za68qxYRw5ShZLQ4l7CdAonKSAQhGBUJKdYPROv2cZ8F4fj5I/KREv5Wp5hfL3Q+7NWZsnzx8P4Ew2cgo2aDUCuKvUvdhDUI2LEaD6wyX/wt0sxhUR9eTO6GYf3d8sfGUlhGItNtyku+flHImnDcUpxenvvUIqT7IVBaEi+NOagDYmITpTAwy1dPsq4TzHdn4l1r5opf3c8A/U+ZkCE9wEMBMx5o43SCbz4Ah/9hWNNpssVLd0guK4sx3rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KxUD6sr454H+LtvHmFnSfU1Wc0xuQyUT+NXqvyVM+Y0=;
 b=CgaWOwZtLxMfN2cIZvh3w9jyz9+apuU2IsCOhk+PzOLLm3BDHXbnRSUWn+Bou0l6Z1vThb0FUqwVsx+EaJuokLF7fKb73Op34TOImX+CsFLe/dpxidyPB1FJgzfvC4iksOgSdC3zBDub7lKvV7qeCQHItEyaU3t+obU39Y7IkuU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:26:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 09:26:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: flush switchdev workqueue when leaving the bridge
Date:   Tue, 26 Oct 2021 12:25:55 +0300
Message-Id: <20211026092556.1192120-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
References: <20211026092556.1192120-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0024.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM8P251CA0024.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Tue, 26 Oct 2021 09:26:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c6547eb-ad55-47ba-870c-08d99862a79d
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104E2A2A2F2DDBC715C341CE0849@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRoqDN7BwmnLo2eymerRMxJ/fNn7T192I/AtH0bykEsiNlkwtEder0P2jfU0B1006eZqZ9tIeFCnq1O2/P/29LEihE4qa3ZCyiNX0DcbKA9+pbBalINkby6Znjc/xMgh4o8QYkj4BinMdpQicCSbaNRfSV39P/WetfHNjubaGk4XTbwtudz2sB6OqDVIHD9FCwR4QXYqA7+huuEWscIY/AG6ywsWptTTMvaQKiKHU3UXmoL0pKPXsbbKOnF8UGeD3FvqO9nPkaiyHotditmzFL67YHZ2PbB4krgumoz3rPYJi+eK9qFKo5Ek4ZEduNx+weQAV29TYa+WJjEREXAAwcfr4kLTh1sgRb2Kzrb3klgPOHqwExxRKzcigqbB48+9IUtkOTorQim3tfazIn+Vdk6wgPDfNETePjQGKEa6nN7bzk2BWqosHN7GR+a5Wj5f/6S2XDojUasaNFTG9MBRWffr92C7Yb1ge33f+1yWxW8l7+Mib0DsVXzSXSKO1p16qCNEyueSA+RplJRPSgPUWeUch79GFItNlqZzLqhLB0/5HJzV5vWpTYw4HPJuxr7jbgpysFIjTblhpyLLCnSPjdmQVht4sWpGFd4wqm6wp7Cl3ShKz6askqQ6QWID5eWhTov66sD4JO6f8aAd7AqpjlqXmaLMvr4m6/RU4buDg2QejAtdDaZY+DgXQuLW9iLpdfSVQkA3zeE621Rd+RtZWp3edj7DYyuMb/sXfS0T9YPiyYaobSSSpCSRkSAYKNDteN+Nd7eGGovJve1AJRBUbm0XQ13e0qXTnUzd67gllJI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(8676002)(6666004)(1076003)(2616005)(956004)(36756003)(66556008)(6486002)(86362001)(8936002)(66946007)(38350700002)(4326008)(186003)(110136005)(44832011)(54906003)(5660300002)(66476007)(6512007)(508600001)(316002)(38100700002)(2906002)(83380400001)(6506007)(52116002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p2FNYXBDxoWxoXOdNYovUFpW9BNVwOysevPNV8QJbYbVnXGs3daFmdDvAv3M?=
 =?us-ascii?Q?O8ZYl5lKq2l5YdK+1qC+8XBYRpGp74JVWT27ZbFbDWXKVK+gh/JJXCBkjxjo?=
 =?us-ascii?Q?h0d9GnK1O3QQ868TPFD06YfXk0TUErr8BxTKNqdSil47V9l5DFN8w59g5BWK?=
 =?us-ascii?Q?LgbwqtrTpfpUOBIiKx/YkJzl+qM+ibgI9u/tz42ZmsU7mGbSYHWcUuWE8lEN?=
 =?us-ascii?Q?/uF6Xd/+4Spe1irJPjOQsp4kDGVHEZa40M9AxruWEG3kwSJ1KbEnv+lhMDQ/?=
 =?us-ascii?Q?ZPITMy0Rf17DoeUgSoi2Gf9jh0Ejs/18Tpdl/LBJl3cKVD/89jwYcp8Gri84?=
 =?us-ascii?Q?PIA+IschorCLjNCCORdX0ChxD3BuFPJVZZXZrhsPlZZFCPiUP2YUFeRSJ4/n?=
 =?us-ascii?Q?jIHjMRVdl8TqKJUkMfdtqb/QaELXQ2JOLf+RAaGAJLE3H+xdAIhSBDv37F7k?=
 =?us-ascii?Q?Risu0E70JTRS0QR40XTM5SMMvGrrQjQO1kLeCEFlGRStyuHjRl+zOJxotWTI?=
 =?us-ascii?Q?ro/jHhzECtjGUGqjPEw7B3IhiEMzDDPlFJzeS3jz8fKRkL4moo/cd/ZlWsQp?=
 =?us-ascii?Q?MmXUYXRCEwVBWIC8HqMkznB448+PixOQwt0v/gUc/VLZBJG1OMDpXxSXPD67?=
 =?us-ascii?Q?conioGyyiQsD3j24yPq4NJj0tqzCno2eX7HaZ4fPOHUbnWMkaoaDIErsBN4D?=
 =?us-ascii?Q?yDyE8QspZwiCWHjRPGRU1EJQuyFMvh1ykveABgSqZHWhB/j3TZgYBhLy8esT?=
 =?us-ascii?Q?yeBJJFJhvhoo+xetkWUs1hWGG+XUMYrapnwmqD3QXPwdj/LHDu4h1JAgoveq?=
 =?us-ascii?Q?J7RBObpBnZD8Ble/OuPmyd12Z8t9TrfFoveBwB/YxTbF4ejCLroAoGr078V4?=
 =?us-ascii?Q?NkuAMBtwntDzwg/BR1YdqLoWBPoG4EfsCZPUxBRAiuxHrEdlzhUi6LZWPYlE?=
 =?us-ascii?Q?+tkPywra6feurpyVqhUNfQo39ecAaMVHhTVC/sjrLXGWAP0DSoHUDb7uqiey?=
 =?us-ascii?Q?sf5UkuGAV2zOwHr1ZxjCFPwj9FruyBmToEUqqri+eYmtSi4/4PvIBXYPCkwq?=
 =?us-ascii?Q?p/1tfb0LUa+I6VMMMX2JSltVzU6T8rHrZLUVgrWyeWKfnQX5M8yU9yoKfq5z?=
 =?us-ascii?Q?fBqq5Htb2gOyjiwTnkbT3Z6qSMh87UgbldcRLoqRbnXRMfoONWVscQJtrDN0?=
 =?us-ascii?Q?/rK79lVlIA699IojQ89WOXDbayy+/N5E8cPj9FwGyLPijFJwg5HaEnBHOBoE?=
 =?us-ascii?Q?W88iKHM17h9L0UkkSyHMg8XMB+8wp7JHUsO+E1vvBF+AwnAssbS3Mnt7Cg8A?=
 =?us-ascii?Q?iyHhs1xDflxZWT5GBy/gDMbk/Sd3z0+kJ137AwAeQNl/GOMgbgPxb9xjfdWR?=
 =?us-ascii?Q?AGOeA/66LpHjRAidPT1IYuyRowUxFlQG7mE7TE7q4sp44m+8tLi27I7FBHCn?=
 =?us-ascii?Q?7kqnXXYw+a06ck9M1EQ+WZlQOEx7BjiFxe1mwsC13mHiDIWWkp/Dwx+gg14n?=
 =?us-ascii?Q?T8sNJNW1Wl4OR3uRObatfBwtQsgAfxyWit1fSZXKLY1i+1xEukQ+ZeqvJsMy?=
 =?us-ascii?Q?nBz2UoPxzRGJK2ghq7L6yy52jS3S2RzGspoRsSS1WQ7OqHe8EjLk1Yv/l9Ps?=
 =?us-ascii?Q?nkMq0a1AhjyzKp+/ZTsvKsY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6547eb-ad55-47ba-870c-08d99862a79d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 09:26:13.9299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UZNBpXbqeKwnkKBSx91V5bCGfAi8iRq312/zG4ect9pIYYHAS/4s1+HQMQCnN6x2iGKUuT1+phxk4e/82CzTCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA is preparing to offer switch drivers an API through which they can
associate each FDB entry with a struct net_device *bridge_dev. This can
be used to perform FDB isolation (the FDB lookup performed on the
ingress of a standalone, or bridged port, should not find an FDB entry
that is present in the FDB of another bridge).

In preparation of that work, DSA needs to ensure that by the time we
call the switch .port_fdb_add and .port_fdb_del methods, the
dp->bridge_dev pointer is still valid, i.e. the port is still a bridge
port.

This is not guaranteed because the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE API
requires drivers that must have sleepable context to handle those events
to schedule the deferred work themselves. DSA does this through the
dsa_owq.

It can happen that a port leaves a bridge, del_nbp() flushes the FDB on
that port, SWITCHDEV_FDB_DEL_TO_DEVICE is notified in atomic context,
DSA schedules its deferred work, but del_nbp() finishes unlinking the
bridge as a master from the port before DSA's deferred work is run.

Fundamentally, the port must not be unlinked from the bridge until all
FDB deletion deferred work items have been flushed. The bridge must wait
for the completion of these hardware accesses.

An attempt has been made to address this issue centrally in switchdev by
making SWITCHDEV_FDB_DEL_TO_DEVICE deferred (=> blocking) at the switchdev
level, which would offer implicit synchronization with del_nbp:

https://patchwork.kernel.org/project/netdevbpf/cover/20210820115746.3701811-1-vladimir.oltean@nxp.com/

but it seems that any attempt to modify switchdev's behavior and make
the events blocking there would introduce undesirable side effects in
other switchdev consumers.

The most undesirable behavior seems to be that
switchdev_deferred_process_work() takes the rtnl_mutex itself, which
would be worse off than having the rtnl_mutex taken individually from
drivers which is what we have now (except DSA which has removed that
lock since commit 0faf890fc519 ("net: dsa: drop rtnl_lock from
dsa_slave_switchdev_event_work")).

So to offer the needed guarantee to DSA switch drivers, I have come up
with a compromise solution that does not require switchdev rework:
we already have a hook at the last moment in time when the bridge is
still an upper of ours: the NETDEV_PRECHANGEUPPER handler. We can flush
the dsa_owq manually from there, which makes all FDB deletions
synchronous.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index bf671306b560..c0e630f7f0bd 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -380,6 +380,8 @@ void dsa_port_pre_bridge_leave(struct dsa_port *dp, struct net_device *br)
 	switchdev_bridge_port_unoffload(brport_dev, dp,
 					&dsa_slave_switchdev_notifier,
 					&dsa_slave_switchdev_blocking_notifier);
+
+	dsa_flush_workqueue();
 }
 
 void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
-- 
2.25.1

