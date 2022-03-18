Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6E94DD7C3
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 11:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234886AbiCRKPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 06:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiCRKPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 06:15:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2099.outbound.protection.outlook.com [40.107.92.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994CD103B8C
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 03:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FL2g04l4jXUlAj2Lei5nA650kP6Fj+4vpsiDHWPxchZoMmOwQZQSn2qU4Rv0aSJ4yNVVpa0YVw9UhS10pqSii3JIvwtqEHlz6xl4Tja9s+xHfmamwbuLA2oq8DJPjkkIqePc3kw1T4LbS0faVPJrgMtdtx+6PzAc0TxgEI/PSDtaxuwwT4V33vFJo4tE8Ln7uTsDsIiqdf4qYuCXy1L3CCwwbcbWDLLn9/yjsiRLdLvspU2xURO3bkITO1uTMdZ582ZkJ4T610D0mWAC+MR1eSy9iaMf8X/Tl8xz1c7Ik40Dfd8QXsY5Ehi811FKCPdwbfTq6ySM0lIfUyS2YtzJIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D76txMFUiBYznc6iHkRmbExZvdb47cjqHG3KPOXcD8w=;
 b=VBxb2qFGcKDCjH1SxgAB1mFQIOSmBQ8XE1WfL45UdYc7dpCWc+j+XJ/4DGWcHcUsUgPaBjqwSPPu3JhbPIQe41SBvN3F7dJ4V3/p4QMDw8xMwjfkVOYGhsXNsDkint4Nfx3YiEkk+qckWRaBjzQZmGFhhWfmR7N4KCg2UENxhBJkOWGA9QFyQu1x9XBTgVhpo64kgLFr5EnbYlaKIRjC5H7eLRuyQDC8Ra/J0zeErTd+wquEhWk7zTw7rcvfVwJI5W0e/6BHP8fCyKoZhCyYJtbgytqjmaUdubA02y1DOnbyJjnoIxzOm88QQO0hjCuQf7LB6Ee+9/Mt7b9ZDVjcmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D76txMFUiBYznc6iHkRmbExZvdb47cjqHG3KPOXcD8w=;
 b=jhOkLa0/nmMc5Y5zahBeLN1oaBNpDy/4OaRb6Ra4r6Sz/sMqgQxemb5DFKc1+rcfg7aryJnfstUNLICB2XXMAB8YoWcJqSEdCq7zSjaqh+OIrYnVjeclFBqaAMb/8ho3fx1muagnYCrrepScF5JHo+YGAjmFVEkMHJ9+CtOx+Tw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR1301MB2090.namprd13.prod.outlook.com (2603:10b6:4:33::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.7; Fri, 18 Mar
 2022 10:13:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5081.015; Fri, 18 Mar 2022
 10:13:39 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 05/10] nfp: move tx_ring->qcidx into cold data
Date:   Fri, 18 Mar 2022 11:12:57 +0100
Message-Id: <20220318101302.113419-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: a47ca55d-c711-4e79-e8dc-08da08c7f890
X-MS-TrafficTypeDiagnostic: DM5PR1301MB2090:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1301MB2090C08CB170B0546CFB0EF1E8139@DM5PR1301MB2090.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSOFhUWdimlZ70i0LHTlDHtdD2dlInDRIAKBe4Y9jnHig7aQ8Uly2CD+Qav/AQV69CcMvRZ7ZLZFl8v//Ruybzbs4nPVwc3FDiWvP/GkEzbD8jgaNNmAFgf8CRvSsJ+5UaYipp5VzxwmPGOBvbn4P12t28cIZVoiJy9IS+RmEnNX7VwNa3nXoEl9mZyUDrIBjxzr4C6uxT8hgrX/uR2m/dWfgcd5Odms3kgpY+QWq1LxDirnqZEr+Ojyxu/XqVGm/O7FT1OXBxK+9H0QVyPEXp0QyBJ/LH5gN9gkGMkvxeu1iNpSLIEmzb6uzzeyvNO65kUI7kyT96Ok+HSeMw+x4QcBzj+PTewF3OVegwfvPXJ6jjZH3pHuzYY0G5CWa+N0/zB7urUJQMigQbi/L1oNSNNzf4BF381b/aU4RtYRNRDafXoQfC/waIZGNuKf7uYSjLYF6MgOiLst149aypNfX7Ch+J4oD/McDX6//qn7tscl8WgSkTvfBirnGNK7QptmdwhEgW7Enn1rPqa9aW5SgoumdOz7gz0RN3X5fTtRBB3yuZIT/u2/equB5ptKTV/bZMM2oufpmQv3gZCLOkQcwgwOKSbm9QSzMFfTj6JMCLwfIrb3gB87SOo8JOhn8TomS8Dg7vUrqd+cdN+eNfJi+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(396003)(136003)(366004)(39830400003)(346002)(2616005)(107886003)(2906002)(186003)(1076003)(8676002)(86362001)(6512007)(36756003)(6506007)(52116002)(508600001)(83380400001)(5660300002)(66946007)(66556008)(66476007)(44832011)(4326008)(6486002)(38100700002)(316002)(6666004)(110136005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7fpyZOdCfYgyFAcVYOr1PyduxfEchjPQO0YRgnco7GuPIfwRcPMB6DsODjid?=
 =?us-ascii?Q?PtJJpUukFO7lpkFZogGKQlj/BAE4HtVAaWArSPuHpESFzlOAJSHME/rxF3me?=
 =?us-ascii?Q?Hb9qKw/estDy9wO6DOzINTPf0txqibDljn/2eY55s2VDruu86S70rEfCtj21?=
 =?us-ascii?Q?X9Ph02SI7wvr9WI2ogcpM87eWkJF+v1GOIuOCOqqOmwv6RWP+9laVAMaNdVZ?=
 =?us-ascii?Q?TmKb/1icWQXGwlIQ1gc3PlLwCN9FCxDCcW/xqrwCnIqmS8jTNPdZmBYadUN+?=
 =?us-ascii?Q?xnTRK56CbasgV6rUFEVhJAlNNQh+LSjdmrtsKwiZM3PK1zv1QUUDjTVvkMWH?=
 =?us-ascii?Q?zHkRu6112ywWetVd4xJAPrxqFQffDj7NkUZAcnfUc+EbwOOGDhQFALVMvGEt?=
 =?us-ascii?Q?8+t9CM0OMxtSzJHW05k2HRaiE/1nxGARTTiVxAaK82NaKRj6RhM/4YB00aao?=
 =?us-ascii?Q?/v6mKKfXq8v/dILDv+1OTZn3Z0syKZ/6PW+Hd/wBObT85Vj15EAWWoupooGo?=
 =?us-ascii?Q?h5yt4CyyPprEhesmqDvkwtFew35+AGIZtazIgApITdIqsEtq8C/jKob2OWx7?=
 =?us-ascii?Q?4GO/ewIbgWR0sP4pNA3yDpppYDfHTTYXezrseRJUmm5qPL4LWD5aGMt3UhD2?=
 =?us-ascii?Q?HOyK4bv+urLMcppjS+wbgm0kp8F0Ne3n/OxHx8cD5eI++TLasZN0ehxqCS8K?=
 =?us-ascii?Q?QmTXZ63S6kmdJbj1QpvnfONfheQPZG5L1D/wxI19q5uGbqXvNdIDKKIQaalP?=
 =?us-ascii?Q?CNo9WcVPV6prOXbz4CCDhJm8ed1Xl450v8a2kih+5PdcDxg8rJJ4QfCHOth5?=
 =?us-ascii?Q?dxKoslQ9/z2SEnTzXebdjyLo84TujpO9wHTWcW+Fu3mlSLxPeggktgxyLLfX?=
 =?us-ascii?Q?qPuS9JS1GI382u2ycGVXj0ihw7VPYvn+QzC9+Z7KVucAPPcPVn8Fi9q3XDXi?=
 =?us-ascii?Q?FLPmyzCVoVa1Jr+9p2xII6Lvu4foYHmxJDFv6pToWCx+HkjQxNJKG7HhxkJQ?=
 =?us-ascii?Q?38XGvPlMPY4zzzIRCGRT1Xf6V7nln170KPa2EDKTCtAqkhdQqDxX8zk3mdDv?=
 =?us-ascii?Q?8Pud1yTNRI4aeFK2a749DLihdnLZ+YxNQFoqzudRW9/WYImGF90zpPa+VxO0?=
 =?us-ascii?Q?y3OFr0IhBy14SOyFRpNfw4fXq0kGoAWpgyQPgdeSrLY9HTQfUVh0Aw/ROTh4?=
 =?us-ascii?Q?aHreeWm2KwzOFRXiGpVb+KC5QO6VWm4wLH6pkr51VBwfCwb1tFKD087bp+p1?=
 =?us-ascii?Q?eQb7DSN9hTnOr66UfsE88wziVLgmq+lH52q+3kO6aD91vnUj94nFF9RhiHRB?=
 =?us-ascii?Q?mjf1eWyYy0pG4PGhUlkzAsG7L0I0AsqGwJLIfO9/Xn37EO1IT87TVTufvGxQ?=
 =?us-ascii?Q?1zEJ8eQidMcSzfr2CV10DcmJsmGnGoGyAP/lbVUZ0gSahlBLbwosTEqDIA6K?=
 =?us-ascii?Q?XcDCD53dx+GsXFRFxPSjAcj48ZHxBjH6zHCHHjE21taDo/xeeoUFApzc0zVY?=
 =?us-ascii?Q?Y08El4Bb+zQWLsVheio09xJhIGGOrPoTkuzQfwmYzhsBAy6iCjO5M18GqA?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47ca55d-c711-4e79-e8dc-08da08c7f890
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 10:13:38.9200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aPr5DX68txO7RXNhD6I+0mb+EUaQya+yROIXyReASxZzGC8XAvQhs72HuvaeGQed/CdsioHUz06Rjd6uuRArX4tQwuITEOPu/qkBdgLklJg=
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

QCidx is not used on fast path, move it to the lower cacheline.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index d4b82c893c2a..4e288b8f3510 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -125,7 +125,6 @@ struct nfp_nfd3_tx_buf;
  * struct nfp_net_tx_ring - TX ring structure
  * @r_vec:      Back pointer to ring vector structure
  * @idx:        Ring index from Linux's perspective
- * @qcidx:      Queue Controller Peripheral (QCP) queue index for the TX queue
  * @qcp_q:      Pointer to base of the QCP TX queue
  * @cnt:        Size of the queue in number of descriptors
  * @wr_p:       TX ring write pointer (free running)
@@ -135,6 +134,8 @@ struct nfp_nfd3_tx_buf;
  *		(used for .xmit_more delayed kick)
  * @txbufs:     Array of transmitted TX buffers, to free on transmit
  * @txds:       Virtual address of TX ring in host memory
+ *
+ * @qcidx:      Queue Controller Peripheral (QCP) queue index for the TX queue
  * @dma:        DMA address of the TX ring
  * @size:       Size, in bytes, of the TX ring (needed to free)
  * @is_xdp:	Is this a XDP TX ring?
@@ -143,7 +144,6 @@ struct nfp_net_tx_ring {
 	struct nfp_net_r_vector *r_vec;
 
 	u32 idx;
-	int qcidx;
 	u8 __iomem *qcp_q;
 
 	u32 cnt;
@@ -156,6 +156,9 @@ struct nfp_net_tx_ring {
 	struct nfp_nfd3_tx_buf *txbufs;
 	struct nfp_nfd3_tx_desc *txds;
 
+	/* Cold data follows */
+	int qcidx;
+
 	dma_addr_t dma;
 	size_t size;
 	bool is_xdp;
-- 
2.30.2

