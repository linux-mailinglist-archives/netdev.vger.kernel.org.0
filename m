Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF34CD24F
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiCDKXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiCDKXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DD34FC78
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daBWISHLG8JP7SiEc/cF6rHpJRoWEPt6IR6J/TsioUWbjWvUHHCHHYYZb7lCV6zvOlCDdnJlvf4MGKkAVJhw96cVIW9B7aNR0FEk3y9XfT8MOr8luAuPUGo3UIvbmC3pO/zG75klOCSP1bGKmiEdCndctaFPLAP2CslLTXBxcHYWNJezJDymfrP7ekvm6aYNlc4k6DQxLn61muY+vBTJrgqOf7uE8BHgqu3u44jaJXZ3Zg2zqaVO4TwLXT1qgpNq3pWAwQM0Tg7E5wDxlGdyM1pHq24A1QimHXxqrE3A4cUyp44dWCPgOtSov5EH/2ve3z8CK4ve7+vKgrY09TgAfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU0B925EyjRBDADBs2ULn9tGrWSG7S0lYlorGoKvivs=;
 b=XvxeV3DjPE2Bnx0wh6IH1AdT1LWqFLXxjdg4HmlIYDeFlSdlRhAByBklG8oWO0z9KqoOHhtpPK8lQVNZU91LIlpOG8czdKzKCbSaq3fSDWjj4q2vkmOICbL2rpiGnaO8FRyNiE5p+ChD11NAJR25v385R0L3VghnjoFVH1EDGweUWLhHm6PWWDlS2nMoCeijE2N3aznJ0PZqJxyvgIov0iZLUUcTut1RwG6GuUo/wcbNoWHITQuzsh5dMopqwOO4QcXI5Zz1rJRLfo6/5tXqHnhTPDXY2zn8YXkQ9CkNL52mIL5rm+joJp4vw9el1HV0KCnQl+w9KxT5hMXRBqErBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU0B925EyjRBDADBs2ULn9tGrWSG7S0lYlorGoKvivs=;
 b=D7bR4mDW/SdXM2wNdnA0xgoT4w/s0HxtDfuGnb7rJhf5kqju29CiDAcydqBUwPAl0iFGoisqw60uv8bz7mHkw07oLJZrJJMbGg7dk+GEvOnaEV3DU5VVEbh8/2qKhK9FI/EHtNizNri122F7PmLWIP150desuyimhurK2HNH6XU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN7PR13MB2404.namprd13.prod.outlook.com (2603:10b6:406:b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.11; Fri, 4 Mar
 2022 10:22:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:44 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 3/5] nfp: xsk: add an array of xsk buffer pools to each data path
Date:   Fri,  4 Mar 2022 11:22:12 +0100
Message-Id: <20220304102214.25903-4-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 633e3909-a068-4906-ee6c-08d9fdc8ebf4
X-MS-TrafficTypeDiagnostic: BN7PR13MB2404:EE_
X-Microsoft-Antispam-PRVS: <BN7PR13MB240479FB8CAD164BF0EB0499E8059@BN7PR13MB2404.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZltEl/VApJy5JKWKBQw8+ViuLaWjF8mlxKQJPSrG7LeNQ1GGG2vFyGy5+HO3Me129FYvIYy4gkXVum6SQXvRgqfS4seh8ThgA1SGt1L0OrkHyvanb0w967lS0QRI4b2gDYCRoUfb1HuoTTMpTLFW1GCKqvvwO5bH4KowMxBFO5ydL/UUWPOw2Oc6wllpXW2q3XfvMTnBgjw41x5oN/nHfVhZaJzKRDHyuxR0CTJ5T7KKJe2dNRde57O3sUgtB8fLVwT+bvuhP32JYsmJXcGDF/R2JhhtLSmMPJ8w0SgIhYMku93g60mOF/l+Ei60sMFjkfstguGjjL+ey56eU3NR4obvkDXcaHLjK7PYAQsU/4JLzq0YD7Dwzh7wwxYEMttkMVOcvnmB3CcJkgvHoDWGXzdD3rfr3g8n4pUqEoYoY8dda37Z42ubngHbpENlb/n6H3t53WpcLq/xNbj7ruRPRIqhyE5voQakOUT1X2BZB1Lto6BOjCWXoJiidFgXn0drnf6NWBp7bXXfVYtIjnkCRh2K1bkCR4VLfC59OpMOP6dc1URNqfiKEQi/gQfmxtIGH/3fMvxx0pJizor2siQ4O9Nb+fYoWUYDDU7mHCZuTzUM/c3tWgkXeT2EaOxboVyC0bb9Nci+QcAZUgI3lNahA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(346002)(136003)(376002)(39840400004)(110136005)(316002)(86362001)(4326008)(8676002)(38100700002)(52116002)(66476007)(66556008)(66946007)(6666004)(6512007)(6636002)(6506007)(6486002)(508600001)(8936002)(44832011)(107886003)(5660300002)(186003)(2616005)(2906002)(1076003)(36756003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWFHNzUrN2NzdFlZaXhoYXdUajI2Sk5BaTFOcVJkM1Yxci9hNFVsNCs3MWRQ?=
 =?utf-8?B?V2pQRGhaUXpla085QlZZZjNBcXNCc0JMVnVuVDdBUXNuOUc3V3o0VEtNdUNx?=
 =?utf-8?B?TDVLTzdmdHVnUjJ2MXkvOWZ0c2V4c3I1M3V4T3BRUnJmb2JsMzM1RkhkcWVo?=
 =?utf-8?B?VkdzSGk3TThSSit2dFJvN3VTZWVVcktjQzJlcHVYckljdkZxSUxxOXJMeVgw?=
 =?utf-8?B?T2VNV0NzNkcwSWdvc29mMVFNeGQxcFFzUkRrdFVvdWlGbVdwdFRMU0xvQjY4?=
 =?utf-8?B?emZDRVJPb1F3cndESXV1MDBpUGVzL3B5WGNqM043eWdWKzdYWkhRQXMrY3lz?=
 =?utf-8?B?WnZmWkdnSHhIcUxwMVlUZ1FDNDAzck5YM2x6aVZKSEdaRGhqYWx3N0x0Nmxz?=
 =?utf-8?B?SUJBT0tkZ0lPa1h0eTdrZkN3WldqL2hEaklaWXhHYjNSbE5wWU5sblV0UWZH?=
 =?utf-8?B?Z245NmVrNDhjRGJiNTZwenJBaDJ4VzYzR1VkOTVsK0ZsbTYyUTQySDA1WHda?=
 =?utf-8?B?cGJFNGdVbitmeFpZYUxrOXNwQ0YxQTlEVXlGaHlneE9HTVpUWnNCTktEWjJ0?=
 =?utf-8?B?STlib1U4ZzMydU1LREN1MzAyOXE5MnpLUzd2RHFPaWtaclRyWWJnY1RaMGFh?=
 =?utf-8?B?bjhFUGd6bzBrQ25KN0YzemV3MlNNb3lUdS9ONTdUemIrckFZZnVEaGFISHNV?=
 =?utf-8?B?YXBReTY3N1B5dGNrZllHR25MNzV4Y2IzSmpoekxvSWorSGhvUkxORGd4TFZF?=
 =?utf-8?B?aXhNVjV2VERBTHdJZlpoclg2QmFkMkMxenFqMkFFTTR0QzREUkE2cC9HUWky?=
 =?utf-8?B?WC9OMUdMV216MHIrVGhMRzRIaHdYN1poMENXblZNb2JXcDY0VEVva3g3TDYx?=
 =?utf-8?B?V0FEUTl2UnFVdTdDakQ2M29WQTNMOG1taDlLc05GKytWeGlDZi93T0I4TzVq?=
 =?utf-8?B?Qmc2OEZnODJXZElWUzJueEV4a25aVDV0RFRwdExaTnhKcEJZYTE0SUx0dHo5?=
 =?utf-8?B?VDIvR1JSM2lEQUM3UEtLNG1ybS9nZTVYNmRvbUhpY29ydE05dlJDeE02cDFa?=
 =?utf-8?B?aE44LzE5RGIyMXM3L0N1RkJnOWRQR2dBMks3eWxsdGwvYlVKWmdiL3JiU0Rs?=
 =?utf-8?B?UjBxazA5ZFlhcC8xQVhDYm14U2RoSFhLMXlqUUNFZ3lRSU5reklqS2FQbXV1?=
 =?utf-8?B?WllVNEtPSnRZYlA0b25OYjIycmFyQlpDRlJvdXVLUEdXckZlYVp2YXcwMmdm?=
 =?utf-8?B?MW94MkpMZ0Zvd1V0QkVsMjUvUTlDZnR3S2JBYU1XMnlHUGtqZFo2cnlDU3hW?=
 =?utf-8?B?K3dLck5PeWpBdHBFYW8rTVdLNHZxNWZQZG9oMk5sRGZaZWxWNVF6QUQ2T0NP?=
 =?utf-8?B?TEdxYkRCbUs1RW9VL2xsR2xjcXQweTlyWGlWQSs2SVFZcGtNNnp6UGxGNEhj?=
 =?utf-8?B?YnZ6anYwV0IzUlZkMy95dmZqWUdQbGI5VTlRT1dNUmtuWlpvMG1YR215Y1RM?=
 =?utf-8?B?TzRxVkJCei9EQngwRGhJbHJmSk1BREZ4TWplc0FNUGtiaHJCYitKWVNYUGda?=
 =?utf-8?B?MVBEQzl1STNzaXE4bklGd3FKd1Z0QU1vQmhsTWllU2xYYnI5TFZSVlZPVXdQ?=
 =?utf-8?B?NGZBK0Jrb1o3NmJSbWlpWHlIemluMXgzbkJaYkxWaTNOYzQyMnh2Sngrc1VE?=
 =?utf-8?B?SzlMMFJuY1NHOUZ0TWcyaElKWWV3V1QvdlFaeUpPQzdwTVF1N2NyZGZ3U3hl?=
 =?utf-8?B?UFN4WTJMRjVLU1laRnBqRXdnS25hR3F1VFhmeTc4UUxId3QxcTk3TUdjdEx6?=
 =?utf-8?B?R3lWek9XRUoyblVvSVJCemJJMUhvY2xpOFptRzVIanlHSURqSUxFT1ZXQ0Rz?=
 =?utf-8?B?WEZvcW9WN1BLcDVBWTFWc0VjV3RzK01tTU1SLzBrbU5WbVJXZkx6WGtZSUs1?=
 =?utf-8?B?OUY1eE5MUEZUSFB1RFl4c3pFZE9sVVVVNGkvdjJzTW9iZ1VubkF0SktzdVJN?=
 =?utf-8?B?enA0V2EwODZxOS81ampDbDBRSi9FU3poZTc5NFpXSWFnTnpOeGNUNVVYVUNT?=
 =?utf-8?B?NlhreG9WZlhuUXhjdnJyVFExUW9LT2drTTZ5dEdEYzE4eDBsT1JBdno5ZVRX?=
 =?utf-8?B?M1pDTjhHUHNTb09OMytaVStZK3lrSnIxay82b1dGRjJqQ3VMRjhTeGgwUENL?=
 =?utf-8?B?OHIzRXcrcDR2QXQvOUdUeThqRmNlUTliTTg1dEVBemZlUnBxZUhLbVZvSXMx?=
 =?utf-8?B?VFNVYmtFdHFQZ2pPYThKWlBMdnJITjNDeTkwRHlNWE5DMklrdDVSRVR2a25S?=
 =?utf-8?B?TThHQnBQQ1FwVkRFeVZjMDJXZ3dyVmN4Q0JoQmtnSlJSL3hJekQ2b1FIMWNP?=
 =?utf-8?Q?a2A6oDo0d6X9M/8s=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633e3909-a068-4906-ee6c-08d9fdc8ebf4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:44.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZakFWGlb8BAjgttDwr6rXH1450QU63o61qFxlfm+zoLpad3OMfpuqZqJNMrvzEycyfpANWgE+Kz1rygmlVn1/nlmlB3oIUB2PQINrPtjEoU=
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

Each data path needs an array of xsk pools to track if an xsk socket is
in use. Add this array and make sure it's handled correctly when the
data path is duplicated.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  4 ++++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index fa40d339df8d..12f403d004ee 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -109,6 +109,7 @@ struct nfp_eth_table_port;
 struct nfp_net;
 struct nfp_net_r_vector;
 struct nfp_port;
+struct xsk_buff_pool;
 
 /* Convenience macro for wrapping descriptor index on ring size */
 #define D_IDX(ring, idx)	((idx) & ((ring)->cnt - 1))
@@ -501,6 +502,7 @@ struct nfp_stat_pair {
  * @num_stack_tx_rings:	Number of TX rings used by the stack (not XDP)
  * @num_rx_rings:	Currently configured number of RX rings
  * @mtu:		Device MTU
+ * @xsk_pools:		AF_XDP UMEM table (@num_r_vecs in size)
  */
 struct nfp_net_dp {
 	struct device *dev;
@@ -537,6 +539,8 @@ struct nfp_net_dp {
 	unsigned int num_rx_rings;
 
 	unsigned int mtu;
+
+	struct xsk_buff_pool **xsk_pools;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e6a17af731ba..abfc4f3963c5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3302,6 +3302,15 @@ struct nfp_net_dp *nfp_net_clone_dp(struct nfp_net *nn)
 
 	*new = nn->dp;
 
+	new->xsk_pools = kmemdup(new->xsk_pools,
+				 array_size(nn->max_r_vecs,
+					    sizeof(new->xsk_pools)),
+				 GFP_KERNEL);
+	if (!new->xsk_pools) {
+		kfree(new);
+		return NULL;
+	}
+
 	/* Clear things which need to be recomputed */
 	new->fl_bufsz = 0;
 	new->tx_rings = NULL;
@@ -3312,6 +3321,12 @@ struct nfp_net_dp *nfp_net_clone_dp(struct nfp_net *nn)
 	return new;
 }
 
+static void nfp_net_free_dp(struct nfp_net_dp *dp)
+{
+	kfree(dp->xsk_pools);
+	kfree(dp);
+}
+
 static int
 nfp_net_check_config(struct nfp_net *nn, struct nfp_net_dp *dp,
 		     struct netlink_ext_ack *extack)
@@ -3395,7 +3410,7 @@ int nfp_net_ring_reconfig(struct nfp_net *nn, struct nfp_net_dp *dp,
 
 	nfp_net_open_stack(nn);
 exit_free_dp:
-	kfree(dp);
+	nfp_net_free_dp(dp);
 
 	return err;
 
@@ -3404,7 +3419,7 @@ int nfp_net_ring_reconfig(struct nfp_net *nn, struct nfp_net_dp *dp,
 err_cleanup_vecs:
 	for (r = dp->num_r_vecs - 1; r >= nn->dp.num_r_vecs; r--)
 		nfp_net_cleanup_vector(nn, &nn->r_vecs[r]);
-	kfree(dp);
+	nfp_net_free_dp(dp);
 	return err;
 }
 
-- 
2.20.1

