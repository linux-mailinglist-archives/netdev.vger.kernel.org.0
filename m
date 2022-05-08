Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D32B251EF93
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 21:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiEHTGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 15:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbiEHS5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 14:57:42 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2124.outbound.protection.outlook.com [40.107.220.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6AFA1B1;
        Sun,  8 May 2022 11:53:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRJxtVS+2JK5VIlrTsZP6K4tMhxpi4jTugP84yfyuqDhtys14l6YN7HF/fzRckabiQx1h7BsZXwUOpeoKjCsaHcoAa1Ru1tjRror4rH0rzKE0J/O54r17Z8wHEDMSRxNnHrDMJfIDDSywiT/Ks6TNT+S/O1Hh4xyUDvjhdBa+xvQEjMT2PxE/0F897n5drzZThB4tyRSZkrqCnEJWjT454PK6LpT1WS1CJaX7X3YCIUyRvZh+xY5LIRMMJP4eA9bZscBKrHNAFP8+PQpY8GI2CelWdDQ5qrAVaYcn6QA0RMq+KDEuAj9L1WbyCs3vh5NwM5w5bmihA71Ne2wNOdjHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SYnUe1IeJdpSC4yXti3PENMjZ6Mv2WHCNFpsCo+hzqE=;
 b=ZtuU32Bd5jAC5FwiT/aVu2yqD2wfXB4oI6vFWt8ijYVQdtaRrXFY1xaPRm0PtPsoU6vhxJk9zStwCAe3Jxna8jDpReEtT+baUwNNanifYRfk8O0cjC+/XOk5YEgilM9cohP/4zkszNauqjxSnseq6va27oZMRtZS4F5nqedKvUxcgvS2RFuVr/3IdkOdkmNiwH5NzTx5zw/ZjSXnVnYc2AZWPT1NWniPRbWvGno1xZMI8yjXtXoQCVFO4JJENa6gVvSwsaxtzltBF6l23xk2sDbYwavQeL0OizWVoa/+MiwLJ8+1usrVnrjcpw6vSIlBqREf6ZHOR5bh9HPxpJPp2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYnUe1IeJdpSC4yXti3PENMjZ6Mv2WHCNFpsCo+hzqE=;
 b=wdp0zgXvCU5vslSswFEkkQ57yosmbH76Axfpwmefc6o15MTCaJJLU8IDliBN89Btlr+/oF5ydiufG5bBopd7CXDOJxzugdw0LaGHKGd0xuLyOiZdaoIjiwrlJHZDHkQhq7NpqO7c2wjlLySG8WP1rkNKmkTBmxOGndiFTtwR5vk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5672.namprd10.prod.outlook.com
 (2603:10b6:a03:3ef::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Sun, 8 May
 2022 18:53:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5227.020; Sun, 8 May 2022
 18:53:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>, Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v8 net-next 09/16] net: mscc: ocelot: expose ocelot wm functions
Date:   Sun,  8 May 2022 11:53:06 -0700
Message-Id: <20220508185313.2222956-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185313.2222956-1-colin.foster@in-advantage.com>
References: <20220508185313.2222956-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0045.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e0d43d1-05a0-42e2-61a4-08da312415c6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5672:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5672249ED8C7646E64E0CBB6A4C79@SJ0PR10MB5672.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGH9gPOkAEjoh7KgyEl7KpDcqaoOlF5EEV1KWKtOW39ipcXA79du7EwERiYOaIzWRX3MVArQAc6KFDXxPRhaYXMxBMbTRF5nxbE/yMxfjCL9cJFgF8qlMiG5uNZHQIeRKCl72kVwOw9Zk6aMA8r4b5StQKYDH2RHfWBp+j+FspgP1ugZtlclGMb8qSwuADwXR0KeoW7yErVaMcyHnGJN78yfeC9G2pN9HgI4Kvd4+SSWCpJairM/QTftbXUpFQDn6iabvbMJy7bKiiasBwsh76roUIFs2Kl1sc1jfqQyGugMYYrXq+9w9E+8X9P0BRFBqqwZERNKh3WcO1p5xFT4Z1G1suE33vlfLagDdGh4v/c4wyeZ7FPIfoLcHbARf5NoySExa2unqVLAJa2VjaDThRneGH2heqjxAYZ3bQyf/rhE5Leo4N0bea6pD4Oy8M5zD44VmSch2sxU2MZoJ2Nh0C1xn3cVCmJ5ipKBj9nKXxVn+bSca/8bkV52BQ4lH2yFiuIP42LeVk0RPXzWkXC0W3qpgTJnluGKTbYkix8NriUyUX7cML2OponBCirGInYkqne5twBfue6Azj3cVc64d00ONOHcgPx1/upRO0Ax3+/PSZS5g4jggxhYDNKqEBGpx3aTh9TkNevBAlM4kiD3FHTTNiHAkOOHcPnuANfy86PI3Hxneq31XmR+9Z/7O3JToSKHeIsfUwRFODJqT0FdVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(366004)(346002)(376002)(136003)(6506007)(6666004)(6512007)(2906002)(8676002)(7416002)(52116002)(8936002)(4326008)(36756003)(5660300002)(86362001)(44832011)(66556008)(66476007)(26005)(2616005)(66946007)(6486002)(508600001)(38350700002)(1076003)(38100700002)(54906003)(186003)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c8EovN0LqdJo22lObPUXq9EwVt0GwV6s3hOmJqpPyLbW/eSOfMHPIuYUY4MU?=
 =?us-ascii?Q?dxmMPNDQyR/cC1yqytXjdRxfOFXnhCO4X5GBZ4u35geA2iaPDc8cZUMG5Buc?=
 =?us-ascii?Q?4MExJrMClCebqTymRaIU2z6vW7qEXagTcDKOTTr+H75NdUrg90Pn28mnGSlv?=
 =?us-ascii?Q?iXsxGEKCR459Mz2OM+fQGe5ZEMuXeKQMYv+UTuEGtJ9n+LFcUvYKFViKVFU/?=
 =?us-ascii?Q?TWKfn8vxLNySp35nOwD/HN+6XJfM+mJ5W5xBuCATlKGe9p2u2+ebChj3VEvD?=
 =?us-ascii?Q?0poPYjZDaGdiRVYZQllqiU6fijwHUSUwiBovqhy0H4YtRoYBh9uEOE8oJ+gT?=
 =?us-ascii?Q?4ZBxuKy3sPiRzLrI051g1BYJ3Fj1b+dnNCfZRcfcurfntTRfIi1Rq8rIEO7v?=
 =?us-ascii?Q?dO9yb68h7yYUG0otbogQDZ994+FXMbjXxRtHB5q2XCzAfU+iQh7kIvTM4ugf?=
 =?us-ascii?Q?09/Kp2MWn4qJSkUA627VHmbmb3821C+FHRRSWqWGPnf+JbDRxqAhQve3ZUw7?=
 =?us-ascii?Q?uXu08XkOkkBouj3anP9oMwQzE2nIFoJ1z2NTR6BqPc3QtIond0KJbpP5t15d?=
 =?us-ascii?Q?wV4ts68nSedxRbCWyHepoxLwYwwDp6qB/+gSlWKirILiPSCUtsIyfoe7jAWa?=
 =?us-ascii?Q?wZqrE3YYYQGVuCGs3mT982/pfQn9pfmPDjewIKqoeGz8nVbOeHePfKVEP5oL?=
 =?us-ascii?Q?UuiVYMznAI42dzMSBe54FV38cS8xnaS9n/LvsBjaGdJvDs8kqtXSv3jNh9Mk?=
 =?us-ascii?Q?Zd1W4AAx7cw/uwvfo9nFKRgzi0g+iMXYyBChZN86uzDdV151Srb/OrwE2pAq?=
 =?us-ascii?Q?w9+3JUcxKTWsjkqE7TMCaAIe1mheo1gQYUUsPbR7r7Hos5OclnAY83pBJoHs?=
 =?us-ascii?Q?DHT+nrE00f5UW0ryTqpWutSY5qu0wZdr8lXi8GyIbQwsT5vwJMG6MVP0pf0G?=
 =?us-ascii?Q?kONrlq/dWtVgIp+ThdBjfkdOR5dQi0gYVmSq0KzqFJ9QVZY7aJ6sv4ZDeydc?=
 =?us-ascii?Q?4y+xj4nvImlrldmjfwpuF38rygJKoF6MjrickKRCWweFQa6RbgEwBXwThpdK?=
 =?us-ascii?Q?5W2ljG+gwZ8qkVrR+NST3M+4rRjvdYWyLmLtlzNw+f5eW4MXCvf89ZIRE3uN?=
 =?us-ascii?Q?s9pFGGvs6Wfdve6Qz8TlSzJ64IODQwRkm60urS1uSb6r0kuu/KAkQ3YNikbH?=
 =?us-ascii?Q?wNmGhlhFBhFEblRbJvhpaJ9H+dwdUfL0wWeWuHTCTU3S5E7x+1Ff8DVsiDlN?=
 =?us-ascii?Q?jqtPEYlb/mXdwc7snEfYGkW94SUV7QSzr7KgcqdBBqRimP8PE1tMKGz0eHW5?=
 =?us-ascii?Q?Byj0dIRl/gEzxMvnBJC1PY288FBAv/Hnt8MTR/AjmFS2yDsOCs4KpM1HAcck?=
 =?us-ascii?Q?oATQ1Y7mtqI5dPgA1LOmv1OIdbRxq87wQL0OWaBE92WylFehRdbnoEhHIXvu?=
 =?us-ascii?Q?WGXlZe28l0p1lM67BmM5PCQuB0nmJYI9nefbOEt5z8jUO0tEVvSA14EikFBP?=
 =?us-ascii?Q?IfcwRfxs5e+LAgLTR8h9nS7Cs43N5YLIFuiLIe596csuWGkAVUTy7VrwaSLc?=
 =?us-ascii?Q?/fwJq9v2i7P5cdxHYyQsyXzlqdpl5Bc4VgFFNO9pGKlEdJmHLoyrz00dOD4i?=
 =?us-ascii?Q?TuZCwfDrsxrd+gVtknT44PvQTnNcOglxvK8yLnHRIJhSNfTlLyVbpfVANPmD?=
 =?us-ascii?Q?53pB8LuLw2W9ZY2hdKcJ3y9DaxezGaQm7X8gkTirguW/DBsdC2URlk3IrhfK?=
 =?us-ascii?Q?uiuwtMGdgXh+CiKc3t9rR7OA7dZ2Iyk46WXyA2ujXWIQzbRyoQFO?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0d43d1-05a0-42e2-61a4-08da312415c6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 18:53:48.2283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ib8uPaa+B8ti5/pwO5DlXoyG+Pg19xjh0eJg5d1mKKyoXP2Pkt86bymwBT8Of/W+R49NkVa43ti4mPzx7hhzh3WgR+IsFRJAoCws+Mr36fs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5672
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 961f803aca19..68d205088665 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -307,34 +307,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f9124a66e386..61888453f913 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -865,6 +865,11 @@ void ocelot_deinit_port(struct ocelot *ocelot, int port);
 void ocelot_port_set_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 void ocelot_port_unset_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

