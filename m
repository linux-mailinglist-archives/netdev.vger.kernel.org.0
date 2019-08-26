Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0039C81C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 05:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbfHZD4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 23:56:01 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43203 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfHZD4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 23:56:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id k3so9706893pgb.10
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 20:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ui4eYUBaHGuNBmrsPX7pN2RNXBqJnHKC0Jicxt/2Qc=;
        b=RkypD5ec4XuQUNFXq2euWlw4p6567ls/zMZzwtpohAhUFlUGimvsgDLLBO3LzEMcY0
         oZLeT1PDMmPq94Rb83rIk/7VfOWC5cZbI4Wz7rU04eTiNjR3KN5yM0lSZ/7ki33PcF81
         6Wxlj5tZkfI3aND4c6eQg+RjJ5bGl32jI+tp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ui4eYUBaHGuNBmrsPX7pN2RNXBqJnHKC0Jicxt/2Qc=;
        b=HTq39BQ5b7K5sDI3blG7I0xkMKvk8Fuijf92tlqwomlf4pYsMfFH+/Q53Rdl4aAG0E
         FHsEOcMXGzwITv1K8Fxhw9yCOVb3F10PY9/f8ZEFQzCOxPkBzetuBT/8qsKb6701hBRT
         ipwV6NWgaVUZtuarNqJu48OejilA/s72wML0s2YGG6e07m/XRZYlx6Ft0hlBH8dqfo6v
         rmxId6ZiUqk4uj7l3UnsPctUWTn6tR2V5IfyXR0Eh4jSpYVsicXS9E21To2e6rpBK9dS
         gi/nx2Tq+mXEM7yhrdA2fGhuReUwJg2RnAjKuhABm/3xvYN0R08MGtZBc8BAqjdD0GQm
         7Xwg==
X-Gm-Message-State: APjAAAUIPBTzdmqGunCJWPichT7JlMYH9hcpdWwhvPO5FqFfBXAl0/cC
        vkVy9rBIishmpP/ejAltAKKk4A==
X-Google-Smtp-Source: APXvYqwaa9I2SuwSezdEH/YJ1cZibCYzreBkoNIK0lhUf8cEdQulTpM2xfpADfoyPhMmQu6yWsmX2g==
X-Received: by 2002:a63:184b:: with SMTP id 11mr15252075pgy.112.1566791759582;
        Sun, 25 Aug 2019 20:55:59 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d6sm8532975pgf.55.2019.08.25.20.55.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 20:55:59 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: [PATCH net-next 08/14] bnxt_en: Add BNXT_STATE_IN_FW_RESET state and pf->registered_vfs.
Date:   Sun, 25 Aug 2019 23:54:59 -0400
Message-Id: <1566791705-20473-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new flag will be set in subsequent patches when firmware is
going through reset.  Delay close and SRIOV disable operations until
the flag is cleared.

Store the registered_vfs value from the firmware.  This value will
be polled in subsequent patches to determine if SR-IOV is in quiescent
state.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 16 ++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h       |  2 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c |  4 ++++
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f522f3b..be0eb1c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6326,6 +6326,8 @@ static int bnxt_hwrm_func_qcfg(struct bnxt *bp)
 		struct bnxt_vf_info *vf = &bp->vf;
 
 		vf->vlan = le16_to_cpu(resp->vlan) & VLAN_VID_MASK;
+	} else {
+		bp->pf.registered_vfs = le16_to_cpu(resp->registered_vfs);
 	}
 #endif
 	flags = le16_to_cpu(resp->flags);
@@ -8710,6 +8712,10 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 	if (flags & FUNC_DRV_IF_CHANGE_RESP_FLAGS_HOT_FW_RESET_DONE)
 		fw_reset = true;
 
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state) && !fw_reset) {
+		netdev_err(bp->dev, "RESET_DONE not set during FW reset.\n");
+		return -ENODEV;
+	}
 	if (resc_reinit || fw_reset) {
 		if (fw_reset) {
 			rc = bnxt_fw_init_one(bp);
@@ -9218,6 +9224,9 @@ static void __bnxt_close_nic(struct bnxt *bp, bool irq_re_init,
 	bnxt_debug_dev_exit(bp);
 	bnxt_disable_napi(bp);
 	del_timer_sync(&bp->timer);
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		pci_disable_device(bp->pdev);
+
 	bnxt_free_skbs(bp);
 
 	/* Save ring stats before shutdown */
@@ -9234,6 +9243,13 @@ int bnxt_close_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 {
 	int rc = 0;
 
+	while (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		netdev_info(bp->dev, "FW reset in progress, delaying close");
+		rtnl_unlock();
+		msleep(250);
+		rtnl_lock();
+	}
+
 #ifdef CONFIG_BNXT_SRIOV
 	if (bp->sriov_cfg) {
 		rc = wait_event_interruptible_timeout(bp->sriov_cfg_wait,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 96f2e12..c316de5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1066,6 +1066,7 @@ struct bnxt_pf_info {
 	u8	mac_addr[ETH_ALEN];
 	u32	first_vf_id;
 	u16	active_vfs;
+	u16	registered_vfs;
 	u16	max_vfs;
 	u32	max_encap_records;
 	u32	max_decap_records;
@@ -1605,6 +1606,7 @@ struct bnxt {
 #define BNXT_STATE_IN_SP_TASK	1
 #define BNXT_STATE_READ_STATS	2
 #define BNXT_STATE_FW_RESET_DET 3
+#define BNXT_STATE_IN_FW_RESET	4
 #define BNXT_STATE_PROBE_ERR	5
 
 	struct bnxt_irq	*irq_tbl;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
index 93524d7..e435374 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
@@ -802,6 +802,10 @@ void bnxt_sriov_disable(struct bnxt *bp)
 {
 	u16 num_vfs = pci_num_vf(bp->pdev);
 
+	while (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		netdev_info(bp->dev, "FW reset in progress, delaying SR-IOV config");
+		msleep(250);
+	}
 	if (!num_vfs)
 		return;
 
-- 
2.5.1

