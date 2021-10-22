Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A902437A7C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhJVQBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:01:55 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:18401
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233397AbhJVQBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 12:01:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IiZIHwXEv5coaYBvrudOAXxViinkfjS/TpKhlUCHTGNtoZ2yTppxofYHWhjm05fxhuQTVrSqNTVEo+U1ipNL2qgWQx4G00WfI7CCj02kEFC7sCSauJvsJQs4ajIOYO0Zb30RLneZAbb9oupTLYRVDUWgyFos7r3sfziQWQUnv5zy1xoKVJtODUNHS15GCy56IqSesKF4fivYF0+9bdHEFus722CXp5TRLjmJ5u2uA3wZgXnl2vBCxb9tp+L3BGM6YioqrUjh5JSrr5758gAVThl9V3075oyLv9TvtIgc37NOsG+CLdFTPrEw9TSQSxVQbZIsJ3L5hDvbSTgqoMo6OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WPhI3KxT9/D5GUvE27snbPDVBMlSev5/hgtRvCBOSRE=;
 b=NGjeZ1k/HYHHXRh1TE6n6cyS4FtHdPGNIKGQcze2IloA4SxCZYWukcrzE4Bt0eCeCo04FoObs9aTDaN51GN6t/tBFuPh5tWIGQ219xhZILpHd4yP5Q6fESHPSDACSw3Vpx95tV+9SW/AKnhj5KMb7uAtNvjFJPr+xDtC/pG3huMYepJKnePTrjnaTclnpMGSa6O+2wbSCRII4PcDMsyiC6IGI9qs6UaGGVXVzQ5kBMWY+3a7Hrl7iGBlPZSCDbEP3bjh2sY+zquif9eAE2KI9VAV+5mSjwiPrFT3pqwNjiPGs46Yl5VLQLEpY5E/y03QUBBzOY4yYg65GknjDR8KHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPhI3KxT9/D5GUvE27snbPDVBMlSev5/hgtRvCBOSRE=;
 b=Uj705oisv3uchxYXXWHEN98yYx3/xR5I1Je83fLQFGf3BkBFLc23tQg0hEYyoibzHnlOjanxQXMWNdktFqR7XV5Wv78u0OWPsL9U9tUB6CRKk/XEtccWBZ8kbcbgC0E5tOdpJzoGKnDXHeq5X91NWygT973Dn/xuF0ru6XNxukE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB7PR03MB4522.eurprd03.prod.outlook.com (2603:10a6:10:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 22 Oct
 2021 15:59:34 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 15:59:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH v2 1/3] net: mdio: Add helper functions for accessing MDIO devices
Date:   Fri, 22 Oct 2021 11:59:12 -0400
Message-Id: <20211022155914.3347672-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49)
 To DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR01CA0036.prod.exchangelabs.com (2603:10b6:208:10c::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 15:59:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e4be131-ea99-47bd-d81d-08d99574f0ce
X-MS-TrafficTypeDiagnostic: DB7PR03MB4522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR03MB452211FC201802D50D6B70B396809@DB7PR03MB4522.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrkStRtd+x7DmDzdZvY5w2Hvra5TO29/XO8hsi++4L3QRF20u8VHj70yosazJgfj5aHxZn8UL7q+GVaoGqUK+jcAfzRcTuQ9JRmq1twVFhG7QAD16CY4b+CbyzOoYPU5ga7yMKr6iB/YoNSIRsi0NEC6D+DIYcBZsjZeesnV35J0hAsy2b3vsZc5EJ3M0wDM+RLkKMZmmo8qFoOyvpdarkN2IoHgh8OGkaKdLkZfpEW9mmsXNHEoA1yXGaN6t/fX3d5qKJSew0SJsj3dTw+oOZvx5fshKUb8V/dZft/R/8POp43gJiY5gt4DKSFFiR+TkcVxgYiTPkhvCn+EI5ixU8aFk6f03PrKdp/81hknWXkXnP5PEyIxkfCRCXxpj4Poc4ZcLEbaN2KV+C8PjtGb5PRHMLaI5oVzhErdwwRVJpON6xA1wLM12zgS7ij479Ob889EiFHqG58aRAW6WnXxAIcV8BthkYhugHVGNgFkzTkP4MxL6rYQapOGYjUTfTYwwPS0xg04eTmPCXVNXYm/vB/tBLRTudWmiy6sic8ERmHOUKOOIuyJh3qbZ07xFGZDHlue8EXDu0kTf/Ii+3hS+iw4DwpxLNbkgkO5usj2Yv5gHVOANVgnBfmWlmeWb3NlGdjAmYZcPtfwdraTBVu4ETWtN4FWpfEOoJ0P0EyjE+GIGoGc47VuJe8VJCRLtolDtn9FgsqayoPoe6XjHMTbY8BKkz3fkIZu38ZX8dBqtnLSOMWNi4rQEAwlJYHWba/eVwLcwzGsmY4Vv4bE33MxPlJR5Yyr8WjjYr0Aprae/84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(8936002)(110136005)(2906002)(26005)(83380400001)(66946007)(6486002)(6506007)(54906003)(5660300002)(52116002)(86362001)(186003)(508600001)(4326008)(66476007)(36756003)(8676002)(66556008)(6666004)(44832011)(966005)(2616005)(956004)(38100700002)(38350700002)(107886003)(1076003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/uAGd3hKl9BFJW2c9gUbYZaEn4Ftd8gJ6NyndY3gBU7IROg1uEJC4Po+G+C6?=
 =?us-ascii?Q?cAhIrTk2VKEVMKkNOpcwSueqyF8rHBP0P2Xn+zyfaS+OplD4bWqFnSRpWgsW?=
 =?us-ascii?Q?7HdOf998b15tXBKxB/SzB1wlZPZb2sNxWD0a5nt2uufozy5nugheBtJC7SEt?=
 =?us-ascii?Q?qPZsLOA6PCExJ/GUBFOCto4E+Kao1bd1DvKTm25QTMJdCzQ3ZvIEOAJE9iY3?=
 =?us-ascii?Q?XXlAkWL8tmYhni2hLnwwaRUZf0u0TV2wbYk2AqanzK2ylRu1gwsaOje72N9S?=
 =?us-ascii?Q?04ClpcBwCCPe9Ox3Qk1Ci+stKJsTaUiqoI4cqBDLwIW8uZQFzMbjG7pfZrib?=
 =?us-ascii?Q?XZ5T9s91zaenCw5bcnStvoL+5uwC4T0MvqwGKYpt5TcY3aSM3zNf8G47ny2H?=
 =?us-ascii?Q?FE/Xn4lLgMGeAKApj6TLU5cbBqNgnNH+Zb3ovXI8CqrB8abvOJh2dW/lx96t?=
 =?us-ascii?Q?F6NTq4CVDMyGZkRZVt3rgiL4dI5KPqY/B67OUdXA1LyfxZSaKPwcObTUaPKO?=
 =?us-ascii?Q?ZCCykXlG4sUzTAKsyA8hTHctn2q43eGuFVCWX9TdtiFUJrNesMOLNShnZ82l?=
 =?us-ascii?Q?pE0YobNqj0uzM33p1KBM7ICKkLds49dVy6TtU9Vl9WXAv0MTQ6vSaQjEybYy?=
 =?us-ascii?Q?j1JQfZSUhIbu6n01IEJ5NO2W0NcWg+LNJYAWpgJfdQ+GLtKg9tvGPBVbD3hz?=
 =?us-ascii?Q?CZupvcgtEYPYOuUfHp1+VeekDObeQ/cidqr2L4MIRUZKrOE0YGbtVD6L1rl3?=
 =?us-ascii?Q?jufgi7QWttvE1DMyWjgZAu4WbFYn7HfTPO1FMJ7mjQUpOlFKHg3GBFrqKelr?=
 =?us-ascii?Q?Peaame2+FFPwY8+Y8fA+Qv0JTFw7kz30D7hlucxDAY5fgbvu3JFAOMy592HW?=
 =?us-ascii?Q?YU0ejJXb3j4z4TEVRXxUhmchyIdM+RnOu6TqQXYOG52O3PL59Wtn4ZYw5EDC?=
 =?us-ascii?Q?XABRvUy+kOP2TRoeOI/vRO0+xOwJHLLlPar/Ceq9azq0T10+zZ+4Z+rhxIHI?=
 =?us-ascii?Q?4tN9l1ROY0/tnW3N8jfgK1cO1ut2HHbq/vsXMm410L7zTucqKito8ifwO/+F?=
 =?us-ascii?Q?pY4jUmKx3s8r+rOLxXxFu3PrgMNi5raUjjaHxoRY65MntJzPH0bOej1csfS/?=
 =?us-ascii?Q?eiMdr2jMFgej7Fj8QZCv+JDldpyLaUwJ9N1fo27zXT/MUyKGEWWl1CdiaVMy?=
 =?us-ascii?Q?s6AEYuGg8C4CzZXyvgDNNeNpnF9Jyd7oGxwayEv9RlcDEGwyG3J5YDmfVv2V?=
 =?us-ascii?Q?giamQnRFzZmuSCmI1gZai6U4EMtkKgyHX8Vhqzrmki+vKDENgJV8uqIKEod1?=
 =?us-ascii?Q?zyWSNSomUQSc56wjWYR8JWxq?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4be131-ea99-47bd-d81d-08d99574f0ce
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 15:59:33.9947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds some helpers for accessing non-phy MDIO devices. They are
analogous to phy_(read|write|modify), except that they take an mdio_device
and not a phy_device.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
This patch was originally submitted as [1].

[1] https://lore.kernel.org/netdev/20211004191527.1610759-15-sean.anderson@seco.com/

(no changes since v1)

 include/linux/mdio.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index f622888a4ba8..9f3587a61e14 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -352,6 +352,30 @@ int mdiobus_modify(struct mii_bus *bus, int addr, u32 regnum, u16 mask,
 int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
 
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
+				 u16 mask, u16 set)
+{
+	return mdiobus_modify(mdiodev->bus, mdiodev->addr, regnum, mask, set);
+}
+
+static inline int mdiodev_modify_changed(struct mdio_device *mdiodev,
+					 u32 regnum, u16 mask, u16 set)
+{
+	return mdiobus_modify_changed(mdiodev->bus, mdiodev->addr, regnum,
+				      mask, set);
+}
+
 static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
 {
 	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
-- 
2.25.1

