Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ED46DE365
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbjDKSDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjDKSD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:03:27 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8036EA7;
        Tue, 11 Apr 2023 11:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dK77XLcMC827j4A/P6VufF6T0veZTdtxZBC9JBvFa/ydzK05gPMdB4HRXlYMfsWnDJVL4q9ckXI19zURZgFZrgYwsL/I7bqBCkwwSg2jGuyfT75xjSx188dY/le5PjdC2h2H7guJtsBiI9PQqTMS4Zuhu3AaSL7sS+mUYWT4btjp3m4NBfKLIG7OM/y5yjomG/DbR5f9O/xTUJ8QBw1lptTVioIPp8SmKsqN57jtaRIqMwkAmrIwbtYxEcKz7LNGHVcwckpKJyxr64SiBkvgp8qOEzzPq8MkraNTb3STK4qja9eIpTKSlxwieZfpfeAF2KE45mLfJu9hQiQtjWZFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0N/dWuSF87eveOxh8QCSo2VOz8UBVReAh/8tIVl5dnA=;
 b=EAoGlhY1oeuVcCVJpblvaOvH3OnACHysf3nPgLMYj/dIzO3E/yIuaeX67ZuPUBnfKzXMHzz6O7/bLtufgiH9vml74BmBP/t5mAIOwpU9yR09P0bSyH44l2H2yUuAZSFQQeN23+NbommghLqLLipalvwq0eHlwLnoa8JDr5XUUJ5S75JQhfRgZxY0XHwa0l3XJZTGfqhZ3GMMLQuMUWxIMWMo6suerZiTWPuelqbly0/GcTyxXDJgf6WmhginPiaoV3Svlbp4ESyIfqSr5dNAqI0tM6/sXkMPl0eHUE9FTylQ6jtMxEBaH+APhrLkJQbYLCt2u9wKwQvYtKHyExC37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0N/dWuSF87eveOxh8QCSo2VOz8UBVReAh/8tIVl5dnA=;
 b=T7PfuwMzsyymwH8cou3Fvo39j7LnTuEvJolMFiDXYAtQlo/2UhRHm4nxKY3p+TdzeKmku3nDWR4sa6aUmaoHuzPNSUTc5rRc0FsgDBjcjZHcxAgtqyNOvdSSl/lkkxTBkLgpDjRQx1Jb1W3Ujaz9Rd2hkDOxnkwoXDxOF33Z8Cg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7829.eurprd04.prod.outlook.com (2603:10a6:20b:2a7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 18:02:35 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 11 Apr 2023
 18:02:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH v5 net-next 9/9] net: enetc: add support for preemptible traffic classes
Date:   Tue, 11 Apr 2023 21:01:57 +0300
Message-Id: <20230411180157.1850527-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
References: <20230411180157.1850527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0186.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::20) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7829:EE_
X-MS-Office365-Filtering-Correlation-Id: cddf9702-73e1-44c4-48c4-08db3ab6edbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /LhkmNdJazOHt2QThu1MEHDmFXmuU0ndVS3xdcLbsMm0XcWD31C8ELHHZgGOaep2ncw/rOoV5sAcZIMsaVrXObcg2sh6LWAxD4Tt4foo+sZhR1oDTNcv0YsiX1iKpaC1TmV0P8FhTbhAoHb/5t6CtjkhTD34QvRUW0Q3tvrcF7GxjeuEmQRjYTW2/AMir8k1gXISLjKGpbqSCfTeILY3UZ7gNL/pXtoAkX7hymQEuYc8XsOx0iknj0Tcv+bMIBLfuQ6RP33qrd6HUfVPsy3B54cLlcyUXCOXAoBCDlRCqyE3GPW51h1wGjvJd4iwfFLbkaeOnVgsCQAZCM4SeQQXZEeQc1CTMo9fbre/79grb7n3Zg/pD9dvcEvr2H7oOyRGNU/8mKHnD0zEcGOXMnNDi0WRLgcCodWUZPBLWzCnOozEBNf4q+YNPyEq1eJ9XTbHs89PuKb+Ur4Qpp1wwq51LDt8OR7Y2Jg9KCDMuFORC+XGp6cW+TeuWZ3Roztkg+Bv0GpjBSX8JMDrdplWJJdEEw4PSXgNOLUeJQ6gU3oPB81ISL0qEh4ntXluIJC5ZoVoH9ajJrxzokizPPMBegfhAA5lwbJegIEqgGGpHr8AD0sk+GvivADHf/fr4c7ZMcA4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(41300700001)(478600001)(86362001)(316002)(54906003)(8676002)(52116002)(6916009)(66946007)(66556008)(4326008)(66476007)(8936002)(6486002)(5660300002)(7416002)(44832011)(2616005)(186003)(36756003)(38100700002)(38350700002)(26005)(6506007)(6512007)(1076003)(83380400001)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/zU8r+Qsbnt58hT3jTD5gc2TLiEXO1CsvhTNopKBlX8YjQPTSzxzZjM+ezUL?=
 =?us-ascii?Q?VYRuOYlgJO7NvyAbNY6U7P3wRvgobV7+k5ts1bpQVfpIneop2JJRX3H5e7CE?=
 =?us-ascii?Q?AVy5MDnWSqnvTcM8s7q8Zs54A5CFGxFNgpVve6OKwkNSU21pCnktnLudDJC4?=
 =?us-ascii?Q?rV/RdnZ0DGHVp+YWVQTVCFvZYo0pNk2SfoVDhgeEmtVO+zT2x81KkdUgtSwC?=
 =?us-ascii?Q?NUaE6BuSAoC1eSWjwq2p7n3GixiAv3Cke22ctnTC2DkRzlvAaFZABd7GJUI2?=
 =?us-ascii?Q?U6it0h8b0WV6PTHPiP5HN1iSobuhs4pvmBfAtZCIDPBvmBeYC5A/vn1gK2vm?=
 =?us-ascii?Q?2a1dYovH85LdFlWbzogI3vbxImfjYJYd+z1uHwgUk4jMzyHuRW/HsutRzfn0?=
 =?us-ascii?Q?TkHh5IS3rs6gdxah645KDvYFXLf5nmHJOqfW07wKFdL4OP+caNy73EWDhir2?=
 =?us-ascii?Q?nq+QBwDyxL1bF/Mzc4SRjjqfzFk20bx1h9E1Ywf/jLBZGKzi+i59Th1iYanK?=
 =?us-ascii?Q?M48sk8q5KAmQdd5MUx1OV1GPtMTjfjUYc5cIIaZUP+q+tTSk7lcQI1xcLGF/?=
 =?us-ascii?Q?AtigGa3OxBGYfGvH/QsUGqDkQm4jVu4pPKpJy52ffYITSXPL7hwJ12e2K21H?=
 =?us-ascii?Q?95sJivakhd66j/wPUe+XxvL2vVz+PxXRnCjezXuKc76jxNdeHcZWBG2Xzwyt?=
 =?us-ascii?Q?VyNFCQR1QIyAPJrIevmcZT+Ae1ndwoWEC0EbsOdNwjlxk8VhCt7MMU3UfRPj?=
 =?us-ascii?Q?mWZWKImhrDD1/irHQ5czqLe57DQswznktLDqPJRhtJ1garVjvSsijWifdtj9?=
 =?us-ascii?Q?HUQ/xV/4bnXe1zvQCoGjXl3c8m3b4gifUXrp8L36EiN8swXferOnpjTg3FFH?=
 =?us-ascii?Q?gehvssTTYo+OFnECWmssNeM/dcFm1hQDSAQSgbIj0S/z14k5f/QOQRYmoZix?=
 =?us-ascii?Q?UuW7O5jRmRHWKXDFfP2xieDh6jrT/08oi1g1sU5QtSbix3yA7R621PWQrgOc?=
 =?us-ascii?Q?b5KSLmN0qZecEaeDgBMFq7x7IQf3WC1GYiopElkLoV/RDCUMPq7OwvSRLz5E?=
 =?us-ascii?Q?xkBfLqV+s42p6OTC9tHheQyg0kl/ZMTTNCP9fjKgt1WdQmSUtPSY+KbFJSST?=
 =?us-ascii?Q?qx8fDMWZ5HOCezyDlqxeqhiMu2V462im0NNjQp8bi157qJ4XVsiAMuyjsT+m?=
 =?us-ascii?Q?BOSfIhmZ9wx9In6psY3KYIAqIgUQi29kWuz0Y9OCNZSeWLbHoZyVDkesGQ0T?=
 =?us-ascii?Q?fRjeiJ6uvRyIoiHFORLLJHOkK5E7p4Hm/eYeJkCCcyVuSAZPAT6FdBhF1c2T?=
 =?us-ascii?Q?sTiaSy02/hOp7kecjV68Y1hbBdvKshSaW2fwjK31NONFyZN06HFKZuY/xd9X?=
 =?us-ascii?Q?m/pS9QyaTkWAr04vvf06wWRQp4zFhgndu97bcerX39drigLVsUFa5AwPdk2I?=
 =?us-ascii?Q?saL6OGzsx9ozQIchaUAap0D6t4ty35BDW5EGCubeiGfF5NaxSBS+nYgbovtN?=
 =?us-ascii?Q?6VKXf2/dXZ8ca1505QnVGQGDskCcWbeuSmqejiOHcZ6fo25UPjstPEnDdrjS?=
 =?us-ascii?Q?8hpvCAR2m1eKHsnmNJtUeXc35R3r3AjFMGTI8fazHycfdvaHS5JwbtvpA7u/?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cddf9702-73e1-44c4-48c4-08db3ab6edbc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 18:02:35.1965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpPvov5XJLAGuyMyG83X3pkQCA46zCtMHCJnbUMDcktVEWpLSV4uugSZDfqSRdruJhZzfyDhjuVjQYLRaXWwZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7829
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PFs which support the MAC Merge layer also have a set of 8 registers
called "Port traffic class N frame preemption register (PTC0FPR - PTC7FPR)".
Through these, a traffic class (group of TX rings of same dequeue
priority) can be mapped to the eMAC or to the pMAC.

There's nothing particularly spectacular here. We should probably only
commit the preemptible TCs to hardware once the MAC Merge layer became
active, but unlike Felix, we don't have an IRQ that notifies us of that.
We'd have to sleep for up to verifyTime (127 ms) to wait for a
resolution coming from the verification state machine; not only from the
ndo_setup_tc() code path, but also from enetc_mm_link_state_update().
Since it's relatively complicated and has a relatively small benefit,
I'm not doing it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v1->v5: none

 drivers/net/ethernet/freescale/enetc/enetc.c  | 22 +++++++++++++++++++
 drivers/net/ethernet/freescale/enetc/enetc.h  |  1 +
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index e0207b01ddd6..41c194c1672d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -25,6 +25,24 @@ void enetc_port_mac_wr(struct enetc_si *si, u32 reg, u32 val)
 }
 EXPORT_SYMBOL_GPL(enetc_port_mac_wr);
 
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs)
+{
+	u32 val;
+	int tc;
+
+	for (tc = 0; tc < 8; tc++) {
+		val = enetc_port_rd(hw, ENETC_PTCFPR(tc));
+
+		if (preemptible_tcs & BIT(tc))
+			val |= ENETC_PTCFPR_FPE;
+		else
+			val &= ~ENETC_PTCFPR_FPE;
+
+		enetc_port_wr(hw, ENETC_PTCFPR(tc), val);
+	}
+}
+EXPORT_SYMBOL_GPL(enetc_set_ptcfpr);
+
 static int enetc_num_stack_tx_queues(struct enetc_ndev_priv *priv)
 {
 	int num_tx_rings = priv->num_tx_rings;
@@ -2640,6 +2658,8 @@ static void enetc_reset_tc_mqprio(struct net_device *ndev)
 	}
 
 	enetc_debug_tx_ring_prios(priv);
+
+	enetc_set_ptcfpr(hw, 0);
 }
 
 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
@@ -2694,6 +2714,8 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 
 	enetc_debug_tx_ring_prios(priv);
 
+	enetc_set_ptcfpr(hw, mqprio->preemptible_tcs);
+
 	return 0;
 
 err_reset_tc:
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 8010f31cd10d..143078a9ef16 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -486,6 +486,7 @@ static inline void enetc_cbd_free_data_mem(struct enetc_si *si, int size,
 
 void enetc_reset_ptcmsdur(struct enetc_hw *hw);
 void enetc_set_ptcmsdur(struct enetc_hw *hw, u32 *queue_max_sdu);
+void enetc_set_ptcfpr(struct enetc_hw *hw, unsigned long preemptible_tcs);
 
 #ifdef CONFIG_FSL_ENETC_QOS
 int enetc_qos_query_caps(struct net_device *ndev, void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index de2e0ee8cdcb..36bb2d6d5658 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -965,6 +965,10 @@ static inline u32 enetc_usecs_to_cycles(u32 usecs)
 	return (u32)div_u64(usecs * ENETC_CLK, 1000000ULL);
 }
 
+/* Port traffic class frame preemption register */
+#define ENETC_PTCFPR(n)			(0x1910 + (n) * 4) /* n = [0 ..7] */
+#define ENETC_PTCFPR_FPE		BIT(31)
+
 /* port time gating control register */
 #define ENETC_PTGCR			0x11a00
 #define ENETC_PTGCR_TGE			BIT(31)
-- 
2.34.1

