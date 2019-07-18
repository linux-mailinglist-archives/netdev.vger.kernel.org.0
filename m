Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E579D6C4D4
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 04:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbfGRCIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 22:08:54 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:47047 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbfGRCIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 22:08:51 -0400
Received: by mail-oi1-f196.google.com with SMTP id 65so20197001oid.13
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 19:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fredlawl-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pYIGokAnHiTaXGPTQHk0GqCr5VmgXxhysOu7yDy4mE8=;
        b=mTXnqU5jjT+d2PiAwqfS+oHZeBwddIfIzbgwJr5HJVj8OZu3Ejhi+A9hQAi3E1QXSB
         p6yso+LASKDHoVMvrSZNUJW8Qr/lVybvydLGLZG3dAWCnsQe9rQVN9QPaP7cXSOOm7xG
         WeqBJrZ7jJE0djFZh+4thTZM1/E0H6ZFc4+kAD5x48/AIdMh8SWZL9dZtCJBm9OVm3eH
         hJBKA/kvNzNJnG5RfU9oPb10jIKyI3UyWzoAX2uJ9/ndXvbz/1w5O7at+bEgY29vT8Un
         cx5tgXraKzGDqNnRvqxLNfVGtKJDyu6t+DvKjYCl0HBdgLrZT/IlUcw4u2gwiB4nTnZ7
         vcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pYIGokAnHiTaXGPTQHk0GqCr5VmgXxhysOu7yDy4mE8=;
        b=ja2DC3Q3MrdbnYCc+Ndm1Q6ULYhOpUM2Hofjf//NcD0pLoX3pzmUhf+TcGF408A4Sm
         J4NyVGMu7mo4wAwqa/nySjZcch3HlnircS2dJvAI8mq/rkULcLbzWz24jCbzK4z7JDNs
         /IgDQ7jZggW3Wgio3sS1nKDcQPX+owgptJ4NUskUJsl9jaLDiXxpKxm2X4Ou7NgAiloU
         ovgQ3Y7c0rpBxntmSpoacGYC5gbmrhxaAeAEiNlnjUQtNG1MigfJ3w/+QNGB/rO0CR7h
         pr7yuWA2IQfk0Rv9GKNufsDa3jSH2pC261vykkomnS3caTamzh1PanNW2NeU+gYh43Fc
         5FjQ==
X-Gm-Message-State: APjAAAWIjYTNfpv964RY1Q9jWYJcFkN7qBz805xCQxBndHU8RZB1AFxB
        byu5dfx4b9LHTKtQKmAlXMwv0HbL1ZQYiQ==
X-Google-Smtp-Source: APXvYqyU0Pfb/5vUCO66TmKbYlCzgLlHqd41g6a+kdgNWxNg9gHANJ35Dgn3P91SIentrM9mHXMU4w==
X-Received: by 2002:aca:382:: with SMTP id 124mr19829874oid.80.1563415730827;
        Wed, 17 Jul 2019 19:08:50 -0700 (PDT)
Received: from linux.fredlawl.com ([2600:1700:18a0:11d0:18af:e893:6cb0:139a])
        by smtp.gmail.com with ESMTPSA id 93sm9102146ota.77.2019.07.17.19.08.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 19:08:50 -0700 (PDT)
From:   Frederick Lawler <fred@fredlawl.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     Frederick Lawler <fred@fredlawl.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
Subject: [PATCH] igc: Prefer pcie_capability_read_word()
Date:   Wed, 17 Jul 2019 21:07:39 -0500
Message-Id: <20190718020745.8867-4-fred@fredlawl.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190718020745.8867-1-fred@fredlawl.com>
References: <20190718020745.8867-1-fred@fredlawl.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8c0d3a02c130 ("PCI: Add accessors for PCI Express Capability")
added accessors for the PCI Express Capability so that drivers didn't
need to be aware of differences between v1 and v2 of the PCI
Express Capability.

Replace pci_read_config_word() and pci_write_config_word() calls with
pcie_capability_read_word() and pcie_capability_write_word().

Signed-off-by: Frederick Lawler <fred@fredlawl.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 34fa0e60a780..8e8ad07a5776 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3891,13 +3891,11 @@ void igc_write_pci_cfg(struct igc_hw *hw, u32 reg, u16 *value)
 s32 igc_read_pcie_cap_reg(struct igc_hw *hw, u32 reg, u16 *value)
 {
 	struct igc_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = pci_find_capability(adapter->pdev, PCI_CAP_ID_EXP);
-	if (!cap_offset)
+	if (!pci_is_pcie(adapter->pdev))
 		return -IGC_ERR_CONFIG;
 
-	pci_read_config_word(adapter->pdev, cap_offset + reg, value);
+	pcie_capability_read_word(adapter->pdev, reg, value);
 
 	return IGC_SUCCESS;
 }
@@ -3905,13 +3903,11 @@ s32 igc_read_pcie_cap_reg(struct igc_hw *hw, u32 reg, u16 *value)
 s32 igc_write_pcie_cap_reg(struct igc_hw *hw, u32 reg, u16 *value)
 {
 	struct igc_adapter *adapter = hw->back;
-	u16 cap_offset;
 
-	cap_offset = pci_find_capability(adapter->pdev, PCI_CAP_ID_EXP);
-	if (!cap_offset)
+	if (!pci_is_pcie(adapter->pdev))
 		return -IGC_ERR_CONFIG;
 
-	pci_write_config_word(adapter->pdev, cap_offset + reg, *value);
+	pcie_capability_write_word(adapter->pdev, reg, *value);
 
 	return IGC_SUCCESS;
 }
-- 
2.17.1

