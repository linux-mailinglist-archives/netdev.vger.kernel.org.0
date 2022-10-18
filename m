Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29C5602E38
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJROUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiJROUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:20:04 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 555C865570;
        Tue, 18 Oct 2022 07:19:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWZvrkwcvcyt7ZAl7M3ZQm5uPJPohLIGaYBLxH2YAgUJZec1eIWMrqK9z+/Kuwxy0YjnvhT4e4ir36DpIZv/1IIGDUKCDG99Xyww9cY5XtZKRcGql9qiuYJYsfZm+1eNb/ikniajCWj87pe1KrB0rdyOcwQL+a/IlM3OwYhjKB4CCFZ8RMWjvy68MZSylyrEaUqx0dg4j9RQF4UCq3csc7LrV7tM37IUvxBpBiTpd7ecg579qCqz028WcqENV2hdWqocH8jiVohoVmPUWvid3yqhJsvuw2IhcOtuaG/dJHa2KDJcAwrR4zAapV+LtkrRtgAsCfeQ+j40xWQDdBBNQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1TmZeJseMcIuqfWQg3HnNJDVghovbT0imT0Y/vQZjw=;
 b=IiOUSLx6tbeMmZ22f2t7iyFmscpqFqhpGjhBTCbgyBvzVj4TAsjidGDGfGlH1lAtPBvfTLL12EUfklngodhs1TSQYPGc7+Rz9KbghA08/NrWng8DZFK7XtrfFECZ6OM4w9ztYcPlzgAaa8sDk1kYY4BQkQnmIJu7G9SENfXC9HDAwSWhdzc0HWy1pDjKAbLGRW4I0wz11HMm5ZoRZOxt9wJ8WkAQy4N8A64bo3T8M4taMtWDYK3tnMSQlICrawOHXI66JYosIwiI2u7f+mrti+CUM1YXJES8s2aO1DwGALiq7OKuwQ6KCDNLeah5zniaAJbtxUvmBL5Z5pY45WQ1OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1TmZeJseMcIuqfWQg3HnNJDVghovbT0imT0Y/vQZjw=;
 b=Cdm0ONt7OZkcdY5EaHNVtzjwzHjegzEa7hL5yuHWubOuzXpNm3fa88cYy5kKOoPm2q09TLigWutt0ovoxzOfjGzmXOki5LGFU4vJjgq8Sv1RZyaFoxrKHDhcoHFFboR5W8mqN3ES7lMSYxQV0BsMWdHbPXftwjzBhl9GQt5Jp6Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8706.eurprd04.prod.outlook.com (2603:10a6:20b:429::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 14:19:40 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:40 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 08/12] net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
Date:   Tue, 18 Oct 2022 17:18:57 +0300
Message-Id: <20221018141901.147965-9-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 99aa3672-6715-4415-4852-08dab113cb3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NIQrAM2ozczI0/0wQ263j9Est05xR2osBxl7mStPvG0iON0OwNtK3R//5SD4doUyfv8IwA+HT2eJs/Cz6hu2AsU5qDG2movhJzExsEN5SDLRbHe+ik7GI7UMd+E8KhC7BBsNl8H+7p0zmcnrjPak9HZPWBprU7rE3KSpk5t8BHDQeLVL84t1tXYbir3HZWKpPezp9t5pq5icF720CQQtQVFp2ENC8Uf+eMAM304rDIqat9gMpMCcZ6zBX9naV94IvWWpuQ93MJtSS9CS9aZ0qXZf7niSNRnlnAyFLChbR8gXhz0/4FDCbgAmH4LFjmrG29P/Y8PKgEGxGCBHj8ubwLnGz0VjetF1gpDZnO+wdRm56q+g8y51wR/gd+Vlob7oyYiqWdhdcqZvgLShu4oaLk+v6GwHqFeOmDehbkOC3YI1UZ4ROf/iYKV/aJGQNaFcsOTdxRilLeeKIvTCitt44pMjaxWu92ir1Pb/gswQ3rc/VS/nHdf3LZARoOGmtHTVfmSADz1iS+xTH2jrLFE5dTWc4dCBeQ/LpESkCiogpfkWTeXCNm0L2NEpKhTqFlAfWVOAn1xVwtJbixQjlRtSJVH1DFjNpy6rV/6yAf1CtGoATAqat3GykotSyeidWBrbotIY3//otxHvfepfDJtju7JN7QiLVjmcUJ9Q6fvJEXFwC2vxZba1L1fwhxRx83k1ta/uymWVuk5HhX+jpKn2vkYIpZe6to82I/FeBGE+/LTHlThY06SSBwySCY9xOGVabsOrAvKR4BKCNrcmQGHUVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(451199015)(36756003)(86362001)(7416002)(5660300002)(44832011)(38100700002)(2906002)(38350700002)(186003)(2616005)(1076003)(83380400001)(26005)(6506007)(316002)(478600001)(6486002)(110136005)(54906003)(6512007)(41300700001)(66476007)(66556008)(66946007)(52116002)(4326008)(8936002)(6666004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LjjgHm7IBTjf4py8JJHzJzQPn73uFkl26x/vrJTVHZwI0ASC+eiwSxPYq//f?=
 =?us-ascii?Q?0+3niN+RbTz/s5b8ZcyYgr9r7R/8V+RiTVmoVMrDqs+EFiaJ69LEv1qHkEhh?=
 =?us-ascii?Q?ILQ/hhEsi7/H+eBpppgmpbYO0IU+k2bDt1iYenu9ve1wy6roJaF+OuekGfDC?=
 =?us-ascii?Q?JmLxtMDAy+NOwjgpytBF3UbAokNMudvuf5xFKa6h2kZGR7jtrkbwAkfLzWXQ?=
 =?us-ascii?Q?NaRRBzupAq5eU2ugg4BbWHXl5t5aDkp/zPR7WF4c1IexRqCaq8yEqJ2EtEK2?=
 =?us-ascii?Q?/hiyxJSWl1JQOugK720aRpsYiiCSkzhEL0/N6yxMQHilCeqSxw2vr5SYQqa9?=
 =?us-ascii?Q?IlevLcJuww8d0JAf0DiBjYBhYeM6TVz32bV3cwzrcVyWjc9fI4RJMFRdBnRA?=
 =?us-ascii?Q?kQ65uWYIAxnmbnmm5xURIycubQIUHoZ+4YID2jpjeFs0Q2vm90WBL/DnL8Mm?=
 =?us-ascii?Q?9AB3Jr0PQG2Ar8ztKB3RQ3rdyKlffd+KxyY89CSZZrHQ0yor4W8ZLvniMUre?=
 =?us-ascii?Q?1Bh31wVePsfFavBRQPkw7b3RjLaqUNMp+Cckmak7hckgm09hyrl8z/PIFTDZ?=
 =?us-ascii?Q?so6hhaajgJexo/d5BtXgZ6dX83JXn97cRx+svFxuEE0k1Jp+33wrxOKC1pN3?=
 =?us-ascii?Q?8IPlFjyXdBsCoNtZpoIOFDd4i4Go1dLRT2IOij96z/1APQpwB4dRf5OTQ6Rw?=
 =?us-ascii?Q?auC3vwW1tPu8DsalgFKpcytipLTrQZOsN5/tIWd68bNbPdc773RHq8E8TCzd?=
 =?us-ascii?Q?9sdzr030jdTaaTvQg54I0lh16ico+XHlBggNuQr7D3qTJbRKPOnG0Kk73IRn?=
 =?us-ascii?Q?Y06ODgpvbJjDQgh0fIIWbK+zF83zrK1qWBeFlcKpXUoqVfGsetcatOWCuzPn?=
 =?us-ascii?Q?FTkhTv6Nt+b82c35VJda+W0EbYwMnQudpgy0e7CuArio0LDMd6bp6GNGV38t?=
 =?us-ascii?Q?kV3PsqWYq1cWwGQ6F1tyjBDvTIlOGlmFk8ZtFfDWn5WwmwjNohIkcOyh818Y?=
 =?us-ascii?Q?E//bTNiQ5j17wmaBN+Hd2NOo/b+7VxjTNbbiYMApXI4A8o1faw/elSZyPLua?=
 =?us-ascii?Q?Qu9aa0TNiAnmULw8yGSPc/Gmcj65BH4RAaOiA1cWG1XPD0dN58jIBGjIAMo1?=
 =?us-ascii?Q?sloeE12fhtrDCKExWuYWXl92l5EX3xBmAXNxqhEV6RQRUP6I4bJ6bz3xxcoo?=
 =?us-ascii?Q?I5ENMQv4O1jWebt9HoHmoetGB7XwPEj56bpCFOKxxxxTfZYlaMpl0QG+Vfy1?=
 =?us-ascii?Q?aNIugPs0yzqVuBT36sRVclzECp2S2ph1xquJkmzS1n3dpEQV+dT0DY1+tfyi?=
 =?us-ascii?Q?PxHKhES4NCdlCRTjaLVRERdG2ZbVM+GX//XLnDLu/BbEDwROF/M6tvZ3RZ9/?=
 =?us-ascii?Q?AMxKYlRKmTwL/Z79dXewigWgxiAZtyyPtNQ7M6W6WSO1VZ5KYsMcOBN1negW?=
 =?us-ascii?Q?y+jU944M3tzlKNq6qFAjUPBAfR7gHYM/IiPWZozVD+alO2YIi/FvsHxf+wtl?=
 =?us-ascii?Q?AtfVZCtSu9wHy10OotZfc9w5ZJCOe2pWNACKgjrXqtb5c1ZybqWoAVaANkyb?=
 =?us-ascii?Q?bmud59yUUX5lWb6uNKN9/1H5OPlJv20s9omPgG2+CEdOKQ6y2CqgyXhWIFAY?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99aa3672-6715-4415-4852-08dab113cb3a
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:40.0466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQhXZoQiCbx0xQPSvDd9NxpFG0/EeyK3LjmTirSicnCazhsggasliBjDMofLYuJCiV0fVa7vpcf3I/zyFOJlog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8706
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
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
Changes in v3:
 - none


 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 25 +++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  5 ++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b95e9a7123e0..9909fdf084e3 100644
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

