Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DE66CB5AC
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbjC1EyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjC1EyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:54:01 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84139359B;
        Mon, 27 Mar 2023 21:53:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSOg86jc0Hp9KYB4v/qdQss0utKoHWV2FpjI3d6rF9BGyBLU15oxoMPs1DPM0FtETYjtBAkpn3i1meJBfKA3E0UQEZVEAMDnA9OLCo5StsH3cZtydMlqfCYwhOdqQ+BEY+3cTzUDul+Q7W5LX5saE2oQt+D94jK+/WdZ9PVN/WkLcmvFNumCTJZfqC+vDmxEYSZRD5en4LIRsp4L0ssKkJ0E+g9vYNmMVaZ/jvMPNAf3beCAsbuxDvYj3L/Cxm/JtaVMRr06A188BBdWXTcG9eFoo0wvGEg7yZwKXmMG6XVMXS6A/XSpsoE9582lKQ5uEXzsm0DYduLdHNiqLoKgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXf8oCsuD4692IF7aE7rV9LfnreLFzYWT+HaqSiheDY=;
 b=Rbd68lbuiAUD+jxO3RzOhBFfW3pfoKmySJNVzyNNyLgmqIdnoFqNkx3I/BSZWYF5Dyb69/i47i5wMg+G2sz4Rd5LxsKxURO1eBGZ9X2i2iG0eVjCqYVuVJIhRReIIc4gv8L548Z6pmgBQQBpbpdGeVaMrht642M9cenxkAF6gpxoLXAfqUqKIxr8zmL9RS7+exH3X1fno4a7sSqJdjS9YAKGHtM5VhMs2x0y2Pt43+WIJw09NGGO1HnPXQjaePfO4BBN4n55djlO2DVyh7knvs2jAyvPXMSEVmEKAlncRnrCAMVVcxenxuX/1Np1RdJKrcmoKddHPXoHGQs2p2DdfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXf8oCsuD4692IF7aE7rV9LfnreLFzYWT+HaqSiheDY=;
 b=ibVMLhbb89Z7cxPoT5Mw60Sc5GuhxH1lBvusouw6g12aiSa6Aop548Zimx6ES7Rn6z1JyHqVvCWffsNx6XfOD3sx/X3ETGklloNFJ5tI2alr1fFXOkbhx6nt+cvGN0idLMtPuvpkG8KcxHWMd8DiT0FBXKVjzML4a2yme0Zl7rU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:17 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:16 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 6/6] PCI: hv: Use async probing to reduce boot time
Date:   Mon, 27 Mar 2023 21:51:22 -0700
Message-Id: <20230328045122.25850-7-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230328045122.25850-1-decui@microsoft.com>
References: <20230328045122.25850-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:303:8f::18) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|IA1PR21MB3402:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1fdca0-8564-407e-156c-08db2f48583f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYisbpc0bDwYSxSA6V3obTuoYZJIZYZ17F3cFNhWmN49uxepQvO0h9jR5KtujTVrvu3mEWJ1DJiLtRZ9YmCHAeZnWCX7ViC6pJgki2jNV57eDBSnST1mGAfWR8rtg7S9ToOB0OFFq5Wl5cfz6ToRVPFXWqK4wD1E4cC21Y/ZXdeuppaQUwWjDwVYA2/80fDAa7VLl1nVP3JFyoseFAaP7GxtsySRjvzOY81ZmUrpykHUY/8eSuK7YGwyEHeMn5DLi3kxzrB+4nBzvcKZIZELX36ER+ZIkP7xP95XwBXMZXOmJ9vx2me6SxGRbigNXlciAMTvARsS/wDw5oVtF+8v2BVOPsDVW/knRaf4LZkG8Yb4nYVcPacHalvztmtUPZAQY/jtHqtVdPVY7zw+3wxXYqUq5Sqi6p2pMkcVaWsqnNjRdV5HoP3F1O14fIZI+zCqOdl6z83quqIbZ80oSa+xjF6cVYSlLPvowaq+51r96DcC3/SN1rrjxxwxRuEmTGJUupLkKv2Pc7dV7+wNK1GyCAO67bPla/OYt5tVp6ySwpcfSL1RLillC5Rl7bFqq8DkLjlKsC+wNaY/fHQEXFzPrmlL0ljyT9rfgHaR/3R0brX+DpU3abWr/Bg6dPylUfMda3YInsAYts2DFSPO6fs3hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ZbUgDbTABzt3+Z8t5SwESveP2pXTa2B7bIU3x8K2P5zn1vMWoJChRdxsIbd?=
 =?us-ascii?Q?tID9YYLwCzYt59+4h2OX16eFttRJkYFhIeno3gzb9mCYEZ6h22KBLb36sNwh?=
 =?us-ascii?Q?Us2dV6aNmVzN7AWj2JU+mKrdsDntKZZ/KpHktBg5SiSke55Ocbz/Y5IKKUkq?=
 =?us-ascii?Q?VVrpJOG4fZI3varuxDAbrwZQXm+/j563hQiR3Ew5DhJcr8mkzBEbklpgmyv+?=
 =?us-ascii?Q?GMzx4XDbck5lQgxUuxzriqqtjMGXCPpzW/XQv6WnijXm36yhx0H8hRQjZJcD?=
 =?us-ascii?Q?2QqwaAtmaWQ56cF+SVcAOzFupGv2xn4HHOWjc24FksBApS/A8X0cIAZHVZlv?=
 =?us-ascii?Q?HHAxBNYM84x8gQl+O++aB1EEyYUI8DMp5497XOaggopunxugDBCE6gUKYLo3?=
 =?us-ascii?Q?2i5fRe3YayTQHifwCyt/qvzaLieu6euUudrtN76H5p8wuNLTALgIAomGMlKA?=
 =?us-ascii?Q?VmzTLdKDAIcdy8/gWvlg6cJl35ujvFIMRybuQmbBOXjXYmEOSjW9DmI4hdKp?=
 =?us-ascii?Q?Il8AvgGVIREgze4X6MCGtjDo4OxuRNeENt1JkFG4o1srefXHxGzu/k+JhBxz?=
 =?us-ascii?Q?gu/HImN7GqCU/ln/uyQze4UKXdxvpEio9JZm426v/+PCwGm4YJHQyyzG+h/n?=
 =?us-ascii?Q?wNHC2n7XWSnoiJ9/Y3PRablhxGPo8ABqyhKsi8HMt6Pz5UrPdTl+8Gm6EwEB?=
 =?us-ascii?Q?38oMC3gCBR8ChhoUEZ92XjrE2MSHQ/oBQOvxLEekncst8bsDluS1jXzQFikq?=
 =?us-ascii?Q?IBi0PjC6zDCtOh+YE/0oqjNLcTB0yMpANG7XRSYa/ku1CQ+x9d6mupFsUHGu?=
 =?us-ascii?Q?HxbH175jaY/8kIxIV8V6eS/h1vn7M4+O+G+UIPtjd9JrpFq9ieLAe0B0VfzO?=
 =?us-ascii?Q?u6yfApIBC2H+Wj1KPh1FRyWsDOmspCAe1GvZNQBWGInWeyc98XpwaIKQOyMF?=
 =?us-ascii?Q?XdIf5QhvgSdApp0X/YOxW0RIomCAhypxxT82E4yMw2QGAZdUqD5uk93ByOLt?=
 =?us-ascii?Q?+TCym0ZFSzaU4UXZHq+Rh8dUiHmf3+C7zmjEryaIN97/Xw69ZwWqhNtjPAlF?=
 =?us-ascii?Q?ZxhRnLNqatn2mKz9lDHYuewEb9PA9JqdBAZFrYEubohYQLVll0J2GzBQPDvQ?=
 =?us-ascii?Q?NVaf7DFzGN63fO6CeMELClD9bJG6vwlWU3JpmVyKCeTr8czv8geqQguuVqeG?=
 =?us-ascii?Q?SROerupmP1bNTTHk60PNGrUdfDsXBNHh1v/rLdYhNTB9fuw6Vq24XEtotJTu?=
 =?us-ascii?Q?UlMoDrjVfrcbnoGeFoZy1wyPYNjy4teH5RLLgNAQweGih4Ahwn4XI4XkLv3k?=
 =?us-ascii?Q?ZAKMK77xA92Njk6qG495Ds2pu3gXiv+NAbYcVT8U8Nt8t2bfTsMjwsFdRWbX?=
 =?us-ascii?Q?1VNIkCPiJa+H4xlJE2EEL/gDAOGrj8YcB6lyQz8FRyY7tY43+RD0kvcNOlqx?=
 =?us-ascii?Q?9xHpd4gE3AWHLuFW7JTeYATSSWcYXWsqBV5jRVb9Tr/DeaThhRkM7Amv5qgX?=
 =?us-ascii?Q?RGZrhwuQJqih4s0Dz5QiZ8RAYqT+cQLOGa93kCa+OFqCVFJSAn0NfyMk3IvJ?=
 =?us-ascii?Q?a1fQJGCLqtAyClEkdRbrplXX7IN8WCp5ykISxCkGEovT7X+rNzMyBJ8F5TTw?=
 =?us-ascii?Q?TYwEIhyD7xH+eTAZn0J7eu5wT3AHPDnxtMFBWk8yfiRM?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1fdca0-8564-407e-156c-08db2f48583f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:16.8783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2zPvkLu+Qnetj1B4AXe4Ub1pBDFvZqDsmESES7EyKF7lFLhzGcnoXQYXRj+f0WIxgJf6hY7W6md3COMLKD+lBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3402
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added the
pci_lock_rescan_remove() and pci_unlock_rescan_remove() to address the
race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
doesn't really work well.

Now with hbus->state_lock and other fixes, the race is resolved, so
remove pci_{lock,unlock}_rescan_remove().

Also enable async probing to reduce boot time.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 2c0b86b20408..08ab389e27cc 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2312,12 +2312,16 @@ static int create_root_hv_pci_bus(struct hv_pcibus_device *hbus)
 	if (error)
 		return error;
 
-	pci_lock_rescan_remove();
+	/*
+	 * pci_lock_rescan_remove() and pci_unlock_rescan_remove() are
+	 * unnecessary here, because we hold the hbus->state_lock, meaning
+	 * hv_eject_device_work() and pci_devices_present_work() can't race
+	 * with create_root_hv_pci_bus().
+	 */
 	hv_pci_assign_numa_node(hbus);
 	pci_bus_assign_resources(bridge->bus);
 	hv_pci_assign_slots(hbus);
 	pci_bus_add_devices(bridge->bus);
-	pci_unlock_rescan_remove();
 	hbus->state = hv_pcibus_installed;
 	return 0;
 }
@@ -4003,6 +4007,9 @@ static struct hv_driver hv_pci_drv = {
 	.remove		= hv_pci_remove,
 	.suspend	= hv_pci_suspend,
 	.resume		= hv_pci_resume,
+	.driver = {
+		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
+	},
 };
 
 static void __exit exit_hv_pci_drv(void)
-- 
2.25.1

