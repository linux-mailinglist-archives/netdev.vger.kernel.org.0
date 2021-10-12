Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0314542A4DA
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhJLMvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:51:23 -0400
Received: from mail-sn1anam02on2110.outbound.protection.outlook.com ([40.107.96.110]:54146
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236326AbhJLMvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 08:51:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGjO1RIy6clVTu+dmTeFwWGmL9COKJJHa8B/O7UaAPGectSgeJRRHaqM3TvyhbnY5fA/J9oXww2lGKuDWULUePviwBNHj3BxBWMS1Ipo+7idatFpy5p5tzefVrt/9x/tlTAzQSq/1EtH5OpskddOXnrwbq1+t6eSduX+OdBBcaa2AWeMbbjj977eJ4tnnXe2PASIUGei5+LtFueNbedO9HP/gmnAk+JMWdBo85Ly6r4bwMTnvTR8ecIVD/8WvbGNKrjZNKNbPDL0oVG9JDBpKSV4Jy6N2WBeSFcvvt2CmMYnbzgoMZbpIzDs8sXASEJgHO5aGg3fU7w0BRzikRc2QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+aulXFgigVFMeuUDrXwgB2QEQ8PvFWPqCyLX9X7ekc=;
 b=KESzSPKOetkIuReBGvGiSHozrPdKFjo5SdMuP8YkHtvk/+ZIAjcoi8MK+9KvayoIQWc5LCHGjvPctJED9Rxd4aR6fRAobry3wipl3LyOcTZY7LQ8YcRfK1c89Q7YHPaenvSpuX/jTzFcBW5/9lzePGWwvZ24Tys/RhIDqBtSV71g3t3VpqzyRzPwjk/g/r8/3guGEfgAzlyQMvSLTG5C+dQyJDWGTwBSSL04NVekEa6Uo/qPId21AEJBW0Qj4VaSpn57y4iMh9SKsu+BsrVuP5tX9M1gwDjsxEHCTIxHHmeLoP8Ov5+gcTJhmKW1cMtmqTvPQJI8yfJLnPsqBXudeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+aulXFgigVFMeuUDrXwgB2QEQ8PvFWPqCyLX9X7ekc=;
 b=kJ8I94pG29TIH6mNnNijBySLuql1+UBd0wwvDmizqez88he0+JrTuMsKUDr/SMRIW5R79yF9WBw1rKxekdn/fgGvh+22vjr6djsTXW9Mpj69OVxZCBX0C00PtjfraeQptIrbBFdGCbCTVCqDc0B6IZpBYZh6ZRVvAVT9FdPmfaU=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM5PR13MB1098.namprd13.prod.outlook.com (2603:10b6:3:33::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.8; Tue, 12 Oct 2021 12:49:19 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::19e0:ef5d:5a60:a70d]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::19e0:ef5d:5a60:a70d%6]) with mapi id 15.20.4608.014; Tue, 12 Oct 2021
 12:49:19 +0000
From:   louis.peens@corigine.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        simon.horman@corigine.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: [PATCH v2] nfp: flow_offload: move flow_indr_dev_register from app init to app start
Date:   Tue, 12 Oct 2021 14:48:50 +0200
Message-Id: <20211012124850.13025-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNXP275CA0006.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::18)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
Received: from localhost.localdomain (169.0.68.41) by JNXP275CA0006.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Tue, 12 Oct 2021 12:49:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37f41ee1-5476-4300-36f8-08d98d7eb4a0
X-MS-TrafficTypeDiagnostic: DM5PR13MB1098:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR13MB1098E6C99E0E7CD6A6728E3688B69@DM5PR13MB1098.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ExIqbfAIaO1p7jABd8oOrZsZw5dMBule8nJDcB/FsOSHIOY3RMWg0hqBFTDfZeBBsGUqQ5fIMHu6EZwqqWl9/uH2DAD9wY2yYA8sd6d7S0JWMJRthIGUAPR0j9D8eeR9Z3NlV832VKhqYK7qlY17O50bDbf8YOOEZrSM0dd93QhsGblhkykXo5F/RbZDgpFOrf8Veemn6okZ3FMCrL/jc6oOm/oirp+L87bPph6i1vmcz/30RKNze5Fy20//63LSEVRxnt4L6Mij3JCWhJfUmfL0fUc2LKaia07NOr0+sQfmPDWHt97Oww2yKZA/Jcod5+4Raaci+aFw/RvCdj3aIZ0pvkqobmBcoDpbR/a8lb9ywyW8TQsXm3SUrE2eqYlFcLBp21K168hK7U7nZeQW1gWa6J3GrpcJosczqE4psNo53+P9AT/At8b7egFPkN/i/TeqpMqGuVOEpomlfsah/s0m6jkjGLzO0l32msFozE8ddt7cub9FgO/keUNwC/8uEac87Al7qxxbhu5epvFyLTmryCJvFI/HP0MGj/+blB3omKZrmtUJIgqFaoOodGyJdcyYAiU8Ue4f/rd3rMvHV7boL/N4CsaiCelTDFrymgCld74d9sGnULvLAXOxOCno/XYtv/y+r/0HnfCunwiuAZFbLM5u823yLOZTYwGlrvR3BaFKLrvMIS12J7pYaa0gTFcXT4AKeCg5khQEEzR1KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39830400003)(136003)(376002)(8676002)(66556008)(2616005)(956004)(6666004)(4326008)(83380400001)(6486002)(6506007)(508600001)(66476007)(9686003)(66946007)(6512007)(52116002)(2906002)(36756003)(55236004)(38350700002)(38100700002)(186003)(107886003)(1076003)(5660300002)(316002)(26005)(86362001)(54906003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zf5PaY5l7f209yTsW8qKLp9owMwTuoAf13KquPpD34gv1FGhZTbnPpaCPfiM?=
 =?us-ascii?Q?vy5VDEzx9QBXyu05r9PLxgL3jeCK8jn80Uy1Gk3w50WgZAPR/pxycyo/Pwqc?=
 =?us-ascii?Q?TloIlawQWBQfx5Wb6LzUBJSg5xux8iAaD8gLCSK+HacuSyGYw1i3lXsozbdo?=
 =?us-ascii?Q?kGo8vQ9xrgBoNne6MbfLX2rx7WoeZV/2tZh0InEpJjtJ42dZXdMYWU48SGAP?=
 =?us-ascii?Q?Fo3aF18y29VofsLZAo+7cvxI+8qSlRjO0mCcMAN6UV77WA5i7lZuuON/DL1F?=
 =?us-ascii?Q?zT1Qr5lxv3IcUC5PDjkUTFRvgRNCdVVEnpBpoq2F1W7z7gYVnvfRp54pj2kl?=
 =?us-ascii?Q?7wOY/ZXKslxxumoS7ZFbcK2TjfXq4dwmcs+xjtb7rswo7OKZbt94Y18Pqdnb?=
 =?us-ascii?Q?ElRq9VyDpMmx8j8a/vbXiflMSfoeTbBSiKfL65xiRUqDbxqo+VsX1eeg+cpA?=
 =?us-ascii?Q?jAtCQNC/nYpM9avyfBGlhAG09sN+S3S+xnbZnWq/qoSlRxFOLsojx4dyxt5k?=
 =?us-ascii?Q?t5bQKZRbbw3nKLHdCUI7pZEDx0WTaSo21QkAMtXgOwVxKFyQXrbaEV8gweFk?=
 =?us-ascii?Q?PHoomREGRcnoqg3WXN04QxAuNoRhumnw4vdGBcTGRSEcIlTjM7AksaKBeCia?=
 =?us-ascii?Q?5OPYOyCbqb1ylHPIva+eBTxCAhWt991NI+wrzUD7KZpAYHuRzXU+CeOKHVS6?=
 =?us-ascii?Q?VQ38hytdvM5u3XRY50Z7XAYjGGBJh4v9PIsbfxzqZW8LPvo64mFbyP7XGIgu?=
 =?us-ascii?Q?cWKF6oVne1octyaSwbC3qfU/ci9yXRsUMdUiIUG4rTGH46kVShbjBJkW1nWb?=
 =?us-ascii?Q?vhWQ3z5eDatZMPB2j0Vvi22MkCmgWyTSAbpRVleFHsbcHfgqgWnhiJ3US1i/?=
 =?us-ascii?Q?NHC/EhaNCXqTYQBWZQu2h9VUzYr49qmzeE8KTLoM36C+QhOuU9hQrxLtDnZO?=
 =?us-ascii?Q?7ii6U7RHU1bqjY4uqpHnZE+fbOV56aS9b7ict+LH7eN01MvyX/fQwYyjowtk?=
 =?us-ascii?Q?fmSW3pf2LsDUtftnXilf/t+JHHi59Cvt2eDreF6uWPmhmeA6AYrWKCw67uA2?=
 =?us-ascii?Q?UR0/2rGQogoxryKFFNR0IPY6onYUv0O0hOxSDRPY9EXgODsQt8gf3HPwy2vo?=
 =?us-ascii?Q?IE5pi49gZfO7yJnJq+0aFOK/vI+cofaPwBi51owpNq4PxbWXzqLZOnI1Tlh7?=
 =?us-ascii?Q?M0UZo72GVqLdI4sEHH6+UPpmwqIplQrG19MqhH7V2Q1GWnCgF3mVhbLdhU9Q?=
 =?us-ascii?Q?h2D/j0KRzdgK4sNhPwJDcekxJdfezPhy0vQrNjuhjFYX1AbBumasFgKqyKXP?=
 =?us-ascii?Q?C8Nw149CSvShBLH8+hLA/Dy1?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37f41ee1-5476-4300-36f8-08d98d7eb4a0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 12:49:18.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K902bFZG3ayDOux6alE22YjM4tN6e2RnqHuPv6gRubk+GfTSOuvT09amdAsGeqOlkY3FO0vv4WALgDqj4T2KXPWKZ07r9BV0zN/80K6LJ/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

In commit 74fc4f828769 ("net: Fix offloading indirect devices dependency
on qdisc order creation"), it adds a process to trigger the callback to
setup the bo callback when the driver regists a callback.

In our current implement, we are not ready to run the callback when nfp
call the function flow_indr_dev_register, then there will be error
message as:

kernel: Oops: 0000 [#1] SMP PTI
kernel: CPU: 0 PID: 14119 Comm: kworker/0:0 Tainted: G
kernel: Workqueue: events work_for_cpu_fn
kernel: RIP: 0010:nfp_flower_indr_setup_tc_cb+0x258/0x410
kernel: RSP: 0018:ffffbc1e02c57bf8 EFLAGS: 00010286
kernel: RAX: 0000000000000000 RBX: ffff9c761fabc000 RCX: 0000000000000001
kernel: RDX: 0000000000000001 RSI: fffffffffffffff0 RDI: ffffffffc0be9ef1
kernel: RBP: ffffbc1e02c57c58 R08: ffffffffc08f33aa R09: ffff9c6db7478800
kernel: R10: 0000009c003f6e00 R11: ffffbc1e02800000 R12: ffffbc1e000d9000
kernel: R13: ffffbc1e000db428 R14: ffff9c6db7478800 R15: ffff9c761e884e80
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: fffffffffffffff0 CR3: 00000009e260a004 CR4: 00000000007706f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: PKRU: 55555554
kernel: Call Trace:
kernel: ? flow_indr_dev_register+0xab/0x210
kernel: ? __cond_resched+0x15/0x30
kernel: ? kmem_cache_alloc_trace+0x44/0x4b0
kernel: ? nfp_flower_setup_tc+0x1d0/0x1d0 [nfp]
kernel: flow_indr_dev_register+0x158/0x210
kernel: ? tcf_block_unbind+0xe0/0xe0
kernel: nfp_flower_init+0x40b/0x650 [nfp]
kernel: nfp_net_pci_probe+0x25f/0x960 [nfp]
kernel: ? nfp_rtsym_read_le+0x76/0x130 [nfp]
kernel: nfp_pci_probe+0x6a9/0x820 [nfp]
kernel: local_pci_probe+0x45/0x80

So we need to call flow_indr_dev_register in app start process instead of
init stage.

Fixes: 74fc4f828769 ("net: Fix offloading indirect devices dependency on qdisc order creation")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
Changes since V1:
    Make sure to call flow_indr_dev_unregister now, as nfp_tunnel_config_start
    can fail after the register call. Thanks for catching this Jakub.

 .../net/ethernet/netronome/nfp/flower/main.c  | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index c029950a81e2..ac1dcfa1d179 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -830,10 +830,6 @@ static int nfp_flower_init(struct nfp_app *app)
 	if (err)
 		goto err_cleanup;
 
-	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
-	if (err)
-		goto err_cleanup;
-
 	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
 		nfp_flower_qos_init(app);
 
@@ -942,7 +938,20 @@ static int nfp_flower_start(struct nfp_app *app)
 			return err;
 	}
 
-	return nfp_tunnel_config_start(app);
+	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
+	if (err)
+		return err;
+
+	err = nfp_tunnel_config_start(app);
+	if (err)
+		goto err_tunnel_config;
+
+	return 0;
+
+err_tunnel_config:
+	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
+				 nfp_flower_setup_indr_tc_release);
+	return err;
 }
 
 static void nfp_flower_stop(struct nfp_app *app)
-- 
2.25.1

