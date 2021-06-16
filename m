Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD23AA33E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 20:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhFPSg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 14:36:26 -0400
Received: from mail-eopbgr30120.outbound.protection.outlook.com ([40.107.3.120]:54736
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230410AbhFPSgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 14:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTKpbt61i1dNYi0TddKnZRJVLSuiWdotYjqH30f5sJLuEYPvN/T1lEDeqU9SOUkBjnf0zBWOO5uZK5ui+rjNMryW75v1Pg5urdxKkjcUzq1X4U1vDX4YWyzD+Bd5tBRDNwxjOx50ezR1FLp3M5RKCrswFmAAzeQGxriCXhOOZ7uoUh1rWzjDbil5VvLwwanl9zwCeVLaFBydAVXQBTRM9RwYvZOYWeans7q8qPTAr6rqh8zsCJdx5EqRJKtY/O6pxSMsgFVS0uB18mdNoBCNcghinFaaiyUTaaxPY94OTSh6aboyOj7PJTpmbKgnjz5WsbdT2EAM/Py8hpWMoTomcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAr1gQIRHSKGN1j37YNkwSM2dSZiXvOWfcZ7tv/LI8o=;
 b=CUgYEMpyTIguwLXgQaeTfdoGnlKU0Pljj+kYshHhoF0blzewKNrXHuVeWqNE+m2/Se+pbwIYF7U+F59gfdNkXt0zpnZSsn1hAwdTC7l0ZExGw6VfduO8klx76JZ97MqW/Ly0NlPXSvLcoQE2kl0oq3H85uyKOtFRLQ9xdnGMzoioyaSGUqVTTXdF4ibrBR/9SSiR+b8hl5WqXfwuRcxn3UA9HP8Vw1BWVPtlS6MJNefT9r7rVxisUikJn+7pX0rUkjqMrZ53uXR+xrMvnaJgfNCr93iWElhdlHkyjmrA3AIHZJAcebzwCqYo9b77AbMXaM8OQfdVkvVFIzbqA+xsdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAr1gQIRHSKGN1j37YNkwSM2dSZiXvOWfcZ7tv/LI8o=;
 b=gDx0yhardlRQz57iUXSf3V3Ql3dhuQMho87qxZWidF0tFXgBIXcLMe/ulGt9FbicDzO0Dee9sT+prsNAB7hjIFDJmzBcyE8//gKT4op1anSCpML8UJbeIVPGGHdBN5ADcFuVx6XwUDKMB0sr0trJ+IvFoHcAgRHEF1z8SuLiQS8=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0708.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:198::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 18:34:14 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 18:34:14 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, idosch@idosch.org
Subject: [PATCH net-next] drivers: net: netdevsim: fix devlink_trap selftests failing
Date:   Wed, 16 Jun 2021 21:34:05 +0300
Message-Id: <20210616183405.3715-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6PR10CA0073.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::14) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6PR10CA0073.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 18:34:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48f5ea20-7713-4306-2c4c-08d930f55751
X-MS-TrafficTypeDiagnostic: AM0P190MB0708:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0P190MB07083F1578914BF2A0EABD25E40F9@AM0P190MB0708.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQUTGS1smcJKa6/qK5I3it2qt9tX/nY2iooxhBqqVSltA1EhQ7Wr8UXpnGWChcUCJDMbgZ39C5o9C/Bg3saO5tFrzXV74bVNHjnMg1wUomG21boLpuRmJ0+8aUkRoBEalrp7+DsdvgmulfyndCnt3z/YpdQ1Uz85TKTCxJiPKuyqZ+dxYWeoKDoaEdwxHyscKyVmHTpTxDUf9yP1JbLC+/EBxV0Q7R9DjJ19RXNlr3x5ojAHRCg6Onmgi7uO9/NvcpYwBB/Fyr8+50IFK1ASAoymACuBkOlLQRsUDoRqxMuoRkK4PGoqo4Rl1lUlROkSIbSDNqQUQEmb67WTMP8SZO07v8pB9UMzt6DjrvtolpzkWxHg/Qx8sUib1Z3TXJrHfnSK7bpLKvZmVR9LQzXpO9I6P7uS4kTj5r8VSyMXSquvpXoZFFbWThamMHZZvQSp0blg9OiNQX8NTkou6sd6BYAHl3cPntkFBGCJIaMnhWHJUjT8/PdhewH0zzVVAEjst/6UlnQjXCVkbJJ3wSGGCQDJio7Tcs5ORE1PQWHfzL16Mc8OCtbAdvpd5mMNqLW7lD7vPsGlT0kBC62HOKcUB/ob03RF/cD7F482ZRznjrTzAeE7zXeVDD1rw3lUeT6dLkQswCvfSloWJbYbBrck58gm7/nUFTWAEBCZFqySfKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(346002)(376002)(366004)(396003)(8676002)(8936002)(86362001)(316002)(38350700002)(83380400001)(36756003)(38100700002)(16526019)(186003)(26005)(52116002)(6506007)(1076003)(6666004)(44832011)(4326008)(66946007)(2616005)(478600001)(2906002)(956004)(6512007)(66556008)(6486002)(5660300002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MAy6yCRJfUl3QMV8SVKjs8S5pOyseh/oOwdHegtmMnDpnu4h8y7ue7ybruP7?=
 =?us-ascii?Q?r5gzyLvsrmyiOHJlVHQquSLqhsrr85BFbaRATmkfWIymTATNWy4EicNxWbHw?=
 =?us-ascii?Q?Gpjavv3bgtz2/xbvEWmE+2Fg9idWr0DsK+YlYt559q6a1GTmf7bClGQXHI7t?=
 =?us-ascii?Q?oHf8bVrXQNvnTwTEFVg+OmwrMGZpjxfGm5JdzAwLajk0crO0byta7F3uOK/S?=
 =?us-ascii?Q?w6G6PV0yheNSXM6IvqozD6igwmNBX513wmKU9Muy0IppR6FhKkYsaTBLYq0s?=
 =?us-ascii?Q?WtE860Si6RlnZOhssMxCGYHcNTIFKTL82QJ1LPkmGUjpZdOxMkrD638LHaCb?=
 =?us-ascii?Q?qt1aBvzfWdT8Pav6ArJ8QDuqu5xnfiZ8FEjhNoD6spt7tv55m2R6xg5WVu4x?=
 =?us-ascii?Q?+5zo6Pfv9zNp01nmMzjnRs2G70D/ebFWWXaxg6TZvctWGrZaX7de7Tgyia+S?=
 =?us-ascii?Q?B9jqx4j05VjKdDlQ3yakRTIh5UoqQjRdT7U7gjAbOIC+ESvBHmcqNf+wbKde?=
 =?us-ascii?Q?Mg1cPq3zgY7+HgJYOYZR5kBFNyQBntDR2k4eJTeXiGWEx5mZgnhU7jzbgT3T?=
 =?us-ascii?Q?3umAPc0cdY3QLioifwFuaLJHhvtmynn02iGfKiw0MvPdPT0Usb7Ad4/H9+lh?=
 =?us-ascii?Q?GTDTePDghwWMsjKNcpYxC+x43uI6M+FWlKxotK1x37AKYdkBddIc8jjvY1jm?=
 =?us-ascii?Q?zfJceKCSYo3FCCaHlDHnvajTU4VVtQTu2Lj2WFbZulJwCsATVEigetD0nRCV?=
 =?us-ascii?Q?X8f7sUlfSMjbz4Ls9TanDCJ5955tv80uVODOqoTYc5NprKqol+nR+WbXB15U?=
 =?us-ascii?Q?vMeY65GihtNVJLCGEtd6EYzj/swBGc9Yk9nqPDElu25Qe2bDxpETyF+jTYkI?=
 =?us-ascii?Q?6FczJbB4T21tmRhZS6z42vd/ZoPU7K+WOxZh7cMksNH7FnqPvaVBHH6HctKD?=
 =?us-ascii?Q?GHtTVEv3XNBMQZ9CkqFRq8LpQBRU9q5/+ouF8f5+e2C/sHNqT09kUL67mFKD?=
 =?us-ascii?Q?jfrpXhzfWAdyv/KxTAtv1wnposnGZe8aH+RPIUhQj3rZTYc+lCJVBJALJwk7?=
 =?us-ascii?Q?0r05XYd+V74uHbdGbQhTMgnjK084+S6nyoxZ9drMcS2McqUnnr6+vktIoNW+?=
 =?us-ascii?Q?FILWvlHknh49tDa3ovq/Gz9ohBhDooOIgRcM0OoCUmRdkt+A1Ms6pmaNGspr?=
 =?us-ascii?Q?GnGBrgwiZis2mjX1uRVUJD5cZavKdK1dHP/KRVA2MdgpsgP6EoLVs4yY7D5L?=
 =?us-ascii?Q?nt7Hp/1+8X6GJ1Tov3RhXUfDoZwxFbWQCG20tk8nW20KyFCVa7d+04jf5A+/?=
 =?us-ascii?Q?SBJ0dtBVOJFZhYLZsB7s+tu0?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f5ea20-7713-4306-2c4c-08d930f55751
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 18:34:14.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Mgm237Z9azi0LMLlFTq/QZq5bSydau/R92LZKR11chYxWH5MniwmdnNqXfsbeMeeNCvVoeuREqOuSHOEaOxnt8QzfyF7Z6EmZvcY1uNUY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0708
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: a7b3527a43fe ("drivers: net: netdevsim: add devlink trap_drop_counter_get implementation")

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
Test-results:
selftests: drivers/net/netdevsim: devlink_trap.sh
TEST: Initialization                                                [ OK ]
TEST: Trap action                                                   [ OK ]
TEST: Trap metadata                                                 [ OK ]
TEST: Non-existing trap                                             [ OK ]
TEST: Non-existing trap action                                      [ OK ]
TEST: Trap statistics                                               [ OK ]
TEST: Trap group action                                             [ OK ]
TEST: Non-existing trap group                                       [ OK ]
TEST: Trap group statistics                                         [ OK ]
TEST: Trap policer                                                  [ OK ]
TEST: Trap policer binding                                          [ OK ]
TEST: Port delete                                                   [ OK ]
TEST: Device delete                                                 [ OK ]
---
 drivers/net/netdevsim/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d85521989753..aad5e3d4a2b6 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -269,7 +269,7 @@ static int nsim_dev_debugfs_init(struct nsim_dev *nsim_dev)
 		err = PTR_ERR(nsim_dev->nodes_ddir);
 		goto err_out;
 	}
-	debugfs_create_bool("fail_trap_counter_get", 0600,
+	debugfs_create_bool("fail_trap_drop_counter_get", 0600,
 			    nsim_dev->ddir,
 			    &nsim_dev->fail_trap_counter_get);
 	nsim_udp_tunnels_debugfs_create(nsim_dev);
-- 
2.17.1

