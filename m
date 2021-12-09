Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8243546F77E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbhLIXis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:38:48 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234447AbhLIXir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:38:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9FH/OHy14rjMjUqdupYm+w1YogZw0TUCOcGSc3NlfIBpt5dXtPotfZtnta2/GD5ciLe8NFKpQIveHuAvmrQW3LEP4mqFSCkI1qpvH+gLkVRmTzgvX5L/CGpWOySvgKY+d6at0aOSnKrdS4ET0gD2fQ5heHKBqK3y+wNGt2HIEbEX+7OUZ6R/CG9SQVG3U5OaBpNNfihLTpBDjGgwDioaN1Fg/IswnI7mP+yCnWe90Jx6dvuej9ETvtEYhOVmz46Fisp/igPqobVN4RWX5OG1bJY1fONRWeFcErpewRPi/qHkocmdcmMtcpVrQkrF0E9JZ7SkeFmNtQpxCWa2KtslQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYG48G70859kaeF3qgIAeQqX2WWXAj4Ag/pVpo4Y1oM=;
 b=jruTFKk689F4u+uTZBJY4QrlE7t34PXvL7ZAjm1KvrDPycZLVxQ6Ouv54HePF3sONw0wY0f29tWBh0coCG3EPGWUvzdioG1PAgZF6vffD8BiwigHcizUXIk9r2bC5dqDDOCijlMLV1Nxiujh3A11p4pb5Pd68e5zNpSP1aOzEp8S/eDPcPILzNfUVh/Xs1caQhTAobppBI7mN7NKVUeuniXn92pxGknVawmO3aEmPDi4UVe5/HqBCHrdHx6bDiLc6MazWgm36WrZJGs/e2udli9MKwgVSQFqBsBWNKYUUhBD2fsskjUjzFagkESx0KxjBgiCew2+RkrvqffmxWNHkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYG48G70859kaeF3qgIAeQqX2WWXAj4Ag/pVpo4Y1oM=;
 b=XZ+TS1pqtYbw9JYbJ4PQePet1keqlfTaaATU7GtFTAg9MnuosZ0WG39TvjFrNkiUgjes6jjPfS49PEp0P9PG9iyDWDSV/U1rann2RywUEXGtDFp4PS+gZPi7wVoMso6CDqC3sGlVktYhNfRiaPpzcJqaMdBEi35PVydYll7ygAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 00/11] Replace DSA dp->priv with tagger-owned storage
Date:   Fri, 10 Dec 2021 01:34:36 +0200
Message-Id: <20211209233447.336331-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48fc1445-84f6-428a-084a-08d9bb6c88c6
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408F701144B0F4C0F91169AE0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLFyxN5MNK/B8AleIhZOVroVQlRY/i/DJ3qXADMc9G4HMuvJNu1Z+tANxBK85nk9JEP0RWL0GMpucwJruy/Q4eTo3f5rv6GzK18C38P1lNnc913PF3CF5IxntqxZnevO2dFB7altqeqL4NYwFqvcMcMt3Di1hW78Ev7p+zvs4Glvots/DOH8JaV7jlsWaL2GSBqxCkiP9Z2Z//aeCWh6D2oA9ZUm2XN3ShZ9MX2gp0+OFi40fNvMzGQNIyLQe4XM1IJF+ABce4qFb37CiYYy+ECC3Mv3wTQsMuciToORlztDPc0mFqryD7l65tAo5CQFU5lntNUV9fPFmpdUw4v2uelzRm7BaL0r5LCYznZEoCkj4TL6YvjceEllo522QBaLgYyVCaP18dYq/8KqbwGBnRSmxK0eZ28xWOyB8wcTMkZzsy8T5g09+bmjRy6CLNV6GEMsabG6CZ8xwf1GXwjDBy+MljL639X+bMfDWK79L471q3d0FkVMOyF594kZrvTdwmBLEAwwzh/ZuEqmUH2OwC2BD4/CVEYjIh4fTqGkaMPCKx13iuguuBeHHdF40p8OhWEorUf97c53X7aYKlQaeKAeo1+FwsuDo0U834343Kt1usAMRM15KqoWgD55zk4FQq5bKlbwUbPesXTMiEQV2LlMUMFaLQuZd1XzbuFjq2o9fytyPvjC4qiUXkHzYtPIJkq6K0wfalMjr6C45WpyJqt7WH+4+teHsvhZ0lq4faUK9Mai5zG8Q3Zwn5XtIaxae8Tfjm5BGf18dySzwn/xfM+SCuFmPf9pdqv6HrLX9v5edH/RhDuuLKuVHiNw3vgf3ghoQd4WgWxbJA65lWhhmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(966005)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jfb9m49n+UUopCKyoRg5CW6oW5CYGQJB3Tx6RYB5Q5OjZvd51eQYAjsJwxdy?=
 =?us-ascii?Q?oob/dCmCv2cc3e2uprCPxSELVQhqmhdbCSEXXvOK++KabzMV/7GNlr69udPs?=
 =?us-ascii?Q?2CjmimUA6ffCxu6SkUxCbLLxHjXpqId34uahVCJlGraXLX39EIlQxJXV103b?=
 =?us-ascii?Q?UvdHuux94K8J5ti1/omQljWNMlM1OGb9WRovwJSU3zxm3dzRLUDWEz9QW+md?=
 =?us-ascii?Q?wbnoGb7zjeyU+r8TKJo0eNrII0dunA5/0LF4r4LpfXbeJC7zll2F+5i+QJOa?=
 =?us-ascii?Q?+J5HcuLklokJPH5qbvjoVpY2qt2sn7IgLkD6qRobnBsgWDWcqalXLNyI1aFr?=
 =?us-ascii?Q?EWcn2gAgxSPXkm+0kekVVbngHJQIBY24Y3whOx50IZscskKHaBw12d5Y4Zak?=
 =?us-ascii?Q?Btg5/EVw0sZTW52xriYlLoNrsew7LR45B7bPaUUIzTRwEAarbQTv8kvuYqFk?=
 =?us-ascii?Q?CqF1CPwYCs7/KhuzprqFQ+cwdIFd/gMrtB0TAWW+vK5CDi/xCTV8FVpcCCVn?=
 =?us-ascii?Q?eFhvAYbq39HresfBr5MHQmDq/Kk6vbPPulXBGW9wosYhDPDIzdATreFnn4WQ?=
 =?us-ascii?Q?qN6MPohETO4ADMmRv7tpFmrfvY4iKFeHd1g3kRKJwush2m3hNVwqxyHzb5td?=
 =?us-ascii?Q?juWN9Bd1IoL6mGoZxI045KuhGiXYqdGMMt6yTr9emLY3o7xafHQ8O5x7SS2y?=
 =?us-ascii?Q?lOWm51LNJgXM2ZoviZ6PH5XuyUEDRijGKaOW1CELntlc+p3nm2vVj5idtrgN?=
 =?us-ascii?Q?GxUZgdrw4CrwZ6GISdhs3Orq96CngY+VKpGmaMyXYZp5EM2zj6qeOBntEfNx?=
 =?us-ascii?Q?WkI6+cTehy0Z45LVS7MMaPFUw8s2PNmZn1vXYRCscYSfUAZFbuByAhzcRmGK?=
 =?us-ascii?Q?HM4x5CEXkhs+k6LlkF1aKYwNNnFMBB/Q3LMFpLwML03fO7ZbbeNSGyKN+vQ5?=
 =?us-ascii?Q?ZKZKwTxwjOXXai3x2LCU0t4FSejxhrXoOW3sIS1r3JGtjkWEQvuEubTIHKdp?=
 =?us-ascii?Q?Juj4fhQ3xG/EVL6djcpKyMsgLw9TKWdbBkU4b4MlhnXVd5fJWjXbcPe1thQt?=
 =?us-ascii?Q?RS/JjU8vNj1Ew69elXhO2imhV1FpmhioukiLrA8F64nj93jrxoPZTHgu1R3/?=
 =?us-ascii?Q?Qwm6yhFTqZjO8vEbHzf+8w2QF6nq1bgtE1RqmFsFiTtNcJ4WP4T5evKcL6Hm?=
 =?us-ascii?Q?yie9jZUe7dhee45bp01wrVxc0uzK5lXCOuYFNjk66vTJO9pjp71Tafm45kM5?=
 =?us-ascii?Q?DVhLvqGIVBYmm7ersAFSUXgJv099rDNfZFg91NPHQqvZnxw+De+n0SWIQ8gb?=
 =?us-ascii?Q?SARdG2VZrOEhaRZOVbd9TpYC4jgp7OZwMbqW5TWjGv94LrUV7fgucl4gD+TH?=
 =?us-ascii?Q?0ipUC45HGaW9k6lxbk98gVWpvP2lrrzD2tyv/9xHOd/ZK+J90izRr6SYg2As?=
 =?us-ascii?Q?aNx9Or7WbYRNLBVPiCUAtm9gG5CWQAD8IgRpr9Jve/oY/6Jn17p19qgBCSFK?=
 =?us-ascii?Q?9R1lRwtLjZRzPZxUaeIivyVQXOEhBwGIxelAzfWNjWxPEcDDryLaB/V1FiO/?=
 =?us-ascii?Q?tPapAEJ4BxKZeRKdHEjbbt/wt8HhRlXZiNb/jnHvuTfhn/YFKorIKwJkOL7/?=
 =?us-ascii?Q?s8bUbPo/YRJgFfep3Q4Ijto=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48fc1445-84f6-428a-084a-08d9bb6c88c6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:07.8146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEYi9iylTeKQaEq2j0dJS/MOWJbZuU2ORI0Ip9RGHUSblqFVENUDw6AJ6kSnpf6kQHxtfCt8gevu3GNj+cBaNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ansuel's recent work on qca8k register access over Ethernet:
https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942.7444-1-ansuelsmth@gmail.com/
has triggered me to do something which I should've done for a longer
time:
https://patchwork.kernel.org/project/netdevbpf/patch/20211109095013.27829-7-martin.kaistra@linutronix.de/#24585521
which is to replace dp->priv with something that has less caveats.

The dp->priv was introduced when sja1105 needed to hold stateful
information in the tagging protocol driver. In that design, dp->priv
held memory allocated by the switch driver, because the tagging protocol
driver design was 100% stateless.

Some years have passed and others have started to feel the need for
stateful information kept by the tagger, as well as passing data back
and forth between the tagging protocol driver and the switch driver.
This isn't possible cleanly in DSA due to a circular dependency which
leads to broken module autoloading:
https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/

This patchset introduces a framework that resembles something normal,
which allows data to be passed from the tagging protocol driver (things
like switch management packets, which aren't intended for the network
stack) to the switch driver, while the tagging protocol still remains
more or less stateless. The overall design of the framework was
discussed with Ansuel too and it appears to be flexible enough to cover
the "register access over Ethernet" use case. Additionally, the existing
uses of dp->priv, which have mainly to do with PTP timestamping, have
also been migrated.

Changes in v2:
Fix transient build breakage in patch 5/11 due to a missing parenthesis,
https://patchwork.hopto.org/static/nipa/592567/12665213/build_clang/
and another transient build warning in patch 4/11 that for some reason
doesn't appear in my W=1 C=1 build.
https://patchwork.hopto.org/static/nipa/592567/12665209/build_clang/stderr

Vladimir Oltean (11):
  net: dsa: introduce tagger-owned storage for private and shared data
  net: dsa: tag_ocelot: convert to tagger-owned data
  net: dsa: sja1105: let deferred packets time out when sent to ports
    going down
  net: dsa: sja1105: bring deferred xmit implementation in line with
    ocelot-8021q
  net: dsa: sja1105: remove hwts_tx_en from tagger data
  net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
  net: dsa: sja1105: move ts_id from sja1105_tagger_data
  net: dsa: tag_sja1105: convert to tagger-owned data
  Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging
    protocol driver"
  net: dsa: tag_sja1105: split sja1105_tagger_data into private and
    public sections
  net: dsa: remove dp->priv

 drivers/net/dsa/ocelot/felix.c         |  64 ++-----
 drivers/net/dsa/sja1105/sja1105.h      |   6 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 121 ++++---------
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  86 ++++++----
 drivers/net/dsa/sja1105/sja1105_ptp.h  |  24 +++
 include/linux/dsa/ocelot.h             |  12 +-
 include/linux/dsa/sja1105.h            |  61 +++----
 include/net/dsa.h                      |  18 +-
 net/dsa/dsa2.c                         |  73 +++++++-
 net/dsa/dsa_priv.h                     |   1 +
 net/dsa/switch.c                       |  14 ++
 net/dsa/tag_ocelot_8021q.c             |  73 +++++++-
 net/dsa/tag_sja1105.c                  | 224 +++++++++++++++++--------
 13 files changed, 483 insertions(+), 294 deletions(-)

-- 
2.25.1

