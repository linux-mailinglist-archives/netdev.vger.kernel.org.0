Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A236A2723
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 04:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBYDs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 22:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBYDsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 22:48:25 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEBCC66B;
        Fri, 24 Feb 2023 19:47:58 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8FDC142189;
        Sat, 25 Feb 2023 03:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677296876;
        bh=nmhAJy6ZN5K9TJvBP4/JewNFzlok1solpEdig0dxwzg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YYm+XSCTD+11D+kTudDUyN2sd7jvlKKV4+0qPETbYRJXOHyGkeq5SiOBL01bIFfVK
         LzAxkxa3FINiz6qYqIa+Q11hfJsSVMNPTesGYG6xCOxN53/kokq+I6KDhQ2/vx3Dmc
         w6XEL47JqJlMa9A604nPB5NXMmp79jBAdQaxPV6oxdnNgDPXHeybktQcAbM2QebTg3
         ZSz24aegXIqa79qxbpcoG+yjYY7b4UdagUV0YvQ4JY8YxzI6M6Rz5oJMQfcl+3GW2y
         IsKU1/WBTK3ft/AhDHCzujrOyLjXc3TjGhHfeUZfOD3NE/nJsGvxKDJ/cR57Kwk3hU
         4c1Dd+dkroCNQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v9 4/5] r8169: Use spinlock to guard config register locking
Date:   Sat, 25 Feb 2023 11:46:34 +0800
Message-Id: <20230225034635.2220386-5-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
References: <20230225034635.2220386-1-kai.heng.feng@canonical.com>
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

So add a spinlock to protect the config register from any potential race.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v9:
 - Replace mutex with spinlock so it can be used in softirq context.

v8:
 - Swap the place when using the mutex. Protect when config register is
   unlocked.

v7:
 - This is a new patch.

 drivers/net/ethernet/realtek/r8169_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a857650c2e82b..fb73b5386701f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -613,6 +613,8 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	spinlock_t config_lock;
+
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	dma_addr_t counters_phys_addr;
@@ -662,10 +664,12 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
+	spin_unlock_bh(&tp->config_lock);
 }
 
 static void rtl_unlock_config_regs(struct rtl8169_private *tp)
 {
+	spin_lock_bh(&tp->config_lock);
 	RTL_W8(tp, Cfg9346, Cfg9346_Unlock);
 }
 
@@ -5217,6 +5221,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
+	spin_lock_init(&tp->config_lock);
+
 	tp->mmio_addr = pcim_iomap_table(pdev)[region];
 
 	xid = (RTL_R32(tp, TxConfig) >> 20) & 0xfcf;
-- 
2.34.1

