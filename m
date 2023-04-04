Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092416D567E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjDDCHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjDDCHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:07:37 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D4D2704;
        Mon,  3 Apr 2023 19:07:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk77QAgqKzL3752Lms9ySxf3RJ9I57v8+11x5LbeSo0beLUOsVPqjsm/rMf0/jBq9tj6X81LCX1Pljcag2jyjX5XC/sGxCAw4g8JjoPIpDl3+DStDghmsNvbewYth3Zux9sZrpHFKTuShQME+nBMMBN0GQmN8cqHpCZHTM3E93V115Vk6/+2/XMoBZVT8Vs+Ku3s175t9nWwwFPNK9ZEsWmPkM8UpLzz5BBITTc4eJfI6cBtXVqeIVZ+AFnXZWkA2rOYNh1BE3uTbBm06zz0dA0qN9QgtyF76SkNw5xDeH/twtPH3fOq3Vrq2zjO4Dyb3fIjzJ2J/UJOGYabj/t0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jneeNI1CuHXTmt+Z+OGxvygWjqmXlgkHAmbx3PaIIgU=;
 b=M0oBTx9mxuT78PcNoivi+9jUvjj0DwDqDT0k8cSSFSGpXf/DDynT56niIZ1r0ArjztNaa6QqhtT8jr5V+4gXrXIQ9pOcIiso2Pym5e2PA9poXZT7aDA5uwY41QmWY7aeyXW5ubigRemxWbdodFHduOFXsiI+gM+mcfIiXdUv37ShzfD2/rz1mvKDaTJeNzdV9TipojoM7D+/E4aroJwbiZXUTPGW1P4xFXIO/ACD1aMANuzdGXf2mYl4b/p7JB/pHcJXF8dofztMSOh76jsWPEAPE67Z9zZSps4lhc8MrGGBhwOlGHpRrkkZdZqudkRFp96NZlj4WWDnF9JaOHhiFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jneeNI1CuHXTmt+Z+OGxvygWjqmXlgkHAmbx3PaIIgU=;
 b=ZWzAVhaZiacNEfR3ufyYJPM+Gl7b3Lj3lIS0xMSDvu1zgzSnT9pKj7opwCNgeVysWwiiByrNJGjBIVyljWpu6WBdd6/qq7mxcL38q5NERX2/G3nSKYzL/NNS6ixEY+oEKiCknStRxVB4/cKXvp28T7151/pf3YFEnlgorn5AQ94=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by PH8PR21MB3959.namprd21.prod.outlook.com
 (2603:10b6:510:23b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.11; Tue, 4 Apr
 2023 02:07:07 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6298.010; Tue, 4 Apr 2023
 02:07:07 +0000
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
Subject: [PATCH v2 4/6] Revert "PCI: hv: Fix a timing issue which causes kdump to fail occasionally"
Date:   Mon,  3 Apr 2023 19:05:43 -0700
Message-Id: <20230404020545.32359-5-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: a78004c2-47a6-451e-4394-08db34b14af3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sPKPKQL+wDd1lWJhRAEmynII/RsmTO6NMi8zGd5vDtP+Sq+QnsGEPzMl4xxXKsmLfM/d5V7kcwgOTSE48YYS7TVqbwQjfNG6JSHMHerHVVOuONeDXpMQ2v/FZpF4N0nzJ5qYTLOSgs2C7xh+GCrX7XiCHwzFJtKULzeLEZll5DlFddveHycfvrT9r0NsQ9BGNdf4QH9lSu31a8AsjDKlNersCI5wH6e2u/5KJy7yI4akzhS8NW+/pjvZ8kapLrKtuUg6FWN/B4K8tdjvfYzCUmFwkNi4Ab2iBa5cZrhXII44l6ykVi6UUTDCqtr9ip2p8btVO30j2P8iSKV+6EQvvHtr9DxeqzAKcRvcQgX6S8V/8aGVz6ixkM9Oxbew0sHFqqWMSkPSPnWIf+nGvSYOB6Qfar1lhTgqsqTbPqhWzJdu9S69+XKj6OLKOYx9aX6zilj6RdaYRjqMbcnhYI+zyqroqA1aWcabn0qyWHInr1EJtFmoGuPbvGNZ49sRhXX/YfIHt/fYbqxeUq97WwU+nV/hp2FuVaFYG9vgJMNGIOIDEwNPaYTeTVFfqa7E1blgpsTPJMF4Wp6PDktwJUeTx7PYfTlRf74WeThMCCNXNR62sOrjC/wjO452JhP4YPuZaTnTppie7BaRNhvA2fH77g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(6486002)(5660300002)(82950400001)(82960400001)(36756003)(478600001)(921005)(10290500003)(38100700002)(66946007)(66556008)(66476007)(8676002)(4326008)(86362001)(41300700001)(786003)(316002)(52116002)(8936002)(2616005)(186003)(6512007)(6506007)(1076003)(2906002)(6666004)(7416002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVwV9qHZbefMLp9nQHc44uDCDEeiVDQiWOlWqXL3yB+jy+c967BvPv5GkUfh?=
 =?us-ascii?Q?7uoDGKPAoIHJp8mZye9Dn9WieRRl9atb3OF3C8NX5Fr3vPuv/+K36bIwT3eU?=
 =?us-ascii?Q?o4ZHGfxdXjqtP7sJgAjkQOv7Uk/2b5+qqm3j2wcj7ZLnv/n2wfcch44fVVq6?=
 =?us-ascii?Q?/7RD041fdM3B0vkEjXnZCdCnMFR9Of1IqdvwGjY4PH/oHqXrU3sTlmT/3qKE?=
 =?us-ascii?Q?COQ4g1z5cJiyGuOYIV/v/MCFk/gVwLa8RyzrCCyMQmalRUS9nUXK9LAdMGNK?=
 =?us-ascii?Q?SOJBUGwNbNANk2Ou94SeukIMN+LLhg28p9L7kzFUmS08oXjKWQLkUDYfN+Z/?=
 =?us-ascii?Q?JOxgZWl6x/ASGlbMdPUwjaBJ5v70RBgmjaY3Jo2G1mpGUK1kyObofG/fNrz3?=
 =?us-ascii?Q?9BSjE4n81pZIisRhj32ab+AU7oTgVUFfISoPmxumY+chklXqV22secAjWREF?=
 =?us-ascii?Q?ibJHzN+Tq60aGiqbJDz2/TrYkTpy3VwYhnWwYLUM/Cgk2qxj5Z+POvEi7WzJ?=
 =?us-ascii?Q?ykK0jaLxIKs7BYDK3IiiZBjPEgviHPJ2zpwGzp/r5UW/uo64pHM+i2k1jQLO?=
 =?us-ascii?Q?jATeAigTMPn5WVLB72BEQ4SSG1j1LBBix5avtZ+BdGwPbjqHar0oaF/ULkhM?=
 =?us-ascii?Q?bhXvM76z2+Xz0cQJ9dGyHo0+Mwek79ung1j/72ZZ1qUlKvDLRZ3kDBhgRS0y?=
 =?us-ascii?Q?jkl8d4z5J8VU7MrcPaM5tUHjra4YaAPeufKRfaVPNumnpKQvaH1VSYb2zr86?=
 =?us-ascii?Q?lCpft72BZmij8rbAS/LFuQownTlMEc0eQwhTWTua0KTBd6Mc1QhcU63FWTJ0?=
 =?us-ascii?Q?HGG9VhnIZm3HObQGsfj9Gw4bLG/6zH/9te+fCYCMPaNdH3E8XhdYs1J4lVBr?=
 =?us-ascii?Q?3qS4QZy2anCgRXdWGcNAWrCXhRtoBKFwQqGZLRsg1ChyB7qVH5s33ST5Y+Xx?=
 =?us-ascii?Q?7h/P7NXOvgbphOFH6g6XRTKjm3obU7himb1be9V1ZTLq5KtVHANDmdE5fc1O?=
 =?us-ascii?Q?dodxPN5HdV7CsvDbValcEYbO0y1ZSiAatExQgXsnkY8DHvz/0kx3gs2bj/qg?=
 =?us-ascii?Q?CA7A/8vfbLajpEr+ksZCkOFsgAm06GAAihcil90st+B+YbVs9nxrqrJsPpNe?=
 =?us-ascii?Q?RbUa5R1pjaS5xExHUlBD+u35GiD07SYoP/ZUV9EDy9c9H5pYxO2I77V+EktZ?=
 =?us-ascii?Q?ipXq4QhKd4+tURX6yd+seL/DeynA+qlmc1BYV3cstb5G2UTEpP8esUkg6WnM?=
 =?us-ascii?Q?dzU+uD7kKERLA8kQhijq5BN0Wqy/OEYBg9wO1peiuv6nt043bFyQ/9CGPqSg?=
 =?us-ascii?Q?GzTjcl98r3+mGmuHl1DscHNt5JF+CYRh08n+POB5ysf8rwJiG6zHQzMuPqdf?=
 =?us-ascii?Q?G71sOp2o0On0H/AQBXPuAcG9kI6LBF1yXnLqjMdQqzzmqQDwzBeu8TkR/uhm?=
 =?us-ascii?Q?BbwKFFs+PRJcC3q4k39Hgo2zTzsY2RgjBlmXDylTZ0euyenidXEgI3WYnV9k?=
 =?us-ascii?Q?XD5LBqruRvZbnrjg2J7+WGn+K323ITbg8+NUInfOJmT+P7iDi1ggRKHY3jbI?=
 =?us-ascii?Q?qThr3xObB2F9Ma+Bz23Uml1cst5D/+Zn2RQSS0X52owO4loSr2f7mjACczdI?=
 =?us-ascii?Q?RUx3TBjQFof9RNRgth3rnGR2zUC84DPcpsCr1U2y2zJ7?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78004c2-47a6-451e-4394-08db34b14af3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 02:07:07.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1fitSC23aGFjp5NrD7UPko9E9q1oz4hvrsJxVgZU0NgriRBll84fJ5PRbLQVsmMnRwVSmg8rUGRPjT8mMoRWw==
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

This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.

The statement "the hv_pci_bus_exit() call releases structures of all its
child devices" in commit d6af2ed29c7c is not true: in the path
hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true): the
parameter "keep_devs" is true, so hv_pci_bus_exit() does *not* release the
child "struct hv_pci_dev *hpdev" that is created earlier in
pci_devices_present_work() -> new_pcichild_device().

The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
where the old version of hv_pci_bus_exit() was used; when the commit was
rebased and merged into the upstream, people didn't notice that it's
not really necessary. The commit itself doesn't cause any issue, but it
makes hv_pci_probe() more complicated. Revert it to facilitate some
upcoming changes to hv_pci_probe().

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Wei Hu <weh@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Added Wei Hu's Acked-by.
  Added Cc:stable

 drivers/pci/controller/pci-hyperv.c | 71 ++++++++++++++---------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 46df6d093d683..48feab095a144 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3225,8 +3225,10 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	struct pci_bus_d0_entry *d0_entry;
 	struct hv_pci_compl comp_pkt;
 	struct pci_packet *pkt;
+	bool retry = true;
 	int ret;
 
+enter_d0_retry:
 	/*
 	 * Tell the host that the bus is ready to use, and moved into the
 	 * powered-on state.  This includes telling the host which region
@@ -3253,6 +3255,38 @@ static int hv_pci_enter_d0(struct hv_device *hdev)
 	if (ret)
 		goto exit;
 
+	/*
+	 * In certain case (Kdump) the pci device of interest was
+	 * not cleanly shut down and resource is still held on host
+	 * side, the host could return invalid device status.
+	 * We need to explicitly request host to release the resource
+	 * and try to enter D0 again.
+	 */
+	if (comp_pkt.completion_status < 0 && retry) {
+		retry = false;
+
+		dev_err(&hdev->device, "Retrying D0 Entry\n");
+
+		/*
+		 * Hv_pci_bus_exit() calls hv_send_resource_released()
+		 * to free up resources of its child devices.
+		 * In the kdump kernel we need to set the
+		 * wslot_res_allocated to 255 so it scans all child
+		 * devices to release resources allocated in the
+		 * normal kernel before panic happened.
+		 */
+		hbus->wslot_res_allocated = 255;
+
+		ret = hv_pci_bus_exit(hdev, true);
+
+		if (ret == 0) {
+			kfree(pkt);
+			goto enter_d0_retry;
+		}
+		dev_err(&hdev->device,
+			"Retrying D0 failed with ret %d\n", ret);
+	}
+
 	if (comp_pkt.completion_status < 0) {
 		dev_err(&hdev->device,
 			"PCI Pass-through VSP failed D0 Entry with status %x\n",
@@ -3493,7 +3527,6 @@ static int hv_pci_probe(struct hv_device *hdev,
 	struct hv_pcibus_device *hbus;
 	u16 dom_req, dom;
 	char *name;
-	bool enter_d0_retry = true;
 	int ret;
 
 	/*
@@ -3633,47 +3666,11 @@ static int hv_pci_probe(struct hv_device *hdev,
 	if (ret)
 		goto free_fwnode;
 
-retry:
 	ret = hv_pci_query_relations(hdev);
 	if (ret)
 		goto free_irq_domain;
 
 	ret = hv_pci_enter_d0(hdev);
-	/*
-	 * In certain case (Kdump) the pci device of interest was
-	 * not cleanly shut down and resource is still held on host
-	 * side, the host could return invalid device status.
-	 * We need to explicitly request host to release the resource
-	 * and try to enter D0 again.
-	 * Since the hv_pci_bus_exit() call releases structures
-	 * of all its child devices, we need to start the retry from
-	 * hv_pci_query_relations() call, requesting host to send
-	 * the synchronous child device relations message before this
-	 * information is needed in hv_send_resources_allocated()
-	 * call later.
-	 */
-	if (ret == -EPROTO && enter_d0_retry) {
-		enter_d0_retry = false;
-
-		dev_err(&hdev->device, "Retrying D0 Entry\n");
-
-		/*
-		 * Hv_pci_bus_exit() calls hv_send_resources_released()
-		 * to free up resources of its child devices.
-		 * In the kdump kernel we need to set the
-		 * wslot_res_allocated to 255 so it scans all child
-		 * devices to release resources allocated in the
-		 * normal kernel before panic happened.
-		 */
-		hbus->wslot_res_allocated = 255;
-		ret = hv_pci_bus_exit(hdev, true);
-
-		if (ret == 0)
-			goto retry;
-
-		dev_err(&hdev->device,
-			"Retrying D0 failed with ret %d\n", ret);
-	}
 	if (ret)
 		goto free_irq_domain;
 
-- 
2.25.1

