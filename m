Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F51267AF9
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgILOmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 10:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgILOlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 10:41:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83984C061796;
        Sat, 12 Sep 2020 07:41:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z23so17206594ejr.13;
        Sat, 12 Sep 2020 07:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z2qnwmIpuwRM8KLgFGyavJGqRBMDHIKVtgsMi7EZwoU=;
        b=GsF3wQJPllWecDuv5u8uHhr+bq0UxBUfd+LtE07v8SFudC+9gCSowcqZ0I+efUmOKL
         Q5DUUkvfcQ5xF3d2OWKcWrCg6jRfwzG3XkIlD89xIk+gW/cIRHU84t2Qx3XfYxx7zHvs
         cyBxIraScDiVhDvXZVyrITkDz0r/UOz5Gre/5KpVN69XnTfuahsIiUcLaRV+wxF5MrAm
         NhHarGL6Jp89XbspUadABLXherfgNIx2/VzQmQwTjZYruaAOGtWFLSBxgYphR2dwzMvE
         Qo+2qyDulBaY06pBLuiLcPuArJslNVNLCix15vMmxDTWSV8t/moqg3FHZv0qubvLB5CJ
         p7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z2qnwmIpuwRM8KLgFGyavJGqRBMDHIKVtgsMi7EZwoU=;
        b=FExAZSWS04a68IqcXoelyhPkO8RKq3L7vfLuSBTbTFTp1WmGWepUo0cW13tiRyn56S
         rf2m1A+DSgrZs7coneklXmWVfSpXoQVdpA72GuvT7ZE0yHd7yC/OJriALn+ZkB+I6ZV7
         m0oIuXC0N2mbLMYswtq7c/gkfjvieqo9HbzNyySMOa4kASRIN+y+TP1qQ2q7XdeH6pl0
         H6ypYXg2IEmnWKiE8FFSiGiOXY0vSuW6bG9Gs+gp5iFPesyjUA8HtJIXTUwBiCxAQLrG
         SiCiWAGI5f8Y3MP6MDHhwur/c1a0Gu4BIq/8WbL3pS6UPXH0FntsXGAnwBg7eO4BfLL1
         Zg2Q==
X-Gm-Message-State: AOAM530x6ccYX29ec2574cEXeVKOi9lrsv6tTNwkyov5tcGbYQy+m2f/
        crjXA/LDprakkY0MHAARyoDiPlXK9Hk=
X-Google-Smtp-Source: ABdhPJxBHiTBz53RDRSLuHso2V6Ilfb3aNOHmwqhnCm7DzrhgYPUCZZ2VO4dxlclfd8b8gUP0naclQ==
X-Received: by 2002:a17:906:e08f:: with SMTP id gh15mr6173435ejb.443.1599921687938;
        Sat, 12 Sep 2020 07:41:27 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id y25sm4842938edv.15.2020.09.12.07.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 07:41:26 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
Subject: [PATCH v2 06/14] habanalabs/gaudi: add NIC PHY code
Date:   Sat, 12 Sep 2020 17:40:58 +0300
Message-Id: <20200912144106.11799-7-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200912144106.11799-1-oded.gabbay@gmail.com>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Omer Shpigelman <oshpigelman@habana.ai>

Configure the NIC PHY (physical layer). The PHY is configured with the
correct polarity and Tx taps depending on the card type.

After the initial configuration, the PHY flow contains the following:
- Auto-negotiation (if enabled)
- PHY F/W tuning
- Physical Coding Sublayer (PCS) link check

After acquiring the initial PCS link, it is checked periodically. Once we
detect that there is no link, we fall to PHY F/W tuning or even
Auto-negotiation to re-acquire the link.

Currently we use Auto-negotiation only because it is a prerequisite for
link training (physical layer quality improvement) and not for setting the
transmission parameters. As a result, the Auto-negotiation is currently
supported only between Gaudi cards.

Signed-off-by: Omer Shpigelman <oshpigelman@habana.ai>
Reviewed-by: Oded Gabbay <oded.gabbay@gmail.com>
Signed-off-by: Oded Gabbay <oded.gabbay@gmail.com>
---
Changes in v2:
  - Fix all instances of reverse Christmas tree

 drivers/misc/habanalabs/gaudi/Makefile    |    2 +-
 drivers/misc/habanalabs/gaudi/gaudi_nic.c |  456 +++++++-
 drivers/misc/habanalabs/gaudi/gaudi_nic.h |   17 +
 drivers/misc/habanalabs/gaudi/gaudi_phy.c | 1276 +++++++++++++++++++++
 4 files changed, 1748 insertions(+), 3 deletions(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c

diff --git a/drivers/misc/habanalabs/gaudi/Makefile b/drivers/misc/habanalabs/gaudi/Makefile
index 24e14cff563d..c5143cf6f025 100644
--- a/drivers/misc/habanalabs/gaudi/Makefile
+++ b/drivers/misc/habanalabs/gaudi/Makefile
@@ -2,4 +2,4 @@
 HL_GAUDI_FILES := gaudi/gaudi.o gaudi/gaudi_hwmgr.o gaudi/gaudi_security.o \
 	gaudi/gaudi_coresight.o
 
-HL_GAUDI_FILES += gaudi/gaudi_nic.o
+HL_GAUDI_FILES += gaudi/gaudi_nic.o gaudi/gaudi_phy.o
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.c b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
index 9fc6e9fe7ac4..1e3f58297e5e 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.c
@@ -704,13 +704,26 @@ static void config_port_mac(struct gaudi_nic_device *gaudi_nic)
 	}
 }
 
+static void phy_start_stop(struct gaudi_nic_device *gaudi_nic, bool is_start)
+{
+	int i;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->power_up_mask & BIT(i)))
+			continue;
+
+		gaudi_nic_phy_start_stop(gaudi_nic, i, is_start);
+	}
+}
+
 static int hw_config(struct gaudi_nic_device *gaudi_nic)
 {
 	u32 port = gaudi_nic->port, data_rate, speed = gaudi_nic->speed;
 	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
 	struct hl_device *hdev = gaudi_nic->hdev;
 	u64 mac_addr = 0, tmr_addr;
-	int i;
+	bool do_auto_neg;
+	int i, rc;
 
 	for (i = 0 ; i < ETH_ALEN ; i++) {
 		mac_addr <<= 8;
@@ -746,6 +759,26 @@ static int hw_config(struct gaudi_nic_device *gaudi_nic)
 
 	gaudi_nic->data_rate = data_rate;
 
+	if (gaudi->nic_phy_config_fw && !gaudi_nic->mac_loopback) {
+		for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+			if (!(gaudi_nic->power_up_mask & BIT(i)))
+				continue;
+
+			do_auto_neg = gaudi_nic->auto_neg_enable &&
+					(gaudi_nic->auto_neg_mask & BIT(i));
+
+			rc = gaudi_nic_phy_power_up(gaudi_nic, i, do_auto_neg);
+			if (rc) {
+				dev_err(hdev->dev,
+					"PHY power up failed for port %d\n",
+					port);
+				return rc;
+			}
+		}
+
+		phy_start_stop(gaudi_nic, true);
+	}
+
 	/* if no need in macro configuration, do only port configuration */
 	if (gaudi_nic->do_macro_cfg) {
 		config_port_mac(gaudi_nic);
@@ -1216,6 +1249,366 @@ static void port_reset_state(struct gaudi_nic_device *gaudi_nic)
 	gaudi_nic->uncorrectable_errors_cnt = 0;
 }
 
+static void phy_reconfig(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int i, rc;
+
+	if (!gaudi->nic_phy_config_fw)
+		return;
+
+	dev_dbg(hdev->dev, "reconfiguring PHY, port %d\n", port);
+
+	if (gaudi_nic->auto_neg_enable) {
+		for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+			if (!(gaudi_nic->auto_neg_mask & BIT(i)))
+				continue;
+
+			rc = gaudi_nic_phy_fw_config_auto_neg(gaudi_nic, i);
+			if (rc)
+				dev_dbg(hdev->dev,
+					"F/W reconfig autoneg failed, port: %d, lane: %d\n",
+					port, i);
+		}
+	} else {
+		for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+			if (!(gaudi_nic->power_up_mask & BIT(i)))
+				continue;
+
+			rc = gaudi_nic_phy_power_up(gaudi_nic, i, false);
+			if (rc) {
+				dev_err(hdev->dev,
+					"PHY reconfig power up failed for port %d\n",
+					port);
+				break;
+			}
+		}
+	}
+
+	port_reset_state(gaudi_nic);
+}
+
+static enum link_status update_pcs_link_failure(
+					struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct kfifo *pcs_fifo = &gaudi_nic->pcs_fail_fifo;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	ktime_t now, before;
+	int count;
+
+	if (!gaudi_nic->auto_neg_enable)
+		return PCS_DOWN;
+
+	now = ktime_get();
+
+	count = kfifo_in(pcs_fifo, &now, sizeof(now));
+	if (count != sizeof(now)) {
+		dev_err(hdev->dev,
+			"Failed to push to PCS fifo, size: %d, count: %d, port: %d\n",
+			gaudi_nic->pcs_fail_cnt, count, port);
+		return PCS_DOWN;
+	}
+
+	gaudi_nic->pcs_fail_cnt++;
+
+	if (gaudi_nic->pcs_fail_cnt < gaudi->nic_pcs_fail_threshold)
+		return PCS_DOWN;
+
+	/*
+	 * Here we reached the threshold count of failures to reconfigure the
+	 * link. Now need to check if all of the failure are in the needed time
+	 * frame. It is sufficient to check the first item in the queue as it is
+	 * the earliest failure and if it is in the needed time frame, all the
+	 * rest if failures are in it too.
+	 */
+	count = kfifo_out_peek(pcs_fifo, &before, sizeof(before));
+	if (count != sizeof(before))
+		dev_err(hdev->dev,
+			"Failed to peek in PCS fifo, size: %d, count: %d, port: %d\n",
+			gaudi_nic->pcs_fail_cnt, count, port);
+
+	if (ktime_ms_delta(now, before) <=
+			(gaudi->nic_pcs_fail_time_frame * MSEC_PER_SEC)) {
+		dev_dbg(hdev->dev,
+			"PHY reconfig due to PCS link failure cnt, port: %d\n",
+			port);
+		return FAIL_RECONFIG;
+	}
+
+	/*
+	 * The earliest failure is not in the needed time frame, hence
+	 * we can remove it.
+	 */
+	count = kfifo_out(pcs_fifo, &before, sizeof(before));
+	if (count != sizeof(before))
+		dev_err(hdev->dev,
+			"Failed to pop from PCS fifo, size: %d, count: %d, port: %d\n",
+			gaudi_nic->pcs_fail_cnt, count, port);
+
+	gaudi_nic->pcs_fail_cnt--;
+
+	return PCS_DOWN;
+}
+
+static void reset_tx(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int i;
+
+	/* This temporary WA is only for HLS external ports */
+	if ((hdev->card_type != cpucp_card_type_pmc) ||
+			(BIT(gaudi_nic->port) & ~hdev->nic_ports_ext_mask))
+		return;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++)
+		if (gaudi_nic->fw_tuning_mask & BIT(i))
+			gaudi_nic_phy_reset_tx(gaudi_nic, i);
+}
+
+static enum link_status _check_pcs_link(struct gaudi_nic_device *gaudi_nic)
+{
+	u32 port = gaudi_nic->port, pcs_val, mac_val, start_lane;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int i, rc;
+
+	start_lane = __ffs(gaudi_nic->fw_tuning_mask);
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->fw_tuning_mask & BIT(i)))
+			continue;
+
+		rc = gaudi_nic_phy_check_link_status(gaudi_nic, i);
+		if (rc)
+			return PHY_DOWN;
+	}
+
+	/* need to check the first lane only */
+	mac_val = gaudi_nic_mac_read(gaudi_nic, start_lane, "mac", 0x40);
+
+	if (mac_val & 1)
+		gaudi_nic->pcs_local_fault_cnt++;
+	else if (gaudi_nic->pcs_local_fault_cnt)
+		gaudi_nic->pcs_local_fault_cnt--;
+
+	if (mac_val & 2)
+		gaudi_nic->pcs_remote_fault_cnt++;
+	else if (gaudi_nic->pcs_remote_fault_cnt)
+		gaudi_nic->pcs_remote_fault_cnt--;
+
+	if (gaudi_nic->pcs_remote_fault_cnt == PCS_FAULT_THRESHOLD) {
+		dev_dbg(hdev->dev,
+			"PHY reconfig due to PCS remote fault cnt, port: %d\n",
+			port);
+		return FAULT_RECONFIG;
+	}
+
+	/* need to check the first lane only */
+	pcs_val = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs", 0x20);
+
+	if ((pcs_val >> 12) & 1)
+		return LINK_UP;
+
+	return PCS_DOWN;
+}
+
+static void check_pcs_link(struct gaudi_nic_device *gaudi_nic)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	enum link_status link_status;
+	u32 port = gaudi_nic->port;
+
+	if (!gaudi->nic_check_link)
+		return;
+
+	link_status = _check_pcs_link(gaudi_nic);
+	if ((link_status == PCS_DOWN) || (link_status == PHY_DOWN)) {
+		/* Try again to overcome a momentary glitch */
+		msleep(PCS_LINK_RETRY_MSEC);
+
+		link_status = _check_pcs_link(gaudi_nic);
+
+		if (link_status == LINK_UP)
+			dev_info(hdev->dev, "PCS link restored, port %d\n",
+					port);
+	}
+
+	if (link_status == LINK_UP)
+		return;
+
+	set_port_status(gaudi_nic, false);
+	gaudi_nic->pcs_link = false;
+	gaudi_nic->last_pcs_link_drop_ts = ktime_get();
+
+	dev_info(hdev->dev, "%s lost signal, port %d\n",
+			(link_status == PHY_DOWN) ? "PHY" : "PCS", port);
+
+	/* TODO: fix the bug in the retimer to remove this Tx reset WA */
+	/*
+	 * No need to update about the PCS failure if we already need to
+	 * reconfigure the PHY.
+	 */
+	if (link_status == FAULT_RECONFIG)
+		reset_tx(gaudi_nic);
+	else
+		link_status = update_pcs_link_failure(gaudi_nic);
+
+	if ((link_status == FAULT_RECONFIG) ||
+			(link_status == FAIL_RECONFIG))
+		phy_reconfig(gaudi_nic);
+}
+
+static void acquire_pcs_link(struct gaudi_nic_device *gaudi_nic)
+{
+	u32 port = gaudi_nic->port, pcs_val, start_lane;
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	start_lane = __ffs(gaudi_nic->fw_tuning_mask);
+
+	/* need to check the first lane only */
+	pcs_val = gaudi_nic_mac_read(gaudi_nic, start_lane, "xpcs", 0x20);
+	gaudi_nic->pcs_link = (pcs_val >> 12) & 1;
+	gaudi_nic->retry_cnt++;
+
+	if (gaudi_nic->pcs_link) {
+		dev_info(hdev->dev, "PCS link up, port %d\n", port);
+		set_port_status(gaudi_nic, true);
+		gaudi_nic->retry_cnt = 0;
+	} else if (gaudi_nic->retry_cnt == PCS_LINK_CNT) {
+		if (ktime_after(gaudi_nic->last_fw_tuning_ts,
+				gaudi_nic->last_pcs_link_drop_ts))
+			dev_dbg(hdev->dev,
+				"PHY_reconfig due to PCS link down after F/W tuning, port %d\n",
+				port);
+		else
+			dev_dbg(hdev->dev,
+				"PHY reconfig due to PCS link cnt, port %d\n",
+				port);
+		phy_reconfig(gaudi_nic);
+	}
+}
+
+static void do_fw_tuning(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int i, rc = 0;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->fw_tuning_mask & BIT(i)))
+			continue;
+
+		rc = gaudi_nic_phy_fw_tuning(gaudi_nic, i, true);
+		if (rc) {
+			if (rc == -EAGAIN) {
+				if (gaudi_nic->retry_cnt++ == FW_TUNING_CNT) {
+					dev_dbg(hdev->dev,
+						"PHY reconfig due to F/W tuning cnt, port %d, lane %d\n",
+						port, i);
+					phy_reconfig(gaudi_nic);
+				}
+			} else {
+				dev_dbg(hdev->dev,
+					"PHY F/W tuning failed for port %d, lane %d, rc %d\n",
+					port, i, rc);
+				phy_reconfig(gaudi_nic);
+			}
+			break;
+		}
+	}
+
+	if (!rc) {
+		gaudi_nic->phy_fw_tuned = true;
+		gaudi_nic->retry_cnt = 0;
+		gaudi_nic->last_fw_tuning_ts = ktime_get();
+	}
+}
+
+static void do_fw_tuning_auto_neg(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	int i, rc;
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->auto_neg_mask & BIT(i)))
+			continue;
+
+		rc = gaudi_nic_phy_fw_tuning(gaudi_nic, i, false);
+		if (rc) {
+			if (rc != -EAGAIN)
+				dev_dbg(hdev->dev,
+					"PHY auto neg F/W tuning failed, port %d, lane %d, rc %d\n",
+					port, i, rc);
+			return;
+		}
+	}
+
+	for (i = NIC_MAC_LANES_START ; i < NIC_MAC_NUM_OF_LANES ; i++) {
+		if (!(gaudi_nic->fw_tuning_mask & BIT(i)))
+			continue;
+
+		rc = gaudi_nic_phy_config_pam4_link_training(gaudi_nic, i);
+		if (rc) {
+			if (rc == -EAGAIN) {
+				if (gaudi_nic->retry_cnt++ ==
+						FW_LINK_TRAINING_CNT) {
+					dev_dbg(hdev->dev,
+						"PHY reconfig due to PAM4 cnt, port: %d, lane: %d\n",
+						port, i);
+					phy_reconfig(gaudi_nic);
+				}
+			} else {
+				dev_dbg(hdev->dev,
+					"PHY auto neg F/W speed config failed, port %d, lane %d, rc %d\n",
+					port, i, rc);
+				phy_reconfig(gaudi_nic);
+			}
+
+			return;
+		}
+	}
+
+	dev_dbg(hdev->dev, "auto neg done, port: %d\n", port);
+	gaudi_nic->auto_neg_resolved = true;
+	gaudi_nic->retry_cnt = 0;
+	do_fw_tuning(gaudi_nic);
+}
+
+static void check_link_status(struct work_struct *work)
+{
+	struct gaudi_nic_device *gaudi_nic = container_of(work,
+							struct gaudi_nic_device,
+							link_status_work.work);
+	u32 timeout_ms;
+
+	if (gaudi_nic->phy_fw_tuned) {
+		if (gaudi_nic->pcs_link)
+			check_pcs_link(gaudi_nic);
+		else
+			acquire_pcs_link(gaudi_nic);
+	} else {
+		if (gaudi_nic->auto_neg_enable && !gaudi_nic->auto_neg_resolved)
+			do_fw_tuning_auto_neg(gaudi_nic);
+		else
+			do_fw_tuning(gaudi_nic);
+	}
+
+	if (gaudi_nic->pcs_link)
+		timeout_ms = 1000;
+	else if (gaudi_nic->phy_fw_tuned)
+		timeout_ms = 500;
+	else
+		timeout_ms = 1;
+
+	schedule_delayed_work(&gaudi_nic->link_status_work,
+				msecs_to_jiffies(timeout_ms));
+}
+
 static int _gaudi_nic_sw_init(struct gaudi_nic_device *gaudi_nic)
 {
 	struct hl_device *hdev = gaudi_nic->hdev;
@@ -1601,7 +1994,13 @@ static int port_open(struct gaudi_nic_device *gaudi_nic)
 		napi_enable(&gaudi_nic->napi);
 	}
 
-	set_port_status(gaudi_nic, true);
+	if (gaudi->nic_phy_config_fw && !gaudi_nic->mac_loopback) {
+		INIT_DELAYED_WORK(&gaudi_nic->link_status_work,
+					check_link_status);
+		schedule_delayed_work(&gaudi_nic->link_status_work, 0);
+	} else {
+		set_port_status(gaudi_nic, true);
+	}
 
 	gaudi_nic->port_open = true;
 
@@ -1653,10 +2052,17 @@ static void port_close(struct gaudi_nic_device *gaudi_nic)
 	gaudi_nic->port_open = false;
 	gaudi_nic->active = false;
 
+	if (gaudi->nic_phy_config_fw && !gaudi_nic->mac_loopback)
+		cancel_delayed_work_sync(&gaudi_nic->link_status_work);
+
 	/* Print if not in hard reset flow e.g. from ifconfig */
 	if (gaudi_nic->pcs_link && !hdev->hard_reset_pending)
 		dev_info(hdev->dev, "port %d was closed\n", port);
 
+	/* stop F/W so the peer port will also lose link */
+	if (gaudi->nic_phy_config_fw && !gaudi_nic->mac_loopback)
+		phy_start_stop(gaudi_nic, false);
+
 	port_reset_state(gaudi_nic);
 
 	kfifo_free(&gaudi_nic->pcs_fail_fifo);
@@ -1911,6 +2317,19 @@ static int port_register(struct hl_device *hdev, int port)
 	ether_addr_copy(ndev->dev_addr,
 		hdev->asic_prop.cpucp_nic_info.mac_addrs[port].mac_addr);
 
+	/*
+	 * Reset the NIC macro PHY before the PHY configuration by each port.
+	 * This function resets all the 4 lanes in the PHY macro, therefore only
+	 * one of the two ports should call it.
+	 */
+	if (gaudi->nic_phy_config_fw && gaudi_nic->do_macro_cfg) {
+		rc = gaudi_nic_phy_reset_macro(gaudi_nic);
+		if (rc)
+			dev_err(hdev->dev,
+				"PHY power up 1 failed for port %d\n",
+				port);
+	}
+
 	if (register_netdev(ndev)) {
 		dev_err(hdev->dev,
 			"Could not register netdevice, port: %d\n", port);
@@ -2080,6 +2499,24 @@ int gaudi_nic_ports_init(struct hl_device *hdev)
 				cpu_to_le32((card_location >> 22) & 0x7);
 	}
 
+	if (gaudi->nic_phy_load_fw) {
+		rc = gaudi_nic_phy_has_fw(hdev);
+		if (rc) {
+			dev_err(hdev->dev, "NIC F/W file was not found\n");
+			return rc;
+		}
+
+		rc = gaudi_nic_phy_fw_load_all(hdev);
+		if (rc) {
+			dev_err(hdev->dev, "NIC F/W load for all failed\n");
+			return rc;
+		}
+	}
+
+	if (gaudi->nic_phy_config_fw)
+		dev_dbg(hdev->dev, "NIC F/W CRC: 0x%x\n",
+				gaudi_nic_phy_get_crc(hdev));
+
 	for (i = 0 ; i < NIC_NUMBER_OF_MACROS ; i++) {
 		gaudi->nic_macros[i].idx = i;
 		gaudi->nic_macros[i].num_of_lanes = NIC_LANES_2;
@@ -2301,6 +2738,21 @@ void gaudi_nic_ports_reopen(struct hl_device *hdev)
 		gaudi_nic = &gaudi->nic_devices[i];
 		port = gaudi_nic->port;
 
+		/*
+		 * Reset the NIC macro PHY before the PHY configuration by each
+		 * port. This function resets all the 4 lanes in the PHY macro,
+		 * therefore only one of the two ports should call it.
+		 * This must be called before we check if the port is enabled,
+		 * as the PHY reset should be called anyway.
+		 */
+		if (gaudi->nic_phy_config_fw && gaudi_nic->do_macro_cfg) {
+			rc = gaudi_nic_phy_reset_macro(gaudi_nic);
+			if (rc)
+				dev_err(hdev->dev,
+					"PHY power up 1 failed for port %d\n",
+					port);
+		}
+
 		/*
 		 * It could be that the port was shutdown by 'ifconfig down',
 		 * and there is no need in reopening it.
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_nic.h b/drivers/misc/habanalabs/gaudi/gaudi_nic.h
index 7259b01b78fb..2aa6ef712073 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi_nic.h
+++ b/drivers/misc/habanalabs/gaudi/gaudi_nic.h
@@ -332,5 +332,22 @@ int gaudi_nic_port_reset(struct gaudi_nic_device *gaudi_nic);
 bool disabled_or_in_reset(struct gaudi_nic_device *gaudi_nic);
 u64 gaudi_nic_read_mac_stat_counter(struct hl_device *hdev, u32 port, int idx,
 					bool is_rx);
+int gaudi_nic_phy_reset_macro(struct gaudi_nic_device *gaudi_nic);
+int gaudi_nic_phy_power_up(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool do_auto_neg);
+int gaudi_nic_phy_has_fw(struct hl_device *hdev);
+int gaudi_nic_phy_fw_tuning(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool check_status);
+int gaudi_nic_phy_fw_load_all(struct hl_device *hdev);
+int gaudi_nic_phy_check_link_status(struct gaudi_nic_device *gaudi_nic,
+					int lane);
+int gaudi_nic_phy_config_pam4_link_training(struct gaudi_nic_device *gaudi_nic,
+						int lane);
+int gaudi_nic_phy_fw_config_auto_neg(struct gaudi_nic_device *gaudi_nic,
+					int lane);
+u16 gaudi_nic_phy_get_crc(struct hl_device *hdev);
+void gaudi_nic_phy_reset_tx(struct gaudi_nic_device *gaudi_nic, int lane);
+void gaudi_nic_phy_start_stop(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool is_start);
 
 #endif /* GAUDI_NIC_DRV_H_ */
diff --git a/drivers/misc/habanalabs/gaudi/gaudi_phy.c b/drivers/misc/habanalabs/gaudi/gaudi_phy.c
new file mode 100644
index 000000000000..5ab8619502fd
--- /dev/null
+++ b/drivers/misc/habanalabs/gaudi/gaudi_phy.c
@@ -0,0 +1,1276 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright 2019 HabanaLabs, Ltd.
+ * All Rights Reserved.
+ */
+
+#include "gaudi_nic.h"
+#include "../include/gaudi/asic_reg/gaudi_regs.h"
+
+#include <linux/module.h>
+#include <linux/firmware.h>
+#include <asm/unaligned.h>
+
+#define HL_PHY_DEBUG 0
+
+#define GAUDI_PHY_FW_FILE	"habanalabs/gaudi/gaudi_nic_fw.bin"
+
+#define PHY_READ_COUNTS_PER_MS	1000
+#define PHY_FW_SIZE		0x1020
+#define PHY_FW_FINISHED		(1 << 2)
+#define PHY_FW_ERROR		(1 << 3)
+
+#define NIC0_PHY_BASE		(mmNIC0_PHY_BASE - CFG_BASE)
+
+static void phy_write_all(struct hl_device *hdev, u32 addr, u32 data)
+{
+	int lane, port;
+
+	for (port = 0 ; port < 10 ; port += 2)
+		for (lane = 0 ; lane < 4 ; lane++) {
+			NIC_MACRO_WREG32_PORT(NIC0_PHY_BASE + 0xF60 + lane * 4,
+						addr, port);
+
+			/* only the lower 16 bits are in use */
+			NIC_MACRO_WREG32_PORT(NIC0_PHY_BASE - 0x8000 + 0x2000 *
+						lane, data & 0xFFFF, port);
+		}
+}
+
+static void phy_write_port(struct hl_device *hdev, int port, int lane, u32 addr,
+				u32 data)
+{
+	NIC_MACRO_WREG32_PORT(NIC0_PHY_BASE + 0xF60 + lane * 4, addr, port);
+
+	/* only the lower 16 bits are in use */
+	NIC_MACRO_WREG32_PORT(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane,
+				data & 0xFFFF, port);
+}
+
+static void phy_write(struct gaudi_nic_device *gaudi_nic, int lane, u32 addr,
+			u32 data)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	NIC_MACRO_WREG32(NIC0_PHY_BASE + 0xF60 + lane * 4, addr);
+
+	/* only the lower 16 bits are in use */
+	NIC_MACRO_WREG32(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane, data & 0xFFFF);
+}
+
+static u32 phy_read_port(struct hl_device *hdev, int port, int lane, u32 addr)
+{
+	NIC_MACRO_WREG32_PORT(NIC0_PHY_BASE + 0xF60 + lane * 4, addr, port);
+
+	/* only the lower 16 bits are in use */
+	return NIC_MACRO_RREG32_PORT(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane,
+					port) & 0xFFFF;
+}
+
+static u32 phy_read(struct gaudi_nic_device *gaudi_nic, int lane, u32 addr)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	NIC_MACRO_WREG32(NIC0_PHY_BASE + 0xF60 + lane * 4, addr);
+
+	/* only the lower 16 bits are in use */
+	return NIC_MACRO_RREG32(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane) &
+									0xFFFF;
+}
+
+static void phy_write_mask(struct gaudi_nic_device *gaudi_nic, int lane,
+				u32 addr, u32 raw_data, u32 mask)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 data;
+
+	NIC_MACRO_WREG32(NIC0_PHY_BASE + 0xF60 + lane * 4, addr);
+
+	data = (NIC_MACRO_RREG32(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane)) &
+									0xFFFF;
+	data = (data & ~mask) | (((raw_data << (__ffs(mask) % 32))) & 0xFFFF);
+
+	NIC_MACRO_WREG32(NIC0_PHY_BASE - 0x8000 + 0x2000 * lane, data);
+}
+
+static u32 twos_to_int(s32 twos_val, u32 bitWidth)
+{
+	return (u32) ((s32) (twos_val) -
+				((s32) ((twos_val << 1) & (1 << bitWidth))));
+}
+
+static int fw_cmd_port(struct hl_device *hdev, int port, int lane, u32 cmd,
+			u32 detail, u32 expected_res, u32 *res_ptr)
+{
+	u32 res, val;
+	int checks;
+
+	if (detail)
+		phy_write_port(hdev, port, lane, 0x9816, detail);
+
+	phy_write_port(hdev, port, lane, 0x9815, cmd);
+
+	checks = 0;
+	do {
+		usleep_range(1000, 2000);
+		res = phy_read_port(hdev, port, lane, 0x9815);
+		if (checks++ > PHY_READ_COUNTS_PER_MS) {
+			dev_err(hdev->dev, "timeout for PHY cmd 0x%x\n", cmd);
+			return -ETIMEDOUT;
+		}
+	} while (res == cmd);
+
+	val = (res >> 8) & 0xF;
+	if (val != expected_res) {
+		dev_err(hdev->dev, "cmd 0x%x returned error 0x%x\n", cmd, val);
+		return -EFAULT;
+	}
+
+	*res_ptr = res;
+
+	return 0;
+}
+
+static int fw_cmd(struct gaudi_nic_device *gaudi_nic, int lane, u32 cmd,
+			u32 detail, u32 expected_res, u32 *res_ptr)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	u32 res, val;
+	int checks;
+
+	if (detail)
+		phy_write(gaudi_nic, lane, 0x9816, detail);
+
+	phy_write(gaudi_nic, lane, 0x9815, cmd);
+
+	checks = 0;
+	do {
+		usleep_range(1000, 2000);
+		res = phy_read(gaudi_nic, lane, 0x9815);
+		if (checks++ > PHY_READ_COUNTS_PER_MS) {
+			dev_dbg(hdev->dev,
+				"timeout for PHY cmd 0x%x port %d lane %d\n",
+				cmd, port, lane);
+			return -ETIMEDOUT;
+		}
+	} while (res == cmd);
+
+	val = (res >> 8) & 0xF;
+	if (val != expected_res) {
+		dev_dbg(hdev->dev,
+			"cmd 0x%x returned error 0x%x port %d lane %d\n", cmd,
+			val, port, lane);
+		return -EFAULT;
+	}
+
+	*res_ptr = res;
+
+	return 0;
+}
+
+static int fw_hash_port(struct hl_device *hdev, int port, int lane, u32 *hash)
+{
+	u32 res, low_word;
+	int rc;
+
+	rc = fw_cmd_port(hdev, port, lane, 0xF000, 0, 0xF, &res);
+	if (rc) {
+		dev_err(hdev->dev, "F/W hash failed for port %d lane %d\n",
+			port, lane);
+		return rc;
+	}
+
+	low_word = phy_read_port(hdev, port, lane, 0x9816);
+
+	*hash = ((res & 0xFF) << 16) | low_word;
+
+	return 0;
+}
+
+static void set_pll(struct gaudi_nic_device *gaudi_nic, int lane, u32 data_rate,
+			bool pam4)
+{
+	u32 pll_n_val = 0, pll_cap_val = 0;
+	bool div4 = 1; /* for easy debug in the future */
+
+	phy_write_mask(gaudi_nic, lane, 0xFF, 1, 1 << 5);
+
+	if (!pam4)
+		phy_write_mask(gaudi_nic, lane, 0x179, data_rate == NIC_DR_10,
+				1);
+
+	if (data_rate == NIC_DR_50) {
+		if (div4)
+			pll_n_val = 170;
+		else
+			pll_n_val = 42;
+
+		pll_cap_val = 10;
+	} else if (data_rate == NIC_DR_25) {
+		if (div4)
+			pll_n_val = 165;
+		else
+			pll_n_val = 41;
+
+		pll_cap_val = 12;
+	} else if (data_rate == NIC_DR_10) {
+		if (div4)
+			pll_n_val = 132;
+		else
+			pll_n_val = 33;
+
+		pll_cap_val = 34;
+	}
+
+	phy_write_mask(gaudi_nic, lane, 0xFD, pll_n_val, 0xFF80);
+	phy_write_mask(gaudi_nic, lane, 0xFC, pll_cap_val, 0xFC00);
+}
+
+static void set_tx_taps(struct gaudi_nic_device *gaudi_nic, int lane,
+			s32 tx_pre2, s32 tx_pre1, s32 tx_main, s32 tx_post1,
+			s32 tx_post2)
+{
+	phy_write_mask(gaudi_nic, lane, 0xAD, twos_to_int(tx_pre2, 8), 0xFF00);
+	phy_write_mask(gaudi_nic, lane, 0xAB, twos_to_int(tx_pre1, 8), 0xFF00);
+	phy_write_mask(gaudi_nic, lane, 0xA9, twos_to_int(tx_main, 8), 0xFF00);
+	phy_write_mask(gaudi_nic, lane, 0xA7, twos_to_int(tx_post1, 8), 0xFF00);
+	phy_write_mask(gaudi_nic, lane, 0xA5, twos_to_int(tx_post2, 8), 0xFF00);
+}
+
+static void config_nrz_tx(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool half_rate)
+{
+	phy_write(gaudi_nic, lane, 0xAF, 0xF83E);
+	phy_write(gaudi_nic, lane, 0xB0, 0x4802);
+	phy_write_mask(gaudi_nic, lane, 0xB0, half_rate ? 1 : 0, 1);
+	phy_write_mask(gaudi_nic, lane, 0xB0, 0, 0x800);
+	phy_write_mask(gaudi_nic, lane, 0xB0, 1, 0x800);
+	phy_write(gaudi_nic, lane, 0xA0, 0xE300);
+	set_tx_taps(gaudi_nic, lane, 0, -4, 25, 0, 0);
+}
+
+static void config_pam4_tx(struct gaudi_nic_device *gaudi_nic, int lane)
+{
+	u32 lane_idx = (gaudi_nic->port >> 1) * NIC_MAC_NUM_OF_LANES + lane;
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	s32 *taps;
+
+	taps = gaudi->nic_pam4_tx_taps[lane_idx].taps;
+
+	phy_write(gaudi_nic, lane, 0xAF, 0xF83E);
+	phy_write(gaudi_nic, lane, 0xB0, 0);
+	phy_write(gaudi_nic, lane, 0xB0, 0x800);
+	phy_write(gaudi_nic, lane, 0xB0, 0);
+	phy_write(gaudi_nic, lane, 0xA0, 0xEF00);
+	set_tx_taps(gaudi_nic, lane, taps[0], taps[1], taps[2], taps[3],
+			taps[4]);
+}
+
+static void pol(struct gaudi_nic_device *gaudi_nic, int lane, bool pam4,
+		u32 tx_pol, u32 rx_pol)
+{
+	phy_write_mask(gaudi_nic, lane, 0xA0, tx_pol, 0x20);
+	phy_write_mask(gaudi_nic, lane, 0x161, rx_pol, 0x4000); /* nrz */
+	phy_write_mask(gaudi_nic, lane, 0x43, rx_pol, 0x80); /* pam4 */
+}
+
+static void msblsb(struct gaudi_nic_device *gaudi_nic, int lane, u32 tx_msblsb,
+			u32 rx_msblsb)
+{
+	phy_write_mask(gaudi_nic, lane, 0xAF, tx_msblsb, 0x400);
+	phy_write_mask(gaudi_nic, lane, 0x43, rx_msblsb, 0x8000);
+}
+
+static void gc(struct gaudi_nic_device *gaudi_nic, int lane, u32 tx_gc,
+		u32 rx_gc)
+{
+	phy_write_mask(gaudi_nic, lane, 0xAF, tx_gc, 0x200);
+	phy_write_mask(gaudi_nic, lane, 0x42, rx_gc, 1);
+}
+
+static void pc(struct gaudi_nic_device *gaudi_nic, int lane, u32 tx_pc,
+		u32 rx_pc)
+{
+	phy_write_mask(gaudi_nic, lane, 0xAF, tx_pc, 0x100);
+	phy_write_mask(gaudi_nic, lane, 0x42, rx_pc, 2);
+}
+
+static void set_prbs_type(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool pam4, char *pat)
+{
+	u32 prbs_mode_sel_addr;
+	u32 prbs_mode_sel_mask;
+	u32 pat_sel = 0;
+
+	if (pam4) {
+		prbs_mode_sel_addr = 0x43;
+		prbs_mode_sel_mask = 0x60;
+	} else {
+		prbs_mode_sel_addr = 0x161;
+		prbs_mode_sel_mask = 0x3000;
+	}
+
+	if (pam4) {
+		if (!strncmp(pat, "PRBS9", strlen(pat)))
+			pat_sel = 0;
+		else if (!strncmp(pat, "PRBS13", strlen(pat)))
+			pat_sel = 1;
+		else if (!strncmp(pat, "PRBS15", strlen(pat)))
+			pat_sel = 2;
+		else if (!strncmp(pat, "PRBS31", strlen(pat)))
+			pat_sel = 3;
+	} else {
+		if (!strncmp(pat, "PRBS9", strlen(pat)))
+			pat_sel = 0;
+		else if (!strncmp(pat, "PRBS15", strlen(pat)))
+			pat_sel = 1;
+		else if (!strncmp(pat, "PRBS23", strlen(pat)))
+			pat_sel = 2;
+		else if (!strncmp(pat, "PRBS31", strlen(pat)))
+			pat_sel = 3;
+	}
+
+	phy_write_mask(gaudi_nic, lane, 0xA0, pat_sel, 0x300);
+	phy_write_mask(gaudi_nic, lane, prbs_mode_sel_addr, pat_sel,
+			prbs_mode_sel_mask);
+}
+
+static void get_pol_tx_rx(struct gaudi_nic_device *gaudi_nic, u32 lane_idx,
+				u32 *pol_tx, u32 *pol_rx)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 card_location;
+
+	card_location = le32_to_cpu(hdev->asic_prop.cpucp_info.card_location);
+
+	switch (hdev->card_type) {
+	case cpucp_card_type_pci:
+		switch (lane_idx) {
+		case 0 ... 3:
+		case 10 ... 11:
+			*pol_tx = 0;
+			*pol_rx = 0;
+			break;
+		case 5 ... 8:
+		case 12:
+		case 16:
+			*pol_tx = 0;
+			*pol_rx = 1;
+			break;
+		case 15:
+		case 19:
+			*pol_tx = 1;
+			*pol_rx = 0;
+			break;
+		case 4:
+		case 9:
+		case 13 ... 14:
+		case 17 ... 18:
+			*pol_tx = 1;
+			*pol_rx = 1;
+			break;
+		default:
+			dev_err(hdev->dev, "PCI NIC %d wrong lane idx %d\n",
+				gaudi_nic->port, lane_idx);
+			break;
+		}
+		break;
+
+	case cpucp_card_type_pmc:
+		*pol_tx = *pol_rx = 0;
+		switch (card_location) {
+		case 0:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 1:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 2:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 3:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 4:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 5:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 10:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 6:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3:
+			case 5 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		case 7:
+			switch (lane_idx) {
+			case 0 ... 1:
+			case 3 ... 6:
+			case 8 ... 9:
+			case 12 ... 15:
+				fallthrough;
+			case 17:
+			case 19:
+				*pol_rx = 1;
+				break;
+			case 2:
+			case 16:
+			case 18:
+				*pol_tx = 1;
+				break;
+			default:
+				break;
+			}
+			break;
+		}
+		break;
+	default:
+		dev_err(hdev->dev, "wrong card type %d\n", hdev->card_type);
+		break;
+	}
+}
+
+static void config_connection(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool pam4, bool do_auto_neg)
+{
+	u32 lane_idx = (gaudi_nic->port >> 1) * NIC_MAC_NUM_OF_LANES + lane;
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	struct cpucp_nic_info *nic_info;
+	char *prbs = "PRBS31";
+	u32 msblsb_tx = 0;
+	u32 msblsb_rx = 0;
+	u32 pol_tx = 0;
+	u32 pol_rx = 0;
+	u32 gc_tx = 1;
+	u32 gc_rx = 1;
+	u32 pc_tx = 0;
+	u32 pc_rx = 0;
+
+	nic_info = &hdev->asic_prop.cpucp_nic_info;
+
+	if (!pam4)
+		gc_tx = gc_rx = 0;
+
+	if (gaudi->nic_use_fw_polarity) {
+		pol_tx =
+			(le64_to_cpu(nic_info->pol_tx_mask[0]) >> lane_idx) & 1;
+		pol_rx =
+			(le64_to_cpu(nic_info->pol_rx_mask[0]) >> lane_idx) & 1;
+	} else {
+		get_pol_tx_rx(gaudi_nic, lane_idx, &pol_tx, &pol_rx);
+	}
+
+	phy_write_mask(gaudi_nic, lane, 0xF7, 1, 0x1000);
+	pol(gaudi_nic, lane, pam4, pol_tx, pol_rx);
+	msblsb(gaudi_nic, lane, msblsb_tx, msblsb_rx);
+	gc(gaudi_nic, lane, gc_tx, gc_rx);
+	pc(gaudi_nic, lane, pc_tx, pc_rx);
+
+	set_prbs_type(gaudi_nic, lane, pam4, prbs);
+}
+
+static void functional_mode(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool pam4)
+{
+	if (!pam4) {
+		phy_write_mask(gaudi_nic, lane, 0xA0, 0, 0x2000);
+		phy_write_mask(gaudi_nic, lane, 0x161, 0, 0x400);
+	} else {
+		phy_write_mask(gaudi_nic, lane, 0xA0, 0, 0x2000);
+		phy_write_mask(gaudi_nic, lane, 0x43, 0, 0x10);
+	}
+}
+
+static u32 get_fw_reg(struct gaudi_nic_device *gaudi_nic, int lane, u32 fw_addr)
+{
+	u32 ignore;
+
+	fw_cmd(gaudi_nic, lane, 0xE010, fw_addr, 0xE, &ignore);
+
+	return phy_read(gaudi_nic, lane, 0x9812);
+}
+
+static void config_pam4_fw_rx(struct gaudi_nic_device *gaudi_nic, int lane)
+{
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0x1, 0x1000);
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0x1, 0x0400);
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0x1, 0x0800);
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0x1, 0x0200);
+
+	phy_write(gaudi_nic, lane, 0x43, 0x8CFA);
+	phy_write(gaudi_nic, lane, 0x44, 0x1035);
+	phy_write(gaudi_nic, lane, 0x45, 0x1008);
+}
+
+static int fw_config_speed_nrz(struct gaudi_nic_device *gaudi_nic, int lane,
+				u32 data_rate, u32 speed, bool half_rate,
+				bool fmode, bool pam4)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 ignore;
+	int rc, i;
+
+	/* clear go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0, 0x8000);
+
+	rc = fw_cmd(gaudi_nic, lane, 0x80C0, speed, 0x8, &ignore);
+	if (rc) {
+		dev_err(hdev->dev,
+			"F/W cmd failed for speed nrz configuration of lane %d\n",
+			lane);
+		return rc;
+	}
+
+	config_nrz_tx(gaudi_nic, lane, half_rate);
+	phy_write_mask(gaudi_nic, lane, 0x0161, 0x1D, 0xFC00);
+	config_connection(gaudi_nic, lane, pam4, false);
+	functional_mode(gaudi_nic, lane, pam4);
+
+	/* clock configuration */
+	for (i = 0 ; i < 4 ; i++)
+		if (i == 0)
+			phy_write(gaudi_nic, i, 0x00C9, 0x390);
+		else
+			phy_write(gaudi_nic, i, 0x00C9, 0x310);
+
+	set_pll(gaudi_nic, lane, data_rate, pam4);
+	phy_write_mask(gaudi_nic, lane, 0x980F, 1, 0x8000);
+
+	return 0;
+}
+
+int gaudi_nic_phy_fw_config_auto_neg(struct gaudi_nic_device *gaudi_nic,
+					int lane)
+{
+	struct gaudi_device *gaudi = gaudi_nic->hdev->asic_specific;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u64 basepage = 0x000080000001;
+	u32 ignore;
+	int rc;
+
+	usleep_range(500, 1000);
+
+	/* clear go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0, 0x8000);
+
+	set_pll(gaudi_nic, lane, NIC_DR_25, false);
+
+	/* Disable AN/LT lane swapping */
+	phy_write_mask(gaudi_nic, lane, 0x8440, 0, 0x8000);
+	config_nrz_tx(gaudi_nic, lane, 0);
+
+	/* config_nrz_fw_rx */
+	phy_write_mask(gaudi_nic, lane, 0x0161, 0x1D, 0x0);
+	config_connection(gaudi_nic, lane, false, true);
+
+	phy_write_mask(gaudi_nic, lane, 0x8300, 7, 0xE000);
+
+	/* AN mode */
+	phy_write(gaudi_nic, lane, 0x8010, basepage & 0xffff);
+	phy_write(gaudi_nic, lane, 0x8011, (basepage >> 16) & 0xffff);
+	phy_write(gaudi_nic, lane, 0x8012, (basepage >> 32) & 0xffff);
+
+	/* IEEE */
+	phy_write_mask(gaudi_nic, lane, 0x8300, 1, 0x1000);
+
+	if (gaudi->nic_phy_auto_neg_lpbk)
+		phy_write_mask(gaudi_nic, lane, 0x8300, 1, 0x400);
+
+	/* set FW to start AN */
+	rc = fw_cmd(gaudi_nic, lane, 0x8000, 0, 8, &ignore);
+	if (rc) {
+		dev_err(hdev->dev,
+			"F/W cmd 0x8000 failed for auto neg, port %d, lane %d\n",
+			gaudi_nic->port, lane);
+		return rc;
+	}
+
+	/* set go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 1, 0x8000);
+
+	return 0;
+}
+
+static int fw_config_speed_pam4(struct gaudi_nic_device *gaudi_nic, int lane,
+				u32 data_rate, u32 speed, bool fmode, bool pam4)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 ignore;
+	int rc;
+
+	dev_dbg(hdev->dev,
+		"port: %d, lane: %d, data rate: %d, pam4: %d, speed: %d\n",
+		gaudi_nic->port, lane, data_rate, pam4, speed);
+
+	/* clear go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0, 0x8000);
+
+	phy_write_mask(gaudi_nic, lane, 0x8440, 0, 0x8000);
+
+	rc = fw_cmd(gaudi_nic, lane, 0x80D0, speed, 0x8, &ignore);
+	if (rc) {
+		dev_err(hdev->dev,
+			"F/W cmd failed for speed pam4 configuration of lane %d\n",
+			lane);
+		return rc;
+	}
+
+	config_pam4_tx(gaudi_nic, lane);
+	config_pam4_fw_rx(gaudi_nic, lane);
+	config_connection(gaudi_nic, lane, pam4, false);
+	functional_mode(gaudi_nic, lane, pam4);
+
+	/* set go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 1, 0x8000);
+
+	return 0;
+}
+
+int gaudi_nic_phy_config_pam4_link_training(struct gaudi_nic_device *gaudi_nic,
+						int lane)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 port = gaudi_nic->port;
+	u32 ignore, speed = 9;
+	int rc;
+
+#if HL_PHY_DEBUG
+	dev_dbg(hdev->dev, "NIC %d lane: %d, speed: %d\n", port, lane, speed);
+#endif
+
+	/* clear go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 0, 0x8000);
+
+	/* Disable lane swapping */
+	phy_write_mask(gaudi_nic, lane, 0x8440, 0, 0x8000);
+
+	/* Enable Link Training */
+	speed |= 0x100;
+
+	config_pam4_tx(gaudi_nic, lane);
+	phy_write_mask(gaudi_nic, lane, 0xA0, 0, 0x2000);
+	config_pam4_fw_rx(gaudi_nic, lane);
+	config_connection(gaudi_nic, lane, true, false);
+
+	rc = fw_cmd(gaudi_nic, lane, 0x80D0, speed, 0x8, &ignore);
+	if (rc) {
+		dev_err(hdev->dev,
+			"F/W cmd failed for speed pam4 configuration of port %d lane %d\n",
+			port, lane);
+		return rc;
+	}
+
+	phy_write_mask(gaudi_nic, lane, 0xAF, 0, 0x200);
+	phy_write_mask(gaudi_nic, lane, 0xAF, 0, 0x100);
+	phy_write_mask(gaudi_nic, lane, 0x42, 0, 0x2);
+	phy_write_mask(gaudi_nic, lane, 0x42, 0, 0x1);
+
+	/* set go bit */
+	phy_write_mask(gaudi_nic, lane, 0x980F, 1, 0x8000);
+
+	return 0;
+}
+
+static int fw_config(struct gaudi_nic_device *gaudi_nic, int lane,
+			u32 data_rate, bool fmode, bool pam4)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+
+	set_pll(gaudi_nic, lane, data_rate, pam4);
+
+	if (data_rate == NIC_DR_10)
+		return fw_config_speed_nrz(gaudi_nic, lane, data_rate, 1, 1,
+						fmode, pam4);
+	else if (data_rate == NIC_DR_25 || data_rate == NIC_DR_26)
+		return fw_config_speed_nrz(gaudi_nic, lane, data_rate, 3, 0,
+						fmode, pam4);
+	else if (data_rate == NIC_DR_50)
+		return fw_config_speed_pam4(gaudi_nic, lane, data_rate, 9,
+						fmode, pam4);
+
+	dev_err(hdev->dev, "invalid data_rate %d\n", data_rate);
+
+	return -EFAULT;
+}
+
+static int fw_crc_port(struct hl_device *hdev, int port, int lane, u16 *crc)
+{
+	u32 res;
+	int rc;
+
+	rc = fw_cmd_port(hdev, port, lane, 0xF001, 0, 0xF, &res);
+	if (rc) {
+		dev_err(hdev->dev, "F/W crc failed for port %d lane %d\n", port,
+			lane);
+		return rc;
+	}
+
+	*crc = phy_read_port(hdev, port, lane, 0x9816) & 0xFFFF;
+
+	return 0;
+}
+
+int gaudi_nic_phy_has_fw(struct hl_device *hdev)
+{
+	const struct firmware *fw;
+	int rc;
+
+	rc = request_firmware(&fw, GAUDI_PHY_FW_FILE, hdev->dev);
+	if (rc) {
+		dev_err(hdev->dev, "Firmware file %s is not found!\n",
+				GAUDI_PHY_FW_FILE);
+		return rc;
+	}
+
+	if (fw->size < PHY_FW_SIZE) {
+		dev_err(hdev->dev, "Illegal %s firmware size %zu\n",
+				GAUDI_PHY_FW_FILE, fw->size);
+		rc = -EFAULT;
+	}
+
+	release_firmware(fw);
+
+	return rc;
+}
+
+static void fw_unload_all(struct hl_device *hdev, bool pam4)
+{
+	phy_write_all(hdev, 0x9814, 0xFFF0);
+	phy_write_all(hdev, 0x980D, 0xAAA);
+	phy_write_all(hdev, 0x980D, 0);
+
+	msleep(100);
+
+	phy_write_all(hdev, 0x9814, 0);
+
+	if (pam4)
+		phy_write_all(hdev, 0x11, 0);
+	else
+		phy_write_all(hdev, 0x10B, 0);
+}
+
+u16 gaudi_nic_phy_get_crc(struct hl_device *hdev)
+{
+	u16 crc = 0;
+
+	fw_crc_port(hdev, 0, 0, &crc);
+
+	return crc;
+}
+
+int gaudi_nic_phy_fw_load_all(struct hl_device *hdev)
+{
+	u32 entry_point, length, ram_addr, sections, status, checks, hash = 0,
+		checksum = 0x800C, fw0 = 0x9F00, fw1 = 0x980D, fw2 = 0x9814;
+	int rc, i, j, port, data_ptr = 0, lane = 0;
+	const struct firmware *fw;
+	u16 mdio_data, crc = 0;
+	const void *fw_data;
+	bool pam4 = true; /* for debug */
+
+	fw_unload_all(hdev, pam4);
+
+	rc = request_firmware(&fw, GAUDI_PHY_FW_FILE, hdev->dev);
+	if (rc) {
+		dev_err(hdev->dev, "Firmware file %s is not found!\n",
+				GAUDI_PHY_FW_FILE);
+		return rc;
+	}
+
+	if (fw->size < PHY_FW_SIZE) {
+		dev_err(hdev->dev, "Illegal %s firmware size %zu\n",
+				GAUDI_PHY_FW_FILE, fw->size);
+		release_firmware(fw);
+		return -EFAULT;
+	}
+
+	fw_data = (const void *) fw->data;
+	fw_data += 0x1000;
+
+	/* skip hash, crc and date */
+	entry_point = get_unaligned_be32(fw_data + 8);
+	length = get_unaligned_be32(fw_data + 12);
+	ram_addr = get_unaligned_be32(fw_data + 16);
+
+	dev_dbg(hdev->dev, "entry_point: 0x%x\n", entry_point);
+	dev_dbg(hdev->dev, "length: 0x%x\n", length);
+
+	fw_data += 20;
+
+	sections = DIV_ROUND_UP(length, 24);
+
+	dev_dbg(hdev->dev, "sections: %d\n", sections);
+
+	phy_write_all(hdev, fw2, 0xFFF0);
+	phy_write_all(hdev, fw1, 0x0AAA);
+	phy_write_all(hdev, fw1, 0);
+
+	msleep(500);
+
+	checks = 0;
+	do {
+		usleep_range(10000, 20000);
+		status = phy_read_port(hdev, 0, 0, fw2);
+		dev_dbg(hdev->dev, "lane: %d, status: 0x%x\n", lane, status);
+		if (checks++ > PHY_READ_COUNTS_PER_MS) {
+			dev_err(hdev->dev,
+				"failed to load NIC F/W, fw2 timeout 0x%x\n",
+				status);
+			release_firmware(fw);
+			return -ETIMEDOUT;
+		}
+	} while (status);
+
+	phy_write_all(hdev, fw2, 0);
+
+	for (i = 0 ; i <= sections ; i++) {
+		checksum = 0x800C;
+		phy_write_all(hdev, fw0 + 12, ram_addr >> 16);
+		phy_write_all(hdev, fw0 + 13, ram_addr & 0xFFFF);
+		checksum += (ram_addr >> 16) + (ram_addr & 0xFFFF);
+		for (j = 0 ; j < 12 ; j++) {
+			if (data_ptr >= length)
+				mdio_data = 0;
+			else
+				mdio_data =
+					get_unaligned_be16(fw_data + data_ptr);
+
+			phy_write_all(hdev, fw0 + j, mdio_data);
+			checksum += mdio_data;
+			data_ptr += 2;
+			ram_addr += 2;
+		}
+
+		phy_write_all(hdev, fw0 + 14, (~checksum + 1) & 0xFFFF);
+		phy_write_all(hdev, fw0 + 15, 0x800C);
+
+		checks = 0;
+
+		do {
+			usleep_range(1000, 2000);
+			status = phy_read_port(hdev, 0, 0, fw0 + 15);
+			if (checks++ > PHY_READ_COUNTS_PER_MS) {
+				dev_err(hdev->dev,
+					"failed to load NIC F/W, fw0 timeout 0x%x\n",
+					status);
+				release_firmware(fw);
+				return -ETIMEDOUT;
+			}
+		} while (status == 0x800C);
+	}
+
+	phy_write_all(hdev, fw0 + 12, entry_point >> 16);
+	phy_write_all(hdev, fw0 + 13, entry_point & 0xFFFF);
+	checksum = (entry_point >> 16) + (entry_point & 0xFFFF) + 0x4000;
+	phy_write_all(hdev, fw0 + 14, (~checksum + 1) & 0xFFFF);
+	phy_write_all(hdev, fw0 + 15, 0x4000);
+
+	for (port = 0 ; port < 1 ; port += 2)
+		for (lane = 0 ; lane < 1 ; lane++) {
+			fw_crc_port(hdev, port, lane, &crc);
+			dev_dbg(hdev->dev, "port: %d lane: %d crc: 0x%x\n",
+				port, lane, crc);
+			fw_hash_port(hdev, port, lane, &hash);
+			dev_dbg(hdev->dev, "port: %d lane: %d hash: 0x%x\n",
+				port, lane, hash);
+		}
+
+	return 0;
+}
+
+static u32 fw_tuning_counter(struct gaudi_nic_device *gaudi_nic, int lane)
+{
+	return get_fw_reg(gaudi_nic, lane, 5);
+}
+
+static u32 fw_reset_counter(struct gaudi_nic_device *gaudi_nic, int lane)
+{
+	return get_fw_reg(gaudi_nic, lane, 4);
+}
+
+static void print_eye(struct gaudi_nic_device *gaudi_nic, int lane, bool pam4)
+{
+	s32 plus_margin, minus_margin, result, diff;
+	struct hl_device *hdev = gaudi_nic->hdev;
+	int pam4_eye[3], eye_index, i, sel;
+	u32 dac, eye, mask, val1, val2;
+
+	if (pam4) {
+		dac = (phy_read(gaudi_nic, lane, 0x28) & 0x1E0) >> 5;
+		for (eye_index = 0; eye_index < 3; eye_index++) {
+			result = 0xffff;
+			for (i = 0; i < 3; i++) {
+				sel = 3 * i + eye_index;
+				phy_write_mask(gaudi_nic, lane, 0x88, sel,
+						0xF00);
+				phy_write_mask(gaudi_nic, lane, 0x88, sel,
+						0xF000);
+
+				msleep(100);
+
+				val1 = phy_read(gaudi_nic, lane, 0x32);
+				plus_margin = (val1 & 0xFFF0) >> 4;
+				if (plus_margin > 0x7ff)
+					plus_margin = plus_margin - 0x1000;
+
+				val1 = phy_read(gaudi_nic, lane, 0x32);
+				val2 = phy_read(gaudi_nic, lane, 0x33);
+				minus_margin = ((val1 & 0xF) << 8) +
+						((val2 & 0xFF00) >> 8);
+				if (minus_margin > 0x7ff)
+					minus_margin = minus_margin - 0x1000;
+
+				diff = plus_margin - minus_margin;
+				if (diff < result)
+					result = diff;
+			}
+
+			pam4_eye[eye_index] =
+					(result * (100 + (50 * dac))) / 2048;
+		}
+
+		dev_dbg(hdev->dev,
+			"NIC PAM4 dac: %d eye0: %d eye1: %d eye2: %d\n", dac,
+			pam4_eye[0], pam4_eye[1], pam4_eye[2]);
+	} else {
+		mask = 0xF000;
+		dac = (phy_read(gaudi_nic, lane, 0x17F) & mask) >> __ffs(mask);
+		mask = 0xFFF;
+		eye = (phy_read(gaudi_nic, lane, 0x12A) & mask) >> __ffs(mask);
+
+		dev_dbg(hdev->dev, "dac: %d, eye: %d\n", dac, eye);
+
+		if (eye > 0)
+			dev_dbg(hdev->dev,
+				"NIC port %d lane %d: F/W eye is %d\n",
+				gaudi_nic->port, lane,
+				(eye * (200 + 50 * dac)) / 2048);
+		else
+			dev_err(hdev->dev,
+				"NIC port %d lane %d: F/W got no eye\n",
+				gaudi_nic->port, lane);
+	}
+}
+
+int gaudi_nic_phy_check_link_status(struct gaudi_nic_device *gaudi_nic,
+					int lane)
+{
+	bool phy_ready, pam4 = gaudi_nic->data_rate == NIC_DR_50;
+#if HL_PHY_DEBUG
+	bool signal_detect;
+#endif
+	u32 phy_status;
+
+	if (pam4) {
+		phy_status = phy_read(gaudi_nic, lane, 0x6A);
+		phy_ready = ((phy_status & 0x8000) >> 15) & 1;
+#if HL_PHY_DEBUG
+		signal_detect = ((phy_status & 0x80) >> 7) & 1;
+#endif
+	} else {
+		phy_status = phy_read(gaudi_nic, lane, 0x12E);
+		phy_ready = ((phy_status & 0x4) >> 2) & 1;
+#if HL_PHY_DEBUG
+		signal_detect = ((phy_status & 0x8) >> 3) & 1;
+#endif
+	}
+
+#if HL_PHY_DEBUG
+	{
+		struct hl_device *hdev = gaudi_nic->hdev;
+
+		dev_dbg_ratelimited(hdev->dev,
+			"port: %d, lane, %d, phy ready: %d, signal detect: %d\n",
+			gaudi_nic->port, lane, phy_ready, signal_detect);
+	}
+#endif
+
+	return phy_ready ? 0 : -EFAULT;
+}
+
+int gaudi_nic_phy_fw_tuning(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool check_status)
+{
+	bool pam4 = (gaudi_nic->data_rate == NIC_DR_50);
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 status, port = gaudi_nic->port;
+
+	fw_tuning_counter(gaudi_nic, lane);
+	fw_reset_counter(gaudi_nic, lane);
+	status = phy_read(gaudi_nic, lane, 0x9811);
+
+	if (status & PHY_FW_FINISHED) {
+		if (status & PHY_FW_ERROR) {
+			dev_dbg(hdev->dev, "NIC %d lane %d F/W tuning failed\n",
+				port, lane);
+			return -EFAULT;
+		}
+#if HL_PHY_DEBUG
+		dev_dbg(hdev->dev,
+			"NIC %d lane %d F/W Tuning is done\n", port, lane);
+#endif
+	} else {
+		return -EAGAIN;
+	}
+
+	if (!gaudi_nic->auto_neg_enable) {
+		phy_write_mask(gaudi_nic, lane, 0x14D, 1, 1 << 15);
+		print_eye(gaudi_nic, lane, pam4);
+	} else if (!check_status) {
+		return 0;
+	}
+
+	return gaudi_nic_phy_check_link_status(gaudi_nic, lane);
+}
+
+int gaudi_nic_phy_power_up(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool do_auto_neg)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	u32 data_rate = gaudi_nic->data_rate;
+	bool pam4, fmode = 0;
+	int rc;
+
+	pam4 = (data_rate == NIC_DR_50);
+
+	dev_dbg(hdev->dev, "PHY power up port %d lane %d auto_neg: %d\n",
+		gaudi_nic->port, lane, do_auto_neg);
+
+	/* F/W configurations */
+	if (gaudi_nic->auto_neg_enable) {
+		if (do_auto_neg) {
+			rc = gaudi_nic_phy_fw_config_auto_neg(gaudi_nic, lane);
+			if (rc) {
+				dev_err(hdev->dev,
+					"F/W configuration failed for NIC PHY\n");
+				return rc;
+			}
+		}
+	} else {
+		rc = fw_config(gaudi_nic, lane, data_rate, fmode, pam4);
+		if (rc) {
+			dev_err(hdev->dev,
+				"F/W configuration failed for NIC PHY\n");
+			return rc;
+		}
+	}
+
+	return 0;
+}
+
+int gaudi_nic_phy_reset_macro(struct gaudi_nic_device *gaudi_nic)
+{
+	struct hl_device *hdev = gaudi_nic->hdev;
+	s32 chip_reset_addr = 0x980D;
+	bool fmode = 0;
+	int rc, i;
+
+	dev_dbg(hdev->dev, "PHY reset macro, port %d\n", gaudi_nic->port);
+
+	/* soft reset */
+	for (i = 0 ; i < 4 ; i++)
+		phy_write(gaudi_nic, i, chip_reset_addr, 0x888);
+
+	usleep_range(500, 1000);
+
+	/* clock configuration */
+	for (i = 0 ; i < 4 ; i++)
+		if (i == 0)
+			phy_write(gaudi_nic, i, 0x00C9, 0x390);
+		else
+			phy_write(gaudi_nic, i, 0x00C9, 0x310);
+
+	for (i = 0 ; i < 4 ; i++) {
+		phy_write(gaudi_nic, i, 0x8000, 0xC000);
+		phy_write(gaudi_nic, i, 0x8210, 0);
+		phy_write(gaudi_nic, i, 0x8100, 0);
+	}
+
+	/* PHY controller reset - to force F/W to start from pointer 0 */
+	for (i = 0 ; i < 4 ; i++) {
+		phy_write(gaudi_nic, i, chip_reset_addr, 0xAAA);
+		phy_write(gaudi_nic, i, chip_reset_addr, 0);
+	}
+
+	/* force the lane pll to run in PAM4 before logical reset */
+	for (i = 0 ; i < 4 ; i++) {
+		rc = fw_config(gaudi_nic, i, NIC_DR_50, fmode, true);
+		if (rc) {
+			dev_err(hdev->dev,
+				"F/W configuration failed for NIC PHY\n");
+			return rc;
+		}
+	}
+
+	/* logic reset */
+	for (i = 0 ; i < 4 ; i++) {
+		phy_write(gaudi_nic, i, chip_reset_addr, 0x777);
+		phy_write(gaudi_nic, i, chip_reset_addr, 0);
+	}
+
+	usleep_range(500, 1000);
+
+	return 0;
+}
+
+void gaudi_nic_phy_reset_tx(struct gaudi_nic_device *gaudi_nic, int lane)
+{
+	u32 val;
+
+	/* disable TX */
+	val = phy_read(gaudi_nic, lane, 0xA0);
+	/* set bit 13 to 1 */
+	val |= 0x2000;
+	/* set bit 11 to 0 */
+	val &= ~0x800;
+	phy_write(gaudi_nic, lane, 0xA0, val);
+
+	msleep(500);
+
+	/* enable TX */
+	val = phy_read(gaudi_nic, lane, 0xA0);
+	/* set bit 13 to 0 */
+	val &= ~0x2000;
+	phy_write(gaudi_nic, lane, 0xA0, val);
+}
+
+void gaudi_nic_phy_start_stop(struct gaudi_nic_device *gaudi_nic, int lane,
+				bool is_start)
+{
+	if (is_start) {
+		/* Enable TX driver in SerDes */
+		phy_write_mask(gaudi_nic, lane, 0xE3, 1, 0x2000);
+		/* Enable F/W Rx tuning is done during power up sequence */
+	} else {
+		/* Disable TX driver in SerDes */
+		phy_write_mask(gaudi_nic, lane, 0xE3, 0, 0x2000);
+		/* Silence F/W Rx tuning */
+		phy_write(gaudi_nic, lane, 0x9815, 0x9000);
+	}
+}
-- 
2.17.1

