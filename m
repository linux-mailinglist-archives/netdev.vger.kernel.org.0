Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634B96E74CA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjDSIPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjDSIPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:15:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2125.outbound.protection.outlook.com [40.107.94.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8F610C6;
        Wed, 19 Apr 2023 01:15:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvigoQiVLX8Gjb42frG6+ALRpu+NfCJaHsv3vJflkGT/FQILQqU8cPVqyrcUqPuXIFPFVKATS6YVV0PoIU5hQZJpic5DIvqiS1/EBhkgFuRZRhq9JMPYkEpMC/gmug5WZbtytUGErajelvGWpOUVchPtohHQdRWFmLluVIM2dy0NwFRzdCFsluTwmOavPhltImqOQN8QDbIfPzGFo3LJnhNrNrNDwyo0XrswEWOHqbpxHj/Yf3as2o9diCUuftYGE/sVqsH5JIT9Zey9IdPLIvRgmFJsU7i1L5X5CM4aRzN1e45Q3ziHyPAAud1rWsVTs5RMKLlF0QZuJTuDpQbf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1NDjTUtQ64LRK7OAslhRt0FjbQ2lBUzD7zx+MJTuX8A=;
 b=GbRGycAGRKwV782p6t2s/xNJ8zS+bu9JNuCgGeibDyyC4GaDe66LM6dFd9OMgzVqHyJcq6Io9RpZ71+/zi5rve7Wes+ebOtTRFRNzCHZweV4FR1y2mtnODTm1cgQcfb31YkHINwb7R0QmfwIqO5GEmvjfXQAx7477yjt620f+Skb311mtn7DKTQBdY+7sOqDd969WfLyaIBa6uX/lZ0Q7YQZayGSO4j6iq7JDRGA+17CoH5K5q7JF4zGlSfKmc9QZbCnZHNMagQZMvdc7GzB80xVjCGXjKEqufNn5esKlfS7XVvgLDulYaNGdBaW1VTQ9CYRq6s70H121EK6PbjQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1NDjTUtQ64LRK7OAslhRt0FjbQ2lBUzD7zx+MJTuX8A=;
 b=XJ0KqOr2GSIOdZLfyglGElMfbi/Zg3pABFla+Nf2XBUQSmCTwSUuSNhfjs0klIPBUtoS7/NtujgqrvQBHteyVn2ilC4o3J68ZIBOEnf3aUOQV+oOB8hPqYJSYREKMa9dWmmXKlipnm4X0ygjDdOn2SPadWutwAmfse34Sedj1qc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB4558.namprd13.prod.outlook.com (2603:10b6:5:20d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.20; Wed, 19 Apr 2023 08:15:47 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 08:15:47 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com
Subject: [PATCH net v2] nfp: correct number of MSI vectors requests returned
Date:   Wed, 19 Apr 2023 10:15:20 +0200
Message-Id: <20230419081520.17971-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0071.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::22) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|DM6PR13MB4558:EE_
X-MS-Office365-Filtering-Correlation-Id: c5a61627-6940-4c6e-c945-08db40ae473a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGbKDh5umr7891poaeksnfl50jRvgJ8pFuR+6+LjW4gdE0HTwb5i45Pb3B/Ts+UZ3jHD5tc6wxAcuo445V1yEz7eUCJTA7R1f/TgjgIxkog6rE1lAF+7B6G8UckocYMt5BFIuha3Rg/BPsYcv0khu114iOLUwKxQoJ1LL3UgGDhwiIl3iUDaiOfyRV8W1zsOfkDsQpEMmCmoiOUKMefsNxmcusWueVW8erFZyM+jO5KrnyXNEN1xb10HULGFH5Vt7IjAwTsthzRbj5g5kxaQgkGb61hZ0jutNGTKYUxMBxv5NAbA6esXIaJRwdSb183gOSkDw12QT2pWHmyNaejiHZwlJp+/JcN9q0i8Z53sO2l6BxhivtRaApT6o3uo2KUDX3nGbURzQqrj/BOpZEbmI+zyOJx8abO1jAfCiy0wVk7OYgLrIPynFTC9YH338U7egGS9wwh2lx0kv40QF08dVIu1DI3LzgRZtdEMg22ON9i5mVZPYD5I8YX55bAGp1x14Rb+XYP2eN29E61G4Qihbkg6faOb1BD9liANQR7oCAfQV3yrUlhf9Limi5FvG0+RLM3xTNbm2fvGdPkgoVtm9oMPTSrJhH/SNKgVjrJEZRc9DpgdIHlhTFTREo7t+NoW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(396003)(376002)(366004)(451199021)(186003)(4326008)(110136005)(54906003)(316002)(66946007)(66476007)(66556008)(52116002)(478600001)(6486002)(8676002)(8936002)(6666004)(41300700001)(5660300002)(2906002)(44832011)(86362001)(36756003)(38100700002)(2616005)(6512007)(26005)(6506007)(107886003)(1076003)(38350700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1DtKVLfU9fJ89+O+6OxwizMjH5jJPRhy3jGibMHVEccZPeE+mZbOSVGChLgP?=
 =?us-ascii?Q?HoAba6Ba2zCZMVwHVEHWUaZa7nFMSDEuyIBIhUIuzapBw0xrNKqQ376nDPib?=
 =?us-ascii?Q?DBt2QEj9eI8GDB7h2g1P1K7dJGnUN3ameyVJ7nxX3KKEBQp6+v8bO02z76Of?=
 =?us-ascii?Q?7n4emdUDAbBRNdpv4YHNrq/EaOT4EACJyM+LVJEXIDYhvUs62eKrIslC1QbL?=
 =?us-ascii?Q?QaYyQ90SF/lkW9WUmy6QL2SDH4RrG3smJ4QW1Aqdnv3w+seOu+MTrgBvhnjE?=
 =?us-ascii?Q?kmZ1HhxNBfF2oy6lk5cb9wGqwXAopWvzWfTxy6jZU4HuqptJ9zGjaBikA6RR?=
 =?us-ascii?Q?to5Aj7CD4eoPWlDpq8OXc0l8jyjVln/05k0qS/Ywa1mUngQbavExsqTPTFUD?=
 =?us-ascii?Q?QsEkj1g75UFqPXT37TBBTZkTJVGpPn6/2qfqO7FshwoDxtvJQeqqTN0e+C0j?=
 =?us-ascii?Q?vtNli5Qosve3kTjluUdyP5wnpzaQ5SomCghiI3OlCEJ5UEhLv7YSqqPmTtNH?=
 =?us-ascii?Q?WnWGFUV4pidhawj0i8uJC28goHCqbCqUVF/512BN8qU4EjOOxVFEu8rPuLXs?=
 =?us-ascii?Q?SzxUDVR7F3yB7ZhuuRRlbzN1sO5pdXR+Vkz30+Lt6eJOvPw0CGlDAv5pMjT8?=
 =?us-ascii?Q?X75WjPo2pav6T7f11l9wHNGsbJLat6QuGElxFRqYFU6LWkDOdrOTd3hz+ris?=
 =?us-ascii?Q?xUkaLpIqmlvtQR72jrCzn4De0v0zVR5O8PJ61hNErgJ4VmCpNHM+pdm6NujD?=
 =?us-ascii?Q?FUrmS5kLKPA3zpFHgGT0qf2zD3Ogy6ayw0oPIH7VHQrOWPOH1JP1aQcHSKMh?=
 =?us-ascii?Q?mj1/jcEvkdcroc4GHMVwkyyn9nmvHN3qGQhOtUCbRTTCpbvXrKND3+Y80sAB?=
 =?us-ascii?Q?gBu+wwj5L7ujaYLYsvQwzOv/2zKmCkZI2wsCCqR/FXinA2IZv5x98AAKIcJp?=
 =?us-ascii?Q?Jbrxnd1wITKWp1ehz3N6vPwZrPNbGq7fp3a4cxwNqk5/rZ1n8b3LWjMU2xBw?=
 =?us-ascii?Q?9sot9FeYv+0DNAOQGtPR6XeR1x+cttD18HmkcO/ux/Z66PxkRPU4/nwAzlnD?=
 =?us-ascii?Q?uDyqBxNnhD+675p7ucgxNLKrff4+5GlWmBUUsURzwvEBhI1iICTlzGAFGWs8?=
 =?us-ascii?Q?BpZK+kzGSwYg0F0c/y+OTeReEmKhVLdIl7jdUhEbJhKgZE7nBS2WlW2v2wjr?=
 =?us-ascii?Q?kpZsUQ1e5g01igBEfCOuAJ8IKLntjEbXFrlOlqjuDvDW13XRh/BqpYnCxuEB?=
 =?us-ascii?Q?ShJCvyGtOz6LaeaGxITVgE1opwnJkA3NpI7KIRaKMd3Uvy2wrURwrOXbYzwQ?=
 =?us-ascii?Q?E6tknbQaE/IxkP8di08o9zdCA83+omMHugOG60nxTfOAEkWmekeJz70jEHGI?=
 =?us-ascii?Q?QHxf0GAHxHFlP7cXcqVVxHHu4x8+P/627HwwxAMp0SzK0qjR9QNHPR61+7kU?=
 =?us-ascii?Q?BznHXno0ixzigGa/YUuABf4CQcnxSFUytML80Es8We9266HghvBaMEfOol9d?=
 =?us-ascii?Q?3dtirz5vLcYUAx4xu/DcVgA3KnLbD/syzl9l/Sz2Oj3l/ijztMGIMaH+9kkO?=
 =?us-ascii?Q?qfZ8HXkeIgGQD/DmJHA2LZY3JBadScaNd6DjbLk6ptXqRJY+M8fEdO5CLWzv?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a61627-6940-4c6e-c945-08db40ae473a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 08:15:46.9361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pa+dLO7Bq9jO2Oxr4KWnxrDzG55F5sFcq7fmLDlH0jUMaH4J7uN04gv2zjwjnPb+o+HcB3cOI24Arv5qTYXr/kZb8u2YNSBO70LPRy2sZ8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4558
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoyu Li <xiaoyu.li@corigine.com>

Before the referenced commit, if fewer interrupts are supported by
hardware than requested, then pci_msix_vec_count() returned the
former. However, after the referenced commit, an error is returned
for this condition. This causes a regression in the NFP driver
preventing probe from completing.

This situation may occur because the firmware allows sharing of
more than one queue per interrupt vector. And, thus, it is valid for
the firmware to advertise the number of queues it does. However,
interrupt sharing is not currently implemented by the NFP driver as
it seems likely - though not tested - that any gains obtained by
having more queues would be mitigated by sharing of interrupts.

Address this problem by limiting the number of vectors requested to
the number supported by hardware.

Also, make correct the max/min_irq types. They were unsigned
previously but should be signed.

Fixes: bab65e48cb06 ("PCI/MSI: Sanitize MSI-X checks")
CC: stable@vger.kernel.org
Signed-off-by: Xiaoyu Li <xiaoyu.li@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
Changes: V1-->V2
* Updated the max/min_irq types to be signed instead of unsigned
* Fixed formatting of commit message to be better aligned at 72 chars
* Also updated the commit message to better explain why this is even
  possible to happen, in response to the question from V1.

 drivers/net/ethernet/netronome/nfp/nfp_net.h        |  4 ++--
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 12 +++++++++---
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c   |  9 +++++----
 drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c |  8 ++++----
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 939cfce15830..960f69325287 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -971,9 +971,9 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd);
 void nfp_net_mbox_reconfig_post(struct nfp_net *nn, u32 update);
 int nfp_net_mbox_reconfig_wait_posted(struct nfp_net *nn);
 
-unsigned int
+int
 nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
-		   unsigned int min_irqs, unsigned int want_irqs);
+		   int min_irqs, int want_irqs);
 void nfp_net_irqs_disable(struct pci_dev *pdev);
 void
 nfp_net_irqs_assign(struct nfp_net *nn, struct msix_entry *irq_entries,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 62f0bf91d1e1..ae309ea48356 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -362,14 +362,20 @@ int nfp_net_mbox_reconfig_and_unlock(struct nfp_net *nn, u32 mbox_cmd)
  * @min_irqs:    Minimal acceptable number of interrupts
  * @wanted_irqs: Target number of interrupts to allocate
  *
- * Return: Number of irqs obtained or 0 on error.
+ * Return: Number of irqs obtained or an errno.
  */
-unsigned int
+int
 nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
-		   unsigned int min_irqs, unsigned int wanted_irqs)
+		   int min_irqs, int wanted_irqs)
 {
 	unsigned int i;
 	int got_irqs;
+	int max_irqs;
+
+	max_irqs = pci_msix_vec_count(pdev);
+	if (max_irqs < 0)
+		return max_irqs;
+	wanted_irqs = min_t(int, max_irqs, wanted_irqs);
 
 	for (i = 0; i < wanted_irqs; i++)
 		irq_entries[i].entry = i;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index cbe4972ba104..c1ac380542b5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -222,7 +222,8 @@ static void nfp_net_pf_clean_vnic(struct nfp_pf *pf, struct nfp_net *nn)
 
 static int nfp_net_pf_alloc_irqs(struct nfp_pf *pf)
 {
-	unsigned int wanted_irqs, num_irqs, vnics_left, irqs_left;
+	unsigned int vnics_left, irqs_left;
+	int wanted_irqs, num_irqs;
 	struct nfp_net *nn;
 
 	/* Get MSI-X vectors */
@@ -237,10 +238,10 @@ static int nfp_net_pf_alloc_irqs(struct nfp_pf *pf)
 	num_irqs = nfp_net_irqs_alloc(pf->pdev, pf->irq_entries,
 				      NFP_NET_MIN_VNIC_IRQS * pf->num_vnics,
 				      wanted_irqs);
-	if (!num_irqs) {
-		nfp_warn(pf->cpp, "Unable to allocate MSI-X vectors\n");
+	if (num_irqs < 0) {
+		nfp_warn(pf->cpp, "Unable to allocate MSI-X vectors (err=%d)\n", num_irqs);
 		kfree(pf->irq_entries);
-		return -ENOMEM;
+		return num_irqs;
 	}
 
 	/* Distribute IRQs to vNICs */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
index e19bb0150cb5..5f89c7198606 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_netvf_main.c
@@ -84,7 +84,7 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 	u32 tx_bar_sz, rx_bar_sz;
 	int tx_bar_no, rx_bar_no;
 	struct nfp_net_vf *vf;
-	unsigned int num_irqs;
+	int num_irqs;
 	u8 __iomem *ctrl_bar;
 	struct nfp_net *nn;
 	u32 startq;
@@ -255,9 +255,9 @@ static int nfp_netvf_pci_probe(struct pci_dev *pdev,
 				      NFP_NET_MIN_VNIC_IRQS,
 				      NFP_NET_NON_Q_VECTORS +
 				      nn->dp.num_r_vecs);
-	if (!num_irqs) {
-		nn_warn(nn, "Unable to allocate MSI-X Vectors. Exiting\n");
-		err = -EIO;
+	if (num_irqs < 0) {
+		nn_warn(nn, "Unable to allocate MSI-X Vectors. Exiting (err=%d)\n", num_irqs);
+		err = num_irqs;
 		goto err_unmap_rx;
 	}
 	nfp_net_irqs_assign(nn, vf->irq_entries, num_irqs);
-- 
2.34.1

