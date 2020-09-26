Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED884279B64
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgIZRbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:33 -0400
Received: from mail-eopbgr50080.outbound.protection.outlook.com ([40.107.5.80]:18948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgIZRbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7BENRrTbEnHgfzmYQO2j+pY8bjsRrEK1b7uMw+S9yuNoV7HXkvsfC5j+0cedrbjPq+pScw/QjSgQDQJcFC+PdMZXauZbRZywHDW7tMJYhkxLjKqqU4rqCloZU0S3pY72tZRSDLbkiLQqtBJ/soadZWAgNTD1clr2ilbCsaS4y4YfdRUeeG6zi3j+EQo+gxUQ+OLJPsAgMcn91p0j7Sw0worpXd3l8/G3I8wt3bedWagk1cg1kp0/IIDKxLbEGW8jqfrE1318GcorsgrIZUPsIINPGp65yMyaxux7xtJxi7W+le4gYsDMNA2M706j67Zf8IzoIHgTLn72gXGr/cSbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RIcxaxmFJdBGAMiaDyTTjJVY6fc+FBB4x/rbbjqpFU=;
 b=GmxryNasaa08g0nHJETzVXFnD2xS/XiSFWoGOksKIn2JxdXB6TW024z3HvSd76tEvswGILRwPENfwUV75coIVL1CC2/gjiWk4AHxdodgwVICBEHwi3JFR4xZByDfkHbBfuEZAWA4zD9LQHk+LRmWe4sn/nf7t7UCDLq/D4iOQbcYW/oSm/iUlWuNpngYRH3UBWXmX4fOcU2bARUyvOmKZA4xxLSeWfaeZCRKiZFSzGNPVZqydU8vYoMI865r9QHXrjGHsQKTzLgqIVK4XgmsF7i54ZjV7u7cPEg+ahKctKGNochOrmq1YDkk1l26rnpUqr6u/c6UGa3yVmEy30bSAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0RIcxaxmFJdBGAMiaDyTTjJVY6fc+FBB4x/rbbjqpFU=;
 b=YkYkzZJB4s/6jMDMgqr7xm4GjHL9uHHV2akzif/cPRgPCTZ2WI8ceZCZzM3kpIhRDWbsGfykOWq7Ixi9CKFJtko0iRk2aPmjiNRU5zFI8S1kHz39gJX8J7gCan5KO9n/TZHCUvkL7KuUqrkFuxxrNkOU9OKTsf0VhMA7jglS2gM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 07/16] net: dsa: tag_ar8331: use generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:30:59 +0300
Message-Id: <20200926173108.1230014-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:26 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e18c5be-9272-4af6-defa-08d86241ff60
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4813BEECBFF6525DA528A958E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 13/xM1ilsRSgTjme3Sit6PC/x9O4JlK19klLI/KcYei9FL2SpTaH1at0woA9lh5mUy5wEFlEg32lQHlIsWCHUbz6ExMM/gmB0OnJRnHoHYG1eqrplXPt8XSiSTrzVoBMD+LeWcl+CV+KxlGHkgDkbNJH5xpZnqRj/QMJ72HZsiWeu28Amhxam1Dj9kP7t7ecoT8rpK9S4kMANXoWnvXQZf4SWKGJ4M3m04DYJ9T6xbz4pRQ9pjuiWOCVAZBh36TH25URNdPWGLRS6of5H0y5QCYLwxb3heLVtlsUXQi8p0rsTb1crpTym9YU6pQrBe+BTM6oESNNSVF9ah0oz1yVIlSOLsx5ySq5+kW4dhDgXiZ7hUeyIS2qJwWaOsEWJhlrrpI+GQ0pUgmSulYHkHegNAaQYF6XSxizhBupaIuzoVGEpBbeesICq5vC53iK7et6HqTbUkUhXPcy0gQwmmm7EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(4744005)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zK7/xIKea5jW+JYl7tUBM8oGUZ5FgBHsnFDvwQSplXTNWZHsd9Fi8S08eG4yG1JCsMYA5QW7YDXCIorvkojXXrOyUAPm/mpQbD40W0lGrcW/hJPeUilzJivMK1sHHxoT6YNqPYWWYTiFA1n08+/wGy/44ClLC+IZHnuznj3EiMbaiENydsgW77GYp1e6k9CP23rgxjHgUHAhUaaeejtpB318uMw23i8FiwtvlRHykEhFfgxSktDEU0t2RSwfPAw1dDCIgW6cWhQ5OS6j59M3kHpUySKVMLZi/JS61RusVPnJXWJjzESYAZtOA0x2qwkT1oPcbMZD+ggh2hPCGTAkZtDd8hOFN67vzotDXRU0hbd1SVnWxXeqwH6we+uXB0R9EJuxqxs53AIxc3uSNF79qwVyNvqM2rJY+AY3HiVcyas3aDb4EfSup0M4acpJEf7xLZ+1lN1WUsjrvKIcYV8dRu4IExxtJ5KEwdOSN3RRGZeXVeaI7J08IyVeFUiRxZndm/KHsrbQ9cHYWwV3vRcSmbnhzCFW5vHgEpFxVJl/vFPEQ38JnKjGZAYhwnWrkmS3J0X3a+w1pUOACbgCYlJVPEQbIBDQhKDOLLzB5bCgKoV4YVa3zB24QIbLyZDRk4B8/C+Wd5ZFup1835+42LVphg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e18c5be-9272-4af6-defa-08d86241ff60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:27.3008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlsGICYq0oVrWaS3qpZ3JOjpS6KDjs81+MiXHFuZzpHDmUO2ob0LHz39kejhExeDFAvfzLC6YJVAIIwzTRYaBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch inside these Atheros chips seems to place the DSA tag before
the Ethernet destination MAC address, so it can use the generic flow
dissector procedure which accounts for a header displacement equal with
the tag length.

Cc: Oleksij Rempel <linux@rempel-privat.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ar9331.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 55b00694cdba..5a7e13e36aa7 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -89,6 +89,7 @@ static const struct dsa_device_ops ar9331_netdev_ops = {
 	.xmit	= ar9331_tag_xmit,
 	.rcv	= ar9331_tag_rcv,
 	.overhead = AR9331_HDR_LEN,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 };
 
 MODULE_LICENSE("GPL v2");
-- 
2.25.1

