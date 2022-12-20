Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E330765239B
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 16:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbiLTPV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 10:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiLTPVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 10:21:25 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2112.outbound.protection.outlook.com [40.107.223.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B097D199
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 07:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JyXCx4DCJt5X1pnIKAyLywdRNx/aLdzoA6Kezjo39iIkNnfz8LoxOX+sIeU3ZOk+16dcZwuQUeqVkIOxa35AB+c+0sp6D8JDPkrthcAujUzP3pdaw24TncGzUY30YUGIhR/I1tVSUNxkZHaljmqCdTRWSrtgp4CGxcgYmWwZNT8Xbtuxqur+cgg1pTcurXA2qk3nZzVNiJSgY9pMdhWm3UH2Sv/KPMTp3UHSXmb1By6qSORoLu+VSSVHN7c9IzyQ+GRp72jx+AvCO9P10faRyBElkFrwUUVkCRLBQKFrMeZ4uh8HwSsS1wu8WVbRbzf5BrreVip1KLUe4N34Qy0RDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fdwt9lXo+ykHVJTQ/95Fna1baEhLYjJdfgFry7vbc5Y=;
 b=GPDLA7dcxsJKKcm6+7pivRejeHUhklZwScPenKgjwl0d5QBqYPz7LkatHNyH92htIt/KIWP4BzCqTjebnuYfyV0HFkmZOcrmHw9CYgHXL2uU6qfLHHmm6XLvsjTzgX+XavAE6DsPH5nJ0xSAmU08l7idmm4rd1SKdW6gNwRWAboWMesYjEnDX5r7HOP6vXiNWSfcb/2Ky2BdmTNc7FVEGAA5kSwXOM5PesHh95kAsHfuX39SENeWD5FvjfxZ2wmkipEXKAP7Cy4K/MzZVopzOzZ0NoRHajzm47kwCu80+LMI5d23kModmfp7OiodFFyktQLmcS47g34chCNgp96PTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fdwt9lXo+ykHVJTQ/95Fna1baEhLYjJdfgFry7vbc5Y=;
 b=mnJY84m59B49t0E12aORI8Pjwf43+1FKPWviZVOZHFGYUEhDNslZs5VcJx4lVDy9ZyX2jmUEJTpK0kcQNmw34aIKYoZnC5EJH7zuhEFGEdTSBGdx90jAmv5h2JgQhckAIqaElhjnM1fCL7x6ap/QKmZUkS5ULmVHWBeSsyAzwFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5112.namprd13.prod.outlook.com (2603:10b6:8:11::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 15:21:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 15:21:20 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: fix schedule in atomic context when sync mc address
Date:   Tue, 20 Dec 2022 16:21:00 +0100
Message-Id: <20221220152100.1042774-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: b891907a-8290-442d-10a1-08dae29dd8e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5gE62bYy8RruttfQeUo6ZhXswNy6MRU7codLwccjxZqypV2r9pdw4QaoKvLB0awbe1Sy4XlixlJnoAHW9xFCCT80stH+qZOeT6PC8JihV38P7wxROtIXB3a52XB9swGEpq6jla6JADU/P9gnUKwlVdc5hy769uvzafXEGn87D5B98LaPT96K8GDFRxATUdXJ74cEiwi6TnJNgHfFYFRRJh6xFNQFSMUUM1LKqD1LtzD40a1GjUOvyb8JAr11zE8Bv8si7W2tJlequ9jOND7bOiIsuo7KzxwpT+NcoEmuWIZWBrOde2M8QaNHuMr/YJabzph9dAusoTywQmdIcNFVzBqD0lkOGCyDHvXOoOLI5o1qvtUygaH+qfH6tkk2NWLFxQ4UnAVNPPOy1ZfjZRjXH7GfP/2D+bTcDySk94sN6FnOgJ/QWUvliqY16R3ThP5IaEROTkXsQ412Ni9rjO+a9fXc9mH97gukE7J068pCWVYn3A192ZHdGb0n3JjB7tOnNgyQMGDWaKjRlkmVQjqV+JUk9QrLmXuAFSKMrRsrVPBEWAkSLYC2SYtVolXId7rooo8Nu9g9rP2kkfHnw7yVEUDmDzXekqKJGHM81xENikfhGMeQHlsRx24Hpcgwh/P2esKb5UP6MXKzo3dRJ6tppQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39840400004)(136003)(366004)(376002)(396003)(346002)(451199015)(8936002)(8676002)(1076003)(4326008)(38100700002)(83380400001)(44832011)(36756003)(5660300002)(2906002)(41300700001)(52116002)(6506007)(6486002)(107886003)(6666004)(478600001)(110136005)(316002)(2616005)(86362001)(66946007)(54906003)(66476007)(186003)(6512007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fm0gcPOo8+TtuhnLl54uxbA3FfLD5qGLbj6IEh64x13C4TS29eckGVjdLl1e?=
 =?us-ascii?Q?c1GfAreg30fcy/kq3TnK6ln8JD0osLQjXn8ael9bpcPYHyLwGxHggJWUAReM?=
 =?us-ascii?Q?V2W4HXyKGDg9gQqbyw9TGDTHia9u2Nopbxek6MxhUyMqFKz8jMtAB0WpPoIm?=
 =?us-ascii?Q?37quBn1bq4UGOxp2Plux5sghVkOX18Z1Zm8HzqUc+KE2vYnG/9oRVelbGQzb?=
 =?us-ascii?Q?yRNXc6Eo6xqs7AfxwZQTejzRE9tVkBVKU/sQOXZE1ON7zBglX7U1k1JJgTuS?=
 =?us-ascii?Q?4xxbgiG3u1W4pT0ke07DRfFYwoPaQjYJ0L91rL6feTJa9DnLbXlnAorKAUyj?=
 =?us-ascii?Q?+06B6NndxzHwf4QUNv0zTOb8KybKlAtv5Cyh7qHjZ2TMhV2wo/0M+/jPLRj2?=
 =?us-ascii?Q?fOQ4anpq5Y4WDq0PDmmeIUjMb2Pj7uyC5tP5goaBR6PMc3a6ihQzEjSAuTxS?=
 =?us-ascii?Q?A7bAMWgM9qf7fz3Yuu4ZHMCKI/IndBHBMDSVJ/MmIiJmXaiIovhWQGqSIO/o?=
 =?us-ascii?Q?C1fZaZVOT5x+Q0j1RdrkTzSGVaWSS3071L1+/F0CUAsHNo7+Ck1Zb5UgRM3L?=
 =?us-ascii?Q?jUSGG1zh2GPR6oQyzwVZqyL84Us1DVzENeyortRF/JyT6bF+Rutoc55FZv/0?=
 =?us-ascii?Q?V8bG7D7q5r5Jaty4IQXjPQtNHN0vnDPaeoXQg+QndpXpp1FZ9iyhY/4On/+x?=
 =?us-ascii?Q?4CHNtazRJSKILzPNVnfvW3OBeC2FnhRXwqYu7yeCKA5eCbUBvVbrt2f1nmSd?=
 =?us-ascii?Q?VgqPc30r7zZdr+QIen1uXJAYwag0dU23phCoJzgesTXCvXXGam4TMFjEgdwJ?=
 =?us-ascii?Q?jS/vBChiqc2iZYE9iA6BWhPCq17V83kIJARn1XahJQlqARAkVBGScsFXQrmS?=
 =?us-ascii?Q?hG3mdiEwaMjQW+fr/AI6LxJf/feERib9wfHxyK9/C6pM3XGxvQXfNALrM41N?=
 =?us-ascii?Q?FqGHI+JUg0ZV7oBM/Vsq1zhlTFEJg5uhivXZbgaHlQLLZcA7I/63oWDJpxSH?=
 =?us-ascii?Q?pU7FDsb8N8M9eSn42NB8bpFxXh0940KM9/7fNFulFMfkmhKMwElA2fT17Msq?=
 =?us-ascii?Q?X6c2NdFMfLe8/JfzRCHARqeFWxjRlanGHhy4RAEU4xwtdsVsEFx2T/bz66Ru?=
 =?us-ascii?Q?Gaf+GNnPkSEMaL5SGM6jD5NadvY4T7G3poeB7wqc/TtQJTTi+PuZZo9gE243?=
 =?us-ascii?Q?5nIFVMZKvdEzoRifn9hlutOGBx2VZT1ltplZ0fusnICSKHK2hjUfzkWmLyBh?=
 =?us-ascii?Q?z2GEIFntQFmLQlnYZ7MFRwGjxu9l/C4iqXjbaLRpzU2oXW3A08HLz9SRWWG9?=
 =?us-ascii?Q?7v0McxwEUhEcWnfnjhWO3nurwLdv8CU7neAOrqZjIrC98KBb8vRgy9fBPSyl?=
 =?us-ascii?Q?+Zue3lzoneEHpMgOcWJgAl2XhLN1y5kg5dGO8CUC4tHsL32mWWeD0Uf3aRaI?=
 =?us-ascii?Q?FP2tUvBWNoRMpqtAmHtRceQeivmiXnALs0ZIZFP89fuBy1BZYko1Cy9yBgtI?=
 =?us-ascii?Q?SjWp+rAp2QLhvTX86Ho72cnsyL4qJb4udZj0gs/ifNivPaSt/PIkGJ5Sv1b5?=
 =?us-ascii?Q?D7T+r1y1UmJl6XcYFaihQXDOuYd3/GaBp+axzNkbOFa8A/zgGLA08CguObnc?=
 =?us-ascii?Q?KFgsEwqS97cS4tUuAJuKvPSYXyBMw8k9pljZn/SD87swOqGJx/AUoZrgiTqB?=
 =?us-ascii?Q?jBeIHg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b891907a-8290-442d-10a1-08dae29dd8e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 15:21:20.4435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +eGOwn2qHA8W+aDgxiHyJm6dFr0pgF7tdMD7MrKzum3xETT8ZUTKpxcwfzr/Mw5v1f/75NkLVSdBCchhOFphrccuztoJS0Xuh2KPVOgvJkI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5112
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

The callback `.ndo_set_rx_mode` is called in atomic context, sleep
is not allowed in the implementation. Now use workqueue mechanism
to avoid this issue.

Fixes: de6248644966 ("nfp: add support for multicast filter")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  7 +++
 .../ethernet/netronome/nfp/nfp_net_common.c   | 61 +++++++++++++++++--
 2 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index da33f09facb9..432d79d691c2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -617,6 +617,9 @@ struct nfp_net_dp {
  * @vnic_no_name:	For non-port PF vNIC make ndo_get_phys_port_name return
  *			-EOPNOTSUPP to keep backwards compatibility (set by app)
  * @port:		Pointer to nfp_port structure if vNIC is a port
+ * @mc_lock:		Protect mc_addrs list
+ * @mc_addrs:		List of mc addrs to add/del to HW
+ * @mc_work:		Work to update mc addrs
  * @app_priv:		APP private data for this vNIC
  */
 struct nfp_net {
@@ -718,6 +721,10 @@ struct nfp_net {
 
 	struct nfp_port *port;
 
+	spinlock_t mc_lock;
+	struct list_head mc_addrs;
+	struct work_struct mc_work;
+
 	void *app_priv;
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 09053373288f..18fc9971f1c8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1334,9 +1334,14 @@ int nfp_ctrl_open(struct nfp_net *nn)
 	return err;
 }
 
-static int nfp_net_mc_cfg(struct net_device *netdev, const unsigned char *addr, const u32 cmd)
+struct nfp_mc_addr_entry {
+	u8 addr[ETH_ALEN];
+	u32 cmd;
+	struct list_head list;
+};
+
+static int nfp_net_mc_cfg(struct nfp_net *nn, const unsigned char *addr, const u32 cmd)
 {
-	struct nfp_net *nn = netdev_priv(netdev);
 	int ret;
 
 	ret = nfp_net_mbox_lock(nn, NFP_NET_CFG_MULTICAST_SZ);
@@ -1351,6 +1356,25 @@ static int nfp_net_mc_cfg(struct net_device *netdev, const unsigned char *addr,
 	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
 }
 
+static int nfp_net_mc_prep(struct nfp_net *nn, const unsigned char *addr, const u32 cmd)
+{
+	struct nfp_mc_addr_entry *entry;
+
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+	if (!entry)
+		return -ENOMEM;
+
+	ether_addr_copy(entry->addr, addr);
+	entry->cmd = cmd;
+	spin_lock_bh(&nn->mc_lock);
+	list_add_tail(&entry->list, &nn->mc_addrs);
+	spin_unlock_bh(&nn->mc_lock);
+
+	schedule_work(&nn->mc_work);
+
+	return 0;
+}
+
 static int nfp_net_mc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
@@ -1361,12 +1385,35 @@ static int nfp_net_mc_sync(struct net_device *netdev, const unsigned char *addr)
 		return -EINVAL;
 	}
 
-	return nfp_net_mc_cfg(netdev, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD);
+	return nfp_net_mc_prep(nn, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_ADD);
 }
 
 static int nfp_net_mc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
-	return nfp_net_mc_cfg(netdev, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL);
+	struct nfp_net *nn = netdev_priv(netdev);
+
+	return nfp_net_mc_prep(nn, addr, NFP_NET_CFG_MBOX_CMD_MULTICAST_DEL);
+}
+
+static void nfp_net_mc_addr_config(struct work_struct *work)
+{
+	struct nfp_net *nn = container_of(work, struct nfp_net, mc_work);
+	struct nfp_mc_addr_entry *entry, *tmp;
+	struct list_head tmp_list;
+
+	INIT_LIST_HEAD(&tmp_list);
+
+	spin_lock_bh(&nn->mc_lock);
+	list_splice_init(&nn->mc_addrs, &tmp_list);
+	spin_unlock_bh(&nn->mc_lock);
+
+	list_for_each_entry_safe(entry, tmp, &tmp_list, list) {
+		if (nfp_net_mc_cfg(nn, entry->addr, entry->cmd))
+			nn_err(nn, "Config mc address to HW failed.\n");
+
+		list_del(&entry->list);
+		kfree(entry);
+	}
 }
 
 static void nfp_net_set_rx_mode(struct net_device *netdev)
@@ -2633,6 +2680,11 @@ int nfp_net_init(struct nfp_net *nn)
 
 	if (!nn->dp.netdev)
 		return 0;
+
+	spin_lock_init(&nn->mc_lock);
+	INIT_LIST_HEAD(&nn->mc_addrs);
+	INIT_WORK(&nn->mc_work, nfp_net_mc_addr_config);
+
 	return register_netdev(nn->dp.netdev);
 
 err_clean_mbox:
@@ -2652,5 +2704,6 @@ void nfp_net_clean(struct nfp_net *nn)
 	unregister_netdev(nn->dp.netdev);
 	nfp_net_ipsec_clean(nn);
 	nfp_ccm_mbox_clean(nn);
+	flush_work(&nn->mc_work);
 	nfp_net_reconfig_wait_posted(nn);
 }
-- 
2.30.2

