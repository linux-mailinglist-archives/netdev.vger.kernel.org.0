Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53F869D8A9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 03:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbjBUCkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 21:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbjBUCk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 21:40:29 -0500
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3A323671;
        Mon, 20 Feb 2023 18:40:12 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 9232F3F2FE;
        Tue, 21 Feb 2023 02:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676947210;
        bh=ezbPlxDXhaV/sDJAItoixMIy3dMW2xrI6AAH/J1Y45I=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=ETctbcQNZLeQqgunhUqAiRSQAKR3iGoZpdxkpmEZjAHKoOakaT7ya1hEzA2o0NASo
         dYyNakLLya0F3VYLRyHMoJeuijhEdN1oxOlgwP3WZcRYU2lMK7M6pt6sAMoVvh6B+k
         uGbVNCPJ0LW9DwUtNFSszrq4/x23ZbY6QP+rD9Ri8nVGLrOuYj+dxnc/ubk3Yfi0av
         ACphm8gvbwhrEt6Xpc7VdLj6u8SLkKrO2a1Wv5s0YejhzmLg5C1WuaueFPtpoHnMk2
         SpVszJOfpjtbMDukuMMcUiAloOXTmS2RM3RnqIVuEWnlUPjdCzhtNTb+LIA6imIxwW
         t5L8kQJCAztVQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v8 RESEND 5/6] r8169: Use mutex to guard config register locking
Date:   Tue, 21 Feb 2023 10:38:48 +0800
Message-Id: <20230221023849.1906728-6-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
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

