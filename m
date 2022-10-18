Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A825602E43
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiJROVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiJROU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:58 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70042.outbound.protection.outlook.com [40.107.7.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417041D0DC;
        Tue, 18 Oct 2022 07:20:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XryN+CGLecb9RlwmnBY4Hf+BKmEpCDX9p+FbjNR+6HfCvpYWUFkEliLYnJHtbpKfeGsH9VPo0+Ay5dJNQvqdUOG/iow1CQLBltsaQgNjFqO3HT0u39+wSx0LuWHO6Zk1SN2WAIrVEso6+Hrie7whvRoBqMB2KTU6Pb1jBlCWsZzDpGSOuf7xVfADY4EJp3W66kszMtHK+bPi1fhhf7KxI398rCZmHyA80Ge7DBCHzWUzwGpsDGgqDIkQBc+fQZ4Jo0NtSOkkteONbAnpVw8asN030m5b991WYyMLpVNivopo9dp0KsgMmELHtepBjgDSaHhdtte1zgWEb91ENwQwuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFZgjxNN7qC7A0Bl99R/A063dhmjBj+uxceXmIkmePI=;
 b=JKbKyZ60fD6/oN8WA74X7wVuMXQqEba5Yrt0Qsg4qCT4+YOE9o+ye8wgJIUSZ6EddaMsEtKSUC7g/2p2Rlhrbzvgw9rAHiTzYMQsAmfGEXSIrUs0ywCWNpwtjP/1SEu9oN/e/zGgCzsPz1MDeF6DoJBQ4H0bhr99enj5GslQaHvbloSwik3fztgk1HW+VM7jqnXo59U/+LiYOhXDH+SvQu+fE3RrHiQqOXdqANyMJ6aVmSe+9P3S4o8y6625uIAiOctnLYrdq+v2Ut2wkysFGJ5JRFEzBKwCRUnr/GM91j/1o5vIEK4H0cvlPUXzNdhrlVKuYky2qRKeN/7pGTf+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFZgjxNN7qC7A0Bl99R/A063dhmjBj+uxceXmIkmePI=;
 b=BhOQ/CuBXE2tjNTOcwdtzv9E/Dx93+GYfVUsoj6gyIstnmWbl0Vy1A9V4FBQvi5QqxlVCII3iRD8fhBw9bYMPsNeARfby1pcIypU69y/2gXRZ1VadmOIUonagGe1sS29Zz5QfVIGPPCd3f2nSOIhvm/rm71Ugj6Lpn0rlkOuGt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:43 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:43 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 10/12] net: dpaa2-eth: AF_XDP RX zero copy support
Date:   Tue, 18 Oct 2022 17:18:59 +0300
Message-Id: <20221018141901.147965-11-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8706:EE_
X-MS-Office365-Filtering-Correlation-Id: 8489d847-573c-4729-3c8d-08dab113cd29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eY598cazQZQek+csZrSoJf07+wgHRjarZuSr99n5c7F1RQyQSwBT5dSxPOOrzDifw91PsXSF4ufXuAqVjYjtflybYzjOJxwj4/ZImCHZxOfFOiBVP42e21z6M1uUtY/OJxDPssMeU28qjXwkiNXSGwbI3a3FN1ssh1ZGTY5Dl7eS0W6CS6UAQ75Sjyt1+uJmv5BqhauEK0Hoooe7tRxgddC1MJlG6bqHc6duAvR4pUxmOrLUR3lG/WhnSjoCqGs4aAoBae3AiC85/HIFJYgmY8u+Yk6TrmiqOjmdyTlSVFl76qFyMstSjU/K2q40FpHH+3DbE72gBolnLKQBUH6RagEJ08TFFAmulEpmJHhsIG6efN6bitwIEK6PncD1eLjONHxOMEeMw8N/8hueSqLyAU/Ptp/8NI2inMXN/RuLi2GeJ1z1iX56dROFornFSwyuiIzRPUknvCCcVPgcvH9yZPKFrDW/V7XF/XvxVSvdGpU9sWOrAm8NZOmjMR8JqRozFRtu/h1XBzo0+iIlSiL6NX1ZwezXvMBTnjpMvdtm4+GrnRLpjETTqUz/Nc/MN/smoQfu35e+FVcODsB6SM7m05KusuFQWwzyJs0hVzUY7v+UdT8eG+5dQiFcuP9DD4GVSnIbivAXr5MZbBB99ryPIE6janSWB/gA+M4JETSEBcDdPGUtU2YlI/38/AaPrETt43qRnRBaiseoBBt8SDiqaRYQjGvIfiYSYPL2fX9cB5TGn1bJ+nbfkKQX6Tri2npwXruW0/F/ibrtiBQgEwbSSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(30864003)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DYxn7MgV3V6dDKOSSNxdJGCWFq+Yw9XYQAtJDz/OUoBwjFiRQQ58C4HCJGf4?=
 =?us-ascii?Q?9hY/EXGDoMtNRHAG9yOIkL6L9VzMhDz2bKnlun8RkHN+psans4vasDfK4DTY?=
 =?us-ascii?Q?0sSzAExyTviIEAtoNeXHs3rHr0XfPaBurynpbmFKX8/bfw1Q/IjvHsyi2aLO?=
 =?us-ascii?Q?nwruHxMKMKmmmDGKYFAf/0egNDm4HCCf8NVKaSXPi7yg18nH48WpesIQfxru?=
 =?us-ascii?Q?KmImA6rMdyt/pmljXKj6U41c0oQOJAJjKdk/3ySOcBbR5RX6jBwxakGZEPgP?=
 =?us-ascii?Q?gaA6dlijx29E7VZDmgpFX8NVhpZM77PaTWMdpjTbVUTjMHvGGIYIrdrqnTwu?=
 =?us-ascii?Q?ggAKSsTAj9MBxvWnreT4N91j//IWDVLqcgRD7QCakaE3HwyJBswA6xw1UP7b?=
 =?us-ascii?Q?Hn/4XuucDtc0ZCTZGmlzVeLOlkJe8Gl4m9tYUa+P0dDESoKS3DrG4rvxoIIR?=
 =?us-ascii?Q?CxWIAf2Aib3vkb3Yvbtalitu/WbgNEdWB4luMAy1+hfKiJ9/LKMIql2YvsU/?=
 =?us-ascii?Q?cwzMadUSpFhabzTWcJinJke4xpKJH90zyebVUqxC9tMquiqz1/l19NqQgka8?=
 =?us-ascii?Q?rhohMe800o6JTzrvKRLtPEnF4TFaYmRHtAoZ3xuKVLKlv9h8JayGJuUxEWzm?=
 =?us-ascii?Q?5/q4hExr+nviPJBJ+2mGDu4Wd+QIxOh1cV6W49RXPcowgw3mUFZdnZ2ELVQ9?=
 =?us-ascii?Q?QFRAKj4ChRQ7Xx2dI7htfn5sNM+UEThpIkI7bnTufEXWkmNuW/zpMvGZaIFw?=
 =?us-ascii?Q?w9ZYvunYt+C16re8uykg90iosRE9iB4qZkqcoH3wc1iD8nDAbHBQ/kQnNjjY?=
 =?us-ascii?Q?l/LcTVZ1Xt9KNGyw402ry9a+4PDuZ7ZsD2L/row1aZHAHLyTDG0rTMifh8ux?=
 =?us-ascii?Q?ReLd7kmNSPZnlDO4iFggyprnNJSvLJijdlSyDLLIGjB84ds7tNusSHx1xORP?=
 =?us-ascii?Q?h/9DGrd9cfulwn7+Lt+OdV5yRcZBaWqPlbQFuPxBivFSQ/P0FPsVGwOPKqpR?=
 =?us-ascii?Q?ugfAR3qcciHBHI6y5LeI0plnSc0UzqHI2OgIG1ADKV6hDhhjgQBHK/hWrTo0?=
 =?us-ascii?Q?ANYwZTZ+1b2n2FZVnfpbXb+9pTRCNCP5oAQFivuAjx5utf8I19HMWAL2yhGt?=
 =?us-ascii?Q?rOu1O+Bn3IZSZzPW4m2ZRxjI4iVXS6zTLGKOhNJwgcU5dHxyYAAUa4GBIyG+?=
 =?us-ascii?Q?zqaGUuqrJle0Qtk/T9t+vFrxOYJd+vwTpdUnPZ9UhMj5TcmIx09J5m4bzey+?=
 =?us-ascii?Q?RWrfNQfYu5o7+vELeKrz4fRdnZwdtdumroTgwJ+6a6FtiiFqOxfWvdkY/X7G?=
 =?us-ascii?Q?fYYm2ZKCJBQL7zNiHZhDBAm2dzmZeQlegHmoJK5v6ib+vNRZxQuLmLl5cNw8?=
 =?us-ascii?Q?lFNqozeKI40Nb/hTyoAqYeITQ95Vdlxi86TxV7pzBxSoesGwuEDtG/85YPIH?=
 =?us-ascii?Q?1mqXIhLVV14gK8jLhWh6FzVJSpZN1KP61CHSHxpuQKtIegYyyJB6pEtKnAkd?=
 =?us-ascii?Q?equ4O7MjoQLCcX04tF+a6fPn8tV68dKstRuiSe98L7T8UhoRPji79v0nrotA?=
 =?us-ascii?Q?L0TG6t0DOJda6aB+0dNbNi8iLtqufd0TSz34OgAYU570A4xXadZ7PcYf/6Qk?=
 =?us-ascii?Q?Cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8489d847-573c-4729-3c8d-08dab113cd29
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:43.4011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alkbDv/qmkBYPwpvqX1yGJOIQqIP+0s9O9e/+czW2nBJkdeTFpB06F1EMf87bKYKrETcNOywUfpqNdJi3GBoMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

This patch adds the support for receiving packets via the AF_XDP
zero-copy mechanism in the dpaa2-eth driver. The support is available
only on the LX2160A SoC and variants because we are relying on the HW
capability to associate a buffer pool to a specific queue (QDBIN), only
available on newer WRIOP versions.

On the control path, the dpaa2_xsk_enable_pool() function is responsible
to allocate a buffer pool (BP), setup this new BP to be used only on the
requested queue and change the consume function to point to the XSK ZC
one.
We are forced to call dev_close() in order to change the queue to buffer
pool association (dpaa2_xsk_set_bp_per_qdbin) . This also works in our
favor since at dev_close() the buffer pools will be drained and at the
later dev_open() call they will be again seeded, this time with buffers
allocated from the XSK pool if needed.

On the data path, a new software annotation type is defined to be used
only for the XSK scenarios. This will enable us to pass keep necessary
information about a packet buffer between the moment in which it was
seeded and when it's received by the driver. In the XSK case, we are
keeping the associated xdp_buff.
Depending on the action returned by the BPF program, we will do the
following:
 - XDP_PASS: copy the contents of the packet into a brand new skb,
   recycle the initial buffer.
 - XDP_TX: just enqueue the same frame descriptor back into the Tx path,
   the buffer will get automatically released into the initial BP.
 - XDP_REDIRECT: call xdp_do_redirect() and exit.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 131 ++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  36 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 327 ++++++++++++++++++
 5 files changed, 452 insertions(+), 45 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a96c60c787af..ec26a206d019 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6322,6 +6322,7 @@ F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
 F:	drivers/net/ethernet/freescale/dpaa2/Makefile
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*
 F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
+F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk*
 F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
 F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
 F:	drivers/net/ethernet/freescale/dpaa2/dpni*
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
index 3d9842af7f10..1b05ba8d1cbf 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -7,7 +7,7 @@ obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
 obj-$(CONFIG_FSL_DPAA2_SWITCH)		+= fsl-dpaa2-switch.o
 
-fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o
+fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o dpaa2-xsk.o
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
 fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0b21a3ee1bf1..4c340f70f50e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -19,6 +19,7 @@
 #include <net/pkt_cls.h>
 #include <net/sock.h>
 #include <net/tso.h>
+#include <net/xdp_sock_drv.h>
 
 #include "dpaa2-eth.h"
 
@@ -104,8 +105,8 @@ static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
 	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
 }
 
-static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
-				dma_addr_t iova_addr)
+void *dpaa2_iova_to_virt(struct iommu_domain *domain,
+			 dma_addr_t iova_addr)
 {
 	phys_addr_t phys_addr;
 
@@ -279,23 +280,33 @@ static struct sk_buff *dpaa2_eth_build_frag_skb(struct dpaa2_eth_priv *priv,
  * be released in the pool
  */
 static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
-				int count)
+				int count, bool xsk_zc)
 {
 	struct device *dev = priv->net_dev->dev.parent;
+	struct dpaa2_eth_swa *swa;
+	struct xdp_buff *xdp_buff;
 	void *vaddr;
 	int i;
 
 	for (i = 0; i < count; i++) {
 		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
-		dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
-			       DMA_BIDIRECTIONAL);
-		free_pages((unsigned long)vaddr, 0);
+
+		if (!xsk_zc) {
+			dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
+				       DMA_BIDIRECTIONAL);
+			free_pages((unsigned long)vaddr, 0);
+		} else {
+			swa = (struct dpaa2_eth_swa *)
+				(vaddr + DPAA2_ETH_RX_HWA_SIZE);
+			xdp_buff = swa->xsk.xdp_buff;
+			xsk_buff_free(xdp_buff);
+		}
 	}
 }
 
-static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
-				  struct dpaa2_eth_channel *ch,
-				  dma_addr_t addr)
+void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   dma_addr_t addr)
 {
 	int retries = 0;
 	int err;
@@ -313,7 +324,8 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
 	}
 
 	if (err) {
-		dpaa2_eth_free_bufs(priv, ch->recycled_bufs, ch->recycled_bufs_cnt);
+		dpaa2_eth_free_bufs(priv, ch->recycled_bufs,
+				    ch->recycled_bufs_cnt, ch->xsk_zc);
 		ch->buf_count -= ch->recycled_bufs_cnt;
 	}
 
@@ -377,10 +389,10 @@ static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
 	fq->xdp_tx_fds.num = 0;
 }
 
-static void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
-				  struct dpaa2_eth_channel *ch,
-				  struct dpaa2_fd *fd,
-				  void *buf_start, u16 queue_id)
+void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   struct dpaa2_fd *fd,
+			   void *buf_start, u16 queue_id)
 {
 	struct dpaa2_faead *faead;
 	struct dpaa2_fd *dest_fd;
@@ -1652,37 +1664,63 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
 static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 			      struct dpaa2_eth_channel *ch)
 {
+	struct xdp_buff *xdp_buffs[DPAA2_ETH_BUFS_PER_CMD];
 	struct device *dev = priv->net_dev->dev.parent;
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
+	struct dpaa2_eth_swa *swa;
 	struct page *page;
 	dma_addr_t addr;
 	int retries = 0;
-	int i, err;
-
-	for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
-		/* Allocate buffer visible to WRIOP + skb shared info +
-		 * alignment padding
-		 */
-		/* allocate one page for each Rx buffer. WRIOP sees
-		 * the entire page except for a tailroom reserved for
-		 * skb shared info
+	int i = 0, err;
+	u32 batch;
+
+	/* Allocate buffers visible to WRIOP */
+	if (!ch->xsk_zc) {
+		for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
+			/* Also allocate skb shared info and alignment padding.
+			 * There is one page for each Rx buffer. WRIOP sees
+			 * the entire page except for a tailroom reserved for
+			 * skb shared info
+			 */
+			page = dev_alloc_pages(0);
+			if (!page)
+				goto err_alloc;
+
+			addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
+					    DMA_BIDIRECTIONAL);
+			if (unlikely(dma_mapping_error(dev, addr)))
+				goto err_map;
+
+			buf_array[i] = addr;
+
+			/* tracing point */
+			trace_dpaa2_eth_buf_seed(priv->net_dev,
+						 page_address(page),
+						 DPAA2_ETH_RX_BUF_RAW_SIZE,
+						 addr, priv->rx_buf_size,
+						 ch->bp->bpid);
+		}
+	} else if (xsk_buff_can_alloc(ch->xsk_pool, DPAA2_ETH_BUFS_PER_CMD)) {
+		/* Allocate XSK buffers for AF_XDP fast path in batches
+		 * of DPAA2_ETH_BUFS_PER_CMD. Bail out if the UMEM cannot
+		 * provide enough buffers at the moment
 		 */
-		page = dev_alloc_pages(0);
-		if (!page)
+		batch = xsk_buff_alloc_batch(ch->xsk_pool, xdp_buffs,
+					     DPAA2_ETH_BUFS_PER_CMD);
+		if (!batch)
 			goto err_alloc;
 
-		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
-				    DMA_BIDIRECTIONAL);
-		if (unlikely(dma_mapping_error(dev, addr)))
-			goto err_map;
+		for (i = 0; i < batch; i++) {
+			swa = (struct dpaa2_eth_swa *)(xdp_buffs[i]->data_hard_start +
+						       DPAA2_ETH_RX_HWA_SIZE);
+			swa->xsk.xdp_buff = xdp_buffs[i];
 
-		buf_array[i] = addr;
+			addr = xsk_buff_xdp_get_frame_dma(xdp_buffs[i]);
+			if (unlikely(dma_mapping_error(dev, addr)))
+				goto err_map;
 
-		/* tracing point */
-		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
-					 DPAA2_ETH_RX_BUF_RAW_SIZE,
-					 addr, priv->rx_buf_size,
-					 ch->bp->bpid);
+			buf_array[i] = addr;
+		}
 	}
 
 release_bufs:
@@ -1698,14 +1736,19 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
 	 * not much else we can do about it
 	 */
 	if (err) {
-		dpaa2_eth_free_bufs(priv, buf_array, i);
+		dpaa2_eth_free_bufs(priv, buf_array, i, ch->xsk_zc);
 		return 0;
 	}
 
 	return i;
 
 err_map:
-	__free_pages(page, 0);
+	if (!ch->xsk_zc) {
+		__free_pages(page, 0);
+	} else {
+		for (; i < batch; i++)
+			xsk_buff_free(xdp_buffs[i]);
+	}
 err_alloc:
 	/* If we managed to allocate at least some buffers,
 	 * release them to hardware
@@ -1764,8 +1807,13 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
 				 int count)
 {
 	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
+	bool xsk_zc = false;
 	int retries = 0;
-	int ret;
+	int i, ret;
+
+	for (i = 0; i < priv->num_channels; i++)
+		if (priv->channel[i]->bp->bpid == bpid)
+			xsk_zc = priv->channel[i]->xsk_zc;
 
 	do {
 		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
@@ -1776,7 +1824,7 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
 		}
-		dpaa2_eth_free_bufs(priv, buf_array, ret);
+		dpaa2_eth_free_bufs(priv, buf_array, ret, xsk_zc);
 		retries = 0;
 	} while (ret);
 }
@@ -2694,6 +2742,8 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	switch (xdp->command) {
 	case XDP_SETUP_PROG:
 		return dpaa2_eth_setup_xdp(dev, xdp->prog);
+	case XDP_SETUP_XSK_POOL:
+		return dpaa2_xsk_setup_pool(dev, xdp->xsk.pool, xdp->xsk.queue_id);
 	default:
 		return -EINVAL;
 	}
@@ -2924,6 +2974,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
+	.ndo_xsk_wakeup = dpaa2_xsk_wakeup,
 	.ndo_setup_tc = dpaa2_eth_setup_tc,
 	.ndo_vlan_rx_add_vid = dpaa2_eth_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = dpaa2_eth_rx_kill_vid
@@ -4247,8 +4298,8 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 {
 	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
 	struct net_device *net_dev = priv->net_dev;
+	struct dpni_pools_cfg pools_params = { 0 };
 	struct device *dev = net_dev->dev.parent;
-	struct dpni_pools_cfg pools_params;
 	struct dpni_error_cfg err_cfg;
 	int err = 0;
 	int i;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 3c4fc46b1324..38f67b98865f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -130,6 +130,7 @@ enum dpaa2_eth_swa_type {
 	DPAA2_ETH_SWA_SINGLE,
 	DPAA2_ETH_SWA_SG,
 	DPAA2_ETH_SWA_XDP,
+	DPAA2_ETH_SWA_XSK,
 	DPAA2_ETH_SWA_SW_TSO,
 };
 
@@ -151,6 +152,9 @@ struct dpaa2_eth_swa {
 			int dma_size;
 			struct xdp_frame *xdpf;
 		} xdp;
+		struct {
+			struct xdp_buff *xdp_buff;
+		} xsk;
 		struct {
 			struct sk_buff *skb;
 			int num_sg;
@@ -429,12 +433,19 @@ enum dpaa2_eth_fq_type {
 };
 
 struct dpaa2_eth_priv;
+struct dpaa2_eth_channel;
+struct dpaa2_eth_fq;
 
 struct dpaa2_eth_xdp_fds {
 	struct dpaa2_fd fds[DEV_MAP_BULK_SIZE];
 	ssize_t num;
 };
 
+typedef void dpaa2_eth_consume_cb_t(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd,
+				    struct dpaa2_eth_fq *fq);
+
 struct dpaa2_eth_fq {
 	u32 fqid;
 	u32 tx_qdbin;
@@ -447,10 +458,7 @@ struct dpaa2_eth_fq {
 	struct dpaa2_eth_channel *channel;
 	enum dpaa2_eth_fq_type type;
 
-	void (*consume)(struct dpaa2_eth_priv *priv,
-			struct dpaa2_eth_channel *ch,
-			const struct dpaa2_fd *fd,
-			struct dpaa2_eth_fq *fq);
+	dpaa2_eth_consume_cb_t *consume;
 	struct dpaa2_eth_fq_stats stats;
 
 	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
@@ -486,6 +494,8 @@ struct dpaa2_eth_channel {
 	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
 	int recycled_bufs_cnt;
 
+	bool xsk_zc;
+	struct xsk_buff_pool *xsk_pool;
 	struct dpaa2_eth_bp *bp;
 };
 
@@ -808,4 +818,22 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 		  struct dpaa2_eth_channel *ch,
 		  const struct dpaa2_fd *fd,
 		  struct dpaa2_eth_fq *fq);
+
+struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv,
+			 struct dpaa2_eth_bp *bp);
+
+void *dpaa2_iova_to_virt(struct iommu_domain *domain, dma_addr_t iova_addr);
+void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   dma_addr_t addr);
+
+void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
+			   struct dpaa2_eth_channel *ch,
+			   struct dpaa2_fd *fd,
+			   void *buf_start, u16 queue_id);
+
+int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
+int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid);
+
 #endif	/* __DPAA2_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
new file mode 100644
index 000000000000..2df7bffec5a7
--- /dev/null
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
+/* Copyright 2022 NXP
+ */
+#include <linux/filter.h>
+#include <linux/compiler.h>
+#include <linux/bpf_trace.h>
+#include <net/xdp.h>
+#include <net/xdp_sock_drv.h>
+
+#include "dpaa2-eth.h"
+
+static void dpaa2_eth_setup_consume_func(struct dpaa2_eth_priv *priv,
+					 struct dpaa2_eth_channel *ch,
+					 enum dpaa2_eth_fq_type type,
+					 dpaa2_eth_consume_cb_t *consume)
+{
+	struct dpaa2_eth_fq *fq;
+	int i;
+
+	for (i = 0; i < priv->num_fqs; i++) {
+		fq = &priv->fq[i];
+
+		if (fq->type != type)
+			continue;
+		if (fq->channel != ch)
+			continue;
+
+		fq->consume = consume;
+	}
+}
+
+static u32 dpaa2_xsk_run_xdp(struct dpaa2_eth_priv *priv,
+			     struct dpaa2_eth_channel *ch,
+			     struct dpaa2_eth_fq *rx_fq,
+			     struct dpaa2_fd *fd, void *vaddr)
+{
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff *xdp_buff;
+	struct dpaa2_eth_swa *swa;
+	u32 xdp_act = XDP_PASS;
+	int err;
+
+	xdp_prog = READ_ONCE(ch->xdp.prog);
+	if (!xdp_prog)
+		goto out;
+
+	swa = (struct dpaa2_eth_swa *)(vaddr + DPAA2_ETH_RX_HWA_SIZE +
+				       ch->xsk_pool->umem->headroom);
+	xdp_buff = swa->xsk.xdp_buff;
+
+	xdp_buff->data_hard_start = vaddr;
+	xdp_buff->data = vaddr + dpaa2_fd_get_offset(fd);
+	xdp_buff->data_end = xdp_buff->data + dpaa2_fd_get_len(fd);
+	xdp_set_data_meta_invalid(xdp_buff);
+	xdp_buff->rxq = &ch->xdp_rxq;
+
+	xsk_buff_dma_sync_for_cpu(xdp_buff, ch->xsk_pool);
+	xdp_act = bpf_prog_run_xdp(xdp_prog, xdp_buff);
+
+	/* xdp.data pointer may have changed */
+	dpaa2_fd_set_offset(fd, xdp_buff->data - vaddr);
+	dpaa2_fd_set_len(fd, xdp_buff->data_end - xdp_buff->data);
+
+	if (likely(xdp_act == XDP_REDIRECT)) {
+		err = xdp_do_redirect(priv->net_dev, xdp_buff, xdp_prog);
+		if (unlikely(err)) {
+			ch->stats.xdp_drop++;
+			dpaa2_eth_recycle_buf(priv, ch, addr);
+		} else {
+			ch->buf_count--;
+			ch->stats.xdp_redirect++;
+		}
+
+		goto xdp_redir;
+	}
+
+	switch (xdp_act) {
+	case XDP_PASS:
+		break;
+	case XDP_TX:
+		dpaa2_eth_xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(priv->net_dev, xdp_prog, xdp_act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
+		fallthrough;
+	case XDP_DROP:
+		dpaa2_eth_recycle_buf(priv, ch, addr);
+		ch->stats.xdp_drop++;
+		break;
+	}
+
+xdp_redir:
+	ch->xdp.res |= xdp_act;
+out:
+	return xdp_act;
+}
+
+/* Rx frame processing routine for the AF_XDP fast path */
+static void dpaa2_xsk_rx(struct dpaa2_eth_priv *priv,
+			 struct dpaa2_eth_channel *ch,
+			 const struct dpaa2_fd *fd,
+			 struct dpaa2_eth_fq *fq)
+{
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	u8 fd_format = dpaa2_fd_get_format(fd);
+	struct rtnl_link_stats64 *percpu_stats;
+	u32 fd_length = dpaa2_fd_get_len(fd);
+	struct sk_buff *skb;
+	void *vaddr;
+	u32 xdp_act;
+
+	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+
+	if (fd_format != dpaa2_fd_single) {
+		WARN_ON(priv->xdp_prog);
+		/* AF_XDP doesn't support any other formats */
+		goto err_frame_format;
+	}
+
+	xdp_act = dpaa2_xsk_run_xdp(priv, ch, fq, (struct dpaa2_fd *)fd, vaddr);
+	if (xdp_act != XDP_PASS) {
+		percpu_stats->rx_packets++;
+		percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
+		return;
+	}
+
+	/* Build skb */
+	skb = dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, vaddr);
+	if (!skb)
+		/* Nothing else we can do, recycle the buffer and
+		 * drop the frame.
+		 */
+		goto err_alloc_skb;
+
+	/* Send the skb to the Linux networking stack */
+	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
+
+	return;
+
+err_alloc_skb:
+	dpaa2_eth_recycle_buf(priv, ch, addr);
+err_frame_format:
+	percpu_stats->rx_dropped++;
+}
+
+static void dpaa2_xsk_set_bp_per_qdbin(struct dpaa2_eth_priv *priv,
+				       struct dpni_pools_cfg *pools_params)
+{
+	int curr_bp = 0, i, j;
+
+	pools_params->pool_options = DPNI_POOL_ASSOC_QDBIN;
+	for (i = 0; i < priv->num_bps; i++) {
+		for (j = 0; j < priv->num_channels; j++)
+			if (priv->bp[i] == priv->channel[j]->bp)
+				pools_params->pools[curr_bp].priority_mask |= (1 << j);
+		if (!pools_params->pools[curr_bp].priority_mask)
+			continue;
+
+		pools_params->pools[curr_bp].dpbp_id = priv->bp[i]->bpid;
+		pools_params->pools[curr_bp].buffer_size = priv->rx_buf_size;
+		pools_params->pools[curr_bp++].backup_pool = 0;
+	}
+	pools_params->num_dpbp = curr_bp;
+}
+
+static int dpaa2_xsk_disable_pool(struct net_device *dev, u16 qid)
+{
+	struct xsk_buff_pool *pool = xsk_get_pool_from_qid(dev, qid);
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpni_pools_cfg pools_params = { 0 };
+	struct dpaa2_eth_channel *ch;
+	int err;
+	bool up;
+
+	ch = priv->channel[qid];
+	if (!ch->xsk_pool)
+		return -EINVAL;
+
+	up = netif_running(dev);
+	if (up)
+		dev_close(dev);
+
+	xsk_pool_dma_unmap(pool, 0);
+	err = xdp_rxq_info_reg_mem_model(&ch->xdp_rxq,
+					 MEM_TYPE_PAGE_ORDER0, NULL);
+	if (err)
+		netdev_err(dev, "xsk_rxq_info_reg_mem_model() failed (err = %d)\n",
+			   err);
+
+	dpaa2_eth_free_dpbp(priv, ch->bp);
+
+	ch->xsk_zc = false;
+	ch->xsk_pool = NULL;
+	ch->bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
+
+	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_eth_rx);
+
+	dpaa2_xsk_set_bp_per_qdbin(priv, &pools_params);
+	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
+	if (err)
+		netdev_err(dev, "dpni_set_pools() failed\n");
+
+	if (up) {
+		err = dev_open(dev, NULL);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int dpaa2_xsk_enable_pool(struct net_device *dev,
+				 struct xsk_buff_pool *pool,
+				 u16 qid)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpni_pools_cfg pools_params = { 0 };
+	struct dpaa2_eth_channel *ch;
+	int err, err2;
+	bool up;
+
+	if (priv->dpni_attrs.wriop_version < DPAA2_WRIOP_VERSION(3, 0, 0)) {
+		netdev_err(dev, "AF_XDP zero-copy not supported on devices <= WRIOP(3, 0, 0)\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (priv->dpni_attrs.num_queues > 8) {
+		netdev_err(dev, "AF_XDP zero-copy not supported on DPNI with more then 8 queues\n");
+		return -EOPNOTSUPP;
+	}
+
+	up = netif_running(dev);
+	if (up)
+		dev_close(dev);
+
+	err = xsk_pool_dma_map(pool, priv->net_dev->dev.parent, 0);
+	if (err) {
+		netdev_err(dev, "xsk_pool_dma_map() failed (err = %d)\n",
+			   err);
+		goto err_dma_unmap;
+	}
+
+	ch = priv->channel[qid];
+	err = xdp_rxq_info_reg_mem_model(&ch->xdp_rxq, MEM_TYPE_XSK_BUFF_POOL, NULL);
+	if (err) {
+		netdev_err(dev, "xdp_rxq_info_reg_mem_model() failed (err = %d)\n", err);
+		goto err_mem_model;
+	}
+	xsk_pool_set_rxq_info(pool, &ch->xdp_rxq);
+
+	priv->bp[priv->num_bps] = dpaa2_eth_allocate_dpbp(priv);
+	if (IS_ERR(priv->bp[priv->num_bps])) {
+		err = PTR_ERR(priv->bp[priv->num_bps]);
+		goto err_bp_alloc;
+	}
+	ch->xsk_zc = true;
+	ch->xsk_pool = pool;
+	ch->bp = priv->bp[priv->num_bps++];
+
+	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_xsk_rx);
+
+	dpaa2_xsk_set_bp_per_qdbin(priv, &pools_params);
+	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
+	if (err) {
+		netdev_err(dev, "dpni_set_pools() failed\n");
+		goto err_set_pools;
+	}
+
+	if (up) {
+		err = dev_open(dev, NULL);
+		if (err)
+			return err;
+	}
+
+	return 0;
+
+err_set_pools:
+	err2 = dpaa2_xsk_disable_pool(dev, qid);
+	if (err2)
+		netdev_err(dev, "dpaa2_xsk_disable_pool() failed %d\n", err2);
+err_bp_alloc:
+	err2 = xdp_rxq_info_reg_mem_model(&priv->channel[qid]->xdp_rxq,
+					  MEM_TYPE_PAGE_ORDER0, NULL);
+	if (err2)
+		netdev_err(dev, "xsk_rxq_info_reg_mem_model() failed with %d)\n", err2);
+err_mem_model:
+	xsk_pool_dma_unmap(pool, 0);
+err_dma_unmap:
+	if (up)
+		dev_open(dev, NULL);
+
+	return err;
+}
+
+int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid)
+{
+	return pool ? dpaa2_xsk_enable_pool(dev, pool, qid) :
+		      dpaa2_xsk_disable_pool(dev, qid);
+}
+
+int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(dev);
+	struct dpaa2_eth_channel *ch = priv->channel[qid];
+
+	if (!priv->link_state.up)
+		return -ENETDOWN;
+
+	if (!priv->xdp_prog)
+		return -EINVAL;
+
+	if (!ch->xsk_zc)
+		return -EINVAL;
+
+	/* We do not have access to a per channel SW interrupt, so instead we
+	 * schedule a NAPI instance.
+	 */
+	if (!napi_if_scheduled_mark_missed(&ch->napi))
+		napi_schedule(&ch->napi);
+
+	return 0;
+}
-- 
2.25.1

