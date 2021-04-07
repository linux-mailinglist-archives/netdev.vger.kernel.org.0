Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE837356A1B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbhDGKod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 06:44:33 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:54744
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235796AbhDGKoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 06:44:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjI9Afu6RAKp081YUbhDOSV264IY0elafkjzp5KKdE4khE6zUrutsRM2enYhAjvlP2fMHmYFe3Hu0oKv8BgVHa3KgUQXNtfgaTejhR2OZ9Fki4CI6Dw6D9FujOERbpNn9mfmayuFHRONBwRCkAYV6OPhWVjwD9fCAAPc8HNIl3qzXuec7kZCAAPWiJ8/BZIZHE42cDGI9EJJWlHBP+DajLiXtLjPG88RK4fsbuq3wFfGwLPugzqbGkF2l+ZHKTGCX/meKQASSBDN2AjY2PwxE0B0VlBrBJW2RTRyjMOuaxcXQgIh2VIvInmLuyy1vX/BQJlZq7BPMzuB46JkTtQeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8k/7BhnKiaURKTxnKa0kqlRzQBvbBjdWFGWVfGjyoYs=;
 b=PLCE/t3XSFuKiPSaelXgnniucPULGqDVDURYy39SxRzj4K/R+VyA6F+kQ+380ypvew4/b2HngEOC2mIOy5dOk4OUP8HuoHKP8GMnIzV5fX0Ofi3FXX0H6cYp0oj14Hrmui0dRx5cRZi0oQV0saLBFeJfqVkfOSDE573bTJLGi09+fdc/7R1aKYlHJ/+Pc4XfNjXBmy4JghmNg2n3239gpVrVMABG2MF9hI/Dul28BYuDPDAJ9SgzNArmDKwL1nSjk2SXNQ+X/OnFkJ34nlOObXANA+u5ek+IjKqKGQnqTtXLh8F95l7i21/qbZzVu/lxOFpWFVq93B16fdYXncWYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8k/7BhnKiaURKTxnKa0kqlRzQBvbBjdWFGWVfGjyoYs=;
 b=hguTboKBZTQJy+PDBUmXUXEYQC177v2abUsmKz2Zedc96FOBf5/JNUGaeO35Y2ZAwnOQsLsmGIt1b0+qWHaEz1qanY/7ppNsioh50XdVUaXe5F7ZEzJyuM12Rby4Mo/1VyHV3h8SEtoDCPrVzQ9O7Rv9Ot6L3sl0tuyu9mVP16Q=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Wed, 7 Apr
 2021 10:44:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Wed, 7 Apr 2021
 10:44:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com,
        Jisheng.Zhang@synaptics.com
Subject: [PATCH net] net: stmmac: fix MAC WoL unwork if PHY doesn't support WoL
Date:   Wed,  7 Apr 2021 18:44:04 +0800
Message-Id: <20210407104404.5781-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0063.apcprd04.prod.outlook.com
 (2603:1096:202:14::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0063.apcprd04.prod.outlook.com (2603:1096:202:14::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 10:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae2127e3-c82d-4440-777a-08d8f9b21a0d
X-MS-TrafficTypeDiagnostic: DB8PR04MB6795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB679584400B00DCA2DB729987E6759@DB8PR04MB6795.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSKB0aq8+QUXZASI+VvCFy6RtAvbIOBf9NGQ1RpGzixGTQutAlrrr50cb0VAlzOzN1W85VaphYHT9EOtryEkeX/Uj6IkuMuFpi6JnBKs6CVXDCJZH6nNC/H2+UQ2R79nMm2hUQK2iCijao6TUUUQkNLbzjyYbHVGhsAtxxscYEeZhwZ4SsDkZgqIaxo5UTvXQvcBM6S8ECvyD6prvjZgFuFyy1VGNDllGIIMzdLafI7wGBysp0aJpTUisxpZuv6Dy2dAxfmD0pkvijcZ3UkcqD8gu36izfP4JFqwOcS8+7nCRPJHcZxeHkKcH8d9VSEYWnacIlFONb6JN1LFBLZ54Ud7wyXzFD4yLtNp6K7Eoc7Eeot98RWxjMeicITdUDLNkoyx6nza0FeNTUBDyitTWKvtL2Om7rBmdsxh12XICBLOmRW0JUrJMbZ9wa91MtsZLzmICbgsFYy9fbkjzuDXR8jeCQGZkbgxKvX6XCak748PBoUB6dRTHoA/ub8lLckU8WmnUC9w1djz2l/rKVaNdalL8YMGtF5/kBMRiOG5TXJzaUmnHSBJ0+eXeivpiEOEpkDT5eSg+yyAUXvBr50PPTZAEC4QB1V3Uh1562VjjQNFMicozMiQX5YC4xb5Trw7pQF1sRbWdoLdmHe34b04q/Yj7XzJAYrRKdGyt17tSvg9VoIMd0ucTRpCxfxkGcggJ9auVjhdrDhBB45aW1TDX3nCgJN2VFGw4GtbB2OLZw2d3z7Q74yb9CycL/j8udXU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(66556008)(26005)(6666004)(16526019)(186003)(1076003)(5660300002)(66946007)(66476007)(36756003)(69590400012)(316002)(6506007)(4326008)(83380400001)(52116002)(6486002)(8676002)(478600001)(8936002)(2906002)(38100700001)(38350700001)(86362001)(6512007)(956004)(2616005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zUvuLGAuspFqSH6uGPZda1bOYSC0ijAyn3fyTSg4X3yHtaDCEA/2V9fRTAtu?=
 =?us-ascii?Q?SN/hEOxW7/0EJDQowCpe+ILu8UxQ3zyekrLEprHU4XOdiO97Rmo7G9VUoGA5?=
 =?us-ascii?Q?gVt6N3NEXL8eAVWQYatgBCZiLjX6LlA7PPpec23Ru3Oh3/Yf7Omdz5LkEN10?=
 =?us-ascii?Q?Py9RRHMoQ6UZVuCdzGHviOOfgYrMFyoRCNivDGs6KQStx2iPU4QAqoqI4dIo?=
 =?us-ascii?Q?2MZoC0n7yVaXUk1rdEOoiuA0QEE+zJlH5P6qZfaQAkHuWjIk5mDyYysvWRxb?=
 =?us-ascii?Q?WRgQZC5+wxSc8vs9pTJoQeDi/X7ZQpeEkY7i5l+3pQGLgvgWfFCkn4Cbea3v?=
 =?us-ascii?Q?sarBKrYmyIFslTDH9Ovj+1CxeQuOMoSjq5GUDlfwbiQpXjzKndCXCL5I7ARS?=
 =?us-ascii?Q?IzwCjWHtoe0vAkkd02zZLv27vq2L2L1P5YbEgA2/xRCkwOBzsqA/vGfXSKYY?=
 =?us-ascii?Q?DWFQrzSafDK6r2lyBN0AVJ0FKGOuAsdiF7wd68eaASLpiYTRE2Yue9asV4Wr?=
 =?us-ascii?Q?4ISFHx7I/MONDVclycEoT3mooVduFS7bdEWQZ9qFpN8T/90ffTP3YtZ2r1J/?=
 =?us-ascii?Q?OnXLCVh+tMMfZ512g49ZF0jUhDVUKTo+YioZJnYSvF9wDxh9Lrg6juHr6dMv?=
 =?us-ascii?Q?dJLpWk3EOpi53w3hNmlXgrVEIdO1nm5HwT3US665ByMdVxFAdWrPKfEbeg5U?=
 =?us-ascii?Q?qPpx3YlkgydRrBp6TkhgcOVbKrc8JuktntXFIiej0b+aL/9VF3dlUwrOyRJs?=
 =?us-ascii?Q?T3fBa1D1nh5o4wnfUduDtZOHWrE+PUcrPbEEmgtp13ryxDjs3dqKKAKhXSHe?=
 =?us-ascii?Q?jWPkfgEaI6Uj5MeK2lVyItBclw2Ng1eGgn3KiW6p+hzmHoyENkS3JwxNksPb?=
 =?us-ascii?Q?z2hwmjmhtoMRVnsTB/BUWR+jqOticREiFuoD1Iz2OgTUdqsR4tjlPJMDQ+0J?=
 =?us-ascii?Q?bRl052qrYgE71/AiFU8aDEd6CDP8fSdOadT88PTfXjK5QQyXQT01OsnU+77D?=
 =?us-ascii?Q?8yR2Df1dnq8XgvCQltJNGF5x/FFFoNEegH/j/siBCuCHt02lOfuV5iUof+7H?=
 =?us-ascii?Q?M9W3gdFJjL8F7rQrWzN6Bcd+2fgF7uwhuaLTXjiVW/EuKF0sDDcMVS73diYC?=
 =?us-ascii?Q?ysEbyG4hb1LBCMpa+H9p+qHhYLvUNKCJgY0Q/EbfW2wYvMe7mqbYSOOFQB2Z?=
 =?us-ascii?Q?jpULZsOCOx7UAs/0QUDw5just4R5xoOdrE01pvvQxdZ3B0fJxjdyhe5t4hQG?=
 =?us-ascii?Q?SE7kLGXLM7547YGcxmcc62UGD8YzDUZUq+2ksuh1Sj1XNWzp5DYS2jDeiepX?=
 =?us-ascii?Q?ScLdl5/rSVXca9cGglOmaGl6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae2127e3-c82d-4440-777a-08d8f9b21a0d
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 10:44:21.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4SjgMRl7uiYmzO2r5U5fVzXIrkC0yTt114VrT3NuaoT7fe57HZxRI0KrTvgAuuaMF9xbal3m0MqkA0LYt3pqNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6795
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both get and set WoL will check device_can_wakeup(), if MAC supports
PMT, it will set device wakeup capability. After commit 1d8e5b0f3f2c ("net:
stmmac: Support WOL with phy"), device wakeup capability will be
overwrite in stmmac_init_phy() according to phy's Wol feature. If phy
doesn't support WoL, then MAC will lose wakeup capability. To fix this
issue, only overwrite device wakeup capability when MAC doesn't support
PMT.

Fixes: commit 1d8e5b0f3f2c ("net: stmmac: Support WOL with phy")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..f46d9c69168f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1103,7 +1103,9 @@ static int stmmac_init_phy(struct net_device *dev)
 	}
 
 	phylink_ethtool_get_wol(priv->phylink, &wol);
-	device_set_wakeup_capable(priv->device, !!wol.supported);
+
+	if (!priv->plat->pmt)
+		device_set_wakeup_capable(priv->device, !!wol.supported);
 
 	return ret;
 }
-- 
2.17.1

