Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C196BC0BD
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 00:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjCOXTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 19:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbjCOXTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 19:19:35 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CDE9DE03;
        Wed, 15 Mar 2023 16:19:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/yS0bDPZdiSx0/TI+BlLMh5iasG6hIX/2SJ0DdgY5A28l0fi43jFyDLt3i8/DCt+ROx5NCQBM5oIG+QKF+7ngDtLxgjPc5dlXE3jY+wM0GybTnDAaAp6BnsTeT4CpH5FCVV6qjjTlLp14Z+IOgcHukyklTr4wQaoiYOWoLQLTq5tjSGO7wXkTemBKtxrGGBtUYiOZmhyRhOXmyAXGN9kL22Nuv6FUvBOLYh/DYN1kWBrpdp9hoUhIGbGA9NR5XACeuqOqTOdjpmR9SR8NO39HZktA7Udeomc8DzLbE0CUDRpC2YwQn3CcYUB7LZiPOEdSWC/9Oa54nTXFypgPKlaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afFApOWQ6Wak5tm2EpYI5zZ3kb9KwYzYy4i/91ybvgc=;
 b=grK0gmnhqwzIBGP0S7Q/M7or/ePtF9Dl2p5dqWkDAoaexIgjCPWVc7Mk4K27a1fATfBbKG8+1bMQ9NjiUvBWdMC4g+q3nadEL83RRjgOFu+jG9bI7TtXWN9V96flFU/2U5jBuSV1udyzdwSkIbcXWu3sJ30ogJDZVR8/7NnK5N0nH7zsR4nkZpBiITEXFjk548CFAjSZpP8crbiPPw02T6AoBg+DrZF+pKH7/SzW69kwaRLaLasOD9JhuRf+LdJocMlswjt8NXGy8dQZihqN4YpcqIkQbpP6Yg362SFUFOJnR9Q4298mdMlrU3RY8kLETdWasoWmQfWc83opVqJ6Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=afFApOWQ6Wak5tm2EpYI5zZ3kb9KwYzYy4i/91ybvgc=;
 b=f5dEcQv2LfWekWpxSiOAlHGGwdJf0gj5UbxUaz7pZBRZ/7RKWr7/0WUx20pJbNL3ly+2g+o4EAn+tOPBjpZZ+Mn0ldPNBAFVOuSFYpYxYvw0cHpkuQg6cUbBDsiDGVvUxWhDKhjJ7KZASsguD/ywmNFq2VunLz6NYWH9YbEYBJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8228.eurprd04.prod.outlook.com (2603:10a6:20b:3e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Wed, 15 Mar
 2023 23:19:28 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Wed, 15 Mar 2023
 23:19:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net] net: dsa: microchip: fix RGMII delay configuration on KSZ8765/KSZ8794/KSZ8795
Date:   Thu, 16 Mar 2023 01:19:16 +0200
Message-Id: <20230315231916.2998480-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:205:2::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8228:EE_
X-MS-Office365-Filtering-Correlation-Id: 5864f415-8e5e-44d8-e534-08db25abb8e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvwUwYI38OicAmgH+nB5DluajX8q9W5VeDCMU5sQx9z/pgnYD0ifg3s6KXYag/iX2rgL7tic2RIfHc/N4Vgxi2dNVj49YcckW/ytODmQK9DXHE6GNOeOAnQPEvs1wyYcUtV7DYgnqP935lhkAMTO3XHpJOCcaSxXWYmhzB/U+TRsEz/2UEVABOsU0MR4BoE7wLkI8q6FmC0QepWvQch4EKxmofenTz+IM0JziX4g0KVFRjFFKodimQksiDqCGKQEvoi8r3/nf7CNREBuYXNDVlLuvItum7nFNEJuioP6n6UEaQdbbOT0A89SGRWerJ28Iu0TZnltqUvLLaLYYXiz3zB71vl/oEMiJFebOgVSyzs2ZlQ+QRfEjyLU/T4pBOy512vMCRWPqJVaYDbdpzUT6DyU/aGoiiJHwfqttMyyC1kgEKXO4ilLrbyxBk+uC+nOo9LnCZKDERSZG0su1kwLquKEGHnro7nXkyvltzZuDX8+hDmXFXcFoM5cSn8s8yagk15CsZLQmbqIzgbHMJFVN8pwiZCwZSOkCAvaH7uFdRLkp2207UgKKaqspehK2CHMHPNOBIf/fn4JBVn2KjHe1sO+oUaGXvBDqlBIeGiieaupEm3Q+sdDPdcqDTHI57M3JUOaNRJCr3BWdzRa/yqSnn+Rlt8DoTNJhmiZ1YjGjq+Gue763AkRiMS0phiZ/5f2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(38100700002)(38350700002)(86362001)(36756003)(2906002)(44832011)(41300700001)(7416002)(8936002)(5660300002)(4326008)(2616005)(6512007)(6506007)(1076003)(26005)(186003)(83380400001)(6666004)(316002)(54906003)(66946007)(66556008)(66476007)(8676002)(6916009)(6486002)(966005)(478600001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vh+Q5AjDRQedt3w/zqk9KJI11uRvDsC9qmepwqj+RPoG8ME3t9IAPdNq17KX?=
 =?us-ascii?Q?M76c4WHyMsCBfQjph2m/wPHJZdMrlMgRQl2zM7mkMK6x+4uISmE3NDWb2o1n?=
 =?us-ascii?Q?96jRomTB1HdC2YriN/GAgjvUAZKaA+Df+SoG1uBdFw4jA5FmB1f2icZRnJAS?=
 =?us-ascii?Q?Gp6QUUK5AZYGZ111KKZvtDVTghqP6F6S1B+NW6qaDUDG/1gvlP/jNxGjqUxY?=
 =?us-ascii?Q?hfRq/ptBRUSCiKADkMgB+AFdGaiRvMBnQ6w9kKtzw+3G3vQxsFIhCWHaZ/Mp?=
 =?us-ascii?Q?jKKzxGd/kj81fkNcHe+oBbNgnEOr2DXqVvBJbt43t+XDbDNQUYpo/v7pL/CX?=
 =?us-ascii?Q?IAvUepLdNJkzW8OvVPHZRVtJAPxJ8XnI/MP7X2+8gvrrMFb8zJV3bYADM02O?=
 =?us-ascii?Q?42+eNYNURy8NwhJPW7NDnvMpzm6wtIzFHYUBIjjHbX7JYdWTKMC8aopmA/9S?=
 =?us-ascii?Q?7DXN+CBCxG9U8QpQIqJZW8JO15GHE87fJFhIfGTipUvbCPpKBpDVl87SfFvd?=
 =?us-ascii?Q?P/ue3OytrAXTuUfSGxUVnm+DMtU41XlH8D10TDYhc6QnF/LP5uYGUReDuYV9?=
 =?us-ascii?Q?oqcuVLeqSyvKZkbjHza31+U2SVUcFKfUH7NLltwF//uNKWAOgEPwEpOGBiM4?=
 =?us-ascii?Q?YlrTIxp/g/ystXAu2AGckHkFWhkEzDqBSSicV1LR41Ru+76pM16rpRr4odwO?=
 =?us-ascii?Q?4ynbQ4DprbtLzEl9FOG5GQhPMtdsFElnI90pVM/oQhlDqdvAT3mlmsTcvtnH?=
 =?us-ascii?Q?c8hr8yEdqvEi9FUWhTDeMU+ZMYMZyVS7QfAu740BmGCWceTs67MmwCiC2ZGw?=
 =?us-ascii?Q?VN/ZRG4w2CUNe6k1GFxRVpn2csBUf4LuOpryhgyW+3oCNM4C9uBBUB1041lB?=
 =?us-ascii?Q?PP90xHGKrpuElmMUf5f/A0PgPuWFJORDfZUIdPQNW2yyya7tooP0JMRYeKbk?=
 =?us-ascii?Q?BQyb9m1Sw9OKnRAjepMBedzJ7aykdkv3yzWDbq107qp2wYY0dRtNzRrbAWUi?=
 =?us-ascii?Q?vtfO1V+WgOJ2Zb7CLpndEu4MzuFfLZDVuTiTjLhKrLoqKc9tn3ch1iYLui40?=
 =?us-ascii?Q?C957Up+KY+MUyjlvJyQrzsjaaknFUVZFmtir1fDQI2ERuU1ATKh+QSl4yKLj?=
 =?us-ascii?Q?RulY4qYfEJ+kWlzqPdRvo4Nexb57t+tU056xrcWEkVbBElkokK3Nsgp1bN/I?=
 =?us-ascii?Q?gSw3HcP2u1xRyvmVe0pZO16/yaqxT5gL4pKgZPhKiziWFpXzMrfy9cSloehS?=
 =?us-ascii?Q?frafxWAUd5bxpSg0ilyzWPuas7kk/bD8MbPDBCWwn6whGYjPwwF4vo7gBVHf?=
 =?us-ascii?Q?17E0MY6C9jOOFtgSQTVBkJOhmuNea9Fm5OK4deL4L4bMI3C5CnPDFv41YnCl?=
 =?us-ascii?Q?yYsQjsSejAKrrpIDcPS6Mwtc7dYD69coFWtNNvv9BR/9QG4qPG4dLkc8mO9s?=
 =?us-ascii?Q?t1FXSy4obQcGAYB9W0ck8r6XZFfZvCx+h2cSjPiv1yPk+johLYq9Wu8YttkQ?=
 =?us-ascii?Q?6hmQmJLPzh5uZEaSsDBcbEeYnvfcDDoPflIbLj7b/0SVbkB6QkSt8s45Pux5?=
 =?us-ascii?Q?/quK4c/r4sfEfSlYqXru3E4p5UUhQDQZVsMNa97YmivDvpDdEE8qYmj/6u4Q?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5864f415-8e5e-44d8-e534-08db25abb8e2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 23:19:27.6757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0XTZ7NzZ0xsr5XqPtwREkncUs+C/YV2++RRd54Td8Jo6j+vtJBS7Ksqv3G1RRcR/sIdrZl4GWxPB1v8fqkyRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8228
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

The blamed commit has replaced a ksz_write8() call to address
REG_PORT_5_CTRL_6 (0x56) with a ksz_set_xmii() -> ksz_pwrite8() call to
regs[P_XMII_CTRL_1], which is also defined as 0x56 for ksz8795_regs[].

The trouble is that, when compared to ksz_write8(), ksz_pwrite8() also
adjusts the register offset with the port base address. So in reality,
ksz_pwrite8(offset=0x56) accesses register 0x56 + 0x50 = 0xa6, which in
this switch appears to be unmapped, and the RGMII delay configuration on
the CPU port does nothing.

So if the switch wasn't fine with the RGMII delay configuration done
through pin strapping and relied on Linux to apply a different one in
order to pass traffic, this is now broken.

Using the offset translation logic imposed by ksz_pwrite8(), the correct
value for regs[P_XMII_CTRL_1] should have been 0x6 on ksz8795_regs[], in
order to really end up accessing register 0x56.

Static code analysis shows that, despite there being multiple other
accesses to regs[P_XMII_CTRL_1] in this driver, the only code path that
is applicable to ksz8795_regs[] and ksz8_dev_ops is ksz_set_xmii().
Therefore, the problem is isolated to RGMII delays.

In its current form, ksz8795_regs[] contains the same value for
P_XMII_CTRL_0 and for P_XMII_CTRL_1, and this raises valid suspicions
that writes made by the driver to regs[P_XMII_CTRL_0] might overwrite
writes made to regs[P_XMII_CTRL_1] or vice versa.

Again, static analysis shows that the only accesses to P_XMII_CTRL_0
from the driver are made from code paths which are not reachable with
ksz8_dev_ops. So the accesses made by ksz_set_xmii() are safe for this
switch family.

[ vladimiroltean: rewrote commit message ]

Fixes: c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii function")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
v1->v2: rewrite commit message

v1 at:
https://patchwork.kernel.org/project/netdevbpf/patch/20230222031738.189025-1-marex@denx.de/

 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 5a7ce2aede68..50fd548c72d8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -315,7 +315,7 @@ static const u16 ksz8795_regs[] = {
 	[S_BROADCAST_CTRL]		= 0x06,
 	[S_MULTICAST_CTRL]		= 0x04,
 	[P_XMII_CTRL_0]			= 0x06,
-	[P_XMII_CTRL_1]			= 0x56,
+	[P_XMII_CTRL_1]			= 0x06,
 };
 
 static const u32 ksz8795_masks[] = {
-- 
2.34.1

