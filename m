Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15513F6357
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbhHXQwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:52:17 -0400
Received: from mail-centralus01namln1003.outbound.protection.outlook.com ([40.93.8.3]:59676
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231792AbhHXQwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:52:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpyyoX+IugoFWVASpVim2cnJsX+gdLFnrkVvGJteqFKlzaIXgwWzE4ChbQwDFRiuQSmS8hLCnXTfb7v0dlad2tLicotAlGirlJCRQlcTRSfL4V18zR9ao6f9Dl1PHQ4G+xof1gyL/jz2do+/X7LC3Uc4YnNeFrhTaNjQiUoJNvo36+mvJP/9t9oXE2nr/50iUyVnRiCWcrFKQYLonm50Dr+Qt6Upx2uqpzwN0iiVTMTXuHLnqzDadK4T0QpdKrb73iHKF+CLyeuyr4MLs2n9FSa9aTpnIrxD1RnSgA9LmVKC1GClEMKOqEMcnAkASmdTgS/lEwmIbEqaWliJmQslNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UFppqmzBOpyIetks7QL9fLp4lH8qpSsw81UxFyilf/k=;
 b=NGG4gO4fEjp3WfzBf0ZLyh+iGv5NCcfhLZUlN8ZebxZJ1iHNphof/DIPDBM8r2hTO+mo330lGyd3lNbHTDV4ZozEhMXRUfe0EiX3Cq7cImrbdM6Ou6Pft7cx9vkzZTvPMDEmYf9IDu1xpEyP8q+IL6yXo+kfk9U7JZ7dFbqcOKYtatWOlGeFLpW1aF44Gh22AGWmnHD7RqueXKG365ZvsEETF3U6SyB818rx7FXm+SVZ6jguwdcqTTc5mGyAPrh4HvxUp+7nil3xEp80PMbCKo5x9QV/2NM9i3KdgBYovYC9x3GTUueWXm4THmERN911rnenvgLgz2JMxr5l/6ubHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFppqmzBOpyIetks7QL9fLp4lH8qpSsw81UxFyilf/k=;
 b=JI8rP5Xkzb2QBPAaPW9YsfKWXcvA104cfE3IQ699bRCdvXijLPOEj/zvjAsgD5WIKMu/IR2yPl65+jFqLc7epgL2mm9aFcpREuwI9Sm7uuFvhBd5KqXvfdgsAAe4FvdueAvWa9HfPpwxVUZUZLlKUITpmK/Har1mJtnWVeW3lhs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB1765.namprd21.prod.outlook.com (2603:10b6:4:a4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.2; Tue, 24 Aug
 2021 16:46:54 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::a09a:c9ba:8030:2247%9]) with mapi id 15.20.4478.005; Tue, 24 Aug 2021
 16:46:54 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 2/3] net: mana: Add support for EQ sharing
Date:   Tue, 24 Aug 2021 09:46:00 -0700
Message-Id: <1629823561-2261-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
References: <1629823561-2261-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11)
 To DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 16:46:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 941450d2-150b-4e37-d942-08d9671ec4a6
X-MS-TrafficTypeDiagnostic: DM5PR21MB1765:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB1765A70FBA7BBAB3BAD57636ACC59@DM5PR21MB1765.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qw+jNrIEv2HSfC1HvFEXv6NecjphZ/bnLLOEw7xS5XxZ/4QcT/SSDFHys63a3ontJfEFV2dnqojXmdS7aGXQ4bujsc6FMXKhLBmKlnHgdNjNn1ks7+z2WyM3OMbnQTFBE2Yp8PjLBPggwpzLYxvOJYcPXtbGFVQOqmdhcivDgdI5JE44q2uMsMfE8ZuaaYl+xCcQQ4vpKrThvFVXuSGn4C1vWlYCtET3M8oJuQapalo519IOCPq8rGOyWsxrxr3eO447hkhi0YpAJziLl9QhB0u/RLgO53mK0+on0Q0FhnWBOqaGtnlHVWmZAIJ4RA17nslOO9wxm5gjXrdH7SH4nIOe+p5IQtpM4zuVqlLkcrPi/CyLO0TCWs67hMS7aPviLskcYz/L3hVijLwyqPAuemI7i/GnO3aYaq23xVX6kRVKR2iiW1GowZy5Hw5SrZuwaKnffJBWYMIwNkYH+GUPL9/Dff7mj/Zj1wdckp9WQUpiziHeuyQQdYEQLHJIiz+fWn24K1rKZqWikqJSD79GHScIBq0bqKoxALpGjie8V67KHW30hMLo2nnFuWZxRwc2iDruL56Qchtu8SBDqwl7NsT284kXJG5kvipnFxT5cwwQmEx0uXPcVW6JBAUdBFpUwomIVgGEyXLomihf6jVdDhRBLsIuppo21+Q61WL09qKdaMW4re2wLT5BUHATNbR7pVzj/PThNQDJAAtQbia9AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82950400001)(5660300002)(30864003)(6486002)(316002)(10290500003)(82960400001)(956004)(6512007)(7846003)(36756003)(2616005)(38100700002)(66946007)(38350700002)(66556008)(66476007)(186003)(2906002)(26005)(6666004)(8676002)(83380400001)(4326008)(52116002)(6506007)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RxR61f73e7suETWCqK8qqT9EX7Z1IAR5SENXglKVOX0Cr8iFdRLTPgqNPCbM?=
 =?us-ascii?Q?fFiFdGYYfNy11fmK3cV8XA/xatYAa5I5RGdVybdIliOe9y/ZueiV3bLf6f53?=
 =?us-ascii?Q?C+XpF6T6pL2AOKUyJ3i/BNv4PBPokqBRFTo4UiUv1HoQ9WMikqMb8fMT8ZvX?=
 =?us-ascii?Q?EJ1GeDiEx4EdOpELeiuDpLiLGOUP772/YtwOk2TJ107d3GHGqUprjXctv9C2?=
 =?us-ascii?Q?Xf13OEH6XkxLyBQ7q0bGDwmIam3pbj3blW15V2TAQIZYFaApXY9DWWJfuwsI?=
 =?us-ascii?Q?7UHGthIjxYLm+7JrwqnAff3Za15QxXewU4cDQFtJHx3NYyN4fhSo/kvfIK9U?=
 =?us-ascii?Q?RsfV5q0TAe1XIs85qEIoJ9Dv0ZktiAHl2O6CA6QguYJsXFKsWNmI1WTSkAJF?=
 =?us-ascii?Q?MA1h7hBf19zyX5N6CZ+9PSBglRcxXWLdqvUCnYUhgH8+XXT8rkUZkgvtL9Qx?=
 =?us-ascii?Q?14lS7hHYJNsL4zNUQRbDl8xquwD+Zu30u1esRQZmm2GWUfy5NhWAbaUE7dpM?=
 =?us-ascii?Q?PbcoejFzSxVRah3I+J9eitxfx3jOwWYvWEd8RvisC5hytdteMmbiBPFuJqWP?=
 =?us-ascii?Q?momoxopOICjrIJai8O9lBpCrupouq+lBSs7GTjmj869kkdNum9S2PFSdizcj?=
 =?us-ascii?Q?r4vDkbDxl30HTC+BuAJknuzBeK7qG3Ik49hmQq+u3ujbaJyDufieYkPfauAD?=
 =?us-ascii?Q?xrRH+mDxJ+rqgakyqUowLVvESgTrbQCnYdY8aJHMYop1LyGKFcy0QDfqhMDG?=
 =?us-ascii?Q?GSjyhYDzgUXzJFCdAyP7NzxmHS8VdASSLfL2Pvw/SY220bNUf3pMzq+0uxvf?=
 =?us-ascii?Q?36TP+xOul6ZpyNOtv04LmDES7qtqamM4Ohlpe1bLlJZ/Z3To8c2OL1s0F/Nf?=
 =?us-ascii?Q?Y0N2FHJTZjOJCi3nC8DgdPLyC7ZdJ/irSKioiNQIBKtcE0dhB+0Y1saq6gNu?=
 =?us-ascii?Q?pr9kRgo31P2md5BVhNbtYLy79PS/GsPvF5P16Mtp/THw6/k6wuuDxx094STY?=
 =?us-ascii?Q?Qo/AS6z12BxskaXPPcReAbm2ynqQzLheLwcXVAhinaHlhxerCv1CvwD2nIOl?=
 =?us-ascii?Q?qDh7xZCm0Js/Klbgrx1DPWf/Laewryjt9Sp8881C/GoY8Ibcc1tz4aHDgoB+?=
 =?us-ascii?Q?c08v6HD16CkdEp2aixZxx6LkKlBsQKlVEI4Rd0OJrwQFAMXpPkDtymvwmop9?=
 =?us-ascii?Q?YM3Cy4I4j9vott4ylEUpnsXwzJgkPgoEGz6g2Bii3JQwoG9sst8H8k/5k2mD?=
 =?us-ascii?Q?RQ9dd1NQpN/nEUVU/xv6Q4+nsfO2Do9JvGMLPld0o4/jzVKNR+GHarQp1MWH?=
 =?us-ascii?Q?wmGthCAvRGudb2icS8NqvbWT?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941450d2-150b-4e37-d942-08d9671ec4a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 16:46:49.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o9PtSB73qFnpXXCLYPCd01snrJq3HcDFLZUuQiJfu9dx1s30jHWbjV2JTQzZmCFY655BGxIYZdRTXX1iD6VViQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB1765
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code uses (1 + #vPorts * #Queues) MSIXs, which may exceed
the device limit.

Support EQ sharing, so that multiple vPorts (NICs) can share the same
set of MSIXs.

And, report the EQ-sharing capability bit to the host, which means the
host can potentially offer more vPorts and queues to the VM.

Also update the resource limit checking and error handling for better
robustness.

Now, we support up to 256 virtual ports per VF (it was 16/VF), and
support up to 64 queues per vPort (it was 16).

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
v2: Updates suggested by Dexuan Cui <decui@microsoft.com>
  Limit max_num_queues to (gc->num_msix_usable - 1)
  Add BUILD_BUG_ON(MAX_PORTS_IN_MANA_DEV * 2 * GDMA_EQE_SIZE > EQ_SIZE)
  More detailed descriptions
---
 drivers/net/ethernet/microsoft/mana/gdma.h    | 23 ++++---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 31 +++++++---
 drivers/net/ethernet/microsoft/mana/mana.h    | 18 +++---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 62 +++++++++----------
 4 files changed, 78 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma.h b/drivers/net/ethernet/microsoft/mana/gdma.h
index ddbca64bab07..41ecd156e95f 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -312,9 +312,6 @@ struct gdma_queue_spec {
 			void *context;
 
 			unsigned long log2_throttle_limit;
-
-			/* Only used by the MANA device. */
-			struct net_device *ndev;
 		} eq;
 
 		struct {
@@ -489,16 +486,28 @@ enum {
 	GDMA_PROTOCOL_LAST	= GDMA_PROTOCOL_V1,
 };
 
+#define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
+
+#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+
+#define GDMA_DRV_CAP_FLAGS2 0
+
+#define GDMA_DRV_CAP_FLAGS3 0
+
+#define GDMA_DRV_CAP_FLAGS4 0
+
 struct gdma_verify_ver_req {
 	struct gdma_req_hdr hdr;
 
 	/* Mandatory fields required for protocol establishment */
 	u64 protocol_ver_min;
 	u64 protocol_ver_max;
-	u64 drv_cap_flags1;
-	u64 drv_cap_flags2;
-	u64 drv_cap_flags3;
-	u64 drv_cap_flags4;
+
+	/* Gdma Driver Capability Flags */
+	u64 gd_drv_cap_flags1;
+	u64 gd_drv_cap_flags2;
+	u64 gd_drv_cap_flags3;
+	u64 gd_drv_cap_flags4;
 
 	/* Advisory fields */
 	u64 drv_ver;
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 560472fa2d00..798099d64202 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -67,6 +67,10 @@ static int mana_gd_query_max_resources(struct pci_dev *pdev)
 	if (gc->max_num_queues > resp.max_rq)
 		gc->max_num_queues = resp.max_rq;
 
+	/* The Hardware Channel (HWC) used 1 MSI-X */
+	if (gc->max_num_queues > gc->num_msix_usable - 1)
+		gc->max_num_queues = gc->num_msix_usable - 1;
+
 	return 0;
 }
 
@@ -384,28 +388,31 @@ static int mana_gd_register_irq(struct gdma_queue *queue,
 	struct gdma_resource *r;
 	unsigned int msi_index;
 	unsigned long flags;
-	int err;
+	struct device *dev;
+	int err = 0;
 
 	gc = gd->gdma_context;
 	r = &gc->msix_resource;
+	dev = gc->dev;
 
 	spin_lock_irqsave(&r->lock, flags);
 
 	msi_index = find_first_zero_bit(r->map, r->size);
-	if (msi_index >= r->size) {
+	if (msi_index >= r->size || msi_index >= gc->num_msix_usable) {
 		err = -ENOSPC;
 	} else {
 		bitmap_set(r->map, msi_index, 1);
 		queue->eq.msix_index = msi_index;
-		err = 0;
 	}
 
 	spin_unlock_irqrestore(&r->lock, flags);
 
-	if (err)
-		return err;
+	if (err) {
+		dev_err(dev, "Register IRQ err:%d, msi:%u rsize:%u, nMSI:%u",
+			err, msi_index, r->size, gc->num_msix_usable);
 
-	WARN_ON(msi_index >= gc->num_msix_usable);
+		return err;
+	}
 
 	gic = &gc->irq_contexts[msi_index];
 
@@ -836,6 +843,11 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
 	req.protocol_ver_min = GDMA_PROTOCOL_FIRST;
 	req.protocol_ver_max = GDMA_PROTOCOL_LAST;
 
+	req.gd_drv_cap_flags1 = GDMA_DRV_CAP_FLAGS1;
+	req.gd_drv_cap_flags2 = GDMA_DRV_CAP_FLAGS2;
+	req.gd_drv_cap_flags3 = GDMA_DRV_CAP_FLAGS3;
+	req.gd_drv_cap_flags4 = GDMA_DRV_CAP_FLAGS4;
+
 	err = mana_gd_send_request(gc, sizeof(req), &req, sizeof(resp), &resp);
 	if (err || resp.hdr.status) {
 		dev_err(gc->dev, "VfVerifyVersionOutput: %d, status=0x%x\n",
@@ -1154,10 +1166,8 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	if (max_queues_per_port > MANA_MAX_NUM_QUEUES)
 		max_queues_per_port = MANA_MAX_NUM_QUEUES;
 
-	max_irqs = max_queues_per_port * MAX_PORTS_IN_MANA_DEV;
-
 	/* Need 1 interrupt for the Hardware communication Channel (HWC) */
-	max_irqs++;
+	max_irqs = max_queues_per_port + 1;
 
 	nvec = pci_alloc_irq_vectors(pdev, 2, max_irqs, PCI_IRQ_MSIX);
 	if (nvec < 0)
@@ -1244,6 +1254,9 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	int bar = 0;
 	int err;
 
+	/* Each port has 2 CQs, each CQ has at most 1 EQE at a time */
+	BUILD_BUG_ON(2 * MAX_PORTS_IN_MANA_DEV * GDMA_EQE_SIZE > EQ_SIZE);
+
 	err = pci_enable_device(pdev);
 	if (err)
 		return -ENXIO;
diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 5341dbdb726e..fc98a5ba5ed0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -46,7 +46,7 @@ enum TRI_STATE {
 #define EQ_SIZE (8 * PAGE_SIZE)
 #define LOG2_EQ_THROTTLE 3
 
-#define MAX_PORTS_IN_MANA_DEV 16
+#define MAX_PORTS_IN_MANA_DEV 256
 
 struct mana_stats {
 	u64 packets;
@@ -322,6 +322,8 @@ struct mana_context {
 
 	u16 num_ports;
 
+	struct mana_eq *eqs;
+
 	struct net_device *ports[MAX_PORTS_IN_MANA_DEV];
 };
 
@@ -331,8 +333,6 @@ struct mana_port_context {
 
 	u8 mac_addr[ETH_ALEN];
 
-	struct mana_eq *eqs;
-
 	enum TRI_STATE rss_state;
 
 	mana_handle_t default_rxobj;
@@ -402,11 +402,11 @@ enum mana_command_code {
 struct mana_query_device_cfg_req {
 	struct gdma_req_hdr hdr;
 
-	/* Driver Capability flags */
-	u64 drv_cap_flags1;
-	u64 drv_cap_flags2;
-	u64 drv_cap_flags3;
-	u64 drv_cap_flags4;
+	/* MANA Nic Driver Capability flags */
+	u64 mn_drv_cap_flags1;
+	u64 mn_drv_cap_flags2;
+	u64 mn_drv_cap_flags3;
+	u64 mn_drv_cap_flags4;
 
 	u32 proto_major_ver;
 	u32 proto_minor_ver;
@@ -523,7 +523,7 @@ struct mana_cfg_rx_steer_resp {
 	struct gdma_resp_hdr hdr;
 }; /* HW DATA */
 
-#define MANA_MAX_NUM_QUEUES 16
+#define MANA_MAX_NUM_QUEUES 64
 
 #define MANA_SHORT_VPORT_OFFSET_MAX ((1U << 8) - 1)
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 8643d8cf1d5a..a41a7e7b2bd3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -696,56 +696,56 @@ static void mana_destroy_wq_obj(struct mana_port_context *apc, u32 wq_type,
 			   resp.hdr.status);
 }
 
-static void mana_destroy_eq(struct gdma_context *gc,
-			    struct mana_port_context *apc)
+static void mana_destroy_eq(struct mana_context *ac)
 {
+	struct gdma_context *gc = ac->gdma_dev->gdma_context;
 	struct gdma_queue *eq;
 	int i;
 
-	if (!apc->eqs)
+	if (!ac->eqs)
 		return;
 
-	for (i = 0; i < apc->num_queues; i++) {
-		eq = apc->eqs[i].eq;
+	for (i = 0; i < gc->max_num_queues; i++) {
+		eq = ac->eqs[i].eq;
 		if (!eq)
 			continue;
 
 		mana_gd_destroy_queue(gc, eq);
 	}
 
-	kfree(apc->eqs);
-	apc->eqs = NULL;
+	kfree(ac->eqs);
+	ac->eqs = NULL;
 }
 
-static int mana_create_eq(struct mana_port_context *apc)
+static int mana_create_eq(struct mana_context *ac)
 {
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct gdma_dev *gd = ac->gdma_dev;
+	struct gdma_context *gc = gd->gdma_context;
 	struct gdma_queue_spec spec = {};
 	int err;
 	int i;
 
-	apc->eqs = kcalloc(apc->num_queues, sizeof(struct mana_eq),
-			   GFP_KERNEL);
-	if (!apc->eqs)
+	ac->eqs = kcalloc(gc->max_num_queues, sizeof(struct mana_eq),
+			  GFP_KERNEL);
+	if (!ac->eqs)
 		return -ENOMEM;
 
 	spec.type = GDMA_EQ;
 	spec.monitor_avl_buf = false;
 	spec.queue_size = EQ_SIZE;
 	spec.eq.callback = NULL;
-	spec.eq.context = apc->eqs;
+	spec.eq.context = ac->eqs;
 	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
-	spec.eq.ndev = apc->ndev;
 
-	for (i = 0; i < apc->num_queues; i++) {
-		err = mana_gd_create_mana_eq(gd, &spec, &apc->eqs[i].eq);
+	for (i = 0; i < gc->max_num_queues; i++) {
+		err = mana_gd_create_mana_eq(gd, &spec, &ac->eqs[i].eq);
 		if (err)
 			goto out;
 	}
 
 	return 0;
 out:
-	mana_destroy_eq(gd->gdma_context, apc);
+	mana_destroy_eq(ac);
 	return err;
 }
 
@@ -1159,7 +1159,8 @@ static void mana_destroy_txq(struct mana_port_context *apc)
 static int mana_create_txq(struct mana_port_context *apc,
 			   struct net_device *net)
 {
-	struct gdma_dev *gd = apc->ac->gdma_dev;
+	struct mana_context *ac = apc->ac;
+	struct gdma_dev *gd = ac->gdma_dev;
 	struct mana_obj_spec wq_spec;
 	struct mana_obj_spec cq_spec;
 	struct gdma_queue_spec spec;
@@ -1220,7 +1221,7 @@ static int mana_create_txq(struct mana_port_context *apc,
 		spec.monitor_avl_buf = false;
 		spec.queue_size = cq_size;
 		spec.cq.callback = mana_schedule_napi;
-		spec.cq.parent_eq = apc->eqs[i].eq;
+		spec.cq.parent_eq = ac->eqs[i].eq;
 		spec.cq.context = cq;
 		err = mana_gd_create_mana_wq_cq(gd, &spec, &cq->gdma_cq);
 		if (err)
@@ -1504,12 +1505,13 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
 static int mana_add_rx_queues(struct mana_port_context *apc,
 			      struct net_device *ndev)
 {
+	struct mana_context *ac = apc->ac;
 	struct mana_rxq *rxq;
 	int err = 0;
 	int i;
 
 	for (i = 0; i < apc->num_queues; i++) {
-		rxq = mana_create_rxq(apc, i, &apc->eqs[i], ndev);
+		rxq = mana_create_rxq(apc, i, &ac->eqs[i], ndev);
 		if (!rxq) {
 			err = -ENOMEM;
 			goto out;
@@ -1621,16 +1623,11 @@ static int mana_init_port(struct net_device *ndev)
 int mana_alloc_queues(struct net_device *ndev)
 {
 	struct mana_port_context *apc = netdev_priv(ndev);
-	struct gdma_dev *gd = apc->ac->gdma_dev;
 	int err;
 
-	err = mana_create_eq(apc);
-	if (err)
-		return err;
-
 	err = mana_create_vport(apc, ndev);
 	if (err)
-		goto destroy_eq;
+		return err;
 
 	err = netif_set_real_num_tx_queues(ndev, apc->num_queues);
 	if (err)
@@ -1656,8 +1653,6 @@ int mana_alloc_queues(struct net_device *ndev)
 
 destroy_vport:
 	mana_destroy_vport(apc);
-destroy_eq:
-	mana_destroy_eq(gd->gdma_context, apc);
 	return err;
 }
 
@@ -1734,8 +1729,6 @@ static int mana_dealloc_queues(struct net_device *ndev)
 
 	mana_destroy_vport(apc);
 
-	mana_destroy_eq(apc->ac->gdma_dev->gdma_context, apc);
-
 	return 0;
 }
 
@@ -1788,7 +1781,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->ac = ac;
 	apc->ndev = ndev;
 	apc->max_queues = gc->max_num_queues;
-	apc->num_queues = min_t(uint, gc->max_num_queues, MANA_MAX_NUM_QUEUES);
+	apc->num_queues = gc->max_num_queues;
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
 
@@ -1859,6 +1852,10 @@ int mana_probe(struct gdma_dev *gd)
 	ac->num_ports = 1;
 	gd->driver_data = ac;
 
+	err = mana_create_eq(ac);
+	if (err)
+		goto out;
+
 	err = mana_query_device_cfg(ac, MANA_MAJOR_VERSION, MANA_MINOR_VERSION,
 				    MANA_MICRO_VERSION, &ac->num_ports);
 	if (err)
@@ -1908,6 +1905,9 @@ void mana_remove(struct gdma_dev *gd)
 
 		free_netdev(ndev);
 	}
+
+	mana_destroy_eq(ac);
+
 out:
 	mana_gd_deregister_device(gd);
 	gd->driver_data = NULL;
-- 
2.25.1

