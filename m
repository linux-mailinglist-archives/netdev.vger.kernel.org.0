Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4426E8817
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbjDTCl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbjDTClU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:20 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021022.outbound.protection.outlook.com [52.101.57.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE0B4EC3;
        Wed, 19 Apr 2023 19:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUbcBBXLRNeEPVdzKSBSCFkNfUpnVk0ElvPvR33vQ4IjSX/R+AjOL2SLSEIx54nIqzeHTFBXwm4dQ9MmA82Pi96nhmXQpvLxHbP1RV2lQ2UGdHNhEwASv7lYGPJrvx74Fl8RxEFVLzv5eC/IjhhxStjmPVtKV9FTmTkh1hoa+lJSzZ83uvD8rojBh6GXiLsl4pwwW+v5RtmSFA6nLcrVYvXpHGHO55RTRV+MMnBNO0kUu6dD6SLsr+w+xG9gVVVtMmo+Goby7EEn70s+0RFGrgdQ+9vdiLeft0H5qk49n+cXzGWDI/0SXnO5xKEl6Ie7WxhdBVRnEzK1cgw9Umz+Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qOPAMkZr4rtwbzpMhwxs/4UwiZWmjvSHb4CdQwyqS4=;
 b=Bs1ienACzmoC2iMN6Td3bJPaVdG8uLYMIyEmEN9Px2Rg+3CXz5p7T3vws+T2ZUpctNuP22Vkze3Q/WkkZNh+SGEmnmcloJQy+1+iHvyATlbl9KcPKFZ9Aoc/7MVGlbwoyadFq8btFvx234bVOC/7jzqYpZgOu6qzfJ7qvtZQ8D0+pY3tFGtQpLPEhOQgY6bK5H+9XhuVGmlspfNBAXi9CmcIRZoAZrK2JJJefzswUr5pruhKLkwcYkQb3Zx2i8mreTdkYeWPaLxyNLKmVn8p5VRDVRg1FYGFuyLo3btp/LH2FJ+5MtuzbC33r8MeLnwg+EGULbRiSdT9g2RjQN9rpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qOPAMkZr4rtwbzpMhwxs/4UwiZWmjvSHb4CdQwyqS4=;
 b=YCp7H84zJYOSe+J+80R2hVaJMuB0XGL2ohnnPz59CT887Ij3ugTKgdJqsRGcFmt8vLTAzXWu2yPDxo7Ccp9h7d4K1xYYzG6pmCqI4CqBgGWWoX4UaKQGz1LZlO9OAGZNmv4n57HqQCgYig34Fh1tz6dkrBXs/zrtKGhES1dn+1E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:15 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:15 +0000
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
Subject: [PATCH v3 2/6] PCI: hv: Fix a race condition in hv_irq_unmask() that can cause panic
Date:   Wed, 19 Apr 2023 19:40:33 -0700
Message-Id: <20230420024037.5921-3-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 71268da5-6bac-45dc-9f31-08db4148b64c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43AG5Ny/u0MFFsrA1XyCJrvbol9uB6YB5da7vVzZ7+/EeDgoOruyoFDOhLS8BK19IdoQpUyF2T6zJPYdAYiFL9r1qXKCKDZplUrwy/R79TW2cfWE3oSKrV6v+LQENEIwbETvv5K0FO9vQfHqvWncCZk7zh6QwloRCnCBXAPgIvpHMjXfpmAYgDdK0/bj0PWif8HVGpyuDeaNam971tFK8fAN96fYS74mFk7n2evsGfuKt1T7AqJnf6mbAgDrYG4hLUqB741n4u0R7oGvYnDFqerdLJWCFKj9I0ecZqKY9b9tWQDVFIbQOPtEPXRdgSx9S+0r6OQpuonlU8S0LCUGQ59AgZ8CVRJqHN4Cblr/U1J265wtYytAhX8tPOdKJsLtvCqHvirMsaWQbE6Q2cGxCA9FQDn2gJCV4WO2Fes7pU9hTnZfGuTQjTf2OR4PsKLhvP7qhV+QpgxLSa0L79rVZhKVg6v8t72N6JIsA6rcu1a14MibO106v3ponTmGEQowo/xKGp4XiqyES37PYPN+GRF9UuSqBIPaSUZTjSOq2PZSeu3/PPP0hsW3+UuCAymJWCqEfuX6hXrd06bLMmCa2SDdAbSTMOpomdyHWIc6FpC+MXFgI2gVhoOBAxLU+L+4BI4rLHlShef2BnTNKWGUyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(66899021)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBt1pE3KS2VxTaHw6c201QQnmwupheTd9rqzb2x8XtyC90SVMq+AdwjA38v0?=
 =?us-ascii?Q?SPyA7mVSZ5tuUAcvZVDqvqnofN7rObWk/ZoYDee9Ly4EP3lQgUkqOMwGbd50?=
 =?us-ascii?Q?K/QGD2GWObmvdDXlPzoteASvgDAlVIQou/9Ax/naI/kAti9P9eeMvr3T9RIx?=
 =?us-ascii?Q?YhiB5G2t4AOFW0YBusRhHHUC4DSUk1hoLoN81n+0Gl3VBGD0e3JV7WJFBSq4?=
 =?us-ascii?Q?BQCf5U6hqed1SEO65IMhgqscC1JHmhHUW9ixRRe9YvT+ZHrdwuff/TtESUAI?=
 =?us-ascii?Q?F9Jmf7athceX7R1haDkgguSiDyW8bfZmiQiVl61GnMk2TR3vQeZOhFo4INaI?=
 =?us-ascii?Q?QWym9WGd+QTEb4GUfQmbHOc/taivRjFMbolHqsEaCn4lzGGu71yo+Gy+6ZdV?=
 =?us-ascii?Q?yYx43FhGDWvEYXR9s3BS9wa6Ok0Gv1mK1cUa73lkzWtd+fai4UMJpqONVj+C?=
 =?us-ascii?Q?egnxCyIxzUzD1QzpoLmQRz+OK7fEFyEXMeXieZJHYTfIO5dsZWeiXtPpKSIq?=
 =?us-ascii?Q?+VUfctJM6AeGnYxWcdwp8hXoZJC/9qnQn3+mdH/fsUXwpml5TUNMs8bov/mT?=
 =?us-ascii?Q?tdC6s138SFOxTGkTa7KdWZBVGV25tEUHie3eGS9F2UNI+6vKUkP0sunjGflb?=
 =?us-ascii?Q?fUpIJA4FISfpadjzcsQ2toavatet5koQ/TgALiOSTVFeZlj8b0pIocUcaJRE?=
 =?us-ascii?Q?8V3vsA789+pzppevGgnjIu8WOXZlcWLp07GKTQL0kJfqzjtRvDGWTuyT35IU?=
 =?us-ascii?Q?5GGCPPL66I0ZebZYnJ2KgQYde45fSFbz+tz4k+I7pQOg5b0w9UDe952MbDE3?=
 =?us-ascii?Q?YaaIoHmrutKR/Ydmt0yOQVkSyiHrF1H1tg80pT/SgRs8PISYKWCxfW0naBEK?=
 =?us-ascii?Q?7B9jOQh7HQQ6i0LMUqdtRyNwdn2MyyrjlIAJkOANDUDvP6HxLgbdLpw8SexF?=
 =?us-ascii?Q?YS62NGJRWk3iVjSkRh9bKXIQX/V9zuMNxK6O/syZokJ9Vq/dr73zTitXr/WN?=
 =?us-ascii?Q?jl6Tt83TEa9DK618boV0YWbNx42crwe/MigXavT1ABw2bxEe6/qxt9vystMW?=
 =?us-ascii?Q?CoUnK3NljBtPTwIBeWqM4qhYXKhrj6LAovo42/1C9vyvMVkGGeqky8zZCvDr?=
 =?us-ascii?Q?tQReAzf9RabJvr6gLcjb/71sX4KtnzHvMdCr13vyyfoeGgeG0TRL7CrnvxPO?=
 =?us-ascii?Q?cYqDdc7z0uZYFShm/maNnLRf+fl9s8nc3CoCPWryNSvibJsJJmqOFUZZAOI0?=
 =?us-ascii?Q?Crg0muxMqDVczSDRnCgIUp/EMuGoIP+R3N5aP5U+/ZaZIe0CLGJ36xgrdJHw?=
 =?us-ascii?Q?kedrbqvt7yex3Gp92DqCuNPjzQt7bUGOObShUFwI7lDNMW3ArSJHJk3LSC/P?=
 =?us-ascii?Q?Y3rTEB7mX8ubStHAl+yBXqSge0wAnuQZTsNhOGqwrEj0p/A5XApA1ZxNWVa2?=
 =?us-ascii?Q?9c75ko+EZJL+Bfz11xlYXOHAC0X5/HEqs1BrQkfYDsUs8st2upzNoQleA05g?=
 =?us-ascii?Q?S4HFErckNwj37Tuwe+a9xx45+ioT3LYHcbEApUzN/INnpUbO9oFzZriTReXi?=
 =?us-ascii?Q?M2pX/LxK24LIsrL1bCUReM19iGkaTj8Nkc/xV1RJ25VIDm42sDTVwmrZxCgE?=
 =?us-ascii?Q?cZvl5Yf9oo4ZgwuP9Kqgj3Y5VVhlQFQESxguq1q6vUsy?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71268da5-6bac-45dc-9f31-08db4148b64c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:15.6669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGWNROkJbnTnvhIBSWLgt5JRkvhGsMv+p/wf5EVUTTBCunDB6zneh2hm9PfFpkP7Qywn+r5x+f/1tb6oOPlcPw==
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

When the host tries to remove a PCI device, the host first sends a
PCI_EJECT message to the guest, and the guest is supposed to gracefully
remove the PCI device and send a PCI_EJECTION_COMPLETE message to the host;
the host then sends a VMBus message CHANNELMSG_RESCIND_CHANNELOFFER to
the guest (when the guest receives this message, the device is already
unassigned from the guest) and the guest can do some final cleanup work;
if the guest fails to respond to the PCI_EJECT message within one minute,
the host sends the VMBus message CHANNELMSG_RESCIND_CHANNELOFFER and
removes the PCI device forcibly.

In the case of fast device addition/removal, it's possible that the PCI
device driver is still configuring MSI-X interrupts when the guest receives
the PCI_EJECT message; the channel callback calls hv_pci_eject_device(),
which sets hpdev->state to hv_pcichild_ejecting, and schedules a work
hv_eject_device_work(); if the PCI device driver is calling
pci_alloc_irq_vectors() -> ... -> hv_compose_msi_msg(), we can break the
while loop in hv_compose_msi_msg() due to the updated hpdev->state, and
leave data->chip_data with its default value of NULL; later, when the PCI
device driver calls request_irq() -> ... -> hv_irq_unmask(), the guest
crashes in hv_arch_irq_unmask() due to data->chip_data being NULL.

Fix the issue by not testing hpdev->state in the while loop: when the
guest receives PCI_EJECT, the device is still assigned to the guest, and
the guest has one minute to finish the device removal gracefully. We don't
really need to (and we should not) test hpdev->state in the loop.

Fixes: de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  Removed the "debug code".
  No change to the patch body.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

 drivers/pci/controller/pci-hyperv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index b82c7cde19e66..1b11cf7391933 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data *data)
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
 	int_desc = data->chip_data;
+	if (!int_desc) {
+		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
+			 __func__, data->irq);
+		return;
+	}
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		hv_pci_onchannelcallback(hbus);
 		spin_unlock_irqrestore(&channel->sched_lock, flags);
 
-		if (hpdev->state == hv_pcichild_ejecting) {
-			dev_err_once(&hbus->hdev->device,
-				     "the device is being ejected\n");
-			goto enable_tasklet;
-		}
-
 		udelay(100);
 	}
 
-- 
2.25.1

