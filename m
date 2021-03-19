Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFD434161B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 07:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhCSGoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 02:44:18 -0400
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:30433
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233935AbhCSGnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 02:43:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVB+5pRKmc6dpN4bkhW6843h0rI6aVrSmbwD+bimMZkdBuIe0Ugi2+62GsOCqgyUp5ojnV5+QTiakBPgGSnfjOy4B2f85K4uGFJh/bSf4sBO4IgZ8rSDvAum5GFxLt1AMwnOaIbnymvbVx2X9/RTb0rU9393OiYzDbuSAt+3GRZ2klTmxwndAzy8vebc+xw44cAuJo4mvAF0AK5ryywP+1dfSfwiqvH1Py+0g9bbb04l9uhPxsTXVYeKB9iKqICY2TaarE6fu6UTtmkeusfjK5j+0+VozJ2zudPnsyLBUspRE6yrtN9Tpat+m9SoxjYe0EANukcgJxh1VEvvg3R5xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9CGlsOumlYE2+yEPN/3IFz7ogC2GEvhfKkL1HG/ZGo=;
 b=L2xk6d0iiCJxLFNKVSmiWn3k4gtd+ATF7KTwRpaR3QQ9mg6Zi0cFuabUr1moRbFeCOz4Ey92M4WWo8/osX/uh1wF+FN1Rp/v2cC71/pzWVsbG2KtDwN7Xc79q5xrz5a8IH4aaDVNVGsGafbHAduclZF+DcqxMODivoYLjQ5eTDqtyouEuMyJNBZ8d7g+n0HIaDxGZQEFFe4j3E3d6BDY/S0a0q9PCKiJfFnbxMOjH+6IJTdoicxmUrnMu6JOJQmiJ++Pv9PgjEE/QvPgbOdXj3oe/hVUB7Q6uDajzfqXERB+gZQSquOygIyDuUJVV0Z+MAS0bDMdPX3toqKmOmfd+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g9CGlsOumlYE2+yEPN/3IFz7ogC2GEvhfKkL1HG/ZGo=;
 b=cfMp+M65aDN8K4zJDWd6o7oZxwI8ZnbraeI+/vzKYMP/1svHS6FwZiy33dmVn45D+3/zvDGVQeAesT7KxFnKlHdKRSDKbXdjjg2KzNVW36tW+1KiNCJpz803sOsaIGZJLRpEN0+sM2GzFpSs7lvr55gZ5RY2IKLf0M6y16qis2o=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 06:43:42 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f%7]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 06:43:42 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     brett.creeley@intel.com, madhu.chittim@intel.com,
        anthony.l.nguyen@intel.com, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from suspend
Date:   Fri, 19 Mar 2021 14:40:38 +0800
Message-Id: <20210319064038.15315-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.5
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:202:2e::20) To PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HK2PR06CA0008.apcprd06.prod.outlook.com (2603:1096:202:2e::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 06:43:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4a69876-5c77-4915-1b60-08d8eaa255b7
X-MS-TrafficTypeDiagnostic: PH0PR11MB5078:
X-Microsoft-Antispam-PRVS: <PH0PR11MB50781B550A6FCBEF0F93B181E5689@PH0PR11MB5078.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4Fohqhnm3C5HZHhHR/BmwAGJlonUQGXJO+m8f2dijMr99aaHqWsiiLyrBYzgwF9vRsQKhRqaynZn10Jf6T+E8CLMoxIF7FFMCkoDklSWmSNtiy4+9eChwdZbi87TDlq6Iwj9f6JZnZvDw9NFiuv/0oj0LCHYf2TBsw4mFDmuxAt3MesXUgd4/eM45D6pZc0fwyx9Lj3e3A6sEBhaLPKeLOz7g2LBbsw8HewOC9iwl140qChTGBa3zVCQHIRKCW+MYYRHwBq0IC2YuDxprsjzkgkd9Rr/TgU/L9l/+DXD+PxpSRqEJJxABorVL0fD0SiraDu58jdfyxpYBRujqP631IIQL9YAmcvuGI+RI74vwphpm0zc9nzJgFU/0JG/W2xu5MHAdw8P5d7gBJhs6tKz7q+ud46y2Jusn3LWAsD3R0Kaxl5hz6U0JKqU8Pb0yBpPT7mioh7379hRmgMHduEVJehf0WKJxiDVWboVuc+vCHzVLbDanhP5E+RN1lsLabu238GLzanxO47ZKL9uQlcqvbcF+6xwZMvUF2z426WwlZYX/M+OEyfALdg1Om/k1yEWQD35Dw6yo/0SDy3NqfH4ya0xFQjwbAwXBN8NHgTpGib/lJUDrYuPAOPB2zcyt400DTZf7bnBCy/FasA4roqUxkPLswhVLuhKHz0EOAIvec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(366004)(396003)(376002)(136003)(66556008)(16526019)(6506007)(8676002)(52116002)(5660300002)(316002)(2906002)(1076003)(83380400001)(26005)(6486002)(66946007)(478600001)(66476007)(186003)(4326008)(44832011)(36756003)(6512007)(956004)(8936002)(2616005)(86362001)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+ec1AkmKg6UG2o2toFywNC0a+CB6c3uiOPyK6UyqB7wj5m5nIfpxOzK4l5lS?=
 =?us-ascii?Q?H3TFbHVGWMgXb4QUCQ40qnCXcGY91Q2ERnsoz/FHaaKYIDTpAqhIBRsiwzPC?=
 =?us-ascii?Q?tmp2gk8JpCFeHiK6VHy4XE1RrjrPsiBe8bpRMsJZ38D8Ox/NEsVnGPDKR0fo?=
 =?us-ascii?Q?14zF9m0fElBbL+MGERSxTmJ2bBS7u/d44rM/2nIQwYmSXmyk9MA6pMJS58Lq?=
 =?us-ascii?Q?VcVgJGnZmdJPZZW6h2rfeMW3iaKsXUMmGmEaJYEPrw7giKyHpavIL78psY6s?=
 =?us-ascii?Q?5ffi8GUFbD+FABDnEvHXI31lUn+KH9ika8JFMro7NhNHopRycmkd8jngwb8u?=
 =?us-ascii?Q?8erTQB1/Z0AXnHE6Rvl0OEZ0GqpqdG82BzvjgLitD1SLPmJ2LlL41cV8q9M7?=
 =?us-ascii?Q?QNKIu5jvjRDmP8F6DBWukCH6NZvK5ASywXdX28W4BiKUFXEH06TkFcFkqctB?=
 =?us-ascii?Q?EDF14XYAHnGKVtB5DM/MHSvlrZ+okEP1zwqvSHa2OQ6zPpyGFdg6Q4CP3eXp?=
 =?us-ascii?Q?Q2fD/0DoAHUN6waElTkEX70Fz2i9K4Cdr29Jg+2lFLfMBHKm1LZF/qaCzk/B?=
 =?us-ascii?Q?uzWew8XQy6yimo5E4nlat7fFaIhWayMx0E9+NVli0CjPdkVjKhUA94i2JyJq?=
 =?us-ascii?Q?aOv86dBHLRtXr+NohFdmcsQEWse4/NEOzcA++svOCs2oKDQoya8Ak1BryoH1?=
 =?us-ascii?Q?bNFQFzi9rJO9MjKn7+4XML+gDE7b2R7jUTqs+P/dXuFLiz4kKXYjrnDpX+jC?=
 =?us-ascii?Q?HY92GKsaoE2L+SKTSw8db6wt406oLJhdbjjzTdFnzWQz4LyTm+PeAJim2UOB?=
 =?us-ascii?Q?B8b6s6Cj2XGNPnwlvQzyDMX/bToYN9+eYrlqnx4L18/OtK7R7/lmmJGLz0yl?=
 =?us-ascii?Q?Fs7UgwnI7mmeWcC2xICrbvl/Wdx9Q1PRyDeIDQ6VsfgpXSa2xOCX1eyTECGr?=
 =?us-ascii?Q?vv2QLtXEI0fz+RA0YU3BykR5RCHvT565ItdOI1IZKBJ+odo0lwDL9s1vQDbv?=
 =?us-ascii?Q?4ypmJ0XeWyCFjoRIKKiqAJIAaA+FY3SHUpGcwxvX+PfAWd58icIqvkkfscet?=
 =?us-ascii?Q?4Yc3TUDYOGXtP6KInIzJGZiEqX34F0phG5NZKIhRAQzgeTtveekegKtiazTp?=
 =?us-ascii?Q?s4JjV1etrt0L2mM99joQRjrXAEYKQ0e26szgSS37uddsXUr3W5P5BT5uVvxH?=
 =?us-ascii?Q?4Qsmnc240w19A38cPxvKSiNkEnmnyYzxnJsGFD5VjjZMrX492jDd7PwyeX2G?=
 =?us-ascii?Q?tBaBq4OoTE9RFXHpYzTrpppj+XCyzzo2ZKvSRSQPzyrc6LFl3wjlVlosnGfS?=
 =?us-ascii?Q?CKekWVdkyVCSEtLAwGEBjTea?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a69876-5c77-4915-1b60-08d8eaa255b7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 06:43:41.8631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/JcXbo8He2Nf8ZfPo2d6T6rLvULv1OQ7FlJ1TOohUHltgzOIlZYjf5GEAzQ9kf+KgUkvyuuXQMCE7qHRz3F6EwsaYnEjV6MxNgF+J8djDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
irq_free_descs() will be eventually called to free irq and its descriptor.

In ice_resume(), ice_init_interrupt_scheme() is called to allocate new irqs.
However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap maybe
cannot be freed, if the irqs that released in ice_suspend() were reassigned
to other devices, which makes irq descriptor's affinity_notify lost.

So call ice_free_cpu_rx_rmap() before ice_clear_interrupt_scheme(), which
can make sure all irq_glue and cpu_rmap can be correctly released before
corresponding irq and descriptor are released.

Fix the following memory leak.

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
 drivers/net/ethernet/intel/ice/ice_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2c23c8f468a5..9c2d567a2534 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4568,6 +4568,7 @@ static int __maybe_unused ice_suspend(struct device *dev)
 			continue;
 		ice_vsi_free_q_vectors(pf->vsi[v]);
 	}
+	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
 	ice_clear_interrupt_scheme(pf);
 
 	pci_save_state(pdev);
-- 
2.14.5

