Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6AF3A2F9B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 17:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhFJPpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 11:45:50 -0400
Received: from mail-eopbgr80109.outbound.protection.outlook.com ([40.107.8.109]:46158
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230280AbhFJPpt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 11:45:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4Jy1de3MXkYq6nTBB4RAwlpLBfxf6nhNcCFLnibiiUw22MHTm59fqnowTMKMcb7R4SrxHAhqZxfyo5TPP/JTxKpi++1LMUjF126dC9IhhG8RGh5xtBXW0W4GmQFqRwVgyDDht9B0MxYY7yFvtOoFF/11+LldIFO+ViZXCBQnil8gizMltLft4PcvYeZcubXkWHEnzb0UAZE0gzIC6PlAkXEenmyulHp/W9Q6Y9AZ54D2+u/uFZ9dfTQr6HFN9yHJ1yHz4kRictKMe7IyhUgBfIGUIcPCai1Nln3tNm1Nnb7p12KRldwvQViBFomRRveccTzKUi7ioGMGn5hMN9oLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SupeTJcAJle5SBF4sfDlfnIXtgA3Rq9AKXzhTokp6mw=;
 b=VG1feMqTy5UxLuGzQqpvYlafj0iol6xhOsvGcmBQ+eXmlnAj3nDCYaPf/t/a5Sx0zkIm1DsYaujNnEx6ca97SBHIlrW7bjJJdbeUR8mKflR1BRBiXy6CTWKHIZ2WW95F63SyJEOFPBEc8qMxHFvvl5rnjYOR5DhmR+tHy4S8cYWcXA6qlRnoSBKrzfnDOobDoLc/wezUaEhGlxFkjZQlcjpjWLYEjrNyPiDstc42U56Z5zxNHTWd0/cMp0t8PyCuhii5StakCQJM0sWnPKeVdmtdqTDij2K8h/+fpPaU3Uq3vSWdWhjY5vEwJAk6NF0EUkJmVTM83sUIl03MpvGTXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SupeTJcAJle5SBF4sfDlfnIXtgA3Rq9AKXzhTokp6mw=;
 b=MtMVB9uMbI4/EHNZxxQJQzJ48c6orXAGjmfdq4QnnVFXhq6exUHL2dLyIH64uFJLvNn82XKWKREFN6mg954rFWRA5jnLqX6ZbB1uZ/ipWuPDgjMVOsg6yBrQ3fU8ZcgowQwiZkqlY3DkvgWPAIyJTkT4lx7lms0QWPvrH3cEIak=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.21; Thu, 10 Jun 2021 15:43:48 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.023; Thu, 10 Jun 2021
 15:43:48 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH v2 0/3] net: marvell: prestera: add LAG support
Date:   Thu, 10 Jun 2021 18:43:08 +0300
Message-Id: <20210610154311.23818-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM3PR07CA0082.eurprd07.prod.outlook.com (2603:10a6:207:6::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Thu, 10 Jun 2021 15:43:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d28fff7-7662-4cc1-dcdc-08d92c268989
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB02688C6E0551ECFD22EC975695359@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSArwzWUeFueDvnmkmKhisAH5Fe5BD/w1buVblaVrYjel1mhbejpUKyQbGSQkR1SnXJAjHr71r/n+kdQ5So1q2fQzOutwiccAsvzNlGzWxlRD8mbqKX6dggOmn3xulu9VZujtkGQH5CDu7/CvAMcTT7OIlIls06s7tSQJDRJQ0J3KDSpZ7f5PdqvR/w0q5U0G98xr5n7VIHtOqknXpnwxW7nj8tWj2pCnzHKfojoy0oycuIeUe8dK24LaigBKW9M2uCWBCb5T3LBvv2hAnYvX1+6pH3adVFSlq7bb4xDYikZLQ3rWyHWyOkCPs3TR6KxlBoc02pHRFX5HAXaFWi088o2T9ytPKJdBgjdQONBLaI4JAUuCKxo9rtkYukaoIyoI4LZShCisDMUe7yHd2foB86ifXK04mh20sSuu8C60P2bLteEI5G6rvszx6OnPXRyiUlPlYQtkt0YlQbgnPGJjzpyGG6HBER4sAVBNxtz4wDdLVBy8lkO+9mYI6u14wlSMeU4zMgEhQpYBgMvABCRmWyuFU164opqFZsw2waJZCyc9moPvjFKXtNyRuvqgeIf+k6DVQL70NGESYWpMaMApdtPqx9vTO3WM04Y5//08w5W7iocDLBSuq+78r5jtdU4tpL7msFMkHmDYYfAIZzLsRcintaEhHg7MJWQnxv6dPC1F8Oq9AV8fGhP+7U7SjZwc2GIA2sTc+L1j5HLRn6h3oOZtxh8WEJ5bvSTiofZkzjjsJZ7oJHpQUFcYcz5FbIqr30d2F9wG1mubDIIeteCOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(376002)(39830400003)(346002)(136003)(366004)(66476007)(66556008)(8936002)(66946007)(8676002)(6486002)(6512007)(478600001)(2906002)(83380400001)(1076003)(6666004)(186003)(956004)(5660300002)(2616005)(6506007)(38350700002)(38100700002)(52116002)(36756003)(44832011)(966005)(110136005)(316002)(26005)(16526019)(54906003)(86362001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P1s678kP4kGMdQl1KAxZnYwZX5Gsd8FM5GxXaDGZcGLBK0GMhBt9anSOrEP8?=
 =?us-ascii?Q?WIs4wSZM9dHqRWtkB252jE1/O647Z/VROHytqU/0LMAASllD2WaWD5dutzwK?=
 =?us-ascii?Q?zq3PJbroNrJKWC2yvyjCF3P+NEZ2mPZjCON9ZA1f2D88prW7fHM1t7++dQhv?=
 =?us-ascii?Q?wdVDVzOqufwHeWaUuqZbzghhxpPuc+dHSPOWwykPJcPv/Ua0Jr/KaHEpLbRz?=
 =?us-ascii?Q?aPNghkbFbGBhRiF4OAvkCv24z32nzzCzBFnvq/CK0bKO9PsMAdeiSQ7l34EJ?=
 =?us-ascii?Q?JwCTPto5tjMzHBBUmpGHUo6TZhQWjkGo7YIN7gOA513WjrePXMuTLZCG7zgQ?=
 =?us-ascii?Q?h2mF3CvsLxEKbeeYXtmtEAyfQWugzvO+SqzkC22ufqSbIw71lOML1UOenk2I?=
 =?us-ascii?Q?OXR6XpCTyDechNSkJj6pzDIT1+MYZuBcb4lL11IMFO05MclKUU2i2Y8IX1VB?=
 =?us-ascii?Q?28OiEJ5G8SeCKTuszQTAr/Yzdr4gyWs0uZ53p8GBVeITRCAix7i3FdvdS1wH?=
 =?us-ascii?Q?ukrCJBMfaL4yVQfgueBAdc5sEBU6/P5VFs/2M9a/wBAT9ONT0Qylo67MyUc9?=
 =?us-ascii?Q?U2TgOu5jdSJJnMzEw+iSMYiLsN2YgyBpbTC89k1O7EzcybMpcruLFLWW9A4x?=
 =?us-ascii?Q?fB9KISOAD54VwvZTguw4CpGfD7ItZtzXmcB/EJamH+dZidfqPYCn5gyzekdc?=
 =?us-ascii?Q?39LgzH42Wa0rFzKeM6OLyLpqKuRePvE1AWvVYF20CoAOg72vfZSWjo2X6hQX?=
 =?us-ascii?Q?1tVj7PKKw3JrlMh8QkbWQ28BqwI4IfcG7xha0rxIPkBHPFBJeaGv+3ISYGw0?=
 =?us-ascii?Q?ei67t4c2CyTkp0ryNdh293+/InnEbzON4kXejjKK3Y5+TAYsVp8Xx+SRPHLO?=
 =?us-ascii?Q?TL0Tt35ezogQdz5WURraJyLl04Ez7O9NkSwoTG9ucuqchWVwd1yOVkaff+XD?=
 =?us-ascii?Q?kfo4+030W/CsYEcXz4WwCa/9mDjBsHjbpSufwFnNFtyhEgQnyqqWjoP+fjic?=
 =?us-ascii?Q?R9L6lzssVxCFfk/3Ri6PGHHYlOuxV6wkor8a27/89YVRtWmyNtquHIVyfEGH?=
 =?us-ascii?Q?JnTp/7ztEy4VFXXGXKGFuCFh99xIkBQdj7GeN0BkZqb26BtEvUn8KF3roWof?=
 =?us-ascii?Q?Dloui0m2s54wINyL1FplPntxumJz0xs4MN2SyDabZ6DUCC2IbvU8ckcmNkp2?=
 =?us-ascii?Q?fwEh50zZO/7wG7/YPBalWyFJSMu87LDIDXPk8BfkqCmo/R9VO4lJNqh+Y4zO?=
 =?us-ascii?Q?Um3Zr+9qCliRLoJ/YeE1KmYEiTeEnmJN7zgMNU+iLZqvAwJE6CKMi3S8+NyQ?=
 =?us-ascii?Q?lkR/OIE7OD5j6KrYMM4ycNOm?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d28fff7-7662-4cc1-dcdc-08d92c268989
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 15:43:47.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7UfCf/9okwmcMoYYVIt8s8TSIVPdnC8Bwme8aYLYO262vTx9VlAEZa6qbi7odWDcoLIserbduyl0gZdtd5sFBrOwxuu+zRa+VB1HhVbQ9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

The following features are supported:

    - LAG basic operations
        - create/delete LAG
        - add/remove a member to LAG
        - enable/disable member in LAG
    - LAG Bridge support
    - LAG VLAN support
    - LAG FDB support

Limitations:

    - Only HASH lag tx type is supported
    - The Hash parameters are not configurable. They are applied
      during the LAG creation stage.
    - Enslaving a port to the LAG device that already has an
      upper device is not supported.

Changes extracted from:

    https://lkml.org/lkml/2021/2/3/877

and marked with "v2".

v2:

    There are 2 additional preparation patches which simplifies the
    netdev topology handling.

    1) Initialize 'lag' with NULL in prestera_lag_create()             [suggested by Vladimir Oltean]

    2) Use -ENOSPC in prestera_lag_port_add() if max lag               [suggested by Vladimir Oltean]
       numbers were reached.

    3) Do not propagate netdev events to prestera_switchdev            [suggested by Vladimir Oltean]
       but call bridge specific funcs. It simplifies the code.

    4) Check on info->link_up in prestera_netdev_port_lower_event()    [suggested by Vladimir Oltean]

    5) Return -EOPNOTSUPP in prestera_netdev_port_event() in case      [suggested by Vladimir Oltean]
       LAG hashing mode is not supported.

    6) Do not pass "lower" netdev to bridge join/leave functions.      [suggested by Vladimir Oltean]
       It is not need as offloading settings applied on particular
       physical port. It requires to do extra upper dev lookup
       in case port is in the LAG which is in the bridge on vlans add/del.

Serhiy Boiko (1):
  net: marvell: prestera: add LAG support

Vadym Kochan (2):
  net: marvell: prestera: move netdev topology validation to
    prestera_main
  net: marvell: prestera: do not propagate netdev events to
    prestera_switchdev.c

 .../net/ethernet/marvell/prestera/prestera.h  |  30 +-
 .../ethernet/marvell/prestera/prestera_hw.c   | 180 +++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  14 +
 .../ethernet/marvell/prestera/prestera_main.c | 267 +++++++++++++++++-
 .../marvell/prestera/prestera_switchdev.c     | 163 ++++++-----
 .../marvell/prestera/prestera_switchdev.h     |   7 +-
 6 files changed, 573 insertions(+), 88 deletions(-)

-- 
2.17.1

