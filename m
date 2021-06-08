Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F55639EC9B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhFHDDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:03:39 -0400
Received: from mail-eopbgr30076.outbound.protection.outlook.com ([40.107.3.76]:50913
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231465AbhFHDDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rjm/5T/wRFmSKfBGlkZqkLp5Y0fD0VlQV18dvCxmRPQ6UtfbwmFqoX/VCDcgC+RwrNvrYNlVUQIcyKjh/OCW6q9yncKbJtUaErGFod6fZRL7xmjXT01en8PGvHGlHRm+6jmAsJYehi/w8ugxmtmAb38l5yE8PW0CNOP7bLd9e8O2iRhb0b4JsagXiYJoB2FFx3lgIQ+iwu76t+ADq/IAWjeU6wD+hoKbENaa3dM6MWm1+g6yLf62SWue29T8QMm9KAvwoYK0KNsVKsxS7exCMw2507oknWaWIiZx9CwpIVKxL/Y1UZGe0qf06u7nl3EYyk77n0ICG2JsfuzNj3pv4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoJr1xoxYoHqMvfgMN1jpHrsrbHvTrgIezAdGHxm2no=;
 b=kyabTEtjLsm2rO4uMeFN0jova7qHlMQMDRmSReejFWUmOlEz9fLviH3N1z0HiLuFWJtf/F6RLsui35kPV/PCSR4ap0E/o2UhK7LHwdUMuE6Xuey1uoubgRCBPGM4pu00jhP7nIqWQaDifFgQO5iXMAbeOLag7vZjOzIXpTRO20g+XaavkvmUfkcfQ6C9sAlJ9ylW/0pjoOhZY3Im3pdrmBQsqSfi/NaIxT7vpzighlm9IJGciPwDNulUQn0B7IXv4q7M9CEXxF1i6/jAElXlAhSCwlWt5oYSDl6B062/sH1h1ydX/+PxWnI5ChSlWTjnYzBnmIbh04zPN+9MCnikug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XoJr1xoxYoHqMvfgMN1jpHrsrbHvTrgIezAdGHxm2no=;
 b=KfFlmFMUjYl7fdITpy5qGRG0T6CO7iDekbRaim1duX0Q+tAFJCdt4U/IUbWn6+2KR2hc7HXptUFggmEurFHoTlX4WvWGhmNxkr8uG7GUaGTAa+Epz3TEwL0rGqWCQkIfiL8Ik5cHc2kccX1AWvncJUowSFpKwjvzG25zOBvb2UY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Tue, 8 Jun
 2021 03:01:44 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:01:44 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 4/4] net: phy: realtek: add delay to fix RXC generation issue
Date:   Tue,  8 Jun 2021 11:00:34 +0800
Message-Id: <20210608030034.3113-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
References: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:01:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de3e8c6b-b820-4378-e542-08d92a29bf0e
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2904289C49D562B11179C0A2E6379@DB6PR0402MB2904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ok3JvQt9TNSikZrIt0cFsqK2ammKhalzydpCGJEM48TNHQ2SJUJZqRA10GoGS83JsimnbCktN6gZuub7S0OhYCSifWbBzIlfLfpBW/zHZsN52HLvl6WJ1MnzT8Ime2mv+gD01UXC+qdlaLcXSAkCPu1bMLQWAlGcVJn7CAXI9HRtIsE06QV+XQ8EZi4uDML2IOHgMiC2j3Lg7mN8C4+HyIk09WXStwQUmNEQiR8YrQg+9GfMcVz24Fj+gnkDIPm3iFw7ThnnX8op2eshfmSttlA4MQzuaCLOimQsu8NhBMMuH4E84RMP/IO1AKOva0W0nM04QAAMkYPNTI2s6tVJq3njDTuoFVvAX2dTsZftsewDZMWamCUACpAbtO63ZkfN4SeRjbxYHdBmdowEvU9Bqnp+cRLNi9/mG3mILmRCmGxS/hu6lqbVHv/P797G7/pwoEObiwmr+bMcqxZkPGkKW5z5GaUarF3OCjArSXLuGpndzmKbdHIB0FpQ9S3DGc+qkI/r+/lrzLDWqNF7FrROCblcvxVnqoSj8sZhY45IipycE77zsmZmQm92cnElj7kbjHYGWw162ExstjmxeJfYToyOrepRbK1ECDm3JvZvubEG7OGg0wTFbcoky/z3usnMLRMp07EldyGMRFl5kNcuEuqYkfj8PjZrAhMgxgvk5JPO9VwMY58jn8xc9C6pGjI8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(83380400001)(6666004)(38350700002)(86362001)(7416002)(6486002)(52116002)(16526019)(6512007)(6506007)(38100700002)(4326008)(2906002)(66476007)(66556008)(8936002)(956004)(316002)(66946007)(5660300002)(8676002)(186003)(26005)(2616005)(1076003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wdNt01EapliesshgoqBO+YJszgHo/TZTJiWeLNYXMpOstxisfDpWOgUO97RW?=
 =?us-ascii?Q?iBd9iwB0rdptI4tyQuPPSLeoOdxzX7hmLXKltByju1imOsQ064YBNANGuwz5?=
 =?us-ascii?Q?NxVvhO2hITQ7X+hqigOujPcf+7tQTHqMxtCfKDyqpx+efRvflvvjgxkbuz7T?=
 =?us-ascii?Q?2cisAMjV6BT//E5UJ1BbEQo1AzfDPRiL4GZJx9hWpjpM0onwCPOmAGYrbBuQ?=
 =?us-ascii?Q?1FPK9MCXPpJfyrdZlvnVPdCoHkhGxkR/MCXa93XFYGPA/KM86tox6ObfdQtf?=
 =?us-ascii?Q?1Xo2F5+AlSeg25X0Tp22pvbG2cm0ZW6Rr9sP4Jeo3+Q033VqWfApfw5aQKUh?=
 =?us-ascii?Q?kupapuVkEky+eH/rQLV+MYKscb4TxOMCpCwAp4U1TK+6AdkV9TjzeXgawybe?=
 =?us-ascii?Q?K9raIzWJgZNg+sKXehY7Z7d/TurJnDftLYilrV4OlONxD4cP/hOb+i0olJs8?=
 =?us-ascii?Q?Q0vccEUjKzSGJHabPalDaBWIMpn2rmTtaeotQMZ/BHTixh8hotTMk6K1tC9+?=
 =?us-ascii?Q?kmfiEPdUlGzq5hYqYXjH2khRyEu2J2nYIKsI0BnAeRfE7IIcsbblXcNqzG/S?=
 =?us-ascii?Q?J8ITeWRRqGZWXLotmMu0U3rWQVPgZfM7ZvqmozTkN45JzZr/1Zkn6OFR4Hyh?=
 =?us-ascii?Q?JPZ5GISYuNfPss+ytSOVnwUe3gIJu5eDtpevgYpCcPQV7K0JTdiKv8pL2Tao?=
 =?us-ascii?Q?J6KLaN8mhD9yxtbaX29lRISJKNcr5KUtEnzuPC3U2E4zyzmgOO8sKsCAgWRn?=
 =?us-ascii?Q?QYck/ddX7NdpkvWu/objOv4N1aSdKO2uNQ8wwvpNxyJehisLDtaMojtBjowa?=
 =?us-ascii?Q?xK7fu2AYycZ0bvXoU/eFDYFyxGtzoIN7OpLL58W1QZCwO7gCE0BRLbnt2dOT?=
 =?us-ascii?Q?oDBMR/B+nKYuGk72BNS5uiXmx6t4CPMANwPMHMNodQkxN8CujuRsc/kge7P+?=
 =?us-ascii?Q?Jzcj/2eslBQd9Ln0m0131Fj/3LNp377ImvcTPYJqdmn6TPKfFmCa2E7GHLc6?=
 =?us-ascii?Q?92fkraiqwDE865S6cYUL0LcYb08VCEBTWG+3MIGTHX6o7glJ2YHqjthPL4C7?=
 =?us-ascii?Q?afLi6Lcdd7Ka0foGbRrIqkHdbfNf3ILwgrVBp2J9+g7Nw41t86RUGr6Xf3NB?=
 =?us-ascii?Q?7qN9SRP2G9dO65BsWulMGgmZfoGzddYJGwdnQuJuBbcKDcNaayPsYsjZkn6o?=
 =?us-ascii?Q?p9K/E3iSOF1+SU7k2TooIDASgbQm23qRiFgk4ltrnLn9GBGJiNATfi5b1HPz?=
 =?us-ascii?Q?pFtJENsY41CdnJEQLpuLClsDUCy8xd41asA7/8/ALMZiKdiIMB59Tl94Quq+?=
 =?us-ascii?Q?uu/vbjvbfhPnWyV2mBZyLCmK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3e8c6b-b820-4378-e542-08d92a29bf0e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:01:43.9963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlyJhrHvGemqcYFEb1vWZLpxq3oIa2hH1pLRHI4mSM6qfidsTWYOp9WGB184y7Fg/I4ngfPGeSwDKK2ecNwrxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY will delay about 11.5ms to generate RXC clock when switching from
power down to normal operation. Read/write registers would also cause RXC
become unstable and stop for a while during this process. Realtek engineer
suggests 15ms or more delay can workaround this issue.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 79dc55bb4091..1b844a06fe72 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -410,6 +410,19 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	return genphy_soft_reset(phydev);
 }
 
+static int rtl821x_resume(struct phy_device *phydev)
+{
+	int ret;
+
+	ret = genphy_resume(phydev);
+	if (ret < 0)
+		return ret;
+
+	msleep(20);
+
+	return 0;
+}
+
 static int rtl8211e_config_init(struct phy_device *phydev)
 {
 	int ret = 0, oldpage;
@@ -906,7 +919,7 @@ static struct phy_driver realtek_drvs[] = {
 		.config_intr	= &rtl8211f_config_intr,
 		.handle_interrupt = rtl8211f_handle_interrupt,
 		.suspend	= genphy_suspend,
-		.resume		= genphy_resume,
+		.resume		= rtl821x_resume,
 		.read_page	= rtl821x_read_page,
 		.write_page	= rtl821x_write_page,
 	}, {
-- 
2.17.1

