Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8382429371
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239079AbhJKPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 11:35:11 -0400
Received: from mail-mw2nam10on2116.outbound.protection.outlook.com ([40.107.94.116]:44922
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238718AbhJKPfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 11:35:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tn3o0ch3LKFiVcqS6f0oyhLuZfZRJ9KflfFAT6D7ABwYgK+oPd1CAEgsH5mDIPxahQWM1aehs4kFWXm25wIJlbkXkAsPAT4mog/pzhb3Y9lyLc8Vib2aN9spg/Vhv5NSofI50xCrPqN/vRClw4rZIEA4kkzm0KoDRR7aN14OhuLC5SSChjBdxQftiJ/847Ol0majF0xDJlMWajz76EpcOOAkX6lS4eK2UPMNiiF6B07ERRprCSIaBB7qOLMiMQ0vjrrtuGczHl0SjE7kYtrvVtx/uVbDtnB4O2jzCcmjVmgc53Z0GLSVtgUromXGSGix8w/gfAI9HKbGtgO5jsbCTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKLhA8/rUOQmlPUWYQaJ5qvTpu5EsV6MKSMf4IdW+ec=;
 b=IYZTGHWNvypiWAZuouB1f8MICD+jaMmbMyQgmg4e6LZw50X37E2rgaytDOEiRSSVOSPcdBWlA9FZ8EnMTX5D8PHvKI0iZnDDBuXWiuiSedQwZ4y11rMGLFJZZ42WrC7O+6CwiYEvaSn0KtKud5p7Wqb9AB/2scRf3nhI9Fil7B50gZPY1v4Kp8bve9esleUcEjP2E9wdK28xLL+Fovg5/BT0YdworRbIx+Ix+aoyPC3qZ0YrQUfWb1Ifj3J8n9BWn5d8tHvWceku1Fbm0eAhHYhkoWp+vJ3kT1XAOK0/ceMhthAbxjNChSMAJNxK1rEhISsb7dxN4JnKMfeWEuk73w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKLhA8/rUOQmlPUWYQaJ5qvTpu5EsV6MKSMf4IdW+ec=;
 b=LOwHxXFukj8bSuG+XnpqnEH2emXFsCvyRhPLnW9BznqknOVY/d/fiPb4j9UNARWZxbN87qrOYv4p1Gltzrv+hHZnGjpqtEgsXY5Tdz21r+gxl24ngO7wgQS0MEK8pnLL2yrpoZEmQ+zm7H/ogwdBZ4FHbaWfELZNJ955l7cWD1s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB3900.namprd13.prod.outlook.com (2603:10b6:5:24c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.10; Mon, 11 Oct 2021 15:33:00 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::19e0:ef5d:5a60:a70d]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::19e0:ef5d:5a60:a70d%6]) with mapi id 15.20.4608.014; Mon, 11 Oct 2021
 15:32:59 +0000
From:   louis.peens@corigine.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        simon.horman@corigine.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: [PATCH] nfp: flow_offload: move flow_indr_dev_register from app init to app start
Date:   Mon, 11 Oct 2021 17:32:00 +0200
Message-Id: <20211011153200.16744-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: JNXP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::29)
 To DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25)
MIME-Version: 1.0
Received: from macuntu.zay.corigine.com (197.245.75.152) by JNXP275CA0017.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Mon, 11 Oct 2021 15:32:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed9f768c-b1ab-48ec-ab6f-08d98ccc67fb
X-MS-TrafficTypeDiagnostic: DM6PR13MB3900:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB390076252ACE973AF457739388B59@DM6PR13MB3900.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p8+pjc3fODywqM/qXrU47Gt7RV4t6bjL9/5sSGYEywC4WFnvvb6QR2hhzYt1zM9o0abrbVmAizoRlxolQ5N8MABvXh5t+y0OL0X7P9UY/9srWO6hrNJFXmnr5K7tR9v42U4P3SVl/nTsKs/3fWp8uNEnx/b8MT2J8OCur52iYS6sOmnVJ/oQgSZveHN1LW3bpjpAD98RLir6f+SuLiblw7kJUpo9IKuGVf9vUWWUEFDbSk3ky1d/Mbt6g3kUjibDXOuI7QdQ4GpDTRkC3eIMsX2Ie+9DAeFwAobUgGri3u8nod2/zvYHRLWJsJXzQoTkyD7Y+lr4gfXxk+B4XI7EkT62WUKB3wiJIY2tNG+nulEb460c4bqzx6SqqNooF3VSdjehHH2+9YUD+8mTj+dZS7sr2AF/9uuQhYv5mrXzulqtIocCEu3ytB266zxdT/uw1u9aYJgIbTdRdV9O1FMXr9E7H/CeCD36GRJwqV6dV6PvNox50Se7PkxFjRrYxy2HqbS7UmyV0FQ8oDAwuxyAtBXkbmS/dH04qgstlss2J+QyaUGWaSerAcWlVO38VypaQRlP/ryoue4zCiI/n+NkXz2vckym8BnrypOfPdfWIKFA3Rp8lxWRTiqJ7meHrMz59sD3ZzPwi6ohpAerfMTKH3gl+SRbz5p9Ok8XaAYFOg6KTBNjohBjIxOsKy1PLKX+gHHJXvykIuJ/1ntmHZxD5xr6KnCjI5Ft0ikPGGUL7wM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39830400003)(396003)(26005)(36756003)(186003)(107886003)(6486002)(316002)(9686003)(54906003)(52116002)(7696005)(8936002)(5001810100001)(8676002)(5660300002)(1076003)(66556008)(66946007)(956004)(4326008)(83380400001)(6666004)(2616005)(86362001)(2906002)(38100700002)(38350700002)(66476007)(508600001)(18116004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Ltp3QN61O4wqUbKLJayYAZFsTTitnz1WS5kvbXHWgfflZfOH5/TyJLubIlj?=
 =?us-ascii?Q?RXbphc5BtwuFNYJVP7ab8NPw1bEt/499SsvOFltrHi18YHgmZ8N4K5QVrqWD?=
 =?us-ascii?Q?F6GNrpAcEvYXu06Z4rIT+GkHGR4apYKPiuMragSinSe3VZnqx6PDFTty4zKq?=
 =?us-ascii?Q?Vbj3ZYdhjgFzV0YUa83jwNnhYghW+QF6tN4txaF1Ku8PgzHFvgSWTHbrHoJ2?=
 =?us-ascii?Q?KnAr4sxk4caxEd6ffqIXLi4npvp5PY6LXOdRyNcTHI/eWYK3BoW/ZSZYH2cY?=
 =?us-ascii?Q?6EdttotzhDCQFlyk5uWgddXRqchA+e6PU4/lb/JBJEJgHOoStwxURksPlR1d?=
 =?us-ascii?Q?Mc/4vtk2hC7KQG92MtBbXeK+5FepBdzjEMptexAs9sBki4mP/Fus63ZE2bBR?=
 =?us-ascii?Q?50U/gzBZWDMnfim2klL4w4PXe+vw/wxrKNznQ0Ve6TqPOI8ZHDHGKarNKHP5?=
 =?us-ascii?Q?C+lbPv8A36CxNTNvoqPU/UuRJOc6fkdiAssgS7JEl1wiXMrrDrguJk695L9t?=
 =?us-ascii?Q?05YxtfqnQU/W1AEHnk4GSffAW7nW95L5UrnCF8nrUfUFMlNg83eK6Y36V+8w?=
 =?us-ascii?Q?EzeIZwiVl/EDLrN/dsOk4fdXT/L0lpfWOLFCJOz9kmMonjr50PjdrIlhwxQm?=
 =?us-ascii?Q?Ji6iiKm6t5r6yxKbcOkSB01TOiq5uDmjIyjtfHzI1ONNwPYg1cfF+uniH+9y?=
 =?us-ascii?Q?wQrn+xZiC11raB6pOWoLlySH5rd1Q9u48duq75mZLkxJ1tgmabqOP5bWN3TI?=
 =?us-ascii?Q?Ao/L8Awf6181LnuqiKMc9FpiFFJquB3hDOyuAugbbLbEvGhH6yzaj0r0YuC0?=
 =?us-ascii?Q?fszu8fSzJFw2EiE8/1BOT1XoJqV1H9gw1by3/kEobI2lXxSZDApicnUOGvzo?=
 =?us-ascii?Q?G+SfYaeoFLbBoed61iloHK4zduC/fz9P3+il6dh1G1fF73dLpYjHFKXX1xiC?=
 =?us-ascii?Q?3Iniiu3JUqEnjzvrMISQBbxttyJwzQQohvamWCBMdbuaIGKNZCSPDJwBujRk?=
 =?us-ascii?Q?0l1dasLFNVo8EVy7elN8S5pExc+0HfIxxT+vppBtNEzH9vlHivH4oCgQdtsu?=
 =?us-ascii?Q?8DCFXuvsWtnXsQKh+xg7FFQevQiBAgOGu0WkyNuNK0InssW4ep1+vFlrJU92?=
 =?us-ascii?Q?9Doj0h/TV0dkJi50fxWyvZeGf9QDk6smaV0ycxdAQtolyZsJuoqZH+qKkJjw?=
 =?us-ascii?Q?MKpFBn4O0XLjBFVkN1V9+48/dNXg/5g565eB5LiksbAIP8lggwPwl7ZECiuv?=
 =?us-ascii?Q?LiLsPzcTciy/G40ikqWUHRD1PjXInId9INiyDW03fyd6Ms235jda9dCEXJgv?=
 =?us-ascii?Q?7nOx8ECgG4626TaL9SR2i/QR?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9f768c-b1ab-48ec-ab6f-08d98ccc67fb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 15:32:59.6988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Mc9Fsk+oncSM6bPlzISUWFYeOsTRmTKAm4IhqEQc1/zLAwsxPYZbQNWCI9rVe5ysrrL6AWFe3GAKydAAwByt3OdnAy1lmXFuaBdvxr3Npg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3900
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
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index c029950a81e2..22bd23de9e3d 100644
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
 
@@ -942,6 +938,10 @@ static int nfp_flower_start(struct nfp_app *app)
 			return err;
 	}
 
+	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
+	if (err)
+		return err;
+
 	return nfp_tunnel_config_start(app);
 }
 
-- 
2.25.1

