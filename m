Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32C63400BB
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 09:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhCRIS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 04:18:26 -0400
Received: from mail-mw2nam12on2069.outbound.protection.outlook.com ([40.107.244.69]:37152
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229540AbhCRISR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 04:18:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmer8nDJ/WMkiQHpWFCo5WgAnFgJbVFoI3S1T4q8t32ZreulIbXezj+Nu8WT/BsWFOjjOc/jBshmDFL8yzUlXZzeQv+bVt9JaIRWMHnQavJpD3KO9paS8EULwKaukVGmkz2PhK12sx+8wqYlhBXbDCzKjan0EJ/7kdjg9d0B4EY5v4wcb/KwvQ4x8ETDm5sIqeasE9NihjYQ6/phTNF9V4hVy+5uINwJ7ecvyWMutoiiQHmKzxSKzpZ3Lro3U87RF8eiU0bILCtVAANynQNbydB5Xx18vYWjghcgN30uGB1djsZvH5sOQjKeC4GHJmfOuGD2x6T3EWbAYcPnymSSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PDOULR4OXMkyULR+6rjMUpAB/wpssimXn9eqUbQKOE=;
 b=TS6AVfO2eCsAXmNPAcWoc2Ryhtf9n4o/kV5jbFAC0uSKn0J2XRsWetW79jVMu/uddZ7jN/f44ssg3dZzAcZlA6AU3AUNKS7hpGvgY/cwcuAbvPiFiDET22maO++2IEVUP9ks1KaZUqbqOVwIVFGSfTX5/f/Zgn1OHeDuZjNao9XH9U8gAy3/8AlyVwGIY5WI//AZE95EUJUwP14OurpC7UcD37ruqDQRiV7aWQb02+kPL72Ta1Bt/R0gvqLzpI08Xm+msENMN9nj64fYdIBKL8hF+WhATEFcCtjJ4aLBMk3yqgo5s0AZFNkRijssCAgu4DYSoxvSTIrkPifyQmAn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PDOULR4OXMkyULR+6rjMUpAB/wpssimXn9eqUbQKOE=;
 b=l7mSdRzbukNZCNQynTsYY7XBix07GxVMSRG1bYvgatw+n4gDigDWVve7rGfnn4TMN4Se1857UEi1MnARbOxpqzUCs6yrCz38YI8adrCubDUsjbUg1WA1w4uaeDzjqsj8tpN+al/tKQcjEt2LCm+/QRgxGWCIsVODWfFYCRhrXuk=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from SA2PR11MB5180.namprd11.prod.outlook.com (2603:10b6:806:fb::16)
 by SA2PR11MB4891.namprd11.prod.outlook.com (2603:10b6:806:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Thu, 18 Mar
 2021 08:18:15 +0000
Received: from SA2PR11MB5180.namprd11.prod.outlook.com
 ([fe80::49ef:bd8a:bd96:4fc]) by SA2PR11MB5180.namprd11.prod.outlook.com
 ([fe80::49ef:bd8a:bd96:4fc%5]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 08:18:15 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     brett.creeley@intel.com, madhu.chittim@intel.com,
        anthony.l.nguyen@intel.com, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] ice: fix memory leak of aRFS after resuming from suspend
Date:   Thu, 18 Mar 2021 16:15:07 +0800
Message-Id: <20210318081507.36287-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.5
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0030.apcprd03.prod.outlook.com
 (2603:1096:203:c9::17) To SA2PR11MB5180.namprd11.prod.outlook.com
 (2603:10b6:806:fb::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HKAPR03CA0030.apcprd03.prod.outlook.com (2603:1096:203:c9::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Thu, 18 Mar 2021 08:18:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c8a2b75-83d1-4433-75e7-08d8e9e660ef
X-MS-TrafficTypeDiagnostic: SA2PR11MB4891:
X-Microsoft-Antispam-PRVS: <SA2PR11MB489179F73C348B4182871C85E5699@SA2PR11MB4891.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xYHp1DhzVKihH/YyP+SI8xgvC2rWy8hnEDZhpehCIDIysLMSZyEVUYD3BuuCYD/rm1T7+8p1YM9X1T6Lbu9ZHllRhqlpPTBUY9cL3xRwiTosi6mdnk07PnVh/CZEGci9jQSxJZu6FMaPDp0fc1cr5KlXmEQ/7OaG80wqqZarup52l1bQo7cYl17pNcXfGTpB41OIeIFe27s8/aEkjRD4/VkO8C3h+wvmqAR/sPuyPBcvZBDxBYzUjf6iunRJs7QwElgrtoHPFa2JFo8s8zVe77COOi0+Q9EQ1JMAb7kbcEYAIxHMSc3dHPtUwml4Rk7mCK56Y9luT15gad1RQna9raua659zy9LVxOjFom5fujt81tKfB2Gy8yt3RVzs4ZLmiVckY8USFX4GXlQnAnqtGyr2oB9Jp0pPJoGWE7/rJiCM22LFcnA1pIMiD00GmEuI9a6VxcctNUFJM5AtuMuYHQ8AvHdgcYezgHI4JA1k3pDz428qUKm/8CwjitFL3iGxgXFAfQHXi3fPPsgnvt+YPDmpc+6WCG4ll4Av2xrCC6EK5QW5zdCxGAbJpawyKhHeXBGrQyKep7Oqobr+h6Ig+oTlCcF4dOp3c6+hHt9IalNowIX7BXkQv3xZZEYwoRvF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5180.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(376002)(136003)(346002)(396003)(8936002)(2616005)(2906002)(44832011)(186003)(1076003)(16526019)(66946007)(86362001)(478600001)(66556008)(66476007)(26005)(6486002)(52116002)(38100700001)(316002)(4326008)(6512007)(6506007)(5660300002)(83380400001)(956004)(8676002)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GGgoeGA9X4Naniv8t12R9r0ln1VSw3WHPGLrHMNjKMr8IlDuWMf70cDUS8N8?=
 =?us-ascii?Q?eUXmjyIz6osvW69pWNce91vUVmvjKoR2iE5g8htfhwSB8QpCaYdCSxiFSosu?=
 =?us-ascii?Q?7D8hhxLjFlXDoX8sezjAWDSTEWz2lxQ6b6hmJIaOE6m2xHiBSFZvO3O1X4ZU?=
 =?us-ascii?Q?gUPNVaxImk+GOfwh4+RzXBlpre9RLu86xQ+Z+ZCFRwYVxrd1DRP242xwUHYa?=
 =?us-ascii?Q?alQnbl4goqa3NvLox9joG2ZMBS5fYmOFkoXGMPBvGz2jrrRxPTeHXU4xenH3?=
 =?us-ascii?Q?DtLp1U5kSaHcoP/YeYmBE6DE+GMmKmLm5+Knnequo3O4M5w+PifPDRjRL2c6?=
 =?us-ascii?Q?P+7H7fvokU9mSlYpFtZY4vcmPrIPSI+txFDSaFq/4iHf40lJiwCW8tt0Fa38?=
 =?us-ascii?Q?zFTs6j7ioN8vxcHW3r1NG1BQq/KG3EUSe9jBtGGYugFFG1GHQ2Lkhlxlrq76?=
 =?us-ascii?Q?js6uVJoG4kvcqXZhYwU14wUkxycNikQaSOjNe/b1Xg3s2CaCpnQanIeYN8pU?=
 =?us-ascii?Q?p1X1SAaWAD9EuOPh/Vb8X62mZ+ueYM1IhR9JgoEJQtBhaNC01kMNUeJCmbn2?=
 =?us-ascii?Q?Nv8tAG7FldIsuDOs8GEc8jDjKCvqbFuukV4dx1pYPv/iRxELrmFIzGZL3sre?=
 =?us-ascii?Q?kovohepTvIKr7DeJjoQBglPt8L5BsMImvik7OeNC5zJeeCe0/7eqy9kerQSP?=
 =?us-ascii?Q?O9AL8Iva43md1yxSs1Aqvvzl35MbbvtUFUfx/W54xlu++bcK31OSIn78Lim2?=
 =?us-ascii?Q?2H0647xm4rzVfpwvUUPPbxOVI9vEsiKDrH/lHYXcARRfQ/RhKzloOkoQxrto?=
 =?us-ascii?Q?Q2/QCw016bBW2p2cYl2zGYTSL0iP7ne/kAGrWi4ktGIKtMATiz3NMp50Mb+Z?=
 =?us-ascii?Q?B5ui3okYeO7uV0rv3dC46LU4HDLbtu32JTXDc/+N8na6bmGHA6ZHhKgrpDq2?=
 =?us-ascii?Q?pV+CpVO0h/OokJ5x0VsI73Ve5YX9cKlcAtSIcC1KVjLvxgD9Tq+3GPMJndQp?=
 =?us-ascii?Q?KDAZc0fqgTddvGy27XfkDQ/lPeCT3tF4uIgjeDMf+h7/3X4W4ENWMoF7LW4K?=
 =?us-ascii?Q?09/PP65U8vo8l6aRVlplrHjS2fO/i0vZbchrK9KpYl85ADALUa3HE2u6MGJv?=
 =?us-ascii?Q?lDp+ggTLxY59lHCnO/sWrH/PzaZZrlU4rpXT6h1zV6GzcBxbb7oO6zplyBJW?=
 =?us-ascii?Q?fSls6s9uZ3manyEuqKPIuI4PwRFjOAbaZavVmai/HUsdd6Ps46CParbXbGK9?=
 =?us-ascii?Q?TvoJc7V/Fdtoge4x4H412wcaJ4Ib1quXRvzN4QQZm2Oq5zvdfjxQ/ubo+QUX?=
 =?us-ascii?Q?VRUXlue0svUL+Vu08naMl8iO?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8a2b75-83d1-4433-75e7-08d8e9e660ef
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5180.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 08:18:15.4266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHhtRXH+1+ZTTq/1f1SCBczyyxudgLaaUtRVGiEHJCOgnB8YBu7YL31B3bTfxmI9i584cNfSqSCOfX5CcMzuSQG/WCbRM1VwzZ62fQTPAEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4891
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
irq_free_descs() will be eventually called to free irq and its descriptor.

In ice_resume(), ice_init_interrupt_scheme() is called to allocate new irqs.
However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap maybe
cannot be freed, if the irqs that released in ice_suspend() were reassigned
to other devices, which makes irq descriptor's affinity_notify lost.

So move ice_remove_arfs() before ice_clear_interrupt_scheme(), which can
make sure all irq_glue and cpu_rmap can be correctly released before
corresponding irq and descriptor are released.

Fix the following memeory leak.

unreferenced object 0xffff95bd951afc00 (size 512):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    18 00 00 00 18 00 18 00 70 fc 1a 95 bd 95 ff ff  ........p.......
    00 00 ff ff 01 00 ff ff 02 00 ff ff 03 00 ff ff  ................
  backtrace:
    [<0000000072e4b914>] __kmalloc+0x336/0x540
    [<0000000054642a87>] alloc_cpu_rmap+0x3b/0xb0
    [<00000000f220deec>] ice_set_cpu_rx_rmap+0x6a/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30
unreferenced object 0xffff95bd81b0a2a0 (size 96):
  comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
  hex dump (first 32 bytes):
    38 00 00 00 01 00 00 00 e0 ff ff ff 0f 00 00 00  8...............
    b0 a2 b0 81 bd 95 ff ff b0 a2 b0 81 bd 95 ff ff  ................
  backtrace:
    [<00000000582dd5c5>] kmem_cache_alloc_trace+0x31f/0x4c0
    [<000000002659850d>] irq_cpu_rmap_add+0x25/0xe0
    [<00000000495a3055>] ice_set_cpu_rx_rmap+0xb4/0x110 [ice]
    [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
    [<00000000d692edba>] local_pci_probe+0x47/0xa0
    [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
    [<00000000555a9e4a>] process_one_work+0x1dd/0x410
    [<000000002c4b414a>] worker_thread+0x221/0x3f0
    [<00000000bb2b556b>] kthread+0x14c/0x170
    [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30

Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 drivers/net/ethernet/intel/ice/ice_arfs.c | 1 -
 drivers/net/ethernet/intel/ice/ice_main.c | 3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
index 6560acd76c94..c748d0a5c7d4 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.c
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
@@ -654,7 +654,6 @@ void ice_rebuild_arfs(struct ice_pf *pf)
 	if (!pf_vsi)
 		return;
 
-	ice_remove_arfs(pf);
 	if (ice_set_cpu_rx_rmap(pf_vsi)) {
 		dev_err(ice_pf_to_dev(pf), "Failed to rebuild aRFS\n");
 		return;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c23c8f468a5..dba901bf2b9b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4568,6 +4568,9 @@ static int __maybe_unused ice_suspend(struct device *dev)
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags)) {
+		ice_remove_arfs(pf);
+	}
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);
-- 
2.14.5

