Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CF83D2452
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhGVMZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:25:45 -0400
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:57166
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231939AbhGVMZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:25:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kO1KMWtHqKnH/hRQmCuxw55SW/2TiKsevGtyn63eaSYvpm77r7m8i3gYZG8VAuol9XzxG4jpfufkr9+8LET2UC89/aW5SnHuPv3P4oKuu0yJnKyVYc3eBCwhGG6Wqm8rRK7vbckfVnxKpEkxf99XBCWqX12t5Ik2jCEI0wpHOOjT7Vqr8ihi/WMmXzQoDG0/t8a97TfH4pVqFzgfYeGMDHe1/2FQw/2ZPobg0DytTrEbKb21SlDwgkhQFcKkj3ruSf4/s5rE4cboPr6SBAzkBbFOq5Nc6DMbK8qD79O8FcBR7SaBCkbYH42Z3FgUc19IECMbaz5vMWR2Yf5oGkHk1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3c53SMSUJqWJDWIvC8oLQ9JPixeSfoViXb573p0nhC8=;
 b=iDlcaZtUrlB7FhIovpEVdvi0P71mTVFB2U4pIy+L5zVh+YMAf9xn/b7ij/QBeH9qNHuyWEYZSvvwQeqfV3cftMfTwCwEVEuZ8aQPHgAhGCFiG0OIBdHZc/jbODTIoLfslhoIRCqj9L95Wej1N8PXagxX8Sc6a1E3EOzSuNM/uHloGW4KJlGy1sTNOgdyGeNQZC3P0yB098xMgfs2JLRuEwVK6XzqxGjK7HJaz7BEEBtcWNfdCUI6ubWjX8Z6+zul/3/XDKUYcsjf4spMLdk6KAppX97sCEF24dvORD6cMsJzKBdAiM2Lnj9k7Jcb6/7WjIK+POsDczYoO0HzTUxO3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3c53SMSUJqWJDWIvC8oLQ9JPixeSfoViXb573p0nhC8=;
 b=D3m2gfwcQIZq2x0u6nCyLqhKiZ/o0k7D2DlMuPhJtRZd4cWxMtmWMWcWbXZhGwoBfcU0JKJi+rXnAQiOsOHlIE4qvfQDsdLdxcIm3e9ZwVcIzPYMwD7H/qbUxkX220vwk8Ivd8CEmWN3u0zoM6J3VLrY69htGeUuj7hjFmBGwXU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Thu, 22 Jul
 2021 13:06:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 13:06:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eldar Gasanov <eldargasanov2@gmail.com>
Subject: [PATCH net] net: dsa: mv88e6xxx: silently accept the deletion of VID 0 too
Date:   Thu, 22 Jul 2021 16:05:51 +0300
Message-Id: <20210722130551.2652888-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0068.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0068.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 13:06:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0f5d9e4-0d14-4226-ff74-08d94d117de1
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25094C3E8904B74C9FF2FFE8E0E49@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Agpd6VW/4/yrDGg4r4Yzlq8U3Wg4iF0PsX4yRxf/ds5Ab3JvXcuitriDBDJJprvPzAl7W0ZvCf0xzP9KbbQ+oDUjb3N1VAj/2k0VzxKe2MVs9mRIU6Nnag8koE5cK9gqgpUe5nB7Klbsg5O3KC/aywV0JWmaF6epdpdkVpVFTIV017H+UZXNBQh4GW0DgCvdJFyG8FGKydCyhF92R2tVqqp7FAdR1Ki+HIQET5LOqpYVSpcufsWg6OqCxhcdi4HL0ee/up3wUKFmsDtxfS7Ow/K2QShlP5YM/frUiwUkHfq381v5OQ6sWp6qVrEIJ8o54uhQNNAcbkqdaYx7OKBvN1Ex+3QeTNN89TvwG36LLu/uonDU7ReBCymXSsm0N5HRVT5SzMPipvee+QwG1aK3JQ9zkD5BikrCqxTmOqu/kJj0UIutPG4QM+qCV4V/hxfdG0pEmpQ2OnWg8x+0oxEYQF/21nWBVyj0OIkOKOYe6Zg/6A6VnCvp1Yhf+kD5TlrM1uQZG/kDg4ArS1hOWiJAxbf/hgopiAIY0FYEzr09iMFqCRbyaWEvcf3EvF1ZcdTe1nh5GV3mCZQZb5tfzlhuVXYapmQ1OhkmrBUN4euf/LFTaLK+OaAgmnUv3/TaM0/6eMStif+rrD3Dr2/AAaPukCOTZP1KsVsbZCHgZvKmDioEOoX7+gZvlyT6UzXIxKG+4SIWtyWzCjese16F8Rw+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39850400004)(8936002)(54906003)(66556008)(316002)(66946007)(38350700002)(8676002)(4744005)(110136005)(38100700002)(6666004)(66476007)(4326008)(1076003)(44832011)(86362001)(2906002)(36756003)(186003)(6506007)(26005)(2616005)(956004)(478600001)(83380400001)(6486002)(5660300002)(6512007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zoxvOEis6putdRIqralFU6FYPg9y/e2bFCKYz/vhxrajezX/kdAZ2FgmZXfo?=
 =?us-ascii?Q?j8KCMd6EvRGfBI2jTvz4lJkvdfFcrnPajKmcoNJVUwLhau64Ad6zvGmySlMF?=
 =?us-ascii?Q?maqsavhM/MmkT/X0uDtR4RA7IobLBlZ1NZEsun65PpYtSuKWzmmt6UuSDsEg?=
 =?us-ascii?Q?+IUdVop0RjzgbCcZDTEFLEhralgNlX6K6Mp1JbKIRHyXqOCzqqnBcCQ2F5AB?=
 =?us-ascii?Q?qYchTQcRZOCmDTiG4/2rX2enfu5n1J/KWhi/m+xRVBQVlybMvAqzFkLqBbdr?=
 =?us-ascii?Q?lNOL6wvwy466v/wjEvJiT8nxHxUKkwz/JbpMLwDuSHuIjab8Tnf+Jt5g1QDb?=
 =?us-ascii?Q?OopUbqA8onKENypaEvhbMhSSBXEUK8uz4ODZn9MGI3G/aDWnihnBWfr/oSe5?=
 =?us-ascii?Q?WZS2QTz5S1+2qCSh0JYfwtnKeb3/kdo6XA97Gea0bVtaUkoobc60l1bEQqnY?=
 =?us-ascii?Q?WNzLBVogvf/xv4gfdBqtMXOq4DOsecjpktOOtpP3bI2Z9yWeIFCV5/eaGnsu?=
 =?us-ascii?Q?WqmobaEc5FIfJ70dIbVChA6BD29XJvt7vshaAzU0RTtOEjcjf2WVy63wKKkW?=
 =?us-ascii?Q?+rYjBUeAUvzA1z++E4n/IfmPbgqwYmzAO1/PBttcw69UeU4n/OK1m2MhkOW8?=
 =?us-ascii?Q?732/tJMRKRTuCp1epxq3Xm4IxnAH0fLg+d9IlsSi/+3bM14kAZEt7xOT/IM6?=
 =?us-ascii?Q?GRp4I8F6AlktbVh3ZJexDlMEDYhqyelFcIC6gj1Xm2H3v5gxHh0L0WIo7aeM?=
 =?us-ascii?Q?TrHeRquF1QN5/qv1wjc9+5jHnY7fW9QEsD1XqkICmosgX0q0RmJQr4V8yqzP?=
 =?us-ascii?Q?7fSPr9h+rjIVZ+NLb76HZ7Kbgra9fp8zFnPkd2Fx1G62YVGi/7ng1xAilNO1?=
 =?us-ascii?Q?lQqJcmJRs2opP3zk4FYMviX4wKKL6FQh0KyAfPAKHyDK/ons+4s1gYIDvujq?=
 =?us-ascii?Q?9acbX6MGcJ9oBqXIPvfS8BBxi5DymIzsrkMZ2Wfrv3wQWZb9KT2ovGK9CnYS?=
 =?us-ascii?Q?7Xd9ixOVAQpUgC5DYDw+kqDzlj3sFWqRMiTluq90elpAX216lVzTRXJHn8r2?=
 =?us-ascii?Q?anxOl2y0y/Pvw03SHQniNONt131n41APztWAPdPulKhvxnx8SK7HAD83yBEc?=
 =?us-ascii?Q?XYk0oIzIYWUz829XcCPRDm+ao/6M4ntFuH8hdrnYr7VWdfavmkhIQmKhS6vl?=
 =?us-ascii?Q?W4xj5RU4QauxJAHXTRLYlBriTUlMW1uiklqUGrsBsdhpmXZ+4SErd+bYyoAI?=
 =?us-ascii?Q?o0r11vquOVd4XMtt5TN8p5CcZJNwyxMYymym9YoocsS1rS0vto7FywRFrGNb?=
 =?us-ascii?Q?FgyaasaH9fA7YVQWHSczFEyU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f5d9e4-0d14-4226-ff74-08d94d117de1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 13:06:17.3480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S9U7fS8qiGwIJw+C/SnmjNzCUt0YpV/swg3Fl9VdQDZGDU8NM6iOCWC7wXXKqA+tQ8D8CXnJSMexeGvUprYHdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit modified the driver to accept the addition of VID 0
without doing anything, but deleting that VID still fails:

[   32.080780] mv88e6085 d0032004.mdio-mii:10 lan8: failed to kill vid 0081/0

Modify mv88e6xxx_port_vlan_leave() to do the same thing as the addition.

Fixes: b8b79c414eca ("net: dsa: mv88e6xxx: Fix adding vlan 0")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 061271480e8a..448dcfb0955f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2176,7 +2176,7 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	int i, err;
 
 	if (!vid)
-		return -EOPNOTSUPP;
+		return 0;
 
 	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
-- 
2.25.1

