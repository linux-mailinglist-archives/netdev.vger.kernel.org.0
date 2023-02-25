Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2642F6A2725
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 04:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBYDsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 22:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjBYDs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 22:48:28 -0500
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B92168AB;
        Fri, 24 Feb 2023 19:48:04 -0800 (PST)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id BD6834218A;
        Sat, 25 Feb 2023 03:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1677296883;
        bh=D9MK5fXeWpCA3lyK/IWtP54/AY1TUkcE/66hZyuxvaM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=uuhdtV/ABQExKT/89UnqXYvRRx8j3dMGgqz5ZcwvP2DOnB5rvV9ZKC7RBKylbgGkp
         5MrdoF84FrdRXHfK02utmO+IIXXpdxlxhzY+/aRis2T5kz9+mUkK38HzRhFiSkU1Ul
         L2St724XjGpBGvGAqv8OGEVzBfLt/kgfUZ6VhyijWINDVJa7ShisT/BewKLKdIoQHz
         S/gKD/iCuK0Q2qJDtVia1Zu9H409iFk/mNCxqQ5m7esBqvWJRBMz417r7+ClCLfHAt
         iFo55j7aFwQrzlWbUeIHpUSXXHzJ+Iw6CYXoPX+UMKDZtVRv7gEesFPdO+OZS9WZju
         rM2RZZICuZQbA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH net-next v9 5/5] r8169: Disable ASPM while doing NAPI poll
Date:   Sat, 25 Feb 2023 11:46:35 +0800
Message-Id: <20230225034635.2220386-6-kai.heng.feng@canonical.com>
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

NAPI poll of Realtek NICs don't seem to perform well ASPM is enabled.
The vendor driver uses a mechanism called "dynamic ASPM" to toggle ASPM
based on the packet number in given time period.

Instead of implementing "dynamic ASPM", use a more straightforward way
by disabling ASPM during NAPI poll, as a similar approach was
implemented to solve slow performance on Realtek wireless NIC, see
commit 24f5e38a13b5 ("rtw88: Disable PCIe ASPM while doing NAPI poll on
8821CE").

Since NAPI poll should be handled as fast as possible, also remove the
delay in rtl_hw_aspm_clkreq_enable() which was added by commit
94235460f9eaef ("r8169: Align ASPM/CLKREQ setting function with vendor
driver").

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v9:
 - No change.

v8:
 - New patch.

 drivers/net/ethernet/realtek/r8169_main.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fb73b5386701f..4e874fa661852 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2711,8 +2711,6 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
 	}
-
-	udelay(10);
 }
 
 static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
@@ -4577,6 +4575,12 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	struct net_device *dev = tp->dev;
 	int work_done;
 
+	if (tp->aspm_manageable) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, false);
+		rtl_lock_config_regs(tp);
+	}
+
 	rtl_tx(dev, tp, budget);
 
 	work_done = rtl_rx(dev, tp, budget);
@@ -4584,6 +4588,12 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget && napi_complete_done(napi, work_done))
 		rtl_irq_enable(tp);
 
+	if (tp->aspm_manageable) {
+		rtl_unlock_config_regs(tp);
+		rtl_hw_aspm_clkreq_enable(tp, true);
+		rtl_lock_config_regs(tp);
+	}
+
 	return work_done;
 }
 
-- 
2.34.1

