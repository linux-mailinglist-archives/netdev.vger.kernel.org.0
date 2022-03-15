Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584474D9BEA
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbiCONOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 09:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348560AbiCONOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 09:14:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8201A385
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 06:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGRLMreWlhqWzJaTAmNeliaIC+EKsn8/T532tnBShGbicslmpA+c6ACYDzjDHQ9y6XOO/z/BsptYXlA1LslgGACRiozrYvVn9tUgnmD2vKiDyyK3JMdSigvXmVtc4R6/i+ArR3DkMlkYgnAkzFaNmHl8VGEDC/MFv8BFeRQ7wWmN23gmPSSkG6CZl/oV7ngN2iQKZ2xi2SKSF/Asxbk6Bf/21uKzJ3cgHRpkeLj7JK96qUt7Kd2T5/5n6EEpMET550YegyxMRVge7ytwEuY5Y8m2M8/iTyefXyDAQAtMS62/FMg9Td9f9JogBb0OYjmR6X0ZIBnDRYPbBKgVcYq9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtZD+u6KxwE8yf2bpJAjtoDybcYeaXPAw/uz/OcomRA=;
 b=OIEbvqsDu5UN49OSruCMs8G4XX8RQJPwWDS8PMGCn2NNcybuvZxg+mYSe9+WzINayCK7EkAZOHpCFpfXSerOBeMD9mkF3Xpxh5hMd/bLVWG3diUACs+PRhe19ZkuM8EAikW5yd5mmYjuHTZ9pVFMX6QJz8PBh++oyrkfT+iBjlHt42FN1+eHm6aHko3mZr1Ii089INR/LZiyE9xNh/24cjHSTWRVYPBIobQ31wDTBp4hou9BAYVgIA5LHdJoh0/SpL4S+Uz3xcRw/T9FnpqcyoSVsmckMVuB/1yZK+/VzCrzLzt62RoqBKy2zMb9KQdZcewKqMdusecTLxpAYC2Qew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtZD+u6KxwE8yf2bpJAjtoDybcYeaXPAw/uz/OcomRA=;
 b=FAwUqmEwu+7F6vTvXvl5GHnbnmYmOnROQV9Pbf9Cz30/xeT0Ww/zG9CV7n3srzwH5CvAjBYBeRFlY+KS0Fv2uxhG8Ws5VqJo8PFNluh7t27c3dRffsHYrpI/n/j+pbiFRS8SxzPWirq7PaeXUbe3lAMjBwM1yHkthviyYVCdbVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8551.eurprd04.prod.outlook.com (2603:10a6:10:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28; Tue, 15 Mar
 2022 13:12:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%5]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 13:12:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: mscc: ocelot: fix build error due to missing IEEE_8021QAZ_MAX_TCS
Date:   Tue, 15 Mar 2022 15:12:15 +0200
Message-Id: <20220315131215.273450-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0002.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9535567-36cb-4c84-40f1-08da06858566
X-MS-TrafficTypeDiagnostic: DU2PR04MB8551:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8551C35C61D1372C370F64ADE0109@DU2PR04MB8551.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dzQSyZ5vddfAi85+RnikSrQRH734xQXZi2/0tGRSJM3CmVuZPZYEV8j/gU0ZWHoV+bUocpGJ7sVORTL/df5iYqZ8FgtOO1zTEtnAM+I4P9xj1pV0eanwYLX0wF0X6dOOHNewzN0go9iR4iZnWz4+Qyuw4BS1M5DPiV2Crwlh9qxKWB5KtWb3rWcWboYUKJUMN/ccdf0i1CiYt0fGGaUsiPWvb1dfZnIOz1BwEfa0Jzot/8+i+VXiDZit6tQ4N5VcXvPxEVcJJS38dfqtGFTAmukqdtTyDdgM1YyyhRKra8ecThFLlrVTsDj/hV9z3+GzYGLfP5WIalRhnNIHA6mihQ/WjQ7oKGszIk/YoDdnf/eweqKzBMvj+FP9uoYHFUoPY9a1nEQ/bykLBoG/zfDlHxtfMvgbVsX0xXFOoWUjgvxtVJZK/qPk3Th+hSUPSH14S6/p4g4B7g0Q37tKytTG61C7GqKq2CX01lBRVCvKsfHCBZv5pRPzvmS7Rw2elN2DG/Ape/+jg8pourdwxQ26z0dh5xU4MyJ+s/6uXWPaQF46NlCmcE7T6aSTZGxpHhAPhs7TgnHGEp+Hes5pMhSSIEolPRYSA6y8R6iVahyQF6xzbF2WSDWbavYrWlQTeWQc3pn0XhRjTkMG+oKDkZrTdaNYVdOgKESHoQvJMVVIIKguFgTQbrJhghgMqDMJdNytQiAaKyIUjU60aBfJIAhFYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(86362001)(316002)(54906003)(6486002)(6916009)(5660300002)(38100700002)(66946007)(8676002)(66476007)(4326008)(8936002)(66556008)(2906002)(2616005)(83380400001)(36756003)(44832011)(1076003)(508600001)(186003)(52116002)(6506007)(6512007)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IWHA+KmkY+ifbpQEvsZOoFpkIshJVlBM6P3dcnhavRz5LViCVatQhTWL1yY0?=
 =?us-ascii?Q?vTNWTtzqPY40BuhBu8cWUGh7nYhqbxE1LvMT4sY6jiUBMVYXTjSkwC5m7mBs?=
 =?us-ascii?Q?O70NU3DiNA5kZAftdc9hatssyjmHxaIav+liKDRQfOqxG700cL5BdP854oUi?=
 =?us-ascii?Q?XnGHPjLNy9NxDMTHaV+Swy3C6HrQdIbiVM5aced9/ycdpTa3vXD4RaBa0dqr?=
 =?us-ascii?Q?i4IgPpZRgnBK1xgHhWTlyvAqkyPY4uNDcSrGr+0QaeJGzUrtQdFTzAli1yf3?=
 =?us-ascii?Q?+ULzZe2tun60BmG26DMVxIY21v9YO4kq1F+psQQi+cNQUCX0moQVy9MkOptI?=
 =?us-ascii?Q?P5f2dym6tja+JRzVDJ0/tuSL4A7Gl8nEuqi7X6PPqKyus9r7Hv9z5UIELgvr?=
 =?us-ascii?Q?slfkNZo0XwmK9h5ujtfJjKXelXdrR//jd2xoPWI8SMNReUQA7EpXm4RMcVCO?=
 =?us-ascii?Q?rX3k7fufTSNztovbv2YUUwTpxsJzXULovS2zUjy89bPc6+nHu8wfQbFoNPlO?=
 =?us-ascii?Q?xWMuih/nyCNFEY5ueF7rLXdWPcmvX5pt0HVjM3L4MTrINIthbDZQZTda2MPM?=
 =?us-ascii?Q?2WhnCphW6ldeW6EXHYh2XffG+2lF11aeJXJvX2NvdVIIdOls0xfG15AN82Po?=
 =?us-ascii?Q?FNw5DwO5epEIEguoAyWTWbUuYJYeSTnhVZ8HcclKb6Is5AOcKYGsgEic/ePp?=
 =?us-ascii?Q?89QNK4S1nZ3RflDxoTBTT2TrX5cjFv53EM5nCtogurSdG/7HslrPkRJksyMB?=
 =?us-ascii?Q?1CcBNjPX6AgR3c4qooID6TXY0PNRLadDy20AELPn1l8ZGS3c4NkQ3tOhSnos?=
 =?us-ascii?Q?T3YPIHlMyTmK6bit8pAQP4A6iHBfu2CVe6P4MXeCdrVxDBXWi66lIuEFqIET?=
 =?us-ascii?Q?3IIwOk0OKqjpw5WOT8U5Qs52hqI995KJkmnb/qu/U39wFn/TFEE4k7b9Hv0G?=
 =?us-ascii?Q?ljs1GUMeSXWkVzzycMorc+F7y2erb5ncOqi2Kx9vlKrezyTpuTPQC6WUFU9o?=
 =?us-ascii?Q?1dYdkqyL7ENn8bKlPeGeXEazrKcCtT9CIIrrqyzn6eqrHHwPu4iK+Ul5apOi?=
 =?us-ascii?Q?MSghKl3trlccU0k5DBIHgKK497vV9lw5681embODk76JzfhnS7nCP/vUe0Gb?=
 =?us-ascii?Q?pmSO82bsf92qZXlP7ZLsMdrs5U0sW7YEW7H4YjNrLf+zhOd2Tosk5G221Q65?=
 =?us-ascii?Q?2kGgrGmGNHjq9W6Iao437QA/D6Dlt5fN39tgPmZSfR3BEWwj6BB3z4RNyzBG?=
 =?us-ascii?Q?lm9b2ZdaVkBAylWgL8gy9G2blNcXMWI4cE8Te8CUGY2zKVVWLcl+RvLyuLfK?=
 =?us-ascii?Q?BYkjR7Q6jMIJ0S+uCSwU+fodYWACSmmgk4qpqjJQzzGNkkwLMclbgkduLpmP?=
 =?us-ascii?Q?/YeFDn9CRCVPgdQahOrCdAy+TMZ26ZdVh21SIo4VKTP/jNEk96VgeloC0SOq?=
 =?us-ascii?Q?RNwW5YkoqavF2+pzZJiv384XuzDIAmlzaJLZXTlmrLcanXK6oGuenA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9535567-36cb-4c84-40f1-08da06858566
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 13:12:56.7803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ceVPx8+wKzflffk7R+U3lXXWjqFfyMAMNj7NDZ1jXepa152OtMCIVXeOsqFleeQumW+KqRlW4iwwgT7dv+gBGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8551
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IEEE_8021QAZ_MAX_TCS is defined in include/uapi/linux/dcbnl.h, which is
included by net/dcbnl.h. Then, linux/netdevice.h conditionally includes
net/dcbnl.h if CONFIG_DCB is enabled.

Therefore, when CONFIG_DCB is disabled, this indirect dependency is
broken.

There isn't a good reason to include net/dcbnl.h headers into the ocelot
switch library which exports low-level hardware API, so replace
IEEE_8021QAZ_MAX_TCS with OCELOT_NUM_TC which has the same value.

Fixes: 978777d0fb06 ("net: dsa: felix: configure default-prio and dscp priorities")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 41dbb1e326c4..a26d613088ef 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2917,7 +2917,7 @@ EXPORT_SYMBOL_GPL(ocelot_port_get_default_prio);
 
 int ocelot_port_set_default_prio(struct ocelot *ocelot, int port, u8 prio)
 {
-	if (prio >= IEEE_8021QAZ_MAX_TCS)
+	if (prio >= OCELOT_NUM_TC)
 		return -ERANGE;
 
 	ocelot_rmw_gix(ocelot,
@@ -2959,7 +2959,7 @@ int ocelot_port_add_dscp_prio(struct ocelot *ocelot, int port, u8 dscp, u8 prio)
 {
 	int mask, val;
 
-	if (prio >= IEEE_8021QAZ_MAX_TCS)
+	if (prio >= OCELOT_NUM_TC)
 		return -ERANGE;
 
 	/* There is at least one app table priority (this one), so we need to
-- 
2.25.1

