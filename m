Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581E3343A6F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCVHS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:18:29 -0400
Received: from mail-eopbgr760072.outbound.protection.outlook.com ([40.107.76.72]:50326
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229822AbhCVHSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 03:18:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ6wFjLVk48pN+NMYPJtKbkqeBAcWtCe/PbKiobjTcpavAhqQkovPsnAp1V41FaEO4kgzPQUeF0kD+Cb0nVkkO4clyI2BjvrkmGJ8FBOwU8DALrf+J2ChvHHGzLMjwuY0lJ3D3BqFssJgDN3nP9EtXs2vZ/RJSFN2Nv+UV7LlGgq9RdAVTp7CZSHTd3lnIS8s++R0bWolEmJyX/VXUC6tNh+R8EGZlC4/s+LfPQGA7qigk7CG/ogNgP2RjvfxxIs59ABHO6ZFNBdIVqWARBbtQ313DbXDUS5IdUwEYXSu+uMgCiqtwTsGbrqde3mD2/PGArOjSHJLOW4keM/sa+kgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMgAN3skDtOkQACoJ8REUngygs6eZnMJIngesIAlgw8=;
 b=VxHSDd6K5+iWKP5AWcFVGqRm4cClkJjduD7VhmA207Qsx9dZd3nioYOd6V7z+c5+qL5ayg51+wc2jSEWZXwNCRDBkVNyCmKCS1FfpfvhH7cm6zuI5pG17x2OjPjtYvMA2ag4at2RamwPYUNSa2LMFyRhNpdDR49IifQi45lO3DSs7pxfh15lFY8doZx1TycCnt/vtmNIOQCbxUUTOcXv5Ly7mpgfmyJooTNiAHjTfIL7TxvyQBgGjBo6RezXVkAr3j1+i3H3ar6Wy+S/laiC/iOqlmOpl+RgeehedFB65s2xo1GQFEgE8W6EA6aZ6H11x3Je6GjPtGmw/WYwKMh5QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMgAN3skDtOkQACoJ8REUngygs6eZnMJIngesIAlgw8=;
 b=BCO0T4XXYerInHHuQ/I0zAVW/HR1UFDx5Yea8i6tGfZA1FgWRAtDravPLYSmZH5UFZg03YV5sTWFYnn2WVKaYggBjmgFUQ2d1ACz2ZyuNa/0eoxurvsYtL5kJ9TpX8u+zEoezQkRYSK+d7FEzR4d0ydn/nCZzwE5FWNLnOJPcLw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.23; Mon, 22 Mar
 2021 07:18:03 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f%7]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 07:18:03 +0000
From:   Yongxin Liu <yongxin.liu@windriver.com>
To:     vaibhavgupta40@gmail.com, andrewx.bowers@intel.com,
        anthony.l.nguyen@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org
Subject: [PATCH net] ixgbe: fix unbalanced device enable/disable in suspend/resume
Date:   Mon, 22 Mar 2021 15:14:48 +0800
Message-Id: <20210322071448.12023-1-yongxin.liu@windriver.com>
X-Mailer: git-send-email 2.14.5
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2P15301CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::19) To PH0PR11MB5175.namprd11.prod.outlook.com
 (2603:10b6:510:3d::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp6.wrs.com (60.247.85.82) by HK2P15301CA0009.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.1 via Frontend Transport; Mon, 22 Mar 2021 07:17:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c098c2a-c737-48b3-7bb5-08d8ed02a16e
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4952D8666D5D60E6A5CA08B9E5659@PH0PR11MB4952.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FLD/e2ICrjit9hLntnkA+KfDqUy4kthMXuLDNxvy0DOYryrp9F9wR+zfQEUYZnWx+3oIP3t5vNWkSnbAifUtHdGet5BxBEa5AVtVHsQ1k3WRzmB944erpls5sQd+Wp+0A5xHPwZrFBEjfrRv50cS18JKYroo6pOCpwoi04w+9AH2oHKJ5bo9KQiVwHurbaD1+MnhwGAodBe2W3d9JBIouezMDe5A5K0zLnzGyqXKvfTzn0SeXjpjat00IwAaq+UGAYpHkKUAtJ/kKY6qpNUIiyYHhaQm6rGd661CoPrTwC6OGSkYLuEBPfTDAvnYUVxnpmbi/iIlhYPRq8aCKkTZOZwgVZPRbTYX1bEASQr4rux6EW+GJvgwbsHShNnEuCB1N3UyZl83LgE2JC9Gx0DotW+nMslw+lUtOARpsFuUZW3yvvAoqgt3pIEeXP4mVcmbgXRYTtVV6RdLYesPlLsVpasu/5FrapYUCUg7iTkVfJeIxULeCxen5ZCQKQwmeWS6qM5wPWdKUkKLNNi8Tc+XLJsBB75/rbEoSuvSMuex6VC/0+8DA6MhlgEoS/qQLpuQ6emSO36IN6zEjTQxOD4nVnTxxgvC4mbsphh3u/aT5vJSTfRkReH/NS8cIkadEJoemZtSaJ+1LllvhjBQ33TvPYhU+Zg1PuFl6As35e+rBl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39840400004)(376002)(136003)(366004)(186003)(52116002)(44832011)(83380400001)(66946007)(16526019)(4326008)(66476007)(26005)(6486002)(5660300002)(1076003)(66556008)(6506007)(2616005)(2906002)(956004)(478600001)(15650500001)(8936002)(6666004)(316002)(6512007)(86362001)(38100700001)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xX3Vy7BsS6Qk1WGOEGWBeH5QrCme3pJ2pbZJv/YdnlNk68tO/wIVQzLhapsb?=
 =?us-ascii?Q?u6Vfz8s+lo3AAdqH/Oan4DbGvUJutHaYBP908kM9Jc42X1RqmejZhLRsDTct?=
 =?us-ascii?Q?mdeiqZEcRGOqweQhpI+a/1nEXAk6iCnw82JXIJNLz39+8jhI7ZiPEbcf2nw7?=
 =?us-ascii?Q?lYaktusOMdQXcd4699Q+pqYO4kSlKsH7J/A2/CWGGiblrSmbLsnSzrdcaD7H?=
 =?us-ascii?Q?ZwiaZ/KAhB0i+m7qiJj7JviN33ENhGmWUAS/2U5Ro7NuIIVuOk8D+PMZisw5?=
 =?us-ascii?Q?aUw+s+GhZ40fSWf2pLbOjsvAzC9STTjv+l1EIZ2EXeHGZ3Sc4JJXxxqNjaur?=
 =?us-ascii?Q?ifRyel4f+vWBzB3N2zM3CnisdK0BYnvzUh/q5AtPC73r3ATIR5OUe8ngsckk?=
 =?us-ascii?Q?IzwyQVPwOP++ST4kf5QfezGFWOEhctxNmcTGMrxTBpnXzvEEAO49kvcfpEqo?=
 =?us-ascii?Q?Bn0WGOAF+HASSoetEs6XAYY4HU3LiFz/wpNRzis7p4jsdc04HJg3cvTm+1MS?=
 =?us-ascii?Q?cvsMab6gokniY9faccz1m57GUbExMn7HEi+3rbh5rgHPC4lQ1mvWuyqQhRcu?=
 =?us-ascii?Q?3Yhd/Bl8M6Ox6okB7h9PCow7dA+xMGpBjKku9CKLUv2/punJO8eeJV0xB9cr?=
 =?us-ascii?Q?U2KJGOfu1PR3MouI+uN1FjeEyiyTMWOmJlLaQJUk84qRvY0/ngesUDVV1GVq?=
 =?us-ascii?Q?mupL7i5Ex94Kej+oWYEgnm2I+CmMfVfKef4l8KzduSS4SDO0ULt0xIj7Qvdo?=
 =?us-ascii?Q?nhaCWEXPCCqpJ2vauPbg7XK+uVz+NtRuLD2DFZxoi+fdRwTx3j1InzPXpMft?=
 =?us-ascii?Q?qcc1vKuU4UMMcX9DQmyV/yLz5aGwGnTI6cU0bAff74yQE7LllNDRtX57fxlC?=
 =?us-ascii?Q?E0dl2cOBwt8Oxx+x9LqFcZlLge88r3CrGI34HFuyHI9f5CgN1gWgukFw0b9t?=
 =?us-ascii?Q?gsXqEgk3ecXH1GWMjvSbnfttB+BDGuzNxraanA2Vx9C5zUgqF5bbjE5iXst9?=
 =?us-ascii?Q?8EoxjGLuMt2NnkWQOMTUWwYLjz4etRKPpdlEVZbi2O/BhXWZnmSKMio2C0U1?=
 =?us-ascii?Q?h6davxIRvopQYbhHekGPLcC2oZLsk+au7BGlV2sKrO7nwUNNkniaySHcLmWr?=
 =?us-ascii?Q?x36SGiNvAEA9dAYXYPMp+azbj8N+VwKJWpbkRlcgT+4rRyr8FQ8DW8pYRhbP?=
 =?us-ascii?Q?DIjMaFgVG1LHGSK0OeTBukmHx7cak4IN+8ipuu4JyVi2ar98/aoVvpfZTeSX?=
 =?us-ascii?Q?e1+718XQ9ULgODNf2SlHbHuJHKknDFc3bLD2En4RLjUXnGP7pW/YDMLBdc2R?=
 =?us-ascii?Q?4vO123oOI8GkldBrk8C+JiTC?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c098c2a-c737-48b3-7bb5-08d8ed02a16e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 07:18:02.8876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJEVlExFMytWudFnsf6SxCkMIMlkqHgA/htc+83nUSN9reefgd86090NRwAeV21GulXhOfsU19wKLKSRPwY8wHXBTI6903L9hiCzGRquFnE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4952
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_disable_device() called in __ixgbe_shutdown() decreases
dev->enable_cnt by 1. pci_enable_device_mem() which increases
dev->enable_cnt by 1, was removed from ixgbe_resume() in commit
6f82b2558735 ("ixgbe: use generic power management"). This caused
unbalanced increase/decrease. So add pci_enable_device_mem() back.

Fix the following call trace.

  ixgbe 0000:17:00.1: disabling already-disabled device
  Call Trace:
   __ixgbe_shutdown+0x10a/0x1e0 [ixgbe]
   ixgbe_suspend+0x32/0x70 [ixgbe]
   pci_pm_suspend+0x87/0x160
   ? pci_pm_freeze+0xd0/0xd0
   dpm_run_callback+0x42/0x170
   __device_suspend+0x114/0x460
   async_suspend+0x1f/0xa0
   async_run_entry_fn+0x3c/0xf0
   process_one_work+0x1dd/0x410
   worker_thread+0x34/0x3f0
   ? cancel_delayed_work+0x90/0x90
   kthread+0x14c/0x170
   ? kthread_park+0x90/0x90
   ret_from_fork+0x1f/0x30

Fixes: 6f82b2558735 ("ixgbe: use generic power management")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 9f3f12e2ccf2..b0a8f7a43f06 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6891,6 +6891,11 @@ static int __maybe_unused ixgbe_resume(struct device *dev_d)
 
 	adapter->hw.hw_addr = adapter->io_addr;
 
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		e_dev_err("Cannot enable PCI device from suspend\n");
+		return err;
+	}
 	smp_mb__before_atomic();
 	clear_bit(__IXGBE_DISABLED, &adapter->state);
 	pci_set_master(pdev);
-- 
2.14.5

