Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 502D76CB599
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjC1ExV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjC1ExP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:15 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020023.outbound.protection.outlook.com [52.101.61.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6402139;
        Mon, 27 Mar 2023 21:53:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRw2kVrKCF5ZhzxCApq8B0aL8VNeUvazaxsAjXf84BsU/IKgdjuvxTVyrNik22KMXCbmEsOldR34A7dV1u4xuJmJrp+gIfv3gZuxQHgOXSAeLTmKFuGIHPVEtKaVOl6NClBxBnej3K1IpUuGudy5ym4IX/aom9xSd9QTBoQJOHeIN5Xpoqfjp1cR237rU053wfRn7a1HjivaKZ3TA+rB9ZrL07E+0UBPJLkBrEi9sl4oK5Ce4ReU21MKShIl184OO+Il5T1cH+FC5y6Zo7se50IqCeFDA6GMe9R7bp41k8JpdeXrB8rHpxN/JD28bnhHKPKFUmcDDWz0KrxQoUhnFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+LurV+FUeNXwWGPJozwHjAJOkAQZ573EunRNVw6njA=;
 b=Le6UQgHoHn70VHqMmNKWhupk0eJRC0EIyZ6xsNV4XG7MNnrOmKTmfTAnBy+JhJ9nY3ZmcdvqGVA/jOHQ9cfD0UAOyZzKj0TscQ8EsgonxSO/qei9Ut4gjpMoRJFGo86epyDO4ol3p6UAvMiLzMEh/sZHRDiRsTdT4cAb39d4ZLI7ofNi/AMGB2xlkqFwWCmQbCWcugfB13pT6hcYWNEKc40IBTtgDe3KP/5nsCqrL21GsiNS6uEQFzvX1b1GeHDgPU5H/zWFm1r25svhKNvnXbt/lmbMykRTrlMSAEMAwWVifZWB5bHUGywLmDvnXX8hFD3dtFjd06MGeMG2kSxi5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+LurV+FUeNXwWGPJozwHjAJOkAQZ573EunRNVw6njA=;
 b=WnTjfKRocJDftxYA1NzqoWJPEvszCmrTVejm4IYWAYkcS/A/96fqnnEAqHUZwrsbfYoGsPfA9ocSdKmKXPmhaKOw+UkJYLUEY6xlGO5QSEzZ4fKEHgVwYNtXYNMg1CejUxBcr2ATFagrDDe1JPSPcZqIC1R93Gjz67rKzm7DrQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:11 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:10 +0000
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
Subject: [PATCH 3/6] PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
Date:   Mon, 27 Mar 2023 21:51:19 -0700
Message-Id: <20230328045122.25850-4-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8d7484dd-7374-4c01-0434-08db2f4854ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Gl9NRIUB/xsCvP9JKv1n19t+c7ixhP/rDrkuBJysmHdGgzCGpJCqN1VaojIfPRoUGF3McjIDUbBNOOseqaK3OlqAqmkhBDEZs7wqRk2+TvWicFr2cVPZZS+hizwJ+llho9AwHAEHE/chZ7vyLKyxZy/+SBY2rqjy4VMKq1l82SiNWwdVNtxdupz6FiDnkIXodZIxTQr/Afd9NNFtw5pz5DlbiLd6V2h/ghVb3E4byUT4LlDKJBPX7Ba0ovkWYPktf/XBCf5rDpyGVZhVkhFhPlaB/qaFzx9K+SPrniDbmbMU3BnbqJk7AogS2+KOMWPDtBB7e2wJbPg7qRiTRFf7ExtgbGIKTQcjfjhR6q7uDCvourMAZE3Jzrfu2je5enJfUd0aIyVzcavGV+rEQh679pJtHKkkJLATARslci9TI9X929nh9+2jzfV2M8ekAB/eTyOg+/eMeGBohKu6AEZbvlb0lb2+6V5OGohgGrmpiLzfJQ2lgCF61YDk6DMnWPo4Gc4yfLA6h/azFlOvrpwJJy1N0/ZpQeTKQ7JXdlnV8YbBLG9XCG5wD69ClRfKcvn+viO8MJNiwAheKoFW12y/e7inGpdMGJ8TxXjxwjh6mWuoLDlwHaova8fjddJAgnjLir3UyPHb0UGLMKTXoCFGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sTzcW86ITtseHJKJxTVpbjfDN02dd+TrxAVZ5hV3mZU01pr5Ex2RibKL63S3?=
 =?us-ascii?Q?23N/JHTnksiuYFMX+VAAz6QYKQNhqawCpZeG9JUc1MTgo1o6cLqmQYzaFQ09?=
 =?us-ascii?Q?tzP2rgkEkmQkFXmSmO5RiGxgvcfdQ9PRv+uTwE7U3Ntd41JtYo5qWMewcQFa?=
 =?us-ascii?Q?oFiQJ6XgU1WZAIpt78blRys2RxIBG69J/4AmbMM90t31qXWJUnSxy2WXMgn+?=
 =?us-ascii?Q?R/DKcihIXT1/NP4g4//QJPJAx7iLsJOTucYD83Y4phRc1avtiOa0GiVyKbL9?=
 =?us-ascii?Q?9PUAmscMHXAp21qhbLB3wAQilhKaAlIyNl32BLHif+PMXEDPu/HLPP1Rcc+O?=
 =?us-ascii?Q?smyX/sT+YjgBQ3sKUL2wGCSI76wBnGMfNVivLyPOziF30yY4bXr1CnDqY0XU?=
 =?us-ascii?Q?mHQsmeI1EhbJSBunP1CL7NMJwQloXNCdMPJ3sP8xfJN9aYTlyLBSawf6SBuB?=
 =?us-ascii?Q?lX8a+7bGeAf54JNdZGxMxbJPAIaBWA1mbpt2COcoPNSXOERN63Nu7410sJrP?=
 =?us-ascii?Q?w+ABHyFxld6HHB1TOn1Q6AVpqIyHhGEm7k/jJjVWuIA0+8N3oe5LtA0FoQnW?=
 =?us-ascii?Q?oAzMPQYQjXz1pKnZg9l1HwHbbjZb8TVPCVnSrBJkhFrS4qafkQiTnOSOCKVw?=
 =?us-ascii?Q?zZnNSeBRKmC03ewpskb9ktck/yXe/0g61e6NBmRaVMYlPPaOIQUllgYzz2zG?=
 =?us-ascii?Q?cxs4TnVGYEJIWgZiPS6THjfDnbd70DTTw9zY+Ko0WWzBugVNM6PpJv2atOq/?=
 =?us-ascii?Q?VGHdb1VK+rAuO1IP0C6XwW5IGL0JGE+SyRPIX6WxGuW7zi9fJzIxbdEmXzpa?=
 =?us-ascii?Q?ey1waJtdk605G3lbBIvYbwXKUwhdrU+AM+jJ/jaZVyLRlk6TDCkc4wN3w5Qm?=
 =?us-ascii?Q?UHeBYyAIyjuBWwtSzLMHvmx1iGiG1fKtq1+oBHW9aa6PPVRQvD4suIMQh8VN?=
 =?us-ascii?Q?E/yz5v8bZd1Boiu+FAIkty9lasn4rtobdi3EIn0cnrAG0RUoa0cdNc4zsks/?=
 =?us-ascii?Q?JxflX9E4366tp8AZzRiXrcWU0XsAYT5qezPV4uQAc7+VEx1cQplQ6XZ+AJHe?=
 =?us-ascii?Q?+zsKnNlK9Y2KSWpEJYFnYxCZ0vt5ViTRW5qhpZzfVnsDdVkK1z5eoRr+Ros/?=
 =?us-ascii?Q?vuxl/WaRZLbHolF0uOzV+egyQnetMF91j67egEXjg4FaSC/3iH1xVVbRnc+H?=
 =?us-ascii?Q?WWLExFtlfDpsrl0KmJwzR+lIcPZAUN7aCQ5wry9qqMwbU0k3vnbJRokgd6q0?=
 =?us-ascii?Q?P7+kIqUG91wMqqyD3lxP+mY4Nfc0pKF4voxhNr8xa3yv2nJhDGWUTqyjFC8n?=
 =?us-ascii?Q?3CKIZg5phcmzgR9DaFoOmr9bT8KwZ9O5wDoqQwo42eB/nqzc5noiROTnzSKg?=
 =?us-ascii?Q?0mfkbuag/Cfmb8vBIxxYrCbk6VzJirdxwM0xxZSKQyIopbSIcvwaWebNFur9?=
 =?us-ascii?Q?sGUqEKFWedqiA4PfurGdPEKkjc80i8GC/eKm6hRBxr0q+WCBgb9dt4V2Us6F?=
 =?us-ascii?Q?XbI93RqQM51FQP10zTLG8euS6HgxZFDIFefSbevDqy5QFeW/xbtvVdg3+mI5?=
 =?us-ascii?Q?iTU3rXz708fZtVVxNcKK9c4nam1C+m14uzrQR4yH2KVu4oBhNalplvjziAdu?=
 =?us-ascii?Q?VweLvUiRRtzv8G1ynYb5A/XGrMIqkG+t3R6T8YLZbeBx?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7484dd-7374-4c01-0434-08db2f4854ae
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:10.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv8TId7ue8jIBdHYyYbsrnCwGqk9fxx7y0WC6eURJWi2QoMGPMHHC/KsJZpR9SToHrlEK0ho75Af2E+9PLb/Gw==
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

The hpdev->state is never really useful. The only use in
hv_pci_eject_device() and hv_eject_device_work() is not really necessary.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/pci/controller/pci-hyperv.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 1b11cf739193..46df6d093d68 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -553,19 +553,10 @@ struct hv_dr_state {
 	struct hv_pcidev_description func[];
 };
 
-enum hv_pcichild_state {
-	hv_pcichild_init = 0,
-	hv_pcichild_requirements,
-	hv_pcichild_resourced,
-	hv_pcichild_ejecting,
-	hv_pcichild_maximum
-};
-
 struct hv_pci_dev {
 	/* List protected by pci_rescan_remove_lock */
 	struct list_head list_entry;
 	refcount_t refs;
-	enum hv_pcichild_state state;
 	struct pci_slot *pci_slot;
 	struct hv_pcidev_description desc;
 	bool reported_missing;
@@ -2750,8 +2741,6 @@ static void hv_eject_device_work(struct work_struct *work)
 	hpdev = container_of(work, struct hv_pci_dev, wrk);
 	hbus = hpdev->hbus;
 
-	WARN_ON(hpdev->state != hv_pcichild_ejecting);
-
 	/*
 	 * Ejection can come before or after the PCI bus has been set up, so
 	 * attempt to find it and tear down the bus state, if it exists.  This
@@ -2808,7 +2797,6 @@ static void hv_pci_eject_device(struct hv_pci_dev *hpdev)
 		return;
 	}
 
-	hpdev->state = hv_pcichild_ejecting;
 	get_pcichild(hpdev);
 	INIT_WORK(&hpdev->wrk, hv_eject_device_work);
 	queue_work(hbus->wq, &hpdev->wrk);
-- 
2.25.1

