Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9736649AC7C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354590AbiAYGjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:39:20 -0500
Received: from mail-mw2nam12on2101.outbound.protection.outlook.com ([40.107.244.101]:33504
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353930AbiAYGg6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 01:36:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EpMujYrGxuGYg/KmRwBMKQZ2Ip9dulHpgclWodtT3pJibB7zmtmV9RnasU1xzBCd8cenMG0dX2Zm87KKBj4Dy45d8/9pK7SFoxTKVdtgIBPFOssA9utahNqbEdXe0CKkH4a5oKvCPyJP1uUA8ZTvl6gKt6JnFu0Xi+AFahwCArawOmQ7hMXKMr3V7q9FB8/13SFBttJLk59Yy3k3FwjPeXj3Em+uceBYvH8F/Fp6Z2OSXMblSXDOZbSnBQVZ8MAaeblxnHjTtCeyRp3lzaSsuQxdJ4rzF4z4olcepweza+4jie9W95WPpb7LyX0DL+0kYuTRzc+wdtktM3ehPIbVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=kipKlXdzRY/0wVxXJ/wItTQ3Q+CUCEFi0tVKMuUamG3+aO46mR3DE1lqPxitcSdk+CzuWi19SlTgKvdohPKn92znHnJBmhduqJhzQ0dgZRTqyLu1Oo/MY5P9payhhrvVNZ4RYqizdxIRAJZkYwgse/wQfiHxnD0aaypv0ibfTiYFn3nABHIiEY9Yupz3bWbOnwTo3P9T8Q6ecOqz0repQUA41JJQix+BvAjuFrRjeG1IO4ooN5G7Jq4a4MMEXw7cxRTAlrHmyjqskpMsxDD0AwdtDZDCtPS6eleMnbKsA7zgEv1vwNyciKPbh2cwdk88jrKiOLCJaE0Vc6kYxhuHaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mQDF4oCS4oyLJbH4+gGFq/wxc013Q8C8cVc0ZWNaAXo=;
 b=oukviimz1Sa8N1vxICudpQ6Dh1XzSjh8ZsNj8pbaiOqYkLmg3429l4sV+rO+RgVPMDHXPEg/m+MLZ+cjT5SCP53I+OS5BFkNUV+XEknSiwRT6qS4iJfjABiWZu6Qaw6efLPFjnvkG1UdDeYaq6jcEUnMGON0bHYC0PT4xBNphHI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB5265.namprd10.prod.outlook.com
 (2603:10b6:208:325::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 25 Jan
 2022 06:35:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 06:35:50 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 1/2] net: mscc: ocelot: add ability to perform bulk reads
Date:   Mon, 24 Jan 2022 22:35:39 -0800
Message-Id: <20220125063540.1178932-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220125063540.1178932-1-colin.foster@in-advantage.com>
References: <20220125063540.1178932-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0309.namprd03.prod.outlook.com
 (2603:10b6:303:dd::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 626188c5-7658-4ee5-d377-08d9dfcced2f
X-MS-TrafficTypeDiagnostic: BLAPR10MB5265:EE_
X-Microsoft-Antispam-PRVS: <BLAPR10MB526523F0DE0BAAAF530C5239A45F9@BLAPR10MB5265.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCvSdYZH3bVX8i2MgH0zw4FKDNvRkaI5WP7kCbq6fx4jIzgUu7VPi5QLWb8Td/T5F+MJSgHmpBvmYjj/IS9ceqQEXFEWYyb8najAZYgWLoSmD8Q7uDd57uFyQ4BNyp/8zej7R/1djlWYJU114E4dPhUED+nDLpAeie2Oi44pXl9EdAjprCAFAkgGV4BPTZgGMZV7sgfhS/9KZylaOs0iQvMqaZrreKFPcJxBJJs0Bd3cCshy2J/IYQaYQ6fJafWmNCDxv7aGV124yD8cApNNgKqlVBmEfdRQVkZQ+PsriQ1Ss3DlFF0EmP7+h0xR1/cbVu9lFxDqnZQUaTmIuJ7aD+9dmAmy+YAYqSYFg4NqFos2AWYJmimYdau4cnQyNxeGU64wSO0WYVdgPA8pP9LXftg5HDZX7ahyfWACT2LqIyOLG4wtIbbYTe3JCMp6WzdlOBfvT98PuNYlP4/MSe4SeF5tt/A92mJzoCf0pCrVZ+xrkQnXoKMxFkORuZl1UBTOH8MSVABEFGo2qUpRzwAhujcC1JLp4De8R7qA3+Tqvtd9JYmu6V/oTc+uiQ/VGlEPnBA8xH2RlpUDanPhyxxOiQTwGZ7glkwezL4NpGjPSfcYq0G5otWg2SybzMICcw8Pzp+qWCZTQ0TwyVVloms3LWRG27Okwo49upEo1sDitV5Jm/2n+z4hvvsdGRJARXJoIDbxTgtky5WfLvu6jTbZww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(42606007)(366004)(376002)(346002)(396003)(136003)(316002)(66946007)(52116002)(6512007)(26005)(6506007)(186003)(1076003)(6666004)(2616005)(54906003)(83380400001)(508600001)(6486002)(44832011)(5660300002)(86362001)(2906002)(38100700002)(38350700002)(8676002)(8936002)(66476007)(36756003)(66556008)(4326008)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NJjsjaol5ZoZHaWFKtyt08DvSTFD8MAO2py/EcymSJolC0YkD72bcunKQwb?=
 =?us-ascii?Q?yL/tK16V1lLZEa+Ny8wO5ezgX50PtFiG4cB+E2qQuAfaAxNW2los1/SY3tFk?=
 =?us-ascii?Q?4DpF+mb9l5qJzzkN8Y7eFBQF97IcI5o6JPfhfQha9eTos0YcMG9HIKBjcd9d?=
 =?us-ascii?Q?FrLAdfg48otnuWiS2DaTfxOKqA9Pt5f8gyKi4sSC4JXSiHcZcBjB0n3foDfF?=
 =?us-ascii?Q?SgW3d3r5ERiduxOt9Vi+8Fh1ezwSkG0lOz47Y4HX2TQX1iES5scEfnxzNmRJ?=
 =?us-ascii?Q?V8ROH4XXevUOdT71519+7SYZgxOA4B06AKSg3sQnwjFqqfgFzyOVUd3/J0qu?=
 =?us-ascii?Q?YuJ1wOEAZkTaihliOgcY0rbKaSvy90qvMrYf3PyVB/lG75zRmycleiPsnNkn?=
 =?us-ascii?Q?dBSeCwBQkftkPbqk20XOAvY2Pvf9zu5BLC7GqEh+shAb+EWOdfDodUjfRLPv?=
 =?us-ascii?Q?wbi4wSbG+ahLGKi5jQftwhScWeAz3edxvlaiUNGIQvpLqkQm5Ee7cDfJIpfX?=
 =?us-ascii?Q?Heukl6kCGbS4gtYT9G+0n4j/ZGHN+5qTP8F0shzGEwl8kf5Tna1DHnQCoFt3?=
 =?us-ascii?Q?iettiNe3A4EevBf57LGkjNWtVIA1zNrGxiJJM686LXAAv0MJaT82HdmuTAAO?=
 =?us-ascii?Q?XGbdWosiO02GFjbJESvsnxQ3g4qXkodZOe68UwI5A1zgrWN73PkHC/li8a8h?=
 =?us-ascii?Q?8ed9IElfrsWNyEgD7gRfH+AxY3NUIaQBD113i9TNApq4bW11HCEHWBnl35gY?=
 =?us-ascii?Q?CbHdhmuyeuxEB+tL/1iF0jF3Ja+9LfvSkzyOTV0wkZWx/5ExZZ0zkdhmcQhJ?=
 =?us-ascii?Q?ichoSseHXz4gNrHHbu+U2Evx0iQ66EBNvMcOaEvVD4GmGTgzJLyG05FYxEle?=
 =?us-ascii?Q?8nW//xUz3EqlT4gsANu/2dpzwxgNuG3cXIw4Cj5KgrwPAsu1HFdMeP36Hdx+?=
 =?us-ascii?Q?eAmE6/2N2JdjcfymNNY8QdAVeUPNfFx0FNyzqu25btXkAOGNunvNHTsrbuz6?=
 =?us-ascii?Q?0Yb80Ut+9jaAYo19S25fhQpULlZKAoahdd30o0ioRz8L1yVITYR4qOdA4NDo?=
 =?us-ascii?Q?ndBYkNhHdMqBD2GZPkx8zDyBCmwgzBBcmV9CuCZZ7djkQtZy/oaI1OngJpQX?=
 =?us-ascii?Q?leZMT0SCiVB0Hjoe1FRWwkdG3LiAUJ58MJYxJ8YJMt2JYDmc1fIgu2ceQZM1?=
 =?us-ascii?Q?VWqCYPgzbbmqZvYpRQOZW9Qkz2ikrrp4lViOIrKRWigPX8XBZQsjntuKsCDt?=
 =?us-ascii?Q?LvnWJw2jzeLy0xoLj/G/jRG1dp8RXll6eayVebQ2yelMCevszSMrhXyGrSCG?=
 =?us-ascii?Q?hqs9nZjyBqnLxNS1HxJoEcV24L2jxjAi2L1DtKIByouOf9OoyQRWy5rj2djt?=
 =?us-ascii?Q?JL2UqJ6BDUtGnh0p3RWw0OqEwZ2KcGLvL2vy9cSH9bPYWBVGKENyGdEt16p9?=
 =?us-ascii?Q?NaHFDdxF9cMM7o/7zfJ26NhLYvOPtvdi4E595Sog0tdRKGv7PnFVBPq4IFUO?=
 =?us-ascii?Q?kWoYTnXEJGxzgyO7j60ZONqmeCpDbplkYk1v0Jt1raaCt/9G9p/oN3aO961C?=
 =?us-ascii?Q?uropt5UhICskp+bbYcURpbMpandTvhCKzZ3tVoNC2nVKc3mzJsnGI8Rljaxx?=
 =?us-ascii?Q?Dh+JSzfoEnRPeNqGiVEXLZ4uUX3Qac1OpCzT22Fxu5Xqq4K5Ao5FoX/FvPSL?=
 =?us-ascii?Q?1nwHMA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 626188c5-7658-4ee5-d377-08d9dfcced2f
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 06:35:49.6855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqZ9mNIGlY79FHI1kCyt76ixBC0hED+US4vx0ENUtSxfgd72SkghXQk1LxyqgYYcxbX4BpbTjh68/lsOGF6bU58lq1pU5Lu4thFJcmgku5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5265
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Regmap supports bulk register reads. Ocelot does not. This patch adds
support for Ocelot to invoke bulk regmap reads. That will allow any driver
that performs consecutive reads over memory regions to optimize that
access.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++++++++++
 include/soc/mscc/ocelot.h             |  4 ++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 7390fa3980ec..2067382d0ee1 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -10,6 +10,19 @@
 
 #include "ocelot.h"
 
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count)
+{
+	u16 target = reg >> TARGET_OFFSET;
+
+	WARN_ON(!target);
+
+	return regmap_bulk_read(ocelot->targets[target],
+				ocelot->map[target][reg & REG_MASK] + offset,
+				buf, count);
+}
+EXPORT_SYMBOL_GPL(__ocelot_bulk_read_ix);
+
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 {
 	u16 target = reg >> TARGET_OFFSET;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 62cd61d4142e..b66e5abe04a7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -744,6 +744,8 @@ struct ocelot_policer {
 	u32 burst; /* bytes */
 };
 
+#define ocelot_bulk_read_rix(ocelot, reg, ri, buf, count) __ocelot_bulk_read_ix(ocelot, reg, reg##_RSZ * (ri), buf, count)
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -786,6 +788,8 @@ struct ocelot_policer {
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg);
+int __ocelot_bulk_read_ix(struct ocelot *ocelot, u32 reg, u32 offset, void *buf,
+			  int count);
 u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
-- 
2.25.1

