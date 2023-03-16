Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968896BD4D2
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjCPQNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCPQNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:13:23 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F36554C8F;
        Thu, 16 Mar 2023 09:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmWLC7VTtVhWmx+n7OCMMyOaJcKsMY3SUqn418+mHtt431xUTOSQV6C5DXPcCtxS1TL9Gi/Jh4rMj/bqbGyx8Oht/yAAS+VIDX20BXLhUoWsqPN4lMkH/pVBMPRKQfits96KnB99ssxnC2BLWSCjOBbDGAAnb4t8BnlAHUhdTUtNvbx/QVE7IBg744FI51gnR7dim4Igj2I7hfuBhkN4dS14Drtullxm9gaNdCxWj6JE81bhrvicZR3BJlnBQO1lIfhbt2fOf2JnbmRWoI9/NNlWrxlxmuie8wYJeQlEUT/DFo4u6t0xUJgvLrIoy0RtzrQSrtXwmiPiY0wX8XTjeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1Tt79ddnPUjDV0vF8kKpl99TT/iZ8+NPAry1JnJq1k=;
 b=EnAjs6T/zn6bqr1dGFufp8rvLZC/80B4NsNLYX7T3B1+gh7x56ALUgM2mzjHLZ//T/zlRC6S9QgZvHPtKYs3zN9STGJML6kqik2yum4ydGg7e2Vad2KJNMPAvzlhlkmiM9vnxxobRv+4dcnL+QhqghpYJkwNDOVy10orUHoLA+alxQaXgCtkwa7KmfE/8monjmyQ7GO+zyHAngpgAHGFGLt5Gbi3qblSl23+1Rrir2b0yEnp+q+QyoQhALVPfU95QuxUSFP6oREsrvHfi7iHjQ6TQ18WgqgHuWrJ6EutjINUD83f3SSeNw8KwMNsRfdcJpLguZNhc/dJHWYC2Nv6Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1Tt79ddnPUjDV0vF8kKpl99TT/iZ8+NPAry1JnJq1k=;
 b=FZfH07EqpnNkcYcNPGf/ifzVCFckzIkQ5ax/+eWWmNQC3FeQdC/6xnphXxUkQ1gn3PuCpXBq5l2UclY4fUJCXindBLayfYI4pu6hF+x6TsPyRylWLGLrQdRSOtBTLeU0Pedddy/OwvPtYymGuo2etSOguV88/GvysHoIX/uGUAU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 16:13:10 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:13:10 +0000
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
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial conversion to regfields API for KSZ8795 (WIP)
Date:   Thu, 16 Mar 2023 18:12:48 +0200
Message-Id: <20230316161250.3286055-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: 325373b8-6662-4884-e436-08db26395648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ObWJy2OJg8Z0Rzp4sH7WcNnizjbbS15lOn6g/fz/L9gUKkQdZtN25lhvcgfsTYcZfC+19y8jXqtA0OKYF66v4UfPRR4wZ2fXPqytUGui2eBL2qwITj4OsbQRi9+84XlcWFsXqn5vhP3lhHv1God11ZSBbpfaBvzUrxsfKD+Su1a0MBuB4D9GFGHBkUF2d+GgGmvZSd5yoXXWXS244I39KbW8zoesKtk9ePeHoaWmNZJNb8CcVhGDZmimZjZIgWVkF3xaPl9BdsUQjeBywD/7V0vcCupLHHfgMUHC+YP18KNDCd9PDpC/Js89xyNgHVk+QuAnUu2kLI5mjTEHOpdkmXSWKKBAThAl2J2MatWzjrnsX2+ArI1RXq+1HkSLYjagmL+L6QCyyTb8WidFvUp3PjmVMrV68pVKMmoa4TOuH2UXBfpXQEUhcxL4tJvXIF5jhDKEvN43BU4mr+HYMUk2eBvjkudJsMmtVMucifQyF29FSxrZfRI7mn9D8QqgJfek/gJmcDuZHiwBPnySYwqrjIboaRrDQRuqSFjONbLHhABHmbzJdMcZgQGVfSr06IGGkgEcLjZtQdK4NRdLNgAp0RWHS5rskBul0SJYlWyobbd3LQ4/shIZTU5sjsbyjKXuqgyCmq10zigzVfkWKFWFVCZ0NzOxdtnOCxcN045WlEJa3cLr7i1m2lWP8uSvA4Ws/xetf7mtQlEIko5fwdQI0vmL5OGGQYIViH2fksFOLtysa/ufX3uaNIGMwSFl6sJVuoR72kbJKY3xEJgFYqXA7DnoXPmIyN+4fVSmngmJSj8vfMu6k+8SRtRP4JJWRnjx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(36756003)(86362001)(38350700002)(38100700002)(2906002)(5660300002)(41300700001)(8936002)(30864003)(44832011)(7416002)(4326008)(6512007)(66476007)(1076003)(6506007)(26005)(186003)(2616005)(6666004)(83380400001)(316002)(54906003)(6916009)(8676002)(66946007)(6486002)(966005)(52116002)(478600001)(66556008)(309714004)(414714003)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0ESkDrTeT5HYZrGdi1azZAbZSio3ucdk3oK1KV/XKql5Iu2LVZTbsCk3vbYr?=
 =?us-ascii?Q?prM1HziB/AfaZj3KytMdCQuMpl6BkgP9Zj/Unq6jUkOrmiszcDaHWpa5m4yd?=
 =?us-ascii?Q?XDPQDeGkfpeX3MFHSJy5WuNpUxn8atUc70+V6mpFltGqqHNoGLrqwu9IkVFh?=
 =?us-ascii?Q?k8TBkqJZgGdM24kmONpaGx4+C00MFRplWK0PssYXI8BGmkO38jfZyoJVCdVs?=
 =?us-ascii?Q?CVgLfiBnnTEGLdOc1s5cFA2VmS4l/dwieWsFMfksNcfp4Jvl/brlbPQi8nRo?=
 =?us-ascii?Q?CgsP88UhP4mRliseGdBRPGdRvnRvL2Z2q9no0G84OGgb1TLdoqdnm43m9J+G?=
 =?us-ascii?Q?Q/b5lX6Rvnz5lTulcFL90a+CMtIuvmMg3EspPsdz0QH7+yDFOqLJyjxf6OSH?=
 =?us-ascii?Q?GyCRqY8U09KB4MuiR1kINsPj+YXASLxpVhFQgfZUftelN9yHYG0YQ4VU0Yof?=
 =?us-ascii?Q?wvaTqhKo+NqIcJY7oUBzUSwdyz9ueBLS4GWPRZWJo3hMLwjSYFk2BuGNzy7S?=
 =?us-ascii?Q?LV9IW7t8GHkUbcH3saK5G3e7HUG3n3hZnGgzHg7RGGFewd9cImM6q91h5yvU?=
 =?us-ascii?Q?Bey1O/n8xvfyiTmH5nyXDTBIvi9tuSFEzoZLM4ZLbjfIQgno4Uznp2pIvDbK?=
 =?us-ascii?Q?bim+WlZbLMWxfGCRpQxuLBmZG9isuXFQnyAQWqv9zzmx+HZ/3zJ+vmFIcFan?=
 =?us-ascii?Q?yb1oripaXU2ZxL49U5/nFW4UifokfIFYJcgPT+Y1yVRfGdO211XttHtdMUhx?=
 =?us-ascii?Q?P9iy2yLy7HLJQnytxGcCN7M4fdhDq/pDq/5VNMqhAj2fTTWlSpcUmcrD7wna?=
 =?us-ascii?Q?3+qZhOaTrSzC7Oizz/dY3soMGK9kdQK2Qn+MA3vdrtSLxXMj0TyxKhUL0P1d?=
 =?us-ascii?Q?ebHhkgltAI8m/3KLF+BD6AYwUXPZGLzFCm5LruvwDf5w6/gGt6fizVFNuwCr?=
 =?us-ascii?Q?OqpC6b/ieWIz32ut0DtVP7whOrgoVCIQUpwqFytxImPu3eVz5CtCiL7lFWrO?=
 =?us-ascii?Q?xnIFmz4Yr2hPIlD4iRzClEcaFC9GRQHra5AxAJdruMzORFsHlT12LGoJP/pm?=
 =?us-ascii?Q?1I2Ei3rmOEZYFuTwjzgATh824C2UhGnxPeBVZooSnqzHDGYWR5QvG9do6s38?=
 =?us-ascii?Q?qowdfgsldj0mLoriB5yA0UzikWD6K7cs6aukEndm21zurcMJNSMbNMFyFOEe?=
 =?us-ascii?Q?k1jt7YEgz6M+EzoxkoE7+GpWAGiXzdTOUIUS7tvvBUQ8T5YXsFpPpwINv6/b?=
 =?us-ascii?Q?5mZpIlcvHIMV4opW4D6LpopF/4z+50IlbjeiIXPnOfUwWRKNBmg/pCYwn0dG?=
 =?us-ascii?Q?ReRaEM4Ptu9B731LFRDGAISZKZLhLaGqxABrypqrNx6TretEMUlHZdK/j/Hf?=
 =?us-ascii?Q?MvakGkD70Cxh4sgyksPbjnl2iSUiEg1DZ9y4N/L8M+swik6aA9j1WWUdIt3C?=
 =?us-ascii?Q?+MrhIU+xVw8fImVAo0xzjOHJaIfXNquQaUjiOf16SWZYJhtm0x0rweZ8rUdn?=
 =?us-ascii?Q?TGALJ4yDfDbpg/XC+Xlw+9DtKMvH1pLInwGrAzO9Lfu67y7ml58mAQ9X2ng+?=
 =?us-ascii?Q?grs8gzuWJKJwVs2Uzq+GfIj4P/bOcCxDF7c8xn830OJU5Xfkhv/uKrSYTU3u?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325373b8-6662-4884-e436-08db26395648
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:13:10.8165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bODBG3J42wEW/gj3M0YMsNIJefZnWTzWpSKr7Fdxelz+7Q9yUVh3TwVGW8R0fFTVheyGFyyFHVtyspTrDavW/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During review, Russell King has pointed out that the current way in
which the KSZ common driver performs register access is error-prone.

Based on the KSZ9477 software model where we have the XMII Port Control
0 Register (at offset 0xN300) and XMII Port Control 1 Register
(at offset 0xN301), this driver also holds P_XMII_CTRL_0 and P_XMII_CTRL_1.

However, on some switches, fields accessed through P_XMII_CTRL_0 (for
example P_MII_100MBIT_M or P_MII_DUPLEX_M) and fields accessed through
P_XMII_CTRL_1 (for example P_MII_SEL_M) may end up accessing the same
hardware register. Or at least, that was certainly the impression after
commit
https://patchwork.kernel.org/project/netdevbpf/patch/20230315231916.2998480-1-vladimir.oltean@nxp.com/
(sorry, can't reference the sha1sum of an unmerged commit), because for
ksz8795_regs[], P_XMII_CTRL_0 and P_XMII_CTRL_1 now have the same value.

But the reality is far more interesting. Opening a KSZ8795 datasheet, I
see that out of the register fields accessed via P_XMII_CTRL_0:
- what the driver names P_MII_SEL_M *is* actually "GMII/MII Mode Select"
  (bit 2) of the Port 5 Interface Control 6, address 0x56 (all good here)
- what the driver names P_MII_100MBIT_M is actually "Switch SW5-MII/RMII
  Speed" (bit 4) of the Global Control 4 register, address 0x06.

That is a huge problem, because the driver cannot access this register
for KSZ8795 in its current form, even if that register exists. This
creates an even stronger motivation to try to do something to normalize
the way in which this driver abstracts away register field movement from
one switch family to another.

As I had proposed in that thread, reg_fields from regmap propose to
solve exactly this problem. This patch contains a COMPLETELY UNTESTED
rework of the driver, so that accesses done through the following
registers (for demonstration purposes):
- REG_IND_BYTE - a global register
- REG_IND_CTRL_0 - another global register
- P_LOCAL_CTRL - a port register
- P_FORCE_CTRL - another port register
- P_XMII_CTRL_0 and P_XMII_CTRL_1 - either port register, or global
  registers, depending on which manual you read!

are converted to the regfields API.

!! WARNING !! I only attempted to add a ksz_reg_fields structure for
KSZ8795. The other switch families will currently crash!

For easier partial migration, I have renamed the "REG_" or "P_" prefixes
of the enum ksz_regs values into a common "RF_" (for reg field) prefix
for a new enum type: ksz_rf. Eventually, enum ksz_regs, as well as the
masks, should disappear completely, being replaced by reg fields.

Link: https://lore.kernel.org/netdev/Y%2FYPfxg8Ackb8zmW@shell.armlinux.org.uk/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz8795.c     |  37 ++---
 drivers/net/dsa/microchip/ksz8863_smi.c |   9 +
 drivers/net/dsa/microchip/ksz9477_i2c.c |   9 +
 drivers/net/dsa/microchip/ksz_common.c  | 209 ++++++++++++++++--------
 drivers/net/dsa/microchip/ksz_common.h  |  49 ++++++
 drivers/net/dsa/microchip/ksz_spi.c     |   4 +
 6 files changed, 227 insertions(+), 90 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 7f9ab6d13952..1abdc45278ad 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -40,18 +40,15 @@ static void ksz_port_cfg(struct ksz_device *dev, int port, int offset, u8 bits,
 
 static int ksz8_ind_write8(struct ksz_device *dev, u8 table, u16 addr, u8 data)
 {
-	const u16 *regs;
 	u16 ctrl_addr;
 	int ret = 0;
 
-	regs = dev->info->regs;
-
 	mutex_lock(&dev->alu_mutex);
 
 	ctrl_addr = IND_ACC_TABLE(table) | addr;
-	ret = ksz_write8(dev, regs[REG_IND_BYTE], data);
+	ret = ksz_regfield_write(dev, RF_IND_BYTE, data);
 	if (!ret)
-		ret = ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+		ret = ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 
 	mutex_unlock(&dev->alu_mutex);
 
@@ -176,7 +173,7 @@ void ksz8_r_mib_cnt(struct ksz_device *dev, int port, u16 addr, u64 *cnt)
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
@@ -214,7 +211,7 @@ static void ksz8795_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 
 	/* It is almost guaranteed to always read the valid bit because of
 	 * slow SPI speed.
@@ -265,7 +262,7 @@ static void ksz8863_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
 	ctrl_addr |= IND_ACC_TABLE(TABLE_MIB | TABLE_READ);
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 	ksz_read32(dev, regs[REG_IND_DATA_LO], &data);
 	mutex_unlock(&dev->alu_mutex);
 
@@ -346,7 +343,7 @@ static void ksz8_r_table(struct ksz_device *dev, int table, u16 addr, u64 *data)
 	ctrl_addr = IND_ACC_TABLE(table | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 	ksz_read64(dev, regs[REG_IND_DATA_HI], data);
 	mutex_unlock(&dev->alu_mutex);
 }
@@ -362,7 +359,7 @@ static void ksz8_w_table(struct ksz_device *dev, int table, u16 addr, u64 data)
 
 	mutex_lock(&dev->alu_mutex);
 	ksz_write64(dev, regs[REG_IND_DATA_HI], data);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 	mutex_unlock(&dev->alu_mutex);
 }
 
@@ -412,7 +409,7 @@ int ksz8_r_dyn_mac_table(struct ksz_device *dev, u16 addr, u8 *mac_addr,
 	ctrl_addr = IND_ACC_TABLE(TABLE_DYNAMIC_MAC | TABLE_READ) | addr;
 
 	mutex_lock(&dev->alu_mutex);
-	ksz_write16(dev, regs[REG_IND_CTRL_0], ctrl_addr);
+	ksz_regfield_write(dev, RF_IND_CTRL_0, ctrl_addr);
 
 	rc = ksz8_valid_dyn_entry(dev, &data);
 	if (rc == -EAGAIN) {
@@ -605,8 +602,9 @@ static void ksz8_w_vlan_table(struct ksz_device *dev, u16 vid, u16 vlan)
 
 int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 {
-	u8 restart, speed, ctrl, link;
+	u8 restart, speed, link;
 	int processed = true;
+	unsigned int ctrl;
 	const u16 *regs;
 	u8 val1, val2;
 	u16 data = 0;
@@ -625,7 +623,7 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 		if (ret)
 			return ret;
 
-		ret = ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+		ret = ksz_regfields_read(dev, p, RF_FORCE_CTRL, &ctrl);
 		if (ret)
 			return ret;
 
@@ -682,7 +680,7 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 			data = KSZ8795_ID_LO;
 		break;
 	case MII_ADVERTISE:
-		ret = ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		ret = ksz_regfields_read(dev, p, RF_LOCAL_CTRL, &ctrl);
 		if (ret)
 			return ret;
 
@@ -759,7 +757,8 @@ int ksz8_r_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 *val)
 
 int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 {
-	u8 restart, speed, ctrl, data;
+	u8 restart, speed, data;
+	unsigned int ctrl;
 	const u16 *regs;
 	u8 p = phy;
 	int ret;
@@ -788,7 +787,7 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 				return ret;
 		}
 
-		ret = ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
+		ret = ksz_regfields_read(dev, p, RF_FORCE_CTRL, &ctrl);
 		if (ret)
 			return ret;
 
@@ -819,7 +818,7 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data &= ~PORT_FORCE_FULL_DUPLEX;
 
 		if (data != ctrl) {
-			ret = ksz_pwrite8(dev, p, regs[P_FORCE_CTRL], data);
+			ret = ksz_regfields_write(dev, p, RF_FORCE_CTRL, data);
 			if (ret)
 				return ret;
 		}
@@ -866,7 +865,7 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 		}
 		break;
 	case MII_ADVERTISE:
-		ret = ksz_pread8(dev, p, regs[P_LOCAL_CTRL], &ctrl);
+		ret = ksz_regfields_read(dev, p, RF_LOCAL_CTRL, &ctrl);
 		if (ret)
 			return ret;
 
@@ -888,7 +887,7 @@ int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
 			data |= PORT_AUTO_NEG_10BT;
 
 		if (data != ctrl) {
-			ret = ksz_pwrite8(dev, p, regs[P_LOCAL_CTRL], data);
+			ret = ksz_regfields_write(dev, p, RF_LOCAL_CTRL, data);
 			if (ret)
 				return ret;
 		}
diff --git a/drivers/net/dsa/microchip/ksz8863_smi.c b/drivers/net/dsa/microchip/ksz8863_smi.c
index 5871f27451cb..f9d22a444146 100644
--- a/drivers/net/dsa/microchip/ksz8863_smi.c
+++ b/drivers/net/dsa/microchip/ksz8863_smi.c
@@ -136,11 +136,16 @@ static const struct regmap_config ksz8863_regmap_config[] = {
 
 static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 {
+	const struct ksz_chip_data *chip;
 	struct regmap_config rc;
 	struct ksz_device *dev;
 	int ret;
 	int i;
 
+	chip = device_get_match_data(ddev);
+	if (!chip)
+		return -EINVAL;
+
 	dev = ksz_switch_alloc(&mdiodev->dev, mdiodev);
 	if (!dev)
 		return -ENOMEM;
@@ -159,6 +164,10 @@ static int ksz8863_smi_probe(struct mdio_device *mdiodev)
 		}
 	}
 
+	ret = ksz_regfields_init(dev, chip);
+	if (ret)
+		return ret;
+
 	if (mdiodev->dev.platform_data)
 		dev->pdata = mdiodev->dev.platform_data;
 
diff --git a/drivers/net/dsa/microchip/ksz9477_i2c.c b/drivers/net/dsa/microchip/ksz9477_i2c.c
index 497be833f707..2cbd76aed974 100644
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@ -16,10 +16,15 @@ KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
 
 static int ksz9477_i2c_probe(struct i2c_client *i2c)
 {
+	const struct ksz_chip_data *chip;
 	struct regmap_config rc;
 	struct ksz_device *dev;
 	int i, ret;
 
+	chip = device_get_match_data(ddev);
+	if (!chip)
+		return -EINVAL;
+
 	dev = ksz_switch_alloc(&i2c->dev, i2c);
 	if (!dev)
 		return -ENOMEM;
@@ -35,6 +40,10 @@ static int ksz9477_i2c_probe(struct i2c_client *i2c)
 		}
 	}
 
+	ret = ksz_regfields_init(dev, chip);
+	if (ret)
+		return ret;
+
 	if (i2c->dev.platform_data)
 		dev->pdata = i2c->dev.platform_data;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 8617aeaa0248..5bcbea8d9151 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -295,6 +295,65 @@ static const struct ksz_dev_ops lan937x_dev_ops = {
 	.exit = lan937x_switch_exit,
 };
 
+#define KSZ8_PORT_BASE		0x10
+#define KSZ8_PORT_SPACING	0x10
+#define KSZ9477_PORT_BASE	0x1000
+#define KSZ9477_PORT_SPACING	0x1000
+
+#define KSZ_REG_FIELD_8(_reg, _lsb, _msb) \
+	{ .width = KSZ_REGMAP_8, .regfield = REG_FIELD(_reg, _lsb, _msb) }
+#define KSZ_REG_FIELD_16(_reg, _lsb, _msb) \
+	{ .width = KSZ_REGMAP_16, .regfield = REG_FIELD(_reg, _lsb, _msb) }
+#define KSZ_REG_FIELD_32(_reg, _lsb, _msb) \
+	{ .width = KSZ_REGMAP_32, .regfield = REG_FIELD(_reg, _lsb, _msb) }
+#define KSZ8_PORT_REG_FIELD_8(_reg, _lsb, _msb) \
+	{ \
+		.width = KSZ_REGMAP_8, \
+		.regfield = REG_FIELD_ID(KSZ8_PORT_BASE + (_reg), \
+					 _lsb, _msb, KSZ_MAX_NUM_PORTS, \
+					 KSZ8_PORT_SPACING) \
+	}
+#define KSZ8_PORT_REG_FIELD_16(_reg, _lsb, _msb) \
+	{ \
+		.width = KSZ_REGMAP_16, \
+		.regfield = REG_FIELD_ID(KSZ8_PORT_BASE + (_reg), \
+					 _lsb, _msb, KSZ_MAX_NUM_PORTS, \
+					 KSZ8_PORT_SPACING) \
+	}
+#define KSZ8_PORT_REG_FIELD_32(_reg, _lsb, _msb) \
+	{ \
+		.width = KSZ_REGMAP_32, \
+		.regfield = REG_FIELD_ID(KSZ8_PORT_BASE + (_reg), \
+					 _lsb, _msb, KSZ_MAX_NUM_PORTS, \
+					 KSZ8_PORT_SPACING) \
+	}
+/* Some registers are wacky, in the sense that they should be per port (and are
+ * accessed using per-port regfields by the driver), but on some hardware, they
+ * are defined in the global address space, so they should be accessed via the
+ * global regfield API. We hack these up by using a REG_FIELD_ID() definition
+ * with a spacing of 0, so that accesses to any port access the same (global)
+ * register.
+ */
+#define KSZ_WACKY_REG_FIELD_8(_reg, _lsb, _msb) \
+	{ \
+		.width = KSZ_REGMAP_8, \
+		.regfield = REG_FIELD_ID(_reg, _lsb, _msb, KSZ_MAX_NUM_PORTS, 0) \
+	}
+
+static const struct ksz_reg_field ksz8795_regfields[__KSZ_NUM_REGFIELDS] = {
+	[RF_IND_CTRL_0] = KSZ_REG_FIELD_16(0x6E, 0, 15),
+	[RF_IND_BYTE] = KSZ_REG_FIELD_8(0xA0, 0, 7),
+	[RF_FORCE_CTRL] = KSZ8_PORT_REG_FIELD_8(0x0C, 0, 7),
+	[RF_LOCAL_CTRL] = KSZ8_PORT_REG_FIELD_8(0x07, 0, 7),
+	[RF_GMII_1GBIT] = KSZ8_PORT_REG_FIELD_8(0x06, 6, 6),
+	[RF_MII_SEL] = KSZ8_PORT_REG_FIELD_8(0x06, 2, 2),
+	[RF_RGMII_ID_IG_ENABLE] = KSZ8_PORT_REG_FIELD_8(0x06, 4, 4),
+	[RF_RGMII_ID_EG_ENABLE] = KSZ8_PORT_REG_FIELD_8(0x06, 3, 3),
+	[RF_MII_DUPLEX] = KSZ_WACKY_REG_FIELD_8(0x06, 6, 6), // Global Control 4
+	[RF_MII_TX_FLOW_CTRL] = KSZ_WACKY_REG_FIELD_8(0x06, 5, 5), // Global Control 4
+	[RF_MII_100MBIT] = KSZ_WACKY_REG_FIELD_8(0x06, 4, 4), // Global Control 4
+};
+
 static const u16 ksz8795_regs[] = {
 	[REG_IND_CTRL_0]		= 0x6E,
 	[REG_IND_DATA_8]		= 0x70,
@@ -1121,6 +1180,7 @@ const struct ksz_chip_data ksz_switch_chips[] = {
 		.regs = ksz8795_regs,
 		.masks = ksz8795_masks,
 		.shifts = ksz8795_shifts,
+		.regfields = ksz8795_regfields,
 		.xmii_ctrl0 = ksz8795_xmii_ctrl0,
 		.xmii_ctrl1 = ksz8795_xmii_ctrl1,
 		.supports_mii = {false, false, false, false, true},
@@ -2747,34 +2807,28 @@ static void ksz_set_xmii(struct ksz_device *dev, int port,
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
 	struct ksz_port *p = &dev->ports[port];
-	const u16 *regs = dev->info->regs;
-	u8 data8;
-
-	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
-
-	data8 &= ~(P_MII_SEL_M | P_RGMII_ID_IG_ENABLE |
-		   P_RGMII_ID_EG_ENABLE);
+	unsigned int mii_sel;
 
 	switch (interface) {
 	case PHY_INTERFACE_MODE_MII:
-		data8 |= bitval[P_MII_SEL];
+		mii_sel = bitval[P_MII_SEL];
 		break;
 	case PHY_INTERFACE_MODE_RMII:
-		data8 |= bitval[P_RMII_SEL];
+		mii_sel = bitval[P_RMII_SEL];
 		break;
 	case PHY_INTERFACE_MODE_GMII:
-		data8 |= bitval[P_GMII_SEL];
+		mii_sel = bitval[P_GMII_SEL];
 		break;
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
-		data8 |= bitval[P_RGMII_SEL];
+		mii_sel = bitval[P_RGMII_SEL];
 		/* On KSZ9893, disable RGMII in-band status support */
 		if (dev->chip_id == KSZ9893_CHIP_ID ||
 		    dev->chip_id == KSZ8563_CHIP_ID ||
 		    dev->chip_id == KSZ9563_CHIP_ID)
-			data8 &= ~P_MII_MAC_MODE;
+			ksz_regfields_write(dev, port, RF_MII_MAC_MODE, 0);
 		break;
 	default:
 		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
@@ -2782,42 +2836,46 @@ static void ksz_set_xmii(struct ksz_device *dev, int port,
 		return;
 	}
 
-	if (p->rgmii_tx_val)
-		data8 |= P_RGMII_ID_EG_ENABLE;
-
-	if (p->rgmii_rx_val)
-		data8 |= P_RGMII_ID_IG_ENABLE;
-
-	/* Write the updated value */
-	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
+	ksz_regfields_write(dev, port, RF_MII_SEL, mii_sel);
+	ksz_regfields_write(dev, port, RF_RGMII_ID_EG_ENABLE,
+			    !!p->rgmii_tx_val);
+	ksz_regfields_write(dev, port, RF_RGMII_ID_IG_ENABLE,
+			    !!p->rgmii_rx_val);
 }
 
 phy_interface_t ksz_get_xmii(struct ksz_device *dev, int port, bool gbit)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
-	const u16 *regs = dev->info->regs;
+	unsigned int mii_sel, ig, eg;
 	phy_interface_t interface;
-	u8 data8;
-	u8 val;
-
-	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+	int ret;
 
-	val = FIELD_GET(P_MII_SEL_M, data8);
+	ret = ksz_regfields_read(dev, port, RF_MII_SEL, &mii_sel);
+	if (WARN_ON(ret))
+		return PHY_INTERFACE_MODE_NA;
 
-	if (val == bitval[P_MII_SEL]) {
+	if (mii_sel == bitval[P_MII_SEL]) {
 		if (gbit)
 			interface = PHY_INTERFACE_MODE_GMII;
 		else
 			interface = PHY_INTERFACE_MODE_MII;
-	} else if (val == bitval[P_RMII_SEL]) {
+	} else if (mii_sel == bitval[P_RMII_SEL]) {
 		interface = PHY_INTERFACE_MODE_RGMII;
 	} else {
+		ret = ksz_regfields_read(dev, port, RF_RGMII_ID_IG_ENABLE, &ig);
+		if (WARN_ON(ret))
+			return PHY_INTERFACE_MODE_NA;
+
+		ret = ksz_regfields_read(dev, port, RF_RGMII_ID_IG_ENABLE, &eg);
+		if (WARN_ON(ret))
+			return PHY_INTERFACE_MODE_NA;
+
 		interface = PHY_INTERFACE_MODE_RGMII;
-		if (data8 & P_RGMII_ID_EG_ENABLE)
+		if (eg)
 			interface = PHY_INTERFACE_MODE_RGMII_TXID;
-		if (data8 & P_RGMII_ID_IG_ENABLE) {
+		if (ig) {
 			interface = PHY_INTERFACE_MODE_RGMII_RXID;
-			if (data8 & P_RGMII_ID_EG_ENABLE)
+			if (eg)
 				interface = PHY_INTERFACE_MODE_RGMII_ID;
 		}
 	}
@@ -2855,14 +2913,13 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 bool ksz_get_gbit(struct ksz_device *dev, int port)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
-	const u16 *regs = dev->info->regs;
 	bool gbit = false;
-	u8 data8;
-	bool val;
-
-	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
+	unsigned int val;
+	int ret;
 
-	val = FIELD_GET(P_GMII_1GBIT_M, data8);
+	ret = ksz_regfields_read(dev, port, RF_GMII_1GBIT, &val);
+	if (WARN_ON(ret))
+		return false;
 
 	if (val == bitval[P_GMII_1GBIT])
 		gbit = true;
@@ -2873,39 +2930,27 @@ bool ksz_get_gbit(struct ksz_device *dev, int port)
 static void ksz_set_gbit(struct ksz_device *dev, int port, bool gbit)
 {
 	const u8 *bitval = dev->info->xmii_ctrl1;
-	const u16 *regs = dev->info->regs;
-	u8 data8;
-
-	ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
-
-	data8 &= ~P_GMII_1GBIT_M;
+	unsigned int val;
 
 	if (gbit)
-		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_1GBIT]);
+		val = bitval[P_GMII_1GBIT];
 	else
-		data8 |= FIELD_PREP(P_GMII_1GBIT_M, bitval[P_GMII_NOT_1GBIT]);
+		val = bitval[P_GMII_NOT_1GBIT];
 
-	/* Write the updated value */
-	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
+	ksz_regfields_write(dev, port, RF_GMII_1GBIT, val);
 }
 
 static void ksz_set_100_10mbit(struct ksz_device *dev, int port, int speed)
 {
 	const u8 *bitval = dev->info->xmii_ctrl0;
-	const u16 *regs = dev->info->regs;
-	u8 data8;
-
-	ksz_pread8(dev, port, regs[P_XMII_CTRL_0], &data8);
-
-	data8 &= ~P_MII_100MBIT_M;
+	unsigned int val;
 
 	if (speed == SPEED_100)
-		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_100MBIT]);
+		val = bitval[P_MII_100MBIT];
 	else
-		data8 |= FIELD_PREP(P_MII_100MBIT_M, bitval[P_MII_10MBIT]);
+		val = bitval[P_MII_10MBIT];
 
-	/* Write the updated value */
-	ksz_pwrite8(dev, port, regs[P_XMII_CTRL_0], data8);
+	ksz_regfields_write(dev, port, RF_MII_100MBIT, val);
 }
 
 static void ksz_port_set_xmii_speed(struct ksz_device *dev, int port, int speed)
@@ -2923,26 +2968,19 @@ static void ksz_duplex_flowctrl(struct ksz_device *dev, int port, int duplex,
 				bool tx_pause, bool rx_pause)
 {
 	const u8 *bitval = dev->info->xmii_ctrl0;
-	const u32 *masks = dev->info->masks;
-	const u16 *regs = dev->info->regs;
-	u8 mask;
-	u8 val;
-
-	mask = P_MII_DUPLEX_M | masks[P_MII_TX_FLOW_CTRL] |
-	       masks[P_MII_RX_FLOW_CTRL];
+	unsigned int val;
 
 	if (duplex == DUPLEX_FULL)
-		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_FULL_DUPLEX]);
+		val = bitval[P_MII_FULL_DUPLEX];
 	else
-		val = FIELD_PREP(P_MII_DUPLEX_M, bitval[P_MII_HALF_DUPLEX]);
+		val = bitval[P_MII_HALF_DUPLEX];
 
-	if (tx_pause)
-		val |= masks[P_MII_TX_FLOW_CTRL];
+	ksz_regfields_write(dev, port, RF_MII_DUPLEX, val);
 
-	if (rx_pause)
-		val |= masks[P_MII_RX_FLOW_CTRL];
+	ksz_regfields_write(dev, port, RF_MII_TX_FLOW_CTRL, !!tx_pause);
 
-	ksz_prmw8(dev, port, regs[P_XMII_CTRL_0], mask, val);
+	if (dev->regfields[RF_MII_RX_FLOW_CTRL])
+		ksz_regfields_write(dev, port, RF_MII_RX_FLOW_CTRL, !!rx_pause);
 }
 
 static void ksz9477_phylink_mac_link_up(struct ksz_device *dev, int port,
@@ -3420,6 +3458,35 @@ static const struct dsa_switch_ops ksz_switch_ops = {
 	.set_mac_eee		= ksz_set_mac_eee,
 };
 
+int ksz_regfields_init(struct ksz_device *dev, const struct ksz_chip_data *chip)
+{
+	const struct ksz_reg_field *regfields = chip->regfields;
+	struct regmap_field *rf;
+	struct regmap *regmap;
+	enum ksz_rf i;
+
+	dev->regfields = devm_kcalloc(dev->dev, __KSZ_NUM_REGFIELDS,
+				      sizeof(*dev->regfields), GFP_KERNEL);
+	if (!dev->regfields)
+		return -ENOMEM;
+
+	for (i = 0; i < __KSZ_NUM_REGFIELDS; i++) {
+		if (!regfields[i].regfield.reg)
+			continue;
+
+		regmap = dev->regmap[regfields[i].width];
+
+		rf = devm_regmap_field_alloc(dev->dev, regmap,
+					     regfields[i].regfield);
+		if (IS_ERR(rf))
+			return PTR_ERR(rf);
+
+		dev->regfields[i] = rf;
+	}
+
+	return 0;
+}
+
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv)
 {
 	struct dsa_switch *ds;
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index ef1643c357a4..a92ebf5417b4 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -47,6 +47,11 @@ struct ksz_mib_names {
 	char string[ETH_GSTRING_LEN];
 };
 
+struct ksz_reg_field {
+	enum ksz_regmap_width width;
+	struct reg_field regfield;
+};
+
 struct ksz_chip_data {
 	u32 chip_id;
 	const char *dev_name;
@@ -68,6 +73,7 @@ struct ksz_chip_data {
 	const u16 *regs;
 	const u32 *masks;
 	const u8 *shifts;
+	const struct ksz_reg_field *regfields;
 	const u8 *xmii_ctrl0;
 	const u8 *xmii_ctrl1;
 	int stp_ctrl_reg;
@@ -145,6 +151,7 @@ struct ksz_device {
 
 	struct device *dev;
 	struct regmap *regmap[__KSZ_NUM_REGMAPS];
+	struct regmap_field **regfields;
 
 	void *priv;
 	int irq;
@@ -235,6 +242,23 @@ enum ksz_regs {
 	P_XMII_CTRL_1,
 };
 
+enum ksz_rf {
+	RF_IND_CTRL_0,
+	RF_IND_BYTE,
+	RF_FORCE_CTRL,
+	RF_LOCAL_CTRL,
+	RF_GMII_1GBIT,
+	RF_MII_100MBIT,
+	RF_MII_SEL,
+	RF_MII_DUPLEX,
+	RF_MII_TX_FLOW_CTRL,
+	RF_MII_RX_FLOW_CTRL,
+	RF_RGMII_ID_IG_ENABLE,
+	RF_RGMII_ID_EG_ENABLE,
+	RF_MII_MAC_MODE,
+	__KSZ_NUM_REGFIELDS,
+};
+
 enum ksz_masks {
 	PORT_802_1P_REMAPPING,
 	SW_TAIL_TAG_ENABLE,
@@ -371,6 +395,7 @@ struct ksz_dev_ops {
 	void (*exit)(struct ksz_device *dev);
 };
 
+int ksz_regfields_init(struct ksz_device *dev, const struct ksz_chip_data *chip);
 struct ksz_device *ksz_switch_alloc(struct device *base, void *priv);
 int ksz_switch_register(struct ksz_device *dev);
 void ksz_switch_remove(struct ksz_device *dev);
@@ -578,6 +603,30 @@ static inline void ksz_prmw8(struct ksz_device *dev, int port, int offset,
 			   mask, val);
 }
 
+static inline int ksz_regfield_read(struct ksz_device *dev, enum ksz_rf rf,
+				    unsigned int *val)
+{
+	return regmap_field_read(dev->regfields[rf], val);
+}
+
+static inline int ksz_regfield_write(struct ksz_device *dev, enum ksz_rf rf,
+				     unsigned int val)
+{
+	return regmap_field_write(dev->regfields[rf], val);
+}
+
+static inline int ksz_regfields_read(struct ksz_device *dev, enum ksz_rf rf,
+				     unsigned int port, unsigned int *val)
+{
+	return regmap_fields_read(dev->regfields[rf], port, val);
+}
+
+static inline int ksz_regfields_write(struct ksz_device *dev, enum ksz_rf rf,
+				      unsigned int port, unsigned int val)
+{
+	return regmap_fields_write(dev->regfields[rf], port, val);
+}
+
 static inline void ksz_regmap_lock(void *__mtx)
 {
 	struct mutex *mtx = __mtx;
diff --git a/drivers/net/dsa/microchip/ksz_spi.c b/drivers/net/dsa/microchip/ksz_spi.c
index 279338451621..a64d2c71ef68 100644
--- a/drivers/net/dsa/microchip/ksz_spi.c
+++ b/drivers/net/dsa/microchip/ksz_spi.c
@@ -77,6 +77,10 @@ static int ksz_spi_probe(struct spi_device *spi)
 		}
 	}
 
+	ret = ksz_regfields_init(dev, chip);
+	if (ret)
+		return ret;
+
 	if (spi->dev.platform_data)
 		dev->pdata = spi->dev.platform_data;
 
-- 
2.34.1

