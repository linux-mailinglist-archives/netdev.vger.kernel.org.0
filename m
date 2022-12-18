Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0D6501BA
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbiLRQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiLRQdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:33:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4552BB853;
        Sun, 18 Dec 2022 08:12:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5B5F60C99;
        Sun, 18 Dec 2022 16:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84D3C433F0;
        Sun, 18 Dec 2022 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379962;
        bh=V1iZjnY+Fu3/ryfiijjX5kukUbPZuFNdU84KcYkm+K4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFQZbEqNxfuPSDX72A5MknYA/LzfZ0EAEjAH+rDIAicGdSo4mzd5tXaKIUB24bH9Y
         9bwgVc0g/eiB0lcBmOFkXEpDX2XD+Dr8x467VvB63aSitu/nl6WXvtp/Hw55xBcVEz
         NAH3gToh+4YKMgHXv9iCJCWiCzCXwE5oB4pesIP+PdUJDvo22JrSE4tALH1AcpBLB0
         j+HfQH+sH979DiO+ATzFHhRxfENplJRFnlejoSvNIHtb0enWRxfpbtGhojUJSyEehq
         5wx00pGZH+EW7lm3s3cHQSaY6fZ9vZRBZPSG3XM0mUWkQU8kXuwSzwuDd77qlAOlmn
         +FV2dtlmVu24g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Peter <sven@svenpeter.dev>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 73/73] Bluetooth: Add quirk to disable MWS Transport Configuration
Date:   Sun, 18 Dec 2022 11:07:41 -0500
Message-Id: <20221218160741.927862-73-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit ffcb0a445ec2d5753751437706aa0a7ea8351099 ]

Broadcom 4378/4387 controllers found in Apple Silicon Macs claim to
support getting MWS Transport Layer Configuration,

< HCI Command: Read Local Supported... (0x04|0x0002) plen 0
> HCI Event: Command Complete (0x0e) plen 68
      Read Local Supported Commands (0x04|0x0002) ncmd 1
        Status: Success (0x00)
[...]
          Get MWS Transport Layer Configuration (Octet 30 - Bit 3)]
[...]

, but then don't actually allow the required command:

> HCI Event: Command Complete (0x0e) plen 15
      Get MWS Transport Layer Configuration (0x05|0x000c) ncmd 1
        Status: Command Disallowed (0x0c)
        Number of transports: 0
        Baud rate list: 0 entries
        00 00 00 00 00 00 00 00 00 00

Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci.h      | 10 ++++++++++
 include/net/bluetooth/hci_core.h |  3 +++
 net/bluetooth/hci_sync.c         |  2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 78c55b69919d..dd455ce06770 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -284,6 +284,16 @@ enum {
 	 * during the hdev->setup vendor callback.
 	 */
 	HCI_QUIRK_BROKEN_EXT_SCAN,
+
+	/*
+	 * When this quirk is set, the HCI_OP_GET_MWS_TRANSPORT_CONFIG command is
+	 * disabled. This is required for some Broadcom controllers which
+	 * erroneously claim to support MWS Transport Layer Configuration.
+	 *
+	 * This quirk can be set before hci_register_dev is called or
+	 * during the hdev->setup vendor callback.
+	 */
+	HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
 };
 
 /* HCI device flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 29d1254f9856..6afb4771ce35 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1711,6 +1711,9 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 	((dev)->le_features[3] & HCI_LE_CIS_PERIPHERAL)
 #define bis_capable(dev) ((dev)->le_features[3] & HCI_LE_ISO_BROADCASTER)
 
+#define mws_transport_config_capable(dev) (((dev)->commands[30] & 0x08) && \
+	(!test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &(dev)->quirks)))
+
 /* ----- HCI protocols ----- */
 #define HCI_PROTO_DEFER             0x01
 
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index a5e89e1b5452..117537f3e7ad 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3940,7 +3940,7 @@ static int hci_read_local_pairing_opts_sync(struct hci_dev *hdev)
 /* Get MWS transport configuration if the HCI command is supported */
 static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
 {
-	if (!(hdev->commands[30] & 0x08))
+	if (!mws_transport_config_capable(hdev))
 		return 0;
 
 	return __hci_cmd_sync_status(hdev, HCI_OP_GET_MWS_TRANSPORT_CONFIG,
-- 
2.35.1

