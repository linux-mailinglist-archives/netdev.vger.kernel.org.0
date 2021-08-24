Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BC23F6628
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbhHXRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:21:00 -0400
Received: from mail-vi1eur05on2051.outbound.protection.outlook.com ([40.107.21.51]:22848
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240512AbhHXRSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTRMQAak+sg1P2AAhqrwMGjyvxx7NUo8VaXzCj7+Xrz+eVMEmxgs6olxsUUMf4ypkrWG9gelNIO/S48HqJ3QI+PPd7PClKWCSm3iQ5+VQcnuTKGbchfit/dNVgLsmPfes80jAlx9INRRth5rcHwLQF0IW4C7B554VtNG4Ma9yH/HqxJ3KMKDW1XGyrgGA1eqFiNUoaWlxR9mHEUOsMmHMVbez51do6solc7Pr199J+NKDbZvttPrxV3Crz9IVa7AivW4YdIod37L1FfMDVYA6Ct28/j8bKjQ6K77ldx0W4+LFdNLRcE1ize9nSO4NZiIq/k1USiGVluwbScWpW9r6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbv5KoCA6JKbLuqHtC9C2O9yiccCuL1IC9murjRXozI=;
 b=BF/zpWF+YZySDhUe9c6Tcze80mdjue0nXMYBXDPF4cm2ivVIZ6RhOubFBxGO332EgiCKuqXcsHyKAcKeXDM/AOQ6q97GPvFljbirrWpkV6NcVnZhmkg21FiVG1/8qe2dKcj+3Iwd0EnV/PEBSqHTb0q15cLLcuc9hvfL2rOWo5+T/pKj3XA/Oc7CF37Jwv88rkqKuDou9RWnwKJ6pk1PSfSYgpjOReHLlUT9X/a2CFQUwvRZnBvk6uuuM7edpxsrrp6oe8ZK75DE4sVzrSwSTjTtnJxw9oy9lrSGZy5QBV2BTeDBaa+4BrzX36k8HJ50U335Hto7Mx7bohmu70E2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cbv5KoCA6JKbLuqHtC9C2O9yiccCuL1IC9murjRXozI=;
 b=sa7YQ7+GaKtU3clHv5qu6lbdFjq+4jHF7MOtNeoxm3tBsJdhxgacS/iyAUyBo7DFgXEgLlNr2iTtHIZ1fWHO5EdhocZgOlj2UTKiG+kAEZOd141wqj/tX7N/55EU1C2+1+xGZRo77Ezf7CmnfdScRCl9AYf7/6eZDyTdKek93V8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 17:18:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 17:18:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] Make sja1105 treat tag_8021q VLANs more like real DSA tags
Date:   Tue, 24 Aug 2021 20:14:59 +0300
Message-Id: <20210824171502.4122088-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P195CA0024.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM9P195CA0024.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:21f::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 17:18:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34f6a51d-ad0a-41a2-e96b-08d9672323f7
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB422244E1AF07CDF7BA7BEE0CE0C59@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kh0fw4cxfzHMMRI5QqE6VcAv7LwNMdBHLzTz3dWaYgEqYcP1HX0NB0aOR0gNKkflMl9QUFixezOxvP+dO5msPlG79shPw5bTGUWrtjqhUaKhwiJ2aylqkPIGjXxzwq6bxgYmHraDTdbkGTfYMy3TVGLqKXyQzztdN6AxCMTcLo5CtnrWP4yM3SJmV6AQygwQdm0Y4sNfzPtrNrCzft9s8ORgOArs1yfbmlNYuW/NvhUwtjgggHFoIj9zIr8GzgMJmkt3rc/KUAgCrMjyhG1P1eJMe7IuprlVNNfChhglIs2gucChr9ENoZEfuZ7q1mTZChcRukBASea0Qfx/X18eLXZR0eEnKfn9azSMGaY91NyE3HadfnbEC9RxJAFKeCJhuF+erbaUzubrhUInojOMIFFp9gB0St9YpH8A7JZMxT3ztiroJ6AYG7wl6BUgu6ceXtrkftr8MRnzngyWEfmMQZM33z19z0nZGePkQlwXA5CuMkSfRToMtFj5SuEcG/b66VBKRjfaNn4urc0zYzcKqHRSq/UYQZFSIf9A1x7DjFyzvz+KMWW4Sj7sNmAO/zkCrgRIozuP85zDIShoHNTh3lmumzQ8K51eqptoRkyECZ5ODDaHx0HN9k7305qlWCHhlAdtuiPS3tpSGY6NFDEKkxFcN6EiNV6xM26f1kOOg/rM+0bOv4Dt9bnKbyCIUDdg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(6486002)(66476007)(36756003)(6506007)(478600001)(66556008)(6666004)(2906002)(4744005)(52116002)(86362001)(66946007)(44832011)(6512007)(26005)(83380400001)(2616005)(956004)(186003)(38350700002)(38100700002)(6916009)(4326008)(316002)(54906003)(1076003)(8936002)(8676002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/Pn8RmhKhvb5iJujY+Ns6otet9+7zFSUiAX4CijJPXMabD9/vSDJQ6ZpGkls?=
 =?us-ascii?Q?0OhHV1d8s7oMvNtCUOluRzoY1fCE2s9h+nD2df3kM4WbQgoig8uFbgwUz70W?=
 =?us-ascii?Q?jKFxWJ7Mam+p3Vi2hoI1rqSUmmSEVWlKMl6X0UEwEZjqdNoRIZsOrJAS1bhF?=
 =?us-ascii?Q?pOVKMiO/LoW+oDrdYEJMpi7xpDF2oNWyA8hIi+VJeF2LvZ/9wkZtTWql4z12?=
 =?us-ascii?Q?3iMg98/rSMcZaIjixr6Pxy03i/ZZsXiTf823/OPb7RBPzGi8uK6yeZJsPpmJ?=
 =?us-ascii?Q?giGRtUyaqlFqt0bxfVQw2X+Aa+JZVtSjC1kMM7d7Kzx3LtOb8xKG93MrSuGz?=
 =?us-ascii?Q?x1CJOeIJy5BXXqXMMtAgAskdbdt2Yftl51nxGhdcbTIaqfdXlQe21j6g6kt0?=
 =?us-ascii?Q?OyoMdHes4Lt2LV7j04KDs7v1RPUxuHCy0UWEOQ++gkKyut0Ui1Ar2eggcdJC?=
 =?us-ascii?Q?byT4lnPhw6+EwlDRiPd4qFywB2+g8bO+5kxgsrPughEOF25vXO4ivEiD056T?=
 =?us-ascii?Q?mQqK4JlOGsJNgeX/fK4TYte1ABgsOhuVqUkAjIVy/hp/Hvjg/MsG4vVi+dpZ?=
 =?us-ascii?Q?PMUMddEPHUwUfuYBok2Adtvw8XA3ZubkCijAaQr4b9SCglyI46EboD6iLqvR?=
 =?us-ascii?Q?XZ05fLevxwrdqFbaEKjRFQc7jsKfHjOfx3R7LmQrpe4P+R3hFIsvJxahqjYc?=
 =?us-ascii?Q?Oe0M4VYI7/rLbXf6HzfnKOxcMGloJPORMz17hcPs//rltjgxmJisb3eQyPCq?=
 =?us-ascii?Q?8zgtEN/o+Ir1FGdteIEhDpXd9wGutrlKD8cOM3yMTD7lXpEWMITB9FvM5CIG?=
 =?us-ascii?Q?QuqSEgowaL7NfJbJDR4xqEFNS+WMbZaJcj2qp8gCXDK6ubHTF0w+e5WAWfl6?=
 =?us-ascii?Q?4/iCSNordroJr8+67x5PvzPxYylk1E0nhxI4yy+Jl1zRjKGHwC5KvwPKgM8X?=
 =?us-ascii?Q?ZFvj3uTue/KJrgkgNvuep/MDQ1Dmm6plL56Q/aj7iVo+XT6mDrUdNuLzDEMo?=
 =?us-ascii?Q?6A+gP/pHfJZq9hdNA8SEQU3oY6e9lqDMaYAVttbQkQVCamJCwtmrp1m6nqz8?=
 =?us-ascii?Q?Js8aiTbcNMz6kj98Wq6dH2iB1tiTy87o6Rf2Q/jpXHw3ZXJZiYhzvHsqiG3b?=
 =?us-ascii?Q?LkQVSunAml0zeZG04gokOyys82Qx+JOno4RWoNY/q6IJQ0xJE9gkp+APn1xC?=
 =?us-ascii?Q?O8YP93Zdt19OjtARr1p/KS++N++fB3RmC/ahwgah9XMPnziFjTwZrbHvP+tM?=
 =?us-ascii?Q?vT1ZynCE/Kn+FtnBZU0jJz7oMoXwuE1OSz60jAGbzSpECnwDiKWKRQ8McMqL?=
 =?us-ascii?Q?xawPdUJ0vBV9Rklv7mzeLU2h?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f6a51d-ad0a-41a2-e96b-08d9672323f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 17:18:07.6360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xwflvq7Vv8pvqiGS8zxN69X1sPTb74QtbcwkjldrJoT5ua2rDyc3SVefo3n4YeCx6lSBTF2Bt46pcXLKt9OqTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series solves a nuisance with the sja1105 driver, which is that
non-DSA tagged packets sent directly by the DSA master would still exit
the switch just fine.

We also had an issue for packets coming from the outside world with a
crafted DSA tag, the switch would not reject that tag but think it was
valid.

Vladimir Oltean (3):
  net: dsa: sja1105: prevent tag_8021q VLANs from being received on user
    ports
  net: dsa: sja1105: drop untagged packets on the CPU and DSA ports
  net: dsa: tag_sja1105: stop asking the sja1105 driver in
    sja1105_xmit_tpid

 drivers/net/dsa/sja1105/sja1105.h      |  6 --
 drivers/net/dsa/sja1105/sja1105_main.c | 55 ++++++++++++------
 drivers/net/dsa/sja1105/sja1105_spi.c  | 10 ----
 include/linux/dsa/sja1105.h            |  3 +-
 net/dsa/tag_sja1105.c                  | 79 ++++++++++++++++++++++++--
 5 files changed, 113 insertions(+), 40 deletions(-)

-- 
2.25.1

