Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC469CB07
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjBTM3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjBTM3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:29:15 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26C91C5AA;
        Mon, 20 Feb 2023 04:28:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLceoOUCpdBOPdPXO6M/eZ0Tv/8enoosumyaNKu0PbkmcaSmedpfE3OABaZ3BhWOZ3gpu7SOQNaHEuADXPsiqnabx9R64GsmG2UA1H4Iu9sI12xsTioY08D51+Ydxi18cR3DfzShVYP550i9sA+19916SKLy4QR4pZ+brdy7Y4Vq/M0jRonSATyxozPMcPO2JIsVKa2w67nl8wvMEsXhg6nygbtVzYt4Tagkev+jw09gL0CVfnsphlCkICsfT3KP+xUViM7AXViJcKkK7SWs6ok9HjqzoTVlqbVPcsaAUOoK9S+j+KB15xcVQ6Jea3/j8yXg58Ag1fH26Pv9d0khnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LAxh0ndzKgSmev7VvnyhN4M8QLpSBeUVLWwrsOu23I=;
 b=bk7iGEVMGEiV1MBTMAblX/eM4O8R5YFdfuizOlk/aIb05VoB8b8YcGO0ckS+5GfTtfTxvnG4r8UgiiiPYRwkNKzBKjmux5OQPe2dkN2KSsoSXW5V6i4c93AiPka5vVRYpNFxarEe7xezCCyUn4MjX4JnL8m+SUfqoqhDG0DMCXaCyueo+E4PqGzuXrf0WQ/7J2h+xED8Bi9DjLkgsmzYV/XOJMTt4OxnZrHXG1OKXQkUtpTpzfSfcuBBeMylkrmDE9gLRvRBAa7lLHU/w3wPX3+wr3/uPm7NtateU1N8wfET4YROcvyVUIDF3WC4H5t2jbZ4eSZR79LbiYpjA1u0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LAxh0ndzKgSmev7VvnyhN4M8QLpSBeUVLWwrsOu23I=;
 b=k2dPio+fBlVt0nBS+361grm5XASV3CP2MuFK6icX3LdPEYpl3EdZrikXKmmv9YeOIHFfg3v3uaiqXwWMNIZR4KgeaN0qffVcpmwBMQ5uQSeyZ/o2hCBCwyNiaujEUF9OR3eRX5slLBuJIxBmV9vRj/avlv7rj5U6qmDPUE08UmM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7725.eurprd04.prod.outlook.com (2603:10a6:102:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Mon, 20 Feb
 2023 12:24:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 12:24:27 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>
Subject: [PATCH v3 net-next 13/13] net: enetc: add support for preemptible traffic classes
Date:   Mon, 20 Feb 2023 14:23:43 +0200
Message-Id: <20230220122343.1156614-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
References: <20230220122343.1156614-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8d::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PA4PR04MB7725:EE_
X-MS-Office365-Filtering-Correlation-Id: 860b3c1e-4069-41ce-f1e3-08db133d686a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jM40lqdUZzbpwjqKvGJd6km3stxo0O36/TgC02oEbt5hyRFK+sV/vPKaoI4zghCsHBwR7ApUD76/HrzbEoRpCzlLgcblzuVpNa6Hl5KAxqm+/D1XKCZOrFE9rReGCXAX/MPABrK/fPP2AU6IgzwYk8yGE3E++raLWrPDTZ1eDw7G1QJhe1uVQaDS0EIhZdArHKVGPB/saCd1aWdmktH3jTeHeSUCet5imA6XxVOjM3XoqS1PUkhqRjYQA1Z69xOnPlaKIcN+RciCBt83UdY7+9CMMK4hyVYi8sHf/0eqJTeeidCcxkwaztKTnuN4ITYgD7Ctl784TDiCEWBrC/Dqk7Yj5cbOTS8D3hrWZBSHzqaMOXU9Bzs7KddPY4ZwLspZtKVhpANsVH+wkWTENF4YXkYNkd+Wr9CKdRUuKqiNiqW556G2rH6aAQThCDIMDgyqdDb2d0S55g876bQ0zNNHFE0RZ3eZzlch14rRVLUbHsU57vbQfZOEMdpRjK2drXfYYR+f1BiyEXrtOAyQ06pKxFeublLzxPj6a7rMPDASDovTz5mupRZ+wM90Ifpbl98USilhubdytSUC8WnPkdgO6XoIt7dP4D1MD2PVZX2ulqQWgZ19AunlYORPpM+MYMPZlVQwRc16mibbIe3XFZ5Zni7EIIepJbzHWWYsGdCrKjW6s0OK27Es7k9ntIrWlBILoHUDYe9P7HijIt6uYKGRrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8676002)(6916009)(4326008)(66556008)(316002)(6486002)(66476007)(54906003)(66946007)(7416002)(52116002)(8936002)(5660300002)(41300700001)(86362001)(36756003)(478600001)(38100700002)(1076003)(38350700002)(6506007)(26005)(186003)(6512007)(6666004)(2616005)(2906002)(44832011)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BBfB9GcWa1SmDP3Fd9ldT+TJfSArfQLJh+Rq1J9MVz6snzzsm8owDDMRqFMH?=
 =?us-ascii?Q?9emU9xj9QKC0bKmXo+EPrd7NUaKGb5dk52hlWlOo7Rt1ebkK3vRahZnG/f+Z?=
 =?us-ascii?Q?NTsRXOSY0yXebKNwNAdLi/7imedtwJYKHBanzwlIstX8n8UkOhnSaJpa7vZ1?=
 =?us-ascii?Q?GvdlCuMipluvGVmkJXaDD+F7wH6WHej/naODXuSbjpaOicxa+F0J1BuRmO/G?=
 =?us-ascii?Q?PfQqWt1badNoXadtIE0Ya5lDYgwLtt1vXzgphqqmMqsVeowfFKL2jgdybZTy?=
 =?us-ascii?Q?aN4aesxTcTQxVRmq3EpeJ1GUAhLYqcBn0jUvUPmrE0EXsQw8NhO14wbDYC7p?=
 =?us-ascii?Q?YcCGug0Mbz3dNggZQxZ8gAGBmEhxcf0EGglI4kspQ805N8y+UPAZUCVen6N0?=
 =?us-ascii?Q?puPWkBrKwFo304RiMjPub4yhZ3yvX6kXNyoROeEF6CelagCRMqyTQWYxBojS?=
 =?us-ascii?Q?rcZ9x6oMiyzC0TArDitFGMLMXWukW4MkPWRU5Bse9/WmKtwaRH915ubbEh2i?=
 =?us-ascii?Q?WrwUa4+E7Za1w9u2FF/MuENBIlPRVhjLVlePHmLLxQUJzb+ZBtDWEG5Zl2VZ?=
 =?us-ascii?Q?tkkvhakdlRk8USnZ9gc7+MiqNhT79we9Rvq/6JmpyskPxiL/R29StFaJ/oNt?=
 =?us-ascii?Q?Od2HxOf4ifoqO7JeMJ9d0gIqZihjb0TrX4lhVD4ABaxZTN71AYM/0kISRL+n?=
 =?us-ascii?Q?BXiqaDkmQVdRcxzT3eCx8IQ9Cz3JCPn+ya1TKa9KZRwHcpRkUYfLYLCtztQV?=
 =?us-ascii?Q?bJxG6HQvrbrdlfbtEPpteHjX8aPSaPi3ExmDjNG9SYN3OIsrpm1M3M+dm8sZ?=
 =?us-ascii?Q?QqRnMRlBvrM/lUKotUd/nGjoAPouQUSXFoC4FPThPieIp/f/aMRw06Y6A1lv?=
 =?us-ascii?Q?ctkyRz/yVvZ3bnAivvvzc86XqfRzgJPfWmJdOYpJ/fEzJM5+XIoIKvBLUTXi?=
 =?us-ascii?Q?PPHkZwZUUzL0Bve0CH2jv5dqutyPRIVyfFtAdXqlkBH4QZVhIvz82sWC/oA+?=
 =?us-ascii?Q?zrTbrtmOoeHCMvFia/hXVJk6iOALxkXiGPBj5ISjpEM+iU8gAZhDOfzKsz71?=
 =?us-ascii?Q?+WXWIgPeZcHOIoAFcghgeOzHlEwsET1hMZhBkapvtC/LKLSQfodneSoo+inP?=
 =?us-ascii?Q?rZLtYppAin7Uy2JYIP4jJUemyKuo5zacY0VthUUxcQEXUsD2IDdpyCfZwr9C?=
 =?us-ascii?Q?4S1GUrCC0g18J9ksBZ8CW4tkbHi1d0e9CkKaxlJvNB4wWCFdftCDlq6nsNSf?=
 =?us-ascii?Q?2huqfrXDSZxQCPxjysYFc3uXkT3d2Bb2/AcFL83oD3Rv/VPHwg5uFNCG+xhp?=
 =?us-ascii?Q?e/GxAJRN6/ZiuGxocqy3zp2tho2d27KdqtTUH2lnPxT0rYkBxInLXZt9KxKX?=
 =?us-ascii?Q?72BT83vP2QfWJd0UZLmtcdTXdFNRXxaED9reqSiwwuQCFba5sEPgsvMYNTwC?=
 =?us-ascii?Q?W/S7JS/r0/tKjB8/Wiwav3TWNvgLHGVGrUBph8OzAEp91JLzAV4Z075bGU5P?=
 =?us-ascii?Q?SFiQWB5krWFE1D3BHQsyXrYmZP9rHcLKnQkKL9h2U5owMLeAVZmw9qVHFsda?=
 =?us-ascii?Q?4wWg6oKLAQ5VBE0iAQJ2/fBg7FJXgF/aOaEYg+UZbMqtbhEFtEG/XvVsknJe?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860b3c1e-4069-41ce-f1e3-08db133d686a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 12:24:27.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 65xC9put//WGBywqFocEX1nVy/uAu0SWVUkgMqju41d2Hk/sm70Jc60K7sUbPp9J9vr8Ffsi1F33D3kOR/PZIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7725
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
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
---
v1->v3: none

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

