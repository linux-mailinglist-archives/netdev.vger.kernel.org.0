Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 945B85A5C5A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiH3HCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiH3HCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:02:19 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE534BCCD9;
        Tue, 30 Aug 2022 00:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpPO+BcEfcSlSE1Hx0xyCxlO64KHgTyd/LJrfRQe6lbcPAxUcdrOp9/Muvs+aNepEAzdCX//h74ZQMJWsES/3W+eHeaN61RIBTNxmmRfoyKlgCNruiqozLP0teOsTf2dnovLQbHjXJ0fPxorHJaByp1KeEq+//JSuKxVp0SIYlmcXIOIzITjO7cN/4/kZCudQveH3ggQksZNVk2EmOpoD7UNZLj33FkN7QzS0bVi54nj54xZb/DzJDwtnSpUqeN5DrgOkWK7/RK5p4EQL/5Iyip1iTtrjWDTbfGVmxKmIoMIi0kFZ5uQ/NKWzJlrufX0JioEt6nKWIwUVMiWq3+KZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0P5wOV+4hO3+ig8JYog28Tnxnts/571ssrCu07uWLc=;
 b=ZMFSa600k8umfp1k5eEP5tXgfWb0pIsWUKuWYbFHc3Y16JB6ZJfp9t7tk/JHJWeN5dkJe3pM7hOrvmNxygqUBtbor6GcCEnU2P3KvgHgn+9MVBpcIXHpyf/p4AJcAghIassA6evAKSlhnMtZ032CGsZaay9Rfyw3OFaAmqiuo1tegQtvOTcWRMnkUub3er+VS2lOysoqNBvToo4XGzLwIBIRY9ogASdzLSI5uefU+IOD8rdkMhou65sqj0cTq7sn/aqUxD5ZuvqSNVpj/QtA91lWLBe50gs0mYq3GiYU+bKjB/1MHkrQdhQY3fv/hcrlg7h4KO+Aatl1UoAB388yWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0P5wOV+4hO3+ig8JYog28Tnxnts/571ssrCu07uWLc=;
 b=OlTKQ7ctmaiYZAYW8E6Mgwt5EscoIUCJMdp9jOqVX5AaDjAuxvCSUv0wlNyAENqvqizNv9OEwPJHs2PhciQwAs7fclqrfOcXvI4gfF8LyYZS3zCdRkLUnULrJMuDd96Np9+lWg0oU4flCmEo2DhjBnZ8vLHz0xLxNh2/Zmvr3Jw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM8PR04MB7729.eurprd04.prod.outlook.com (2603:10a6:20b:24c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 07:02:16 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 07:02:16 +0000
From:   wei.fang@nxp.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: fec: add pm_qos support on imx6q platform
Date:   Tue, 30 Aug 2022 15:01:48 +0800
Message-Id: <20220830070148.2021947-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::13)
 To DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 007b7c56-0fa2-43a0-43c0-08da8a5592be
X-MS-TrafficTypeDiagnostic: AM8PR04MB7729:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pjNAMrCEHEn7dNibIGme5iEu+2lqrUTv6ivAbeCIh+hE03GEJcA1vXmhIyALTiBD94yYMtUFXQ/g508FxHLILH34EmrTEkEF550WFArdel3oEOuYy4/HfAs21Rrr6MmB1FypN65QRhHnDPw4DLI9IqqI/FU7604KpEP0sjC28fVc5wieHPr5UVbcfYStyszCGgyg2wrV3KILY6/qbFINrDoRKec4URxj2SSFAr6djKn+A1jDAEqmCph9yx5jOO/z1GrdMf2T9EZFhnQO2yek36DTvzAHwMQLmdm8fTthBrOMhfo4lFCAsI4MXwqHmitmJLKPvR7xQ6jlT9VXqmutjV4/HJ7TuPjxgTwBsc+YNo5YR6E7Yltr97ss05l56gva7ndYGs3qA26S0EUFsJpjGRvpuFyrFXBrRUVSKhPvfKUop/lqlMl79HoKKV5e0CheJKHKNAYi75NEnhu3jgYyVuO0kFPOhPZpV3dgt/LQJYLGYYmpcT/6WtZvo9ryWYWhbXjSq31SHeUL/s4oV7MeaeL/AmR1TPAh7BK6ewZROoN/AQv7o9nbtlomFNMwsCrKTjL3XKvgsz8W0qDSlz2KsEt20wJheF27m5f+LlvzQMntvNMagUfJd8JsoShDZ2ljfFSQz9sPz/4+hhFiklrwlezEz63hyuE0BKqSK/gFXkG9WOxpfPlgFF7t/RR0rqVOFwcMul4tgN6oHS8/4MY/Pl+Y+WByYG3FoSGxrVJIOs0DFwDFBWRmtg36JieLd0NURMX6aZonWPGbemi0aojZE3UgxSfUFe0m0UdzYdp4aLw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(186003)(1076003)(316002)(86362001)(6486002)(66946007)(4326008)(8676002)(66556008)(66476007)(5660300002)(478600001)(36756003)(8936002)(41300700001)(38350700002)(2616005)(6666004)(26005)(52116002)(38100700002)(6506007)(2906002)(83380400001)(6512007)(9686003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9PWf+FKbpbNFL5R9faxSGyJ5dyQTy3W5K7/lg8tTpre/8pdACqa2ysnRdDau?=
 =?us-ascii?Q?OXjObOFqSIIouzOnCW0KaheETCA6t5sbHrdAiLR8XdyvJBunwEUDz4AmoHV0?=
 =?us-ascii?Q?rBa3zzDxh5xHNmCGi86g+2PgHaujH3sGxKMXrKpbyAnlT2NADiazbV3oJ7hx?=
 =?us-ascii?Q?ZY/lXCR/Q+zTRn4Atw91U6wbuKXvh30JzwWhQNRiqd8/fEnWw3jti+ngOTBh?=
 =?us-ascii?Q?ANf6c7hFuXGyKnpF/jQD6vpM8/I+7/TH4YS9Pj/cJfJQ3M4OWUSf10tDpv4j?=
 =?us-ascii?Q?AM6Gkmt+/jg6sh/ABLyUsoKmpiA9SVJQiLPmIQacu8GjuYdY0uE81WTpwD17?=
 =?us-ascii?Q?Nng8sdBWyr3JGfqYNP5b5ErN0WqJYhtYhV/GaC70ex7wvPwgRNI2u4qwJWPf?=
 =?us-ascii?Q?f80QFH9SH8si8q7qOtVbME9/FfV4LA1FAkq4Z0DOVPEILT5738rYla7S3GYG?=
 =?us-ascii?Q?W7E950UivYE0VuSC+FeqbDKEoTIjXW1aRqrRTQNYv/JEP5wmk2Xulrh5WGbO?=
 =?us-ascii?Q?kax1xK0fc4SkLb5UF2adwtFuWCT/i86iYmEuMhlc1m6pzNIH7c4IpM/bLPj+?=
 =?us-ascii?Q?AAJO8/ecWmsdvtsFowl1BzR7t08npDclKROOhVN1Mpok5fNqMvXot2+4jKSa?=
 =?us-ascii?Q?XNEdedosOtNH3X6QKHjefEJn1fwGQ+OlD1HVwd5+7miU6CibbMYP4u6/Dqs4?=
 =?us-ascii?Q?VHQhGa8RpHz+BgGdxdcgAz0DyLDnxKNvmqbYvkoh3GyYi0+NtseVAyL8rpf+?=
 =?us-ascii?Q?aaJ0Y7vVV7iHFaRc+P8pydHT/yK8UjFgKsh0pkE004IxMZ+ec09/xn7Z9jmm?=
 =?us-ascii?Q?2WRyu01ycN7MzZZfefTfai1pbz/lny1POmypljWFUFUVW+oD/wuI2/4gBwce?=
 =?us-ascii?Q?PUrUP6AtYgWTLgjN2V7zwUugffmQFBPb0m/KwkSVAxVuVQSEbttPT9nMbU41?=
 =?us-ascii?Q?Dto9YqpO2bacLh+zhynl3vKJLLlymWVwpPHXHIM12P2hJ2KYcCEBzgzJ9qR0?=
 =?us-ascii?Q?r2gPf8sEajhrxfW83uory+fMPTxQshTEo3Ix9/2zQVYUOSzXy8lvt0s5Bfo7?=
 =?us-ascii?Q?1RLQfCeDlcfXpUAu7EAEN9MI120S5X79vuCjP5avPH38y1xIn0gEFBYJCq/m?=
 =?us-ascii?Q?3fIbsjHzOaLUQVe9UHxIYePEU3MtgZORR4/AgBGfOnl3qnZ3wK0xc1E7sJA+?=
 =?us-ascii?Q?+zLuagae6PrIG1L5c962taQcNTEdKjrKSD2N4ApO4FYmejQ2HeivJSxZl6K4?=
 =?us-ascii?Q?WyX67Sn/VP6xBK4T5XwnGqMjACnE4G+/uSHNoQVLbaerbIhrnMgqUm3Y66gx?=
 =?us-ascii?Q?0yFgHDTO9rb+7WhPHCneS/eJLUwG+75PW4rTZtP2QBKzN4Xhkddvrrv6fVhr?=
 =?us-ascii?Q?rAzUxQ6UOSjTEM9Jr12IIAHdJnex69krMfPQTriLt3+MdGCs9g8uDezQSK3q?=
 =?us-ascii?Q?pZyomQHOYXGTEQ32suwyQdhaKfm182W6i+ZT7+fIiU9v+91MCuaUAVv9CI56?=
 =?us-ascii?Q?Nq/nFshq2OUKqS4eHw19SNLkfJX1SNz7iEDDejODpUXCxQkoRUpPSXfaq5fH?=
 =?us-ascii?Q?43Nh/tYyvvs5/ZqEF9gJlyZNPjZmsMqPjAgKkWbT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 007b7c56-0fa2-43a0-43c0-08da8a5592be
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 07:02:16.7329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yz2LKvqyO8VWgqQZbBJxKHFoV5T4jhygoqdllkhIwMIVZe5nxgmlSzT8d11AP3qWaXaSZaXqO9lBxEctVGUgnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7729
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

There is a very low probability that tx timeout will occur during
suspend and resume stress test on imx6q platform. So we add pm_qos
support to prevent system from entering low level idles which may
affect the transmission of tx.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      | 5 +++++
 drivers/net/ethernet/freescale/fec_main.c | 9 ++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index ed7301b69169..a5fed00cb971 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -16,6 +16,7 @@
 
 #include <linux/clocksource.h>
 #include <linux/net_tstamp.h>
+#include <linux/pm_qos.h>
 #include <linux/ptp_clock_kernel.h>
 #include <linux/timecounter.h>
 
@@ -498,6 +499,9 @@ struct bufdesc_ex {
 /* i.MX8MQ SoC integration mix wakeup interrupt signal into "int2" interrupt line. */
 #define FEC_QUIRK_WAKEUP_FROM_INT2	(1 << 22)
 
+/* i.MX6Q adds pm_qos support */
+#define FEC_QUIRK_HAS_PMQOS			BIT(23)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
@@ -608,6 +612,7 @@ struct fec_enet_private {
 	struct delayed_work time_keep;
 	struct regulator *reg_phy;
 	struct fec_stop_mode_gpr stop_gpr;
+	struct pm_qos_request pm_qos_req;
 
 	unsigned int tx_align;
 	unsigned int rx_align;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f5f34cdba131..bcc441d9a499 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -111,7 +111,8 @@ static const struct fec_devinfo fec_imx6q_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII |
+		  FEC_QUIRK_HAS_PMQOS,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -3218,6 +3219,9 @@ fec_enet_open(struct net_device *ndev)
 	if (fep->quirks & FEC_QUIRK_ERR006687)
 		imx6q_cpuidle_fec_irqs_used();
 
+	if (fep->quirks & FEC_QUIRK_HAS_PMQOS)
+		cpu_latency_qos_add_request(&fep->pm_qos_req, 0);
+
 	napi_enable(&fep->napi);
 	phy_start(ndev->phydev);
 	netif_tx_start_all_queues(ndev);
@@ -3259,6 +3263,9 @@ fec_enet_close(struct net_device *ndev)
 	fec_enet_update_ethtool_stats(ndev);
 
 	fec_enet_clk_enable(ndev, false);
+	if (fep->quirks & FEC_QUIRK_HAS_PMQOS)
+		cpu_latency_qos_remove_request(&fep->pm_qos_req);
+
 	pinctrl_pm_select_sleep_state(&fep->pdev->dev);
 	pm_runtime_mark_last_busy(&fep->pdev->dev);
 	pm_runtime_put_autosuspend(&fep->pdev->dev);
-- 
2.25.1

