Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64C76E8820
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjDTClh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbjDTCl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:26 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021022.outbound.protection.outlook.com [52.101.57.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D20F9;
        Wed, 19 Apr 2023 19:41:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHiHC33NZ8SCDytbIc2iOt1SPbdXOVV/raxFFfCGxFmaEG08MNV9T56BaQFpcIsMJIFfQkWy3gpHFGfagb4B+nMOROzT8EiENJ2+jxbuISi52F2elc4xrYBZLhQad2OIy/Ap0008JkFpy89v63x5Xv/p6KesdCw8hducj3RRbVbceohRlOG0Q2ZL2lWV8lbdSyVKDWVLUPOY0mNNWyjD1XgBtuJOySDJqjME8zQ5wHWIC3kLUL+UZo9gACI71Avke+lAeZg3A/gm8M4IL2a2SRNJ5J8FOIzCwULXzU/UjRF/Yw+Mk8F9NA7W3Shp80nzkysm8vF4vuHvtMBgRmRHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOtyolTiZvROuvCdIoKLhmvPeieVpPdw+Netk63t3oY=;
 b=m3Ey96bCfnb7AuauFZYG9pBnKwrFXNik8lxBlY9t6oJdpY6W3iDhSMaQA7cMOZEPdJsuJ33VV6h3lPkdFy/+b3ObEzpU88Tb/FLosulftsjEjJeN5DxK9UesRsBai99z5/mehnbg5UFT0TZucWf6ywPtkNTlL7hKJEQLIqNNosQcmgGSsb9Qz82t3qYjpUufNyq5/ti7MinkB42xq18u82xt4u55gaOt5aRcXtXcnrz5aqV2xo1ySXVoZ1Yyr7TcVGdzz1Yx2ePAM8WHp2LTCLRKs4fz7vMnxn7blfUjBrleBSyxdFh5HVkuqBWsZL+szA8M7MLvLYqyN5MFzga4MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOtyolTiZvROuvCdIoKLhmvPeieVpPdw+Netk63t3oY=;
 b=I3KjXOVh/IvRg+D2UOAtaFT9zMoW1l6IM9mnDmNUMyTn/nEe81YVaOCldz7/g8uzeYbk1n1Crg0P29cU4/+99ZgNAN3Adl0dqmNbtVCHnxxXbyc5NNS1aJv7yic2XEP6zfyvA86sbUMqKYZ/dWjj2tcl5jXDmHQ5+/qHX8tvkF8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:18 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:18 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     bhelgaas@google.com, davem@davemloft.net, decui@microsoft.com,
        edumazet@google.com, haiyangz@microsoft.com, jakeo@microsoft.com,
        kuba@kernel.org, kw@linux.com, kys@microsoft.com, leon@kernel.org,
        linux-pci@vger.kernel.org, lpieralisi@kernel.org,
        mikelley@microsoft.com, pabeni@redhat.com, robh@kernel.org,
        saeedm@nvidia.com, wei.liu@kernel.org, longli@microsoft.com,
        boqun.feng@gmail.com, ssengar@microsoft.com, helgaas@kernel.org
Cc:     linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        josete@microsoft.com, stable@vger.kernel.org
Subject: [PATCH v3 3/6] PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
Date:   Wed, 19 Apr 2023 19:40:34 -0700
Message-Id: <20230420024037.5921-4-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230420024037.5921-1-decui@microsoft.com>
References: <20230420024037.5921-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::28) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|SJ1PR21MB3411:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b09d1b-1ac5-463e-11dd-08db4148b7ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eyr6mY8JQYRf5mx1rADNVbeoyggPjkDBhx5s9qTNkgiCjODNTCrgwEJA8fXt9jew8A5whM+zH2wrZhaVl0KtI0/smoq57msT2I5A/odx7vRsLOwKkDGAz/oGyXCMBRtu4vhsgsMP0qbl8W6+CZ0hAQO1bK0HQmnv7IngcjS5LzqP3aHCr0zLg/XZMiUBxSvuw27Ykycq9Pm46S41V05ajEXt9X1CH6D5RHC8lj3KcxvNjaOjeDhkbTGR+Use7lORdoRQ+a65Fao/ZLLkNGobfnBf6WFIhhWn6e9vG+ikPL6ZFNkDGXTok1CDmcxYd3t/FAxILpd3TKnsVLPXmlzNuk/r5y5yUp6CuT450ewMqvDjf74mMubvVqzmbUjOpFxD/cidvsayaYG6SsYbum+TKwBB5gOYAf1WDXtSVrYYQeddkHIIv3IrA3AWWcgWOWnuOtiDY3GcTqDIunkKReJNZlwTR/+Ew2P3bWgf0WI2oa3o6oLT+pbA9tAbjHU6yQzpLfwozX0fj816lSIYpMp7QsuHcEClki1jW4Osvr30Bg5GU8wW0pQxtxPHPKJ0GtA46vvOFM/XhsI9qKFMA2mHso/eqjGil7R0BQF+4AcB90JYi/X1GxEgikBPdj2kr//giP+KjdiDgRmmFr3UNzq3+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cx4GsA7wEYoBb1ccq6QrRIfscPRb6gASpNTwLEXWNG+8iWcZ+7qHT7D09DMA?=
 =?us-ascii?Q?Lnb+PO4c5tXvuIsEPPEaqec22W9MI1XAdTo1vi956In0MXqkpAW3YiWmM4Z2?=
 =?us-ascii?Q?+8X1yBV273rHxffOk8Lm7dIV8mIFyY+d2+BkiVAGQ7OAFe+2g44GDc7BhEiN?=
 =?us-ascii?Q?+1j5WhHw2oVFv29xuB+y9lAi/stgMbc0rrpgKBznH0LgfRHk5ufqk4pylrfo?=
 =?us-ascii?Q?w+hXDOCG+2eVHhqOHzcwqhptPnc2Yxav108FH2qR+eIWMbWgzQ8ReNtllXgq?=
 =?us-ascii?Q?+VIAHGlyyOiTI3wNaB7+xAy7hqDpYraVibNFi0MFck8Z3lhL/G7Rko0TOtlg?=
 =?us-ascii?Q?bfeBUaSLXqNvE1VHcYglO3dIAO3AetDz4RYyQdmid0Ndgs8SCdi0LhsWcYiK?=
 =?us-ascii?Q?ct3ClVbVO56pt8uGXEQ26o72Agv27+U49clp9qyxXUTefwqNSviExo3P/9xD?=
 =?us-ascii?Q?5ZNe4KsD4JK1IgAhl685LcTwx8OLNGxuqtYz2Pgbxs/mFt660iUGq5TMzhSy?=
 =?us-ascii?Q?55ZILmK9nlYP3jYQL75JCTUhltN6m2C2x1ukSFv3wFnaFrcW+Mll5TeJMtKT?=
 =?us-ascii?Q?0TW94kzvQGdd7bbSuSEX1xN33KWmboM5XDP6gB11MzjV3tk6L8pPVDPGNSX2?=
 =?us-ascii?Q?z4nvhYvVlJ2Pek5oRBBsacwblMlZbCJFqHxkYn2dkDU+8usIZzBuMuQFki6R?=
 =?us-ascii?Q?+YUSzhBbOwsKayuos4Ucqpjn8iLoqTCeeaP4qczaLaMWykgxQ84XjSc9dGpY?=
 =?us-ascii?Q?WjvOiQEFm7MsLOK8C1aPvDtBBgyfBVQlRSKm987bVhadis/toCIQZ1SYe8Rm?=
 =?us-ascii?Q?1kp6tE/hTnxIM1aEXUbe710WVdqxyHQV5LQLzSmxnczLJnepORqM1oMfQw+I?=
 =?us-ascii?Q?NXZ5bdn4EthmV315IAQzhGRlNmXBqW7+HYzzjKMHF+vGL5SYdW1B7fPu5b6y?=
 =?us-ascii?Q?WyWKUWS+uOHCjt+RzPQa8EKMi8bU+VR5yCHybZsNjc44F4XVBBlqWjzvXxDA?=
 =?us-ascii?Q?7cYBz2JDXi+uGlc12Tv70A4s1LEHGNDNqWhKTy/013tCD/sJ/m2WMYnVgHwV?=
 =?us-ascii?Q?Pu856bI3/KBAC8m3m7SODUFnbElWCe94MsgnuADHLwBzcbyQ7OBJniOc2Aik?=
 =?us-ascii?Q?qKkM67K198+nRiN/j27A3ViQMEnsAwb8bYXA5baB0GjH3fMabIHrkXkEXuy0?=
 =?us-ascii?Q?3avl4HjzNgQG3EIUcADSqLkEVcMdRogYoLcuisOioViLSJiLQN+GejvNXw9v?=
 =?us-ascii?Q?Bvn1qTZplHzcOuqx5PYPswm/xhYYU64uR96xhCX8PMMN/0QILMkY947UfLKf?=
 =?us-ascii?Q?KWIOak3XTrVdAxOVsFLjYpoya/LuWa47VOv3tOS0Bwef/imVKLGbrVbBkJam?=
 =?us-ascii?Q?w+sAyVlyvF1nDRoHmVB6hIfBWrbbX7YOP/VY+aZRXCGb5M1JthRobIxUypjN?=
 =?us-ascii?Q?IsgmMhzd2RPXdo/TsV+MHUNrom4VHWVxAACV3ce7nqoH5iVMIjZTh7QxqrWV?=
 =?us-ascii?Q?suChNn9TN/wJb5pqvDEFhlXChcyv+pvxnRLxxTZXGA0+15O4iIxCxTlGQQLK?=
 =?us-ascii?Q?RJiV/bRsUula+/uyGxWz5xzUgnmN1F+0aRv8RMft0FVK9gX2w7d40DM+5w95?=
 =?us-ascii?Q?aLh9HbvD1hRSIOSQlBgJK41A1+cMNEm8mC8BuwnRGidB?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b09d1b-1ac5-463e-11dd-08db4148b7ab
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:17.9618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SaNPadS+rcD5r+A7+LD3xJFeF5ThoGGWoNv7TE2tebY4WjJWqjNlZ4c5ybitKeFpgIar4L/wtAg7DvMiginEhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3411
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hpdev->state is never really useful. The only use in
hv_pci_eject_device() and hv_eject_device_work() is not really necessary.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

 drivers/pci/controller/pci-hyperv.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 1b11cf7391933..46df6d093d683 100644
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

