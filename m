Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8BA26D5678
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbjDDCHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbjDDCHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:08 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020022.outbound.protection.outlook.com [52.101.61.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEA5271C;
        Mon,  3 Apr 2023 19:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehL7GItWkaPJbysyfJJkbAB3KU9X+W65ZO8nq3puNFdg/onOwU8c7vDF9h1J899WrTOPgc7sINB+OWq9ZM2i+TRq/UkjZW0vySsFjRdW1Wy0fv2QD+Xyp3F6xtEVgct5m6avlTjKVVOihRRrz3iqg1poD3zS8CtmKhBkbyoOFPfdVemHmX48dgKlw/Y6tQQ3yOtYxmzVo9DGBnZu8GhNbgwiViZ9WybeQLizitsuHTc4ncXeOM2tqL8IVSMGJOGauLq/U6wffNVZ2ypn8/JQaOY7OtbOPGr6IxD1k4xSEKsUV7PwYf8QZVISuPNhnrgLEO1H0MqMfklrlYb1kc3e3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxLe1FYK7bQI/ndH3Bdw5dGK2hjINKnHd0St/4JWr5k=;
 b=k6EjZykxJC1nUf1QdpJIetI+SHj/1OFV7jdYOtJq1g2UZqreWFyWHilKF9ls2Qql7KGhVKR4d20Lz6o9IDFEN+/UKZwobwyB/OY5334+F5BvgRR1siMIw8MgbBOyIQd4rYNqXmLoz8Xhm/WGMi6Lyqa1xRA3losFtQEybcTBKsztZe38eqSp6Renm6Aakjcws/f0CEsNkK/5Ps4iC1J7HiiQ9bQ0+5kCQMBDArs14e7LNqrc94FKgFHgzUXsjLrAFRWtOUm06a5XJrN7XkO5QuJPddyotIZ3ufjObHD6wGoyWH2MBZ8qA3IS/1exBkhjnc3IAYvEfV0szjvSf8Co+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxLe1FYK7bQI/ndH3Bdw5dGK2hjINKnHd0St/4JWr5k=;
 b=IXgLLigmL4wVecNoDO/mZ5ziTOc5M5af4HvVzBOrnvI7up3O67nsYLQoc5bYhmZcDoum9QieEHE6VhLZNvglKbPiufyxjGnhm4CHB6NL4ZNVO7rJGFGKlIiSna+tR9NUs7/7BEjWVfLXqehQSB0i/b4soPkUudVjLoX0RwjIDms=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:05 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:05 +0000
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
        stable@vger.kernel.org
Subject: [PATCH v2 3/6] PCI: hv: Remove the useless hv_pcichild_state from struct hv_pci_dev
Date:   Mon,  3 Apr 2023 19:05:42 -0700
Message-Id: <20230404020545.32359-4-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404020545.32359-1-decui@microsoft.com>
References: <20230404020545.32359-1-decui@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR2101MB1092:EE_|PH8PR21MB3959:EE_
X-MS-Office365-Filtering-Correlation-Id: f5dbe20d-7f32-47dd-459b-08db34b149aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rCamEumvZaf+JElnqRQHUuYumGB+YCwBdt2zLq+pLpfN+6K2Sr/wo6PieA8Qe59WRt5+VplzfgSq4Krbe3wdAVdD1QfnXd2b4NyBE8MLaRd6Mq1zI8uD1aM+ccQDC40XYcI7xeoJiIPtjie4B9BQcHrteuxSpfElA4OJ4Kqpuc5Q2vazlraFmFe3Rv9siZYvadWn5ITAmkrFsh4wgZJWlWyJ15In+ieFK8CJkLJOjPgYw7lt8SCe/zS67VOQ2eaai7wbasbKHSPa+4LpNbc/znMoscZB/7v6l5jSp7g/9EQIrG8869XQrd9LYVAc6HROsCMRAhGjLiSuSWX5n7DGqLd2EexPTbxCTMnesceEYHW8heDVw3E+D/rXoebPg8DTmtZ8nRTjqXJ3YNlSr0w+vwHLpfyWQYTVGUlmdTuUr1gnWNDpNzNrsTD6JmRIAnwSosSQaQwUO74ASHXZJMtHgLNv9BZ07qFADq6/7o5Qyew5vG0N3wIDAYRKsGUtCBZhBkg8G17aENq7D8f51cYsxaUuTp5PP4zr3fpLbyNh47zAkyIbxrkNsVt007L00z/O3syZgiQOrK8Ixve8enpFNVuljRUEbIcQExvJCxSJz2G2V3WBcBmu/VXQufMPOU5ySLa8FqvXH8Psrs9cJoEMXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yWbqbIUB7i6nLDv1NHT/KZG0N/Ge9Tg4/66jynh5xXoleuERrhJR23f+k+Sy?=
 =?us-ascii?Q?0dargxDhrfYfxIvupcux03FFOTckfbWCZI1qjrhArA2QaNiv5wPmdlmwvaL/?=
 =?us-ascii?Q?k6WTS5mApDQWfGC9XRpHpK3mJnRKgjyHGeO5NbvCouldxBmyXvIueiMfEzVp?=
 =?us-ascii?Q?mRRfNCpj8VhzMiNCUuf2VQw20fR1yAVGvoSt8T4r/1Faqu+vdLO1GqnbNkaU?=
 =?us-ascii?Q?2wzb66LTbQkFoOQxUaC+/Z5lPGCCJSquzXsKXGscb5JwFY3yfOoFzmRS5l8C?=
 =?us-ascii?Q?VnE57l/rsyHQ25e/Ux5SLO3Kv5lgnm8rODDqlSaGN+B1ssti+9tL0vjZxrKX?=
 =?us-ascii?Q?CIkQqBhlU7uUpgi1dmXS6a54OHqCk/dvM+G3gzctogqG1Qu+bn5ER25iIUBq?=
 =?us-ascii?Q?9zh8FdMLYZROE9U2slwOdea5rZ2QFlIW1Ns7j+akA9ntzFlwIwaVm+cMaULH?=
 =?us-ascii?Q?//Wc2/uJylXSk34XKfiWerh6y5S4aXv61oMjui/sawCuNyM4yWkXDKOv7T99?=
 =?us-ascii?Q?b2yX/PV/aOCDqkiSPqZr9iTSk3/4QkqZqDk3DpXORNm9sQKjLgs/PyLadMa7?=
 =?us-ascii?Q?xn3RuQK0iHlCsJknOKRERRyJMagLGMbcspwVX7pk3VcGPFBpXWYtt7m6dBLZ?=
 =?us-ascii?Q?C4kjqjtN93PxvwV9TAQ3o9uM7t5oMqgD4h7Bv5KeTd9PTg6z61sRTrdosvqk?=
 =?us-ascii?Q?/YWmzwylpqDVnIgEPKn06bW0BKQBsSnr3L4PWovCAkST1TqQTYTKBOD/A/Ik?=
 =?us-ascii?Q?T/D0DQoqLGhlcTdqgTmbRYUVdPOyRkGSCUaByUQKtSCEKmEipCs+NsF5bX4g?=
 =?us-ascii?Q?+OvxU4NULhD4vxuElkAvlmKUhTPY9SxWk6ouE+ntksRK1zDfYqAztbaRy3ah?=
 =?us-ascii?Q?F2U32egSwDR35IGVShqJfX1wqbeJ6SWt0B5J/Mb0mB09OqRIRyZj5ZZ6tcN+?=
 =?us-ascii?Q?z0XY/Z9RZufqAxqbmhIZyMke7TDygOcgKZpyxAeS8WTdBwV9vqfrPxYv4B/I?=
 =?us-ascii?Q?QD1rgwjVqV3FbBS5AeemKzkfSAFUDMODOihlX6+Ae2RYf282Ir181JBbhMdv?=
 =?us-ascii?Q?sVj/q/wqr3AoRo+8TBCFASWqMdJ0mo/L+POzPN1kOghjHJcQ5l9KTUlMB9hp?=
 =?us-ascii?Q?QVGqcY/2J1+euprPxxquAm7VOXZRJH28HRdKqFQ6mvqEUTl3RKKSL759fLc8?=
 =?us-ascii?Q?gZBvdDm7cjh4xqcZf8HpMxCoU8zT5HFsSlG4wVx3vF9H1uyOm/1NTHy1efLe?=
 =?us-ascii?Q?K5FlsT+gKF1s+bTaPhsNqDalTgqAArfanustGKR7VlVoHJpxCWLWB2gc6ZyU?=
 =?us-ascii?Q?hTknbKn1IHZEflz01yWgo+pS9Ry0Gy0HZv4/SLVO7p338kmxxWhFwiFAe9Xs?=
 =?us-ascii?Q?pHmOgrlrFp+s1YCpxnBHd1TReiKS2ioYdCE2mUWe01/hCsFr8iTjNNdmQ1EY?=
 =?us-ascii?Q?fQif8Za9+blrjNTGZklgSPbN8giacoxCwRe9uAkrlQe20NwomeJ0ZkYn+you?=
 =?us-ascii?Q?WWk3scWofaMTExGIDHLYpLdbnPi8Dm42vx9rKVrKt7s8zOvFolkUYODHgxch?=
 =?us-ascii?Q?mquiznthnjcPJaZEsGsWQVO5p/ZeyHd8V6JYIl60IBzoVVZ5GH20ASTfvlmS?=
 =?us-ascii?Q?/N9UwB038F9beaL7Ndy1voWJd8n1YQyh2FvwDQpu7c3Q?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5dbe20d-7f32-47dd-459b-08db34b149aa
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:05.4694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCXT/on0pqJSoGmFSUBX7w7GLZkA9Re8C8BzYAjCikqnekq52grCM52CkZoWerXUdTt5NjM3lDnKqney4+EJvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR21MB3959
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
Cc: stable@vger.kernel.org
---
 drivers/pci/controller/pci-hyperv.c | 12 ------------
 1 file changed, 12 deletions(-)

v2:
  No change to the patch body.
  Added Cc:stable

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

