Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A065380A4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiE3NxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiE3Nv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F6B21E09;
        Mon, 30 May 2022 06:36:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12F8060F81;
        Mon, 30 May 2022 13:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A53C385B8;
        Mon, 30 May 2022 13:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917796;
        bh=rQOzDbigvvxG6jMxeqztHkPaTTETYnr8ntAiHYX1pbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHD4hLwmAjRJv6R3nbyVU3Mk36b2fnDGot90q6y34Vei9hQQ8o3PqDbp9d+YyF0oo
         nDxIbuMmSimVCbUkE21UCSImgOK0vpfaUmRXbOV74/3TEZomHPgNUjtposQdn0aYgC
         brHAA00y6MQ6O4uklY9mi7axVn5RT47P2xLRbPE1KD8Xr75r2rgzeTicsZiPuOTTeD
         QjJ6E3Gahw9XYfavFSrAaXbgLQf/qltxNbpqNOKT+Lm814bjKVRLeXgyoxo/agICiG
         1trLM+h488MKHacuUdCyoyA+hmXpPcf5jx+Qq26fDz6Yym+IWrVXTMnbgVaFn9cq7E
         PcRq9vyb0nf3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 100/135] Bluetooth: HCI: Add HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk
Date:   Mon, 30 May 2022 09:30:58 -0400
Message-Id: <20220530133133.1931716-100-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 05abad857277dda198063017b00ba5b9fed2c0cb ]

This adds HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN quirk which can be
used to mark HCI_Enhanced_Setup_Synchronous_Connection as broken even
if its support command bit are set since some controller report it as
supported but the command don't work properly with some configurations
(e.g. BT_VOICE_TRANSPARENT/mSBC).

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 9 +++++++++
 include/net/bluetooth/hci_core.h | 8 ++++++--
 net/bluetooth/hci_conn.c         | 2 +-
 net/bluetooth/sco.c              | 2 +-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 69ef31cea582..62a9bb022aed 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -265,6 +265,15 @@ enum {
 	 * runtime suspend, because event filtering takes place there.
 	 */
 	HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL,
+
+	/*
+	 * When this quirk is set, disables the use of
+	 * HCI_OP_ENHANCED_SETUP_SYNC_CONN command to setup SCO connections.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 131514913430..49a88b2f4678 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1483,8 +1483,12 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define privacy_mode_capable(dev) (use_ll_privacy(dev) && \
 				   (hdev->commands[39] & 0x04))
 
-/* Use enhanced synchronous connection if command is supported */
-#define enhanced_sco_capable(dev) ((dev)->commands[29] & 0x08)
+/* Use enhanced synchronous connection if command is supported and its quirk
+ * has not been set.
+ */
+#define enhanced_sync_conn_capable(dev) \
+	(((dev)->commands[29] & 0x08) && \
+	 !test_bit(HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN, &(dev)->quirks))
 
 /* Use ext scanning if set ext scan param and ext scan enable is supported */
 #define use_ext_scan(dev) (((dev)->commands[37] & 0x20) && \
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 84312c836549..cd51bf2a709b 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -481,7 +481,7 @@ static bool hci_setup_sync_conn(struct hci_conn *conn, __u16 handle)
 
 bool hci_setup_sync(struct hci_conn *conn, __u16 handle)
 {
-	if (enhanced_sco_capable(conn->hdev))
+	if (enhanced_sync_conn_capable(conn->hdev))
 		return hci_enhanced_setup_sync_conn(conn, handle);
 
 	return hci_setup_sync_conn(conn, handle);
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8eabf41b2993..2a58c7d88433 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -885,7 +885,7 @@ static int sco_sock_setsockopt(struct socket *sock, int level, int optname,
 			err = -EBADFD;
 			break;
 		}
-		if (enhanced_sco_capable(hdev) &&
+		if (enhanced_sync_conn_capable(hdev) &&
 		    voice.setting == BT_VOICE_TRANSPARENT)
 			sco_pi(sk)->codec.id = BT_CODEC_TRANSPARENT;
 		hci_dev_put(hdev);
-- 
2.35.1

