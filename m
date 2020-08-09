Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220523FD8F
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 11:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgHIJ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 05:29:19 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:53541 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgHIJ3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 05:29:16 -0400
Received: from localhost.localdomain ([93.22.150.139])
        by mwinf5d05 with ME
        id DMV72300G30hzCV03MV8BZ; Sun, 09 Aug 2020 11:29:14 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 09 Aug 2020 11:29:14 +0200
X-ME-IP: 93.22.150.139
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, yogeshp@marvell.com, bzhao@marvell.com,
        linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] mwifiex: Do not use GFP_KERNEL in atomic context
Date:   Sun,  9 Aug 2020 11:29:06 +0200
Message-Id: <20200809092906.744621-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A possible call chain is as follow:
  mwifiex_sdio_interrupt                            (sdio.c)
    --> mwifiex_main_process                        (main.c)
      --> mwifiex_process_cmdresp                   (cmdevt.c)
        --> mwifiex_process_sta_cmdresp             (sta_cmdresp.c)
          --> mwifiex_ret_802_11_scan               (scan.c)
            --> mwifiex_parse_single_response_buf   (scan.c)

'mwifiex_sdio_interrupt()' is an interrupt function.

Also note that 'mwifiex_ret_802_11_scan()' already uses GFP_ATOMIC.

So use GFP_ATOMIC instead of GFP_KERNEL when memory is allocated in
'mwifiex_parse_single_response_buf()'.

Fixes: 7c6fa2a843c5 ("mwifiex: use cfg80211 dynamic scan table and cfg80211_get_bss API")
or
Fixes: 601216e12c65e ("mwifiex: process RX packets in SDIO IRQ thread directly")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This is completely speculative. I don't know if the call chain given above
if possible in RL application.
So review carefully :)

I'm not sure of the Fixes tag. If I'm correct:
 - The first one is when the GFP_KERNEL has been introduced.
 - the 2nd one is when some logic has been changed to call interrupt
   handler directly instead of existing workqueue

Note that if my analysis is completely broken, it is likely that
'mwifiex_ret_802_11_scan()' could use GFP_KERNEL in order to relax some
memory allocation constrains.
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index ff932627a46c..2fb69a590bd8 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1889,7 +1889,7 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 					    chan, CFG80211_BSS_FTYPE_UNKNOWN,
 					    bssid, timestamp,
 					    cap_info_bitmap, beacon_period,
-					    ie_buf, ie_len, rssi, GFP_KERNEL);
+					    ie_buf, ie_len, rssi, GFP_ATOMIC);
 			if (bss) {
 				bss_priv = (struct mwifiex_bss_priv *)bss->priv;
 				bss_priv->band = band;
-- 
2.25.1

