Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FB32F8ACD
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbhAPClX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:41:23 -0500
Received: from mail-eopbgr30103.outbound.protection.outlook.com ([40.107.3.103]:6278
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725601AbhAPClW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:41:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cA8hRMXzqv1rmJJ41PiDEq0HZrkJC43DAzy26k5Cz1V/kGBQ35bGfDJyxQNYaHcUSxN5DiqSoFfC/QA9KoX58uLblh9X+ZKnD1cJjyzTVNRn1rJEmBPd19YQNYD1xpIKbo1qExU46BmFDbv12+zQVPnbK+xSci/R32VH8Y1r26JnIE3MwWglazrvDs6PCnKw4CPMJoB3sKxk6XYBoCWLfD3it1R5nbZ9memBC50NvgZRo838o1z8FGBtS85kTZdySvi34s7vYdKf/9TFwhtSxm/NX/qcCFfUXuCSdVfpS4iV88sbxjw3YUfS6+KQJUfky0K1QuOF++x1m7D+03ftQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glc8duWmUvoDE7rEKyfuYLOTiPMe1wYXWVMfIlfmiyM=;
 b=nVG2nrH6gkklbA93ORF3EqG9VRv+QstTgvpIbcC9TC7zz2mB8UXHNj6dqaSJsEmKpmlu2GamL9E+T9Y7cjwyi5WBi9Ezdv5R9GVfq0Xbp86KRVEIO7vWfTldEtd1iQxDjfCM5s4yLxCxG3Yoi0vDNtGZ4q99s3oNFxsd6KgFO9FWr7nF7I4iNS0NyBrmh3RIkcmy+WMPBVvzydDtavtk1q9AKSRlQRQkImDm+O8kmlOB9ditEkOuBaP0QwLtoIYVSDzk1XXQyxbNQuT3JQOuuOk7TcHk+1xGRLUq3GKRxyo9kBOySs1UiqwZzZHfVeALGUplrp73qemxmd4NDFbJBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glc8duWmUvoDE7rEKyfuYLOTiPMe1wYXWVMfIlfmiyM=;
 b=g00ezDZA3bGDnb656YNFFbaot8GPk1jsc/KlyQWA/yvYMN0LxlYUwp7r5IlsDzoG1X8Yh89niFWTJ8Q638afGX3a5Me8FJOYc3zGbRH/LE+3XxdkaVnQVGGZNZ9ueJ9gYJQWamdwQq7gv8KwqEf6THi/i0zLu2/qEgCgESi+n2s=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Sat, 16 Jan
 2021 02:40:02 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.012; Sat, 16 Jan 2021
 02:40:02 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
Date:   Sat, 16 Jan 2021 03:39:35 +0100
Message-Id: <20210116023937.6225-2-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0025.eurprd06.prod.outlook.com
 (2603:10a6:203:68::11) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR0601CA0025.eurprd06.prod.outlook.com (2603:10a6:203:68::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Sat, 16 Jan 2021 02:40:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82457ffd-2641-41ea-9643-08d8b9c80633
X-MS-TrafficTypeDiagnostic: AM0PR10MB2674:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB2674BFCCA798C9378BC3D1A893A60@AM0PR10MB2674.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mHmXdr22hn+bGbe5sFdCHa6lR2Snvd4qWsSj3lmV3mGhwWzJ3wBRxUgJTC5qzNQ1LpzrO9KgTV2d1rN6yLN2hB7lz+CI5KJhliPXSCwwUs8sLofoRSnJapAyn/jDBtJ/yzNmgiLOMiW2YtHxcf3IteVRB9acGNi491kcZNwDSuV8BdWOnmfgzsOEWzm4ywhPA+eeRFLAj60RLY5FFQUWa5MK2KBELki5t565XwxDrZLNI27iFB1IoJulTLvHhurodB4Jy54bGX8D8MqBGWFtAzjUHR/XPtKwsp3hHYuEfZ4kXfNHIETy/sLJ398RuElpEzXIvMUQpnXF8FzAmn5n5Y80eBIoU0127l4prxy7n5dgl0z1/pUo4+NCsTYK7MZ369P7WN1KK5P4/LSEYMlSXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39830400003)(346002)(396003)(66476007)(66556008)(66946007)(6666004)(4326008)(5660300002)(36756003)(26005)(52116002)(6506007)(8976002)(956004)(478600001)(2906002)(44832011)(8936002)(6486002)(110136005)(86362001)(83380400001)(1076003)(6512007)(2616005)(16526019)(186003)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zxzR4chSl1YauXZFJXO9eCLtzcZ6xLOg01kLd51lRj03wezylCOR0PIMoFHv?=
 =?us-ascii?Q?vX3H2NGDlQsp6ZmE6H6Q5nEM16lBs8KIvSKyPk27n76Z8e1DcuMygbjpU3TS?=
 =?us-ascii?Q?UhZkrdJKh6bw4Lr7AFdJDYF8UUnyKt9zFeRzYMvZSXkJtPjeH77ArUiBVWLX?=
 =?us-ascii?Q?Bu4651qxfFdcWvgt76hcO8+iHlokpw4cz+iVvuSFDUtjDnvfaCG7r7PUKU+N?=
 =?us-ascii?Q?UYwJ1IITRPffcuxf4EIc99sFM46jKjPl/kOExc9llv0h5YlammCPrzAfgQfg?=
 =?us-ascii?Q?QrzThSK+Os1esaT86Q5mq6TJ2Db0tMM4VagWARm6ZfqyWbiyax+LZva3mQmP?=
 =?us-ascii?Q?jwnGeoPLNCSC9smE5xcm7u9aUbHxOyK8QGekmcKI13wtQNzLEI5ggcqEDmqx?=
 =?us-ascii?Q?8UxjnARaryxa0h76/uGvrpZyHMjYZ8czS1tqiOGIyPKA3/j+UVNscqgVQBXw?=
 =?us-ascii?Q?WX3fUN1r5VjFQS5nbxBgRp3ww51sC6+NOiK3ZUiS+TS0MWjC+XHbVpoP4QXc?=
 =?us-ascii?Q?5UWqS2K11xGtOGAwQ//kk4wNQb0+z+Dw8k15si6ZBa2SrBj6rVF8A33tXfIo?=
 =?us-ascii?Q?fukNh7RntJf9ozsKyexyBt12jc5LEb3/0LVTOwag+xlBTyx1p9sWy6u6/Vfb?=
 =?us-ascii?Q?G9f17rq+0nIHjS05q7kYfgCpM43LLAC6GX20GmB9nb9Phrs7tYfCmdZvwhNA?=
 =?us-ascii?Q?fkWyFP6oEbqO2ibCzU8SkYtCCi49d1VJhYgW9PhZUFOStYSbM4h6FuFBifiL?=
 =?us-ascii?Q?R7kJ5/SL0t1KQuglZGJJYlOB89IMNIxVdKFonG5AwzdnMrFcUHQgSQm92KIA?=
 =?us-ascii?Q?cZwuQteGZOdQe8aRI/aV8BSHMg2KgKJn0Cef+mDya5zS9lNE19QuiUCFT3GY?=
 =?us-ascii?Q?hrl1FsdGTv2sWy+t8pScHuX+tn3WRICjxwFZTtk39lK4Xy2WwsJBtijzYqH+?=
 =?us-ascii?Q?2kwfn/zQ90a1MpnM8lIYEzuHLgpYAyeW3jfnh3Pho288z9h07h09K4P25JPb?=
 =?us-ascii?Q?hQ0s?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 82457ffd-2641-41ea-9643-08d8b9c80633
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2021 02:40:02.3745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zL/W7/tDUtmArr/3BG43i0ZGcjgUTZQDPcw42G6X91HuN1wWR3YJNW+DncvN7lpb8XXwsSaJj89rGxbaHElrACuP6tEHz6XkvUZtoYSLu4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx_port_vlan_join checks whether the VTU already contains an
entry for the given vid (via mv88e6xxx_vtu_getnext), and if so, merely
changes the relevant .member[] element and loads the updated entry
into the VTU.

However, at least for the mv88e6250, the on-stack struct
mv88e6xxx_vtu_entry vlan never has its .state[] array explicitly
initialized, neither in mv88e6xxx_port_vlan_join() nor inside the
getnext implementation. So the new entry has random garbage for the
STU bits, breaking VLAN filtering.

When the VTU entry is initially created, those bits are all zero, and
we should make sure to keep them that way when the entry is updated.

Fixes: 92307069a96c (net: dsa: mv88e6xxx: Avoid VTU corruption on 6097)
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 66ddf67b8737..7b96396be609 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -351,6 +351,10 @@ int mv88e6250_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 		if (err)
 			return err;
 
+		err = mv88e6185_g1_stu_data_read(chip, entry);
+		if (err)
+			return err;
+
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
 		 * VTU DBNum[5:4] are located in VTU Operation 9:8
 		 */
-- 
2.23.0

