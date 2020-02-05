Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561981538F0
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 20:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBETVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 14:21:35 -0500
Received: from mail.aperture-lab.de ([138.201.29.205]:46520 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgBETVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 14:21:35 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2020 14:21:34 EST
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c0d3.blue; s=2018;
        t=1580929879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oR8zVIyJPPLtcbIaEesyxlzKUGtwe37C23vEgBL6VjQ=;
        b=f2/oKsD4u8CWbuveyA+cr1Cn3MuN6+uYKh6gv0Nm07gzKgM/MtcCWQnbFIJFD2IxP/XjUd
        PIAUqa2WGyb1TD4CIaiLYWX6g7erH1gWMuPB2gj6USmG3GyKOJZDUxObIqpIEh7NzciYm+
        vNKiq04a4eUoRcbQTzDbgmjwoicaozyZ/YUrgrMiCKcfLZBdwjyWPrYtDTutj6F/7LM4fT
        aLVvuS6RSoBiQQEpUM5o8gKk3d+duyqJDfwfsp01aieu7AHNA7x+61wPfewyTfqgbWsESM
        lu9byc5nx1ai+ELzeE6iUYnVYG5/LF001YWdEICVhkKe/l7YvG/ZhW6wldblDg==
To:     ath10k@lists.infradead.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH] ath10k: increase rx buffer size to 2048
Date:   Wed,  5 Feb 2020 20:10:43 +0100
Message-Id: <20200205191043.21913-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=linus.luessing@c0d3.blue smtp.mailfrom=linus.luessing@c0d3.blue
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

Before, only frames with a maximum size of 1528 bytes could be
transmitted between two 802.11s nodes.

For batman-adv for instance, which adds its own header to each frame,
we typically need an MTU of at least 1532 bytes to be able to transmit
without fragmentation.

This patch now increases the maxmimum frame size from 1528 to 1656
bytes.

Tested with two ath10k devices in 802.11s mode, as well as with
batman-adv on top of 802.11s with forwarding disabled.

Fix originally found and developed by Ben Greear.

Link: https://github.com/greearb/ath10k-ct/issues/89
Link: https://github.com/greearb/ath10k-ct/commit/9e5ab25027e0971fa24ccf93373324c08c4e992d
Cc: Ben Greear <greearb@candelatech.com>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath10k/htt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 4a12564fc30e..6a2b5e10e568 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -2220,7 +2220,7 @@ struct htt_rx_chan_info {
  * Should be: sizeof(struct htt_host_rx_desc) + max rx MSDU size,
  * rounded up to a cache line size.
  */
-#define HTT_RX_BUF_SIZE 1920
+#define HTT_RX_BUF_SIZE 2048
 #define HTT_RX_MSDU_SIZE (HTT_RX_BUF_SIZE - (int)sizeof(struct htt_rx_desc))
 
 /* Refill a bunch of RX buffers for each refill round so that FW/HW can handle
-- 
2.25.0

