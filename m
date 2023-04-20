Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3B16E8827
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjDTClq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjDTCl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:41:28 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021015.outbound.protection.outlook.com [52.101.57.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DEF81AB;
        Wed, 19 Apr 2023 19:41:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsZc7gw1AHgIWAzLEbQkxObgkWzgUSRJQMrZ2hMbcChSxC0wHAjXQgbvcJMqEdUUAW40pP5SQ93JnS0fpjpG0tnismK4Lt5xwMUxsHG9SRe6wOu9F4krp6RfcSTuV/9Wen905K6j7z1FQwP02f2rJ7lGGxLLcezjLEU+Zk4I6F3KQD/L5mwP9MgZmikJKohpR2CRSs7fBqnXpLROb5K6zWbv0efBbSeA955CcjSzNZQq2oPPkubZhn9+tSy3D7qqHKvlvx9I5Bh+OCiefs27R1/foPZG3hsnaHAmDpORvLgTcmhLIjj4JL8m1odcD3+dcQOhxxFUfWUNd0efRZRfHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3prjjBiDMNJjNVQK4bImxHlXF9B4TpfNKM7lAedvycY=;
 b=d57+zW/Hj/LPYi4w8LvbBj9w0xSbf8bV8pZ+26t0UGJcJO9ftSIUZs6kNQpZjYMDxkwq6x/bzSmeuXSYFqOAxYJByLVXXOokzyw96udcicxGbmSdBgz3wLk+pK5lRQ2cgiKQQ9FmJaVZwteQaXInmbXqZCCsDuLdg3kA056IVBmGI7crv0/cVnF/zVpZTK3h6cp5jXxSxH9bMrv+ZjfCirSnTEv+Cj4VBcOGuewaJ2F+Xhxf1a1j5/ePPuzfUKpIXsSoSA2lns7IY7Z11Mj95NWpkHvMA/CDSLa81uvc23siAeGdfXSKpkRnSAlFxvT1X7uibiOi9e9fX+1Jmv5vvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3prjjBiDMNJjNVQK4bImxHlXF9B4TpfNKM7lAedvycY=;
 b=BCXlCBWiPedKFtPNeKs3iNmRt9NraVZpOeNS1wAEZqpSGpp3wpfMbdcED4rhhJvO5rswJNoE6dkRGixYRWhKbTgpTdxng2j1xBvPnXiIsTEwWJid8nHAyG7dBw6qqoWAaNqtXJZz5nMINDPRGF2vvytwXQ3+CoSXtDk4Q8pBH6A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 (2603:10b6:207:30::23) by SJ1PR21MB3411.namprd21.prod.outlook.com
 (2603:10b6:a03:451::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.7; Thu, 20 Apr
 2023 02:41:20 +0000
Received: from BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30]) by BL0PR2101MB1092.namprd21.prod.outlook.com
 ([fe80::932e:24fe:fc1b:5d30%5]) with mapi id 15.20.6340.009; Thu, 20 Apr 2023
 02:41:20 +0000
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
Subject: [PATCH v3 4/6] Revert "PCI: hv: Fix a timing issue which causes kdump to fail occasionally"
Date:   Wed, 19 Apr 2023 19:40:35 -0700
Message-Id: <20230420024037.5921-5-decui@microsoft.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4e5dc93c-57fc-4f73-847c-08db4148b909
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jq0ghVO0abZWhGzT1O4GiqfE6Wbvw1Jr2I9DDqKdJbYlD1MLRvF60Jnztwn8+TNUgV5i8b7G1YMuYmhlsIy4paY7TDMAawaBdLQjDUivL1cs2DoZHppADS3Y2rh7LwvYDOc2DP4roGhPwZpf+6WUq1rSTSC+dZdvUHRzQTPuZ5CvRtzYj+XIbizVJkPZOBl3WtsKphyH+hRE1uZdGyDvtmby4P7XBWKk1YCZSbe4VgBBqNOz1hSz8C7TM/v0EJoAL3GPiNX8d3x+/ZzcahZwwwmXEsYj2DMancJTaV3LqzEG1bojHTV6iA3YWmFcnaNlG8QcPT01Twy64vQoDjDdJAbS4vU6YJ/310up5zgFqCxreao0leM1J+vY+3utqKdxAScVoSxSQ3Xr8plVYTllHq+hpxv1tVdPwacnTG4xGEZ132NkITfU62zP8wfMxg00kcbuisqJdJuMHGu0tnbkEFtXZkqc1OMWammlALZ9ZJxnTrFyf7Rjxxlhd2CgZVUidsK3Fev9NoLHch6jJeG+Jwimky4GPWkUef7SgX27o4g+0dUsFdOb3A3o+M4DGWRwwM7FUN+PZ5nt3Vh6C26L1kU7iqCgwrSSXImSrQvqnrQZRi3ta+/953+inbKfcxfpaiSn2fzbK025qjZRgPa+GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1092.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(451199021)(2616005)(83380400001)(36756003)(186003)(6486002)(6512007)(1076003)(6506007)(6666004)(52116002)(66946007)(66556008)(10290500003)(66476007)(478600001)(4326008)(316002)(41300700001)(82950400001)(82960400001)(921005)(786003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ek2q8OfZ+O0tMV41bWwWhzW71JlZsa+3geawA5sqpqSeqw8pqAbS7ZOq0vw?=
 =?us-ascii?Q?xqeSAhPAP7oe+EiZWx5NZhP394n6GYBq8LkDDYTn3WPy+TU9z2j1mYABXtXF?=
 =?us-ascii?Q?Kh+PzbDuFyl6qkXrPTKjxozrKbKpUtdOxgeyEhUo6BVp54L+fzP7PJ5pWGl7?=
 =?us-ascii?Q?kVsNcnxe2fZyv3tslHFjws5/azybNxjt31S2iNqOihxiuou/yXkze72kT/zk?=
 =?us-ascii?Q?C+L5FbcpG5E/K3l/5M3PdSEg77Lobfw2POpy6rwqq03dvuaXcUGGDQBf9fPg?=
 =?us-ascii?Q?J0UongAIxsyTzVUs5xdc3h3KmKR9DBsIRo2bP3pgs7l9UKXZLtI+VhSyYY7l?=
 =?us-ascii?Q?XdmcXDn0pBYosAnw0ZhoYtj8QKjDp+dKs3qbVwFIJA0h+LXqHGZvK5tyy9X4?=
 =?us-ascii?Q?oUOVGn6TpEHDQcghOWDdgfxC9nGU+W11S9Ot/iQXhQue2YiTVa6E54hQU3Cz?=
 =?us-ascii?Q?CH59jYJwsg2pMs2SGGxxKgb4tjSe4Xlm2Gtr92cmfPOw/YQGar9DqxVmBIfk?=
 =?us-ascii?Q?l8sUrci1DcdgFftQI8NrNDtdpyWvtNcvrmwmZNNwxO15KHYtfMtWi11Z7do9?=
 =?us-ascii?Q?tbP8bp2tAf3sEibSUt87Scrox/FlOaIHwhKE85VhPKNAXVh/e9OxbpALzCeN?=
 =?us-ascii?Q?n6gNgH70WxDwgJ8geoGLLxArSwt1HCicpydpQt3TqrdLUH7Oneg9TC+WRB8y?=
 =?us-ascii?Q?FxsGBk+H51xLsLA5/dAR0VW9oh7eJ+GlkPnllpXyTZbWzGwMUeWZKh8UuIYW?=
 =?us-ascii?Q?tB1IaZPGJNnx2TTByvlZXyKfZAYzyiIgxjLzi4dYNc1nWTdeB9CP57p2ypIU?=
 =?us-ascii?Q?jkqnjXMc/qBcsFDMYIWqJUQ+yeD0edkDO1WIZyPWRs7pOQngmhqioF0PIwct?=
 =?us-ascii?Q?mUqAMicUvREWGcpGinCJTiDYu51tx5QXvryUSvb/Pd3Xflkwimhfj00ouNJW?=
 =?us-ascii?Q?jnkyZmaqo6CHHNm5waq/m3pYt1bbloRRxcbtd8hw/dk7XeofH56DOz7LTTW1?=
 =?us-ascii?Q?9uO+t7FneNdhnDvAa+PV99nCwz/Q1zqx0AEiLqYpukLqmfe2/Q+5VoYUnc0F?=
 =?us-ascii?Q?P4IvRAtnPoGY4w4kknZU6DWcu0xR2avQuN16ZA45uI2DrAaMbRZeWd3deh4C?=
 =?us-ascii?Q?JrxLSDCXBGidUJNFCDx90VVRavLOkFoeb6dKDpMeS5smg4oRcZSs0Q7hnqEC?=
 =?us-ascii?Q?KisE6PIqwO5QwgaGZkYWW/wGgPHMbWcghQIDJzvZDN7rCqlrBlrCauOZ05Tq?=
 =?us-ascii?Q?Qf/uIcCJKn9LTf9kIjJO1J2KJDsLFlScSavx3fMdiMt5oOeRQDu3mUFrzuvB?=
 =?us-ascii?Q?uIAS3upaMJld0id9AG6cH7NfhZdCITG9Eb5THxtxgH/48tWGoqcn39FkmhsU?=
 =?us-ascii?Q?5cL7xRCQRtc1KC6Q4AYug9NOp3v/aWof0QAyNkJTW9iQ40VT0/YkSjpsefiK?=
 =?us-ascii?Q?UXrl8n/3f9eDO5wXHRs7dqPV/FT2FuiADxiVp7Bl+usMUQaPpTFU1F+hRoLs?=
 =?us-ascii?Q?X9ifh9oF2IfATC7/y1QnayW5WWYulpw4HxwWKxwuROHcnuuTevPpt7AToksf?=
 =?us-ascii?Q?W+GyT3ryEIysOx0r0/KsXnRVchhKP27WxF9GpSG4vjHnZpBrbg5xCVG72QRJ?=
 =?us-ascii?Q?KM9wMmyHO2XQAlpn5022iOWokz67x5fjd/bVlN5PQewt?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5dc93c-57fc-4f73-847c-08db4148b909
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1092.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 02:41:20.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXlWjZIjS8O9VIO7fLtuMLmUA5pUOos3rga+sC7WoO+dgZoofdBfEoN0CfA+VdsTQf45JTUHN0eav4vDUpt73A==
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
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Wei Hu <weh@microsoft.com>
Cc: stable@vger.kernel.org
---

v2:
  No change to the patch body.
  Added Wei Hu's Acked-by.
  Added Cc:stable

v3:
  Added Michael's Reviewed-by.

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

