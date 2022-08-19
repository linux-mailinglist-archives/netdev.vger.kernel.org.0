Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1377C599812
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347965AbiHSJAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348021AbiHSJAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:00:46 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2047.outbound.protection.outlook.com [40.107.105.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F90F14DF;
        Fri, 19 Aug 2022 02:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m51AOnNeP7KtajUFT9JUcoqlkmiBtGZze9ohTbNRGnKqf4BHHfVQU41hSFqlWJQmrPfF61ZyrByOIwZ9KzREIMyTXqCeVGTQsr6R9XnnxbnaB1PBeFrjXX7illzNNgo/A++PmFH/TPJkzZ7Rhr3/BfRUko2nrAIoVhSQazPcJpllmSnpEdLsRWxZ/druVVKpnk2Pa9Y5SHKpgz9ENwJ2MuJA/F5S/8Sz+f8GJZqz8iqjD4jMz8KlWIC7h+DIMeIiRMeBgt+ydJzc5SjXLU8fOkuxg7+CnWN1RpBq1oCTAYJQzeEvqBQswJAoDHiF9xx7xXEBZ8hvCAMAoasvUPD5gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7PUakwU2+nyIkGweuJwEF2jdf5JcTIh6hPfHjjOlK0=;
 b=jkTAukyTn0f2Y1BgCnog75gIMvII24dyMMig1IEeRtG0YE5pUlOnt4XRTuAzGvfPWjYlC0tS1DxpAeD+oCg2Nr3js6p5PyeooQ86/pIe5NUuxw6qrKMiTlzAKEoyNpFJR1ioBpCeM1CWeAKyKMv+H++amNcAlLHNla5z1vvttGyVqna/VpuJ8qhPXZOq6NxinXBOXbK4EeR4Vh7Gv1up0KrgPThPbMY+rIvELKUBXkKb8LYtXzlM7nNgkiE4f7k+OVnR6qaPtDNc+U1BUnMDlL0vEUlydOurAedSFp/pINTv+0IbU2+4flC2odBD034c+O3YNxyxfiFxZMTEj7e1sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7PUakwU2+nyIkGweuJwEF2jdf5JcTIh6hPfHjjOlK0=;
 b=buhZRfP9g8ubUWYGnWZTYFAdYQv+E1RnsYbuajm7AAO+XA/mxKidVblRTfklvw1zfi8nuokGt38EUva88so8e0Zz4/1hmzH5xXav3BwD7BlRlpHY++hGaz7WeTQAeaKjdqX/CfWiOXG5QtTfIg4e+wi5cEvG5z4Yyz2JMQlGVZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR0402MB3536.eurprd04.prod.outlook.com (2603:10a6:803:2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 09:00:39 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 09:00:39 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fec: change the default rx copybreak length to 1518
Date:   Fri, 19 Aug 2022 17:00:41 +0800
Message-Id: <20220819090041.1541422-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:3:18::31) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ddb944b-238b-4357-6b79-08da81c149b3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3536:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mr5rYQ0g1UvrVeab/Iv+tjYiFUkLuz6I0fcS/td0IC0XHSgI5YyWPUZ9cTGlzGbIII74VTywlZn3Cow9OwiG0TwbJXUsGpxCCXRtYDrvBnC4MnzTbabWTywCE+WRNO/WaL299/JBt6VbBaFl9kOasKz63p8efMm1z3x4mPXDFOKYZdrVgQQHZBF+ZOo8/mBfgt0GB7tfGOz9DrZvaNZ/ZsdH8PUbQqwlSD70GDA3z8YZG4YgFs3i3FdohLm8rsQztsChoxBQjZQ0Qz5SQyoTobLzLnCGKndY9oYwEVNTCxzR+NqBtMPk6PTxMdC84MNwO4h9WyNAFXVVwB+tSAR44XurbjfUWUoF95yjJjopREZmEudrEuNYb7s0vmOOTp5w/1gGwdHJuondGU6MBweqXxRvrmv3/jlkTYiulEpfYsjAs21jriPzRsBCBg2GbZY5MYJmsADr+aybHFvwuTyFsURuXhU2dlajMGi0uNPEeo4WCZc0fBEcfbCmJj4zQAb8emH1VFCUfOJAl4DenLpcFmGztVHjJbRG7j2vh/YCyD1udX4g0edSRA33QF6TsYFIuKSROeiW2uoj1fYfoSxR0MHpS3fKIur4NhV0lU/Qt02vtylgLfU9NY59MhAc49UN9ouFtf2RGbieMEFGY8perwRi5+MTs3NbyZMK9SWsv6b91sq6wvyBksR6bAJcC/ldEerga9P6s1ZPhJaEi55V2USi5K3Wdu3LHtmim94lmwc9Et6W3tFuZpsxRwIYEa1DClp9wvyufDt/Ui8owMutGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(26005)(6512007)(9686003)(6506007)(52116002)(2616005)(83380400001)(316002)(36756003)(38100700002)(38350700002)(8936002)(4326008)(66476007)(66946007)(5660300002)(478600001)(2906002)(41300700001)(6666004)(186003)(1076003)(8676002)(86362001)(66556008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3MFFHaunQZDMx8qNz+yHW0NymoEXgJvGm35covlgWmaF8KFfLLskiri+mLZV?=
 =?us-ascii?Q?nEcdnjVbItQMgGXZC2pjf/jCD+uNKsCp/qjE2uG6bjDCQeNRtaqLDXbJAzln?=
 =?us-ascii?Q?Ytyf3bAb/OTJNavv4bekdTKP6Rd6jKnxYo6eWml+iFyU1ANt0Ba8Un8MgDOn?=
 =?us-ascii?Q?7T8UcG9Sg/Heytsk0JD/WGlhdSMq3vB0JnV2+lkv0ezaQ8qIxJplwBWO/h6u?=
 =?us-ascii?Q?M9NdL4RH1823ejUyzS0sXuBAtZiWQ2L5zkz4z2Bmu6dbQvOL8lqOED2UqifG?=
 =?us-ascii?Q?IlZ0WnimKSFtcxVb8QU6b3iD/MaCBHZluJXqviVVOXecUQM2+i2DrG0VdaqF?=
 =?us-ascii?Q?qXzjJr/oFiPteFiFLeR73xeLDBrtHHqCtOtNAZx56riAA8oDP/MDubai+k2v?=
 =?us-ascii?Q?Womb7tszMKnSOeLJWtgsWgD4fPrK+L25qLXXSaIz74JgCxNptD1/4bhnD2bm?=
 =?us-ascii?Q?94eMMC/b+JDuw9L/LFjylcHU8E+krgHr6E3Cuck6gFh7je80jAWmd7P8yJEP?=
 =?us-ascii?Q?GCG3IbZ80k1gmuzlu5/LrQCdNOf6IqP1NONn6f6V0cNWv5zQOy8neSordmIH?=
 =?us-ascii?Q?fuGHDnm6j706TxQgimNJ6EApZtdQEl5Uno4zbtgJqd/SywhBHg3Bm6S9RY5K?=
 =?us-ascii?Q?tcp5N6yeYE/WZAhjZdp8Qv4iCNOIACJd5lcjXFf81Yx2wgtztd1BUWVS59R1?=
 =?us-ascii?Q?ECRZ4J85FQuyIBwhikjj9EFvCSAZswU1SBZb+9Jf4iLj+aAMAADzhFqLWtCz?=
 =?us-ascii?Q?z9H3baAZvWXUVUylTGUpTd728TB1rxMh1l7fBQAQmBxtU5CwkoC/9vnnN+se?=
 =?us-ascii?Q?/4KnT+SvwsZXN9vLQz1hRXxqkdP20CQ5Uwg7H6bwvq1cs9wU213ZRoZMtIbK?=
 =?us-ascii?Q?KoBrOhR5yCvOks7BWGvnFv6NvzmDwjGVsoj0wqOfmWRyJwNujpFwd2ZyjAVN?=
 =?us-ascii?Q?QPOuCVvmAzcrVPEyDZQG3bI9qSijbEBGcJ1IxFk8XhFplvaaLUk9aXZgOou5?=
 =?us-ascii?Q?9xBbIcHabMohH63U6/YPFjhYaOoeq28KbqNXsw4sdfK5i/jQ4sIrz+HYi3Jt?=
 =?us-ascii?Q?InHDrGGxx4HeBKk0z/efLrAl3glYSDPlsOxCB7vuJQr2iX9E/yJrSeVqm8Vb?=
 =?us-ascii?Q?bnJER2hMfq0rEy9edsxiv+GTOFz37cwhp1ZrkayuMtERl5lJJvl8L+PQgGNE?=
 =?us-ascii?Q?GPKfq6SdTUanG3GSs46f/GWsP+rTMYlClIaJ/qLuqVI3CcNAYHICTaE0F3Vg?=
 =?us-ascii?Q?wgEtaQcy4W8dPe5WbjXDQnz9LoopYNm30JRiQu7/j7FpAFWFPuGQFww83cdY?=
 =?us-ascii?Q?pQ0xb1hIq7RTJWfLKNdAnW81PGdjUHbrXO4YVluXb3op/Ehto2HFxkJ5Fm7Z?=
 =?us-ascii?Q?QjiArh9Rb3hwRiXkPJ0Z1aSzbfCrsrYRr5N3lZqafFchClvuqn42Ojc9OxmG?=
 =?us-ascii?Q?CJEOLqFJOD6COvpt50SsitTIaOxl+irOeZYBTa2NEYeKS2nC9vuk37iloG1t?=
 =?us-ascii?Q?3W0FCmERBZh7+4OhubGoEcEEQ8kvm3ILNrwlcvHJP0RWKWxCETjK71IQ37gG?=
 =?us-ascii?Q?ddJYM5V8hPCtn95SZB1lcdF76BAFAyKGfZt64QV6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddb944b-238b-4357-6b79-08da81c149b3
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 09:00:39.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +x7OT0J9zKQcrJ/b7edn/KMqE5gNnieWbZ2Wnikbz9dpinoI+Tcnhar/vytFpARnNfoZCueQwKG6jK9ifiRAng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3536
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

Set the default rx copybreak value to 1518 so that improve the
performance when SMMU is enabled. User can change the copybreak
length in dynamically by ethtool.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e8e2aa1e7f01..f5f34cdba131 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -299,7 +299,15 @@ MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
 #define FEC_WOL_FLAG_ENABLE		(0x1 << 1)
 #define FEC_WOL_FLAG_SLEEP_ON		(0x1 << 2)
 
-#define COPYBREAK_DEFAULT	256
+/* By default, set the copybreak to 1518,
+ * then the RX path always keep DMA memory unchanged, and
+ * allocate one new skb and copy DMA memory data to the new skb
+ * buffer, which can improve the performance when SMMU is enabled.
+ *
+ * The driver support .set_tunable() interface for ethtool, user
+ * can dynamicly change the copybreak value.
+ */
+#define COPYBREAK_DEFAULT	1518
 
 /* Max number of allowed TCP segments for software TSO */
 #define FEC_MAX_TSO_SEGS	100
-- 
2.25.1

