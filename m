Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB905BE9DE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiITPPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiITPPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:15:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2125.outbound.protection.outlook.com [40.107.100.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E39E0F3
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:15:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NXgsm7UCW48dyOtVugvdf61gAwGvoN6ycWhr0L0yn2NfVvQ2KSGEnQbzXMiM+QmuZ2m7qQEYu9NL2Cx6qxa9pUnl9HVl1itbxFlxcZPNszzSF2uZBmMSgW5DJJV0t+04EZbKcEM9N8TI22dbluSFOonjg3cYdv/nEPCzkzXq7FHgo/5dfaBs9ZCsogxQKtskauAdXMfSM77lg1zhh9IGOlOo81GvYLI3hMLeUMsGTrInCH6FyArKyXGJWSxvgQZmBTKNGFeVPdA5418GrGkf9DOntHK0AwAU0ebzHC+WmiCzQDEs81yfeYr2dt+d5x0WnG6OqnS2jntHg6xvkwUTKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qc4x+yyEmslotEWH6jYRMDHTUS77ETsr2Zdk/4BQSWU=;
 b=a8uZhWewexkr1yNTCtJ3v+LjgLc197rWthuQUjQZN1g/AUwbQnoXGjjL8UkXsdIY/dpzkLO9DEovMl6SSzSA5Z4ceArqWUvh1xN4N0furF1FSvWsSM1xU0lrB5YRFZBpw5nuKkbWXmmMEQ8JQvUO3jrWXORKVaMd+mIOYdzxteSivaVkR9M1yWTrrGJCLEvxDECWXEhFggVm2Rwx0HvugKUDgsycD6DCufDc/HCrIupEHJLJHJ7ond1g/9uK797eEHOxSleTJac+AGCD605t1uEhHenRX6du6vqyPpA8Ka2KHLQ3gzKs34g+XqYzO3AvyARIhRrkaBum7IsI3CmJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qc4x+yyEmslotEWH6jYRMDHTUS77ETsr2Zdk/4BQSWU=;
 b=mxZFsH/I2TDu+bHxmTdMhZmLdC96D8S/aJeQiQP81KQ9rOC760VzKzXu4pblhZy8tdHbjErm7STgu22XyA+7ETOQTDYCenn8k42wwQxI24cF14UY2j6jlvALyoPWBjLdstZOHVV7mLFzssPnEkuR3seEqawup+FYn+GpdUuq1As=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5301.namprd13.prod.outlook.com (2603:10b6:a03:3d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 15:15:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%4]) with mapi id 15.20.5654.014; Tue, 20 Sep 2022
 15:15:23 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>
Subject: [PATCH/RFC net-next 1/3] nfp: support VF multi-queues configuration
Date:   Tue, 20 Sep 2022 16:14:17 +0100
Message-Id: <20220920151419.76050-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220920151419.76050-1-simon.horman@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0064.eurprd07.prod.outlook.com
 (2603:10a6:207:4::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5301:EE_
X-MS-Office365-Filtering-Correlation-Id: fe33f3fd-36a3-4c41-01f4-08da9b1af05d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UVrJyOmGXSQ5JvoM1DVJWODNm1oksX/nsgyZZmG48efipxb4YZE/fkeylMCtyKY8TUDbHFq7t/eB7vdsdfrBR7rP1MxMc6T7inDM+V3jn8/fqVGrndImnsOn8LgdFglNN+XKuQBwthsRKrnhNyP+QbZEnxwz8bAYjk135QsvmbOGlZwoiccwiZMBo371vXpIKMj5uvkZ6oYMN/oRiVQWK4X6uxo/g3biUP5HRENrcWDyOLEV+Y6uXwiwGrL6dLkUigNpKmBXeLaZxH7i8iAcH8BsasSF0pljdbbYVQBjy2x04N6iN86IPPIigEbSf1hbD9BoDvHXObiyDU++FdpSk9N6oAbje77T70RPzk2psXffpuCjStCDo8u2YACJsBqPyrStr3ZpXmv9s0hCe7Au8IrkF/hMUYDqpi4qlji5gSOpk2zohNVLDR9CZ+fCrEw7WiKKnbFH2Nj3gwyASCnAYTmTJlGNvjw3HjJkDCUZeeunq7KTTQ8MzbF+OIIXk86ZEKqHx6sQPbXvStPiYT4RlTNWh9axX3LurlhdNVW2kjK+YCRQjYiRW8+0FlCDKOrd7PqFdzfFNqbj8xgM6WrJhEYt/oJJwkmVQIobGpCwTsCvCeJKcs7slH962HB+BP3Ot9eSIY7ol+26ropwP+REPUZBkZ8MlRE/GpLrR3E2NhswlqxPx2+F+a76aho0JWdOp2Y/UjpA9oVC5E/V8VU1fQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39840400004)(346002)(136003)(376002)(451199015)(6486002)(478600001)(186003)(1076003)(2616005)(6506007)(6512007)(6666004)(107886003)(52116002)(2906002)(44832011)(8936002)(36756003)(5660300002)(110136005)(54906003)(316002)(4326008)(8676002)(41300700001)(86362001)(66476007)(66556008)(66946007)(83380400001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YmQ5f0ZVdDq5uQKpZPV6Ota2fuPUaX2s0xs8sIX3gyUid1L6DJR5AijeFNgv?=
 =?us-ascii?Q?+H2YY3x07bPiCM28hb+hXqNjj+yjCwPYitvTm5H9mCfDXdb3aBNvKKqmlkCX?=
 =?us-ascii?Q?mot2JCkHHl8mGfusql5xk+V8RIZvG7HN/zeYSWNxnx45aGCCQjeursJidiZp?=
 =?us-ascii?Q?CYJeoNgSvsZEGFBxbzhtVZPfL3MV9QGteqkk/UpSNSpVSHHPuai0AEbhLJT1?=
 =?us-ascii?Q?ontqDGqtO3Udme/PNZ2AVK7xnjXPSXwmY682bC6EMKEIjicbiqqzTKWqLHvj?=
 =?us-ascii?Q?4GXAx++eKM8iiRbscfFkM1bWWyEyyGjnx0bvDbeYFLe8DCzPMo1gYY1w7c51?=
 =?us-ascii?Q?Z+WUVALUX2qtWjjdyE0Z4rBCAbUy/qCHIm+01Y0r2CJldRkb4mvP0QUhK8Hy?=
 =?us-ascii?Q?JIwTG8VbJEDlJTGhG1TCBblLU+Ge2+MLkDXIK2U3CfrEOgviqyMAyWYoLvlK?=
 =?us-ascii?Q?F+HLbfumL60ILlFsPqI7B9YJ1Abea0NRKZ0UdP5KeV0X2+ySDg0lfY2BB5eN?=
 =?us-ascii?Q?1FdgMbfWljslZqwmbc88+HHYCYIHf2L5cIeYWMmBBVqFk88TCXpcgXVckRN9?=
 =?us-ascii?Q?tqEE0R47Mgj3y5R+FmKqYAl9ObIvm2i/oZ6CRzHuzokWFx/HcbEX2Rt4L7su?=
 =?us-ascii?Q?JHoLuASxY+QBSVgThzgLZsbiXD6vCThQhNtNLhUiPsoEAYBin0fOofGFesNr?=
 =?us-ascii?Q?U41DJqqA13hMfJZaPoCg3hiNRsVuxveXi6G/RkMRi4SfldyOnyPyPcYiHlyB?=
 =?us-ascii?Q?ecfub3nAiZQLWKGcyXRJ5EqYXVjPd729/U4B7dD7+f0marv/zIQjPzZQekJA?=
 =?us-ascii?Q?VzazHVW7Nysc1xDhxGSt+dDKnVXvLwg4Ow3iaedIJTI9RwwnenIL6X4dmqe0?=
 =?us-ascii?Q?8b4DYuhIMo5uDOSoh38fOAcKhC+JYv7GHIXUxq5k5SJ+AG0nJNHOTK+3sHqL?=
 =?us-ascii?Q?xUkcYAodNtpY7u3E9Kow5N1iwnuRd3qOo6d44AsTGA6UPOQtQTDlMPKhcPV3?=
 =?us-ascii?Q?JYW5GHLnszUb4OpUwATVV9hJ5vFF+wh7kW0VFq2zErejGef+OmgrphUWLJS8?=
 =?us-ascii?Q?aPbw/m4eWl28UpgZjjLsma+WTIVEWP9uKfx+YTaWek8uUM74/yYWhEOFFK/X?=
 =?us-ascii?Q?9AGii6NzI1MId7w5kPcaR3jwUqDLbtCxIeY+LhUZiw8DSpheBT4bPiN5FvCr?=
 =?us-ascii?Q?n5I0Uj7AegegdBv1KhEjHtOnYMt6R+QuNrpNxd0ZdmQNDDY5RqHAFg9A9PMC?=
 =?us-ascii?Q?WoY1Qtgylv1Ng5ngJDtHWXiCelZLRhrP4jvnepOjlFLGMfU/noe41oDGaPU9?=
 =?us-ascii?Q?BBqoh85uUzkzOjT0IMDNNd35uyOoxltiaE7b4wjTNnSDo/iR5kEPKyhZnEWS?=
 =?us-ascii?Q?AUTrE7gbLalzz2tzcDPnFxri6kvcMtvBo87W3lcLKSSCEUlHaCEG2UOp+xis?=
 =?us-ascii?Q?5KxtzsYA9BdhAQFfjL3HCKPQjD5NEZqFKGNj+hO0Wx9kHmvy3fQga4UW3Sej?=
 =?us-ascii?Q?uuh9hhvNIEzDy73+sTcG/b/pBQ8a1JmbmaK0pas3xv+tK2pfuTliIN896y6Y?=
 =?us-ascii?Q?ux8M9ZUsBdhSo9KLDIj4mX/YKqLnmyQJ0qqPO7BA47E1cioODa8jEfOb65FQ?=
 =?us-ascii?Q?nQwBowkBSASCVuafWwLdpLAmsTU9fMuCwc3RpZ92rnNY30IxHHMngAgj3Wwa?=
 =?us-ascii?Q?aB+MdA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe33f3fd-36a3-4c41-01f4-08da9b1af05d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 15:15:23.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d1NBF2br34Tnd2dm/MjPsGjQ4cHZXOBapnKsHSE69g0b4UMRKUATR/YXeYHi/fRrqZvKh2Z+/Rcmz66oR1IGYOE2HoJrfTxWzwp1FFS7QS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5301
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Add VF setting multi-queue feature.
It is to configure the max queue number for each VF,
user can still modify the queue number in use by
ethtool -l <intf>

The number set of configuring queues for every vf is
{16 8 4 2 1} and total number of configuring queues
is not allowed bigger than vf queues resource.

If quantity of created VF exceeds expectation, it will
check VF number validity based on the queues not used.
The condition is that quantity of the rest queues must
not smaller than redundant VFs' number. If it meets
the condition, it will set one queue per extra VF.

If not configured(default mode), the created VFs will
divide the total vf-queues equally and it rounds down
power of 2.

Signed-off-by: Diana Wang <na.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c |   6 ++
 drivers/net/ethernet/netronome/nfp/nfp_main.h |  13 +++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_main.c |   3 +
 .../ethernet/netronome/nfp/nfp_net_sriov.c    | 101 ++++++++++++++++++
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |   3 +
 6 files changed, 127 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 873429f7a6da..be1744d5b7ea 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -29,6 +29,7 @@
 #include "nfp_app.h"
 #include "nfp_main.h"
 #include "nfp_net.h"
+#include "nfp_net_sriov.h"
 
 static const char nfp_driver_name[] = "nfp";
 
@@ -252,6 +253,10 @@ static int nfp_pcie_sriov_enable(struct pci_dev *pdev, int num_vfs)
 		return -EINVAL;
 	}
 
+	err = nfp_vf_queues_config(pf, num_vfs);
+	if (err)
+		return err;
+
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		dev_warn(&pdev->dev, "Failed to enable PCI SR-IOV: %d\n", err);
@@ -782,6 +787,7 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto err_fw_unload;
 
+	pf->default_config_vfs_queue = true;
 	pf->num_vfs = pci_num_vf(pdev);
 	if (pf->num_vfs > pf->limit_vfs) {
 		dev_err(&pdev->dev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.h b/drivers/net/ethernet/netronome/nfp/nfp_main.h
index 6805af186f1b..37b2bd6091f0 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
@@ -17,6 +17,12 @@
 #include <linux/workqueue.h>
 #include <net/devlink.h>
 
+ /* Define how many types of max-q-number is supported to
+  * configure, currently we support 16, 8, 4, 2, 1.
+  */
+#define NFP_NET_CFG_QUEUE_TYPE		5
+#define NFP_NET_CFG_MAX_Q(type)		(1 << (NFP_NET_CFG_QUEUE_TYPE - (type) - 1))
+
 struct dentry;
 struct device;
 struct pci_dev;
@@ -63,6 +69,10 @@ struct nfp_dumpspec {
  * @irq_entries:	Array of MSI-X entries for all vNICs
  * @limit_vfs:		Number of VFs supported by firmware (~0 for PCI limit)
  * @num_vfs:		Number of SR-IOV VFs enabled
+ * @max_vf_queues:	number of queues can be allocated to VFs
+ * @config_vfs_queue:	Array to indicate VF number of each max-queue-num type
+ *                      The quantity of distributable queues is {16, 8, 4, 2, 1}
+ * @default_config_vfs_queue:	Is the method of allocating queues to VFS evenly distributed
  * @fw_loaded:		Is the firmware loaded?
  * @unload_fw_on_remove:Do we need to unload firmware on driver removal?
  * @sp_indiff:		Is the firmware indifferent to physical port speed?
@@ -112,6 +122,9 @@ struct nfp_pf {
 
 	unsigned int limit_vfs;
 	unsigned int num_vfs;
+	unsigned int max_vf_queues;
+	u8 config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE];
+	bool default_config_vfs_queue;
 
 	bool fw_loaded;
 	bool unload_fw_on_remove;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..5deeae87b684 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -78,6 +78,7 @@
 /* Queue/Ring definitions */
 #define NFP_NET_MAX_TX_RINGS	64	/* Max. # of Tx rings per device */
 #define NFP_NET_MAX_RX_RINGS	64	/* Max. # of Rx rings per device */
+#define NFP_NET_CTRL_RINGS	1	/* Max. # of Ctrl rings per device */
 #define NFP_NET_MAX_R_VECS	(NFP_NET_MAX_TX_RINGS > NFP_NET_MAX_RX_RINGS ? \
 				 NFP_NET_MAX_TX_RINGS : NFP_NET_MAX_RX_RINGS)
 #define NFP_NET_MAX_IRQS	(NFP_NET_NON_Q_VECTORS + NFP_NET_MAX_R_VECS)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index e2d4c487e8de..e5d5f88e60c7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -296,6 +296,7 @@ static int nfp_net_pf_init_vnics(struct nfp_pf *pf)
 		if (err)
 			goto err_prev_deinit;
 
+		pf->max_vf_queues -= nn->max_r_vecs;
 		id++;
 	}
 
@@ -794,6 +795,8 @@ int nfp_net_pci_probe(struct nfp_pf *pf)
 		}
 	}
 
+	pf->max_vf_queues = NFP_NET_MAX_R_VECS - NFP_NET_CTRL_RINGS;
+
 	err = nfp_net_pf_app_init(pf, qc_bar, stride);
 	if (err)
 		goto err_unmap;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
index 6eeeb0fda91f..eca6e65089f4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.c
@@ -29,6 +29,9 @@ nfp_net_sriov_check(struct nfp_app *app, int vf, u16 cap, const char *msg, bool
 		return -EOPNOTSUPP;
 	}
 
+	if (cap == NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG)
+		return 0;
+
 	if (vf < 0 || vf >= app->pf->num_vfs) {
 		if (warn)
 			nfp_warn(app->pf->cpp, "invalid VF id %d\n", vf);
@@ -309,3 +312,101 @@ int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 
 	return 0;
 }
+
+static int nfp_set_vf_queue_config(struct nfp_pf *pf, int num_vfs)
+{
+	unsigned char config_content[sizeof(u32)] = {0};
+	unsigned int i, j, k, cfg_vf_count, offset;
+	struct nfp_net *nn;
+	u32 raw;
+	int err;
+
+	raw = 0; k = 0; cfg_vf_count = 0;
+	offset = NFP_NET_VF_CFG_MB_SZ + pf->limit_vfs * NFP_NET_VF_CFG_SZ;
+
+	for (i = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+		for (j = 0; j < pf->config_vfs_queue[i]; j++) {
+			config_content[k++] = NFP_NET_CFG_MAX_Q(i);
+			cfg_vf_count++;
+			if (k == sizeof(raw) || cfg_vf_count == num_vfs) {
+				raw = config_content[0] |
+				      (config_content[1] << BITS_PER_BYTE) |
+				      (config_content[2] << (2 * BITS_PER_BYTE)) |
+				      (config_content[3] << (3 * BITS_PER_BYTE));
+				writel(raw, pf->vfcfg_tbl2 + offset);
+				offset += sizeof(raw);
+				memset(config_content, 0, sizeof(u32));
+				k = 0;
+			}
+		}
+	}
+
+	writew(NFP_NET_VF_CFG_MB_UPD_QUEUE_CONFIG, pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_UPD);
+
+	nn = list_first_entry(&pf->vnics, struct nfp_net, vnic_list);
+	err = nfp_net_reconfig(nn, NFP_NET_CFG_UPDATE_VF);
+	if (err) {
+		nfp_warn(pf->cpp,
+			 "FW reconfig VF config queue failed: %d\n", err);
+		return -EINVAL;
+	}
+
+	err = readw(pf->vfcfg_tbl2 + NFP_NET_VF_CFG_MB_RET);
+	if (err) {
+		nfp_warn(pf->cpp,
+			 "FW refused VF config queue update with errno: %d\n", err);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int nfp_vf_queues_config(struct nfp_pf *pf, int num_vfs)
+{
+	unsigned int i, j, cfg_num_queues = 0, cfg_num_vfs;
+
+	if (nfp_net_sriov_check(pf->app, 0, NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG, "max_queue", true))
+		return 0;
+
+	/* In default mode, the created VFs divide all the VF queues equally,
+	 * and round down to power of 2
+	 */
+	if (pf->default_config_vfs_queue) {
+		memset(pf->config_vfs_queue, 0, NFP_NET_CFG_QUEUE_TYPE);
+		j = pf->max_vf_queues / num_vfs;
+		for (i = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+			if (j >= NFP_NET_CFG_MAX_Q(i)) {
+				pf->config_vfs_queue[i] = num_vfs;
+				break;
+			}
+		}
+		return nfp_set_vf_queue_config(pf, num_vfs);
+	}
+
+	for (i = 0, cfg_num_vfs = 0; i < NFP_NET_CFG_QUEUE_TYPE; i++) {
+		cfg_num_queues += NFP_NET_CFG_MAX_Q(i) * pf->config_vfs_queue[i];
+		cfg_num_vfs += pf->config_vfs_queue[i];
+	}
+
+	if (cfg_num_queues > pf->max_vf_queues) {
+		dev_warn(&pf->pdev->dev,
+			 "Number of queues from configuration is bigger than total queues number.\n");
+		return -EINVAL;
+	}
+
+	cfg_num_queues = pf->max_vf_queues - cfg_num_queues;
+
+	if (num_vfs > cfg_num_vfs) {
+		cfg_num_vfs = num_vfs - cfg_num_vfs;
+		if (cfg_num_queues < cfg_num_vfs) {
+			dev_warn(&pf->pdev->dev,
+				 "Remaining queues are not enough to be allocated.\n");
+			return -EINVAL;
+		}
+		dev_info(&pf->pdev->dev,
+			 "The extra created VFs are allocated with single queue.\n");
+		pf->config_vfs_queue[NFP_NET_CFG_QUEUE_TYPE - 1] += cfg_num_vfs;
+	}
+
+	return nfp_set_vf_queue_config(pf, num_vfs);
+}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index 2d445fa199dc..36df29fdaf0e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -21,6 +21,7 @@
 #define   NFP_NET_VF_CFG_MB_CAP_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_CAP_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_CAP_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_CAP_QUEUE_CONFIG		  (0x1 << 7)
 #define NFP_NET_VF_CFG_MB_RET				0x2
 #define NFP_NET_VF_CFG_MB_UPD				0x4
 #define   NFP_NET_VF_CFG_MB_UPD_MAC			  (0x1 << 0)
@@ -30,6 +31,7 @@
 #define   NFP_NET_VF_CFG_MB_UPD_TRUST			  (0x1 << 4)
 #define   NFP_NET_VF_CFG_MB_UPD_VLAN_PROTO		  (0x1 << 5)
 #define   NFP_NET_VF_CFG_MB_UPD_RATE			  (0x1 << 6)
+#define   NFP_NET_VF_CFG_MB_UPD_QUEUE_CONFIG		  (0x1 << 7)
 #define NFP_NET_VF_CFG_MB_VF_NUM			0x7
 
 /* VF config entry
@@ -67,5 +69,6 @@ int nfp_app_set_vf_link_state(struct net_device *netdev, int vf,
 			      int link_state);
 int nfp_app_get_vf_config(struct net_device *netdev, int vf,
 			  struct ifla_vf_info *ivi);
+int nfp_vf_queues_config(struct nfp_pf *pf, int num_vfs);
 
 #endif /* _NFP_NET_SRIOV_H_ */
-- 
2.30.2

