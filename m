Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECA169D885
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbjBUCe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbjBUCeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:34:25 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D421A489;
        Mon, 20 Feb 2023 18:34:01 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id D4B9C405FF;
        Tue, 21 Feb 2023 02:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676946837;
        bh=ezbPlxDXhaV/sDJAItoixMIy3dMW2xrI6AAH/J1Y45I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=b7MKVP8UxhA1dKb/URCZruGgXPBO5jiC12PZyrFddz6R7S2I+E+Wrhw37bI85p0U8
         8KvcuygFsxcxskatGpsB4N+xpDJXCNUTXsuPktYw+PEZO7p5C4jfX4XZfmgpE2z9tr
         +qE20xmlry42t5rBSeSb77l13LQPlzJfZg402117qD2LmQv/4ro7G5IBSzszBWUAF3
         DyB5NYw3BR8YzxkZZBqrKj6+FUmya/vNB6QR93hwP/AQlPNtUhIlyGUIVSVfyPMNe3
         qSU9PKMTRdeOe7UXtysXlZC7VKdE+ivAy856P8TnGMpHRQCbzCYcHFzZNkBKdzHc7j
         SxF/eXILjwLBA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 5/6] r8169: Use mutex to guard config register locking
Date:   Tue, 21 Feb 2023 10:32:36 +0800
Message-Id: <20230221023237.1905536-6-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221023237.1905536-1-kai.heng.feng@canonical.com>
References: <20230221023237.1905536-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now r8169 doesn't have parallel access to its config register, but
the next patch makes the driver access config register at anytime.

So add a mutex to protect the config register from any potential race.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v8:
 - Swap the place when using the mutex. Protect when config register is
   unlocked.

v7:
 - This is a new patch.

 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e40498dd08d17..897f90b48bba6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -613,6 +613,8 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	struct mutex config_lock;
+
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
@@ -662,10 +664,12 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
+	mutex_unlock(&tp->config_lock);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
+	mutex_lock(&tp->config_lock);
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
 }
 
@@ -5217,6 +5221,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	mutex_init(&tp->config_lock);
+
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
 	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
-- 
2.34.1

