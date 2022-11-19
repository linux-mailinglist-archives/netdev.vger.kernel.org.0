Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C88396311E6
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiKSXOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiKSXOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:14:34 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98611A3B3;
        Sat, 19 Nov 2022 15:14:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZr/izxSbbo3lYrJ7LLaH7/TKw6MVltvRtojG/1+K3EvVed+HlqijGQKgM77sKdPHtRzdoIOpz+RWIW78XWsjgEQ5Sxm5dcW7mae+/W7suMv2jP4H8vYq9X3UNL8F9RtHT/eQTL6w/9Cp3Xa9TF2uJ6N2t05OW7j1ZMPM2kzZfu8UEyl7XO+VjtaVNtzx/31hjaaHt7SdB3pqjO65r1gPg/8uM2BPgCZTyvseC+nTpll7Qg0iFsnJjvlN4OdDfRXPm3oB6ZpU4hOOuUBQDSSls7OtZg3J11RbMIpM05Box87cRgpv0lnY0h7WENbdr1Kmw/QSAAVsaOpZA3QB+qChg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NA83SgFLebyowtH7rp6jDbvYBsMZIMHJ0Y8kGiRJ6s=;
 b=MXIXxrjBoNBLY53KFXYWVSm/MQ/ybITAJbBO/2QeC06yguV9WHc2bv6Z4FNsXX+vZPFhglpM+noOIrfUejIcgrdV0deFar0haXqblJ/2zAKqPcIrRfqeVHcLYx7eK8SCHGGx1TxBKAcWdZOkbCec1Umb8dmFVGqucsZSmFHvc/bFaNOW9eSQDqAAO29SYJtsJoCBeFjKinxKcoMm9q0GAsY8Fhd5ZY/YGBNDTc5lIyYaLbnqynQ+r5LdtpGfBp8YhoQGfbHouNC2MJ/EBftnkZQWuSRAngOB4vDPCQPwCmWDP4woa1izeW7C+2LMEmEGLOS4HSjtnoM/xMkqR+LtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NA83SgFLebyowtH7rp6jDbvYBsMZIMHJ0Y8kGiRJ6s=;
 b=PZLkPpRrrHp/M1k0LN8jA4epm3gFQm4LcgFeEikOD7Px1/v0nL+44VxvU7KYX9uHWzr6YHN7MTxojX/fH9+71NTP0jLrT4PdwoFZd09lQ3Yc2r1/n6aYwwd7dBkjqs2qbO2yOpmA3Xpf9ppBYnb1QCngUcnC/86UAtSVIbllB5A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH2PR10MB4293.namprd10.prod.outlook.com
 (2603:10b6:610:7f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Sat, 19 Nov
 2022 23:14:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 23:14:24 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 2/3] net: mscc: ocelot: remove unnecessary exposure of stats structures
Date:   Sat, 19 Nov 2022 15:14:05 -0800
Message-Id: <20221119231406.3167852-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221119231406.3167852-1-colin.foster@in-advantage.com>
References: <20221119231406.3167852-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH2PR10MB4293:EE_
X-MS-Office365-Filtering-Correlation-Id: fbfce4a8-b681-498f-e48e-08daca83cc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ScS/Xc563qtZ1yw6gZ26XOpgraRINYxRwYVaZD+1UT7sgAz8/Drd/xDu4NVai5i72m6FtfkR6Y/Mmq8dugak9UOeERPr0mt7IxOnb11nBqFhY0LW6yR/7KbniocTBAcDOOIkfWtMTiftI1YMcRIlTtY8ndDGoC6rcQfGFstOTjqiP3ufUAWDrhQQnDsvLX7QoDiXzZSnjdIh8Fwyj7Nk7vzQfBMNFjk3RJh4rhns2ARgOc90oHGeS8L9ITklknOyboliOf1+tCbqCXBpYpoPv+9UDq+KWGiCfpdkHCm63rP+T4FHbG6s79bLB8ULkLr9RpAK8WqSK4nIuQkDbIwLw42oisH3sL1ENb+GShZ4J1oOt+/xSjibISfslBo8f/rI260i5/PdTJkpLhyDaqkgPDFFNo1clAMctRerLN/M+mxhgCMfRJZYWWrZe2IvedVIes6Za2RfSEPKAeWLgFlMpAHXAm6EouAoXD/nqA92B0Y1imSSSTzu4aO0LJObixu8qvBTkoCFeDiLbZ90/R+wDFWFC9rCLdl3hwL7QCKIuxyYUTIlGRQO9P3InSYDscj7unvYGIbbKRzoxIog+pr3lK6FTrkBQVDlEKZyiEwxkZYUzAJt/qoASax8U9QcOPI86pMFS36nA61Oj9gs3HNt7ct2fRh5Md2Q9AMPFM6JRLLaoUwiF47fsmvtnHZja2Ag
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39830400003)(346002)(451199015)(2906002)(26005)(86362001)(83380400001)(6512007)(4326008)(8676002)(66476007)(66556008)(66946007)(38350700002)(38100700002)(36756003)(41300700001)(30864003)(44832011)(54906003)(8936002)(5660300002)(316002)(186003)(7416002)(52116002)(478600001)(1076003)(6666004)(6486002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3fkkAu7SASbh4Dlwds5FZAiFKLBqIc2xJLv1ZZ+QPdD+ytlXMJL2A3VNU5ND?=
 =?us-ascii?Q?JfIGEOp5EvwGFDlDH9o15ZzFhhma0//fY+CB2GRipDvdNjP8McFCTSrLDVUI?=
 =?us-ascii?Q?9NGRqs1Yy2C6pDt7Lw/CIOcIaXfoSBJao9qrj05RbKNo8/tgKe/lE0nQZK44?=
 =?us-ascii?Q?yvmv+2Oj+WxmFNXbOJusYmLW/4nGdD9YACwbTheGTUJIn7UjsOdJhHAwbOO1?=
 =?us-ascii?Q?YWJWv+c0QiqS1IPoy+1N362ux4DD7RQAd42/wUMK6bACeerDyemytJiKGXxh?=
 =?us-ascii?Q?WMhq5FUSo+e7VCR5Py0Me2FoIjGGxc1Oy6KhqltebA2G5I9ofDp/p5Y2Icgb?=
 =?us-ascii?Q?qeAqSCXiUk9Q4MLniLhUW82p+2icLMXLdYjr6IrzFB5LNlRzZZRLC7Nk4N5n?=
 =?us-ascii?Q?fT61ib4ZmYnYh4ymYomh/2DC5Dr9RJQxdtWm3165fM/PXuPRWgXNWTK2m8pU?=
 =?us-ascii?Q?7vpszsC87zZ5DsCKBpYitxTWpevKFWxc/jS0+U16MDTx4T/1cGAtUK4lp6Z9?=
 =?us-ascii?Q?BLZF/GyLrY/mfpvYi1mtOu1zF5NHzXfu5II2WJibD/5bzPrj8ix16Wk35CER?=
 =?us-ascii?Q?ABmywACNlhWW8tpsfzEkyxWutpGfFxHYL6d7ctPK/+b39XjXtdZl1f+MotgF?=
 =?us-ascii?Q?SAAI64GFUSEWzDplgr63IR+JtkXnI9p9zpFswWZBg9mRmdZ55lv18lMw7rHP?=
 =?us-ascii?Q?FyIB52fpyEHkcUvXqOnCdOx3LcZMr5b5bepB+Q+1zmgBfPH5BGA+o9K97Gl1?=
 =?us-ascii?Q?35wE9lCPxjmVhXBlUExsmmQsVvYP24DHOc2l/wpgOZraCD60PX1/sM5/SoAA?=
 =?us-ascii?Q?3gqNppuA5sVeI4+dpGAjanWX0G/gJemxa1KljJDPZ7bCX6vyAig6A+Uzeanx?=
 =?us-ascii?Q?XDOKXC6FNlATYgjowu1fQt2tzVH4ptfp5VFN0IM55hzDs9cmqvr4v8lRQRfu?=
 =?us-ascii?Q?qv8LwB5AOKuYM+1+irgURK567DnWNlOjvG0Bq9IZkoLXgtC3aqhpeGppQg13?=
 =?us-ascii?Q?uvSn4ifNjg/fb8j96WO731WNBnQaT3LXxG5imy3n5sp9B0VtnHBrjQNxhTx1?=
 =?us-ascii?Q?5qEICXMD28+43boPapbhLLInEgCIItMltW3+23o4djodjbI1Sury8ch6xxhE?=
 =?us-ascii?Q?AuuSMKtRUmPvK0eZukiHFwllnR+nNT5bzQPmiUwAry1mipJUc7frFKW+icmb?=
 =?us-ascii?Q?8vh1AFbriA9VATJsVJK+kuoQ/cMBFE8dWy4d0CZMKubiMgk/VBNQOyKmL84S?=
 =?us-ascii?Q?D59E+lEe1fB2Vm26EHd0d2HVQIBYI+RMOSZRg4bqa73jnAraS/WiBaCZ1dtA?=
 =?us-ascii?Q?CltOo8RNa50/V46xyH4ZMCyMHt2pbDrLq+oauAH/EVN6Ry4m/1WjTjSaI0ba?=
 =?us-ascii?Q?Wpa6nKfqrbbbq2JRffqeSaa8nr6YRz/4xEVyzlTGl6AkogfaCFjOyN7UThB+?=
 =?us-ascii?Q?/Q1YdjvdkY7oKhCa5v+W9MC/TQYmJXiQM0akeF+BgM257eoZL99XB83AjWVI?=
 =?us-ascii?Q?WvFIC9W023Ev434QdG581qrGc6LYyU2/VI3RtEeNEXCC1DmLVWvpb8Gn7QqJ?=
 =?us-ascii?Q?u4KKtYwE80zHhEd/cVv+vJEPPek3jc+pMbNNDaFL4FiokEQjMonM1QmWcio9?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfce4a8-b681-498f-e48e-08daca83cc69
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 23:14:24.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BK5dOwrgUXS51vBwKImZQ0TRnLdT0fFdLlgxT0mTGio9+6rbjaB96bznROtSITQUmlw/PGIvjBw3CZo5QRtEWnTp/HevGlegy8++sIi52i0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4293
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 4d1d157fb6a4 ("net: mscc: ocelot: share the common stat
definitions between all drivers") there is no longer a need to share the
stats structures to the world. Relocate these definitions to inside
ocelot_stats.c instead of a global include header.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1->v2
    * No change

---
 drivers/net/ethernet/mscc/ocelot_stats.c | 216 +++++++++++++++++++++++
 include/soc/mscc/ocelot.h                | 215 ----------------------
 2 files changed, 216 insertions(+), 215 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index 5dc132f61d6a..68e9f450c468 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -9,6 +9,221 @@
 #include <linux/workqueue.h>
 #include "ocelot.h"
 
+enum ocelot_stat {
+	OCELOT_STAT_RX_OCTETS,
+	OCELOT_STAT_RX_UNICAST,
+	OCELOT_STAT_RX_MULTICAST,
+	OCELOT_STAT_RX_BROADCAST,
+	OCELOT_STAT_RX_SHORTS,
+	OCELOT_STAT_RX_FRAGMENTS,
+	OCELOT_STAT_RX_JABBERS,
+	OCELOT_STAT_RX_CRC_ALIGN_ERRS,
+	OCELOT_STAT_RX_SYM_ERRS,
+	OCELOT_STAT_RX_64,
+	OCELOT_STAT_RX_65_127,
+	OCELOT_STAT_RX_128_255,
+	OCELOT_STAT_RX_256_511,
+	OCELOT_STAT_RX_512_1023,
+	OCELOT_STAT_RX_1024_1526,
+	OCELOT_STAT_RX_1527_MAX,
+	OCELOT_STAT_RX_PAUSE,
+	OCELOT_STAT_RX_CONTROL,
+	OCELOT_STAT_RX_LONGS,
+	OCELOT_STAT_RX_CLASSIFIED_DROPS,
+	OCELOT_STAT_RX_RED_PRIO_0,
+	OCELOT_STAT_RX_RED_PRIO_1,
+	OCELOT_STAT_RX_RED_PRIO_2,
+	OCELOT_STAT_RX_RED_PRIO_3,
+	OCELOT_STAT_RX_RED_PRIO_4,
+	OCELOT_STAT_RX_RED_PRIO_5,
+	OCELOT_STAT_RX_RED_PRIO_6,
+	OCELOT_STAT_RX_RED_PRIO_7,
+	OCELOT_STAT_RX_YELLOW_PRIO_0,
+	OCELOT_STAT_RX_YELLOW_PRIO_1,
+	OCELOT_STAT_RX_YELLOW_PRIO_2,
+	OCELOT_STAT_RX_YELLOW_PRIO_3,
+	OCELOT_STAT_RX_YELLOW_PRIO_4,
+	OCELOT_STAT_RX_YELLOW_PRIO_5,
+	OCELOT_STAT_RX_YELLOW_PRIO_6,
+	OCELOT_STAT_RX_YELLOW_PRIO_7,
+	OCELOT_STAT_RX_GREEN_PRIO_0,
+	OCELOT_STAT_RX_GREEN_PRIO_1,
+	OCELOT_STAT_RX_GREEN_PRIO_2,
+	OCELOT_STAT_RX_GREEN_PRIO_3,
+	OCELOT_STAT_RX_GREEN_PRIO_4,
+	OCELOT_STAT_RX_GREEN_PRIO_5,
+	OCELOT_STAT_RX_GREEN_PRIO_6,
+	OCELOT_STAT_RX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_OCTETS,
+	OCELOT_STAT_TX_UNICAST,
+	OCELOT_STAT_TX_MULTICAST,
+	OCELOT_STAT_TX_BROADCAST,
+	OCELOT_STAT_TX_COLLISION,
+	OCELOT_STAT_TX_DROPS,
+	OCELOT_STAT_TX_PAUSE,
+	OCELOT_STAT_TX_64,
+	OCELOT_STAT_TX_65_127,
+	OCELOT_STAT_TX_128_255,
+	OCELOT_STAT_TX_256_511,
+	OCELOT_STAT_TX_512_1023,
+	OCELOT_STAT_TX_1024_1526,
+	OCELOT_STAT_TX_1527_MAX,
+	OCELOT_STAT_TX_YELLOW_PRIO_0,
+	OCELOT_STAT_TX_YELLOW_PRIO_1,
+	OCELOT_STAT_TX_YELLOW_PRIO_2,
+	OCELOT_STAT_TX_YELLOW_PRIO_3,
+	OCELOT_STAT_TX_YELLOW_PRIO_4,
+	OCELOT_STAT_TX_YELLOW_PRIO_5,
+	OCELOT_STAT_TX_YELLOW_PRIO_6,
+	OCELOT_STAT_TX_YELLOW_PRIO_7,
+	OCELOT_STAT_TX_GREEN_PRIO_0,
+	OCELOT_STAT_TX_GREEN_PRIO_1,
+	OCELOT_STAT_TX_GREEN_PRIO_2,
+	OCELOT_STAT_TX_GREEN_PRIO_3,
+	OCELOT_STAT_TX_GREEN_PRIO_4,
+	OCELOT_STAT_TX_GREEN_PRIO_5,
+	OCELOT_STAT_TX_GREEN_PRIO_6,
+	OCELOT_STAT_TX_GREEN_PRIO_7,
+	OCELOT_STAT_TX_AGED,
+	OCELOT_STAT_DROP_LOCAL,
+	OCELOT_STAT_DROP_TAIL,
+	OCELOT_STAT_DROP_YELLOW_PRIO_0,
+	OCELOT_STAT_DROP_YELLOW_PRIO_1,
+	OCELOT_STAT_DROP_YELLOW_PRIO_2,
+	OCELOT_STAT_DROP_YELLOW_PRIO_3,
+	OCELOT_STAT_DROP_YELLOW_PRIO_4,
+	OCELOT_STAT_DROP_YELLOW_PRIO_5,
+	OCELOT_STAT_DROP_YELLOW_PRIO_6,
+	OCELOT_STAT_DROP_YELLOW_PRIO_7,
+	OCELOT_STAT_DROP_GREEN_PRIO_0,
+	OCELOT_STAT_DROP_GREEN_PRIO_1,
+	OCELOT_STAT_DROP_GREEN_PRIO_2,
+	OCELOT_STAT_DROP_GREEN_PRIO_3,
+	OCELOT_STAT_DROP_GREEN_PRIO_4,
+	OCELOT_STAT_DROP_GREEN_PRIO_5,
+	OCELOT_STAT_DROP_GREEN_PRIO_6,
+	OCELOT_STAT_DROP_GREEN_PRIO_7,
+	OCELOT_NUM_STATS,
+};
+
+struct ocelot_stat_layout {
+	u32 reg;
+	char name[ETH_GSTRING_LEN];
+};
+
+/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
+ * and copied to ocelot->stats.
+ */
+#define OCELOT_STAT(kind) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind }
+/* Same as above, except also exported to ethtool -S. Standard counters should
+ * only be exposed to more specific interfaces rather than by their string name.
+ */
+#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
+	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
+
+#define OCELOT_COMMON_STATS \
+	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
+	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
+	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
+	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
+	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
+	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
+	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
+	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
+	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
+	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
+	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
+	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
+	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
+	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
+	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
+	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
+	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
+	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
+	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
+	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
+
+struct ocelot_stats_region {
+	struct list_head node;
+	u32 base;
+	int count;
+	u32 *buf;
+};
+
 static const struct ocelot_stat_layout ocelot_stats_layout[OCELOT_NUM_STATS] = {
 	OCELOT_COMMON_STATS,
 };
@@ -460,3 +675,4 @@ void ocelot_stats_deinit(struct ocelot *ocelot)
 	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 }
+
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 995b5950afe6..df62be80a193 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -596,221 +596,6 @@ enum ocelot_ptp_pins {
 	TOD_ACC_PIN
 };
 
-enum ocelot_stat {
-	OCELOT_STAT_RX_OCTETS,
-	OCELOT_STAT_RX_UNICAST,
-	OCELOT_STAT_RX_MULTICAST,
-	OCELOT_STAT_RX_BROADCAST,
-	OCELOT_STAT_RX_SHORTS,
-	OCELOT_STAT_RX_FRAGMENTS,
-	OCELOT_STAT_RX_JABBERS,
-	OCELOT_STAT_RX_CRC_ALIGN_ERRS,
-	OCELOT_STAT_RX_SYM_ERRS,
-	OCELOT_STAT_RX_64,
-	OCELOT_STAT_RX_65_127,
-	OCELOT_STAT_RX_128_255,
-	OCELOT_STAT_RX_256_511,
-	OCELOT_STAT_RX_512_1023,
-	OCELOT_STAT_RX_1024_1526,
-	OCELOT_STAT_RX_1527_MAX,
-	OCELOT_STAT_RX_PAUSE,
-	OCELOT_STAT_RX_CONTROL,
-	OCELOT_STAT_RX_LONGS,
-	OCELOT_STAT_RX_CLASSIFIED_DROPS,
-	OCELOT_STAT_RX_RED_PRIO_0,
-	OCELOT_STAT_RX_RED_PRIO_1,
-	OCELOT_STAT_RX_RED_PRIO_2,
-	OCELOT_STAT_RX_RED_PRIO_3,
-	OCELOT_STAT_RX_RED_PRIO_4,
-	OCELOT_STAT_RX_RED_PRIO_5,
-	OCELOT_STAT_RX_RED_PRIO_6,
-	OCELOT_STAT_RX_RED_PRIO_7,
-	OCELOT_STAT_RX_YELLOW_PRIO_0,
-	OCELOT_STAT_RX_YELLOW_PRIO_1,
-	OCELOT_STAT_RX_YELLOW_PRIO_2,
-	OCELOT_STAT_RX_YELLOW_PRIO_3,
-	OCELOT_STAT_RX_YELLOW_PRIO_4,
-	OCELOT_STAT_RX_YELLOW_PRIO_5,
-	OCELOT_STAT_RX_YELLOW_PRIO_6,
-	OCELOT_STAT_RX_YELLOW_PRIO_7,
-	OCELOT_STAT_RX_GREEN_PRIO_0,
-	OCELOT_STAT_RX_GREEN_PRIO_1,
-	OCELOT_STAT_RX_GREEN_PRIO_2,
-	OCELOT_STAT_RX_GREEN_PRIO_3,
-	OCELOT_STAT_RX_GREEN_PRIO_4,
-	OCELOT_STAT_RX_GREEN_PRIO_5,
-	OCELOT_STAT_RX_GREEN_PRIO_6,
-	OCELOT_STAT_RX_GREEN_PRIO_7,
-	OCELOT_STAT_TX_OCTETS,
-	OCELOT_STAT_TX_UNICAST,
-	OCELOT_STAT_TX_MULTICAST,
-	OCELOT_STAT_TX_BROADCAST,
-	OCELOT_STAT_TX_COLLISION,
-	OCELOT_STAT_TX_DROPS,
-	OCELOT_STAT_TX_PAUSE,
-	OCELOT_STAT_TX_64,
-	OCELOT_STAT_TX_65_127,
-	OCELOT_STAT_TX_128_255,
-	OCELOT_STAT_TX_256_511,
-	OCELOT_STAT_TX_512_1023,
-	OCELOT_STAT_TX_1024_1526,
-	OCELOT_STAT_TX_1527_MAX,
-	OCELOT_STAT_TX_YELLOW_PRIO_0,
-	OCELOT_STAT_TX_YELLOW_PRIO_1,
-	OCELOT_STAT_TX_YELLOW_PRIO_2,
-	OCELOT_STAT_TX_YELLOW_PRIO_3,
-	OCELOT_STAT_TX_YELLOW_PRIO_4,
-	OCELOT_STAT_TX_YELLOW_PRIO_5,
-	OCELOT_STAT_TX_YELLOW_PRIO_6,
-	OCELOT_STAT_TX_YELLOW_PRIO_7,
-	OCELOT_STAT_TX_GREEN_PRIO_0,
-	OCELOT_STAT_TX_GREEN_PRIO_1,
-	OCELOT_STAT_TX_GREEN_PRIO_2,
-	OCELOT_STAT_TX_GREEN_PRIO_3,
-	OCELOT_STAT_TX_GREEN_PRIO_4,
-	OCELOT_STAT_TX_GREEN_PRIO_5,
-	OCELOT_STAT_TX_GREEN_PRIO_6,
-	OCELOT_STAT_TX_GREEN_PRIO_7,
-	OCELOT_STAT_TX_AGED,
-	OCELOT_STAT_DROP_LOCAL,
-	OCELOT_STAT_DROP_TAIL,
-	OCELOT_STAT_DROP_YELLOW_PRIO_0,
-	OCELOT_STAT_DROP_YELLOW_PRIO_1,
-	OCELOT_STAT_DROP_YELLOW_PRIO_2,
-	OCELOT_STAT_DROP_YELLOW_PRIO_3,
-	OCELOT_STAT_DROP_YELLOW_PRIO_4,
-	OCELOT_STAT_DROP_YELLOW_PRIO_5,
-	OCELOT_STAT_DROP_YELLOW_PRIO_6,
-	OCELOT_STAT_DROP_YELLOW_PRIO_7,
-	OCELOT_STAT_DROP_GREEN_PRIO_0,
-	OCELOT_STAT_DROP_GREEN_PRIO_1,
-	OCELOT_STAT_DROP_GREEN_PRIO_2,
-	OCELOT_STAT_DROP_GREEN_PRIO_3,
-	OCELOT_STAT_DROP_GREEN_PRIO_4,
-	OCELOT_STAT_DROP_GREEN_PRIO_5,
-	OCELOT_STAT_DROP_GREEN_PRIO_6,
-	OCELOT_STAT_DROP_GREEN_PRIO_7,
-	OCELOT_NUM_STATS,
-};
-
-struct ocelot_stat_layout {
-	u32 reg;
-	char name[ETH_GSTRING_LEN];
-};
-
-/* 32-bit counter checked for wraparound by ocelot_port_update_stats()
- * and copied to ocelot->stats.
- */
-#define OCELOT_STAT(kind) \
-	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind }
-/* Same as above, except also exported to ethtool -S. Standard counters should
- * only be exposed to more specific interfaces rather than by their string name.
- */
-#define OCELOT_STAT_ETHTOOL(kind, ethtool_name) \
-	[OCELOT_STAT_ ## kind] = { .reg = SYS_COUNT_ ## kind, .name = ethtool_name }
-
-#define OCELOT_COMMON_STATS \
-	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
-	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
-	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
-	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
-	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
-	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
-	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
-	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
-	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
-	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
-	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
-	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
-	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
-	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
-	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
-	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
-	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
-	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
-	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
-	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
-	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
-	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
-	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
-
-struct ocelot_stats_region {
-	struct list_head node;
-	u32 base;
-	int count;
-	u32 *buf;
-};
-
 enum ocelot_tag_prefix {
 	OCELOT_TAG_PREFIX_DISABLED	= 0,
 	OCELOT_TAG_PREFIX_NONE,
-- 
2.25.1

