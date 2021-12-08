Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3776746DE65
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237333AbhLHWgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:36:20 -0500
Received: from mail-eopbgr60053.outbound.protection.outlook.com ([40.107.6.53]:19075
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229533AbhLHWgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 17:36:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7NrC4Ba2of2erqCEnoM1BsBSRMJotwwxmMRNAaBUI12BNdhrtl5CMo9he7wvHGs5AFsqwmGxWs1N5vdHsB3xhNXpAY2FGsPTkVj+PIVkHw/8NuwFYTM+tgaPWcTTMjiamdXhTmC8IkuE07OyqTskWec2vnzcmLcCMQFzjuz+syAk6p17BTnmzI8wIiZqXUGUgBuy2OnfdQFAQtqYh2sSflir3ZiPFomzxu+gb3UuCD+1u5kCrwQtE+yy5IY/gvLu70Jc0KpWLXfC6aXhyhcgzH/O6AHORPFupZVtSWxLqsTghtNNuHM37TZzLh7/lgBmDQZCv+Wp6K++BofiK8t2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYNzxW+E0K1SfkzgiXzg6/5qz5LgoJhAd9CH34HHfp8=;
 b=Lw1ocCSSDEMPFZ5DmK1rYgv98DOvnFcZSypTXRAmw3OtBxLSPC273N3QO5HfsSdVSJUppg6qZ36ArONme4DNiP+ZlpIVcz8D29xuN8839TNPB79tenwUdh4/QZknadMmIvmyyT1bxRprDj91wMKwFN18O4eR4taSC/IjHdIxImLNK9/HfOY8+lsZlJJLohvuDXgAsvFuQKs5Y+73O+Zri6Z/ycUmvCW79YdaK5PpCFY0OqjomEI1K61ybXsgjjf6+e076DaefW0Ct+dYE0t8HD1V8ICBmqzivmydiUmCE4NS5qMRhgmGhrkBsvmWBIJd8XIvpdQJJv3Dyi51F7818A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYNzxW+E0K1SfkzgiXzg6/5qz5LgoJhAd9CH34HHfp8=;
 b=FJjL2OZs/g7/uBs0cC8VxpxemJ8S2HqxvBaL/1gHbpGceYbOPJkSM3ncHl82ynyM3g3WF9JOsjy/26GiReplrYGWV6KSFeVS+v4kR1kcLI+nAGi/LJtS1rZMP3h9W33okh501+LkPbt7fDrHsvQzreCkzSZJTGC+C42k0c99PFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3070.eurprd04.prod.outlook.com (2603:10a6:802:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 22:32:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.024; Wed, 8 Dec 2021
 22:32:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next 0/7] DSA master state tracking
Date:   Thu,  9 Dec 2021 00:32:23 +0200
Message-Id: <20211208223230.3324822-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0129.eurprd05.prod.outlook.com
 (2603:10a6:207:2::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM3PR05CA0129.eurprd05.prod.outlook.com (2603:10a6:207:2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Wed, 8 Dec 2021 22:32:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40a170b9-6eed-40f9-af43-08d9ba9aa6ff
X-MS-TrafficTypeDiagnostic: VI1PR04MB3070:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB307043399019DFD0F0AEE726E06F9@VI1PR04MB3070.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: woQl0Fm3rP+YEcPvxHBkYSy2nCOx7q5OGMZ04wDcje2xi0LoBc8TWKTw5+/CdMuwCSddOZDiVigoXeLel83Nv+SK/3e+AYsEBm8mMLQ/4KVBnHD083A/IZj5RYlYfyBfGe1fcQP6TbFdvS090W6ZN1gxm3IiprhGir512elpkWXvwlK9gv9dDKyKa9cWAGCnWAXKay3Rm8VhENLqOYMXiowfq3eIqfBf25PU7tkgPQxM6NqRYN3eAAzsdBA6MYHxUQnFOzoYMLWBeUEOXBq73tiOg1seHVEOzU/tK1G+HXyfyqC8fShunja9ggpF8wNbS5BnAaqGvzcA9L5T9Tje95YSJ0kOMTaTSdU6rBQ1lgutWhbA31zmduDwS5bWSU54U4TJyRPQJnaGk4WVaMfigBEh5oa2YR1h0rdLINPqfBcf/6g5EugZC092VgE8qGYTRJaepXcPKowCbGZM48RDE5DpMsH7NjkUPdNHQSubhSYpvpEZDhhukYh3jiXbVcAFBXioxCVV9z1GCiCt6myAuU0pYJ1DgFEi87IfD9CFavDrRIYYxdk1GUX2uWB6eNf1YZmsXwTfk98K8QxHpQx4m5Ln9VdJ2Uy8I1tWuQ+vLS1jWggF5iVyHEvBsjjYYrGi5O322T3DMlWdQ6Iz49hARnMp5k34z/YRP3ShdKvWeghyegSJ7FRJWLi37F9C/RDpvxl81x8Bo7GnXPN+EtUfDhnE8Izbebh7zl2Edcc5lx/dH3TLnFLBVCpVb6uCOOyDBBrG+haFCks5tJZwJSO1qYY4Rn4JReaqb5ylbhR3GdWgO/arhj0wV6+Ku7Ra8GuR5VOyfe7EDw2dV8ZRAPs3qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(956004)(38100700002)(54906003)(4326008)(6512007)(86362001)(2616005)(6486002)(66556008)(44832011)(83380400001)(6666004)(38350700002)(8676002)(316002)(1076003)(5660300002)(6506007)(66946007)(52116002)(2906002)(36756003)(8936002)(186003)(26005)(508600001)(6916009)(66476007)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/4A6cDhafCcFrjfAQamyNzQqK7Lfis1eeSEA/ndYkQ7Be5vUB/YlRLtk3E45?=
 =?us-ascii?Q?1u9dXs47fsSuwG4N1bM2I7IFoJSDvyDFZazCjIx7ec4W2dS+pnTPfbaE4lX8?=
 =?us-ascii?Q?QwyN7ZwhNHpSU0g4b0UMw0Y9LfricF5hDI5jSPZS+pgelf7lCYMefi9+MiEO?=
 =?us-ascii?Q?849cI8WIWknqqq5gVK0sM5RTcFqx1KXf4GmSmJYE4aZEcpxlVag/qqfW2dG+?=
 =?us-ascii?Q?9tmOBgG949hAN+9LIpz4o5yvcqXjQCiWp/KbHlPqoJaSfjGlRLIBpHFP9W61?=
 =?us-ascii?Q?Wlrs0l9YXZLzobgg9bB1Ib6J0uZpUGZOBIN0m1g2vD4LbBAqCil9FVLTyL+K?=
 =?us-ascii?Q?IDtpTnP4aksJFTxm7SVINHwHfjS2T60CHALRY73JalhqqVjgEXdWilzhDweQ?=
 =?us-ascii?Q?CFx3d3mlDSeVPWUXpfa/rD/nBVLSK4J/jO3FT05UAgN6YycnCSnEV7vbyWZa?=
 =?us-ascii?Q?WWjPzCYRTsD4DtzYd7MRH9iDAnqmb3GxaTHO6M85S28mEtQf7AtfPnSYUwbk?=
 =?us-ascii?Q?lCFqaZ+mEYLvwz7ThM8gyEXpJAfY5GogXuM3F5TlvpdR0K17U9/ru5Lnk7k8?=
 =?us-ascii?Q?hZJG/K4WgCYp4CtmZUYrizv1aCpYAaz3MIXxk0YpiY+qGPljtPuxhVy10+C8?=
 =?us-ascii?Q?KaGZJIOyiK7qftubuHXKrW7sK4JVTumI+xIwYWIFeIfDlWtSneP9lWqzZdOX?=
 =?us-ascii?Q?SH22IsPu77+IroMh8QcIrfFtR9gDGr5fYZxMyy1AGsCn5FUpAJx3GJ/EnmK3?=
 =?us-ascii?Q?9SUQHjW2XUCE0I23tzcb2mMcFKzmwdkOYVF6DQxFhDxZpUQIGVy31DrbMNco?=
 =?us-ascii?Q?V8YLaiPeffy42ee81KsrV1JcjHDBMDBQxK9cZ9lXtEfdAPiy3pvd2zNLszN1?=
 =?us-ascii?Q?9v3PWenfXg4U/6MgmFqYDIvYZEYBOFtKQxrIol3s/6as/19x6rsDXslzN4Vg?=
 =?us-ascii?Q?+fdeeEkCJbbHwTzcERBI8NvJudiFYBNsYYkxAFcg/ekHWHpM0wC7r5appfjv?=
 =?us-ascii?Q?cd9dBRZfZORl/ls6o6h3jSdEgJdcqzTFSMQy96bFsEV6eZH4c1jfhq/EPb5h?=
 =?us-ascii?Q?Ga8Y1OlZBtZEmje8S+qs0+gTjdBxO0WAMBwURTNd7VzQPa71OWejV3+Z0If/?=
 =?us-ascii?Q?LBEg4qQDLcO/gPIT3PsuQk+lkfnZuTslKaZ67/DQR8L5F+x8G3nRIq54bnhL?=
 =?us-ascii?Q?FgUWN+WtxOsavqNYoloskSW6u9AseripzPf5i2XAisX1JiVyM5MHEsl4Gnap?=
 =?us-ascii?Q?nvhvKjehk+rv5epCQfyNWjhbyVEvQDAr7qE43fqO++8/PZoINqVyf97yaafl?=
 =?us-ascii?Q?GYgZpZ8NXrKlAF1VdyYG1PCzhgMmb1BfPV3volosXwON9hFaiLIoxpEESHxh?=
 =?us-ascii?Q?8f7gDF8JRgq3aFDU+1jRCW8t9iyl4M1NJ0ciwTupWvd6zgF4AE8wk+isAL8e?=
 =?us-ascii?Q?GJSBpOzoUcomnljWMwTMABFO/Qbky9NfllJ2qC04oTogdVKZyrwHu38OQFmg?=
 =?us-ascii?Q?F+VrURmrcrIaFHdciJ0ZSsak81U2Cv2aXn2e9wdWbXl1EWw4ug346jGO35cB?=
 =?us-ascii?Q?uO9CShP3fLlgYvcxGjP2ZonQdaP/aD2MLiegZo9BIg0X/GAEKHjQmu94aR1L?=
 =?us-ascii?Q?0rAksQAw72PIMXxgeCHUkoc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a170b9-6eed-40f9-af43-08d9ba9aa6ff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:32:44.1483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sQdODdTEk+FGkY+PPuzln1hKjDbkGN8oOC6Em06+/Duu3l8fXXp+1yaK+5xTDe+f4yFuiyO6vU4wisG4es+DVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is provided solely for review purposes (therefore not to
be applied anywhere) and for Ansuel to test whether they resolve the
slowdown reported here:
https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/

It does conflict with net-next due to other patches that are in my tree,
and which were also posted here and would need to be picked ("Rework DSA
bridge TX forwarding offload API"):
https://patchwork.kernel.org/project/netdevbpf/cover/20211206165758.1553882-1-vladimir.oltean@nxp.com/

Additionally, for Ansuel's work there is also a logical dependency with
this series ("Replace DSA dp->priv with tagger-owned storage"):
https://patchwork.kernel.org/project/netdevbpf/cover/20211208200504.3136642-1-vladimir.oltean@nxp.com/

To get both dependency series, the following commands should be sufficient:
git b4 20211206165758.1553882-1-vladimir.oltean@nxp.com
git b4 20211208200504.3136642-1-vladimir.oltean@nxp.com

where "git b4" is an alias in ~/.gitconfig:
[b4]
	midmask = https://lore.kernel.org/r/%s
[alias]
	b4 = "!f() { b4 am -t -o - $@ | git am -3; }; f"

The patches posted here are mainly to offer a consistent
"master_up"/"master_going_down" chain of events to switches, without
duplicates, and always starting with "master_up" and ending with
"master_going_down". This way, drivers should know when they can perform
Ethernet-based register access.

Vladimir Oltean (7):
  net: dsa: only bring down user ports assigned to a given DSA master
  net: dsa: refactor the NETDEV_GOING_DOWN master tracking into separate
    function
  net: dsa: use dsa_tree_for_each_user_port in
    dsa_tree_master_going_down()
  net: dsa: provide switch operations for tracking the master state
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: replay master state events in
    dsa_tree_{setup,teardown}_master

 include/net/dsa.h  |  8 +++++++
 net/dsa/dsa2.c     | 52 ++++++++++++++++++++++++++++++++++++++++++++--
 net/dsa/dsa_priv.h | 11 ++++++++++
 net/dsa/master.c   | 29 +++-----------------------
 net/dsa/slave.c    | 32 +++++++++++++++-------------
 net/dsa/switch.c   | 29 ++++++++++++++++++++++++++
 6 files changed, 118 insertions(+), 43 deletions(-)

-- 
2.25.1

