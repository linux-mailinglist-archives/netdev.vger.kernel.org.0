Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D576480F3B
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbhL2DWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:22:53 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231775AbhL2DWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:22:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J71Vx81yhpX5M/k73Y0RCHnTxlyvEGNTY29tEPLgWoyyahr79kKB6pS1/xlOdU6R6nfVpjUC0RemWguxNuYqY+5mLURZ3QNGk2BvM3hbsrHK1MpbZlGaKR37MdLFAgqxTzglmCfnaD7nVQrmc4x/pDsbNrOO2sGcyFf7CLOeUivWD+9IfnAw1y2e8HGVMe3Hjosih96hmnqhf9IOwUDFR0ztV2DBUu9m3vceIeEZyvUoizzN2/pkkvR5ngaURJWKpDRKSlHmSTqv9dinnQjxypKqO5xny62PxNZKb2QCJHQI4D1A+zfruxLtvm+QKs04JKA6e+fJ859xqIH66zBGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+h+QyU14SXl4Pd9NPlROPD6U9/Sbq+EOodfVk46IGI=;
 b=EoOrPbgkpQ/2FaDXac1XZt9FvchixmNYQO+PTr0PkYMHaML8lSAlvEu/32BVfzIErRPiPuTR+f9x8bvTh/nN2j7ibOu640+D1/vgMSZlm+kXARVG/mPyZIeYhXSY8dN/PC03zJm+BT8BkzTlj7jIqnyzK1ZFFZQcKjMQi9cmw+E2g8c4ZaHBO5OqHyC5K5dF/tcbaKODxdFNAYZhasIm4pYmXP+ka1j1we5YAejLMNiZoQ3ZxuYfHeRfzy3yPrIrBV17KtL8pMhLkAgiGN2PvTKlzsFA/hxCp0hXQgoMPbqGo3eHQRD2wZhJ6RUG+gixiZ5qeybp2OmLdJY3sbslHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+h+QyU14SXl4Pd9NPlROPD6U9/Sbq+EOodfVk46IGI=;
 b=VkiDOpf0RoHSZXZCHRZCZfPd+xP3OIVg+qgPKgucaBoFV+92XvHs13br2HKdf7PDmdTcjuIcfLiE3xsq/cRllv8aO9DrT0HleMcRYgX4uJjN6SxWnw2wsbsUPtWA9ENMZxlo0Qgh0obXoqgNQS04nb9qIeklZEhBSwC4Lid66dI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 0/5] lynx pcs interface cleanup
Date:   Tue, 28 Dec 2021 19:22:32 -0800
Message-Id: <20211229032237.912649-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f6777cd-38c8-463c-6889-08d9ca7a7cce
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB552139A553F39A85C7AC9B06A4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBBTPe6yzYmKdIpkKkxQ9NN2wqDtXYLpZo0IYwys6Fbd27bjW3lJ2KDvOPD2ORUDnNdb8ido4fC0NErZkcRYwHOTNn/E0XyfktaKjj0+zzP6cqR83m6aike8tWtIl4RBacrKsnz3N5FIN2oAWTZtYGV8rtjkqLH+UOTC+kJa2WH5l0VNSWJYv+MysJNoIrTmhOfDHDodoTJZZ4tTq4fevRMul6MmiBjKZSsPhTzrYVWhRDptGwt26qQcx6TfYdFz8WwKuXdg+5I/sNh9IIjzVtBG2Re33UwoGBDW9GKJ/KkrVNFsXgp8YzaZLzX24O8JYioKk9GkUh2O/rxOdPv7hd4qADd19FlrxPQv3MNCeKsbN44sTyiIekHVh/dbH64ivH3WSCNfP8nqXU93pTwtvHxTA8K+USe0tuVoMXVbww4bFMKFvfEtZ3NrXSXTyhCrXck2GyGmZqra7lLWH514YbYeBv70E3oSZRkI5w57UPaHkkmgV0g+J+Q9CaGDxnOOCIavPKoscK36109c9OQ2SHs8cD9wMP9DVF4vMWJQDBOKAO4N4hYNn8vFeqOuI4nPGgILtjzS4pfBSyeV35uw4o/7aLglxUtG+B+baHMLARpKj+cojaLocuQTqkr3WQemsQ2JYEpzQRoD6hsNENal5eTz+IHwKT2DRcIYgIhejfTiyuY06dKUZmxHtpqtxIqzgCxCknZxZoxXVGp7589k1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lmLTH9RzjsqnxX8ksKwFRsm9DOos5oW8NXfuafkyBTZx1UNTJ8V1HwAUI5JF?=
 =?us-ascii?Q?ZYBMKTkzJ6pqQFV+eQy/MJ4QkYXN8fTBIgQjv7D3woSTovfrcJe4Ij92mAL1?=
 =?us-ascii?Q?ifl9iWxu8JdVlxxzPsKVuYzKFsZOUIatqt+CWAtsIH89mlTPy1/D29Ka7Jdg?=
 =?us-ascii?Q?lq16ZWBMDO/RRA87J2GZvE2NBsK+9U+JwXECjKhjnIa7w1rClNtZIAHh70gY?=
 =?us-ascii?Q?lxY1u+t014JI4tdL2SO51Q6o9+xrkki/Kydx3ISzwCo/lljNgCTQ5ZotrOSn?=
 =?us-ascii?Q?67Z/YHpzdkWygKydZmHdMXWTW2JywGn7fro1de26OkgQ9tQTFQXFMMF8eDsc?=
 =?us-ascii?Q?D1OV0j+Ko0R8ia11Qid2NReONn2+3Oc8dMsQCXX/1tL38nUk/P5K2jluUodL?=
 =?us-ascii?Q?nb2oZYGfKNs0SwyhuM36VaaiZtwxp0pwWAMMFnBELgw1nO1XW5kVG9Npubdk?=
 =?us-ascii?Q?oUlNK1uJjDzftpHSaoQd6vK7UGUbHEO7FYq1scsuomk3A+aDZi58DL3DHKrL?=
 =?us-ascii?Q?RlhOTyN1fPWQNNmbu4ltY+z+m+3LCtrizFZplShI6yeY7Elt49HdhgdySQ1L?=
 =?us-ascii?Q?2bxohiQO2tBhP2iOL/9aR610M2wrduF3dVRLWHR1YQ9UJ5XsoH/5t37fOIkq?=
 =?us-ascii?Q?F7i8y1XPIprXJDeCXszyI7ciVzuMteaY+p51yXYqsWFX0xLxcOP1DYc6V173?=
 =?us-ascii?Q?Izxp1wkf8bfM70KB+xXPScX1829OYQClX3N9gW5lideJqW3KbSZ1hGVzexnr?=
 =?us-ascii?Q?Qomv2lEa9hMXWEVsLG5UhBDpAhAly3TBxVHmDjZ5VDoCh82ROlQgI9rv28rr?=
 =?us-ascii?Q?chhjh3ZWll1eqKUF1Z7GGG20FEieNuny5OmbdJ0nwxMkaNZdVkruT/q4Yjim?=
 =?us-ascii?Q?1dvUVomLIYNHk0tW+4GuCruWia2Z2LVMhPimKQcFNzFbUObsbFDD5fdD9dy+?=
 =?us-ascii?Q?qsyroJ2eDvVNbjbooOtwEdMGvbtBnqzCZQ2nD6iGaEk9DMb4p5w2jYVRwRzv?=
 =?us-ascii?Q?6tuGOsHTwevBSZAXlVtuEG4QlawVqY0p1c8Nv3zb28Eo7h4gNysZoL/1AxWR?=
 =?us-ascii?Q?xZXMgfYLp6HkGisyVdlCZKQ3qlRoABBuDy/RtpnWhXo70PjTi84+x5E6aJG6?=
 =?us-ascii?Q?+6iu9EbLRyeZkUAGWOZo3dt68lJrj/O+BOHSC+MakM/PW9p9MsULohWHt3kr?=
 =?us-ascii?Q?Gd69E8UZYy4+JuRwzrejStyajFco9jcBoDpO56lUSDb2RMZLTYOZ2VOGYbGN?=
 =?us-ascii?Q?ohf9pdPfe0FlKmkR2L9wKiQMPkJB+hF/4kN+mYvP8BxVS9xcu+gspQ+my+51?=
 =?us-ascii?Q?zHAXw/HCpZv72Q18eOOGOPR6RYKh7zUnoTzmSp3i/QvBuFouBIZE9uLs8T22?=
 =?us-ascii?Q?Pgw7WzuJ+vl6fZNypQeC5axcQKVQOiVKfaen77xDVtGbjLy4fRhCgFjSiwju?=
 =?us-ascii?Q?4vjaogIvsXVQdeADNjDqEXhu1ZfdUO2QQif2jpu8z34Gvy+fLz2QXuqM3yGh?=
 =?us-ascii?Q?PisQD/+tf/oH0/3BthW8IOt5CBXwzivZy/B3kuEIeKe6aPsMOvKIUFRD1wtW?=
 =?us-ascii?Q?bulO1Ye+fTYTPkmFakJBulX+G1e1CegMCIcLg8ogSpL1XRWoijS8T1W/eqsf?=
 =?us-ascii?Q?BGQtHA7Qcw7fltn5Kune+IvF6RKdMDRWzV5SK9ZFqx7190kVLLXxFYwM/qcW?=
 =?us-ascii?Q?bYvX3g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f6777cd-38c8-463c-6889-08d9ca7a7cce
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:48.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6MNAKPm1iCRPczFIpj8YQWcJ2+j+AnDB/5vp1hwlU6ixcxtj+g/1ZRg0q425LNtl01NGjpbQcEuIqqAqCgZWSY++KnfvG3jNNUVCJXQpnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current Felix driver (and Seville) rely directly on the lynx_pcs
device. There are other possible PCS interfaces that can be used with
this hardware, so this should be abstracted from felix. The generic
phylink_pcs is used instead.

While going through the code, there were some opportunities to change
some misleading variable names. Those are included in this patch set.


Colin Foster (5):
  net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
  net: dsa: felix: name change for clarity from pcs to mdio_device
  net: dsa: seville: name change for clarity from pcs to mdio_device
  net: ethernet: enetc: name change for clarity from pcs to mdio_device
  net: pcs: lynx: use a common naming scheme for all lynx_pcs variables

 drivers/net/dsa/ocelot/felix.c                |  3 +-
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 28 ++++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 28 ++++++++-------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 12 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 27 +++++++-------
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 +--
 drivers/net/pcs/pcs-lynx.c                    | 36 +++++++++++++------
 include/linux/pcs-lynx.h                      |  9 ++---
 10 files changed, 86 insertions(+), 66 deletions(-)

-- 
2.25.1

