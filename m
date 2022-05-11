Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040E1522FE2
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiEKJwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiEKJup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:50:45 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60077.outbound.protection.outlook.com [40.107.6.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12AD2AD8
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1W/4rFFWQvKCGk0w4MLGxaNavyWA6e5sDbW510cT4stvxZba5AjU2K9OTM9q0M4HtUvY0LYWUZHQQqW9lKGhAQsExLelMaFXPreyNmH48YxuvotK/JJvlMgfVFXrdlF5qnPOxdI8LdaqKJR/bY4NfqPrXMRm07s3zYzydqGtULFesgjyOxIRPLfobJzwFOEUwlNCbsDoC9QCXddZaiW3dwyGp+LrHYN6TzLMCcHwSEDci2oZnG6lvz74v0fJo5NyHSISXntsB8y4+rpky3BJXdlSN2Sualnq5cIp1BbLpBW2i//lA+K73bHK8e7dTamA3AEw72pzsEktMXXZG/Kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNuz4/RCvAOqZqFy0qHPFT60QcJRVljacC5NzvfJ0SA=;
 b=UF3aoyJsdXvCSIw+Uv7s3lGxKE0B6EatW371yBR+T4erBaXTfNLSPGKgJ9+ZY7UskZFdV9OFWoSrBDjk8M6WzhZoNWvPXA9wNVlPOc3TnN0Ifp164mfGpu9IJau7bvOquI2Bc7eDLytzerTKEgEYezBQASRMSZ4d7kPkqbYhqzECYRsIeMbZyK05juLTZW0zFgSclubg3LHFeM8OH2Ygw9TlHqLEAiyV2vTtMsZbUKe8O9Ygm9kMW7qKIRYUJ5ZzFsaZ0KFJErolPZ0iwiS+NLlhxN/eTYKR9mtnUcmT7LQJrhDuNpbhUw3ERcdQCmb0PaiMJcrLheN9c/5bUfdj5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNuz4/RCvAOqZqFy0qHPFT60QcJRVljacC5NzvfJ0SA=;
 b=f2ecm0AVaHqlvxltXW4ymKvU+zClxE4ws3DGkPgHFmxNoUX8GgO2TtP+Cda7Pi7jzRFleSZKnOX5UiRJ/+xxuSTH0QlTmSbEWl0wLWVrs/zL2sgtTcSpTyBpWZpHeCXF985yVH5Fz4oPjcnD3Dg1rpe5kx68LNSm9ICmwb8KrTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4964.eurprd04.prod.outlook.com (2603:10a6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 09:50:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 4/8] net: dsa: introduce the dsa_cpu_ports() helper
Date:   Wed, 11 May 2022 12:50:16 +0300
Message-Id: <20220511095020.562461-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fb0b8dc-32cb-45a9-834a-08da3333b543
X-MS-TrafficTypeDiagnostic: AM0PR04MB4964:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4964CCCF7ED0B4EE91118F43E0C89@AM0PR04MB4964.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+5OMdm6+CutGFPToeqBcthFRrH7HkoYauEqrIYChixIihrflg1Ese9rhaWpaL+fHKJyAYS9OEoowgEhY5HBgd/UFTrSFASbPp/D0iLAYpaG8ggszDC5ORnkN4/cS5qxAUUN3PblvRfSzTunUbD6bndDvdV79gF6a/QFiH9LPaUDpsSAI7xpDOJ5dEbyurh7lgnqQN/JbHatF5g6HmQNf16XiwgnEi71jJVJxa0Eh4KRIA2j+w7+TJTyscuvou+5cFTuHcHA4hSKuAEibQXx4nIJrCuXhvI91DLY2wSC8iKGHkZbMMqUezpZYouXwvQfNE9Yp0phGkJi0aqwSXzY9xtik78hsruSO7xPUHGgf9vcpShAhK3qaFyQhEspzLBRDsSGPDvOGNcS9CLhWmO1w+YkSnlu3J9NpNp0z1dIojiR81cfiQ9/b2+SEMHLwT2sVOKaL+CVLFD+1qK2Eexqv8a8xDaBglx4hMBAusWav2EgF8h/51hkvY8WB4Shp08tTS8J5eEgI1XNwacAF/ka+BTmJ+gme/6RR/WMs6fAMs0nwss2ZZM+HEGhgaeedqpBjsCcVNLa/+zavbEcA3f2AA3R1vz4Kk0Ba0R55ZJyaWJlB+7VExnaWODR1+QHihAPY1B0UxmnEKKxb1Vja8+iofdhRBsfxVVs2je+tVpFQRUVEpBMZSXcrCNles50r3LwiJEsUaNRUTxRDt8/IipNnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(54906003)(38350700002)(66946007)(6916009)(508600001)(66476007)(8676002)(66556008)(186003)(1076003)(316002)(36756003)(2906002)(44832011)(86362001)(6512007)(5660300002)(2616005)(7416002)(4744005)(8936002)(6486002)(6666004)(4326008)(6506007)(26005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WO+QXIuFIfMkKQ8v5Z2qHlWDl5hT4tACqJCNSq4QpL3ctDaDlc1UB0zA5L5G?=
 =?us-ascii?Q?tp2FzHLWnQ0OuA628VPja63RjMotFSRGJ6xhnjNkn4LS7ZJO/W3STVtXOb9B?=
 =?us-ascii?Q?Hh3Y2hVPQIQNC1F02GPUP52gSwGYNPtzWMs7XczjsR8gE79pKcB7ST2D+5Bx?=
 =?us-ascii?Q?DlRsjSFDPqbfeug6d6sqOQhS1wAy4GsoEDE2OUMAd4Ir8wYSYBnzxhYII233?=
 =?us-ascii?Q?F3zK4uKhyU8XmyVJSkL2V5HQ+CqSjwhMsEf+5KNd+UPHFm5pyoz0Rm8I5BmY?=
 =?us-ascii?Q?Xe1g3I7peW9eHZo6ofPgUVm1S3x8cbtnZPX9b5ZePVXSOW/g84/Qz/h5apeR?=
 =?us-ascii?Q?FferWjmMBGoAOzk459/sQNmWThzVQLn4oB+nDnaspT+rWJMpQT99F0an6n4S?=
 =?us-ascii?Q?071COq5ggHHua5WiGFfi5nYbObxq6/Rfp1DSPgrUQ2F3hd0LY7e4fC+Blr5f?=
 =?us-ascii?Q?44SAmhSZ5o89v9yy3szxYiATvCWL+paAQKF9HjUpo4ov2I3Y3r7+WiwhdMm1?=
 =?us-ascii?Q?Ptg6yorMz7v6fBJDqt548i7ieFgx+cGL1OKWyRpNtaEWRGkk+uwb5e9OxyD9?=
 =?us-ascii?Q?5beN3Zfg4gQrNbNttkpJe29kvR0WddGqjKCl57xnHg4WjOEhJwBmXgGU4f4c?=
 =?us-ascii?Q?1Y4Xl88Jn/zf7tf25Ys6296wHxWZvRxsggkImzAmcsTpWwApDUMy4kCecH7e?=
 =?us-ascii?Q?H52EdmXV/tHuq7DbD//LI4cA4rIYu2+GXfgo8cy+zZkEYzTbMzN82r6/mGZl?=
 =?us-ascii?Q?wqJEoxuNKtz6AQ4W3TUvlF2pDYeO3ChFNnEo4/2QEO/xBNQu1fMprBN0WeTV?=
 =?us-ascii?Q?zdAr4xHNXpHi6jrlw3xLyrh9EqdxlUxm4xEQcuk8F+fvfuohmRDEB1IndjGg?=
 =?us-ascii?Q?Sg/XTuntMo9n066qfCbEvWHfW/98LuTNFFqshddCYpESt6Xh475TZPe5td38?=
 =?us-ascii?Q?Du3fQxl2u9qGDO0Td//lTZeSLRAtbDDFmSM/9SDtCNEw6Kl0VGtu70w8NuzG?=
 =?us-ascii?Q?/TFMSDw/qkpTPpxskUiO7lrRyIFbbmaD/lWYzoGhSHcUqgZg/wQlXHvzihVK?=
 =?us-ascii?Q?zdwwA7cnn8rk9SNg2HMW9mINMxjAhXfyEa/RR0GgUAr+yp0FNaG3ZgXu1BUn?=
 =?us-ascii?Q?JgSrG6lYW4MNR4tys//bl+JJesAlkCU8AK2Fbv6/IHUgjzJu/tWA7aozP6SU?=
 =?us-ascii?Q?VLs7li0oyIoF1kwaksjHZRX3u7sh5HIYNghdKRcRCOhlGK6TNJGyMpr2G/kv?=
 =?us-ascii?Q?EEw9fsBlwKkae48Ok38sZkBBFqAb5hkm2UubfCLnkeneb6+Weu0+DME+O3FR?=
 =?us-ascii?Q?kPnR0E9uPzstENDAB/Ei/Nx4DaUOeNEoU5QxF1I95WWHthFQQU+ym5VBj+6H?=
 =?us-ascii?Q?JgXedI1t3SgVZHOYPutzvNTMIEnKW3hWzPn+p92/vsB+IWPOg0P1Rmkev/nd?=
 =?us-ascii?Q?C6+fsTewTygPKNI9+4+Ehno4Qq9zzWw3EAUj89ZlIVLIT4mpUCpZU9ZexehX?=
 =?us-ascii?Q?rxDtxcfUapQ/ZM5SQB6K1tJteFNINVnk83G/Fyka67ADg0qg/7/FhqNYMTmA?=
 =?us-ascii?Q?WxM1gFIMuEae9gvObRIEZmTZsRnseQG66KiyNLza1dlfOxXsIGq8ARsDQ3BP?=
 =?us-ascii?Q?Gs9R6rz0KcjAgRGA9sqqp6WyFReVLfE/UBoe97mZt5hc6EXadGvxtwEX/WJv?=
 =?us-ascii?Q?LUfl5r9L9mOEQrc1YyicAF4Mg28ZOMzdmY/TxqBOF7w7zJNuC1tNs9pHR9C8?=
 =?us-ascii?Q?aVilt5Qa10GL6LlKZVucuAEly2nXtIE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb0b8dc-32cb-45a9-834a-08da3333b543
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:40.5358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LiIeQQBzr68Tj4u4xMYpvrtaN4mKEo/fXzsb36noenx6IhnS9yzQSJWf9zr03KWX/rTuMI/DmcFNpaGfcMo24A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4964
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to dsa_user_ports() which retrieves a port mask of all user
ports, introduce dsa_cpu_ports() which retrieves the mask of all CPU
ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 include/net/dsa.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index efd33956df37..76257a9f0e1b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -590,6 +590,17 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+static inline u32 dsa_cpu_ports(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp;
+	u32 mask = 0;
+
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		mask |= BIT(cpu_dp->index);
+
+	return mask;
+}
+
 /* Return the local port used to reach an arbitrary switch device */
 static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
 {
-- 
2.25.1

