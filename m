Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4282FA86C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407147AbhARSND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:13:03 -0500
Received: from mail-eopbgr00138.outbound.protection.outlook.com ([40.107.0.138]:27055
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2407103AbhARRdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:33:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT7oeHmOZ6dXha8Mj4e3p8tTqMkt1jdXWVgzcPbeuJe3gIFFwZlFaPdQ7pwjc7D+myFymhrSOrkX9RQt1QC0PcJ54SFj3iv1jUOCeyGJ/iic5bS12NY57zb6m0bmuqEEezGI2i2QLHJLtHyMOzmx8Sr27X+yI3xkUqX3VQ6jekCpLgfqPEg00iF5+g5IBkgUnbflY4YX6v3o37+dKo8wtiM5wdFgRus3FdN/aBV20GV1dPurMs+Oe2/wVzNM8ldeglrAqvQGoIWMDZ4yaDyVIv4/j+HiD99E9O14x+7xIM++QS39aGP8i7dOBWR811glYYeCgQay+Td3vOV9vCSluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ae06GyZMyjQjDMRcniFJjBT7PgJmaXTE7fYEuXVcS04=;
 b=G2f4D3RYFxUEdjaYYmAqFvdd7pJjpLqJtlhUyq4Ra/iZ06j55iXDkHOEZ3geni8SAM9+78dKkIi2GZt05FCkt61zZOl1sMPqJAzQu+5wSWrFgWCVtBwdnNUtlI9ctDnDIJzlqeeXQ6SpH2+x+wgwfQv7rCEnIDx6jm3w8ziTepy+tZ9Fs4lz/VJoIWrw91bJ/tppVNx8ONXCn5IF/OpmDxvqOk5Q0/5/T6raxcfDnBbXFDZ4EEz+LCQyuzyJ7AtYQQOVmzI8Lqui3oUGTLc1PDjwBdYlmcnr6X63N/FLS3xx9KeDmYPd3+f2X8YaH0yV3VnXHCQwEwhlMDtDvKiXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ae06GyZMyjQjDMRcniFJjBT7PgJmaXTE7fYEuXVcS04=;
 b=uTnPeNLYhAJWKEN4yhvF6zk+HM+pXPiP7L0teOqwi3RfAv759ESzB0JDxmreOV80rCniK+QDnD/PeAO2xys9KMkDAoatoDwqaDYOYKm5cn3sETLPdJhTnWeGD7ljAWf8jW0cpW4kaF87XNRekj/mR6QGV7rw7wbQwS1/x0WvQzo=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0059.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ce::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.11; Mon, 18 Jan 2021 17:32:55 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%4]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:32:55 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.com>
Subject: [PATCH net] net: core: devlink: use right genl user_ptr when handling port param get/set
Date:   Mon, 18 Jan 2021 19:32:30 +0200
Message-Id: <20210118173230.5981-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: BE0P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::14) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.4 via Frontend Transport; Mon, 18 Jan 2021 17:32:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f54ecc1d-4963-46c0-a264-08d8bbd716d4
X-MS-TrafficTypeDiagnostic: HE1P190MB0059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00599AE020316CDDBE641C3395A40@HE1P190MB0059.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: au22ClIRMhGgUtDtEiDufi6uTUTwjpdgePXVpwwG2xnK+hvkkWJdNO82YwDM4XitLB2dNNRlKtY9RRuc8Hwl2JvqMvyZV0AwmYMz/MgKTx0AmZi54toJZHHNbrb+rPQ91EJKrUqZgxIC6okoN4+H21hXGglfZLM5iNZ6eqToqOEeCtyKWj6/X6X2IdZImH3G8Hu06PEFg1D8HmBp0hFdMGgsSn6CEu0YAzC9ke9NXC9OG2DsQmt8irlq0uZVye9IgdexsG5/8mFyYkfo9QtZApaw3fzPOcR3gdeQFRaX7MDKlc2VV8rxzuVhAztfyCpEwZqrNo2Kx1SxLQVRENygdlsJ7YA0zqDAQWHtTI8sxtjLx1Qkjb5upsZMYM6Bpr/Rdy1Njp1kGJldbMUMfnLlcmuTz4uuZIHv3lTghPIHD8wFVhqta8sZw3sOVRU7+jgheAGVjIQ1VYzMQ/1YrK+7R8hSZqHjDrD6Mvv5eqBHyYPd9SRZFk/UDr1pc/hLBtEbrJU91efBRBTwqFTmgyUFHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(346002)(396003)(136003)(83380400001)(36756003)(86362001)(110136005)(66946007)(6666004)(1076003)(66476007)(6512007)(5660300002)(44832011)(4326008)(478600001)(66556008)(6486002)(8676002)(956004)(6506007)(8936002)(2616005)(2906002)(52116002)(186003)(316002)(54906003)(16526019)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kWGw9aEkSxMFvcxcZ71tUE/gjn8DArgaHxqURStaooPx05W9xWFSyDEmPCe1?=
 =?us-ascii?Q?xs1JuFNdq0fr76sOfcuZtKN3hMsNGPoWGBr4ACM2eFd/dS3FSr2O8N7E2CZj?=
 =?us-ascii?Q?92yxRJcvR8EB0RSpWYS5sRm1+AJpgKkp8N2xuhFQcEhGrkKPiEylVhrxNLbj?=
 =?us-ascii?Q?REt7J3BHGy/eu8tws/sqy1ITOoD7xNyNtSiYu6YvP3ABFre5vKtCWJukDpkF?=
 =?us-ascii?Q?aisg9G4/7aL4VkTrX9qCPiLfg5xhL2WwXaXJRXF5j4Bi2Esgk2BickvVyNIk?=
 =?us-ascii?Q?QoJ09RnYzdcv50G5TI0biVmPqRj4qaZMWtV1bUFuHaCPnjWb/tn3AiuItO5u?=
 =?us-ascii?Q?z1/BLr4P+wQyoAubywDJt5sRqKy220LDQ8aE1UgdoNjl12z/w032NrRXpCUl?=
 =?us-ascii?Q?j3o+cvnFDbrqKDH/02mO17xZaL73rav+r9gytuXCPLHrMizK3ZhEmPr1DyEm?=
 =?us-ascii?Q?25mmy8kzv2EQptFMD4zHejb3FW+6lbhl7SPI6KMPl8IgzWXe9NZJwsmaqbyc?=
 =?us-ascii?Q?M4FwswsSttIEBwq/cYtoSHBl7kJLuM1ExbSUCT/OKrESCsORPvf1ReLHISSh?=
 =?us-ascii?Q?hTqcGm1zKbrzYGEfX3AK+SG6ifXacZAh9LujG7sYhlnqeRxfTDBVeTVbKev+?=
 =?us-ascii?Q?uua+iOXJM9B4gwT5XMxz5aAvkwzsaLZ0ko2LtlNlQ3ikzqntqjpwwjqF/xbQ?=
 =?us-ascii?Q?HZNAOvnDEHHdrPvIuoCXrMaXNABMGycEf/e3/wUa9rFhHJAfro1HLnGkYqYS?=
 =?us-ascii?Q?UP12FpS7g3Go0/4aiq2o8Y2870GZUxf2G3h0Syqzfk4kR6/T2EyEWMQCRSOA?=
 =?us-ascii?Q?QAeDhHx72V4SHPB1p0vsk2dJ3dGFOpXUXjETCzLeBpxjsf5zeYtjQAjPFppj?=
 =?us-ascii?Q?kim5mYmzqHy5jXY8l5Sg9aIrH8tj1aW45JJwtHvpJJKUncg7BGzdLb5CwhdH?=
 =?us-ascii?Q?pF6a7pab2I/YvvA71VQy20GLhU2bQwIkgUSAmufi8RtWNVkRYh3f5HJEJC44?=
 =?us-ascii?Q?HWq1?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: f54ecc1d-4963-46c0-a264-08d8bbd716d4
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 17:32:54.9960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6YWovrJxb8nrZQSaPJrWxAyMbSC/Ohp4sGMxYCV8TYUbhyO3X+WZQDeyM4h/q4s1zIppTpnXFupQruG6Zs6ibzqP6CSMuDGJQ5W5svgurA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

Fix incorrect user_ptr dereferencing when handling port param get/set:

    idx [0] stores the 'struct devlink' pointer;
    idx [1] stores the 'struct devlink_port' pointer;

Fixes: f4601dee25d5 ("devlink: Add port param get command")
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index ee828e4b1007..738d4344d679 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4146,7 +4146,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink_param_item *param_item;
 	struct sk_buff *msg;
 	int err;
@@ -4175,7 +4175,7 @@ static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 
 	return __devlink_nl_cmd_param_set_doit(devlink_port->devlink,
 					       devlink_port->index,
-- 
2.17.1

