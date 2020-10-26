Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE1299CDC
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437443AbgJ0ACQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:02:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411080AbgJZX4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9AA421655;
        Mon, 26 Oct 2020 23:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756575;
        bh=HuUrQmQhOLgVAZnDVmNGwkA3mB4folOoB2tnhWkJwJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzqoVHCnnQ9t6DyTqeN6i8sFfvARJyPcH4ewqt8ly5SdUfeg4k1WT9GpqyRaqI7Qb
         Jw+y5N0GhbaKXunvQ/4Pn6+XOkCVa45oro865Y7wWzhikRsJXQAZORbBj2V1hOMgg0
         2PAeTjskjikvSKbycopqFznEXEyq9OgW7aC/zjcs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wright Feng <wright.feng@cypress.com>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 49/80] brcmfmac: Fix warning message after dongle setup failed
Date:   Mon, 26 Oct 2020 19:54:45 -0400
Message-Id: <20201026235516.1025100-49-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit 6aa5a83a7ed8036c1388a811eb8bdfa77b21f19c ]

Brcmfmac showed warning message in fweh.c when checking the size of event
queue which is not initialized. Therefore, we only cancel the worker and
reset event handler only when it is initialized.

[  145.505899] brcmfmac 0000:02:00.0: brcmf_pcie_setup: Dongle setup
[  145.929970] ------------[ cut here ]------------
[  145.929994] WARNING: CPU: 0 PID: 288 at drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:312
brcmf_fweh_detach+0xbc/0xd0 [brcmfmac]
...
[  145.930029] Call Trace:
[  145.930036]  brcmf_detach+0x77/0x100 [brcmfmac]
[  145.930043]  brcmf_pcie_remove+0x79/0x130 [brcmfmac]
[  145.930046]  pci_device_remove+0x39/0xc0
[  145.930048]  device_release_driver_internal+0x141/0x200
[  145.930049]  device_release_driver+0x12/0x20
[  145.930054]  brcmf_pcie_setup+0x101/0x3c0 [brcmfmac]
[  145.930060]  brcmf_fw_request_done+0x11d/0x1f0 [brcmfmac]
[  145.930062]  ? lock_timer_base+0x7d/0xa0
[  145.930063]  ? internal_add_timer+0x1f/0xa0
[  145.930064]  ? add_timer+0x11a/0x1d0
[  145.930066]  ? __kmalloc_track_caller+0x18c/0x230
[  145.930068]  ? kstrdup_const+0x23/0x30
[  145.930069]  ? add_dr+0x46/0x80
[  145.930070]  ? devres_add+0x3f/0x50
[  145.930072]  ? usermodehelper_read_unlock+0x15/0x20
[  145.930073]  ? _request_firmware+0x288/0xa20
[  145.930075]  request_firmware_work_func+0x36/0x60
[  145.930077]  process_one_work+0x144/0x360
[  145.930078]  worker_thread+0x4d/0x3c0
[  145.930079]  kthread+0x112/0x150
[  145.930080]  ? rescuer_thread+0x340/0x340
[  145.930081]  ? kthread_park+0x60/0x60
[  145.930083]  ret_from_fork+0x25/0x30

Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200928054922.44580-3-wright.feng@cypress.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/fweh.c    | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 79c8a858b6d6f..a30fcfbf2ee7c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -304,10 +304,12 @@ void brcmf_fweh_detach(struct brcmf_pub *drvr)
 {
 	struct brcmf_fweh_info *fweh = &drvr->fweh;
 
-	/* cancel the worker */
-	cancel_work_sync(&fweh->event_work);
-	WARN_ON(!list_empty(&fweh->event_q));
-	memset(fweh->evt_handler, 0, sizeof(fweh->evt_handler));
+	/* cancel the worker if initialized */
+	if (fweh->event_work.func) {
+		cancel_work_sync(&fweh->event_work);
+		WARN_ON(!list_empty(&fweh->event_q));
+		memset(fweh->evt_handler, 0, sizeof(fweh->evt_handler));
+	}
 }
 
 /**
-- 
2.25.1

