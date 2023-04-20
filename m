Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C266E8839
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbjDTCmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbjDTCmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:42:06 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FACB7287;
        Wed, 19 Apr 2023 19:41:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkQLkawleUzKWLOOviEKp+uxsNUxnT63zMmNdcyS9JMQJAN0AE9hokJqb8FbJyUzAJ4bk0KPUj4UPM70q0mBCRcCy8GoSm7v9/6qEtdsHydsfNb6Mypc0aCNuuz4H5oDxGAvIwMVlhmEq1oVfuLnSwreluHEO5lVqkHJW6YeUz/ShjFM3aWz91uPlGM3iFaALqQAA63F+g9Wv+tZ6p8jXnB+2mf0X0uHKceebeWVYeVntlI6/dCA/OWb5BxbfT7YZkCULn6ehMr1qejX0F7ckrlrYtmd0c7RC5CfnDiB34ph02wj7EW64wceWXlAtbYGQeqVGNk81xjGaRyW25jsOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iyhmWuJbQEfT/SmVjDTEIzOqUYQjNjzxVBbj5zIUhE=;
 b=Mchm+jpd6lUmHC3+qlc3qz/5LSm5K2XDaf6XF5o8GNiQnPsq3Lseo3x1D1HJLnpIkeKOMqYXtjwVdPj42eiVuy3z3U8h4xalKtVlTzfWypoyiuoJ89h8JOmHwT+SJ+Q0THucXcH7hNlLFrUTM+x2PSP2UMOaix7BRAt4iDMyd9Ou7meBlSHmYl9D3qhQJNBXWo/aq9VG+ACzt+0J+i/hnhb4SCv0NUoDuO3rRy2OhvmqJWegaF8f7t0TnfQibN3rhnIVOk14AnoJE3zju0RVH4iaAZm2fkKyDYwD4Lcf48mHa/+gxyUgWTV0F+R2RwrLY6TWH3LWjmYmvPqJX4Fzdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iyhmWuJbQEfT/SmVjDTEIzOqUYQjNjzxVBbj5zIUhE=;
 b=gs1Z2d1sJehkNsdRg6CIkD76FkNuzQV5bOhiruhhskmIM2d6EfSQ2068r4e9RWHHmJlBFE/4TdwF90mwhAeS9GD1qNP3DatNoh/0RAW05wfHIBSH+Pvd2fPQyZ6IXYhAWwP5+9DQNEwgc2b85fUu2Asch4xf3gGYZQkG8oFAEmA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:25 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:25 +0000
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
Subject: [PATCH v3 6/6] PCI: hv: Use async probing to reduce boot time
Date:   Wed, 19 Apr 2023 19:40:37 -0700
Message-Id: <20230420024037.5921-7-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: e38939b3-9173-4145-55d0-08db4148bbd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9TTXWr4eYaMlnhgzRkMRrsifacAAQf1hhTz1Ri137+rwCyYmGjAZEB9c0Rl1F+gLPFbP6eKh9Za9eAm5GwVG+Ox51skQiiyu1x69nySTdqTHfLAMYuuAS/XRvLdyvlZQ99jKko1hC3Sr8dMh55HM+cFghI33YyBGSu8UW07WUxNuoFabB07JqZN8U6XTruAV7xdvdnz30McGJmm7VI8a0yVjd/TqhEkQEi9E1RmcvCYeBmGUGAMN4+2jJqpCdLNzV59lpmb+huBAljLGeUY6BwQDNBjHTCmprAV9EYF1d0Y3pxtjrqDKHhbUGIsLvE/zz3Vj/kr969jT5Km4hb4E8as+C+PlwHIjAW60EUDtUOx33DB1iop/5XxcuvkNEFzoF3nPN7NZwsqElXr6MbT+3jgz5pfxI3vpGABCsAmpGj0yejpw1f+625A3fzMq97Hsr4C8MDHHRiU0VaOlWvKQwE1HqBGujeHNu3K409flDfKzOuIpqK0YYKmsZXg1189SQHhm0mHzhrNtQx2//JAj5SALEkba4CgcdqU32XHGNLesMA/ilDU1WrHFfNINoqR4RUeuVnmjyY/ocgwoItn0ySyn9wdl03UJfXU5zCKz/OcvrbLhtD4bv92Sv0ZJlsCd9PeHH52VohrJLGYPZX02g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c+DsVGH/LQYfIloRVEaOk/9VHyMqtdYLdNp8+qz9cA6603AaUjxoS57RIFWJ?=
 =?us-ascii?Q?hPBxeewWjqjZuln0uCtu6m169osQeROEmGtlYVwIT/mql7xeloAesYZp68xX?=
 =?us-ascii?Q?VUMRYnEDX8ToVL06W6cvSDcuN9s+076zzzWzsJiGuUKkPWJQJ9OKtufKjkd7?=
 =?us-ascii?Q?wAEYl7Ln4BP/kWGk4PvUmZC4S0uo6aSFReBnzjO/YYKbLkvCGw5et2QnK/3m?=
 =?us-ascii?Q?2wfiLJOATx0KEZbLvMbaBe88fswkOsiOU8NFH3tssW3LVvtIqNf75pZS8XMW?=
 =?us-ascii?Q?B/B4WDRQTZEbDpLhKKuMYDVI2gIUTvlkdn2i95Qc1t480hQGW4ez0vRpOcnX?=
 =?us-ascii?Q?F3SO7i8rD203eVqWfaFXCSvCNsjwk3T4xNpkTOH/tkwEkA3JR6/bghNuYxhr?=
 =?us-ascii?Q?BUGuetQ7A2yOlgjCSXD+RSMt4bx8KxRbRmH99qKKPuXa9A6L4cQdEF64n8MM?=
 =?us-ascii?Q?6ZMFejwkg7DvvFsOUxRxeX+oAX1U7TIhO9+Vrc7MQ7os+QLC8oOR+RGoQ1SW?=
 =?us-ascii?Q?svGPVSRgInX5eqwjOw4gl5aVvjlY4HdD3ZHxiVXjgYsh67DIopZfqR7iB9Ta?=
 =?us-ascii?Q?Vp5lU5T269Sp15bIfWXWNHaCAD1bbFA1SRX/LZnK7eIrcPh6G9xGtUvCOm2a?=
 =?us-ascii?Q?+WvNCkotAuNZ6oSaOvJBMG0rGuMXsWvy66LiUKaLKnb9bIFw83tUslApub+1?=
 =?us-ascii?Q?g6rZkrh9vkLa+wzILM/3qEvs3iLbx5JqhuwHZRR6DGGhvxXFHCYGhL0c0DGT?=
 =?us-ascii?Q?yt5OE6eBT6d/bO2qZADVuV9TBFLG+XO7fwahhLaIyHaZqCDYVOJ5AwWCIvcZ?=
 =?us-ascii?Q?3QWeIrmJhzLCc19Fag7Guqgas73k6Nbc1QlMleCNdyXqxsa1nkyXkgVUflHk?=
 =?us-ascii?Q?UlVQOtcH3LMf4DdujzKevIDSzKq9q+fAuXwwSNqOc5VEgK2xeMZw/ajOotLO?=
 =?us-ascii?Q?ttyQ80RWQX7BRjGosY04Qnby8XT6Dj8UhxFrGkOk4pQEvoUmy87d3DXVoRpH?=
 =?us-ascii?Q?I9NTTBjjZi+Qxza9yvD70gysbXRTb1BtT0Zj/iwd/i/QlclArOFjgMdxmC+R?=
 =?us-ascii?Q?+Ce1F/R5M1rLu0URPFrdSOGQ0mc1E+V7Zq8Rm7swk2oGhc7Pj5YTbc4t4Jvi?=
 =?us-ascii?Q?2k6ibtGjGhRHmXCzPjZKHKyPeeZbxR3oyLXb/g2clSfjdrO6YdN/gdU0jB0D?=
 =?us-ascii?Q?OkpqRRsTTbvU5gGd7T1ufuU23URndZybbGnYrMwB4y0avrmqpvdRhlSs6ccT?=
 =?us-ascii?Q?udw3eUMcdBQ9Uzqg6JJSRiXfb97gsUtZY98416bKmaeFED4a+cK+vvmJMjt8?=
 =?us-ascii?Q?oZJMn+yzccauBWUp5lZw5/9cUEaor94GuTkBqTColt7cFL0chkulgeuGaGMZ?=
 =?us-ascii?Q?kMXRAZEZI5kYxeuDp9peIxyAI3gYDsK/XOhk7pjFQFItJ2nPi2PquIUabsE/?=
 =?us-ascii?Q?/iQb4AOFA/lmrbcp7x73Jg74ZD5RV/9ETlMq2GWuw5bhfLwbnHM4zKD87exU?=
 =?us-ascii?Q?UaGiElYUi+7nszbzGsW1XtWK+yTACu5xxaPNDHO9iIf+rYCMyt5udrkqL9CC?=
 =?us-ascii?Q?C/FVyB/Ud8zWJJqSqmbltYYi1tTun7eqH3NdC0z1WkID2bjUthz8BMCsj3s5?=
 =?us-ascii?Q?GsFwmrctidkaS6CHkYq7kqhYsnwWA5KoUlYWJCEfW15Z?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e38939b3-9173-4145-55d0-08db4148bbd2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:24.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlEoNcgCZ9WCdmTjtfN3ZPrNu8HkAvlk2S61c5S1mrcUaJSFb6i1t0GMmZSSHUalKmq/fVw5m+QXz6SK7Db+eA==
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

Commit 414428c5da1c ("PCI: hv: Lock PCI bus on device eject") added
pci_lock_rescan_remove() and pci_unlock_rescan_remove() in
create_root_hv_pci_bus() and in hv_eject_device_work() to address the
race between create_root_hv_pci_bus() and hv_eject_device_work(), but it
turns that grabing the pci_rescan_remove_lock mutex is not enough:
refer to the earlier fix "PCI: hv: Add a per-bus mutex state_lock".

Now with hbus->state_lock and other fixes, the race is resolved, so
remove pci_{lock,unlock}_rescan_remove() in create_root_hv_pci_bus():
this removes the serialization in hv_pci_probe() and hence allows
async-probing (PROBE_PREFER_ASYNCHRONOUS) to work.

Add the async-probing flag to hv_pci_drv.

pci_{lock,unlock}_rescan_remove() in hv_eject_device_work() and in
hv_pci_remove() are still kept: according to the comment before
drivers/pci/probe.c: static DEFINE_MUTEX(pci_rescan_remove_lock),
"PCI device removal routines should always be executed under this mutex".

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Improved the commit message [Michael Kelley]
  Added Cc:stable

v3:
  Added Michael's and Long Li's Reviewed-by.
  Fixed a typo in the commit message: grubing -> grabing [Thanks, Michael!]

 drivers/pci/controller/pci-hyperv.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 3ae2f99dea8c2..2ea2b1b8a4c9a 100644
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

