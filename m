Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B61425850
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbhJGQt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:49:27 -0400
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:18693
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242839AbhJGQtY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 12:49:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbV3DBJPRCyx/zazbW4AwAYwEWLYz/EMOcNVy6fOQoF0FTr4WLfGSWIWvFyjtALJ5dJPORlWvJA95VNtPe2OgccDMs1UhgdYaOgAQ7vDoUMln3U7fzz8qFMCbNxu6oflfV/l/iwhPPXcLDvlAjggt9a/qExAymur71dojy5gXq0kahU3LYjB81MOidKMlMYKWMP7k3jAaNxer74jol2+FItULToX1KlQXvRxfoHsPs8MP1hGkAsbJkFCUKZWyuP6YKY7EG+ubpem1IeCPINNSlSFUqIh0yue3o8TXFCcXHVXMYyYw/RtP8A7srHxtUZSliu2B8q1o3IDrI1pYTAt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+LH85B+4TcbhbPs+mKjeqpkNcO3QumKJUdKALsGWGw=;
 b=am9lgwvGzQ/1lgAJLcBRPxxDTLcrLhxVwDoJ8GxpkwF8ott/LLThqW3sh9odM5WYPa+SCxZWUfx+/wozne9KE/mncfumG2vZFS55FvZl2u1mQHK8d72C4NJcNzQiimQbIB4sNbvMLZOwzUN4Lr5n3YKx433rezCosWNqVU1kDem7bG2MmUQZ4Tp61n/NE714XZtmfXuFDMIMs5RXggf7AYsgngQ6wfWLLscmze83t3tnnODnoHbGC+J3NGL42MtjKZQ7smoeCsZPG8MPYYnmOj75k2MkzsUlh3fGYFzFUfmT2eeWDabgiu40BV/s+ZCARgJou5UGkZ3dxZZMKT9mNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+LH85B+4TcbhbPs+mKjeqpkNcO3QumKJUdKALsGWGw=;
 b=RWCvkmBCFv6y12GWaLDFnnEuo5x85QLiOQTgj7kqBSXKeqyBfAfcAXtJW8Ou9JxaaRuf+gSBCt+nL25Q+FMHHuH9t99RsWqAuE6965iVhq9+v5yqVxlnDni+31oRK1qBBiZSGEjIZ95va31ZxvpHIj1QxFidc0C/NorILZzPvnc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3549.eurprd04.prod.outlook.com (2603:10a6:803:8::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Thu, 7 Oct
 2021 16:47:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 16:47:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v3 net 0/4] DSA bridge TX forwarding offload fixes - part 1
Date:   Thu,  7 Oct 2021 19:47:07 +0300
Message-Id: <20211007164711.2897238-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0105.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR08CA0105.eurprd08.prod.outlook.com (2603:10a6:800:d3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 7 Oct 2021 16:47:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d801188e-0df2-453c-c216-08d989b22448
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3549:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35499C1B28248D4B5CE9B706E0B19@VI1PR0402MB3549.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pEXannizvKk+PlTvWwB+zzQQGxJ8qvb5mQFMOqgNdOwXHfW4rUYpGjffeJhYJ5wQ3OUGlYlHEki5uLsqJxTjM3SVgoMWJTvGBUL326jgJHtfc05yMtkZudilYrM7fROeYxpgj2CWNJbTs1SwS3wPNaUeKFbECkGVzm071yR5cOnXcdIbETwZuHxmXY7ZWUhen5aFBxxEZTd3HWGK7OplAwIQr6I7p3rT8FkrKqBQGg6ty7+mhrjZ18l9pWzBurORbRs00f7JZwm6KXZ+lm19Wi5J/FqshRoe0oWH268vI85LHwvDb5aB+yobypMaUSJeolChZnwyhc8J9uVHnVq8z8s5WGj+in9v3sLKR8uRYJEyf2eTVvHyx0yRmS5s0yy2xr/92XjRQaHhERhpZlbH+sy7RWTzWU7zyUlwYYvYl7JdggDrF8TiowquayI3AP+Aj8tN6MN2QSQKbP9WOeaTqeFF7XEhbOK+mWDyGCiaqfEAY83+NoYslqXbEpkxQxUmUjwNR2eO+CR66AYT/ZQEt3LCwt9hvEMmNtSDeVKSfpAVpx9q/zmfHtpLyJ6ywVhV70pwAct3RCKfgtDhMciF6UOQ9Phx8TBXvmCwklRWCZWVgT9J9xt/oPBGysbsUWkb6VEsoHOtx0IBmsrJvk0V0qQCH+Q/6Ni0vgfhkjFM2QUyMILvGTDbwWvATwkvgNTj175v/T0MpEdEoOFDkaqPwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(83380400001)(38350700002)(5660300002)(316002)(2906002)(110136005)(66946007)(1076003)(54906003)(6512007)(66556008)(66476007)(38100700002)(2616005)(6486002)(956004)(8676002)(52116002)(4326008)(6506007)(508600001)(26005)(44832011)(186003)(8936002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZyGkGJjguKCa9n5OTS/us3I6y52ZpBaUBYxK+u7HbNLtByQeRkzg3YNlwz5p?=
 =?us-ascii?Q?utFdbxpDjiu2xGJmDLEoyUFVWKuRwGTI05jq3rEekjuwuNySS5hysTRrxp90?=
 =?us-ascii?Q?wU0uFXgHZXD0+wGCfNc9oAHf1yp+Onpl/wPoo5mfflYTIT9rY34yQSh1qQ8r?=
 =?us-ascii?Q?EhusZHghqB8WjPHT3+CGLG2EnBZmH13Mk4B90U3Sj0vcVp4dy0GUH82IbFBU?=
 =?us-ascii?Q?MPA7JMeuPsP9lUvbvCzdsmCajpd/TBV4En5re/1BvhST7n8F9SGlNz0+Hoox?=
 =?us-ascii?Q?NunqO4i7b+bn0MvWmVIQDNPG5u5VGBjjgk1Pt4JoIZnj4Zvcn6Uf2nIbPbiS?=
 =?us-ascii?Q?FcTVv9fQA2WZRqaP73V00tPhBM7TtXLto74CGlluuq0DiaQp28a3KBSoLbrX?=
 =?us-ascii?Q?faqi3gOjP7RJM+hu11AMX5xVUMm5uldjoVzeWXTi4Enbhjwh4tE4FECxBfAD?=
 =?us-ascii?Q?BFKdmQKHPqAGs1tsg21xGjyBf3mxMvvc3ypXwNy/5EblyLNfAinp3evo6kA8?=
 =?us-ascii?Q?iqq9N1WlDXHg194vpooaJ2mxnKmd12OKsIF/KukLNmh+CJomubyAQKmz1nCl?=
 =?us-ascii?Q?Kb1h8Zvf6h7kxDWwYo7gw0dY51cA/q5gfbbCMnE4Cf7mrLkvLIkHhb3o0Akp?=
 =?us-ascii?Q?ZofQZJv2ARIirJ45WSpdQE6zAKARQdCor76JB4QMKxhdC//dtRWCSVMmk7Os?=
 =?us-ascii?Q?HCPUc0XhFVNYj63FzaDPFfZkcIcwXfSgbj5w+w8Wa275FaEI8ibPIMKj7C5O?=
 =?us-ascii?Q?DPhDBFKu3jbIUJR/Q9ZpaW1/ASfujSN7PcZlc68OPMdM+zDPfXWIl53YiqIm?=
 =?us-ascii?Q?t211ELSVBriGZXaB/wZ0Ze3Qqic/d5d93QyiuxTZBVRBTx6GFdIww8wpX6jD?=
 =?us-ascii?Q?agRhnccG5Gc1NEq6TZpStNDcuRXvABn/MkxFpRyoPiEBl0vTZs/Wg1aI/k53?=
 =?us-ascii?Q?UuAa2khq4X+gDv+KgfVkDd/EunYnoDyNyidckgne/hULLHxrvixlvrmYyppS?=
 =?us-ascii?Q?5rWcpytUjeZ5sFd2dt+gQDTvVXpyB1EVDzbWYsrP7TF/NJfDDExWy5bFFFCT?=
 =?us-ascii?Q?l/hWwjG5BaVKdSZGcy118aAAllEp2DeHqWV+k/64AJ6VjXlET0Twz80XDL1r?=
 =?us-ascii?Q?EHAY5JtlBjxwwR06GjTPfyhY38m+goKjFaHfXgi4jbli8AZGyPghL4Fgg+qQ?=
 =?us-ascii?Q?2XCsLkZkXEyoOf9OgPlBxGDttg5V10CRo1/0AxRFFacsBSXc50W9oQfGXm2q?=
 =?us-ascii?Q?xLjG7K9WIleIQTTkiDxnPv4T3ic2JNJrmV2bWvv+ZyRUWLexneCzTeWnFPvb?=
 =?us-ascii?Q?ErxvrqT5UUpEUxWn6e0z87F1?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d801188e-0df2-453c-c216-08d989b22448
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 16:47:25.7147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+akhHBL42jHmAeyfHWWqk9MafbZi9dgXKkkFYndT5yTdVRnBK4UozYMvv0PsjiDbeW70h34fSbmLgBgVYKw6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3549
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is part 1 of a series of fixes to the bridge TX forwarding offload
feature introduced for v5.15. Sadly, the other fixes are so intrusive
that they cannot be reasonably be sent to the "net" tree, as they also
include API changes. So they are left as part 2 for net-next.

Changes in v2:
More patches at Tobias' request.

Changes in v3:
Fixed FDB isolation with VLAN-unaware cross-chip bridging.

Vladimir Oltean (4):
  net: dsa: fix bridge_num not getting cleared after ports leaving the
    bridge
  net: dsa: tag_dsa: send packets with TX fwd offload from VLAN-unaware
    bridges using VID 0
  net: dsa: mv88e6xxx: keep the pvid at 0 when VLAN-unaware
  net: dsa: mv88e6xxx: isolate the ATU databases of standalone and
    bridged ports

 MAINTAINERS                      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c | 112 ++++++++++++++++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h |   9 +++
 drivers/net/dsa/mv88e6xxx/port.c |  21 ++++++
 drivers/net/dsa/mv88e6xxx/port.h |   2 +
 include/linux/dsa/mv88e6xxx.h    |  13 ++++
 net/dsa/dsa2.c                   |   2 +-
 net/dsa/tag_dsa.c                |  28 +++-----
 8 files changed, 153 insertions(+), 35 deletions(-)
 create mode 100644 include/linux/dsa/mv88e6xxx.h

-- 
2.25.1

