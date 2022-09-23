Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31415E7EE9
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbiIWPre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiIWPqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:53 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2071.outbound.protection.outlook.com [40.107.21.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F19F82D34;
        Fri, 23 Sep 2022 08:46:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AoSksGxXoe/PaSqidh9cz2wVKM4z1sdTverv59IYbOIf3J6i/uwBm19krrWopz3yAb7K21Sfj5MrmtB8rbc52qD3M200r5pvuYRA3/X1eQc7quwduxPLQE3yjPDWGPEXyzzj/PIl8oJR7/nIQZ0rxZBNs6fjJTeIjSWeZTdbJaHROPmA6jN3QdkLnKbZf07lOnaQ2PSObCjMUJIpmkvktN8chtcmTykrhZCApL2VcL95mDsl7s86SqQb0OsXwJkX9naYwDWcAuOlmxfcyDU466VdBs+icXF+u4DtCgpAH5wb83OJoYAvijCXGFPNaBOlKOgJ2lcm24ey+3cI8Wfu0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tfy1cQe2pjTdl74BJUssYxOzvnUsE5DOmtj4haeFNqA=;
 b=D4yk7uOjdkx556aWSSJZ+2nbQ4IkEdesp6PyC/9jalWyglr8w9XOO+8X966AEf5ZoGXX8quDPqQ4UW9W+edR+KlyH5DstnIZ7yRrYNAvXETduZGpOllA8VDBR76LoD8x53s6kJoQzbgL2XInQvaVHO+YK5PyP9goe159BcLyz7/S8o6qHjlf3YLqY8IYQ9+dJq8RuwjYMV3We9KZXwZQI1JnJ67yROOxqpk+wwduTTkCp7zooki5ylLkH8oRew4sLgm1DzkgOQRtyG6WNG8djI//HEyyYKyd0OPY8P4saTQGAQh1l2cw7zT1jXfdXt+Acmr0g5tVFP54s/iLbOpvLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tfy1cQe2pjTdl74BJUssYxOzvnUsE5DOmtj4haeFNqA=;
 b=Rc+/wjGnY6ZMFM+/Jq8ZYB/Sz4ZZ5v18Gy9wFdmRizTQ3DgSfDLEsGqYbs4vq/lOqQ+hZZJ7yrMwjHp4BslkbBPso+ZSkUVRCdX34LKmmaZYgpSIpQ/BrYgPyCgHD+I9/YUllUT3/sZwKfGA2jffpPC8K3YJc89eUUZgKTN7C5E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:49 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:49 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 08/12] net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
Date:   Fri, 23 Sep 2022 18:45:52 +0300
Message-Id: <20220923154556.721511-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220923154556.721511-1-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 9afe0694-7931-4ac9-bc05-08da9d7ad3ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WWWAK8lPnnncQBpF7WLZjNswJLBX2Lf8YliF7loFqk3Os5vgTghvDbeWZzJQ4CJsovbMJKXtFxsk7VPmUFy+2d7WPgykcfsoCGbb+1k0VhJcZU5TXarkSEoKIMNI9isrY8n5ntYKVrg0Y1i1RLo/rd4e7YPQEvOx609xqULiaOVJETtkA0TZQnrppgokjnf3ILgSYHoJtSPhPlgE0OdWiVkuznNAvdKRPAo/PuhupEkD0fsYZlxeVanbfa5yPdZEmfh7BzpC64TkLt54TrOaNJAjHh0XCP6/uao5Sac/ePfzUJKECKg0f86HA+6kgIk3UbqEykQAR/ejF6u21yOqXf9Av3HN0+PqNZJTl968O8b0/KRLLRCcbRIG92ijhWPYiv2ezdiqYH3T/+7VuZjnww3FOdlYVHitPerK2IyDoIJqmkyrNJKdj+3YKTSt3KOskPcL+Gi7B5DfRwQbU53ddT03qHjMB+RnbNiABihtm3wEveIkbO+J83BWii3DLVW6L3JMuNV2onRrpDWFYJjN/61N2wZd8KrHuSgl99ZE2Tper30mbL5lNtWifePMCpVTIyrRz9YhNy29NF/+zhLssu1c+wY/ceM3K3LcTUYNl6AEc+suVYFXOrezY1HRuwAVaZKNtCYC1weNahZ7pZQTrWrYA4ZdkFTBfsuCD2aWMg3KO+Ur+P+/WZX+t/1gNa0ZbDQ5G/NoNdcFjbeC6wL5pHzaWc5zReq3l1z8QmxwdzEUYhkHXOIYRoYN5XUDsu//yuH78XJp3/tuc4XFt1HOtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(451199015)(66476007)(41300700001)(52116002)(83380400001)(6506007)(66556008)(4326008)(66946007)(8676002)(26005)(36756003)(6512007)(38350700002)(8936002)(38100700002)(6486002)(110136005)(54906003)(6666004)(316002)(478600001)(2906002)(2616005)(44832011)(86362001)(1076003)(7416002)(5660300002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cA8iyeP5HNaloh80j/F6A1D0IMxYel6ggivhcZiWO+z6LEFKFZ06R7ZAan2+?=
 =?us-ascii?Q?Tb7lkUs49xgAM+syNmnqAiMMl5l3ZEAwzKeTyzWXAceMMNSIy0zpFtYYHJoc?=
 =?us-ascii?Q?gj5L/HJFMEerx9PfvA/PU6UGYvZDzp/vbv8+9GJkMnuqCjnGXIWyIneFVyIT?=
 =?us-ascii?Q?dOyVgLPcdvm2r26eQnjqk0qWJzEqOizwOgfevqRLBalJHlRmeuc93HJkpG8U?=
 =?us-ascii?Q?rbm6zlg6PJxTkduHicvCMtnCf6i1VZA4qhrizrMC7+B9eDW3/U1ba0ziUmFx?=
 =?us-ascii?Q?i0U60XQpsoQnbwXhoLWLnBuqMVga6Xnw45GurVd6WdiZkK53ZwpL/FX9RsAi?=
 =?us-ascii?Q?DsRurvzFZnV+3SmJ6eHCudv1iMrbOGV3RIcasXy6mj3SWzEkSUu1dk04v8ix?=
 =?us-ascii?Q?JtwlcJSMG62c49sOfgeVpHHSJlJIYs+llPRH9nbCfYGIjyjzqko5U9EYUvj9?=
 =?us-ascii?Q?glBOxCrfUo2bKBCoiCNhlcW5qJOJZD75cxU8OZ13mapXEwz2tDxa+olmk//U?=
 =?us-ascii?Q?vkfF/D1OYHc7GoT4fryshavwJ/2UadIF4z8Q8bgoFDswDjOEHhSL3KyiFU8A?=
 =?us-ascii?Q?yZoEze/FaqyRFS87XWOAIjTW4epkL6lxOpM8Jxd+SeIREOHx3ZIv17Se1o97?=
 =?us-ascii?Q?kFm34f5WTo5QZDd3Jf8dNi4g0qQUayq4YHdeD2EaBOmlFLDQbbYMHEmo8lnI?=
 =?us-ascii?Q?Xjje00PkKbEwbJetzCo0OHkDy7kHpbfZVkVeZoV8z4vldUgx7nm36rssxPmh?=
 =?us-ascii?Q?9aGQ5qhvNhoeqpxjbLsenKyqxDtoFaWr5+zxQCmIL/S0ZfTkGnfBNI1exyoB?=
 =?us-ascii?Q?QCSSKT35r8QE4m5pmWzkYUEelBpZRuSdJFkIfRfW4llHlCE0lH3W+vH0EWVo?=
 =?us-ascii?Q?chL4q8NYBp6nJGiyYi4NoThwbaNpa79IAF/orQYG7CbOUCJ9Q6ny+irS07dU?=
 =?us-ascii?Q?Oc4KD2XY5ThoBS79uzuInxMV5QicswOQXvV/bOSpO4k13QhDt8fYM0CIdZCZ?=
 =?us-ascii?Q?90OrN95QsG3c6/bRi/uxrKZrwpAKDgnU//NxIEbTS8JZERFxOJJ9oGu4ueys?=
 =?us-ascii?Q?D3uyMdhzUUp6bcf83BN3ciBnAbjw8Nzik97D+twHksCGOOmT8FwxGf120ByT?=
 =?us-ascii?Q?/cDNXDgYbOs34cHJNKTkkeE0/xhgxuadHhOWWpex1nyto9FGZNtq4P/LRqV4?=
 =?us-ascii?Q?/p6tD3I3ZyrttHd87krI/spcYTTvIwDx4utsdivYknK9jt0PsUzo33TDq2U9?=
 =?us-ascii?Q?B/XyIFNitxnhHQiCoGyh99PPa5oUJQ+isJHciQIKynxhISAQvXPmcOF2YWo8?=
 =?us-ascii?Q?4lpca3kokDfVb6BBWASwSwsLftu8vC4TLSg1wJ8UXvinQgmKpWxTlDgv5CD/?=
 =?us-ascii?Q?HghrHZu9KXJWOkObFPJwGXqU61ILkugwQ56giAo0Ez0G+tegWlkjoCuDijLy?=
 =?us-ascii?Q?5XDwwxkfK65v/zkXKqK64MHOdN0k6pMJ6nNS5TNWDEkLvXbutqiKZkilbWDB?=
 =?us-ascii?Q?QC+Qo3py7c5uAi+L/cmA4e3czyr3zFGkZxSnLTALS3J6v8bdovBT221ahK2n?=
 =?us-ascii?Q?uNc7ZHeT7Wq2IXCKhIf1Uoh032DcJS1EuMm/HmUx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afe0694-7931-4ac9-bc05-08da9d7ad3ab
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:49.3226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfqEvvXAS9+1/ahIjbe7y2Rd+RcjlFaVDRyDaV4qLz/VpUGtqXmdZO5aR6Vhxa9WjktSVM1WvR9dv9QUKn0xmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
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

The dpaa2_eth_alloc_skb() function is added by moving code from the
dpaa2_eth_copybreak() previously defined function. What the new API does
is to allocate a new skb, copy the frame data from the passed FD to the
new skb and then return the skb.
Export this new function since we'll need the this functionality also
from the XSK code path.

Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 25 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  5 ++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d40d25e62b6a..a3958f02bd7e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -485,19 +485,15 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	return xdp_act;
 }
 
-static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
-					   const struct dpaa2_fd *fd,
-					   void *fd_vaddr)
+struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd, u32 fd_length,
+				    void *fd_vaddr)
 {
 	u16 fd_offset = dpaa2_fd_get_offset(fd);
-	struct dpaa2_eth_priv *priv = ch->priv;
-	u32 fd_length = dpaa2_fd_get_len(fd);
 	struct sk_buff *skb = NULL;
 	unsigned int skb_len;
 
-	if (fd_length > priv->rx_copybreak)
-		return NULL;
-
 	skb_len = fd_length + dpaa2_eth_needed_headroom(NULL);
 
 	skb = napi_alloc_skb(&ch->napi, skb_len);
@@ -514,6 +510,19 @@ static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
 	return skb;
 }
 
+static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
+					   const struct dpaa2_fd *fd,
+					   void *fd_vaddr)
+{
+	struct dpaa2_eth_priv *priv = ch->priv;
+	u32 fd_length = dpaa2_fd_get_len(fd);
+
+	if (fd_length > priv->rx_copybreak)
+		return NULL;
+
+	return dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, fd_vaddr);
+}
+
 /* Main Rx frame processing routine */
 static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			 struct dpaa2_eth_channel *ch,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index bb0881e7033b..7c46ec37b29a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -791,4 +791,9 @@ struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
 
 struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv);
 void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv, struct dpaa2_eth_bp *bp);
+
+struct sk_buff *dpaa2_eth_alloc_skb(struct dpaa2_eth_priv *priv,
+				    struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd, u32 fd_length,
+				    void *fd_vaddr);
 #endif	/* __DPAA2_H */
-- 
2.25.1

