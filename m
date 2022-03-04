Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126714CD24C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiCDKXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiCDKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:33 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2431239B81
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHQAiSFJsfrj3FkWGTTFHp03uXL2yRLKS7qXaxztIW02ZuFXtuKy4j4TC5aNfEPKKO1D+vnkGQPZv+qswMJQLDypqiXKJ94egAUAxW0Pcmf9Pf61wWfBf2scDMufCN05olobIUydYt9M3ioffnaXPSX/cUIjiIeH3qnhbmdaPWLlXu405s63AXck0TQLITeQt08vvqn94LqHZQTNuIHsPPPoILnxe+1sEvlP2f4pgcA9mwXxV9Nc/G/gAfpYkU5U7LvS5xTYT4hwcG6cvvnuqdgoTlqHrimRpkVeUAvKb9qAPqcIwZOkW7hapAJIqWFefi4vY6CtU1R53D82JyGA2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WGbZGa+38okN9YpcGXw8iSP6EbXWVMZs9a1GrXA1f0Y=;
 b=TAwr+4J6pKPf2FDZI2CXhPN7GmSoTXGKl0qJ/sLV1BL46fhjVS88QiNu+4hGWzKL8wQZaZ0ZabdeVhi2YFz2v9Bpd3UlInIeQyIJZq2cZ3V0tKAWapYtl4p6BV4pGJoEU1WN0xsvADNh0MD8AuB7P/FsBiY+17jAAN0swZr96tfoX0DPf+LD/PS9596ByDZP9GTq6LOaCgr3C17DjmeubOSl03umZ5U4GFJGR/iUkQZm8/0zKm4SzfEyo3hTbySNRSNrUiwupt32EDDtsZ+sGfIct/6cVKDBTlcvLzzYOj+P0NHPitDU+51GYbHPcciUlTaAsSo8Bsswor8CLSKPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WGbZGa+38okN9YpcGXw8iSP6EbXWVMZs9a1GrXA1f0Y=;
 b=B5As7X6WrrsbPY/vF9la6E8W960orxJvkz1ZsgtpPj17aU/2WKiEM8nyEbtzTGzI3qAiyDkjVbhrhPcMJaYHYMUpa7ibc3v/Tq6jhcRFM/oWCP9rqIQ1SMKU1at2PW8T5wRm7reKI/TnhFHcI1mxmXwF3UK11el52AUK9+H/D9I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4539.namprd13.prod.outlook.com (2603:10b6:5:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.7; Fri, 4 Mar
 2022 10:22:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:41 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 1/5] nfp: expose common functions to be used for AF_XDP
Date:   Fri,  4 Mar 2022 11:22:10 +0100
Message-Id: <20220304102214.25903-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220304102214.25903-1-simon.horman@corigine.com>
References: <20220304102214.25903-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e984a34-910c-4419-7162-08d9fdc8ea28
X-MS-TrafficTypeDiagnostic: DM6PR13MB4539:EE_
X-Microsoft-Antispam-PRVS: <DM6PR13MB453955FEF4AA1510A198DFCDE8059@DM6PR13MB4539.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VLhcs9XnOTIoPU6Lduuf9CY3mobFY2u3TnwoJdR75GYVNo2r2qVMsJCZPQQLJleIUViO02FWOgHS8G5OgHnx8l0wVByzAg2c8/PTsGAU6eFxvV4kOm+ZMkloYbaDqJniYcyRhLnn27UPltz6fi9DEsFSBpeTpHDhUPx36b0++31nd237ElJAzHIjd28Y4flR+V+TZDLGBt3sxvB1X5WAD4Y6Ykx714ARTaD+Fj8Ji/afi7PeZEuvgtm5K3dvNyghV+FCi7uIU9wuuzyZy/5ufjBaO988AK0muZf5ZygvnTp2PjcfxHjOoxVffQXvDCg5/4iQGOWhgCVNY+oCJeKeQDis6V/xYZ/ohsbcPTUpaH7NWBvUntu8PueiivsKlJ37LMNd0xPkCnwyhoEM3wHyjLDTv7AEd6f6WyJ+g48Ja3DxbFQY0WUhQdybd4t3BrlhJzlioGrqEBkf+6xObEGPBq7IreT7AAg9NIXIpo7+hQLcpxAH/6xD8HbpjNjNiX0RQ4LB1rWEHouGg9R0Fejzytcj8VJXhPn7BsqEKRQ+cNMkJPDrm0l5O/vOvCVT/Pw0d+S+bJpQJtkOw2C+KVi9z8CXYZs0sAn2d3FBlDkPDUueOVB7+8nxNzjIhtC4H7fTkN+xianZBJFRyDQpEyZ2Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(136003)(376002)(366004)(39830400003)(6486002)(6636002)(8936002)(110136005)(5660300002)(316002)(508600001)(66946007)(66556008)(66476007)(8676002)(4326008)(6506007)(6666004)(52116002)(86362001)(38100700002)(6512007)(83380400001)(66574015)(36756003)(2616005)(2906002)(107886003)(1076003)(44832011)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0YxQS9CV1JtLzZVYnJtUnRpUVp6VHlLTHJXbXhLNTlDTzdpZmNVVVd1UXpU?=
 =?utf-8?B?TXFJQ25ndDBIVkdFWkQ0ZTdoZ2o1R3FNY1YyMUk5SnVPcG1rd3ZLWVQyVFlp?=
 =?utf-8?B?aTJXaXBSSUtmbWsxcDRnSy9DNjd6M0hubTdvTytVUkF1N2RwR1BUTWJXL0pM?=
 =?utf-8?B?VzJWWVdHOHBENzkwWFRsc3JHMjhyVnRSR3FiSmJHTHh6QVk3TUVLc0VUNFYy?=
 =?utf-8?B?enVJU2NSZXBvZ3hEU3F5bDhlcy9YUEpYSHdFS3hJdUJIaWZlZGxPUkNCRERT?=
 =?utf-8?B?Skt6aW5BMG5lY24wc3dkMUZQUVMyQTdXUGtRUVdpNzg3OW9JelUxNEhGR0Z3?=
 =?utf-8?B?Q0Vsd3hTdFV4R0JtUHBmU255NWk5dHc0a041dUNEY010dmNSNnZEOWtzN1lP?=
 =?utf-8?B?a0JHd1dPNU1DakF3V2w1VVVDdTFXMEwrOUgxQllWT3JaNFRvYStKa1dLWWE4?=
 =?utf-8?B?Q1ZzNnFVVjR0TkdIRFF1VG1NREpFQ0NPMXRVYWpuK3Q1cWsyR1M4QjFiUmtM?=
 =?utf-8?B?TXkzNnNNVFlzaks3MXY2U3RpZnd2MjI0YUVBOFE4SndUM0pYTHZjNVJ0bFhX?=
 =?utf-8?B?RTMvekZoTjE4cjJyZjNlSDVQaXJ3ajhCSzZhSnN2QUR3cmJ1eWxzRGdGR2RT?=
 =?utf-8?B?dTJXUmNhNE0rNXRiYU9sc2hORHF2cmFEZC9PS1IwWkI0dnV1MHI2LytjUGFM?=
 =?utf-8?B?amhZZ1pOaHMwNjVKOUlQMHNjV1pTUXVvcGRLcHNJb1lnblF1Q210dDNveE9C?=
 =?utf-8?B?aEZQUnhPbE8zdEE0UTVueG1VQTRnMWdMbnptRklmam9BTWdvSWpGelMyQWda?=
 =?utf-8?B?U2NTbmxaOThrM0FLUmlLTWVhQVYxVkVSaHlPb3lTajNqTUVJdnZsWFhrYTY5?=
 =?utf-8?B?Q0JsalpnOFZvbWdDNUl5TFdUamtPTGVIckR3UnUxS1FnM1Y0RDFTOVpFcVhV?=
 =?utf-8?B?aW9sMEJ6cENacVdUdG9iVERKbkF1TCsrMk5pbTZqOE9EbDFLN0o1ZDZncm1w?=
 =?utf-8?B?QlEwUm1NaGdTQ1R1T1ZTc2V0emp5ZEMrWGZ5T1MvY1ZuUVhWSkZRdnFLZ1RL?=
 =?utf-8?B?MGNwWkQrU0FFQ3lLMXFCelB5V1ZNYXBrdXZ0WUdTMnhuQkEzQ0EwUVQxQ3Vk?=
 =?utf-8?B?SWJ6Ungzem44Wk1wOXhYSkN6RlJyZmRRd2h6RmpLVGo0YldhUzJ4THdnZnlX?=
 =?utf-8?B?cUJVWHpKMTRyMldYMC91SHJTblNpb01kVlltbVJsTmhTakovc0hVOE1iWitz?=
 =?utf-8?B?MGhpWlQvRVNVSHQzQWx2dUg0eEdxUjF4dUEvRlhxaExmTFhjTUNaZ2JTQzlX?=
 =?utf-8?B?Mi9UU0FmRUVLelB1QVVBcllKdzdKemZreXc5WHFjdnl1bFF1dlpZVjFIU1FZ?=
 =?utf-8?B?NExialdzbExlMjRXWU01dEdWSHhnUjZIS3cydzlCYzV5Nk0rc2VBUit6WkJo?=
 =?utf-8?B?SGNLTjRyUUdQWnR0QW91Z3pzQTNYTVVlL09zYTNTdUdrT2ZBbjV5eGlEc2NM?=
 =?utf-8?B?Z1duNlQ1MEdKSGFvTHF1TWdPNDZ5ZjRKVW4yTk1FNnJqQ2pMVHRHSGtOSksv?=
 =?utf-8?B?NVptLzZPS1JRV2UyVEhtS2NZRHlIZW56NVBKM1BzbUdGc3BraHFMbWE2b0Rn?=
 =?utf-8?B?TWFONWwvYlFRNG5vUk1aS1pWTUJRY0tVMmxUZ1Zhb1luakc2TFVuUGxpNHU4?=
 =?utf-8?B?RDlSQkdLVXBvbkNNZFFRUndWUWwveERONjVONUFaRzdhTUc4TjhyaTk1M3hJ?=
 =?utf-8?B?WVk2eThOVHFMc2k0bmJxaGs5aGhDeW16bkFESWVJUkdiMVFsbTFKSTFWK2dK?=
 =?utf-8?B?dU9tU2RxOGlIdmg0L09zTEdwc3J0bE5wZ3Rkbit4MFF6c29wWVp2TzU1V0Jv?=
 =?utf-8?B?L0ZNU0dqdWdML0pXWkx5OXZ0UXFrSGpKWXpCTmMvM3FUVzdoOFhZblNWUWsv?=
 =?utf-8?B?QXMzMFowWm9XOGhXcnNTcEFSWmhZN0pEelorTjAyZEwyc0NGM1FQY2t5VjlG?=
 =?utf-8?B?aXNZb3pXcTZoOUNkRFlYQU9mYXFDV1ZqZE1XSHRYUXFGV1VqZ2pnaythUG5R?=
 =?utf-8?B?M2tkcnBzTHJtVHBSajE3WTQ1K2NCRXRSS3FzQT09?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e984a34-910c-4419-7162-08d9fdc8ea28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:41.5640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ceRmXc6oZ9ugVOb4AgJN/8GZDZFJmBDdtvdbHdQ6SOj6/OT1vkYk1ErxlGjGAV1AHpOrW27Mv2r3cX+SfJIiDAFFQ0sZUqZV4yovmtg2s6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4539
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

There are some common functionality that can be reused in the upcoming
AF_XDP support. Expose those functions in the header. While at it mark
some arguments of nfp_net_rx_csum() as const.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h     | 14 ++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_common.c  | 16 ++++++++--------
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 0b1865e9f0b5..fa40d339df8d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -965,6 +965,7 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd);
 void nfp_net_mbox_reconfig_post(struct nfp_net *nn, u32 update);
 int nfp_net_mbox_reconfig_wait_posted(struct nfp_net *nn);
 
+void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr);
 unsigned int
 nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
 		   unsigned int min_irqs, unsigned int want_irqs);
@@ -973,6 +974,19 @@ void
 nfp_net_irqs_assign(struct nfp_net *nn, struct msix_entry *irq_entries,
 		    unsigned int n);
 
+void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring);
+void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget);
+
+bool
+nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
+		   void *data, void *pkt, unsigned int pkt_len, int meta_len);
+
+void nfp_net_rx_csum(const struct nfp_net_dp *dp,
+		     struct nfp_net_r_vector *r_vec,
+		     const struct nfp_net_rx_desc *rxd,
+		     const struct nfp_meta_parsed *meta,
+		     struct sk_buff *skb);
+
 struct nfp_net_dp *nfp_net_clone_dp(struct nfp_net *nn);
 int nfp_net_ring_reconfig(struct nfp_net *nn, struct nfp_net_dp *new,
 			  struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 79257ec41987..edf7b8716a70 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -381,7 +381,7 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd)
  *
  * Clear the ICR for the IRQ entry.
  */
-static void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr)
+void nfp_net_irq_unmask(struct nfp_net *nn, unsigned int entry_nr)
 {
 	nn_writeb(nn, NFP_NET_CFG_ICR(entry_nr), NFP_NET_CFG_ICR_UNMASKED);
 	nn_pci_flush(nn);
@@ -923,7 +923,7 @@ static void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
 #endif
 }
 
-static void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
+void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 {
 	wmb();
 	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, tx_ring->wr_ptr_add);
@@ -1142,7 +1142,7 @@ static netdev_tx_t nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
  * @tx_ring:	TX ring structure
  * @budget:	NAPI budget (only used as bool to determine if in NAPI context)
  */
-static void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
+void nfp_net_tx_complete(struct nfp_net_tx_ring *tx_ring, int budget)
 {
 	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
 	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
@@ -1587,10 +1587,10 @@ static int nfp_net_rx_csum_has_errors(u16 flags)
  * @meta: Parsed metadata prepend
  * @skb: Pointer to SKB
  */
-static void nfp_net_rx_csum(struct nfp_net_dp *dp,
-			    struct nfp_net_r_vector *r_vec,
-			    struct nfp_net_rx_desc *rxd,
-			    struct nfp_meta_parsed *meta, struct sk_buff *skb)
+void nfp_net_rx_csum(const struct nfp_net_dp *dp,
+		     struct nfp_net_r_vector *r_vec,
+		     const struct nfp_net_rx_desc *rxd,
+		     const struct nfp_meta_parsed *meta, struct sk_buff *skb)
 {
 	skb_checksum_none_assert(skb);
 
@@ -1668,7 +1668,7 @@ nfp_net_set_hash_desc(struct net_device *netdev, struct nfp_meta_parsed *meta,
 			 &rx_hash->hash);
 }
 
-static bool
+bool
 nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		   void *data, void *pkt, unsigned int pkt_len, int meta_len)
 {
-- 
2.20.1

