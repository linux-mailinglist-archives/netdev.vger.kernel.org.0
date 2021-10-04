Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DE9421737
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbhJDTSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:37 -0400
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:12353
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238982AbhJDTS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9ikpar5h8VioDvmOnAiQV4RMR1Mb0fcPS/04UvQqCQ9695necD2esLPNeutZG/+EPmCDo/sqAiolYysO09DQgi0NlLuR/xxOjmQpeVyoIs393Qd0IL7UAAN4QLuaQx34lZTCZVAG8WoPDqLJVhz6x1yiAMmJ1Z1kS5AhTOw/3MD2EUFsekxFhbgkEacthkLxkVmryPw0gjxhKT5ZivuUAHxGYMRl5w9mMMxhQz6PN0C78FpbSJFC8pPu96iG/y/PuaH5m46+n6ckd3vUUuvR2WxcbqBdXHjZmcckPZXyN3g8S/hmgd9P6n0MjhmQqdVvjcopj9fUDyN+VpOHmpMBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ChK7Kts7N990eCny/qEgkvUuCqEcxWqd7slt78ttkQ8=;
 b=lRyUCqp4L/GLcrkT28hIFoPP78KutgOlBEtaO1J/daCluX4/Ck/vixuNLkh3exE6Uz7miox/AF2kizWw0/T83y2fEkG96Dx17b67d+1/NCjK1q3IECu2wHrUC/YjeCuVnFNycmIy8hSeeZ9DxEBqEQvhVNijOGFliHGq4TXVmTPqR4On69LNu8kTFSYC4mWdxgkHOoKCegBRkjQ+88Ns49dKYXNpQaJWot7byQEH9bsmkb7l6yDf6SZHHYE6bt25+HGoVBEIl+sagp25VIYcHFCU9N3VrRmqN5G88dnqPHTSF4VXqOgZzQEpNFUxmyUpoXQruBtjWa5+V6O4AtqvmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChK7Kts7N990eCny/qEgkvUuCqEcxWqd7slt78ttkQ8=;
 b=LQkGMktt/FG/lVbRhqLUeUSXo2PtO2Oj1SCnC69q5QeLUakI/2Ecm9YIjxWb6NMD+0E9ozVfgo+XFTu/pf1xFoHLVFU7aP2u58uaU0jJT57HfrB9aZC+l6Ge31O0NbZFRWA/q5cH6wb61R/N3l/87MG4NfUiKKvFdO4xKlhT2Tw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR0301MB2183.eurprd03.prod.outlook.com (2603:10a6:4:47::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Mon, 4 Oct
 2021 19:16:10 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:10 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RFC net-next PATCH 14/16] net: mdio: Add helper functions for accessing MDIO devices
Date:   Mon,  4 Oct 2021 15:15:25 -0400
Message-Id: <20211004191527.1610759-15-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cad7f027-18c3-472d-40a5-08d9876b6c4a
X-MS-TrafficTypeDiagnostic: DB6PR0301MB2183:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0301MB2183DD1140961DF70157457196AE9@DB6PR0301MB2183.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WHugdG8EFCks6JF3KdXpl8b/EL+M5boiKSu2Au4EAzQu1WPhrwIFSwxETXK/L0gFLED4nGylpAj6Cw+xf1RPwXw2XpDuiWRu91d+KhgNmrl9q2qWcOsrU192MypTLZAQmveEONgv/LwjKNyFF+XJouSp71URqgWIZLGwAG5rvdqdmCQXqggUupkeElFmc/cR+FrpO+bHEGLQ+LTQyrWWMkK2RqZkQzyEPJiqEDZEfp2v8y8vgfyXSNiz9qy0Yu/pz65yFDPUSd/bjoMYU513biRe8a/tAEBX4SDnI/Du2l5h0K16l+B2WLQD04W5F6AL3roxC7YcCpU4XnjYBspvDD7KgoiA3qKllUX8EEPZb3fTPfOkumw3X7vmXIpCYTpkMM7lYzvCvwMmMlNoGQc7UOEpFiUoz8asNW9IxUZIUbxTICqxTJs8IwElHAd1M/fVkVnoHhAhhR9CzLJHqPrAKE5InRLN+v1PNDRzCixzKkC3V1WkfkMlN62eEimBkYL+RuFfu0sDQ5n89t3f+DhTBWOSx01fr8HnthaBOr9bxIM5VM5acRMqxomPwTeb2obxtgzki9nl/FISj6eeSzEP7zT3OIpvg6F5+HOwzOOAaSo77P4atA6utnJIZ/Nc7eOWp+Eng2qNQCzuDfixYLjnaahWnjM8GIV4L7o1mMNppDKZYsHOXRsX0s+Em9WHwwbRnrzu997Ss9pKrUZqbhXbiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(186003)(83380400001)(2906002)(54906003)(5660300002)(1076003)(52116002)(26005)(66946007)(66476007)(66556008)(44832011)(8936002)(110136005)(6506007)(2616005)(107886003)(316002)(6486002)(6666004)(36756003)(8676002)(4326008)(956004)(38350700002)(6512007)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qYoz0kL4/78vROObXpIOOb4DwDHev08IxD0rmVGI/91yzsAemSgCm7H3vUdL?=
 =?us-ascii?Q?izwRwqFV/f4ENBUhzXSPeCYKnjaEZdaYvZ43Mr/IgTua+norC75y2lactt94?=
 =?us-ascii?Q?7C+fzcZpQsAdOOHYbNUD1UrsCiE7FcMsnNURprtrIGQfZGsJwWQFJ6FacmHg?=
 =?us-ascii?Q?hMDE6zXJ3WO9By7pUO/Z3vXwwlGd6yXBEXtBLp+xpuqBVu5mmAXTbEuNAMZ/?=
 =?us-ascii?Q?Je2H+zY52m5v7h66YKMR6zUrBA+/wMpC+pKQZg3gPqzAK5sI7Onx0DtKDPFB?=
 =?us-ascii?Q?7rADwSnqAaWfJrC8tvJulBs6BPbnK62d5mNZqTidxeWziC7ISzPxjKOoMxSE?=
 =?us-ascii?Q?bHB343/K6ubWXxV7Z2wpPnSTY6+TVNSSw5ocYBsB2BEaAkmLGO++K8tzkDR0?=
 =?us-ascii?Q?c09QhiKtHKstp3gG/tFLQzlyhFhyzzeeNQoKt3G170CwXwYZWQSfj/zuos/A?=
 =?us-ascii?Q?k5bZc+h4hGeM0HRz7v9ku+fLpSicYR0FQfzy2H9pNWe1YTc1bKh34eFnQPEH?=
 =?us-ascii?Q?9NhMW+QvmENckTlmIsP3GW7r4ySsAEcDwIOs+EJPOIPvj9AiCrkMdzutpVaT?=
 =?us-ascii?Q?ZpO54lYUyOQ9nD6YcKre0YihXDbPPSPv5eKIhHqVCDATQy9d7LBVTZQ+LqAu?=
 =?us-ascii?Q?HwgktlRodnhcaCyI8AMeOOGw4tVFi7LZd9LZC2xIOkoyhklhNDImdpRgLL6D?=
 =?us-ascii?Q?QdQ6I6+Ten36SrVdT3YTasBRMHGNs8bId6ujUBLmbzepdsurzVWRSPgSNhy2?=
 =?us-ascii?Q?R6EFtY7B6TCPbgM/NcXM9nyQESDhoCQ/m2eqYGx2qO28rR9JGU3HP3f4daRT?=
 =?us-ascii?Q?D9rKItgvGtdn0yCnTGdozAq+nWnTaiXs54xmh3qQjtcVwR4Gg1EQrU/KKYYv?=
 =?us-ascii?Q?HrtJ7r1gnuwQwbogP04ARsxrMk+XYcC0sAyxqcU1LHcNeBBIwl6qducVh9mi?=
 =?us-ascii?Q?I06iaZOz5kma0nAm0fWPC/EZoOvwjVFQp9xWOf/yqe5y2bfYyQQZWlBiyY2/?=
 =?us-ascii?Q?3052V491CNhL0w5DuDFMCpmT+0yAjsUNGQ2xCQeQO0zE977kDKUOnsemk7ts?=
 =?us-ascii?Q?ekWuLrtfW5YolL7pafsywQ614YDcdMDpO0oMAmeiswwrIE5e72OD6fXYtmQa?=
 =?us-ascii?Q?ufm0DRR3NtD2lS9fcN16xyA9lCaZK35XoGKoI37bP02zwiyzRWB0opjWh1BB?=
 =?us-ascii?Q?LVbMyr/Fcp9SsTslLPsFXEA3drX2223nzWjLFcekP0JIRzFd0u+7VN4CxTge?=
 =?us-ascii?Q?jLcSxzOnli2iuUor1j//DEHK49h0OQqZrvsm4744qKbFzVnk8oZ22UqHndjT?=
 =?us-ascii?Q?vlLrfMneHsFIovkxo26rWCXq?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad7f027-18c3-472d-40a5-08d9876b6c4a
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:09.9563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MoahedUCgJsKY/PaiASL3t/8ZlfV6zeTVRI0bRIwpeGijW3tHj4WnWWpGDsxQ3rfzYHT6n0UaKjXqxWhLUBiew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0301MB2183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some helpers for accessing non-phy MDIO devices. They are
analogous to phy_(read|write|modify), except that they take an mdio_device
and not a phy_device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 include/linux/mdio.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 5e6dc38f418e..1342bbb6ef0c 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -350,6 +350,23 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
 int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 		   u16 set);
 
+static inline int mdiodev_read(struct mdio_device *mdiodev, u32 regnum)
+{
+	return mdiobus_read(mdiodev->bus, mdiodev->addr, regnum);
+}
+
+static inline int mdiodev_write(struct mdio_device *mdiodev, u32 regnum,
+				u16 val)
+{
+	return mdiobus_write(mdiodev->bus, mdiodev->addr, regnum, val);
+}
+
+static inline int mdiodev_modify(struct mdio_device *mdiodev, u32 regnum,
+				u16 mask, u16 set)
+{
+	return mdiobus_modify(mdiodev->bus, mdiodev->addr, regnum, mask, set);
+}
+
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
-- 
2.25.1

