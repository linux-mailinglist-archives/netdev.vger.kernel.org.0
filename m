Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D1969BF2B
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjBSIkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBSIk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:40:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AC5FF3D;
        Sun, 19 Feb 2023 00:40:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAmqciNOymFSj54MWCmeK8RcW4kOc/OQ2IEb/JWc8wUS8H2Zl4mooeBeskoWhvIHp5EAYiZdD+q5zGDr782rO0q0Ap+edXLnU2++V4f0xNAwgjWHrX+c5vyVuXHCwCl3ysJ3GD+akANd8lzCWPCtrcRfjC3beaIxt2Oy7BleNvE38Z3jn3yWk/ZRlYNaiZCp+j9y6K8J/1c4T9Qb3LmLKPipzhDWW7D2mcCj8Zb15Wl4Y5ENvWoqsUTvTXXBTYGvH4L78WEgbe0WbUqL8pntkJVzLC8YmivmsLRzqQk2p1JOU5pbmSDEeeqTJkMxlNkSC5aXQBdcTWtHJdNE+bkJBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtrMvI0DuHif4UOFQ8Gq5vULGnkoQ1ASNHsJzY7/fAE=;
 b=gINbm4zaSTKQPSYjfetZJLB+0KULJbQenRoLtLArWEG0mY8JJkJvNxQUfHYhMTeMYF5nH/7BN/ZfEIVSjfRIZp1jMgcT5hAFFSXv6Z2gBjhdlYYDfWirWxyGz3L93NNnXKV1Wa5Irf5AJCWJlFkfEQvw/Q7j4f5othpBmp9ueAzNMubcTaUWlpAECZv8bQp/RPUCw+bN+UgHPHL2yxXlqz8S2omkkWmiYr96mk3HB3r9bK5NX676CNPb2hgSSHZkDsvuhz0TO5HHRW5WbtOMkZO9olRoCYC7Aktdklp8APxPXOPvLyk5mWnNUxChDEeDGWhk053HsUKU6GCtRw3iLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtrMvI0DuHif4UOFQ8Gq5vULGnkoQ1ASNHsJzY7/fAE=;
 b=wLBzlVVRaL+GXAIUQS+vw0ekXbaJjI5k8wVjt18+auCsrkr8fyffSRCOdplg6oxTq9OArJXX2rQgmi0dCKD3IcNJj3z3N/qrxocS81ENcEKZ6C4o9tu/nLiQ5lGLbnPTn8Kf2zmm+snW9yi82aG5ey2eHO2e10mMfsBPjpNXLWY=
Received: from MW4PR03CA0130.namprd03.prod.outlook.com (2603:10b6:303:8c::15)
 by SN7PR12MB8170.namprd12.prod.outlook.com (2603:10b6:806:32c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 08:40:08 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::d6) by MW4PR03CA0130.outlook.office365.com
 (2603:10b6:303:8c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18 via Frontend
 Transport; Sun, 19 Feb 2023 08:40:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:40:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:40:04 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 6/7] vfio/pds: Add support for firmware recovery
Date:   Sun, 19 Feb 2023 00:39:07 -0800
Message-ID: <20230219083908.40013-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|SN7PR12MB8170:EE_
X-MS-Office365-Filtering-Correlation-Id: c960a44d-277a-4dfd-f58c-08db1254e808
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: To+cpii2ZSALETcr1AJgLdPeFNKV3uonB+aTVQctquwNo6SsAzxb+OLl0EAqEu+b4MTvBRgUnggFgIzVr7dd5w0az12RVAnV3rDv9OH18oiIRWjZcEitx32KbVVmsbla3Ek7ZgTNKeJB3hBgKfaaKgJYkMQykXyzbeZEvWGL4XgdnjfFszLPtpZPdfvsxL2QdY3K1fZ/h55I2rBbCHFV+mwC63VpqmWqm+bHFL1IKYywI/TWegUY5FjXr0WYlMLqhMyv7pimbsFgt7sS+1JkTcTcdJ2YJKF/k7blBdPZyF1/18kzUqaOt3LtAH2uHsTEpZv1bTwR8fOjXmGifuLQjKczTHXf6XZloE+831PyIkIp23rMtr72zcUYMqBf42KPzPi2ciBreijC+zs3xAWOtLTClHL0FPjp/LTivZVsVt4GCFwJ0Z90E5CfC1Qgj53a4iD+BWX5Lxx7y0Qx9XTKWc0GtIeP1iW+ac+sbJnfwCPwGCEMrNSg7WeYVec5HnZ0bJ+pTQ5hRUSLmvOjPUC0tuuJKUE67caq/mSe8Q7KnHpa3aNPhcbu8nSEq8YQzorsMTdPlTZ6l4tK+KADuguIHF44505Vo9DAQ9Q7C/jxV7v21WjdvRixUCnuMNYzdUIXr3VVoyr03247HgL/6fFYzd+YnfIv7rbZyn7VyMfFT5xL4zkwq49LkQYIkqsZUW4sgFvGFC4JoeufF6J/K7Nb/s7ueyZ4hbG3EdKH4Lp78xw=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(44832011)(5660300002)(26005)(16526019)(186003)(40480700001)(1076003)(426003)(86362001)(47076005)(2616005)(336012)(83380400001)(478600001)(356005)(36756003)(2906002)(36860700001)(8676002)(82740400003)(316002)(41300700001)(4326008)(70206006)(70586007)(81166007)(110136005)(40460700003)(54906003)(8936002)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:40:08.0948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c960a44d-277a-4dfd-f58c-08db1254e808
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8170
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's possible that the device firmware crashes and is able to recover
due to some configuration and/or other issue. If a live migration
is in progress while the firmware crashes, the live migration will
fail. However, the VF PCI device should still be functional post
crash recovery and subsequent migrations should go through as
expected.

When the pds_core device notices that firmware crashes it sends an
event to all its client drivers over auxiliary bus. When the pds_vfio
driver receives this event while migration is in progress it will
request a deferred reset on the next migration state transition. This
state transition will report failure as well as any subsequent state
transition requests from the VMM/VFIO. Based on uapi/vfio.h the only
way out of VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET.
Once this reset is done, the migration state will be reset to
VFIO_DEVICE_STATE_RUNNING and migration can be performed.

If the event is received while no migration is in progress (i.e.
the VM is in normal operating mode), then no actions are taken
and the migration state remains VFIO_DEVICE_STATE_RUNNING.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/aux_drv.c  | 61 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/aux_drv.h  |  1 +
 drivers/vfio/pci/pds/vfio_dev.c | 34 ++++++++++++++++--
 drivers/vfio/pci/pds/vfio_dev.h |  4 +++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/aux_drv.c b/drivers/vfio/pci/pds/aux_drv.c
index 4b1f06f8aac9..2d5a3225c786 100644
--- a/drivers/vfio/pci/pds/aux_drv.c
+++ b/drivers/vfio/pci/pds/aux_drv.c
@@ -21,6 +21,46 @@ struct auxiliary_device_id pds_vfio_aux_id_table[] = {
 	{},
 };
 
+static void
+pds_vfio_recovery_work(struct work_struct *work)
+{
+	struct pds_vfio_aux *vfio_aux =
+		container_of(work, struct pds_vfio_aux, work);
+	struct pds_vfio_pci_device *pds_vfio = vfio_aux->pds_vfio;
+	bool deferred_reset_needed = false;
+
+	/* Documentation states that the kernel migration driver must not
+	 * generate asynchronous device state transitions outside of
+	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
+	 *
+	 * Since recovery is an asynchronous event received from the device,
+	 * initiate a deferred reset. Only issue the deferred reset if a
+	 * migration is in progress, which will cause the next step of the
+	 * migration to fail. Also, if the device is in a state that will
+	 * be set to VFIO_DEVICE_STATE_RUNNING on the next action (i.e. VM is
+	 * shutdown and device is in VFIO_DEVICE_STATE_STOP) as that will clear
+	 * the VFIO_DEVICE_STATE_ERROR when the VM starts back up.
+	 */
+	mutex_lock(&pds_vfio->state_mutex);
+	if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
+	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio_dirty_is_enabled(pds_vfio)))
+		deferred_reset_needed = true;
+	mutex_unlock(&pds_vfio->state_mutex);
+
+	/* On the next user initiated state transition, the device will
+	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the user's
+	 * responsibility to reset the device.
+	 *
+	 * If a VFIO_DEVICE_RESET is requested post recovery and before the next
+	 * state transition, then the deferred reset state will be set to
+	 * VFIO_DEVICE_STATE_RUNNING.
+	 */
+	if (deferred_reset_needed)
+		pds_vfio_deferred_reset(pds_vfio, VFIO_DEVICE_STATE_ERROR);
+}
+
 static void
 pds_vfio_aux_notify_handler(struct pds_auxiliary_dev *padev,
 			    union pds_core_notifyq_comp *event)
@@ -29,6 +69,23 @@ pds_vfio_aux_notify_handler(struct pds_auxiliary_dev *padev,
 	u16 ecode = le16_to_cpu(event->ecode);
 
 	dev_dbg(dev, "%s: event code %d\n", __func__, ecode);
+
+	/* We don't need to do anything for RESET state==0 as there is no notify
+	 * or feedback mechanism available, and it is possible that we won't
+	 * even see a state==0 event.
+	 *
+	 * Any requests from VFIO while state==0 will fail, which will return
+	 * error and may cause migration to fail.
+	 */
+	if (ecode == PDS_EVENT_RESET) {
+		dev_info(dev, "%s: PDS_EVENT_RESET event received, state==%d\n",
+			 __func__, event->reset.state);
+		if (event->reset.state == 1) {
+			struct pds_vfio_aux *vfio_aux = auxiliary_get_drvdata(&padev->aux_dev);
+
+			schedule_work(&vfio_aux->work);
+		}
+	}
 }
 
 static int
@@ -88,6 +145,8 @@ pds_vfio_aux_probe(struct auxiliary_device *aux_dev,
 		goto err_out;
 	}
 
+	INIT_WORK(&vfio_aux->work, pds_vfio_recovery_work);
+
 	return 0;
 
 err_out:
@@ -103,6 +162,8 @@ pds_vfio_aux_remove(struct auxiliary_device *aux_dev)
 	struct pds_vfio_aux *vfio_aux = auxiliary_get_drvdata(aux_dev);
 	struct pds_vfio_pci_device *pds_vfio = vfio_aux->pds_vfio;
 
+	cancel_work_sync(&vfio_aux->work);
+
 	if (pds_vfio) {
 		pds_vfio_unregister_client_cmd(pds_vfio);
 		vfio_aux->pds_vfio->vfio_aux = NULL;
diff --git a/drivers/vfio/pci/pds/aux_drv.h b/drivers/vfio/pci/pds/aux_drv.h
index be5948575a0c..ffad35a5b1e4 100644
--- a/drivers/vfio/pci/pds/aux_drv.h
+++ b/drivers/vfio/pci/pds/aux_drv.h
@@ -17,6 +17,7 @@ struct pds_vfio_aux {
 	struct pds_auxiliary_dev *padev;
 	struct pds_auxiliary_drv padrv;
 	struct pds_vfio_pci_device *pds_vfio;
+	struct work_struct work;
 };
 
 struct auxiliary_driver *
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 8d32b2a543c9..5fbf434d9696 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -26,10 +26,17 @@ pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+			dev_dbg(&pds_vfio->pdev->dev, "Transitioning from VFIO_DEVICE_STATE_ERROR to %s\n",
+				pds_vfio_lm_state(pds_vfio->deferred_reset_state));
+			pds_vfio->state = pds_vfio->deferred_reset_state;
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
+		} else if (pds_vfio->deferred_reset_state == VFIO_DEVICE_STATE_ERROR) {
+			dev_dbg(&pds_vfio->pdev->dev, "Transitioning from %s to VFIO_DEVICE_STATE_ERROR based on deferred_reset request\n",
+				pds_vfio_lm_state(pds_vfio->state));
+			pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
 		}
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 		spin_unlock(&pds_vfio->reset_lock);
 		goto again;
 	}
@@ -42,6 +49,7 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	spin_lock(&pds_vfio->reset_lock);
 	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		spin_unlock(&pds_vfio->reset_lock);
 		return;
@@ -50,6 +58,18 @@ pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 	pds_vfio_state_mutex_unlock(pds_vfio);
 }
 
+void
+pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			enum vfio_device_mig_state reset_state)
+{
+	dev_info(&pds_vfio->pdev->dev, "Requesting deferred_reset to state %s\n",
+		 pds_vfio_lm_state(reset_state));
+	spin_lock(&pds_vfio->reset_lock);
+	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = reset_state;
+	spin_unlock(&pds_vfio->reset_lock);
+}
+
 static struct file *
 pds_vfio_set_device_state(struct vfio_device *vdev,
 			  enum vfio_device_mig_state new_state)
@@ -63,7 +83,13 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		return ERR_PTR(-ENODEV);
 
 	mutex_lock(&pds_vfio->state_mutex);
-	while (new_state != pds_vfio->state) {
+	/* only way to transition out of VFIO_DEVICE_STATE_ERROR is via
+	 * VFIO_DEVICE_RESET, so prevent the state machine from running since
+	 * vfio_mig_get_next_state() will throw a WARN_ON() when transitioning
+	 * from VFIO_DEVICE_STATE_ERROR to any other state
+	 */
+	while (pds_vfio->state != VFIO_DEVICE_STATE_ERROR &&
+	       new_state != pds_vfio->state) {
 		enum vfio_device_mig_state next_state;
 
 		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
@@ -85,6 +111,9 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	pds_vfio_state_mutex_unlock(pds_vfio);
+	/* still waiting on a deferred_reset */
+	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
+		res = ERR_PTR(-EIO);
 
 	return res;
 }
@@ -169,6 +198,7 @@ pds_vfio_open_device(struct vfio_device *vdev)
 	dev_dbg(&pds_vfio->pdev->dev, "%s: %s => VFIO_DEVICE_STATE_RUNNING\n",
 		__func__, pds_vfio_lm_state(pds_vfio->state));
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 6abb52814ef0..c93e9d033b7a 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -23,6 +23,7 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
 	u8 deferred_reset;
+	enum vfio_device_mig_state deferred_reset_state;
 
 	int vf_id;
 	int pci_id;
@@ -34,5 +35,8 @@ struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void
 pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_deferred_reset(struct pds_vfio_pci_device *pds_vfio,
+			enum vfio_device_mig_state reset_state);
 
 #endif /* _VFIO_DEV_H_ */
-- 
2.17.1

