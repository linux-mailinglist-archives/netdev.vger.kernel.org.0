Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D08E310C0B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 14:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbhBENlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 08:41:47 -0500
Received: from mail-vi1eur05on2049.outbound.protection.outlook.com ([40.107.21.49]:57153
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231249AbhBENir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:38:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJVTe3ZjldgArdDcZdFtMiFvs/GosYh/RibFHRXrONGKpPEWBzVPO+m65g72lB2i3o/A4JkSEg/aXQTqLbV5IFJVLx/D7jn7g5XfGy4hCTddkAdCUpDx5YojLLQI+OaRjqOBInb2ZXsocXuEz5silLjwC9rIgjY6IS+XHvdM2eP1K0VQkDJCadIsbKZmL/FHnNYSgpXGnzfIOV0fs61KsEvEtU4SJyJ32uD3O3LdkjtmK0mTn+vzWHiHbxHtl3b/jQLkvzH/o18PiotGPbnAwuqEbndk0ngR66sTUPy3m8KsiRHh1v+wnyXADp25jOC0PcIHeuHgZ0+6e5Dwq0lN3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3DP491hSf/yuxvTlSKSqjQ0BDNOCvb2E9MLjKxqNFs=;
 b=eLK+R1tkz69xo3EWw/7rQacC03JEptYHO5N/9ysm7agNyjNQBOZosdtq+W1Lp9qbIOVQPSnbnq7VYWHTy1Kilayv88jZeNMleI97kOnnIUYksQvrF1PsojhYCWK2I0K3q17/hu6Qprh4r1WJSe3KsFiX5nL98GxSzjJqz0kelECoBGhi8o9cmlmhXlJBC+sjuscrJceXbrxvd9ogoajdDErI7C6+fsmJh4eZ4FzBFlF3iEE9BRtR+X4rIHP+wgu/NXsiBM1vbPS9bV7oeLVk9R0XrtJmVWpAzbAa7QSyq+YixrcmQnUmYYQ7aS2+9nJyEWHB7T5WwgNcNxkjkDqHdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o3DP491hSf/yuxvTlSKSqjQ0BDNOCvb2E9MLjKxqNFs=;
 b=WQjoIARvLS3QnANlgmMwHr0ABnS4nDqAUgbyRWtZEpf50qViwtQRLq2Ay2GOKunx22L+/Jc4Hz0m2p7OzhEf07pPz1oVbdfruapKNuN3BgOfY9cS3sz/oB1kmLbwkBBZ/EGEVt3QlHswAxA9WhBxRhxidClxtUkfG1bdIDV0/R0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Fri, 5 Feb
 2021 13:37:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:37:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v3 net-next 1/4] net: dsa: automatically bring up DSA master when opening user port
Date:   Fri,  5 Feb 2021 15:37:10 +0200
Message-Id: <20210205133713.4172846-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
References: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR09CA0138.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR09CA0138.eurprd09.prod.outlook.com (2603:10a6:803:12c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 13:37:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47cf3a36-630b-49c1-0552-08d8c9db2da1
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49106EDD6C595CF9154EE7CDE0B29@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tp6tnA6LMy4mDP0RjPG8a3XcxiPqRc8kLRnhF/SubZ4HMnRQFcXchmW/dN3KZzYiwumY4Sx3u9VHWGBL0QwURDXiVg19DUO/0HOw7EM3ySnuuE5TAf5BKilsPLobiLeGo4NGPA+70sX6xBq1HHeSEtmGOOOF1mo1IdBbP73J/uDby5RmSQxLhG/F9BcUakgDQ5wWw20qJNkxi2AVznyo250YEdGeLt49J0xqlf1azX2nUmp2oa9Vvx80b1X9TZ/8nxk19+U0lfc3iMwW3hhzv17fWMlYejFZuYufzdWoAOtxnWg1cBK4gOcmmli//TRTC4i93sU11bMgbSBh0V4rGtzh8ynrh8H2Y9uIC+6vKlB70IWB+upmbQaXcBaCznKVigaQI0J4unTiWMhBkuq9s8ZVuVMHCs3mxPKSYAFFQ6vDhb3NA6YLE3QN4DuuXGTqdrGiI+blW08G0cDsw8UrDQkxEgn8AOrDtPG+9B7dGo2zJ8oPHtcI7IRBdlTJU4jlqPW3OfTalScKO27R5BPs9gFrTMdMoka0j+YEknTccwcA9MZkblBQtpOd6+8kUw0TlFerKe/s/BxszU1AZUoc89JNF7J2l67LbmVEvfts4OqwyFKbBkQPJ++lsvNyKSU6gDzz3hqZhfUDIuaRNP1B7oTPmgTdBVCg0y2h6wozRDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(2906002)(16526019)(5660300002)(186003)(8936002)(69590400011)(8676002)(2616005)(1076003)(956004)(44832011)(6486002)(478600001)(966005)(4326008)(54906003)(6506007)(66946007)(83380400001)(86362001)(66556008)(66476007)(26005)(316002)(110136005)(6512007)(52116002)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F5e4JySiCEOIM/stTeID0PwX1hwFBlkCQ3xh/5jr1EG+oRevi/YXpT42vrJ0?=
 =?us-ascii?Q?tYYVl+6pxvgO+WMhMwmpLH9qOueNkD/NAdNZnspoIMwa4/UApN4YAMMExnn1?=
 =?us-ascii?Q?56NkwJd0L07h3XtuFspVSgvag/KpuPng7fYo/Uzun4HqopaEJeOF2jG5E062?=
 =?us-ascii?Q?kGHHB/mTkRibLbNDoBc5gc+v537pu0GoYcj0fJtdUmHjgJM42bFb9BLB700H?=
 =?us-ascii?Q?f3cmJFqmMlCPYTJWXnarzdA1vvWVOjEr69uZMBJRGAz6zVQg68B9WnVPAtnw?=
 =?us-ascii?Q?/dNLWNZvefuRQ4TfZsDGLDImlnQEn9mm0PaN8OPmy2a5ISLK3vAYohHtjNo5?=
 =?us-ascii?Q?LLbp4S+yBz9tMjujFsyDJT+mhlXQWmSISRnyFP/ZHAngEx3MWQEvfTUmVg1n?=
 =?us-ascii?Q?2IyyOrU/5IL+3bySD6wEV+rwzYBuMEOnmY9vcRPiduTubO8Mv4E1Rz8DMDFa?=
 =?us-ascii?Q?JARnHWjg3a8gfiN+rtb7Dw28i82TzFolmSoozYTeXkULAnfOoVlfiCh3jS+0?=
 =?us-ascii?Q?a8cjI6uJ8YulixE8/866Faqt4sASTxn8ybw/W0xTi9T/cc1mEmWBdt3/Vx/W?=
 =?us-ascii?Q?+PKUFl/7kUkBc+QmG9ktItkYzWnD37swVWhp0UW7XmgiGVCsTbKkGCOr1xCh?=
 =?us-ascii?Q?SLvmVLZhU29r1SHH5s2JfeXN8DJmaOGTysA87uPhpnjquxVpIFuTovrOXcmA?=
 =?us-ascii?Q?/n3KiAOj6v1hSG2nqQ08NQvGTkK8QCjgTXF8VR0aoHyo1aVk7Yvfijr0qkQE?=
 =?us-ascii?Q?+//CVa2nK7dYT+i0sHNFKZlmANcdFW2v1Ch8h1d5ozodf14HeNVkcO9D1Dmv?=
 =?us-ascii?Q?f6LHnTVAiLudAfddM+p8l+XtNP8lnGcrlQCDN0cclLA2kOCFgHEpLqYgIDPd?=
 =?us-ascii?Q?PjZ5TQAO1JBd7vZ9NBxgZo3KqOzhMSTS7PCzgNnVFyjkExcNdHv+r8EKSAYX?=
 =?us-ascii?Q?q+5KJ8MgD4BTSicXtzGkSfdTtUJQMDHYYEqobpv34zkIvChlPTm5UsL+bCiR?=
 =?us-ascii?Q?1mL5JWY8vWlSo+GFpUSRl4HYZYbSQuPCxAaV75Y/2A10dFioqCMZfi2PdrhY?=
 =?us-ascii?Q?tDhcYr73rUlVYjOAsy1FZQ0miDohvNG2rOFOzjSub4gnnt3AYvkBM6lauFT1?=
 =?us-ascii?Q?2+dXhcubFmvydl/RgEucEdyBTbBNqBoxUT7S0fdZwzC+aatghwxWfAseVfVI?=
 =?us-ascii?Q?rGreZ18G4uf2+z0rh9d26h36o3IUc3g0tRZsrVQKIlK5pLjtlX5S+UCWDCX6?=
 =?us-ascii?Q?m8/kWFhYHhWuhfWesY/3HGRYa3MX6GmNfYZut++kgEOeLeo7PXypSmTltq8j?=
 =?us-ascii?Q?09coWGhuifu7ZHL/AViwS0Mq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47cf3a36-630b-49c1-0552-08d8c9db2da1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:37:27.5452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GrSzugLk5h+ayHgElj1LJ0fOiYavc1J1vuRLGdVV09RHfXPTU+wKug9jSfyFxd2UhnFl9L6Bblsefk9TZYZOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA wants the master interface to be open before the user port is due to
historical reasons. The promiscuity of interfaces that are down used to
have issues, as referenced Lennert Buytenhek in commit df02c6ff2e39
("dsa: fix master interface allmulti/promisc handling").

The bugfix mentioned there, commit b6c40d68ff64 ("net: only invoke
dev->change_rx_flags when device is UP"), was basically a "don't do
that" approach to working around the promiscuity while down issue.

Further work done by Vlad Yasevich in commit d2615bf45069 ("net: core:
Always propagate flag changes to interfaces") has resolved the
underlying issue, and it is strictly up to the DSA and 8021q drivers
now, it is no longer mandated by the networking core that the master
interface must be up when changing its promiscuity.

From DSA's point of view, deciding to error out in dsa_slave_open
because the master isn't up is
(a) a bad user experience and
(b) knocking at an open door.
Even if there still was an issue with promiscuity while down, DSA could
still just open the master and avoid it.

Doing it this way has the additional benefit that user space can now
remove DSA-specific workarounds, like systemd-networkd with BindCarrier:
https://github.com/systemd/systemd/issues/7478

And we can finally remove one of the 2 bullets in the "Common pitfalls
using DSA setups" chapter.

Tested with two cascaded DSA switches:

$ ip link set sw0p2 up
fsl_enetc 0000:00:00.2 eno2: configuring for fixed/internal link mode
fsl_enetc 0000:00:00.2 eno2: Link is Up - 1Gbps/Full - flow control rx/tx
mscc_felix 0000:00:00.5 swp0: configuring for fixed/sgmii link mode
mscc_felix 0000:00:00.5 swp0: Link is Up - 1Gbps/Full - flow control off
8021q: adding VLAN 0 to HW filter on device swp0
sja1105 spi2.0 sw0p2: configuring for phy/rgmii-id link mode
IPv6: ADDRCONF(NETDEV_CHANGE): eno2: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): swp0: link becomes ready

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Using dev_open instead of dev_change_flags.

Changes in v2:
None.

 Documentation/networking/dsa/dsa.rst | 4 ----
 net/dsa/slave.c                      | 7 +++++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index a8d15dd2b42b..e9517af5fe02 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -273,10 +273,6 @@ will not make us go through the switch tagging protocol transmit function, so
 the Ethernet switch on the other end, expecting a tag will typically drop this
 frame.
 
-Slave network devices check that the master network device is UP before allowing
-you to administratively bring UP these slave network devices. A common
-configuration mistake is forgetting to bring UP the master network device first.
-
 Interactions with other subsystems
 ==================================
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..c95e3bdbe690 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -68,8 +68,11 @@ static int dsa_slave_open(struct net_device *dev)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
-	if (!(master->flags & IFF_UP))
-		return -ENETDOWN;
+	err = dev_open(master, NULL);
+	if (err < 0) {
+		netdev_err(dev, "failed to open master %s\n", master->name);
+		goto out;
+	}
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr)) {
 		err = dev_uc_add(master, dev->dev_addr);
-- 
2.25.1

