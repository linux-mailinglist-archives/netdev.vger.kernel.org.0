Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFC86743F1
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjASVHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjASVG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:06:58 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380D3868E;
        Thu, 19 Jan 2023 12:59:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnueqxbS5Q5T8pY3mCjAV8IAwxNsGl/m0qTNNYstLj4LWPxCgQBL6eLDfAgTH00xLiYklUD3pV2+5UKkXgoDDojyTa43nY0I/2ooEm2Dvf7/GAZe8uYGNeH5lW1VNJy72Ika9F+b+9sdlS0pzPw9fqUwFnlXkE4aDhnBvYRUlK11Gw5oMgZN7h7LQzWWu68P9/PYQXufYNjnAYcSRvMuGpc6TY16+9us2aaFKISunUsM52JuiAvE/Duu2d4GXD3SZ/26Xqvk3IZU6UOck66DVb0JaltE17fixfLXwDn5/ZEF1qNbw/oHfgMHtF7RfQkNuM1BlGU7RSGiSi8wYBvrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0hmIld8UeCOf6LBE44w5WhBdu1eAGsIlSoxkXwMVnR0=;
 b=VFctQAahAcnMb9ZParFqaFuD7fPWyShLd3SWx5wwnPWRaISL8Jp9eBn2osItXr82CP+Be7j6v8idrt8hBR6sHJpG1Uw/QYvog61MBnEePD2f60TBpqFPiuSLlqWpXQOql00V5t8Rh4R8p7ka0J0fdWxXq8mtZNiBeS0f7sykE4sgTha7ZJCIiCx7cy32fU8H1VhdIhfFQKhqjcejOWgzt5bQFL1iMZMrtnKuoSrTY+eGRS13hfr6Nr45lifnd+YxD3fE+eTMojrDzM6fwZVEXgPf6lviqi2VxsWxbluu8NyokuITQcprTQgXgDhdKrUql8aBPaFIZhmYvyn3wUcTVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hmIld8UeCOf6LBE44w5WhBdu1eAGsIlSoxkXwMVnR0=;
 b=btMyLlLykbbV4muONDaEJostQmxcGi1Nc4+U2LdvwwnNzGwZKpDEVRMqk94+nrz9ISyXzYUjRalcUYOZe7s3T8gfoI1exCIevVPcfVGtRgrb+qIqOnQgqwDES+kI+dXdS1yVd2ww4v5mQ15qG/pCmR+cmouuA5ph0yVH58ULGo4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by SN7PR21MB3936.namprd21.prod.outlook.com (2603:10b6:806:2e8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Thu, 19 Jan
 2023 20:59:47 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::baef:f69f:53c2:befc%8]) with mapi id 15.20.6043.006; Thu, 19 Jan 2023
 20:59:47 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH net] net: mana: Fix IRQ name - add PCI and queue number
Date:   Thu, 19 Jan 2023 12:59:10 -0800
Message-Id: <1674161950-19708-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::10) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|SN7PR21MB3936:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a72297f-e3af-4d3d-7d42-08dafa6018bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOu5k5Lx59X8924/GlrBNlSIj8ci1g8Fc89UW5W7V3+nCYPazw0w0FH+YGrTpZLtRCjT5O4nOg0asC/Y6uQkN2mLQGV+cSBSe2H2hHoB19W6X7T1vJfHiQo9trwKMDbTTZ/Xchgqst0+STFYhBWp31+/B/jbV7bgqXkXk++n9O3agUtTSLCd9vOYw3YEE9YNzhXzV+lNpMYau1arjqVakmhHZ8UZPlP13BPOlVm29mXq9JcyhdTKWxFi5rgGm5+bsmceeIVsg5+vuHvXNGH96tp4VcJ5HjUG69bGuCvlP//QxrpKPJDGhw8jDPFcChogcZDGW7seU8pxH5k5wWSuMwcw6mS2Rvi0xDNUDEoEV98jZ7In3KmW/cO6jmgcazWICRtIDeIRTr5jdbEdvkeom6myMVH+VbjWiBbnShqnRwd5QiAWqotwEWBaEFU2FpIc0MYDOsBOl9s3/vmrtVSL+cawIlQAg9E6eyHGIJ9Rh3gANpm/AbpLskVCBbeJwEY8wC50VWr6z4jOA/QS6pRWXb+lz4E4EJ/4t3SiZ2DgrnN8n6wxmFRRVLyyePrgekpzIyGLypajgwDvtpszysKa+uRrM2onSJVNC+VeyPQZpdVecczv/445mZMJuvaWm6pBcYnzX2cy2p1Oyk76oLNFAzyc7XTEHEhcW3HVITp7Id1rIXAMUpGoAqBxvq3We/IuqUKtO2rxqzaHNoEfs/0peKDhwZwd7llEfoNSwqYTiCPRP55MCqohnqjQYOF5Rxca
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(38350700002)(8936002)(41300700001)(8676002)(4326008)(66946007)(66556008)(66476007)(36756003)(10290500003)(83380400001)(38100700002)(82950400001)(316002)(2616005)(82960400001)(6666004)(2906002)(6506007)(5660300002)(52116002)(186003)(6512007)(26005)(478600001)(6486002)(7846003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Q6GGDuFBA2MWZzkHxu6Ci0ic1/nDjBa7+CgYfHxbgAtlzdbLj26BpkMT1x5?=
 =?us-ascii?Q?rIRQf4zLhlhI7MJjAR1I2nvHj61O/efUyHsTYbXa+jqeu0M74Kd6SvnjIXCD?=
 =?us-ascii?Q?uJKAe9xzmwMOtpJcAYt2cnsArJoewKXE/MK+p9Zp9/dgjP7JAcGxmKjk/hGU?=
 =?us-ascii?Q?97pjd5Rb4vgllWzS+4GUwuMHiK9ISOiZW+N6hP5Wiz+GHVRKukQi0p4vI4mt?=
 =?us-ascii?Q?RVYcMJyzf0zUBcQ8VFPl//9paNwnSM7nBVBczSRvmwWGHX8j8q65MIhApdx8?=
 =?us-ascii?Q?eMo0ORSQx0SLc5vZ9kiC7EVs6YIJ4Se5hma8s4VDByJqixaEuB2nxp/9Ij9O?=
 =?us-ascii?Q?J8bWeUWKvcEbx6U3lo3UFmfucpWzIAn3KPp4p/kc6ACpfpdQ14e2+vJ4bxXu?=
 =?us-ascii?Q?0bOwUvFTlaUAHX6dJCWUtEkHw/1/qqnn6qeGCHiChDGCfjZ4Tqx0BzfSL5c3?=
 =?us-ascii?Q?+5yAMkTtyQ8+22tcKBDugsw2JOSD8sAFEMSioRbX7x4V93XHPFfrqP5rEVlp?=
 =?us-ascii?Q?c+zai5gbOBltCs7WDur0+NIDvg+mhBbr+YAPdFa3quw9IORau2S6QMY9e/q2?=
 =?us-ascii?Q?0aHzG50UDSC/1mS+LW9iEH5mmgxRthEKbvyuGF7yZPGFTbkTTKBkLcibl3ZJ?=
 =?us-ascii?Q?PSDDegAKInvZFmjgp7RufsmdadS0io40Qr4yXtVOhYC4GjlotvVZye6cYoNK?=
 =?us-ascii?Q?eux8/NRH5vV22ezUAOngdbOiQBnDNBOQZLZhT72YLjkrOUVBbIiswaK7aRFk?=
 =?us-ascii?Q?IZl1eBSK70NKeXUoCKoU8Rbz113aFhNm4kBc8nITa/u4e74jPpcg60RF4+9M?=
 =?us-ascii?Q?8CNN1kcYg1kK//uMVdWdPqShIfNNBl0B72PkpW4VZNCzcaVWgenIBa+Ey/qL?=
 =?us-ascii?Q?C/k0y0FQZd08Fwoz7RLr2W+2HhBZn2w6LGvIbSbgnEau6JG9TBs5tOKQSRct?=
 =?us-ascii?Q?H2gVsujY3pV+Pm77/VFDQbdjyXhfQmB9nvliQT5TfJ2hPNUah8EP9ZrtIXMc?=
 =?us-ascii?Q?tnBHf52+YaRJ5kfMRIVpUXdhwMYFBowQ4oMWvk5wb9k9ixbZGNMGWVhLgLrI?=
 =?us-ascii?Q?i866Ex5+HTvomS3QMo24y5q/amG+KHV4+quZTdXu689cK0s3qQVNqbYD/aLq?=
 =?us-ascii?Q?XfXg5bsOBkASo1EC22XULFEs6yOW6RK3j4g2wp6oBFf2DcfO5ZvnL5aS7SKB?=
 =?us-ascii?Q?HSg11+LUGvlDzlTVEQ4EwVcKAOTHEM4YDj0t7T3K9b3HeDHfaVbP19uGAG5O?=
 =?us-ascii?Q?IeXrTcuEtN611Qm3ttCyD34WxFV7nUxUBXAT5f/Wf+sZ4TQ9Ce7NgTZ+JG1a?=
 =?us-ascii?Q?IdtSETvnRgzd3pnT/pyqM7YJ73sj4zVjZJv4gYWdZ6F2kvdapoVwxfmipvka?=
 =?us-ascii?Q?qeGkV+ygTTh/M4NJGd4CWUD6Ilm+bFH4gAJkt21YnjKabbJaTNXy1yoCxlZ1?=
 =?us-ascii?Q?h88g2Kk2TidBx6u5T45kqtW3O0glZnO9gMOkA7L/lHtt+oU6hMKvqgKlZMsy?=
 =?us-ascii?Q?WmaJBpWbeDuUnjOytsgX/5Zzb+d8IqNfewe27ewmmD9Kxteff1OX28XVKZDA?=
 =?us-ascii?Q?O5pu3c1A3Hj1chAbHYh0MqJpkqvEsAMBc31AoAO3?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a72297f-e3af-4d3d-7d42-08dafa6018bf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 20:59:46.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s6xSlKPcR38c9RjWHZ/GyBfVX40HFrqbWfP0IjEcciE0frJTh97BCYwiDZKpNFy2oUr35feICXwj3/f/2Kct2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR21MB3936
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PCI and queue number info is missing in IRQ names.

Add PCI and queue number to IRQ names, to allow CPU affinity
tuning scripts to work.

Cc: stable@vger.kernel.org
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 9 ++++++++-
 include/net/mana/gdma.h                         | 3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index e708c2d04983..b144f2237748 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -1259,13 +1259,20 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 		gic->handler = NULL;
 		gic->arg = NULL;
 
+		if (!i)
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_hwc@pci:%s",
+				 pci_name(pdev));
+		else
+			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_q%d@pci:%s",
+				 i - 1, pci_name(pdev));
+
 		irq = pci_irq_vector(pdev, i);
 		if (irq < 0) {
 			err = irq;
 			goto free_mask;
 		}
 
-		err = request_irq(irq, mana_gd_intr, 0, "mana_intr", gic);
+		err = request_irq(irq, mana_gd_intr, 0, gic->name, gic);
 		if (err)
 			goto free_mask;
 		irq_set_affinity_and_hint(irq, req_mask);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index b3ba04615caa..56189e4252da 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -336,9 +336,12 @@ struct gdma_queue_spec {
 	};
 };
 
+#define MANA_IRQ_NAME_SZ 32
+
 struct gdma_irq_context {
 	void (*handler)(void *arg);
 	void *arg;
+	char name[MANA_IRQ_NAME_SZ];
 };
 
 struct gdma_context {
-- 
2.25.1

