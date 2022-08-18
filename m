Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE035984EA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbiHRNyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245394AbiHRNyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:54:11 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaf::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E5027CCB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKQxl3g3FO4m2tlqhILH1Y404xLskii8I9wfHOX8KChnMWbarxWZPKKKjZXpS4hHSpscBAb7fjZV5y7gWs/O4sCgjNSN/5H1pdcbecvuWl/w1LYa2gjYiRIwr3QHKZ/yjlscLMKrAnHA4Ip9kRzMkCwh9xJybZNTwo9JXir2jND8Oxy5hMFXpgBHuG9vZG5TdKSOAvWOOKZT36I7tmF0ZdYondGBWCr8cAWugja38Y9p1pKLqlUe5FZ1NAehQnS3Yk+QaO+Jo5WbHFOceHKy1A87Is0c08OTU8n1lFlW4v+jFXCMsa/4mykTzsrc2zT+/hR2UdC6TJPl3ruQvHIGQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ahHw/7BpTp01z2qSASLDN6dxBdBFV0TEZ4Yt+G4Uqo=;
 b=bjfYAYazbtjnCj49A4E0SV1KfNN/wtO5j0818GEIKNWCDZuhrZNw9eWM5DPwgbcNeH/vy5UPXw9qItytqPwUhd4DiDNm99rCVQ2RnBL8xGZiH+2+muDp+tjJ4oQlp4w7Pq5+GRSK+sdxNPD037adK5HsRGL9YlD0xpu+iMVHuJVWwQuWlYMbrjqdmnufvtRzrxDfzaaI55+Ur5JYWluo7QibxsKT+/mLS8vOb2iFNCmdqI3jgvRet9wAlcjSCHyI0DjS3B4NMXkNFoNQUFKpVEzSOnTBH5/GFEGPSvNefq8taG6rFJ8OEVScZSXz3mj+sGGLMs0LSZcjbOFZOM3JTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ahHw/7BpTp01z2qSASLDN6dxBdBFV0TEZ4Yt+G4Uqo=;
 b=G4YJbiADEoKi+Hbg8+I9QDhIJvHmZIaTKmeE0j/ezyX0EW963O1bHlZ6dKJvf4i2kiwD0ctE3MeHmoNK/dN39gY33fk/succsTNnKI9gvNoxr/zjt352I1XgUgMsJtzteRf2KxynBxdCtMXt0pNrzNaj2BW2rL8mO3l8pS2Uqkk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6088.eurprd04.prod.outlook.com (2603:10a6:20b:b6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 13:53:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 13:53:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v2 net-next 2/9] net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
Date:   Thu, 18 Aug 2022 16:52:49 +0300
Message-Id: <20220818135256.2763602-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM9P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 597e9a30-69be-4bc8-746c-08da8120fd8a
X-MS-TrafficTypeDiagnostic: AM6PR04MB6088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1VYWxhLEYc3BBZRBOB21X7wxd03HDtpO4zVpMCZ+cU8THT3iX5msHaY4XcrTuU7Z/u3PiG1MJQbPZ5OLFP2MxsJvP9BLLiMUYSD63x0GujMXouO42xWgUA+TSMEn8rbrwnyHBoQ4PZM+btXisE+zss/CNRGgSwM7tW2EXzuDubp0mt5CwoVjrmNGDd2qt9JAFMn4Fc9fFdTABqaQy4gTh6yBsR5k1+wld8JO1UIhuvzVbhOiZGyMka3bc4MyZVtoNSZjoDXWFbRmKrOiiIlHoskehOS8iKnl5I4llQmqnaHQ5xkScOAjdL38RwfccLWdB9b2PRxb5E23NVAoQu7Kv/orjQ0Ut7rcAfW3ey6IKhw+ZVpcOsqPz4TWISPhxh8eWs4uSkU81S+wMjw84opzu0OcB48/RT6ctJvAP30MXTK4RaGRfb6bLdvSb9EqlNCf0arGywj5uTf4+9vGqg0P1slVS0eUxvdrQM7E44IxGQ9Jc35s1/WztLt3U31K3uBfGnV6/avrFrxS8cTrhiE9uQce9wYS01W0usEZzl+GQjR6ki4qSd18WcIDFDKKhyTjFGkwkCbsnkLnXVSyF496RS9xdiHn2Dmj8PfJM+OuC0UPlOna0TufiUGzSxhAm6+VeRXcF6/NLjIMcX66tKspT1IyPoBBqeIsBanCiEOd45K9+3fMyl44F/IITl5kHtrL7ZTwL5Iqwk/VhFpl9KgEE5EZEBW3koqJjMEQpUDj1mivxK07Ht7A02BTInyjwDitnuhtLH9kN3Umq/Erm1YMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(66476007)(5660300002)(6916009)(4326008)(54906003)(66556008)(316002)(2906002)(44832011)(8936002)(38100700002)(66946007)(8676002)(38350700002)(7416002)(36756003)(478600001)(6506007)(52116002)(6666004)(83380400001)(6486002)(26005)(186003)(2616005)(6512007)(41300700001)(1076003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4593itcASVkLHg7uL5S6L9CjyUXgkZikV5KijY+LJHncgIjb3bMexFmtVclZ?=
 =?us-ascii?Q?TIdQ+dy/R+ATu9aYDMXgN+4aMUc27aPHahPnWvCLvFQJpr11lkKFstct1oum?=
 =?us-ascii?Q?zGg1kPy2n5k5AYshpEvlnC841USDg7oHarnXAq++H5Q8zaDA5qJ/h0TSW1rZ?=
 =?us-ascii?Q?4S2bPcWlcWVMvQmi2gCkj/mFo8hemzLzhm/Vc+wfnl4zEy8NsQ+vQCW0O9Qp?=
 =?us-ascii?Q?2JdmcMR1qrKcHBcxWGLDnNlr8OD7SLc7I4u1/YzLbhlOnOD4L+KbIxMR3vga?=
 =?us-ascii?Q?8FoxDcWZbRkeI0piMWWdZoIgrQPGRHbhD5/djAPSME3ZQJTBF5nF25lqnWiy?=
 =?us-ascii?Q?y1vkIjhSla+YA8Stfu1U0f/qDqs6m0uzyWyQLFsIipPgR1E6BNSTyI4zUiv8?=
 =?us-ascii?Q?Yt7Yt1Qtwtz2C8sjxdMXQiakf6DO1guPFFbGSMarph2WPJGpYeerwIjV1oqy?=
 =?us-ascii?Q?VApPYauzKZyezGeryfXIEmjjCXG+btpi9sF94lIn5B5M174eeRuHD4zTSds4?=
 =?us-ascii?Q?Z6cpAE40WyCrPrs7ya6OZ7xTp9D1QP1//NCev48ZC7LgtpxX1MLNiCBx7QrK?=
 =?us-ascii?Q?nRyCCS2V9R56aGLBd/yJUtNjuVba365haumpOcbaE4xoawscscnelBr6xoCt?=
 =?us-ascii?Q?9Co60+u5ZvlGI06Vy/5XzdMM18ETEyL2ssHJ9NMJnOKstZyew0kq1ozGcUWN?=
 =?us-ascii?Q?jvxBWvS2jZY55HmzP4elD4EhsET9nbNkRdIEviWEpxrLcaNHwAddwiaK5mJ1?=
 =?us-ascii?Q?C4MeZTepJZcDLFzaflwEdfKi2HU4hTaDVyGcj6bitXnHQJ88DoOcCiXuVLQV?=
 =?us-ascii?Q?j7VMnoY3URR4/zGdXVM8l5YxEY4d1ErIPVs+g4J6b9oAMfIbk4gJJNTEUSBs?=
 =?us-ascii?Q?su7jryAi5PCsXWmKQqOTdNrIvILQ3zWxvfIOrSGTRYP9+4BzhxxwuJH8FTAh?=
 =?us-ascii?Q?32GB1xC5AYAC6YWSt7jCBpzc4tPkg3RWKH/9c1EzZe3w1BXVORWNu8vgi8Gd?=
 =?us-ascii?Q?eFE6IAv2Afq6JMv9FCTW6tuIX2+yKY1mgWRrkLeeoWOVC41+ki62d9RNduxG?=
 =?us-ascii?Q?GV51OQU9PuwfO8YE7w2sj8F5zQ+sGdoT62h3ubd+PF4riudWXZRbTtaP9f2Z?=
 =?us-ascii?Q?2mlRPup0k3iKgppUTkY24osJr1pW6fPrZgsT/Yi8Zv/VLsAW6Ir6pq2He6Nv?=
 =?us-ascii?Q?XIuQfZBNpyrb53EBJ3PLLZ8y0kMd6kMwi7njPtDj4ERdNjsgklj1zj+I7zJG?=
 =?us-ascii?Q?NsTypQc+4J+y17S0wWhEJDRv/YpI980NAyubceMKkwcAfnXfBFV6bSpaPZdP?=
 =?us-ascii?Q?Q7yjvR2Mo57rcRX/Qg8cPFxXMDobSkicHhgyz5hSOhdibth0o8I7eGRkU0uN?=
 =?us-ascii?Q?oCpohRXHTIDTbMYqWAbgEYP6G8f7xRXnmPXlL6jq24f1JlfGrVhBHiEMLpKU?=
 =?us-ascii?Q?TFUelX0zYVAEjnbRmOvMYBzkA86JuES9d1v8xPvzy4xkXcbEDtjDmzwmaNVO?=
 =?us-ascii?Q?tk8Gf+rEqqxXceGxQ9Gb+Cl9YN6lgHFrSuK6EtT+gR6NeqBOAYAeagqnQ9kA?=
 =?us-ascii?Q?fqNHP4yl73IC0BEqdRw22Agd6/yVL+t7pQjwhJT8xmD/GVkjFFPFB7J/D83z?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597e9a30-69be-4bc8-746c-08da8120fd8a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 13:53:12.0554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jsay+KRYMJVw/hEkmnaHJF6qc2cky3/PQYMwr+Xo/uiTvEv0nbjp9TDKTRMCKKi1owK51iMxZHF4A5mFJTocYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6088
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa_slave_prechangeupper_sanity_check() is supposed to enforce some
adjacency restrictions, and calls ds->ops->port_prechangeupper if the
driver implements it.

We convert the error code from the port_prechangeupper() call to a
notifier code, and 0 is converted to NOTIFY_OK, but the caller of
dsa_slave_prechangeupper_sanity_check() stops at any notifier code
different from NOTIFY_DONE.

Avoid this by converting back the notifier code to an error code, so
that both NOTIFY_OK and NOTIFY_DONE will be seen as 0. This allows more
parallel sanity check functions to be added.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v2: none

 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 2f0400a696fc..008bbe1c0285 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2710,7 +2710,7 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		int err;
 
 		err = dsa_slave_prechangeupper_sanity_check(dev, info);
-		if (err != NOTIFY_DONE)
+		if (notifier_to_errno(err))
 			return err;
 
 		err = dsa_slave_prechangeupper(dev, ptr);
-- 
2.34.1

