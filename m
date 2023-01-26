Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CC267D147
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjAZQYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjAZQYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:24:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D12F3525B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:23:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaye1V3JEkTd3FmLTEr+8t6Kpw/9jiPvcsLIPEnxYZb1xJW5sHdHt8g79W4nyPkkkTDysoCk/En6FsSxZ5p95zsxb77vGJAmUBjEFbpW4xESyU6l+oFfpjH+BWdigbWU2pxDYHs/Ot3h/rICiB3DESV9k/zjHP+lLI1gKhDbl3bmB0CcvZ7QtYTi5uGOLiu3eF3JfaA4As7H7At8t6j7yy0h1qOLygY2sV86xib0PSeWa9Rwsj5GLhcorVuFgaEXRBzzhn8DApBh7/cpRGsIhR7avVJGXhJLySKjI1RR+nLh3BOglqzcTa/9V6RGsgx3mkMzqyX5OK73TJOEHBiYfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u8hQlm38ob57LZCfpyEknEa7+Pk/gayTbza+DuQqxvA=;
 b=jvGpvragbFB1cvyIOJ9HVwEHSKqele3s+exSW7kSKf0ypiNJV1HtlWTBZYjH5pixspfmok+6dqgv9h8s0LJS8h3VTPFyz8P8QFKChlXqxJJWO6WI73oXfxjigzk4vG09vWq26Nevkf3/IuIUiee9rRzS+qAM/yXezTsSDnl1Cl25Yc0LyZC+iwod8k4yujkYjBTKEeePHJuomX5NFhxs3xQUG0JhVk67f/1lYKp3kA5DqmbSMWr2zie2O0Nape1VK5tg4uP2Jgg1N5tYYVHLztpN9dTXToZNjFAg2JLOM7S+AnTfvY816XirN+WooFNm18ENqhkKM4wXeRRcoki7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8hQlm38ob57LZCfpyEknEa7+Pk/gayTbza+DuQqxvA=;
 b=WSro5eIPM0lc4X9kaVMJJXgir/cxVKW0N0hGtZribdtB2dq9Izl03fFqWo7WbD1832HbqHBvtpkMocmmqAiZzxNuFdYcSXPOTlzeeSq/TSeyVdvdopbC0GQZ21tvmV43AjZREPHtl+VoxMq+igkkI3HtpJOX2rDpO/GGIaDz8rvsQCQBqEYCH87s5vI2MSUy/ZlIFdZMwvicownr1kaw212x774CjysNk1GXTYV4seFNnLzuSlTMNlFsB4XCBiXdczV/g806g+sr7Y8vkDO2KmzNjI3V2R3wtfcJwGfhj3tZUV99XCM/5LSnztu+ZP/K6MglZNjL/WquneMKBHjKcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:22:51 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:22:51 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 10/25] nvme-tcp: Deal with netdevice DOWN events
Date:   Thu, 26 Jan 2023 18:21:21 +0200
Message-Id: <20230126162136.13003-11-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0078.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::11) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: ac33ef01-ce3a-408c-4155-08daffb99223
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kbKbqztWpN+eJaIIwIwXfsYkQaF7VxMfAkJI16agWK2zYUl9ZfCbTUnBBZtK9Txs4fLpT4PSf8akhypDN9L5Mxj/acLgYrr9C0QE6jFWx+V45keoR93rCah0wBRuMeqRgSKJwyGtQ3hr/HD6dFyR/ahQGV/JX7sEoodd+UcsXIAMRXCMn4hrDOSDUWHDtB5s8SRT2+W6+Eng6BOhe0lYNjg49sBRY83Bfjt5fJLTpmt/D6GXcVb+kuqBwRx0P3NGRbO33a0MKogFhVqGWFC8kfysnkaP2HnqkZ8N80XkLhBBJG3IQaCftdDZDc+o1NnWjZzCY0FqbJKxIhsGdE7DgDix5buy2GKTp5TLy9TOy0mKeGb3fcEo4hgrLutLuaFNT8ci19DqszmZp8KpItxnEnzdh72gpTiamSPCMThgIRfZ3aukyl0PhsnCGBR2kDalipCj32UOVEha8RFtSnieH/N+Nwq3ZP142NFoRMu3bp7cAjsDtzaE8UfTuf8jzYEg8dzGF6yD62Umxomg8Qv2B2e1Ljdfi648K2Hd02VKPQyHL0V/judIdfWaVH3nODt5nlsqqRwQvPIDqaMd1phBf2jcAjceUmOAny7DfJyZ5MXqNiHXGniMgdigZk6sIQz0cXHXhrQxpdoBGKGhT936A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UueweukxM+Ze1CFk7SkUvOj1K4MPjeFKLmJhRAGJDXZVoHee2IGUd9n0DzbN?=
 =?us-ascii?Q?Wg3xO10ASp9dhXEWCCKrQ8ItSQBH2ht6Nb/FbHT+5vRC+J6vUP3J5caUKdis?=
 =?us-ascii?Q?CBOI+PMQE7u6B32LF/TDvi4IuK75kpVKAbCfd2xPpbZcravc2Q5yvowdmInj?=
 =?us-ascii?Q?6WmX9xWJwgCMuhGeWWV9kgIO+KegFG9ueEklqsgf98z22n0WCZFNkjAvZhmA?=
 =?us-ascii?Q?xXig63DDzJqVXutnwzApKnzHOOdEPv4PiZL5yuUGArs3JMDMRD9NLEK62+kj?=
 =?us-ascii?Q?AGWfDiEV44NY4fg1fFeYFRwka9qYlw9RJTXOjIg/SaoMWnVjZRWUCtpUSKRb?=
 =?us-ascii?Q?vjiVcuqON93Zi9g+DRM7uOqnhdRrPBJqTGufc68IqNkxJfficjXLwC9c5r6+?=
 =?us-ascii?Q?KBe4tiHAzxVa8Gz9AZdoFOj7GFhRJ+vxF24ByBtEJRWW2PUTjPuS9CJIEkaX?=
 =?us-ascii?Q?VBXipv+fho4z1y/ItycFBp8RVa5MiBV2C2+guIPEQOtW33K4/IfztycNiAx0?=
 =?us-ascii?Q?pZ7JsPACbZrXYmqgbm+FYOrD6Y5AzIqX4CSeNqITFpl3b7kHSpKH176ijW5M?=
 =?us-ascii?Q?g4o2tmVjFYls6dquXHVIbyuyjbn3imDOtgT53DAsYfTm8rHUj04jh+wcz+B6?=
 =?us-ascii?Q?4kb4q5i/m4Bt3ZStefXcKhzOCXsdMoqzm2tl2PoISBJxqyy/euM6084CDh3G?=
 =?us-ascii?Q?b7RgRwnSHiZ1TUGiptERThyPCQE3u1n1Wlvkc7zRpDkpj5t8Uve34KgK+m6m?=
 =?us-ascii?Q?tDDJJj0uFeR9sT1ZAoyImNbH1LxxIHDfqcU8Q7zdHxnltYDgJY+fsxwEDLWE?=
 =?us-ascii?Q?2kdBkemWcpO0GFiqRP/ShulNWNQCJ4BwGTpH6jvq9piNq0pxYGh4NDhYz17K?=
 =?us-ascii?Q?DazKJm7yN6xSsv49o28uZel/DMR6C4zcINyv2Pix7KEAjhXK9y3tljyscmUy?=
 =?us-ascii?Q?BRL8qyJp9YLlmTa6NWK6eVkt+408tg7W5oeBSKlU+ucb0Gual0u9DEO0/Yye?=
 =?us-ascii?Q?ph9Bte0Sm0CG4DenKlsp6gUzkYfJjOhvA+3+dZ81X9HNgw9jf4lFCkwgMPG5?=
 =?us-ascii?Q?s7vleqNaXqiyzRqE67S1MdLyIyOjBMk5Pk4QSa+9v5fEmGgcU9M3jjYgD+2u?=
 =?us-ascii?Q?BlwsaSmWfQdYCcbRYCvyeB+d7EKCrnkLrhvxMaoq/4PsaMYLbGMFr73nkOI2?=
 =?us-ascii?Q?tIw8CxP0XsBvf3hAJV65DfETZXirsRkWzgRWAMHn0fodFWpVERbOxRyXcS00?=
 =?us-ascii?Q?ZFwITLI2PqfDOMimRDTmA/XFbDkzsjZ5CGne3yXbgyYI2+NwUIwCuDA155+G?=
 =?us-ascii?Q?JdEl8oIKcRQyyFX+IrVm/0Np7CvNokd2r/ySDHsSpfELHwAGtTnd4q3Bybo7?=
 =?us-ascii?Q?IVIaeBFaHyIEgWi4Fs/bWVEwkt65K3xATfARFKTrkU5lq97q03GyQEP/4iOT?=
 =?us-ascii?Q?uJsjrxA/dPokS2Ffoe+SWRQC6fBma2W1ffwXpoiAr4J7QJ5m1l9Iy7yNVvFf?=
 =?us-ascii?Q?8gAADWbJYwx9TOkXjRB4wr4XpLPDLDa0NWKchUwDbhucMIWlqgpre2UuDsp0?=
 =?us-ascii?Q?ifesOgUgiSBW14mhHTUFx5NbSt6SvNlih2KEBAHQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac33ef01-ce3a-408c-4155-08daffb99223
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:22:51.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GEEdRJjJBCFM2FBLpKAbc4GoJIeq2Pdki8Bt+UpUGh8HbJsKGHInigeQcpXQG1c8Bpp8MDzZ2Xur2ZSwJUG4TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Gerlitz <ogerlitz@nvidia.com>

For ddp setup/teardown and resync, the offloading logic
uses HW resources at the NIC driver such as SQ and CQ.

These resources are destroyed when the netdevice does down
and hence we must stop using them before the NIC driver
destroys them.

Use netdevice notifier for that matter -- offloaded connections
are stopped before the stack continues to call the NIC driver
close ndo.

We use the existing recovery flow which has the advantage
of resuming the offload once the connection is re-set.

This also buys us proper handling for the UNREGISTER event
b/c our offloading starts in the UP state, and down is always
there between up to unregister.

Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/tcp.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7e3feb694e46..732f7636a6fc 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -204,6 +204,7 @@ struct nvme_tcp_ctrl {
 
 static LIST_HEAD(nvme_tcp_ctrl_list);
 static DEFINE_MUTEX(nvme_tcp_ctrl_mutex);
+static struct notifier_block nvme_tcp_netdevice_nb;
 static struct workqueue_struct *nvme_tcp_wq;
 static const struct blk_mq_ops nvme_tcp_mq_ops;
 static const struct blk_mq_ops nvme_tcp_admin_mq_ops;
@@ -3129,6 +3130,31 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
 	return ERR_PTR(ret);
 }
 
+static int nvme_tcp_netdev_event(struct notifier_block *this,
+				 unsigned long event, void *ptr)
+{
+	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
+	struct nvme_tcp_ctrl *ctrl;
+
+	switch (event) {
+	case NETDEV_GOING_DOWN:
+		mutex_lock(&nvme_tcp_ctrl_mutex);
+		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
+			if (ndev != ctrl->offloading_netdev)
+				continue;
+			nvme_tcp_error_recovery(&ctrl->ctrl);
+		}
+		mutex_unlock(&nvme_tcp_ctrl_mutex);
+		flush_workqueue(nvme_reset_wq);
+		/*
+		 * The associated controllers teardown has completed,
+		 * ddp contexts were also torn down so we should be
+		 * safe to continue...
+		 */
+	}
+	return NOTIFY_DONE;
+}
+
 static struct nvmf_transport_ops nvme_tcp_transport = {
 	.name		= "tcp",
 	.module		= THIS_MODULE,
@@ -3143,13 +3169,26 @@ static struct nvmf_transport_ops nvme_tcp_transport = {
 
 static int __init nvme_tcp_init_module(void)
 {
+	int ret;
+
 	nvme_tcp_wq = alloc_workqueue("nvme_tcp_wq",
 			WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!nvme_tcp_wq)
 		return -ENOMEM;
 
+	nvme_tcp_netdevice_nb.notifier_call = nvme_tcp_netdev_event;
+	ret = register_netdevice_notifier(&nvme_tcp_netdevice_nb);
+	if (ret) {
+		pr_err("failed to register netdev notifier\n");
+		goto out_free_workqueue;
+	}
+
 	nvmf_register_transport(&nvme_tcp_transport);
 	return 0;
+
+out_free_workqueue:
+	destroy_workqueue(nvme_tcp_wq);
+	return ret;
 }
 
 static void __exit nvme_tcp_cleanup_module(void)
@@ -3157,6 +3196,7 @@ static void __exit nvme_tcp_cleanup_module(void)
 	struct nvme_tcp_ctrl *ctrl;
 
 	nvmf_unregister_transport(&nvme_tcp_transport);
+	unregister_netdevice_notifier(&nvme_tcp_netdevice_nb);
 
 	mutex_lock(&nvme_tcp_ctrl_mutex);
 	list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list)
-- 
2.31.1

