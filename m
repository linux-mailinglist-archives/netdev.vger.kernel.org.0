Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A134CD24E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 11:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiCDKXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 05:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiCDKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 05:23:33 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2115.outbound.protection.outlook.com [40.107.243.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0FD3982A
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 02:22:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeHnqdD9ON8EEbkoFqpAerRSlF6pPmlBjsDdErOQHgVGg6W0q+Sk7xfGsbxI4HOZYcTi4RqB44IepZ9h3CNBzh1tpldaKOZaA87qxzVS/rHTp850n4sWScNH/X6CDj04BvT828VNrmz5KWcAvp1gSVYgAE9AOwF2vA4VpUOqkHi5ZD8aBcr/16OCAEYcAVOI09flGjTayBWI46ab+mlXg/b1amIdCqx272tdgLeRe3UGH6Z8VFvLjvzJz7pjY0kd9rHLvFMDTCqYsEk/CiakUaw+oY3NkIN4CJk/+TtiLg4qWxW4JX0u0ykzk58qrcfBal7La/3R6BTHr/q4eqizLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FESGjbWHNHBlPyIYx56n6E/WhnW/5Vv+TOUVWTpBUWE=;
 b=Xy9TlDpflEQXcuO1GrxKBMwF/CLbs5OFNg4lFGsv7f3z9LSNPaYiNESzo04MlhlfRAefKLF1jp1dARDIRXAAir2A12usTprFscO2UicI7QP1E2kXsbRY25yVGlCGgI0dlgIp1Q0I7yteZSI4udaUgSColeR8CHm1po6Kjf4/Hs8HCnHNMPYvgU5DO7M3HqWnakBvGAduTSIyxtsMkGvJvsceggmVPTmiPgB55fISgwLAABTxcoZtxpkds30JeYdalHQyCYxLGvfZljmYtJczhe6caeGPghwdFFwdlzpMlIHkipZNn2P4wzGj/EbDEWV5m8PR3C53KkOs0FG28lhyuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FESGjbWHNHBlPyIYx56n6E/WhnW/5Vv+TOUVWTpBUWE=;
 b=dWtj/tgPSTNXT+HwvfUrxAA36GSq10D4l30nip9uR2Vh/yZ+VFi+E60nCK57ESZTmTygksqDV8TfWFKIC3h9ao4nua1xKirDmCv6mu/51MyVjAeuAo9tFj7JqxddW1e+gQmNlc7p/xGg2RzCQLGUFvTjgZcS6kLIfkoMqej6t4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN7PR13MB2404.namprd13.prod.outlook.com (2603:10b6:406:b7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.11; Fri, 4 Mar
 2022 10:22:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 10:22:43 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 2/5] nfp: wrap napi add/del logic
Date:   Fri,  4 Mar 2022 11:22:11 +0100
Message-Id: <20220304102214.25903-3-simon.horman@corigine.com>
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
X-MS-Office365-Filtering-Correlation-Id: 19602b54-2bea-4cea-587e-08d9fdc8eb1e
X-MS-TrafficTypeDiagnostic: BN7PR13MB2404:EE_
X-Microsoft-Antispam-PRVS: <BN7PR13MB2404A8E10736C044F5751F08E8059@BN7PR13MB2404.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CsLshtJNJUusKI7SDcf37+hlYaYJV6D3UalESD1fVo/G/DeoGpD57lv60W/pNclRcD1EUATuiXNnZXGbXcBPDLwEYJAzIJ7q3bIZgBqZ3bHOU1zPUVbva75HWJM1nYQfFOdMqODWUlz405dPKP5Wr1U8vvk7fHTOwii1g3V2Zvr60P9W2HkXXoqhE+csYeembFZ6dewARYmCzcC4iLVLbALX0h3rEGXb+fCbnbG9f3m8SV6J4G3KTTiX/9C7vhtFREnnPPFpCRfkniCGyFqjyYl6yzLE+e3tUMxAz97Gb1FumtErtQ0szFAfj2sAH2ZvdDhGuXbdr69ajaoMfdOE/JtRrcQrbQVzDzykxmiaVeSD0OGpto/Zao7TOEkqJZsoN33DRklDOuq63V/5gZTOXPRe5NSBQiPoNXgJCWkHdyMgs/cMKBPQEyoCr0S+juTzIU+eGHuIue8pNSlKAZQD0/ZDFyHXv38hpS9247bdqksVjuponnjYlUpPBuTqfKO/83XGSYWp89qXvKGkLvIdL1kpJcuW7X78M8fQkGSff3CteLbGaHLyqNVU5pf5L/p6Gd6tpmcmvOlKJ07h1jp1Ogh8OIeBM6uua/7LeY6phNmhfpz5DM8OTZ7mM7c8ADC7MPlZF8ZlrYM+29pHZzfPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(346002)(136003)(376002)(39840400004)(110136005)(316002)(86362001)(4326008)(8676002)(38100700002)(52116002)(66476007)(66556008)(66946007)(6666004)(6512007)(6636002)(6506007)(6486002)(508600001)(8936002)(44832011)(66574015)(107886003)(5660300002)(186003)(2616005)(2906002)(1076003)(36756003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzJuQXpXOVZyUURmT0ZNSUhEdHBndnVEdFRDMVorcm9qa2hqcDBSb1FsbmJL?=
 =?utf-8?B?VWkydHgrVkJrYk54U2F1V0hzekdxVkhQV3Q2Ni9hU2trRVlpUjRYWTdXWWI4?=
 =?utf-8?B?OFkwbmRwbnFWRkZta1R4TUxZMytMOUh5a29GNTNpWXdKb1hFUkIvUDVFQnZm?=
 =?utf-8?B?RGQrczh1bjhxZVE5c3JRakpPUCt2RlpPRGZRREM0MWdrcEFVSGkyZHVuWDFz?=
 =?utf-8?B?ampaSWJBdzdiRHNMWkx0USt1UGpUUVlBMUJqMzhqMzV1SzZtaWFNT2xzaFFq?=
 =?utf-8?B?K0YrUkpDRWFHQWdzS3krZjI5aDJGVXBvRFgyMjNtbHVrNXpwMjlxaElMaTZy?=
 =?utf-8?B?NVFtemptUVZEQ05oVEI2ZmpxWHZEaUFiY0lUNUNuMGllR0t1YVdHR3hyUW9i?=
 =?utf-8?B?dzE1b0lMTnYvYWlMTTNrUHRaa2cvNGc0bTRXV3FtNlVCTHA3U1BRNXBXSkpO?=
 =?utf-8?B?WjJSM2toTWplb3RCY2pkQ1NkeEtnNnVaNnBJRFBCdVZ6RTJLWHh6QkpGcEhz?=
 =?utf-8?B?SXdzZGZZZDJtSHpMeGQrYm81Rkk3clY0YXZqRHh6MXA3MzB3d3d2RDlwZStv?=
 =?utf-8?B?NGhqQmZtZktRbFk2Sy9GcS9EQWtMemNLamxvZlA5dEN6ckVOR2hQT1Qzb1ZN?=
 =?utf-8?B?dkgvdlJRVGV3bG1ZR1FnbGpObjdOVFIwVXBGU3kzV1E3YVBpSGpHLzdsQlpM?=
 =?utf-8?B?R2d2RzJQZVlTVmJmNFRTbjJhVzh3TFpncjNYbFJqa2ZCWWcwRzE0cStHSmJs?=
 =?utf-8?B?ZGZOUzBUYk5yNElYRm9LandkVC96SHQ5M0tVOWhmWkNHVXFSMFJ0VUZHVjJS?=
 =?utf-8?B?QTgvM0hIY2prVDF2YkZWODlod0Z0c2k0MzNxczAwMzZLaS9ZdUZVZ2twemlI?=
 =?utf-8?B?bS9XMWZXSTZKVE42dXhSM3JGUlc5a1lybFBReTk5ZVJXbmpRWkhKVUZSMGNx?=
 =?utf-8?B?QkZsVmNMeXhKOU5FeDZ0eEV4ZVdaeVlBRm90YWUxUXkzNzMwRFhUUThLenM5?=
 =?utf-8?B?a3lrc1VJOWVxM3hjbHVzcTBRMi9NQnRoNEp5YWtLM2kzc0R2N1pLVkVXVVhm?=
 =?utf-8?B?b1RpcEpVampSNHBPVkd6WXIrNEc5dnZNak9LbG8xaHJFK0VqMmd6UXNjTU9B?=
 =?utf-8?B?K2t5ZkVHdWpwaTNObVZnM3FIQ2s5N3UxVUVUV3hDcUxtdDYzdDBidEcrRXh2?=
 =?utf-8?B?bnAyazRVTEl5dWlObnIwbGhXcHlHMG1hVTI5cnpBd0kzL0xBdExOZjFRWDFT?=
 =?utf-8?B?THdxTzJnVFRxWTBIcDM5OXlEVmF5anBJSkdTZFovZ3U0dHo0M0hNOW9wNnRj?=
 =?utf-8?B?TzlCODQ4czdkR0RsekF1VHhwVnB4VkRjTC9Ldk9zOStlL2VxNGtCeWlhNnlz?=
 =?utf-8?B?OVQzK045ZVlvN0FXQU9LMG05OExqVUhFSEJtc1V2TUdVUDVPMWRYenhqQUg4?=
 =?utf-8?B?RTR0eEZjSysxRDdKUXJkVFNTdklpYkVHY1ZHZ2YvM0dpS01INXNFMlRCTTNi?=
 =?utf-8?B?bVJxcTdqbnlvdXNnZHltV3lVcllzY2ovUlFRTDd4YVRrWGFCRC9vU1hwSXdZ?=
 =?utf-8?B?L3JXb1hoVWNIMjd4SEtBT3loVENFVm9LNXp3UzZSN21YU0dzQ04yVFB3Vmx4?=
 =?utf-8?B?dU9KQ2JZVE5CT2ZFVHBKaXJYVWlBYmNRQWpJaXV1Um91amF0ZGlzUEJxZUdx?=
 =?utf-8?B?N1l2WFlKTmpwWFJRSTZoUjRFSmVKejZyT1RwSE5ET2NVK3JLOFliWVNhOGwr?=
 =?utf-8?B?bjlROXFzWERVT1VtbmQwK0M1bnFrMGVOeTN5ZnRzQUw2aVkwUHdwTUhCVktP?=
 =?utf-8?B?VXN1Rzk0aTNmeHBRS1dTRXFnN1ZIeFFwY3d4eXI3ckZiM1ByK2w4dDdGOUdl?=
 =?utf-8?B?T0l3bDBLcFVCU2tCZ2EwTEJwU3hQTnI1cUgzTWNRR1hDR2FkdHorU0hFdVdU?=
 =?utf-8?B?STJZTTcraWk4d3h2dExCaEpjZ2tnUWNjUDFNV1FwTlR3NFY5QmZ3c2NTajgv?=
 =?utf-8?B?OW00M3QrbmNKYU00bU5Jbmh0VUVuQmxqa2twWWlYTXdZNldVcUsxOXd0bENq?=
 =?utf-8?B?ak9wOTFRNFhuSWlDTFczYUdlK2pYVkF6SmU3VitHTDhiL2JkSHpqMFpIUWhM?=
 =?utf-8?B?K25RbllvTmhCLzRXZnZVMmRUREJSTUk4UEVGYXlxdVdqMERlR2dZbDhwNndU?=
 =?utf-8?B?VGRZTDBqNE9OdEdVeTlXaFN4MEVhRGpvNldIVUdYa0c1K3dWdGhCdzFiMlg4?=
 =?utf-8?B?dXJiK1ZjV3NwWU5qZEZ6ZDdEQ3luQnR2SWJUQUdrTG1sM1R2ZnJuU2hZVVZ5?=
 =?utf-8?B?bDFFMDc1MlplMWtreWI5TU1vaXhEVjVTTnZKbE1QT2dmQ2VtaWlYSWxNZ01Y?=
 =?utf-8?Q?pEVSsAeAoLRMF7PQ=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19602b54-2bea-4cea-587e-08d9fdc8eb1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 10:22:43.0649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ad8Zsc3OiXT+hieQ4rRQ/wY/09hQYD2v0F5WCa1jStD/A7GHZGVELpgWt4ryDM53rxXjdEXG0r64sjP3fCr7gkPtWzBFXGAomfnPHN5AyAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR13MB2404
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

There will be more NAPI register logic once AF_XDP support is
added, wrap our already conditional napi add/del into helpers.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../ethernet/netronome/nfp/nfp_net_common.c   | 38 +++++++++++--------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index edf7b8716a70..e6a17af731ba 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2638,6 +2638,25 @@ static void nfp_net_rx_rings_free(struct nfp_net_dp *dp)
 	kfree(dp->rx_rings);
 }
 
+static void
+nfp_net_napi_add(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec)
+{
+	if (dp->netdev)
+		netif_napi_add(dp->netdev, &r_vec->napi,
+			       nfp_net_poll, NAPI_POLL_WEIGHT);
+	else
+		tasklet_enable(&r_vec->tasklet);
+}
+
+static void
+nfp_net_napi_del(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec)
+{
+	if (dp->netdev)
+		netif_napi_del(&r_vec->napi);
+	else
+		tasklet_disable(&r_vec->tasklet);
+}
+
 static void
 nfp_net_vector_assign_rings(struct nfp_net_dp *dp,
 			    struct nfp_net_r_vector *r_vec, int idx)
@@ -2656,23 +2675,14 @@ nfp_net_prepare_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 {
 	int err;
 
-	/* Setup NAPI */
-	if (nn->dp.netdev)
-		netif_napi_add(nn->dp.netdev, &r_vec->napi,
-			       nfp_net_poll, NAPI_POLL_WEIGHT);
-	else
-		tasklet_enable(&r_vec->tasklet);
+	nfp_net_napi_add(&nn->dp, r_vec);
 
 	snprintf(r_vec->name, sizeof(r_vec->name),
 		 "%s-rxtx-%d", nfp_net_name(nn), idx);
 	err = request_irq(r_vec->irq_vector, r_vec->handler, 0, r_vec->name,
 			  r_vec);
 	if (err) {
-		if (nn->dp.netdev)
-			netif_napi_del(&r_vec->napi);
-		else
-			tasklet_disable(&r_vec->tasklet);
-
+		nfp_net_napi_del(&nn->dp, r_vec);
 		nn_err(nn, "Error requesting IRQ %d\n", r_vec->irq_vector);
 		return err;
 	}
@@ -2690,11 +2700,7 @@ static void
 nfp_net_cleanup_vector(struct nfp_net *nn, struct nfp_net_r_vector *r_vec)
 {
 	irq_set_affinity_hint(r_vec->irq_vector, NULL);
-	if (nn->dp.netdev)
-		netif_napi_del(&r_vec->napi);
-	else
-		tasklet_disable(&r_vec->tasklet);
-
+	nfp_net_napi_del(&nn->dp, r_vec);
 	free_irq(r_vec->irq_vector, r_vec);
 }
 
-- 
2.20.1

