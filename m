Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01352DEBAD
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 23:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgLRWkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 17:40:10 -0500
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:29348
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbgLRWkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 17:40:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjLm7hBCAnqD1bZRKFeoOBNG23Sac/eXw3KkiMrlhnJtIsDHiGA/OHGl8aoWBkVPCU/dPil04nBJUxtSnrrMs13RV505qbiTK+/Gf9td770yWVq+dAaxuSer6earexDvr5WlZPLCSXrrX/rV1pSOLajB2DO1UcPcLbMr7wxmn98rH7p/rJIRkGhIl3xj/wEk/VKdLVomBDKHUsmLpRSoeKWCw9JYoMkG8DildXdOXnIlsTt+9kqGoJbQJA4i8vm/HIL1CLPFkDk2d86zrQGotxRp6JGB399ALCVWs9vtidRn1eh0Q42OzEt34cqTkaezH6BQ6Vp8V9KNHnMG01QhxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cGtD0ZkBRDvwwSUe4TF/0eqTp5+KbUM+KNxVkjylPI=;
 b=aw6KKfsxNHwj3s5tDwtHAuGNd8lQm4DELoisMniN2aKgzFYSWmXj2ZboeygTyqWePGRLRjVdD/dKky3cyPBk+gHKUMrEqAboE8U4hZ6lJJ3YHuZ08SKRyMqUwgPJ4qvM5lzJYRxI/FQn9O4GR6OAYQfUMkcpwczYRyxNgVtqMJTbr6a5kRI32dh5UsCm6QqohjYbyKgmL0wdduQ6xUQ8aD+8SLTWb3LN8Ybp2cAYuHYFtx2eSDGu1F/Q6pls4l+VAA0oiV3UKq8jhkuFtJdCejL0rZo56afM8DD7VLW9wr/Z0JQvQTBozuySLj1bjG599mmXhJ3zV1jeVi7iShqgVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cGtD0ZkBRDvwwSUe4TF/0eqTp5+KbUM+KNxVkjylPI=;
 b=VZxL0Q6C0JOKNP+YAEVd0gxkX2C6FxAswe10vknbdii4bTjSo+qEiVW8YrlPcfYslIRVi+zfHoHPVulleUcaNwav+sGCZF17Rh5aaQzk9YPML2N69C0V2HlQHV80LTD8YuTbFtThE4OGD+e+BCguNd7xgZleOwkbjtbQ4JRyCOs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Fri, 18 Dec
 2020 22:39:22 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Fri, 18 Dec 2020
 22:39:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 0/4] Reduce coupling between DSA and Broadcom SYSTEMPORT driver
Date:   Sat, 19 Dec 2020 00:38:48 +0200
Message-Id: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM8P191CA0030.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::35) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM8P191CA0030.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.28 via Frontend Transport; Fri, 18 Dec 2020 22:39:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 22904689-e76e-4c7c-7e1e-08d8a3a5c3df
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26860B4377666234CBBEC2A2E0C30@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMnOQGBoVoA8AALUblvV19CCUbs2E0a5PB5ihe3y7mPDOm1czaWPJAW67xEYx2M2VaqDF+lauGc5l2PpOFDh0JGoc16JAX47owDBJMmmpmQd/zK+JWtwl9mIt6naJFqGfkQObLk2f1y+pgWWxp/ecwQtrcibxVYp9HeV+/6UbXPcPi1UIq10EKMw3oRtVBaiBJVyQUVko+pBwzqgFUSEBbRx+UBqFEQEcqCqsN5G7a1sBcAfdVuqodHqzZtk5Zo/WfliUkAJQWAmh3jD1I75+AJ4YepzvZusbeke7cKs+9aB8jTx6lY3e0CdsGzjL5f2nOGecdLHLCiz3d/v5iPlXCPvECz91+itzD8nx7JQaEL4qRQl11kOo2kEXYv7/f6RKiSs07zdd18mN+xU6DPYjuyk9N2PEsUu+VSZGUo1b5NLbaZ9KKILQ+om+Cq6mK9w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(52116002)(2616005)(66476007)(66556008)(956004)(83380400001)(478600001)(8936002)(69590400008)(86362001)(44832011)(66946007)(6512007)(36756003)(316002)(5660300002)(110136005)(16526019)(186003)(8676002)(26005)(6666004)(1076003)(6486002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Z7rZQfu+gHDB4mwswTVBHtOWwpdP8U//Bcsp4VFQt5WR1ZYhhFhGpBfVFZ7M?=
 =?us-ascii?Q?LjR1cmeVwuIOX+XR3+YDFrUyGDD7jJUQ69Fu8xIhsqurBd1LxL1dWS6um2Dt?=
 =?us-ascii?Q?lcncM0kUJm4ZwYkl2M1AI4qDZDsT53OyaxcdV+5Hqu2VY7cZb50OUYIWCVqM?=
 =?us-ascii?Q?rYvBTgojNRgtMBqveSLIca3EAWSVIj4n4vN5MS723PA/nmmgjEqmDMofJwE+?=
 =?us-ascii?Q?eyXJENqGEZSqKe37JS6THmAqLwPFmgWilVpV6hOYf3IQpsaJlBs/lmLlNwku?=
 =?us-ascii?Q?5u3zrJol4r77lRd7ILIYRtg8GTTxmS3toMOwGXP/JfLK07EHYFZ1QQ2EHGnb?=
 =?us-ascii?Q?5qg9HZDeBwoo/DPDjxuajk5ydP/FaydQyW5BLpeIyFtGTU0m9P/DwTRL7sRx?=
 =?us-ascii?Q?vz8OAynNb/lpOEIjPoUJEJY5pcEUSvzPuRSAid+IiL9Q+d/1iuW5crfW2NhP?=
 =?us-ascii?Q?NJU8xdy6NR8d6vg+GtJ0lC9pLrbf6FzvhWTXLNXk5Xuoz67XbpEMxUlZkhec?=
 =?us-ascii?Q?ggM3lyRJRR4oXvIHs51IaE7zAwS+wFPGRQPkMNxNUVbobafccEAc2LSTKSDZ?=
 =?us-ascii?Q?H49NwZsyo8DNDgxmRL3MWLAtZ4/vSJcbsqQj82B2xiS/pIF6wCHSQtLc4tyf?=
 =?us-ascii?Q?BBWFTxJcbLBeZcQpN5eYF1wIgn0fMJ2TT5QgIakA+2lewpU4DUZv3/W92WZ8?=
 =?us-ascii?Q?mQJpG+lRUoz4EbnzClgqRMyZzPaxtObOyqGa1If84PuQFkvgHz/Jul2KW8G0?=
 =?us-ascii?Q?VtvV8Gr419nJRVaK3T8OblIlI9jVapv9IGtCfl174h7KmJpq0Z1CjclVKd6c?=
 =?us-ascii?Q?8HnPlKedHJqQN1Cl0SDlsFhj4RWlk2k4H1f7ovVUIjFkQSocS4TQSxQJIVdn?=
 =?us-ascii?Q?/K2p2BBUMe+Wz6a2wl3rFVc2Rb/IJHhlhb2BzsEQJ8KtwbILBRJNaUP2Yy3s?=
 =?us-ascii?Q?noPG21T/u+qBLNFrIYWtXMsB9aw35xXdB9uimQFiWOc9ol8l9okIue8dKRlD?=
 =?us-ascii?Q?QiOn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2020 22:39:22.3710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 22904689-e76e-4c7c-7e1e-08d8a3a5c3df
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yn/23cV7Q9AgDtyvoQ1gVlkH/unnbzytQHbWtvD5HtIkLfwqDC4S/6roAVf2XiPADhsiYBIbUwnykoEfHkYrwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upon a quick inspection, it seems that there is some code in the generic
DSA layer that is somehow specific to the Broadcom SYSTEMPORT driver.
The challenge there is that the hardware integration is very tight between
the switch and the DSA master interface. However this does not mean that
the drivers must also be as integrated as the hardware is. We can avoid
creating a DSA notifier just for the Broadcom SYSTEMPORT, and we can
move some Broadcom-specific queue mapping helpers outside of the common
include/net/dsa.h.

Vladimir Oltean (4):
  net: dsa: move the Broadcom tag information in a separate header file
  net: dsa: export dsa_slave_dev_check
  net: systemport: use standard netdevice notifier to detect DSA
    presence
  net: dsa: remove the DSA specific notifiers

 MAINTAINERS                                |  1 +
 drivers/net/ethernet/broadcom/bcmsysport.c | 77 +++++++++-------------
 drivers/net/ethernet/broadcom/bcmsysport.h |  2 +-
 include/linux/dsa/brcm.h                   | 16 +++++
 include/net/dsa.h                          | 48 +-------------
 net/dsa/dsa.c                              | 22 -------
 net/dsa/dsa_priv.h                         |  1 -
 net/dsa/slave.c                            | 18 +----
 net/dsa/tag_brcm.c                         |  1 +
 9 files changed, 55 insertions(+), 131 deletions(-)
 create mode 100644 include/linux/dsa/brcm.h

-- 
2.25.1

