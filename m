Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CAD4CD250
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiCDKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiCDKXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:42 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC9E4F46A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyRi+9VctJ8xPlgVCOFIZN7nOA3gmdMUTAeFTyHB5nZEPkDCRoGstm0k6V8vkqfgDyHVGog4YfEWoru1o8v9XgAjNBFS7sbKjc83k+kQtlepCTLuvBCFuilIMgp5+ijFLgyM8wI6WlUHG3CXGigyzvWblFkIvuGuttCWtKOxubpJW3YSiDFXVda3GrYDGkamNNfvb/F+aBIur7jyIcluwkaenc+fBHI1vV3UzHnQ7NhKEzlnmtRHrUrflaWKMwicK1z3I/qCvv2Wf333pKaLiiCpN+bttWccTD0aIoNk7sv1/cQNa40khR262HKlJYWawECNRIUgVIXbRxR+Busp9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2pFNl6FkY9nEJ6Ok35fkZ72wDrtMIzN1FDEfNJTe3g=;
 b=lconc1cS4cbbOMZH8dSSuF4NkLRuhv4QhefyM4UlBJn8+g0V7+UOlO90O9D6b/rDn/vfdVCC0Swuneb7Ogv0XKC4DmOImfHr+oklJN69s49NJAOuTliUjcDqn0jZYQiwckF6Nu9RTh1l+h82e+bmkz5vR1JJasUEICHeR6Xt8zSOikNME1Sd4KBAtyeLRBaIutXP6EL4l22ycdVDJWdeeFg/ViC9gbWF1xgzQAXc5KENEZQdlp+p4syjfIn1NK81YXqd9qAnXi6ciuC/ZT6WesGrln1j4DMc1V+kDnGF05rfWiQT6EwiIAf8FtAY1AkGN+zDjwcTYmB/IKavWxkgpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2pFNl6FkY9nEJ6Ok35fkZ72wDrtMIzN1FDEfNJTe3g=;
 b=X75BQt83NAAoeuZA+UwbQgHvTDmKFWOpBVxdkocCfXAdtDmmb4SkYtWG2SxjV/c8r4x36+B5IFaIjteN6EQOJNm+dTDgtpQHp6UM7q5X7Nmfa1fCm8mV9kE2z/cYnTVx1i3NyPHaVM8PdMVRMI3pE/IvsY28aXH3RME3+fwkPis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN7PR13MB2404.namprd13.prod.outlook.com (2603:10b6:406:b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.11; Fri, 4 Mar
 2022 10:22:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:47 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 5/5] nfp: xsk: add AF_XDP zero-copy Rx and Tx support
Date:   Fri,  4 Mar 2022 11:22:14 +0100
Message-Id: <20220304102214.25903-6-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6e802f7a-920c-4d15-805f-08d9fdc8ed91
X-MS-TrafficTypeDiagnostic: BN7PR13MB2404:EE_
X-Microsoft-Antispam-PRVS: <BN7PR13MB2404015CF29C33FABB58130AE8059@BN7PR13MB2404.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qk52Gnq4jEvlxj7UuGc7DCadw47Ge27p+/78kygH6MwiPjEjt9okRWZuhdtDaZIbQ9l0VU4BeKyZjjjXLQygyeMW3nOp+perHxHfm8teGGTdJBFCS9j5d5sr5pSCkYCODftx89j4mKV8SgRzw2eMe+og132CdLGjobyeWXYD7EK6aPSZcq/9UzV1usOUKh58fvVmISucLWvw7DAM+YXG7V6aGpPrGiJ/yyTsJjFxCEI9ZFX8JXa+0e23X75uz1WZOB8Ir8DAJS5n8vw4mCqIeB24qAIGEPKfjbm00hsHgMyjkxnwKlaCLKlmWHFcJzhg3IDnuMKcVCMwWigvzbdorXQWKLNVs4aAj2CdJbFfk1l/EEUhNQo8R/vvARtyE0Hr4X5u2zppHwL1X5feiV9YIYhdP4DedAKphQHDHACRYWsH/saUS7Qwp7wioT2j8Z646AGSHCtgtvWLlA3SCLg+RgItITWD2pjspk1YOFOj5lYUYsa3RIqWbsfazhz6xDBRZmB+rGsrJX8WASiTmtXKNvYzM2M+/nI83S3fMGdQLZyuAtcFc5KqiC32BmepWxBdFzxHGeYXOKktMT7KbZycgQ+WLZ8+EQdMYT96gEh658IZuueCjGumA1seYCm3D7JXIcY/tgmlK2Lhl6hdNFmrIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(346002)(136003)(376002)(39840400004)(110136005)(316002)(86362001)(4326008)(8676002)(38100700002)(52116002)(66476007)(66556008)(66946007)(6666004)(6512007)(6636002)(6506007)(6486002)(508600001)(30864003)(8936002)(44832011)(66574015)(107886003)(5660300002)(186003)(2616005)(2906002)(1076003)(36756003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU0rczBqbGp6YktzS3ZxQ0s3bkRYZGtrams1eFVzSklmNkFPMGhoRUZJZ3NH?=
 =?utf-8?B?KzJWNEZZZ0QvSm9PZnp1K0ZEOS9kNTFBU3A1RjNGQzBCR2dFMlRTc1NRbG84?=
 =?utf-8?B?OXNTQmw4SmZXeUE5L2lMK1NaSGZpa3RNZjhjNFNtTDA0UUpBWmtiVmRNd3dZ?=
 =?utf-8?B?RFc4Sis4UGsrYXh4c2lCakRHVHhZUjg3TTloMW5JUlNrSllkOExCc2dHK09W?=
 =?utf-8?B?M0pHTnlVNUtSWmg5WEl2NTZlOWxldHZCL0w1Y1g4RC9TVmR4ZTQxODBEMVFu?=
 =?utf-8?B?N0ZaclhlbGhlY0E5cjhIdTl2VEFQTTRWdkNHRERkcUU3VEpHRC9QMUtDSXc3?=
 =?utf-8?B?RFIzbEVwSWxCenRkYjNTM2wxZzJhcUt1SzVuVGt0cEVuWGY1Z3o0dy9YQldt?=
 =?utf-8?B?MkIzSlFJbTQ2R05WUmJacXFmV2dyRG9xNjJXRlV5Y2RXaUdHVXhNbkZRN3Jt?=
 =?utf-8?B?TXJBMjBadWZqSS9yZzVrR0JtY000VVhwTU1BeWgwL1lTWTVuY29DdFY1UFBq?=
 =?utf-8?B?dGgySW1LT1EvTDluQ0JBYS9wWkZyVlVRVm1nU2xjSlZmWTJlVTZMb1c2aXdC?=
 =?utf-8?B?OENxVGtVajFwSm1ENUpybGlmdEN4bFEvQ2pabGtrVTFaZEZrNUwvNFIvd25M?=
 =?utf-8?B?a1RrYUpmOCs0Z2IyVDVSYk5vcmt0TzJnWHJDRy9TMmdEaCtlTG1MdVJCQmdl?=
 =?utf-8?B?cWszbjRGS2JORzVucEZSNm53cktxckNSak9ZaEg3R0xtUDI3ZDBiaUEyQThp?=
 =?utf-8?B?alZrdFcxWjFxbWhIaTZ1WXd3VFZYQVUwZ0xkNVBWbWkwTkFMU2Rtd2d6Y1lp?=
 =?utf-8?B?NFhwazdBYklMY1J3VlU4Q2pQSm5XNzUzUGhYNlFTanZvd3VVVXl4eE5pNWVK?=
 =?utf-8?B?eGR5SjVBNW56V3ZnUzZKLzRBQTVXaXFCTW5rOXhLNEZoTkJDWEE4TUk2VVQ4?=
 =?utf-8?B?b0UzSmwwTEpCOWtvNzU1NThoOStUSnVpV0h4cHEwQmtVVG5qVy9ObTY2Unhu?=
 =?utf-8?B?WFdkTzVNMzhUSDlpMEJ1R2dyb2JKbGFhWXU5c2V1cys0RlBoeFRvVmh2SmZI?=
 =?utf-8?B?Rk1GaVVpV0FBNVRWUXZoTDhRVXYzd3puRFNpMjFPUUNWWFNsSUhTbzhHMmdR?=
 =?utf-8?B?dThZMmFEUDZDNzBGZG5lZTFSSlIxQjF4MTdFQ2ExVFJubzlWdzErL2tUOGpK?=
 =?utf-8?B?UStHbjlVRU5USDdHZ25ibFRseGxKb3k1c1lFcmswWVNtVWJkdlhkL3RrVHc0?=
 =?utf-8?B?QUFHTnZvdjVwaG1nV0VwWC9lTi9hWklwZFhpODRQWWNZaHpnUkNMTVRland1?=
 =?utf-8?B?VE5BVU9TT3JqKzVIV2dlR1dvTFdmRHV4dTUzNWJTNGxXV2ZBUkN3SzdOS3Qy?=
 =?utf-8?B?dFlmQmFta2tuQ0ppYmRCZDhjMDBIWFI4R0d6cXg1bk9RbXRXRlVpTTNpYTYv?=
 =?utf-8?B?dHBzbHY4aUVTeFpuNGV0TkFwZllUM2VMcC9hSUdCVVQyWWVPTlJya2J4S3dG?=
 =?utf-8?B?bS9VbnRKR0pISUJmWExhSlUrV1RlZ0U4MGtHa0FJVTVGWmt0OFZYUjhEYnVh?=
 =?utf-8?B?RnNuNlBrYlpEZEIxYll4TUprSWZwaUtUMTVrQkMzWDZUZmxaTXRTamdDV01k?=
 =?utf-8?B?YVJLK2xqSXZsNTZlRHk0NzlveS8rcFA3aSs3Qjk0ZUhVdHpkaWV3R2RuVEtW?=
 =?utf-8?B?YzVGOVBVcnBXMmtOTGhIR2JOZTdZUWlaUC9jd0x6UlVReGwzSnI5R2VYd1I5?=
 =?utf-8?B?cXZzQit6WXV4MDJlOXVCcFdiVHlrU2UxaHk4ay9CYzFuNGp5TWM5N1M2Rm0y?=
 =?utf-8?B?MHFFSUVBaFZHYmRyeDJmaW5hQUorbXRnek9NVnFzT253SHVJK09ZYlo4dHhw?=
 =?utf-8?B?dFhSRU9maGNLZEdBNGcxSWJFbW4yQlRraFYyN3lFVTcwS1MzMUN2dU1wS000?=
 =?utf-8?B?VmpscEZlbzg2VGF6aFo1VW90emZGVFcyUlJGc3BoUExFdTlXUE1oVTlVSEtL?=
 =?utf-8?B?alpHeTYrT29XYmV4SEIyUEF5OGNBZjcwczlFenYvLzh4aGJFWWtnN28xdWw0?=
 =?utf-8?B?R3FDa3dFSXNHWi9VR0VlQTFXcTlYR2Q4Z2U1VDhlbXVTNU9WOEFlV1BJbk00?=
 =?utf-8?B?WkdrODJRQ1p0YzhxeG9XVFNrd0k2QmVyb1lXakFqbWlKcDYwdjljT2cwdmo5?=
 =?utf-8?B?Y0F5RVAyekF0SldiT0JtckJUalloZEpUY200ZVg4RUpaeWRidDB3V1EwYjlM?=
 =?utf-8?B?SER3MlRVUTVFUUhnRGYrWkFod0xVZC82NVduTXBYM1MxUjhObjRFOFBQdCt6?=
 =?utf-8?B?MENlT3FyWGZtZWFlUGtneTFoNWhYc3RFUE9PbTB2S0NCczNlUWVKVE0wSjNL?=
 =?utf-8?Q?hn0R9Q2rF333DALY=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e802f7a-920c-4d15-805f-08d9fdc8ed91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:47.2689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X8UTu88mfTtof1XWL1nbPhr5Bh6OAYrzl1SJA9aivqSzI5Tp+XcsnXU2o5cLTQYTmL9B2meT7YcleC11XmAC+HYLoAliGPYT2FSVyGaPJYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR13MB2404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

This patch adds zero-copy Rx and Tx support for AF_XDP sockets. It do so
by adding a separate NAPI poll function that is attached to a each
channel when the XSK socket is attached with XDP_SETUP_XSK_POOL, and
restored when the XSK socket is terminated, this is done per channel.

Support for XDP_TX is implemented and the XDP buffer can safely be moved
from the Rx to the Tx queue and correctly freed and returned to the XSK
pool once it's transmitted.

Note that when AF_XDP zero-copy is enabled, the XDP action XDP_PASS
will allocate a new buffer and copy the zero-copy frame prior
passing it to the kernel stack.

This patch is based on previous work by Jakub Kicinski.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/Makefile   |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  31 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  98 ++-
 .../ethernet/netronome/nfp/nfp_net_debugfs.c  |  33 +-
 .../net/ethernet/netronome/nfp/nfp_net_xsk.c  | 592 ++++++++++++++++++
 .../net/ethernet/netronome/nfp/nfp_net_xsk.h  |  29 +
 6 files changed, 756 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h

diff --git a/drivers/net/ethernet/netronome/nfp/Makefile b/drivers/net/ethernet/netronome/nfp/Makefile
index 9cff3d48acbc..9c72b43c1581 100644
--- a/drivers/net/ethernet/netronome/nfp/Makefile
+++ b/drivers/net/ethernet/netronome/nfp/Makefile
@@ -31,6 +31,7 @@ nfp-objs := \
 	    nfp_net_main.o \
 	    nfp_net_repr.o \
 	    nfp_net_sriov.o \
+	    nfp_net_xsk.o \
 	    nfp_netvf_main.o \
 	    nfp_port.o \
 	    nfp_shared_buf.o \
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 12f403d004ee..437a19722fcf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -171,11 +171,14 @@ struct nfp_net_tx_desc {
  * struct nfp_net_tx_buf - software TX buffer descriptor
  * @skb:	normal ring, sk_buff associated with this buffer
  * @frag:	XDP ring, page frag associated with this buffer
+ * @xdp:	XSK buffer pool handle (for AF_XDP)
  * @dma_addr:	DMA mapping address of the buffer
  * @fidx:	Fragment index (-1 for the head and [0..nr_frags-1] for frags)
  * @pkt_cnt:	Number of packets to be produced out of the skb associated
  *		with this buffer (valid only on the head's buffer).
  *		Will be 1 for all non-TSO packets.
+ * @is_xsk_tx:	Flag if buffer is a RX buffer after a XDP_TX action and not a
+ *		buffer from the TX queue (for AF_XDP).
  * @real_len:	Number of bytes which to be produced out of the skb (valid only
  *		on the head's buffer). Equal to skb->len for non-TSO packets.
  */
@@ -183,10 +186,18 @@ struct nfp_net_tx_buf {
 	union {
 		struct sk_buff *skb;
 		void *frag;
+		struct xdp_buff *xdp;
 	};
 	dma_addr_t dma_addr;
-	short int fidx;
-	u16 pkt_cnt;
+	union {
+		struct {
+			short int fidx;
+			u16 pkt_cnt;
+		};
+		struct {
+			bool is_xsk_tx;
+		};
+	};
 	u32 real_len;
 };
 
@@ -315,6 +326,16 @@ struct nfp_net_rx_buf {
 	dma_addr_t dma_addr;
 };
 
+/**
+ * struct nfp_net_xsk_rx_buf - software RX XSK buffer descriptor
+ * @dma_addr:	DMA mapping address of the buffer
+ * @xdp:	XSK buffer pool handle (for AF_XDP)
+ */
+struct nfp_net_xsk_rx_buf {
+	dma_addr_t dma_addr;
+	struct xdp_buff *xdp;
+};
+
 /**
  * struct nfp_net_rx_ring - RX ring structure
  * @r_vec:      Back pointer to ring vector structure
@@ -325,6 +346,7 @@ struct nfp_net_rx_buf {
  * @fl_qcidx:   Queue Controller Peripheral (QCP) queue index for the freelist
  * @qcp_fl:     Pointer to base of the QCP freelist queue
  * @rxbufs:     Array of transmitted FL/RX buffers
+ * @xsk_rxbufs: Array of transmitted FL/RX buffers (for AF_XDP)
  * @rxds:       Virtual address of FL/RX ring in host memory
  * @xdp_rxq:    RX-ring info avail for XDP
  * @dma:        DMA address of the FL/RX ring
@@ -343,6 +365,7 @@ struct nfp_net_rx_ring {
 	u8 __iomem *qcp_fl;
 
 	struct nfp_net_rx_buf *rxbufs;
+	struct nfp_net_xsk_rx_buf *xsk_rxbufs;
 	struct nfp_net_rx_desc *rxds;
 
 	struct xdp_rxq_info xdp_rxq;
@@ -361,6 +384,7 @@ struct nfp_net_rx_ring {
  * @tx_ring:        Pointer to TX ring
  * @rx_ring:        Pointer to RX ring
  * @xdp_ring:	    Pointer to an extra TX ring for XDP
+ * @xsk_pool:	    XSK buffer pool active on vector queue pair (for AF_XDP)
  * @irq_entry:      MSI-X table entry (use for talking to the device)
  * @event_ctr:	    Number of interrupt
  * @rx_dim:	    Dynamic interrupt moderation structure for RX
@@ -432,6 +456,7 @@ struct nfp_net_r_vector {
 	u64 rx_replace_buf_alloc_fail;
 
 	struct nfp_net_tx_ring *xdp_ring;
+	struct xsk_buff_pool *xsk_pool;
 
 	struct u64_stats_sync tx_sync;
 	u64 tx_pkts;
@@ -502,7 +527,7 @@ struct nfp_stat_pair {
  * @num_stack_tx_rings:	Number of TX rings used by the stack (not XDP)
  * @num_rx_rings:	Currently configured number of RX rings
  * @mtu:		Device MTU
- * @xsk_pools:		AF_XDP UMEM table (@num_r_vecs in size)
+ * @xsk_pools:		XSK buffer pools, @max_r_vecs in size (for AF_XDP).
  */
 struct nfp_net_dp {
 	struct device *dev;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index c10e977d2472..00a09b9e0aee 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -46,6 +46,7 @@
 #include "nfp_net_ctrl.h"
 #include "nfp_net.h"
 #include "nfp_net_sriov.h"
+#include "nfp_net_xsk.h"
 #include "nfp_port.h"
 #include "crypto/crypto.h"
 #include "crypto/fw.h"
@@ -1316,6 +1317,9 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct nfp_net_tx_ring *tx_ring)
 		tx_ring->rd_p++;
 	}
 
+	if (tx_ring->is_xdp)
+		nfp_net_xsk_tx_bufs_free(tx_ring);
+
 	memset(tx_ring->txds, 0, tx_ring->size);
 	tx_ring->wr_p = 0;
 	tx_ring->rd_p = 0;
@@ -1504,10 +1508,14 @@ static void nfp_net_rx_ring_reset(struct nfp_net_rx_ring *rx_ring)
 	/* Move the empty entry to the end of the list */
 	wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
 	last_idx = rx_ring->cnt - 1;
-	rx_ring->rxbufs[wr_idx].dma_addr = rx_ring->rxbufs[last_idx].dma_addr;
-	rx_ring->rxbufs[wr_idx].frag = rx_ring->rxbufs[last_idx].frag;
-	rx_ring->rxbufs[last_idx].dma_addr = 0;
-	rx_ring->rxbufs[last_idx].frag = NULL;
+	if (rx_ring->r_vec->xsk_pool) {
+		rx_ring->xsk_rxbufs[wr_idx] = rx_ring->xsk_rxbufs[last_idx];
+		memset(&rx_ring->xsk_rxbufs[last_idx], 0,
+		       sizeof(*rx_ring->xsk_rxbufs));
+	} else {
+		rx_ring->rxbufs[wr_idx] = rx_ring->rxbufs[last_idx];
+		memset(&rx_ring->rxbufs[last_idx], 0, sizeof(*rx_ring->rxbufs));
+	}
 
 	memset(rx_ring->rxds, 0, rx_ring->size);
 	rx_ring->wr_p = 0;
@@ -1529,6 +1537,9 @@ nfp_net_rx_ring_bufs_free(struct nfp_net_dp *dp,
 {
 	unsigned int i;
 
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return;
+
 	for (i = 0; i < rx_ring->cnt - 1; i++) {
 		/* NULL skb can only happen when initial filling of the ring
 		 * fails to allocate enough buffers and calls here to free
@@ -1556,6 +1567,9 @@ nfp_net_rx_ring_bufs_alloc(struct nfp_net_dp *dp,
 	struct nfp_net_rx_buf *rxbufs;
 	unsigned int i;
 
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return 0;
+
 	rxbufs = rx_ring->rxbufs;
 
 	for (i = 0; i < rx_ring->cnt - 1; i++) {
@@ -1580,6 +1594,9 @@ nfp_net_rx_ring_fill_freelist(struct nfp_net_dp *dp,
 {
 	unsigned int i;
 
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		return nfp_net_xsk_rx_ring_fill_freelist(rx_ring);
+
 	for (i = 0; i < rx_ring->cnt - 1; i++)
 		nfp_net_rx_give_one(dp, rx_ring, rx_ring->rxbufs[i].frag,
 				    rx_ring->rxbufs[i].dma_addr);
@@ -2560,7 +2577,11 @@ static void nfp_net_rx_ring_free(struct nfp_net_rx_ring *rx_ring)
 
 	if (dp->netdev)
 		xdp_rxq_info_unreg(&rx_ring->xdp_rxq);
-	kvfree(rx_ring->rxbufs);
+
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx))
+		kvfree(rx_ring->xsk_rxbufs);
+	else
+		kvfree(rx_ring->rxbufs);
 
 	if (rx_ring->rxds)
 		dma_free_coherent(dp->dev, rx_ring->size,
@@ -2568,6 +2589,7 @@ static void nfp_net_rx_ring_free(struct nfp_net_rx_ring *rx_ring)
 
 	rx_ring->cnt = 0;
 	rx_ring->rxbufs = NULL;
+	rx_ring->xsk_rxbufs = NULL;
 	rx_ring->rxds = NULL;
 	rx_ring->dma = 0;
 	rx_ring->size = 0;
@@ -2583,8 +2605,18 @@ static void nfp_net_rx_ring_free(struct nfp_net_rx_ring *rx_ring)
 static int
 nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 {
+	enum xdp_mem_type mem_type;
+	size_t rxbuf_sw_desc_sz;
 	int err;
 
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
+		mem_type = MEM_TYPE_XSK_BUFF_POOL;
+		rxbuf_sw_desc_sz = sizeof(*rx_ring->xsk_rxbufs);
+	} else {
+		mem_type = MEM_TYPE_PAGE_ORDER0;
+		rxbuf_sw_desc_sz = sizeof(*rx_ring->rxbufs);
+	}
+
 	if (dp->netdev) {
 		err = xdp_rxq_info_reg(&rx_ring->xdp_rxq, dp->netdev,
 				       rx_ring->idx, rx_ring->r_vec->napi.napi_id);
@@ -2592,6 +2624,10 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 			return err;
 	}
 
+	err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, mem_type, NULL);
+	if (err)
+		goto err_alloc;
+
 	rx_ring->cnt = dp->rxd_cnt;
 	rx_ring->size = array_size(rx_ring->cnt, sizeof(*rx_ring->rxds));
 	rx_ring->rxds = dma_alloc_coherent(dp->dev, rx_ring->size,
@@ -2603,10 +2639,17 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 		goto err_alloc;
 	}
 
-	rx_ring->rxbufs = kvcalloc(rx_ring->cnt, sizeof(*rx_ring->rxbufs),
-				   GFP_KERNEL);
-	if (!rx_ring->rxbufs)
-		goto err_alloc;
+	if (nfp_net_has_xsk_pool_slow(dp, rx_ring->idx)) {
+		rx_ring->xsk_rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
+					       GFP_KERNEL);
+		if (!rx_ring->xsk_rxbufs)
+			goto err_alloc;
+	} else {
+		rx_ring->rxbufs = kvcalloc(rx_ring->cnt, rxbuf_sw_desc_sz,
+					   GFP_KERNEL);
+		if (!rx_ring->rxbufs)
+			goto err_alloc;
+	}
 
 	return 0;
 
@@ -2659,11 +2702,13 @@ static void nfp_net_rx_rings_free(struct nfp_net_dp *dp)
 }
 
 static void
-nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec)
+nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec, int idx)
 {
 	if (dp->netdev)
 		netif_napi_add(dp->netdev, &r_vec->napi,
-			       nfp_net_poll, NAPI_POLL_WEIGHT);
+			       nfp_net_has_xsk_pool_slow(dp, idx) ?
+			       nfp_net_xsk_poll : nfp_net_poll,
+			       NAPI_POLL_WEIGHT);
 	else
 		tasklet_enable(&r_vec->tasklet);
 }
@@ -2687,6 +2732,17 @@ nfp_net_vector_assign_rings(struct nfp_net_dp *dp,
 
 	r_vec->xdp_ring = idx < dp->num_tx_rings - dp->num_stack_tx_rings ?
 		&dp->tx_rings[dp->num_stack_tx_rings + idx] : NULL;
+
+	if (nfp_net_has_xsk_pool_slow(dp, idx) || r_vec->xsk_pool) {
+		r_vec->xsk_pool = dp->xdp_prog ? dp->xsk_pools[idx] : NULL;
+
+		if (r_vec->xsk_pool)
+			xsk_pool_set_rxq_info(r_vec->xsk_pool,
+					      &r_vec->rx_ring->xdp_rxq);
+
+		nfp_net_napi_del(dp, r_vec);
+		nfp_net_napi_add(dp, r_vec, idx);
+	}
 }
 
 static int
@@ -2695,7 +2751,7 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 {
 	int err;
 
-	nfp_net_napi_add(&nn->dp, r_vec);
+	nfp_net_napi_add(&nn->dp, r_vec, idx);
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
@@ -2834,8 +2890,11 @@ static void nfp_net_clear_config_and_disable(struct nfp_net *nn)
 	if (err)
 		nn_err(nn, "Could not disable device: %d\n", err);
 
-	for (r = 0; r < nn->dp.num_rx_rings; r++)
+	for (r = 0; r < nn->dp.num_rx_rings; r++) {
 		nfp_net_rx_ring_reset(&nn->dp.rx_rings[r]);
+		if (nfp_net_has_xsk_pool_slow(&nn->dp, nn->dp.rx_rings[r].idx))
+			nfp_net_xsk_rx_bufs_free(&nn->dp.rx_rings[r]);
+	}
 	for (r = 0; r < nn->dp.num_tx_rings; r++)
 		nfp_net_tx_ring_reset(&nn->dp, &nn->dp.tx_rings[r]);
 	for (r = 0; r < nn->dp.num_r_vecs; r++)
@@ -3771,6 +3830,9 @@ static int nfp_net_xdp(struct net_device *netdev, struct netdev_bpf *xdp)
 		return nfp_net_xdp_setup_drv(nn, xdp);
 	case XDP_SETUP_PROG_HW:
 		return nfp_net_xdp_setup_hw(nn, xdp);
+	case XDP_SETUP_XSK_POOL:
+		return nfp_net_xsk_setup_pool(netdev, xdp->xsk.pool,
+					      xdp->xsk.queue_id);
 	default:
 		return nfp_app_bpf(nn->app, nn, xdp);
 	}
@@ -3821,6 +3883,7 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
 	.ndo_bpf		= nfp_net_xdp,
+	.ndo_xsk_wakeup		= nfp_net_xsk_wakeup,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
 
@@ -3948,6 +4011,14 @@ nfp_net_alloc(struct pci_dev *pdev, void __iomem *ctrl_bar, bool needs_netdev,
 	nn->dp.num_r_vecs = max(nn->dp.num_tx_rings, nn->dp.num_rx_rings);
 	nn->dp.num_r_vecs = min_t(unsigned int,
 				  nn->dp.num_r_vecs, num_online_cpus());
+	nn->max_r_vecs = nn->dp.num_r_vecs;
+
+	nn->dp.xsk_pools = kcalloc(nn->max_r_vecs, sizeof(nn->dp.xsk_pools),
+				   GFP_KERNEL);
+	if (!nn->dp.xsk_pools) {
+		err = -ENOMEM;
+		goto err_free_nn;
+	}
 
 	nn->dp.txd_cnt = NFP_NET_TX_DESCS_DEFAULT;
 	nn->dp.rxd_cnt = NFP_NET_RX_DESCS_DEFAULT;
@@ -3987,6 +4058,7 @@ void nfp_net_free(struct nfp_net *nn)
 	WARN_ON(timer_pending(&nn->reconfig_timer) || nn->reconfig_posted);
 	nfp_ccm_mbox_free(nn);
 
+	kfree(nn->dp.xsk_pools);
 	if (nn->dp.netdev)
 		free_netdev(nn->dp.netdev);
 	else
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
index 553c708694e8..2c74b3c5aef9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c
@@ -42,13 +42,19 @@ static int nfp_rx_q_show(struct seq_file *file, void *data)
 		seq_printf(file, "%04d: 0x%08x 0x%08x", i,
 			   rxd->vals[0], rxd->vals[1]);
 
-		frag = READ_ONCE(rx_ring->rxbufs[i].frag);
-		if (frag)
-			seq_printf(file, " frag=%p", frag);
-
-		if (rx_ring->rxbufs[i].dma_addr)
-			seq_printf(file, " dma_addr=%pad",
-				   &rx_ring->rxbufs[i].dma_addr);
+		if (!r_vec->xsk_pool) {
+			frag = READ_ONCE(rx_ring->rxbufs[i].frag);
+			if (frag)
+				seq_printf(file, " frag=%p", frag);
+
+			if (rx_ring->rxbufs[i].dma_addr)
+				seq_printf(file, " dma_addr=%pad",
+					   &rx_ring->rxbufs[i].dma_addr);
+		} else {
+			if (rx_ring->xsk_rxbufs[i].dma_addr)
+				seq_printf(file, " dma_addr=%pad",
+					   &rx_ring->xsk_rxbufs[i].dma_addr);
+		}
 
 		if (i == rx_ring->rd_p % rxd_cnt)
 			seq_puts(file, " H_RD ");
@@ -103,20 +109,23 @@ static int nfp_tx_q_show(struct seq_file *file, void *data)
 		   tx_ring->rd_p, tx_ring->wr_p, d_rd_p, d_wr_p);
 
 	for (i = 0; i < txd_cnt; i++) {
+		struct xdp_buff *xdp;
+		struct sk_buff *skb;
+
 		txd = &tx_ring->txds[i];
 		seq_printf(file, "%04d: 0x%08x 0x%08x 0x%08x 0x%08x", i,
 			   txd->vals[0], txd->vals[1],
 			   txd->vals[2], txd->vals[3]);
 
-		if (tx_ring == r_vec->tx_ring) {
-			struct sk_buff *skb = READ_ONCE(tx_ring->txbufs[i].skb);
-
+		if (!tx_ring->is_xdp) {
+			skb = READ_ONCE(tx_ring->txbufs[i].skb);
 			if (skb)
 				seq_printf(file, " skb->head=%p skb->data=%p",
 					   skb->head, skb->data);
 		} else {
-			seq_printf(file, " frag=%p",
-				   READ_ONCE(tx_ring->txbufs[i].frag));
+			xdp = READ_ONCE(tx_ring->txbufs[i].xdp);
+			if (xdp)
+				seq_printf(file, " xdp->data=%p", xdp->data);
 		}
 
 		if (tx_ring->txbufs[i].dma_addr)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
new file mode 100644
index 000000000000..ab7243277efa
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
@@ -0,0 +1,592 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#include <linux/dma-direction.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+#include <net/xdp_sock_drv.h>
+#include <trace/events/xdp.h>
+
+#include "nfp_app.h"
+#include "nfp_net.h"
+#include "nfp_net_xsk.h"
+
+static int nfp_net_tx_space(struct nfp_net_tx_ring *tx_ring)
+{
+	return tx_ring->cnt - tx_ring->wr_p + tx_ring->rd_p - 1;
+}
+
+static void nfp_net_xsk_tx_free(struct nfp_net_tx_buf *txbuf)
+{
+	xsk_buff_free(txbuf->xdp);
+
+	txbuf->dma_addr = 0;
+	txbuf->xdp = NULL;
+}
+
+void nfp_net_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_tx_buf *txbuf;
+	unsigned int idx;
+
+	while (tx_ring->rd_p != tx_ring->wr_p) {
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		txbuf = &tx_ring->txbufs[idx];
+
+		txbuf->real_len = 0;
+
+		tx_ring->qcp_rd_p++;
+		tx_ring->rd_p++;
+
+		if (tx_ring->r_vec->xsk_pool) {
+			if (txbuf->is_xsk_tx)
+				nfp_net_xsk_tx_free(txbuf);
+
+			xsk_tx_completed(tx_ring->r_vec->xsk_pool, 1);
+		}
+	}
+}
+
+static bool nfp_net_xsk_complete(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	u32 done_pkts = 0, done_bytes = 0, reused = 0;
+	bool done_all;
+	int idx, todo;
+	u32 qcp_rd_p;
+
+	if (tx_ring->wr_p == tx_ring->rd_p)
+		return true;
+
+	/* Work out how many descriptors have been transmitted. */
+	qcp_rd_p = nfp_qcp_rd_ptr_read(tx_ring->qcp_q);
+
+	if (qcp_rd_p == tx_ring->qcp_rd_p)
+		return true;
+
+	todo = D_IDX(tx_ring, qcp_rd_p - tx_ring->qcp_rd_p);
+
+	done_all = todo <= NFP_NET_XDP_MAX_COMPLETE;
+	todo = min(todo, NFP_NET_XDP_MAX_COMPLETE);
+
+	tx_ring->qcp_rd_p = D_IDX(tx_ring, tx_ring->qcp_rd_p + todo);
+
+	done_pkts = todo;
+	while (todo--) {
+		struct nfp_net_tx_buf *txbuf;
+
+		idx = D_IDX(tx_ring, tx_ring->rd_p);
+		tx_ring->rd_p++;
+
+		txbuf = &tx_ring->txbufs[idx];
+		if (unlikely(!txbuf->real_len))
+			continue;
+
+		done_bytes += txbuf->real_len;
+		txbuf->real_len = 0;
+
+		if (txbuf->is_xsk_tx) {
+			nfp_net_xsk_tx_free(txbuf);
+			reused++;
+		}
+	}
+
+	u64_stats_update_begin(&r_vec->tx_sync);
+	r_vec->tx_bytes += done_bytes;
+	r_vec->tx_pkts += done_pkts;
+	u64_stats_update_end(&r_vec->tx_sync);
+
+	xsk_tx_completed(r_vec->xsk_pool, done_pkts - reused);
+
+	WARN_ONCE(tx_ring->wr_p - tx_ring->rd_p > tx_ring->cnt,
+		  "XDP TX ring corruption rd_p=%u wr_p=%u cnt=%u\n",
+		  tx_ring->rd_p, tx_ring->wr_p, tx_ring->cnt);
+
+	return done_all;
+}
+
+static void nfp_net_xsk_tx(struct nfp_net_tx_ring *tx_ring)
+{
+	struct nfp_net_r_vector *r_vec = tx_ring->r_vec;
+	struct xdp_desc desc[NFP_NET_XSK_TX_BATCH];
+	struct xsk_buff_pool *xsk_pool;
+	struct nfp_net_tx_desc *txd;
+	u32 pkts = 0, wr_idx;
+	u32 i, got;
+
+	xsk_pool = r_vec->xsk_pool;
+
+	while (nfp_net_tx_space(tx_ring) >= NFP_NET_XSK_TX_BATCH) {
+		for (i = 0; i < NFP_NET_XSK_TX_BATCH; i++)
+			if (!xsk_tx_peek_desc(xsk_pool, &desc[i]))
+				break;
+		got = i;
+		if (!got)
+			break;
+
+		wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
+		prefetchw(&tx_ring->txds[wr_idx]);
+
+		for (i = 0; i < got; i++)
+			xsk_buff_raw_dma_sync_for_device(xsk_pool, desc[i].addr,
+							 desc[i].len);
+
+		for (i = 0; i < got; i++) {
+			wr_idx = D_IDX(tx_ring, tx_ring->wr_p + i);
+
+			tx_ring->txbufs[wr_idx].real_len = desc[i].len;
+			tx_ring->txbufs[wr_idx].is_xsk_tx = false;
+
+			/* Build TX descriptor. */
+			txd = &tx_ring->txds[wr_idx];
+			nfp_desc_set_dma_addr(txd,
+					      xsk_buff_raw_get_dma(xsk_pool,
+								   desc[i].addr
+								   ));
+			txd->offset_eop = PCIE_DESC_TX_EOP;
+			txd->dma_len = cpu_to_le16(desc[i].len);
+			txd->data_len = cpu_to_le16(desc[i].len);
+		}
+
+		tx_ring->wr_p += got;
+		pkts += got;
+	}
+
+	if (!pkts)
+		return;
+
+	xsk_tx_release(xsk_pool);
+	/* Ensure all records are visible before incrementing write counter. */
+	wmb();
+	nfp_qcp_wr_ptr_add(tx_ring->qcp_q, pkts);
+}
+
+static bool
+nfp_net_xsk_tx_xdp(const struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
+		   struct nfp_net_rx_ring *rx_ring,
+		   struct nfp_net_tx_ring *tx_ring,
+		   struct nfp_net_xsk_rx_buf *xrxbuf, unsigned int pkt_len,
+		   int pkt_off)
+{
+	struct xsk_buff_pool *pool = r_vec->xsk_pool;
+	struct nfp_net_tx_buf *txbuf;
+	struct nfp_net_tx_desc *txd;
+	unsigned int wr_idx;
+
+	if (nfp_net_tx_space(tx_ring) < 1)
+		return false;
+
+	xsk_buff_raw_dma_sync_for_device(pool, xrxbuf->dma_addr + pkt_off, pkt_len);
+
+	wr_idx = D_IDX(tx_ring, tx_ring->wr_p);
+
+	txbuf = &tx_ring->txbufs[wr_idx];
+	txbuf->xdp = xrxbuf->xdp;
+	txbuf->real_len = pkt_len;
+	txbuf->is_xsk_tx = true;
+
+	/* Build TX descriptor */
+	txd = &tx_ring->txds[wr_idx];
+	txd->offset_eop = PCIE_DESC_TX_EOP;
+	txd->dma_len = cpu_to_le16(pkt_len);
+	nfp_desc_set_dma_addr(txd, xrxbuf->dma_addr + pkt_off);
+	txd->data_len = cpu_to_le16(pkt_len);
+
+	txd->flags = 0;
+	txd->mss = 0;
+	txd->lso_hdrlen = 0;
+
+	tx_ring->wr_ptr_add++;
+	tx_ring->wr_p++;
+
+	return true;
+}
+
+static int nfp_net_rx_space(struct nfp_net_rx_ring *rx_ring)
+{
+	return rx_ring->cnt - rx_ring->wr_p + rx_ring->rd_p - 1;
+}
+
+static void
+nfp_net_xsk_rx_bufs_stash(struct nfp_net_rx_ring *rx_ring, unsigned int idx,
+			  struct xdp_buff *xdp)
+{
+	unsigned int headroom;
+
+	headroom = xsk_pool_get_headroom(rx_ring->r_vec->xsk_pool);
+
+	rx_ring->rxds[idx].fld.reserved = 0;
+	rx_ring->rxds[idx].fld.meta_len_dd = 0;
+
+	rx_ring->xsk_rxbufs[idx].xdp = xdp;
+	rx_ring->xsk_rxbufs[idx].dma_addr =
+		xsk_buff_xdp_get_frame_dma(xdp) + headroom;
+}
+
+static void nfp_net_xsk_rx_unstash(struct nfp_net_xsk_rx_buf *rxbuf)
+{
+	rxbuf->dma_addr = 0;
+	rxbuf->xdp = NULL;
+}
+
+static void nfp_net_xsk_rx_free(struct nfp_net_xsk_rx_buf *rxbuf)
+{
+	if (rxbuf->xdp)
+		xsk_buff_free(rxbuf->xdp);
+
+	nfp_net_xsk_rx_unstash(rxbuf);
+}
+
+void nfp_net_xsk_rx_bufs_free(struct nfp_net_rx_ring *rx_ring)
+{
+	unsigned int i;
+
+	if (!rx_ring->cnt)
+		return;
+
+	for (i = 0; i < rx_ring->cnt - 1; i++)
+		nfp_net_xsk_rx_free(&rx_ring->xsk_rxbufs[i]);
+}
+
+void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct xsk_buff_pool *pool = r_vec->xsk_pool;
+	unsigned int wr_idx, wr_ptr_add = 0;
+	struct xdp_buff *xdp;
+
+	while (nfp_net_rx_space(rx_ring)) {
+		wr_idx = D_IDX(rx_ring, rx_ring->wr_p);
+
+		xdp = xsk_buff_alloc(pool);
+		if (!xdp)
+			break;
+
+		nfp_net_xsk_rx_bufs_stash(rx_ring, wr_idx, xdp);
+
+		nfp_desc_set_dma_addr(&rx_ring->rxds[wr_idx].fld,
+				      rx_ring->xsk_rxbufs[wr_idx].dma_addr);
+
+		rx_ring->wr_p++;
+		wr_ptr_add++;
+	}
+
+	/* Ensure all records are visible before incrementing write counter. */
+	wmb();
+	nfp_qcp_wr_ptr_add(rx_ring->qcp_fl, wr_ptr_add);
+}
+
+static void nfp_net_xsk_rx_drop(struct nfp_net_r_vector *r_vec,
+				struct nfp_net_xsk_rx_buf *xrxbuf)
+{
+	u64_stats_update_begin(&r_vec->rx_sync);
+	r_vec->rx_drops++;
+	u64_stats_update_end(&r_vec->rx_sync);
+
+	nfp_net_xsk_rx_free(xrxbuf);
+}
+
+static void nfp_net_xsk_rx_skb(struct nfp_net_rx_ring *rx_ring,
+			       const struct nfp_net_rx_desc *rxd,
+			       struct nfp_net_xsk_rx_buf *xrxbuf,
+			       const struct nfp_meta_parsed *meta,
+			       unsigned int pkt_len,
+			       bool meta_xdp,
+			       unsigned int *skbs_polled)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct net_device *netdev;
+	struct sk_buff *skb;
+
+	if (likely(!meta->portid)) {
+		netdev = dp->netdev;
+	} else {
+		struct nfp_net *nn = netdev_priv(dp->netdev);
+
+		netdev = nfp_app_dev_get(nn->app, meta->portid, NULL);
+		if (unlikely(!netdev)) {
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			return;
+		}
+		nfp_repr_inc_rx_stats(netdev, pkt_len);
+	}
+
+	skb = napi_alloc_skb(&r_vec->napi, pkt_len);
+	if (!skb) {
+		nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+		return;
+	}
+	memcpy(skb_put(skb, pkt_len), xrxbuf->xdp->data, pkt_len);
+
+	skb->mark = meta->mark;
+	skb_set_hash(skb, meta->hash, meta->hash_type);
+
+	skb_record_rx_queue(skb, rx_ring->idx);
+	skb->protocol = eth_type_trans(skb, netdev);
+
+	nfp_net_rx_csum(dp, r_vec, rxd, meta, skb);
+
+	if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       le16_to_cpu(rxd->rxd.vlan));
+	if (meta_xdp)
+		skb_metadata_set(skb,
+				 xrxbuf->xdp->data - xrxbuf->xdp->data_meta);
+
+	napi_gro_receive(&rx_ring->r_vec->napi, skb);
+
+	nfp_net_xsk_rx_free(xrxbuf);
+
+	(*skbs_polled)++;
+}
+
+static unsigned int
+nfp_net_xsk_rx(struct nfp_net_rx_ring *rx_ring, int budget,
+	       unsigned int *skbs_polled)
+{
+	struct nfp_net_r_vector *r_vec = rx_ring->r_vec;
+	struct nfp_net_dp *dp = &r_vec->nfp_net->dp;
+	struct nfp_net_tx_ring *tx_ring;
+	struct bpf_prog *xdp_prog;
+	bool xdp_redir = false;
+	int pkts_polled = 0;
+
+	xdp_prog = READ_ONCE(dp->xdp_prog);
+	tx_ring = r_vec->xdp_ring;
+
+	while (pkts_polled < budget) {
+		unsigned int meta_len, data_len, pkt_len, pkt_off;
+		struct nfp_net_xsk_rx_buf *xrxbuf;
+		struct nfp_net_rx_desc *rxd;
+		struct nfp_meta_parsed meta;
+		int idx, act;
+
+		idx = D_IDX(rx_ring, rx_ring->rd_p);
+
+		rxd = &rx_ring->rxds[idx];
+		if (!(rxd->rxd.meta_len_dd & PCIE_DESC_RX_DD))
+			break;
+
+		rx_ring->rd_p++;
+		pkts_polled++;
+
+		xrxbuf = &rx_ring->xsk_rxbufs[idx];
+
+		/* If starved of buffers "drop" it and scream. */
+		if (rx_ring->rd_p >= rx_ring->wr_p) {
+			nn_dp_warn(dp, "Starved of RX buffers\n");
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			break;
+		}
+
+		/* Memory barrier to ensure that we won't do other reads
+		 * before the DD bit.
+		 */
+		dma_rmb();
+
+		memset(&meta, 0, sizeof(meta));
+
+		/* Only supporting AF_XDP with dynamic metadata so buffer layout
+		 * is always:
+		 *
+		 *  ---------------------------------------------------------
+		 * |  off | metadata  |             packet           | XXXX  |
+		 *  ---------------------------------------------------------
+		 */
+		meta_len = rxd->rxd.meta_len_dd & PCIE_DESC_RX_META_LEN_MASK;
+		data_len = le16_to_cpu(rxd->rxd.data_len);
+		pkt_len = data_len - meta_len;
+
+		if (unlikely(meta_len > NFP_NET_MAX_PREPEND)) {
+			nn_dp_warn(dp, "Oversized RX packet metadata %u\n",
+				   meta_len);
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			continue;
+		}
+
+		/* Stats update. */
+		u64_stats_update_begin(&r_vec->rx_sync);
+		r_vec->rx_pkts++;
+		r_vec->rx_bytes += pkt_len;
+		u64_stats_update_end(&r_vec->rx_sync);
+
+		xrxbuf->xdp->data += meta_len;
+		xrxbuf->xdp->data_end = xrxbuf->xdp->data + pkt_len;
+		xdp_set_data_meta_invalid(xrxbuf->xdp);
+		xsk_buff_dma_sync_for_cpu(xrxbuf->xdp, r_vec->xsk_pool);
+		net_prefetch(xrxbuf->xdp->data);
+
+		if (meta_len) {
+			if (unlikely(nfp_net_parse_meta(dp->netdev, &meta,
+							xrxbuf->xdp->data -
+							meta_len,
+							xrxbuf->xdp->data,
+							pkt_len, meta_len))) {
+				nn_dp_warn(dp, "Invalid RX packet metadata\n");
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+				continue;
+			}
+
+			if (unlikely(meta.portid)) {
+				struct nfp_net *nn = netdev_priv(dp->netdev);
+
+				if (meta.portid != NFP_META_PORT_ID_CTRL) {
+					nfp_net_xsk_rx_skb(rx_ring, rxd, xrxbuf,
+							   &meta, pkt_len,
+							   false, skbs_polled);
+					continue;
+				}
+
+				nfp_app_ctrl_rx_raw(nn->app, xrxbuf->xdp->data,
+						    pkt_len);
+				nfp_net_xsk_rx_free(xrxbuf);
+				continue;
+			}
+		}
+
+		act = bpf_prog_run_xdp(xdp_prog, xrxbuf->xdp);
+
+		pkt_len = xrxbuf->xdp->data_end - xrxbuf->xdp->data;
+		pkt_off = xrxbuf->xdp->data - xrxbuf->xdp->data_hard_start;
+
+		switch (act) {
+		case XDP_PASS:
+			nfp_net_xsk_rx_skb(rx_ring, rxd, xrxbuf, &meta, pkt_len,
+					   true, skbs_polled);
+			break;
+		case XDP_TX:
+			if (!nfp_net_xsk_tx_xdp(dp, r_vec, rx_ring, tx_ring,
+						xrxbuf, pkt_len, pkt_off))
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			else
+				nfp_net_xsk_rx_unstash(xrxbuf);
+			break;
+		case XDP_REDIRECT:
+			if (xdp_do_redirect(dp->netdev, xrxbuf->xdp, xdp_prog)) {
+				nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			} else {
+				nfp_net_xsk_rx_unstash(xrxbuf);
+				xdp_redir = true;
+			}
+			break;
+		default:
+			bpf_warn_invalid_xdp_action(dp->netdev, xdp_prog, act);
+			fallthrough;
+		case XDP_ABORTED:
+			trace_xdp_exception(dp->netdev, xdp_prog, act);
+			fallthrough;
+		case XDP_DROP:
+			nfp_net_xsk_rx_drop(r_vec, xrxbuf);
+			break;
+		}
+	}
+
+	nfp_net_xsk_rx_ring_fill_freelist(r_vec->rx_ring);
+
+	if (xdp_redir)
+		xdp_do_flush_map();
+
+	if (tx_ring->wr_ptr_add)
+		nfp_net_tx_xmit_more_flush(tx_ring);
+
+	return pkts_polled;
+}
+
+static void nfp_net_xsk_pool_unmap(struct device *dev,
+				   struct xsk_buff_pool *pool)
+{
+	return xsk_pool_dma_unmap(pool, 0);
+}
+
+static int nfp_net_xsk_pool_map(struct device *dev, struct xsk_buff_pool *pool)
+{
+	return xsk_pool_dma_map(pool, dev, 0);
+}
+
+int nfp_net_xsk_setup_pool(struct net_device *netdev,
+			   struct xsk_buff_pool *pool, u16 queue_id)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+
+	struct xsk_buff_pool *prev_pool;
+	struct nfp_net_dp *dp;
+	int err;
+
+	/* Reject on old FWs so we can drop some checks on datapath. */
+	if (nn->dp.rx_offset != NFP_NET_CFG_RX_OFFSET_DYNAMIC)
+		return -EOPNOTSUPP;
+	if (!nn->dp.chained_metadata_format)
+		return -EOPNOTSUPP;
+
+	/* Install */
+	if (pool) {
+		err = nfp_net_xsk_pool_map(nn->dp.dev, pool);
+		if (err)
+			return err;
+	}
+
+	/* Reconfig/swap */
+	dp = nfp_net_clone_dp(nn);
+	if (!dp) {
+		err = -ENOMEM;
+		goto err_unmap;
+	}
+
+	prev_pool = dp->xsk_pools[queue_id];
+	dp->xsk_pools[queue_id] = pool;
+
+	err = nfp_net_ring_reconfig(nn, dp, NULL);
+	if (err)
+		goto err_unmap;
+
+	/* Uninstall */
+	if (prev_pool)
+		nfp_net_xsk_pool_unmap(nn->dp.dev, prev_pool);
+
+	return 0;
+err_unmap:
+	if (pool)
+		nfp_net_xsk_pool_unmap(nn->dp.dev, pool);
+
+	return err;
+}
+
+int nfp_net_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags)
+{
+	struct nfp_net *nn = netdev_priv(netdev);
+
+	/* queue_id comes from a zero-copy socket, installed with XDP_SETUP_XSK_POOL,
+	 * so it must be within our vector range.  Moreover, our napi structs
+	 * are statically allocated, so we can always kick them without worrying
+	 * if reconfig is in progress or interface down.
+	 */
+	napi_schedule(&nn->r_vecs[queue_id].napi);
+
+	return 0;
+}
+
+int nfp_net_xsk_poll(struct napi_struct *napi, int budget)
+{
+	struct nfp_net_r_vector *r_vec =
+		container_of(napi, struct nfp_net_r_vector, napi);
+	unsigned int pkts_polled, skbs = 0;
+
+	pkts_polled = nfp_net_xsk_rx(r_vec->rx_ring, budget, &skbs);
+
+	if (pkts_polled < budget) {
+		if (r_vec->tx_ring)
+			nfp_net_tx_complete(r_vec->tx_ring, budget);
+
+		if (!nfp_net_xsk_complete(r_vec->xdp_ring))
+			pkts_polled = budget;
+
+		nfp_net_xsk_tx(r_vec->xdp_ring);
+
+		if (pkts_polled < budget && napi_complete_done(napi, skbs))
+			nfp_net_irq_unmask(r_vec->nfp_net, r_vec->irq_entry);
+	}
+
+	return pkts_polled;
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
new file mode 100644
index 000000000000..5c8549cb3543
--- /dev/null
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/* Copyright (C) 2018 Netronome Systems, Inc */
+/* Copyright (C) 2021 Corigine, Inc */
+
+#ifndef _NFP_XSK_H_
+#define _NFP_XSK_H_
+
+#include <net/xdp_sock_drv.h>
+
+#define NFP_NET_XSK_TX_BATCH 16		/* XSK TX transmission batch size. */
+
+static inline bool nfp_net_has_xsk_pool_slow(struct nfp_net_dp *dp,
+					     unsigned int qid)
+{
+	return dp->xdp_prog && dp->xsk_pools[qid];
+}
+
+int nfp_net_xsk_setup_pool(struct net_device *netdev, struct xsk_buff_pool *pool,
+			   u16 queue_id);
+
+void nfp_net_xsk_tx_bufs_free(struct nfp_net_tx_ring *tx_ring);
+void nfp_net_xsk_rx_bufs_free(struct nfp_net_rx_ring *rx_ring);
+
+void nfp_net_xsk_rx_ring_fill_freelist(struct nfp_net_rx_ring *rx_ring);
+
+int nfp_net_xsk_wakeup(struct net_device *netdev, u32 queue_id, u32 flags);
+int nfp_net_xsk_poll(struct napi_struct *napi, int budget);
+
+#endif /* _NFP_XSK_H_ */
-- 
2.20.1

