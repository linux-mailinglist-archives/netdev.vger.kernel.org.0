Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2CD4DD7C2
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiCRKPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiCRKPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:02 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173FDE438A
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwxOmkf81bBlqdb7rIp1RqoMT/1XzZSnWPln9+rJKETkfwfIMdf8LSW5xlnZCUeJZoULzyCUi2OZ1WrUdUafPdMsUarKL66rvTH3nWMIoJE5hnSUyLlFynM1EVl1R+IyPJtV3Z9alYK8qRvIXulfTNlFJx/jYn6BuhMd3tsdNKAGzR67nLI18bw3m/fXBK09F4p+G2qkQrDxkdHlxbGhE3BGHmuy6+nXfbQhtMW4Y7rRuZrDw9NTGSJj+/Aka8++C7HJ8nsIvD9l+p7oofo5yayY0ACaqPTOxaXoOoUpfH4mNLap5Mrrkq1BqEZ0SAS2OwmZRwuEmHn1AyxfEYYJFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qRwIsxME4yECKGc6XtiOwqUCMk58u83rwT8iL1OC/rY=;
 b=OUYiYeDaNP7doFedVd2uLBfJWLwE+LF/C0lWeMji5nIF5ic8zmEbS7VPRgG9nUjm0/XehHZXLfD5aK1gZ7yJU25XgCCsm8i73hAjpSF7URjxHU/pbCTlotjI3awsP8MtMRBVsDLZT7dbQTk1Lpyqb4vbeUK2L/v1sOiQizv3LsO8I3pISOs7D8ENNYhvpKlF/92Gwpb/cq45MczvrG31aUWXbMWjQylIW7GPG5jS2zvsL8ANGt1mnkR2NWOvWXfENphbuSxdP3CM0ePYljDe0fWGTrqRDMXCq3ubkhOgr+c9r2D8yLFcOT5fhGoBJMZ/uZj4gBhL3+rxQywWwVERDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRwIsxME4yECKGc6XtiOwqUCMk58u83rwT8iL1OC/rY=;
 b=bHKsA+BdR+uPlbcUp+DF0DanvYIAUEUy7SybrdjXaXlahIoYKgcSY/IO3UfiZYnsJX/4VargsN5VG4h10DF+sJOo9D9ssBDHGJu4CgA2/VS7CyyuoZ8/D5Ojzmd/bJ+Q1iPwtjujr87o2YTRskQJrd7f7PzCHjx6gnysXbFqiiM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:36 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 03/10] nfp: use callbacks for slow path ring related functions
Date:   Fri, 18 Mar 2022 11:12:55 +0100
Message-Id: <20220318101302.113419-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318101302.113419-1-simon.horman@corigine.com>
References: <20220318101302.113419-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0114.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab87b780-588a-48a2-3b92-08da08c7f6c9
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB2090C5A01CFA4AAA9750AEFEE8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4HKHapOkcDZet5kCsW+TvRApsV2qBoCsER1DigrZJ37EYTNCNKL3+IDYYA7TGylsco1AgzWQs8BgQNcoNCbnrHLQqAhX2rOWJ9rvBbS9txyW6QfNyCe+sLNDvzBH9DxII3fjKvyX0Wmj7AKzQWXfB2MuAa+bEQslBW1tqmU1/W+XgJVVl1gxvx2kYJcQU6UGGm/IxlVB9j49yXJgik2r229CpwGox/Q0qX7b1gmu90ngQFLSu6V06Y26GXogR9ecyw9KnDm/rJR5mcWQ91Y4TL/QOQ4MmmHBtN5I+deYmZ77Ayau/c92mksCSDNcalCI3Ndy1MGsTEY/V38oUuwCRXYbv5mijVPqPHAjQ3431E2tGphH13lvIs+9kskQr90czRzoL0IQ+pdyMqR//HfmXWxeqFF34ntbKP+FtUALjkpHnJcWvr4Bfto9qHFZC2v3d+7oOP3PQkevXv4BRYYulQu05Rm0mNIX1ExZ34TkNwFePAWjLicG1jk93hOVFo3IVA+gUgRvsL0x8I7CA94RpqX5s1bXFFq57vrbI2noXPY9jUbuC6/2WjsLisVOXhXQPe7hmRS0ODx+0TAF9dC5+kjgEMj+mbrNe2H1u4lbPZj2Nm9NfYXe2iXnHUzTgZdmslWwZ4lpoX1ypCS8AU8bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(30864003)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?id4ODewBA3ry5m/al9D6VxapkOHtcmhiSnO9trxtTCVT277hFF5zj/DXCv3L?=
 =?us-ascii?Q?NogWsSzhgnEuoRdk38DRH/EnMHej0JN7xawJ+j5+N4eGh5d9WVrxnE9QSS2a?=
 =?us-ascii?Q?Jc+1kK+pZpFd5eWFQiOUHDtLPhiEKIM4It4m1KFZa5U2rKsgViu1ht0bUbCH?=
 =?us-ascii?Q?nxAX2N0nIqKjqCyVP22EAmpUULN4hPpqvSbBu4IXmz3PKmtO95xxX86Ck40T?=
 =?us-ascii?Q?ZalOITslJB7FJDLLMqML0Epa8dT2/dmGK6HwXrmu+/6G0lZCs1+/UyOsaMI0?=
 =?us-ascii?Q?ihLw1a6zpyiCOyWAPZaPCf8Pf5P3BTQEfmBb7VAsVWBsHziXcelhBzQQ8prP?=
 =?us-ascii?Q?Jbzh9QBT5s8wQDtqmilG7RTtTJUzr7k2d9ng1GFJ8kbX7JPdAbnaKt8TtoKP?=
 =?us-ascii?Q?WNoU06GhXQJp//JoJfdNKf7bO37fp9GXx/HwDtoFoGGTcbaGQllv7FA5lxvl?=
 =?us-ascii?Q?YPYo4LIfPKc9Hd1F0kL7zR5Gh9EIRSu+uOqieZaLYVCNJqYwvFrOe2DbcUSD?=
 =?us-ascii?Q?gPnFo1/onREZkbLHZBwL/fzMQKk/o4rYh5hrPAF8xTW3/qqSnOgHWLk8cL5J?=
 =?us-ascii?Q?VX72kY5ZDqCkB7qR+kKOfwZXrq1Q1+rkP0/d0quJt7Jv1o0Z5DomiKjuBCx6?=
 =?us-ascii?Q?YfOpJNBEAZ1jgIlV63LhNLIXIm4E+1U/tLVrBWCV83fAitNXYohcy2zI95oO?=
 =?us-ascii?Q?91/E0DSxFfK7kzSspUWFJFXIqQE6/1FwmKhxsL5wch7okDLoS34q4fDTaoXa?=
 =?us-ascii?Q?39TJAsJhsETt7c8mDPPXy7jVn3XoyT6OUQkTFkSViA97osnCuMpQXRQhjXa+?=
 =?us-ascii?Q?UvfqGIuVXPUC1hDEmHVs6CO3h+UQkfaFyIjSotOQ1/xShCN1LfKDX5sc8N8s?=
 =?us-ascii?Q?/InHNT6fYz0APIbFmRNRH9mKRVXRH9vpLmuG1lyV5JTJxFbRX6FM19b5jFpN?=
 =?us-ascii?Q?WWP4qFNWQn516G5aoLHKY1rAfgiFMgtnaLeRx97T1c8ULSTb06dkRd9AVxTl?=
 =?us-ascii?Q?JWPuSTbCFFES1LhOAQeK81zQIrK/r3Fn80/qNJeX7EGWG7ZpLgDEF5qJCRs8?=
 =?us-ascii?Q?sPXTO+aRqkAcimr66gicu1XYDiUwYC/tYEZnBCE+DrrlF/vBiUKdGfym7yES?=
 =?us-ascii?Q?IzDAShY2E9LBhTRfIYyaPuauUivK4vNMWUwu1u89EaOtyL/5sjTjxd0fCel8?=
 =?us-ascii?Q?LVXE/2zdF1V5/oKvrAXCY777VoJ7StpDO4Es4Cvz+ljACgAiLGyYgB8oziaY?=
 =?us-ascii?Q?hdPm0cdf1wuaSw09fqYM3Bl3915Bo/2GnpGOWnt2TsZR6Yew1vWqPCMaqDRJ?=
 =?us-ascii?Q?+4ylJ5rSxrDWufLeXy9wtPkv95AOzmUtc4/hQLvkrxc3C5C0BqH0VAvzh/DY?=
 =?us-ascii?Q?42jV4adwCI0hNDDC4/5bYOphrk/47YLSgOuDEcgo3x6uYeTvE/yy7fSfkvAI?=
 =?us-ascii?Q?3+ytanSrC472Be2e1Ti4gXeOE6ErONVvcdKpQXaXCwesQWlwTyZm1S4K6Xux?=
 =?us-ascii?Q?wFJoSbAVlci2ugaaQi1/zgYzxfSExxC9UL1MV5LvAkgRtgcN3mdLu/fPrw?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab87b780-588a-48a2-3b92-08da08c7f6c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:36.1055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kGOD3bADuRd37Icz+fNEDuiBbrgOzpfNE9od0QbfThundKTDgi4C6sx70drFGOSXRXuF9jSEgCIq/Eu3GwleazQcVs6SJKiw6ImbufBywc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1301MB2090
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

To reduce the coupling of slow path ring implementations and their
callers, use callbacks instead.

Changes to Jakub's work:
* Also use callbacks for xmit functions

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  27 +----
 .../net/ethernet/netronome/nfp/nfd3/nfd3.h    |  28 +----
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  28 ++++-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   4 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   7 +-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_dp.c   |  55 ++-------
 .../net/ethernet/netronome/nfp/nfp_net_dp.h   | 111 +++++++++++++++---
 8 files changed, 148 insertions(+), 114 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index b2a34a09471b..619f4d09e4e0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -1131,9 +1131,9 @@ int nfp_nfd3_poll(struct napi_struct *napi, int budget)
 /* Control device data path
  */
 
-static bool
-nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
-		struct sk_buff *skb, bool old)
+bool
+nfp_nfd3_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old)
 {
 	unsigned int real_len = skb->len, meta_len = 0;
 	struct nfp_net_tx_ring *tx_ring;
@@ -1215,31 +1215,12 @@ nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	return false;
 }
 
-bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-
-	return nfp_ctrl_tx_one(nn, r_vec, skb, false);
-}
-
-bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
-	bool ret;
-
-	spin_lock_bh(&r_vec->lock);
-	ret = nfp_ctrl_tx_one(nn, r_vec, skb, false);
-	spin_unlock_bh(&r_vec->lock);
-
-	return ret;
-}
-
 static void __nfp_ctrl_tx_queued(struct nfp_net_r_vector *r_vec)
 {
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&r_vec->queue)))
-		if (nfp_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
+		if (nfp_nfd3_ctrl_tx_one(r_vec->nfp_net, r_vec, skb, true))
 			return;
 }
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
index 0bd597ad6c6e..7a0df9e6c3c4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
@@ -93,34 +93,14 @@ nfp_nfd3_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		    void *data, void *pkt, unsigned int pkt_len, int meta_len);
 void nfp_nfd3_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget);
 int nfp_nfd3_poll(struct napi_struct *napi, int budget);
+netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev);
+bool
+nfp_nfd3_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+		     struct sk_buff *skb, bool old);
 void nfp_nfd3_ctrl_poll(struct tasklet_struct *t);
 void nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 				    struct nfp_net_rx_ring *rx_ring);
 void nfp_nfd3_xsk_tx_free(struct nfp_nfd3_tx_buf *txbuf);
 int nfp_nfd3_xsk_poll(struct napi_struct *napi, int budget);
 
-void
-nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-			       struct nfp_net_rx_ring *rx_ring);
-int
-nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring);
-int
-nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			    struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			   struct nfp_net_tx_ring *tx_ring);
-void
-nfp_nfd3_print_tx_descs(struct seq_file *file,
-			struct nfp_net_r_vector *r_vec,
-			struct nfp_net_tx_ring *tx_ring,
-			u32 d_rd_p, u32 d_wr_p);
-netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev);
-bool nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
-bool __nfp_nfd3_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb);
-
 #endif
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 4c6aaebb7522..342871d23e15 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -38,7 +38,7 @@ static void nfp_nfd3_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring)
  *
  * Assumes that the device is stopped, must be idempotent.
  */
-void
+static void
 nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 {
 	struct netdev_queue *nd_q;
@@ -98,7 +98,7 @@ nfp_nfd3_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
  * nfp_nfd3_tx_ring_free() - Free resources allocated to a TX ring
  * @tx_ring:   TX ring to free
  */
-void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
+static void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
 	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
@@ -123,7 +123,7 @@ void nfp_nfd3_tx_ring_free(struct nfp_net_tx_ring *tx_ring)
  *
  * Return: 0 on success, negative errno otherwise.
  */
-int
+static int
 nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
@@ -156,7 +156,7 @@ nfp_nfd3_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 	return -ENOMEM;
 }
 
-void
+static void
 nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
 			   struct nfp_net_tx_ring *tx_ring)
 {
@@ -174,7 +174,7 @@ nfp_nfd3_tx_ring_bufs_free(struct nfp_net_dp *dp,
 	}
 }
 
-int
+static int
 nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
 			    struct nfp_net_tx_ring *tx_ring)
 {
@@ -195,7 +195,7 @@ nfp_nfd3_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
 	return 0;
 }
 
-void
+static void
 nfp_nfd3_print_tx_descs(struct seq_file *file,
 			struct nfp_net_r_vector *r_vec,
 			struct nfp_net_tx_ring *tx_ring,
@@ -241,3 +241,19 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 		seq_putc(file, '\n');
 	}
 }
+
+const struct nfp_dp_ops nfp_nfd3_ops = {
+	.version		= NFP_NFD_VER_NFD3,
+	.poll			= nfp_nfd3_poll,
+	.xsk_poll		= nfp_nfd3_xsk_poll,
+	.ctrl_poll		= nfp_nfd3_ctrl_poll,
+	.xmit			= nfp_nfd3_tx,
+	.ctrl_tx_one		= nfp_nfd3_ctrl_tx_one,
+	.rx_ring_fill_freelist	= nfp_nfd3_rx_ring_fill_freelist,
+	.tx_ring_alloc		= nfp_nfd3_tx_ring_alloc,
+	.tx_ring_reset		= nfp_nfd3_tx_ring_reset,
+	.tx_ring_free		= nfp_nfd3_tx_ring_free,
+	.tx_ring_bufs_alloc	= nfp_nfd3_tx_ring_bufs_alloc,
+	.tx_ring_bufs_free	= nfp_nfd3_tx_ring_bufs_free,
+	.print_tx_descs		= nfp_nfd3_print_tx_descs
+};
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index bffe53f4c2d3..13a9e6731d0d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -98,6 +98,7 @@
 /* Forward declarations */
 struct nfp_cpp;
 struct nfp_dev_info;
+struct nfp_dp_ops;
 struct nfp_eth_table_port;
 struct nfp_net;
 struct nfp_net_r_vector;
@@ -439,6 +440,7 @@ struct nfp_stat_pair {
  * @rx_rings:		Array of pre-allocated RX ring structures
  * @ctrl_bar:		Pointer to mapped control BAR
  *
+ * @ops:		Callbacks and parameters for this vNIC's NFD version
  * @txd_cnt:		Size of the TX ring in number of descriptors
  * @rxd_cnt:		Size of the RX ring in number of descriptors
  * @num_r_vecs:		Number of used ring vectors
@@ -473,6 +475,8 @@ struct nfp_net_dp {
 
 	/* Cold data follows */
 
+	const struct nfp_dp_ops *ops;
+
 	unsigned int txd_cnt;
 	unsigned int rxd_cnt;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 1d3277068301..dd234f5228f1 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -754,7 +754,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 
 			__skb_queue_head_init(&r_vec->queue);
 			spin_lock_init(&r_vec->lock);
-			tasklet_setup(&r_vec->tasklet, nfp_nfd3_ctrl_poll);
+			tasklet_setup(&r_vec->tasklet, nn->dp.ops->ctrl_poll);
 			tasklet_disable(&r_vec->tasklet);
 		}
 
@@ -768,7 +768,7 @@ nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec, int idx)
 	if (dp->netdev)
 		netif_napi_add(dp->netdev, &r_vec->napi,
 			       nfp_net_has_xsk_pool_slow(dp, idx) ?
-			       nfp_nfd3_xsk_poll : nfp_nfd3_poll,
+			       dp->ops->xsk_poll : dp->ops->poll,
 			       NAPI_POLL_WEIGHT);
 	else
 		tasklet_enable(&r_vec->tasklet);
@@ -1895,7 +1895,7 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_uninit		= nfp_app_ndo_uninit,
 	.ndo_open		= nfp_net_netdev_open,
 	.ndo_stop		= nfp_net_netdev_close,
-	.ndo_start_xmit		= nfp_nfd3_tx,
+	.ndo_start_xmit		= nfp_net_tx,
 	.ndo_get_stats64	= nfp_net_stat64,
 	.ndo_vlan_rx_add_vid	= nfp_net_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= nfp_net_vlan_rx_kill_vid,
@@ -2033,6 +2033,7 @@ nfp_net_alloc(struct pci_dev *pdev, const struct nfp_dev_info *dev_info,
 	nn->dp.ctrl_bar = ctrl_bar;
 	nn->dev_info = dev_info;
 	nn->pdev = pdev;
+	nn->dp.ops = &nfp_nfd3_ops;
 
 	nn->max_tx_rings = max_tx_rings;
 	nn->max_rx_rings = max_rx_rings;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index 59b852e18758..791203d07ac7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -105,7 +105,7 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 		   tx_ring->cnt, &tx_ring->dma, tx_ring->txds,
 		   tx_ring->rd_p, tx_ring->wr_p, d_rd_p, d_wr_p);
 
-	nfp_net_debugfs_print_tx_descs(file, r_vec, tx_ring,
+	nfp_net_debugfs_print_tx_descs(file, &nn->dp, r_vec, tx_ring,
 				       d_rd_p, d_wr_p);
 out:
 	rtnl_unlock();
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
index 8fe48569a612..431bd2c13221 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
@@ -392,57 +392,28 @@ void nfp_net_vec_clear_ring_data(struct nfp_net *nn, unsigned int idx)
 	nn_writeb(nn, NFP_NET_CFG_TXR_VEC(idx), 0);
 }
 
-void
-nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	nfp_nfd3_tx_ring_reset(dp, tx_ring);
-}
-
-void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-				   struct nfp_net_rx_ring *rx_ring)
+netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 {
-	nfp_nfd3_rx_ring_fill_freelist(dp, rx_ring);
-}
+	struct nfp_net *nn = netdev_priv(netdev);
 
-int
-nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
-{
-	return nfp_nfd3_tx_ring_alloc(dp, tx_ring);
+	return nn->dp.ops->xmit(skb, netdev);
 }
 
-void
-nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
 {
-	nfp_nfd3_tx_ring_free(tx_ring);
-}
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
 
-int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring)
-{
-	return nfp_nfd3_tx_ring_bufs_alloc(dp, tx_ring);
+	return nn->dp.ops->ctrl_tx_one(nn, r_vec, skb, false);
 }
 
-void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring)
-{
-	nfp_nfd3_tx_ring_bufs_free(dp, tx_ring);
-}
-
-void
-nfp_net_debugfs_print_tx_descs(struct seq_file *file,
-			       struct nfp_net_r_vector *r_vec,
-			       struct nfp_net_tx_ring *tx_ring,
-			       u32 d_rd_p, u32 d_wr_p)
+bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
 {
-	nfp_nfd3_print_tx_descs(file, r_vec, tx_ring, d_rd_p, d_wr_p);
-}
+	struct nfp_net_r_vector *r_vec = &nn->r_vecs[0];
+	bool ret;
 
-bool __nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	return __nfp_nfd3_ctrl_tx(nn, skb);
-}
+	spin_lock_bh(&r_vec->lock);
+	ret = nn->dp.ops->ctrl_tx_one(nn, r_vec, skb, false);
+	spin_unlock_bh(&r_vec->lock);
 
-bool nfp_ctrl_tx(struct nfp_net *nn, struct sk_buff *skb)
-{
-	return nfp_nfd3_ctrl_tx(nn, skb);
+	return ret;
 }
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
index 30ccdf5aa819..25af0e3c7af7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
@@ -5,7 +5,6 @@
 #define _NFP_NET_DP_
 
 #include "nfp_net.h"
-#include "nfd3/nfd3.h"
 
 static inline dma_addr_t nfp_net_dma_map_rx(struct nfp_net_dp *dp, void *frag)
 {
@@ -100,21 +99,103 @@ void nfp_net_rx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_tx_rings_free(struct nfp_net_dp *dp);
 void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring);
 
-void
-nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
-				   struct nfp_net_rx_ring *rx_ring);
-int
-nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-void
-nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring);
-int nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring);
-void nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
-			       struct nfp_net_tx_ring *tx_ring);
-void
-nfp_net_debugfs_print_tx_descs(struct seq_file *file,
+enum nfp_nfd_version {
+	NFP_NFD_VER_NFD3,
+};
+
+/**
+ * struct nfp_dp_ops - Hooks to wrap different implementation of different dp
+ * @version:			Indicate dp type
+ * @poll:			Napi poll for normal rx/tx
+ * @xsk_poll:			Napi poll when xsk is enabled
+ * @ctrl_poll:			Tasklet poll for ctrl rx/tx
+ * @xmit:			Xmit for normal path
+ * @ctrl_tx_one:		Xmit for ctrl path
+ * @rx_ring_fill_freelist:	Give buffers from the ring to FW
+ * @tx_ring_alloc:		Allocate resource for a TX ring
+ * @tx_ring_reset:		Free any untransmitted buffers and reset pointers
+ * @tx_ring_free:		Free resources allocated to a TX ring
+ * @tx_ring_bufs_alloc:		Allocate resource for each TX buffer
+ * @tx_ring_bufs_free:		Free resources allocated to each TX buffer
+ * @print_tx_descs:		Show TX ring's info for debug purpose
+ */
+struct nfp_dp_ops {
+	enum nfp_nfd_version version;
+
+	int (*poll)(struct napi_struct *napi, int budget);
+	int (*xsk_poll)(struct napi_struct *napi, int budget);
+	void (*ctrl_poll)(struct tasklet_struct *t);
+	netdev_tx_t (*xmit)(struct sk_buff *skb, struct net_device *netdev);
+	bool (*ctrl_tx_one)(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
+			    struct sk_buff *skb, bool old);
+	void (*rx_ring_fill_freelist)(struct nfp_net_dp *dp,
+				      struct nfp_net_rx_ring *rx_ring);
+	int (*tx_ring_alloc)(struct nfp_net_dp *dp,
+			     struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_reset)(struct nfp_net_dp *dp,
+			      struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_free)(struct nfp_net_tx_ring *tx_ring);
+	int (*tx_ring_bufs_alloc)(struct nfp_net_dp *dp,
+				  struct nfp_net_tx_ring *tx_ring);
+	void (*tx_ring_bufs_free)(struct nfp_net_dp *dp,
+				  struct nfp_net_tx_ring *tx_ring);
+
+	void (*print_tx_descs)(struct seq_file *file,
 			       struct nfp_net_r_vector *r_vec,
 			       struct nfp_net_tx_ring *tx_ring,
 			       u32 d_rd_p, u32 d_wr_p);
+};
+
+static inline void
+nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_reset(dp, tx_ring);
+}
+
+static inline void
+nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
+			      struct nfp_net_rx_ring *rx_ring)
+{
+	dp->ops->rx_ring_fill_freelist(dp, rx_ring);
+}
+
+static inline int
+nfp_net_tx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_alloc(dp, tx_ring);
+}
+
+static inline void
+nfp_net_tx_ring_free(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
+{
+	dp->ops->tx_ring_free(tx_ring);
+}
+
+static inline int
+nfp_net_tx_ring_bufs_alloc(struct nfp_net_dp *dp,
+			   struct nfp_net_tx_ring *tx_ring)
+{
+	return dp->ops->tx_ring_bufs_alloc(dp, tx_ring);
+}
+
+static inline void
+nfp_net_tx_ring_bufs_free(struct nfp_net_dp *dp,
+			  struct nfp_net_tx_ring *tx_ring)
+{
+	dp->ops->tx_ring_bufs_free(dp, tx_ring);
+}
+
+static inline void
+nfp_net_debugfs_print_tx_descs(struct seq_file *file, struct nfp_net_dp *dp,
+			       struct nfp_net_r_vector *r_vec,
+			       struct nfp_net_tx_ring *tx_ring,
+			       u32 d_rd_p, u32 d_wr_p)
+{
+	dp->ops->print_tx_descs(file, r_vec, tx_ring, d_rd_p, d_wr_p);
+}
+
+extern const struct nfp_dp_ops nfp_nfd3_ops;
+
+netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev);
+
 #endif /* _NFP_NET_DP_ */
-- 
2.30.2

