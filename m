Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E36CB59D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjC1ExX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjC1ExS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:53:18 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-cusazon11020018.outbound.protection.outlook.com [52.101.61.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724A26A6;
        Mon, 27 Mar 2023 21:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKAeYNZUF6dp/2zJWLCtXnuaCPUnuv+TvFDoEBW3wV6dsBjR0iupethHynkqP7K9FCSt7zua9pRzWKHCMVMxkBpmFfZrxCu6Drs2wf4ex4rQsVlHrVbyOD2Gm7pfgzZAIa+XyoF5Ts4nVOpvcGgjbJZi00WzV91yhojaodbW8I8HV01Qb6YB2zOQp/y4lYuMjgiDDBQ4v3Iue48IDSl0LaoZsrBXmpTLHaBu+z/n7vFMaSTMU93NcZZHjGh7SffA8vlPBQcg0am35pXB0zWgVZh1GH7wzYhUUUsjrqv63USf55kRsWeEB+51VFI7P2mGSfJcqf16BItpFVPAzB5aUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r602AhK3lP3IJo/nC+/46SPMWQHOXhGqOgHGO5+GLUQ=;
 b=LkCP9rTinfyhxCUH66zGkLPZkEbnjWWoN2Pgm0Utwmt8fmaPNhuOLrPaHnHsIuPO2lnT0H9YjWSKOwcOCxnq5Wx2szQc9nSV+sQ93ini/lc2hcFPTo7mTdRizdZ/cN+bWIOqA6/24aCKSmUc8Sa+vRmVQDaUkhUY3b6E/0ZyL20HavpUKO59CACuInR42NEZh0Xl1KiIyeVT84H4TNxS7FPyoZPyHYE/jhO05iGO7wGxuyuNKKc9AJH/iMGXENl8b9sHP06G6W72Ob4LF7yeXbEUmPMZWuPma0yz0WgGxyY/eX8aR8vyYBMHvDXu73tss1SQFBGkwiM5sInDL7Z5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r602AhK3lP3IJo/nC+/46SPMWQHOXhGqOgHGO5+GLUQ=;
 b=bG7amG6HXu2oxdowyZbvT7qOLk1mJz5ryaCwwF38jdJHpc6CDSckwX7TbPNOy2PMAWLudZy2nsrCeKLP/J/x+OLbeTXXcW9vBAPDhUHXa3Hd1UHXjuQ/nQEQeXAcE/pYQNm0S4TToYK4/edUU1kJ3bCkVST9TMpe5wm2q6EOzuw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by IA1PR21MB3402.namprd21.prod.outlook.com
 (2603:10b6:208:3e1::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.6; Tue, 28 Mar
 2023 04:53:12 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::97b2:25ca:c44:9b7%6]) with mapi id 15.20.6277.005; Tue, 28 Mar 2023
 04:53:12 +0000
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
Subject: [PATCH 4/6] Revert "PCI: hv: Fix a timing issue which causes kdump to fail occasionally"
Date:   Mon, 27 Mar 2023 21:51:20 -0700
Message-Id: <20230328045122.25850-5-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 502a4588-6066-4f16-6614-08db2f4855da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4ptgAIaeK7c+hL0WFjcPj1ic5OtXe1xgYixxzw9Qrct49TR0d+oo6OUjZQPVlEfjee08ql6tfzXsFoWmkKHnTsTrPyQuO3iMrULoBi55y47pf9IzrX2grxtySlX0Kg/vatq8uq90GdQx/Y3YdsWTA4yF6ymmq2rm+hRcfco4N76LVJHiKq68BK7pC4ivoL5Jk/bo6PHoayCkQJ9VB/FELAWwZtNJQn7vx8/PRq8jZGhDSj5xKIpMngf27ohIUKgoQ745X5bEcB8fRaMGW01E1ynEpDCRu36EU7m71TQM9hUjm+y2VHJWELRkSX1d4E93aE9C7soy8QbbmvGKqH/wU0LDu7qYesTdffwvxUSYFR6PgA9kFYCWqi+KJscvq5hladLv8/YUMhiXUtuFtjLz7SjT82cPcjEqR4GRsBumMV8tjbjkFgYB6qBW+JHk0+3NADxajic6LZOWOOJWARjmDjp0nxpnIZ/6jpbCBtwHfVD3fBrJdoo0mDKFxNIHPujy3Bmdmwh2/x4QZOuytq4PCQpgzONMX0bPgpDsllmdA/mucL5FIx/OClh1SPH0aDrQtDVq89HxI0T+3yZC6bCeCsWmdV5n1nrk6myf8cFzfTGQSdbnL0TiASo6NDW0iv24ZaB1qMI3aO6Dsm73t6ozg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199021)(478600001)(83380400001)(10290500003)(2906002)(1076003)(38100700002)(52116002)(7416002)(6486002)(6506007)(6512007)(921005)(2616005)(5660300002)(8936002)(6666004)(316002)(86362001)(82960400001)(82950400001)(186003)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VsKuDBijtF6cjuWgoO8+pVjZKh+BG8JvZri3aoPrG/W3wj2iJGrFUUKIVTg/?=
 =?us-ascii?Q?BZJhOipl4n/TU78y9PgiwGTwpYgowZnUG/SpfMFBvE3e2L4Ky2AClWfuScS6?=
 =?us-ascii?Q?Wt5GPQ7ldcGmLwvW9D4seNnJdQh54FIhJ1+iYHg+qK3Qiu3/hzfnI9p1PxTn?=
 =?us-ascii?Q?qq9wszxk9c4Z/R3JGmep20YBlu2c55pwfB+0KR97IeinImcacZqhRtIM9QGl?=
 =?us-ascii?Q?c3oINQJ6pSywvUvlhvoqEFJUM+b8A+l7O82UCRkiup4OQrMOjSSIlH2SUH8g?=
 =?us-ascii?Q?iSc4HtwZ1z3RKR7kJD83eatD8npfxdcY+3BIeZuDrGGRyKUbQ0m6G6QQ6WVI?=
 =?us-ascii?Q?nsRHW27Cl3DTCqhqschJRMJGKQZ9jMdFPAauo5XRdJ9XSxzoWyFKZfM77x3J?=
 =?us-ascii?Q?uQnujUGyqbHiLaaIn8shTa+wcMIvo3aQJZhdJ+/Fdly2XpoJo+ps5hUXUHrM?=
 =?us-ascii?Q?bSLhyh8DsyH2byc2avzPh746EjBcTPIzGEyYALP2H6lQK+hT60oULbATH6pk?=
 =?us-ascii?Q?rodvVku+OKsLxzLziTUWUk8eNQFk847elCbvAfxFvD1m+BSdaetxF070Ng8S?=
 =?us-ascii?Q?Dx8berMN17fDo0CIGUQaXaA/1LZkbqVBNkP++PCm1EPXmxR7xeyHE3smLIkZ?=
 =?us-ascii?Q?HB9v2U1ZUwTQmTH26zuzi/13Qvl3BWDaQ90rRPCuG7Kz3uYXKdppTY6JxXLd?=
 =?us-ascii?Q?DPvUl2ED2YWsMk1lXvUCjvmcZYnHTHWZOIGFgyOreR6odHSUnnhJ72doZRyn?=
 =?us-ascii?Q?b2Cdac4DqRLaH1J12msJ6kqG5rimu07sG0o3Iv98GnnmxAlGilV4Q7cw01rW?=
 =?us-ascii?Q?7CMVJn9lbHmJauBEqLnUYtvil8ghNrBit6wziPrRd4TDq3bzyPIaDfBBUE9U?=
 =?us-ascii?Q?//sEaLM7rX2fHML1cevImioKmL1tlB3N0Ws3l2vPIFJOO24X0kaaK2C0dDNR?=
 =?us-ascii?Q?HIBLFktB2wtQYm1vY9GDdKsOXkYSJUqogwFJnUztza9E91Wv6IVqs4WlB56w?=
 =?us-ascii?Q?QNM0E0jUIhvCAVsmUpvj7+uf2iHlULa2wumK/KEJoXUy6hQmuym8nTdi+sd0?=
 =?us-ascii?Q?if+XW0eFExi9RxqL3koztnu6xEdK8LcFB72FVVFaq49Pa4f445PSQOHXmFhe?=
 =?us-ascii?Q?6o43iICnG8z7wm1EosGkOck+Nsmn9C04W67NqyXcOmtJO7x7411eogBYzEVg?=
 =?us-ascii?Q?OxzKmTlZ9d3q549d2Aw0nWQL8lTF3cN27KYVHkkP8kS4ksXn3SoBl9vII0Bl?=
 =?us-ascii?Q?hIW2MRORXoWs6s5QFTZ6hp6Xsu1T0EIFI94wqzc6D5nC/51ZtSL2ceZjx280?=
 =?us-ascii?Q?hQS35XN6Li/L8cHQuukmDMrLPZYcEUnpwvnHiRyqQSVgoZ4MHiV4CZ54yBbh?=
 =?us-ascii?Q?QG9whFvGIWlZK7bDYwTHx0K/VobU3Mp3NK6biPZjdzHCNIyCRofKVRaUJmNp?=
 =?us-ascii?Q?nWRgIeFjhQehmQ3YK8JGVIfT6DbxgTYkEy+ybliCEKdWdJDITCa6H0FrNP+i?=
 =?us-ascii?Q?yKt4Awcg8IeSflmOChdlPAnYKwsKfOTO1JtGIFYPd6d2a+DORKPO1mnmhFb5?=
 =?us-ascii?Q?tGnmSak47OcfpNBHpKsXpSwsK/IufKggrtDMFYbzHynR5QlsjJpT8eY+pHs9?=
 =?us-ascii?Q?JNZ2HrOPsPVDegfDbynJuUjOYgP4SCi89n5/+cXZbv5g?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502a4588-6066-4f16-6614-08db2f4855da
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 04:53:12.9156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g750lvB1vGR18k9QyUBSKuScqMq+9VQk4O3A/AtvV5ZgEIxivlOI6SBvaLf7znY5COsDEkwCxBhXQnMEtCtK2g==
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
---
 drivers/pci/controller/pci-hyperv.c | 71 ++++++++++++++---------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 46df6d093d68..48feab095a14 100644
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

