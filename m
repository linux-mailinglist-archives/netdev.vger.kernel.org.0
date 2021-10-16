Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7954301D1
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 12:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbhJPKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 06:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244041AbhJPKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 06:20:23 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CFBC061570;
        Sat, 16 Oct 2021 03:18:15 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [80.241.60.245])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4HWfGs3JNWzQjBM;
        Sat, 16 Oct 2021 12:18:13 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4/4] mwifiex: Send DELBA requests according to spec
Date:   Sat, 16 Oct 2021 12:17:43 +0200
Message-Id: <20211016101743.15565-5-verdre@v0yd.nl>
In-Reply-To: <20211016101743.15565-1-verdre@v0yd.nl>
References: <20211016101743.15565-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A3F926F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're currently failing to set the initiator bit for DELBA requests:
While we set the bit on our del_ba_param_set bitmask, we forget to
actually copy that bitmask over to the command struct, which means we
never actually set the initiator bit.

Fix that and copy the bitmask over to the host_cmd_ds_11n_delba command
struct.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index b0695432b26a..9ff2058bcd7e 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -657,14 +657,15 @@ int mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 	uint16_t del_ba_param_set;
 
 	memset(&delba, 0, sizeof(delba));
-	delba.del_ba_param_set = cpu_to_le16(tid << DELBA_TID_POS);
 
-	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
+	del_ba_param_set = tid << DELBA_TID_POS;
+
 	if (initiator)
 		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 	else
 		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 
+	delba.del_ba_param_set = cpu_to_le16(del_ba_param_set);
 	memcpy(&delba.peer_mac_addr, peer_mac, ETH_ALEN);
 
 	/* We don't wait for the response of this command */
-- 
2.31.1

