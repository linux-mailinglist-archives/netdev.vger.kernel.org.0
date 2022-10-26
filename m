Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCDE60E89A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 21:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiJZTJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 15:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbiJZTIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 15:08:21 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2069.outbound.protection.outlook.com [40.107.20.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EFEF971D
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 12:06:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mftGlOSCOwbYwgBn4aqFO0DuJKCpSINNh4Y5iF0cqgLYBnSvrurbx/5MfQXmFIpcd++q8JrrYWQVq+QqQAmn3WHzrYtOv7EXLJnk4W79pTixj6BkXv/qedIF49fCVBrogoe0M6DBbNMXfhoqqTMMcMxetpuJoxLtDDDUX6HOu1Z5hSmH7NM9ZYl59oA0snwEan0ZzAIgrY3Skf1Bm5f5y3Pr3Mxqa9/ouTO+gndWGMw3VyBD4COWrxsMbetuXwqtZw4yHlDphTG0o/UeNvIVHXmqTTbdBTTVjRA8iTYN/E3mSAAsK2lpTkwURr29QbWEqDmXbmak7n1eDqES5dBk4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4tO+H/P/xJNyA5GdRLoXNzDiWpjmQu/AxLMx5+hoYw=;
 b=K+vKewIb66TXQScAFeWPhvfo0WE77mBpPtdZ2MMxGlmVF/zCZO/uQtlC7sCFd+NuMph9zvsQDLAfD44x8QBh9060Mabj18kDCxY/JZBltbWHiUqhtr1062Dx29hIOk+oTefwWxvWMOkxw2GRaU6cKr/jqqwDKJv3JgVP28Wi1i2XykpGa6anrj/atC0RP6L5RF/DqNCefLdPRGI4hBxDu2bVloDNLibzkm7wSNoSJAfWIIUNya4Og0axn2uLDYauzQ9rlaxLv72YWOxY/+B1g9HKfvz5VaA6VmzOSidmYc9TLZVDVFUZND4n3u+Vuw9ukuEIsFijW1LdhB60sKc08w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E4tO+H/P/xJNyA5GdRLoXNzDiWpjmQu/AxLMx5+hoYw=;
 b=OdhksSwe6y4RS9m2d9zin6St4tn/Lb5NXp8FAEOK5uhqkvdP+OINEnskdFbhKy3PLez7suKl5t6NtAhbdv4o1zzD+Kuj+8gKa0W6t1BDK1v1giLMcYe1uv9KujWBVAUFLdwyJGViMYkxzEE7/eXK3Si/DCOlYT/IEHHZz15tVuE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8602.eurprd04.prod.outlook.com (2603:10a6:20b:439::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 19:06:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.023; Wed, 26 Oct 2022
 19:06:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH ethtool] fsl_enetc: add support for NXP ENETC driver
Date:   Wed, 26 Oct 2022 22:05:52 +0300
Message-Id: <20221026190552.2415266-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8602:EE_
X-MS-Office365-Filtering-Correlation-Id: 906242a4-fc5f-4455-1d74-08dab785218e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Py3eyGhpXuiozkdwKxRPJvGSFyRVbgvFFpPRESz98uSRzHjy1Rv2CP7qfYQ69UVJe7GA7mT7E/bOLS8OdYQwmW1PJLmcCu/Ku7OPTaOqX/cq67765IOchrl6Lr0oxk5VwUXvtYaKTRXbDR/xGMx1mIjTLB7AFfFq0QLoCEoSN3dGTmjWW4BOEO33Rqj5MwVw4lcmGyjYeLyaANGEOQ3hSrK9DzDJNdyyCp+y4K5VFlQEk03Y9Y+4/5vJohUqGMYZcwSeWf6iq/Hjxf1jD0h//KGfh98PfzNlbIcIheM+pKermStEwHNmki1SvVbT5ATEKWe1cBGFT1Jjfv1SPHQP3LuCqifYhHU99/uh6mx9kfKLMjjMvBXCGdDqLt1FkSgly3ZIyGPYH1q2Gt3FbRzKodU/A5mQHyxy89+EFSWIp1RSZzhQZnDOjLZgvpCr5qprlUhTsorosSSXrhXK1dpzzKnumJ98YRmQ584PPMUj830PMVDG2of/+g+Pbsw6DsRu2WcIsSjISJUNqEQwlx/ND9JtzG9Tp62pD20nyrQSris1KBzEGpd1W24fAihUrXQQraO4oiTsLEBxJIlMLPN47AdM4A0XYCjRptwxS9wrBOac1aCDfKSSYXwUppQ1lyjlxqu7UbQx0GNLBbDk1/+wQyNRwX/9Fg2dZCHpsX6IH2iWjSC+wzUeYVQpumU0kNB/InA4RWX9nFBdRWjr41nEJ4EAlM7rjxIOyZKes5Ct3oIurHhbK+b5TJstvlVPHLaCRD1i2a9SWij+NrkxMo1Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(136003)(376002)(39860400002)(451199015)(38100700002)(8676002)(36756003)(66476007)(316002)(66946007)(38350700002)(83380400001)(66556008)(41300700001)(6486002)(4326008)(478600001)(5660300002)(6916009)(54906003)(30864003)(44832011)(8936002)(1076003)(186003)(2616005)(6512007)(2906002)(86362001)(52116002)(26005)(6666004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m0Vo88cD4G9OZhr90bNzs6s78utMGQwc3YUBbVwATjgIB8DNdoWxjDby0WEH?=
 =?us-ascii?Q?N+lEl6dxfiMMXKhtlYs7GsdWJjQoKgJwH2yuBydygQaqLHDpSvreTaE784dP?=
 =?us-ascii?Q?sG76JDUq6i/vqAG3N3hb90f1gD7sVEtIY9ioyfcu2O7lLTmHy+KObzwBMFU2?=
 =?us-ascii?Q?zt1mxGkiFSgRh7/OhohG6Sal6tGoA704HStepNdAdjesZCf4hVlvl8L5JXaI?=
 =?us-ascii?Q?jJEwee8qeqbc01uR5PvJB8uO0FYoh170mDv4/WR64fHBKSwjseQxSdKlz467?=
 =?us-ascii?Q?c2IFyqoIHe4CowOxEbJ3BLfe6Uoei5/BDXhpK4IQFNoy1/PHty89hkOz64bN?=
 =?us-ascii?Q?JcfHUoss43rtx8uQl5vxB6QtHFg6jWce/sJzMYja9MWbWP/PfGf/pgEW161Y?=
 =?us-ascii?Q?KxFauUx5lVKpZbzpmM9TPma1G6kF6ZpnVBpdPIA1oFVst55xl4xwFHQdKiyM?=
 =?us-ascii?Q?HTUTWfVfj/A0DTuhgs2KGCIazz4F4NR5pQAwzV9Wiohyyvwgy2aCuWfL9IWv?=
 =?us-ascii?Q?XhfwqrwubW67HVmueRUheeN5/aKy7gBd/nWquJIZmbejm/EKdooQiRL+AFac?=
 =?us-ascii?Q?63Ml9TRvd/xPfdVHHhgsnnQioZbvyxeMMua+4COurZ/Bn72NX/anDtcJaZl/?=
 =?us-ascii?Q?oUoAZwav/9Eigm74FIBnhNHhsXbAPw8CMzEohWp5kSq0qc3oaDRLxynii4nr?=
 =?us-ascii?Q?5MA99w5P71hDruaZe5WAiYFO9cDCuokuBncucDUxtBiH2kucYA19NJLUfTFN?=
 =?us-ascii?Q?b7NO3xUJ+/I5BplbDbeMoni1yDQWC11keLHpQ+eON3XmkuHMF2eJz50FgThG?=
 =?us-ascii?Q?/oBRLCliezzVC8LBGc6G++U+C0KZQzqWAj2ZFqRU53ShcGHn3ZG8EI01mUOt?=
 =?us-ascii?Q?y/pzGkVmmKFE0K8bmo4lLlmmDsSam7hBb5NpqPhicbQS1zXaT14rI/fFA2Np?=
 =?us-ascii?Q?GpoEGWsrkMErqd+RJkI9uNImt1uTn3vKiTyBWqQGiEQ6sLoJ4BWrzqoLt8nh?=
 =?us-ascii?Q?l7u40gdcc39FIWXaPu8OXULqYNTd/P9bSfMmfVPeHJZSRZksf9rfl5BPV578?=
 =?us-ascii?Q?bWq722jYdZ9vwwAPECQTSgpcZp4ymYZ55eGYOZEvTn0yaKNpysJiFICv2M3/?=
 =?us-ascii?Q?uK4haobPzeop5PduDSnxVsevjD2MpElmJZtRAL8tG9/ooyOZz8v8NjXMngBq?=
 =?us-ascii?Q?C9vnbWDWyJcWTCHVjXKtUWXzY/Jm46M6aE/0KBmvgEPrQvcgLuIIUP7LH0wS?=
 =?us-ascii?Q?wkGoIZYx9R5m/FvBNyMEJiezFqEujVBY0voWY6enIDyHcUeLVuxME/1gO5VF?=
 =?us-ascii?Q?57tjcsBYbIAdbsqjz6b4cUac+ScCIRwtArMG8OeSuHoDKNrGizIHI2cov5BG?=
 =?us-ascii?Q?uy9FATXDbikzen0Q0B1JL6tTFk4p22DQsPMgfiER9tcS6UoyRKNNEQHUT8Ns?=
 =?us-ascii?Q?Xjp4oQyaVIVL0wg1Q3eXZFO4r5TsG5bodmJoLzVNUe48PPMZXHr7p5ySNFK1?=
 =?us-ascii?Q?5nCHfpkwrAvqadOn0ardnIprme148uz1yI7nj1ZOcKdUbvCrIw+T8Sv84CPd?=
 =?us-ascii?Q?Gvle6tTKCidDP+d/tp8/lBq8w8eAnp8NpxasvAJOQNio8Bj+Jzc8HNebuMeP?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 906242a4-fc5f-4455-1d74-08dab785218e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 19:06:04.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: waKe1LAUADAU3C6wYScQGdIQu/w7GlgzkxJO5+91CJSNZOmpiNqOb07X4JeZbY16yXVPR4yMFFoio6+vu4yJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8602
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pretty printer for the registers which the enetc PF and VF drivers
support since their introduction in kernel v5.1. The selection of
registers parsed is the selection exported by the kernel as of v6.1-rc2.
Unparsed registers are printed as raw.

One register is printed field by field (MAC COMMAND_CONFIG), I didn't
have time/interest in printing more than 1. The rest are printed in hex.

Sample output:

$ ethtool -d eno0
SI mode register: 0x80000000
SI primary MAC address register 0: 0x59f0400
SI primary MAC address register 1: 0x27f6
SI control BDR mode register: 0x40000000
SI control BDR status register: 0x0
SI control BDR base address register 0: 0x8262f000
SI control BDR base address register 1: 0x20
SI control BDR producer index register: 0x3a
SI control BDR consumer index register: 0x3a
SI control BDR length register: 0x40
SI capability register 0: 0x10080008
SI capability register 1: 0x20002
SI uncorrectable error frame drop count register: 0x0
TX BDR 0 mode register: 0x80000200
TX BDR 0 status register: 0x0
TX BDR 0 base address register 0: 0xebfa0000
TX BDR 0 base address register 1: 0x0
TX BDR 0 producer index register: 0x12
TX BDR 0 consumer index register: 0x12
TX BDR 0 length register: 0x800
TX BDR 0 interrupt enable register: 0x1
TX BDR 0 interrupt coalescing register 0: 0x80000008
TX BDR 0 interrupt coalescing register 1: 0x3a980
(repeats for other TX rings)
RX BDR 0 mode register: 0x80000034
RX BDR 0 status register: 0x0
RX BDR 0 buffer size register: 0x680
RX BDR 0 consumer index register: 0x7ff
RX BDR 0 base address register 0: 0xec430000
RX BDR 0 base address register 1: 0x0
RX BDR 0 producer index register: 0x0
RX BDR 0 length register: 0x800
RX BDR 0 interrupt enable register: 0x1
RX BDR 0 interrupt coalescing register 0: 0x80000100
RX BDR 0 interrupt coalescing register 1: 0x1
(repeats for other RX rings)
Port mode register: 0x70200
Port status register: 0x0
Port SI promiscuous mode register: 0x0
Port SI0 primary MAC address register 0: 0x59f0400
Port SI0 primary MAC address register 1: 0x27f6
Port HTA transmit memory buffer allocation register: 0xc390
Port capability register 0: 0x10101b3c
Port capability register 1: 0x2070
Port SI0 configuration register 0: 0x3080008
Port RFS capability register: 0x2
Port traffic class 0 maximum SDU register: 0x2580
Port eMAC Command and Configuration Register: 0x8813
        MG 0
        RXSTP 0
        REG_LOWP_RXETY 0
        TX_LOWP_ENA 0
        SFD 0
        NO_LEN_CHK 0
        SEND_IDLE 0
        CNT_FRM_EN 0
        SWR 0
        TXP 1
        XGLP 0
        TX_ADDR_INS 0
        PAUSE_IGN 0
        PAUSE_FWD 0
        CRC 0
        PAD 0
        PROMIS 1
        WAN 0
        RX_EN 1
        TX_EN 1
Port eMAC Maximum Frame Length Register: 0x2580
Port eMAC Interface Mode Control Register: 0x1002

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Makefile.am |   4 +-
 ethtool.c   |   2 +
 fsl_enetc.c | 259 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 internal.h  |   3 +
 4 files changed, 266 insertions(+), 2 deletions(-)
 create mode 100644 fsl_enetc.c

diff --git a/Makefile.am b/Makefile.am
index 21fa91a58453..0bd41dd4600e 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -13,8 +13,8 @@ ethtool_SOURCES = ethtool.c uapi/linux/ethtool.h internal.h \
 if ETHTOOL_ENABLE_PRETTY_DUMP
 ethtool_SOURCES += \
 		  amd8111e.c de2104x.c dsa.c e100.c e1000.c et131x.c igb.c	\
-		  fec.c fec_8xx.c ibm_emac.c ixgb.c ixgbe.c natsemi.c	\
-		  pcnet32.c realtek.c tg3.c marvell.c vioc.c	\
+		  fec.c fec_8xx.c fsl_enetc.c ibm_emac.c ixgb.c ixgbe.c \
+		  natsemi.c pcnet32.c realtek.c tg3.c marvell.c vioc.c \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
diff --git a/ethtool.c b/ethtool.c
index 96cef4630693..f15a7cef60ab 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1131,6 +1131,8 @@ static const struct {
 	{ "bnxt_en", bnxt_dump_regs },
 	{ "cpsw-switch", cpsw_dump_regs },
 	{ "lan743x", lan743x_dump_regs },
+	{ "fsl_enetc", fsl_enetc_dump_regs },
+	{ "fsl_enetc_vf", fsl_enetc_dump_regs },
 };
 #endif
 
diff --git a/fsl_enetc.c b/fsl_enetc.c
new file mode 100644
index 000000000000..c39f5cb3ce3f
--- /dev/null
+++ b/fsl_enetc.c
@@ -0,0 +1,259 @@
+/* Code to dump registers for the Freescale/NXP ENETC controller.
+ *
+ * Copyright 2022 NXP
+ */
+#include <stdio.h>
+#include "internal.h"
+
+#define BIT(x)			(1 << (x))
+
+enum enetc_bdr_type {TX, RX};
+#define ENETC_SIMR		0
+#define ENETC_SIPMAR0		0x80
+#define ENETC_SIPMAR1		0x84
+#define ENETC_SICBDRMR		0x800
+#define ENETC_SICBDRSR		0x804
+#define ENETC_SICBDRBAR0	0x810
+#define ENETC_SICBDRBAR1	0x814
+#define ENETC_SICBDRPIR		0x818
+#define ENETC_SICBDRCIR		0x81c
+#define ENETC_SICBDRLENR	0x820
+#define ENETC_SICAPR0		0x900
+#define ENETC_SICAPR1		0x904
+#define ENETC_SIUEFDCR		0xe28
+
+#define ENETC_BDR_OFF(i)	((i) * 0x200)
+#define ENETC_BDR(t, i, r)	(0x8000 + (t) * 0x100 + ENETC_BDR_OFF(i) + (r))
+
+/* RX BDR reg offsets */
+#define ENETC_RBMR		0
+#define ENETC_RBSR		0x4
+#define ENETC_RBBSR		0x8
+#define ENETC_RBCIR		0xc
+#define ENETC_RBBAR0		0x10
+#define ENETC_RBBAR1		0x14
+#define ENETC_RBPIR		0x18
+#define ENETC_RBLENR		0x20
+#define ENETC_RBIER		0xa0
+#define ENETC_RBICR0		0xa8
+#define ENETC_RBICR1		0xac
+
+/* TX BDR reg offsets */
+#define ENETC_TBMR		0
+#define ENETC_TBSR		0x4
+#define ENETC_TBBAR0		0x10
+#define ENETC_TBBAR1		0x14
+#define ENETC_TBPIR		0x18
+#define ENETC_TBCIR		0x1c
+#define ENETC_TBLENR		0x20
+#define ENETC_TBIER		0xa0
+#define ENETC_TBIDR		0xa4
+#define ENETC_TBICR0		0xa8
+#define ENETC_TBICR1		0xac
+
+/* Port registers */
+#define ENETC_PORT_BASE		0x10000
+#define ENETC_PMR		ENETC_PORT_BASE + 0x0000
+#define ENETC_PSR		ENETC_PORT_BASE + 0x0004
+#define ENETC_PSIPMR		ENETC_PORT_BASE + 0x0018
+#define ENETC_PSIPMAR0(n)	ENETC_PORT_BASE + (0x0100 + (n) * 0x8) /* n = SI index */
+#define ENETC_PSIPMAR1(n)	ENETC_PORT_BASE + (0x0104 + (n) * 0x8)
+#define ENETC_PTXMBAR		ENETC_PORT_BASE + 0x0608
+#define ENETC_PCAPR0		ENETC_PORT_BASE + 0x0900
+#define ENETC_PCAPR1		ENETC_PORT_BASE + 0x0904
+#define ENETC_PSICFGR0(n)	ENETC_PORT_BASE + (0x0940 + (n) * 0xc)  /* n = SI index */
+
+#define ENETC_PRFSCAPR		ENETC_PORT_BASE + 0x1804
+#define ENETC_PTCMSDUR(n)	ENETC_PORT_BASE + (0x2020 + (n) * 4) /* n = TC index [0..7] */
+
+#define ENETC_PM0_CMD_CFG	ENETC_PORT_BASE + 0x8008
+#define ENETC_PM0_CMD_TX_EN		BIT(0)
+#define ENETC_PM0_CMD_RX_EN		BIT(1)
+#define ENETC_PM0_CMD_WAN		BIT(3)
+#define ENETC_PM0_CMD_PROMISC		BIT(4)
+#define ENETC_PM0_CMD_PAD		BIT(5)
+#define ENETC_PM0_CMD_CRC		BIT(6)
+#define ENETC_PM0_CMD_PAUSE_FWD		BIT(7)
+#define ENETC_PM0_CMD_PAUSE_IGN		BIT(8)
+#define ENETC_PM0_CMD_TX_ADDR_INS	BIT(9)
+#define ENETC_PM0_CMD_XGLP		BIT(10)
+#define ENETC_PM0_CMD_TXP		BIT(11)
+#define ENETC_PM0_CMD_SWR		BIT(12)
+#define ENETC_PM0_CMD_CNT_FRM_EN	BIT(13)
+#define ENETC_PM0_CMD_SEND_IDLE		BIT(16)
+#define ENETC_PM0_CMD_NO_LEN_CHK	BIT(17)
+#define ENETC_PM0_CMD_SFD		BIT(21)
+#define ENETC_PM0_CMD_TX_LOWP_ENA	BIT(23)
+#define ENETC_PM0_CMD_REG_LOWP_RXETY	BIT(24)
+#define ENETC_PM0_CMD_RXSTP		BIT(29)
+#define ENETC_PM0_CMD_MG		BIT(31)
+
+#define ENETC_PM0_MAXFRM	ENETC_PORT_BASE + 0x8014
+#define ENETC_PM0_IF_MODE	ENETC_PORT_BASE + 0x8300
+
+struct enetc_register {
+	u32 addr;
+	const char *name;
+	void (*decode)(u32 val, char *buf);
+};
+
+#define REG(_reg, _name)	{ .addr = (_reg), .name = (_name) }
+
+#define REG_DEC(_reg, _name, _decode) \
+	{ .addr = (_reg), .name = (_name), .decode = (_decode) }
+
+static void decode_cmd_cfg(u32 val, char *buf)
+{
+	sprintf(buf, "\tMG %d\n\tRXSTP %d\n\tREG_LOWP_RXETY %d\n"
+		"\tTX_LOWP_ENA %d\n\tSFD %d\n\tNO_LEN_CHK %d\n\tSEND_IDLE %d\n"
+		"\tCNT_FRM_EN %d\n\tSWR %d\n\tTXP %d\n\tXGLP %d\n"
+		"\tTX_ADDR_INS %d\n\tPAUSE_IGN %d\n\tPAUSE_FWD %d\n\tCRC %d\n"
+		"\tPAD %d\n\tPROMIS %d\n\tWAN %d\n\tRX_EN %d\n\tTX_EN %d\n",
+		!!(val & ENETC_PM0_CMD_MG),
+		!!(val & ENETC_PM0_CMD_RXSTP),
+		!!(val & ENETC_PM0_CMD_REG_LOWP_RXETY),
+		!!(val & ENETC_PM0_CMD_TX_LOWP_ENA),
+		!!(val & ENETC_PM0_CMD_SFD),
+		!!(val & ENETC_PM0_CMD_NO_LEN_CHK),
+		!!(val & ENETC_PM0_CMD_SEND_IDLE),
+		!!(val & ENETC_PM0_CMD_CNT_FRM_EN),
+		!!(val & ENETC_PM0_CMD_SWR),
+		!!(val & ENETC_PM0_CMD_TXP),
+		!!(val & ENETC_PM0_CMD_XGLP),
+		!!(val & ENETC_PM0_CMD_TX_ADDR_INS),
+		!!(val & ENETC_PM0_CMD_PAUSE_IGN),
+		!!(val & ENETC_PM0_CMD_PAUSE_FWD),
+		!!(val & ENETC_PM0_CMD_CRC),
+		!!(val & ENETC_PM0_CMD_PAD),
+		!!(val & ENETC_PM0_CMD_PROMISC),
+		!!(val & ENETC_PM0_CMD_WAN),
+		!!(val & ENETC_PM0_CMD_RX_EN),
+		!!(val & ENETC_PM0_CMD_TX_EN));
+}
+
+#define RXBDR_REGS(_i) \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBMR), "RX BDR " #_i " mode register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBSR), "RX BDR " #_i " status register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBSR), "RX BDR " #_i " buffer size register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBPIR), "RX BDR " #_i " producer index register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBCIR), "RX BDR " #_i " consumer index register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBAR0), "RX BDR " #_i " base address register 0"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBBAR1), "RX BDR " #_i " base address register 1"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBLENR), "RX BDR " #_i " length register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBIER), "RX BDR " #_i " interrupt enable register"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBICR0), "RX BDR " #_i " interrupt coalescing register 0"), \
+	REG(ENETC_BDR(RX, (_i), ENETC_RBICR1), "RX BDR " #_i " interrupt coalescing register 1")
+
+#define TXBDR_REGS(_i) \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBMR), "TX BDR " #_i " mode register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBSR), "TX BDR " #_i " status register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBBAR0), "TX BDR " #_i " base address register 0"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBBAR1), "TX BDR " #_i " base address register 1"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBPIR), "TX BDR " #_i " producer index register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBCIR), "TX BDR " #_i " consumer index register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBLENR), "TX BDR " #_i " length register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBIER), "TX BDR " #_i " interrupt enable register"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBICR0), "TX BDR " #_i " interrupt coalescing register 0"), \
+	REG(ENETC_BDR(TX, (_i), ENETC_TBICR1), "TX BDR " #_i " interrupt coalescing register 1")
+
+static const struct enetc_register known_enetc_regs[] = {
+	REG(ENETC_SIMR, "SI mode register"),
+	REG(ENETC_SIPMAR0, "SI primary MAC address register 0"),
+	REG(ENETC_SIPMAR1, "SI primary MAC address register 1"),
+	REG(ENETC_SICBDRMR, "SI control BDR mode register"),
+	REG(ENETC_SICBDRSR, "SI control BDR status register"),
+	REG(ENETC_SICBDRBAR0, "SI control BDR base address register 0"),
+	REG(ENETC_SICBDRBAR1, "SI control BDR base address register 1"),
+	REG(ENETC_SICBDRPIR, "SI control BDR producer index register"),
+	REG(ENETC_SICBDRCIR, "SI control BDR consumer index register"),
+	REG(ENETC_SICBDRLENR, "SI control BDR length register"),
+	REG(ENETC_SICAPR0, "SI capability register 0"),
+	REG(ENETC_SICAPR1, "SI capability register 1"),
+	REG(ENETC_SIUEFDCR, "SI uncorrectable error frame drop count register"),
+
+	TXBDR_REGS(0), TXBDR_REGS(1), TXBDR_REGS(2), TXBDR_REGS(3),
+	TXBDR_REGS(4), TXBDR_REGS(5), TXBDR_REGS(6), TXBDR_REGS(7),
+	TXBDR_REGS(8), TXBDR_REGS(9), TXBDR_REGS(10), TXBDR_REGS(11),
+	TXBDR_REGS(12), TXBDR_REGS(13), TXBDR_REGS(14), TXBDR_REGS(15),
+
+	RXBDR_REGS(0), RXBDR_REGS(1), RXBDR_REGS(2), RXBDR_REGS(3),
+	RXBDR_REGS(4), RXBDR_REGS(5), RXBDR_REGS(6), RXBDR_REGS(7),
+	RXBDR_REGS(8), RXBDR_REGS(9), RXBDR_REGS(10), RXBDR_REGS(11),
+	RXBDR_REGS(12), RXBDR_REGS(13), RXBDR_REGS(14), RXBDR_REGS(15),
+
+	REG(ENETC_PMR, "Port mode register"),
+	REG(ENETC_PSR, "Port status register"),
+	REG(ENETC_PSIPMR, "Port SI promiscuous mode register"),
+	REG(ENETC_PSIPMAR0(0), "Port SI0 primary MAC address register 0"),
+	REG(ENETC_PSIPMAR1(0), "Port SI0 primary MAC address register 1"),
+	REG(ENETC_PTXMBAR, "Port HTA transmit memory buffer allocation register"),
+	REG(ENETC_PCAPR0, "Port capability register 0"),
+	REG(ENETC_PCAPR1, "Port capability register 1"),
+	REG(ENETC_PSICFGR0(0), "Port SI0 configuration register 0"),
+	REG(ENETC_PRFSCAPR, "Port RFS capability register"),
+	REG(ENETC_PTCMSDUR(0), "Port traffic class 0 maximum SDU register"),
+	REG_DEC(ENETC_PM0_CMD_CFG, "Port eMAC Command and Configuration Register",
+		decode_cmd_cfg),
+	REG(ENETC_PM0_MAXFRM, "Port eMAC Maximum Frame Length Register"),
+	REG(ENETC_PM0_IF_MODE, "Port eMAC Interface Mode Control Register"),
+};
+
+static void decode_known_reg(const struct enetc_register *reg, u32 val)
+{
+	char buf[512];
+
+	reg->decode(val, buf);
+	fprintf(stdout, "%s: 0x%x\n%s", reg->name, val, buf);
+}
+
+static void dump_known_reg(const struct enetc_register *reg, u32 val)
+{
+	fprintf(stdout, "%s: 0x%x\n", reg->name, val);
+}
+
+static void dump_unknown_reg(u32 addr, u32 val)
+{
+	fprintf(stdout, "Reg 0x%x: 0x%x\n", addr, val);
+}
+
+static void dump_reg(u32 addr, u32 val)
+{
+	const struct enetc_register *reg;
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(known_enetc_regs); i++) {
+		reg = &known_enetc_regs[i];
+		if (reg->addr == addr) {
+			if (reg->decode)
+				decode_known_reg(reg, val);
+			else
+				dump_known_reg(reg, val);
+			return;
+		}
+	}
+
+	dump_unknown_reg(addr, val);
+}
+
+/* Registers are structured in an array of key/value u32 pairs.
+ * Compare each key to our list of known registers, or print it
+ * as a raw address otherwise.
+ */
+int fsl_enetc_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+			struct ethtool_regs *regs)
+{
+	u32 *data = (u32 *)regs->data;
+	u32 len = regs->len;
+
+	if (len % 8) {
+		fprintf(stdout, "Expected length to be multiple of 8 bytes\n");
+		return -1;
+	}
+
+	while (len) {
+		dump_reg(data[0], data[1]);
+		data += 2; len -= 8;
+	}
+
+	return 0;
+}
diff --git a/internal.h b/internal.h
index 9fa6d80b4b29..dd7d6ac70ad4 100644
--- a/internal.h
+++ b/internal.h
@@ -406,6 +406,9 @@ int dsa_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 /* i.MX Fast Ethernet Controller */
 int fec_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
+/* Freescale/NXP ENETC Ethernet Controller */
+int fsl_enetc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
+
 /* Intel(R) Ethernet Controller I225-LM/I225-V adapter family */
 int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
-- 
2.34.1

