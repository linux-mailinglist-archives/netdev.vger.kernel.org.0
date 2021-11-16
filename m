Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0597A452AC4
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbhKPG3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:29:40 -0500
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:43904
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230448AbhKPG1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:27:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y23ZrD9hs65Mukg6TXkwpw2I1kjjjF5DZtLg9/Dg9RMB3wk9uTQKU/wk4GODQ9vzPcUnQdN7JHdo0W2jeiHgTrRZcIuh5bBG9UXdc7iPwiTAO1kUdshbIBhDwIelcDJuCjOFY0aHV0YxlvKuZobk4EFGYwtH/5wPfSaIiBvjWnZ26X2WkIyXolKW1Uw7u9LeorXRKvU/23FUYfUSEbf0TWZh8VJ6F4RfTI5LdOQ4kC0tS/gvfjiH0AJ6ZTztiBMlU4f32z6GEaqpiQfkVaWBPws+G3jmNybWkQvaTHNotTJmnoWzp4qdGQwg91gs6W7jZc1GWUwaDm7HgKgB+7xtuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugxxeNhoCd+QUZYaL+ZQni1pVGcyQnP46C2Xz/dU7Qc=;
 b=eEwLv3E1utaoUV+SsghgrWWydFDg6/lq0btVXYAjbjoevVw62i+AhY7xBnbLfDHZS4+yNbnN/umnnCwM3GguGa5DR4825YYP8vpp+a3SifREB0Xbki8q8dkCV4BZiPIIeGGNghNwJxZ+4DdkPehWeGvCV8eMjjlQTnX2v1XmXP3ifJ1XF1IEn0iFfWMA7g4jGN069V1t3xssNRxE1tC3sGevYuBmdVguQA9YYUiU9/2sohLn4d2SbtfLdrikVueEk599FmsO2zwZXS7183jULpCi9ovQgpBrtIyy+PNdBV+SnCt+oCS0e3U3CTN/lAA+e4tK5j2LVHmqPbMbNsj0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugxxeNhoCd+QUZYaL+ZQni1pVGcyQnP46C2Xz/dU7Qc=;
 b=0aRBOEUEljkV18D5LvBBe6zmbk35ashwsYAg5Wn6RVD/3rbZCSxjeVYCq/4pEwOvznQ1AUPmXYo1yO09PK/iYJzE+hYO9vTupleRuaScCoATKW5yW5A3M3s+CHfkCmuqGhmj0ldD2mc+q96hTGev2aRA142dyiXAmP+wTzhg8gs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2383.namprd10.prod.outlook.com
 (2603:10b6:301:31::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 06:23:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 03/23] net: dsa: ocelot: seville: utilize of_mdiobus_register
Date:   Mon, 15 Nov 2021 22:23:08 -0800
Message-Id: <20211116062328.1949151-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a649a4a5-e780-4c6a-4f53-08d9a8c9a407
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2383:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23834404C308135761C909E3A4999@MWHPR1001MB2383.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b0GlSwoXlp7i+BIfXxIgq6pvs5zRc4EO1fzVHTa9mcuBRXZwDWw9Sm8JnvkEvtGC5YfJgcLSZQc7BJ6KW15Wsebhdv9b0nELuECC60/Ff8jQwhAjDxqtuppaqiUdonpvpOLvdjwgZhfbYiQtgCYS/OaupuMrV32DdPWbF0raVbgMPogC+0+Uofeuz6SF1t+B3g+poOK8vwGlslNE/z8Saj9gXaURGiAExRLo1hYnjWo6jkle3aFPOnAGwNhAJPFurVejt7BGp6llRJ55SibgTVKwPtl6mwZG4ELsmQ+YR+zz0482o1SAfiCwZ3dxeWrjKotK8EqWunmd8Ur0MM8v2NHrpnVZeiQnxHBloxJQ03pX2scb87VVxtojVZbYw1z9rfIOXCXOXRuBsvHXqpu4REySeadQ7tfb178t/Xb8VFouFTfEAO0x2awbDLjmyq2NHJRZzvcu8hDqAwsg7oCoQ1VklQIPVtWy1m3IAB1fGzCg0mAd2cH+XwhBqeXRN1pWJYZI5m/EG29Xq2tCH7iBwCocEvnBbls5xhtXDU4cAeVz3QlKAdbLh5GWx0FUb4mlTfbeVDuVKw5CwhxVAmut/cllV0pUkxEqZxwYuRMkheSpm1MmSCoHoh9PWw2FjxlOONgmd2bSwUM5L04mUStIupfmJxOnDB0ENZpb3HdjxeRy3xVJ5oBtAdyUFU5TfLO0uNCfHgFT+U15tTS3g9vigQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39840400004)(136003)(366004)(346002)(396003)(6512007)(54906003)(316002)(4326008)(83380400001)(8676002)(86362001)(44832011)(1076003)(2906002)(66946007)(38100700002)(38350700002)(508600001)(956004)(26005)(66476007)(66556008)(6666004)(4744005)(6486002)(6506007)(52116002)(5660300002)(36756003)(7416002)(8936002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2wrIoONKNu/wsTJYkqneW4X9lPOLx5TzJVBZiRz6S3AsVAM6aqAPSzFcASg8?=
 =?us-ascii?Q?3RqDMw3oidDNRJDTnXsSB3PRQ6RqAuHJ4RZxkyrxxXAXgsmx9rkDLrBLY8YX?=
 =?us-ascii?Q?bc9cdF1oj8d1VLoIbfhTinAxvRe/K8tCbJMq6QyKXNLNk5VM2DLMVwr3IyWJ?=
 =?us-ascii?Q?IMXBFXhBZMxN0RgVkvp99oIp1RuZlhtBDKECzC/ylNXgTCkWo3jPK2B9QIqQ?=
 =?us-ascii?Q?dvU5kvz+xX11LLGLXW4bE4hEKh7ewROXhwqQiSxpjmQO/lK1MOk1ignyNspT?=
 =?us-ascii?Q?2ZX197PeYDpjqPFodsmQPngxAsUHEVXp6BZVJD4t9nEgWVRPwJq6m1q0PVHT?=
 =?us-ascii?Q?J27h8VwDXhNWufvjo6N3eRV+ysgBtW0kpojPwUUBlrxzUsjLp+hyq5ZFfrAh?=
 =?us-ascii?Q?nRln8A7cVeEur6MAXzn0ZoiH26di6NGN/68I/LSnpaHoTIk5vcCAtvSNeUlV?=
 =?us-ascii?Q?Omr/D8s6giuUVuwY3bpbvgDIZ0iY3gaBcid/Ewn+9fgdfBkUh6LoEpnwJyEg?=
 =?us-ascii?Q?fEPQB2Ajt0MwbyLBpD7WaAiVFsXIyt0CKsl0hmEdjPOysYtyqZvhdoNTqHCw?=
 =?us-ascii?Q?hLtO3jZ3nmo8anXhjPLDo5tPXUGtY98r9ADxr6hAoCmbbmf2mbJOdoqbHbpp?=
 =?us-ascii?Q?fzvXi/S+e8vfsgx+fQVRbi2xOvBaLvduSPYTBoC2O22vvwRRhG4A15Fx9QDG?=
 =?us-ascii?Q?F/oc5DmPI8bC4arCiFQ+iqx0YudRE/fGopBluW1wmMwrgTsekRI5PBSBqg8h?=
 =?us-ascii?Q?F5cNNScqBqeGPIZsXktvqcrsgJ19B8OQPWptwzqyDaZANX7hQDSGjn7hseOl?=
 =?us-ascii?Q?BWj5T2UFiI7u0/aXekBsLbogPYL3e/wY3rY5a1HGWbgJ4gwB3gmmQVtGH8zL?=
 =?us-ascii?Q?qDyEEYTFlmnCrMEqtqQO6/Yo9B7irALNxW/jdO5EcgcNQXoDZYgDg0TLf5xB?=
 =?us-ascii?Q?GQxyr/Q7WWXCYlooHyW1CWCzi67lCg319JvGw6kkAhJ6oNhZVfSNVaaFdIJm?=
 =?us-ascii?Q?q7clWnzQYtFlO6OJNyp/1z5//+mWapnJd8RPSLxRsVBjDsCgUlNOvVLPZqol?=
 =?us-ascii?Q?Hbl+CHpRlxSQ/SOiWRnWb8b2N1XwCQ2dk5R800ONrV5ACxYqHUqJQdXXfNjB?=
 =?us-ascii?Q?gXcLZDPYY5707Nm+KHdDHsODXjoNOAJll0DdQRfDvEhvKwMy3yDwVu7HFFXl?=
 =?us-ascii?Q?gpg8ntbvfhEqTChgLBLb4wNkQRa9R4+XEyWA+W0btUSG/JymYPgSahg9VePz?=
 =?us-ascii?Q?aYViyU0cEYaPCc/75LePENcsxSUXVsxCkaiY7BFgxTK/r5/e0+FBJx5fmK6f?=
 =?us-ascii?Q?UpobS68ZJxao68b+IydG1GD3jOa2UpPMXOIOX6XKMspE3e51wuirzafZSsgr?=
 =?us-ascii?Q?QbRDp9Bt/manherk5FvXk2jjo9rLhtX8T9urNOqE3nuS+xhDlb7kFvCWuyBI?=
 =?us-ascii?Q?uATcdU0zIUOMz248L/ov4xUABAv/+dCTxJzt51Sike8drB2nm6KcSRFtV8Oe?=
 =?us-ascii?Q?1rEkCWgdIKNyEkHHpLrm/Tuz2Dxm8xLH8uNN5chwZ+XYFhRinsFgUZi9y9tB?=
 =?us-ascii?Q?G5k6xtf6ncgMVqkgGgo/Jtu7X9BPQVF2j/7NMsyylUOF5tHgB8ltmckHUSg9?=
 =?us-ascii?Q?CiPiFXrQlwFGi2UlWgts2mNLJwzG6Z23wtvtOKrUIq1ERRJGMkkNJLPPWLuT?=
 =?us-ascii?Q?CwatqvtweWBTeYzB0zCTWRbEdug=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a649a4a5-e780-4c6a-4f53-08d9a8c9a407
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:44.5300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzVNENqOEH+iJQH7AnbpwWZQaODwG8DqGgtRAVqNQLh/71pxUTez9VEkxEh1+tWbM+NU8mioBGI2gdyNSK8G/BtJHSvmtEEyh88TJNJmnrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2383
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch seville to use of_mdiobus_register(bus, NULL) instead of just
mdiobus_register. This code is about to be pulled into a separate module
that can optionally define ports by the device_node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 92eae63150ea..84681642d237 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1108,7 +1108,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = of_mdiobus_register(bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
-- 
2.25.1

