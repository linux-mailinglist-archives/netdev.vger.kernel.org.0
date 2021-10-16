Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59C34300FF
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 09:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243854AbhJPH5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 03:57:21 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59636
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243847AbhJPH5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 03:57:20 -0400
Received: from HP-EliteBook-840-G7.. (36-229-230-94.dynamic-ip.hinet.net [36.229.230.94])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 1FEC541B9B;
        Sat, 16 Oct 2021 07:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634370912;
        bh=sYtxWk/9F8kIk/EvT2aldjm/z/xHFQDrJ3LScERKp3U=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=JisBaMUPkA/+Xri84pp2WF6CshxcdEn9bjG7id68fWIIXE9DWlZvQ7TCGi8gzWQ0b
         k2Qfo9YJgQumqn5Gd22ieqqWf44OfaojyNUxyiha6FFSukVAcA25p5RWIK7yf9IPa4
         eo7i5Gb6tRbzaejTOex+mUnlx0eRdb6m6ac/GQazCuD2fxfSVKHhFqKHspAiYH2okb
         JUZXG2/06fnczicn2UArnOsDCddJBmwpQ2eRsQRRD63uiObPOsR4WzSVn6R/EnISJM
         uHaIsNfGKrOW2lfi5Za9XinUqvyzPZ/gCu00Z5HlpDtshNfdGfT0Mx8fYv7uGHSdPw
         WAqZhQlMc80ZQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [RFC] [PATCH net-next v7 3/4] r8169: Use mutex to guard config register locking
Date:   Sat, 16 Oct 2021 15:54:41 +0800
Message-Id: <20211016075442.650311-4-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211016075442.650311-1-kai.heng.feng@canonical.com>
References: <20211016075442.650311-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now r8169 doesn't have parallel access to its config register, but
the next patch will access config register at anytime.

So add a mutex to prevent the race.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v7:
 - This is a new patch.

 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 53936ebb3b3a6..b91de853e60f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -621,6 +621,8 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	struct mutex config_lock;
+
 	unsigned supports_gmii:1;
 	dma_addr_t counters_phys_addr;
 	struct rtl8169_counters *counters;
@@ -670,12 +672,14 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
+	mutex_lock(&tp->config_lock);
 	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
+	mutex_unlock(&tp->config_lock);
 }
 
 static void rtl_pci_commit(struct rtl8169_private *tp)
@@ -5307,6 +5311,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	mutex_init(&tp->config_lock);
+
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
 	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
-- 
2.32.0

