Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6B624E081
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgHUTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:15:01 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:30460
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726243AbgHUTO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 15:14:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMom90rqDZvqjndqqihp0qCpronrfU3w1ru+C+4sKL5enRhktzh92fZHpN9daYPX+kVbO6Cg/HmsVabR/PhX5qjWiXbbHZLpdd3ju75PdhsiMSddlVrVO3o68F2TzYHYQir7cQWnO+rXIQsF6hxV2+rnyCzPEEKSnbrwHdOqUtntnQcslbVmzHbOMGJXq1dVlU3bOUB/beCuMK8jF5F2It575ZRr32MQA3rqp9lgaISe/tkVcq4zv8PGaxReA2Z2ywGdHG1a0eORl/FBznosZzhSq/A9wEff9xLYyveWbBBmQssACyqrOn2s+LGBvy8uuxYKNgPanBpOSdTFb9Pszg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0pEsxcKlIzan7zTpYEJdxuzUJNNMRfaDvUNPLCTr8Q=;
 b=WjAyOqwnPyrm0JrYMxfe24gokHYancBKP+J3IiSfIkh2SBxP88HMcnDUgiep2Bn5wxzo0qMr37buOtVffSStjGqVDsVRjVpyPXaGVQUeIZJLQrqVYR/ggPbWQxK5+GcvhiFTPsiuOqc5nHr3lEGNb7z2gBH3XfKt2r2XH/LmmXJsRicYSh5jQJCCq5ug8jFI9Py4I6Z/BtRjs5wcAzT/S2PiZN1+IF8mJj5FUstPnwoT8jg7HVDtDN2aKC23KYiQNH8bBZm40EKduVrfq/SQSVHxNPqsbw8ffS814tHD7vKB81+TOnmKITCtBf4JJrCLTAKixQT9NWhGh29lzgaOYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0pEsxcKlIzan7zTpYEJdxuzUJNNMRfaDvUNPLCTr8Q=;
 b=hCyIZfHCZYYUyOWLwSmElKpmp6TIQMDqffDooVJ2fi7RTd59oIn9wPMOps9idEcQbtV1LXM6UMQN+YIItRBgmry2vPE+4KFiyt+BOIrrF1PZryQEWnCSpWtDMgFDrXUVbbuirM0MHR/zs2QaAucVzCHOM7DMgTaaann+47Krlk8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM4PR05MB3348.eurprd05.prod.outlook.com (2603:10a6:205:5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 19:14:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::7991:155c:8dee:5dd9%6]) with mapi id 15.20.3283.022; Fri, 21 Aug 2020
 19:14:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/2] devlink: Fix per port reporter fields initialization
Date:   Fri, 21 Aug 2020 22:12:20 +0300
Message-Id: <20200821191221.82522-2-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821191221.82522-1-parav@mellanox.com>
References: <20200821191221.82522-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19)
 To AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by DM5PR10CA0009.namprd10.prod.outlook.com (2603:10b6:4:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 19:14:51 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 39a7fd39-c285-4e96-e590-08d846067b41
X-MS-TrafficTypeDiagnostic: AM4PR05MB3348:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM4PR05MB3348E087DF61AD33641BDFAFD15B0@AM4PR05MB3348.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lN9d+fVecogMbNLeTch7T3uFuJfHS39KMEYgF5lrXuVmMAbdrt41L7/WjJKzN/iGWlaNwB/FiY/cBx15L/e074wpc8LmWtyVXxOxRx5ikAyWjTglmMbGjkhq4/WhXSFKPgiWkr8Ace0U2GGfXJgPdUGryi2S0kX2ZA9pKE65hvkzo24zvCNtRJZzcBAtUwfCLKGzTKgE/kZJVOqurDfgGOkXcIDSOMqdr5M8ohp0GpV4itT6irQaQEKLS8gp31TuTxoZQ/SGLi3Haqfve2DMgzcx2kSEqf3GGJPbPja8/61E+tO8W0TYL1z3ag5mnJUNygwCROzoAUwoveCNeNaBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(5660300002)(2616005)(316002)(1076003)(36756003)(8676002)(956004)(54906003)(6666004)(8936002)(508600001)(66476007)(52116002)(86362001)(6506007)(66946007)(16526019)(6486002)(66556008)(83380400001)(6512007)(186003)(26005)(4326008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: sZ+1AgRHfxdWyGo8it3mwRDqscPbz1APO4IRo3ZGs3o/5kSAnhoRDv6sOyxXE9oJtGzkbrdGP4E8UWQ/KkF9cThpIFqnhOQGd/uz/dt7LPkLdtpsFhUs3WJjPCQ1ZgsprKT4d+n6Ox+u5zCWz6oFPFxydfDb+C5Q38n8ZajoqO15cs3odZHYHtAwmdK/x1bROET0q7bXZAqVOTppnLdI7m1R1+79pAEV2G110hE0OuvXJIQjhBx1KR0a8l4elvzE9YTM029+zzC0IrlM+rCQIA3F+G/wK8kYkABOIjzCbD0m+vRzzVH5z5lcpPBg6xyXZ1AUUp1OU+r9UV7+mvqWEv0MBOXW5W9WsjbgoAQQ0GoOW8z8X/pnOZwDE77zS45BDIhUzxWBCgcoEowpLEpU6ch4tdfUqQMz1gEybU+NIiYI5Kc9Ji2AwNjrI/bT79oZb6kPV3lspGGWCmZDkmknkxeiTWS5YcfvyyLN4HdKy2NBmyxrYulHl++cwqipKdVHS9Gp/dnID/IB10BV5zk1m0egV3AWwO8BZEBpG2hRsu4j/U4Meyv+1zSjivgwUVEUOhXIPWqei51K0EmkT9i68hhCn/XGjdykjnjnsMiE/xVEDSp8yiqc3i+q6ulb3YAxDTrWyVKTULt6J9MGh2I/aQ==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a7fd39-c285-4e96-e590-08d846067b41
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 19:14:52.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Vn2j9e+SWa7G+SSydDX2GrW7h7MAB2U2s6I4jY2n4H6znLeS2TOpuOrBQSHGtkWyxOoXbNiztspzp8LpfSQvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3348
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Cited patch in fixes tag initializes reporters_list and reporters_lock
of a devlink port after devlink port is added to the list. Once port
is added to the list, devlink_nl_cmd_health_reporter_get_dumpit()
can access the uninitialized mutex and reporters list head.
Fix it by initializing port reporters field before adding port to the
list.

Fixes: f4f541660121 ("devlink: Implement devlink health reporters on per-port basis")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e5feb87beca7..9b01f7245fd8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7555,11 +7555,11 @@ int devlink_port_register(struct devlink *devlink,
 	devlink_port->index = port_index;
 	devlink_port->registered = true;
 	spin_lock_init(&devlink_port->type_lock);
+	INIT_LIST_HEAD(&devlink_port->reporter_list);
+	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	mutex_unlock(&devlink->lock);
-	INIT_LIST_HEAD(&devlink_port->reporter_list);
-	mutex_init(&devlink_port->reporters_lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
@@ -7576,13 +7576,13 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 {
 	struct devlink *devlink = devlink_port->devlink;
 
-	WARN_ON(!list_empty(&devlink_port->reporter_list));
-	mutex_destroy(&devlink_port->reporters_lock);
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
 	mutex_lock(&devlink->lock);
 	list_del(&devlink_port->list);
 	mutex_unlock(&devlink->lock);
+	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	mutex_destroy(&devlink_port->reporters_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
 
-- 
2.26.2

