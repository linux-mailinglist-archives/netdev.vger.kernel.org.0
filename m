Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1677644068D
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 02:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhJ3A5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 20:57:20 -0400
Received: from mail-cusazon11021025.outbound.protection.outlook.com ([52.101.62.25]:32445
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231685AbhJ3A5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 20:57:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9p4iDPzA86Lvvd7Hy3UFRCsgtYL9ZM/H7/8b5uCghPmGR5Cttx+PZzH5J5B4lR6YYOQQwgI3GOduorQNu9PUyUuzeih/u38EwC/pCM4457Hq4XI4vox/QKvxJZ5VbW4Rn0sHMWHdVPlj5/9j7FAGFh8ZYuLkds11Eor+h/IbvcAqnerc9DsIZjWJgxtZdbTotyviY0a1tsRdG1a9gOPCutj15l5ZD3kdrOpHzHYW+TAl81EPhSdUnWIzF8mAQTATg//ZGcXb4LQ3aC7fwnHm0A3PgRsJNzEhkOE0qvW9yZCSseQNXEoj0p6+ogq5Mboy42jS+pv0QX1lKIUTON8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+enMPXcBAT2/rjRco8lWVaQVZhSs6N8PbzxuoU4WOo=;
 b=g3U4egVLZruCx9q+tsrk/oJZBSEh6Nye7lAstfbkDv0pZRjWQeEQl2KafDG3JF7GKIEhj6doj5vv9V618Bb9dOSuI8ygIHBFsD6UY+rrghSrvPW+R37DhGsOtfDZbE/0MTErTt1qXCM1OzSUgtCXVx4UILQG2F313n9BrpzjoaxJWUW75lZHfVyoRZWf9ykWzrJmlyQBazzeiedWx3Dn0ESp/spfD+YKyg6VtYe12NumlWRLcddZprmQu+8IA9PqZeHxfE0nBviZzRUZLkGEMf2v2Xs9kLQVBjjV2uWtNwQcIegTjETkQ7GC1kHPJWK4ikHxMEfqto05hnVoNjcpbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+enMPXcBAT2/rjRco8lWVaQVZhSs6N8PbzxuoU4WOo=;
 b=fS0E50/c+az/+GGjJ089oiR2dJydepxIqubJrDI9cfoJLZN1BGvRUKW5vdulfcXHk68dE4vESOT69l/HiQXe6ZtYbcjHEhx+2/IrPWKVvnxIawLorjb5NBmBTix8Mm3UnMWdf+4XoQTne50r5lVwgCoupRRLc28JR2/wKvdsRyk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com (2603:10b6:4:a2::17)
 by DM5PR21MB0827.namprd21.prod.outlook.com (2603:10b6:3:a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.6; Sat, 30 Oct 2021 00:54:31 +0000
Received: from DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828]) by DM5PR2101MB1095.namprd21.prod.outlook.com
 ([fe80::c0b9:3e28:af1e:a828%4]) with mapi id 15.20.4649.010; Sat, 30 Oct 2021
 00:54:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org
Cc:     kys@microsoft.com, stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
Date:   Fri, 29 Oct 2021 17:54:06 -0700
Message-Id: <20211030005408.13932-3-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211030005408.13932-1-decui@microsoft.com>
References: <20211030005408.13932-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MWHPR22CA0002.namprd22.prod.outlook.com
 (2603:10b6:300:ef::12) To DM5PR2101MB1095.namprd21.prod.outlook.com
 (2603:10b6:4:a2::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:f:7661:5dff:fe6a:8a2b) by MWHPR22CA0002.namprd22.prod.outlook.com (2603:10b6:300:ef::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Sat, 30 Oct 2021 00:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23fc68f1-35be-441e-dec7-08d99b3fd4f4
X-MS-TrafficTypeDiagnostic: DM5PR21MB0827:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB082739FC8EEBF7AA2B517A1DBF889@DM5PR21MB0827.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6cg1RE6Zrj7J5c/Fn/cIrAVV9n6Y5ouZNZKtf2svuq7iJs5kf4hpeyIRh1e6r90XdfSQeCz8zEhiEgPoSaGpE/FZh2KaC3D0Pl0gQ6ytOMamySMeSh3y3ZGMbqd0qhVFXpj2qHn9KiXtnGfjVCJIFA7JzMbpA7nfZCcuVMMEdSEPmfv2dVc++LOUXWvqJ9BqoBBeOOcIFaTtgMbktFOLuihcJ6+hLwCd9JYd8nRTtdIeXoQOyM5gFjJ7DIrkovm8t5uSehpVKiV22GN7fURFV/Q9VZlBfsjuAZGtmCbb0RGF8dG+9VYt8Ys+UfRiyrsm5TwsSQs3AAsN/YimBxsFWmqYg9+hNbTIZIAvvXCKFNFaBHFT41ESFv+upcWNTBUsfDF8ZB90ssPyhf96HEd9odmaOEPRWVkNeC/Hg7yIFFStv1CE9Ey6ODsmsOOp37KYRr+o6GQjpLwOQcUsbUaL8ZqyKGY9vB5lT6S1WQXJ4sG37CV/FUwRNjOWq2hPFijYY9w+ZdSmC2XqDerlWo1xyIUDUsdl5K3iybmzp2Xjp5BBJqxto8Asc21LhxoBVOiyiWy+IA63cXp2PF9szBYsGrtLeF7EhA53sBHES9YpxCTUVe8Ix2I//8uOrsj7Kg9hErmRNUBlig5XpytaQljIyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB1095.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(7696005)(86362001)(6486002)(1076003)(83380400001)(66556008)(66476007)(4326008)(107886003)(66946007)(8676002)(2616005)(5660300002)(6666004)(10290500003)(38100700002)(82950400001)(82960400001)(7416002)(36756003)(316002)(2906002)(186003)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3xZCLbn1PF0u1E9ZAfd6LXgsjaVOFqIGWjqpwsYxGnrq+KxN0QhWl+TZVjny?=
 =?us-ascii?Q?FpHVyXHRCFhMJ47lBVAoapHEIBdkjx/jFAJ03LI1gNfjD3LkTvg1RpbKUu2f?=
 =?us-ascii?Q?tmoyEsBwIhYL+ygDgS9VTNOVMizS459npb6oaCqehcn7sRkevRsVrxcAzwHx?=
 =?us-ascii?Q?YX8IeXY1NmWKRCPISwv+s9M+5bxuBfKgO4BdxwAjKcpPif8nMs/MJCYEpcea?=
 =?us-ascii?Q?0CJLEI16o25aZwDv0/iXQu+vboq2xEEdYx0NcS2XGpooI/Z/RWuMKspVOGNh?=
 =?us-ascii?Q?mjA91U3uxoeJd7l8xQbXLWyomd9Q1Ed/lU943Go5hX/1XPglxbjUP+XuntFj?=
 =?us-ascii?Q?EuDaQdNvoTEeq3FzdzGuWaPc0drODjFQNKUtEmbZhtw6dP2Qk67XrXDXsxNP?=
 =?us-ascii?Q?Qxac8j54Hqjy7U6lSUPIv/E2VALQoimzVRJkiIEuxwm9zTPbntL7p30K1lKp?=
 =?us-ascii?Q?7J7MfRcM5aRPAfVjpfHIktSURDoUJ6qVu28QYjO3WLFgHxlQP5VvrBGiBY9T?=
 =?us-ascii?Q?WNNjeRBbcrmDKomno7N5F+n2USisQ+7HXAVsFJAAzF8T+JaPcYKOhtyPyVgk?=
 =?us-ascii?Q?2UYe5VvP47X7qt4QoirfIltHogS4uT71q4MI2J7Tp3LHAq3LjcNLsSAmKOFP?=
 =?us-ascii?Q?r6iGwuySrzkBoVJIkCM2dxPlhympIVnedKUS40YTq00b2CJYNHNTaeG/Xp3W?=
 =?us-ascii?Q?5ppCERalkUa9YsvkfznhrQhfJRvIrshI6Nr90lj6NqUg+5ZnYugxTfdHTGUD?=
 =?us-ascii?Q?mtXveGgIqLE83HU2pYVGkEqf4MFbtmReu+s2KT/2pfPCDwtU6dfEd4CUxN3t?=
 =?us-ascii?Q?dM7pQdFVFegBo4ZQxWBJzpTMoFgHY9bQBkJABOFJZy0STWaplg/S4nmgDgb1?=
 =?us-ascii?Q?bApT6X26XM9YBh5hucXeVarF9cTMlKW0Do3opqieZK451BngYBrYwUQ9Rm6d?=
 =?us-ascii?Q?07pQTGZcejJm98ffLXsRcjImx0NIRAsNwhME5fCbNLmg8B+iiMWFz+bEtnh9?=
 =?us-ascii?Q?aSjp1kYy2KRc6QzNaQywwp+ETFbl2PWI9pL8Tn72gb4D45DV24qRzJdMmn6N?=
 =?us-ascii?Q?L/mQFwiVQ5fDJ09Jbmo4csFuL8P0XW8eI/KFU7tLeCNjKPKfAPA0AUj9marG?=
 =?us-ascii?Q?FXjR9DKnOKNdCiAY/WueW1uLlxDK3DGL5JCE1TztgiJuP6hdKCKVEiMcOYTs?=
 =?us-ascii?Q?/bbluVCEyD3gkA2HlwvZTw5tKwrqhn+TDH9e4wN3dZisVPVutd6qxx7AlR/t?=
 =?us-ascii?Q?SsRLjHU2Fc7NJ42y77lKuQM0A/wPM1o7CM95a1bxEpCRuJTy5er3xrSKNbRv?=
 =?us-ascii?Q?br5uh8JrKRWpnLc/gHer2e4BD3xYpNBcevgo7JJj+XGa3JQibLTbu5PefX3m?=
 =?us-ascii?Q?tnNcjHuhyEbbrbFdz1uxEZA4iQQw9aFnGgva8gvZ1X3Zd3Wo+5h+yS1LHX9H?=
 =?us-ascii?Q?50vr1Nb2quJyWM98DFLK8I+S3u6jcVKSHFw6miMCkC608NYyF1+uRgHK/lSP?=
 =?us-ascii?Q?jA8Mtbhacf9mqrFhGTgVDNJ1z7mZA76Bfeic2qrEuIOTC4YbsqNhpo07A4Qf?=
 =?us-ascii?Q?LlB9jeY+0+DA+yYSM+P5GDa6n99G6o26vKTWFqvVKzCsgx3GPlzh/JEB3Z2W?=
 =?us-ascii?Q?I81EbENo0o2rBYx92IVSNlNKtzjJAIYfVXP79eOydDwuqJlPaCEeRfoycs8w?=
 =?us-ascii?Q?sMc4gzN0KLP5/+kDw09sxTa0Gns=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23fc68f1-35be-441e-dec7-08d99b3fd4f4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB1095.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2021 00:54:30.8617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ec5hqzbHelu9fEwsezqawgTy4yP0E2FsZxsQ1Cz17CBJTPgpNIZWNwisO8luhZuPcoFIJvkVzwjAUHe3ASkJfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0827
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PF driver might use the OS info for statistical purposes.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index cee75b561f59..8a9ee2885f8c 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -3,6 +3,8 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/utsname.h>
+#include <linux/version.h>
 
 #include "mana.h"
 
@@ -848,6 +850,15 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	req.gd_drv_cap_flags3 = GDMA_DRV_CAP_FLAGS3;
 	req.gd_drv_cap_flags4 = GDMA_DRV_CAP_FLAGS4;
 
+	req.drv_ver = 0;	/* Unused*/
+	req.os_type = 0x10;	/* Linux */
+	req.os_ver_major = LINUX_VERSION_MAJOR;
+	req.os_ver_minor = LINUX_VERSION_PATCHLEVEL;
+	req.os_ver_build = LINUX_VERSION_SUBLEVEL;
+	strscpy(req.os_ver_str1, utsname()->sysname, sizeof(req.os_ver_str1));
+	strscpy(req.os_ver_str2, utsname()->release, sizeof(req.os_ver_str2));
+	strscpy(req.os_ver_str3, utsname()->version, sizeof(req.os_ver_str3));
+
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err || resp.hdr.status) {
 		dev_err(gc->dev, "VfVerifyVersionOutput: %d, status=0x%x\n",
-- 
2.17.1

