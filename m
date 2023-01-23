Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4E677A66
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjAWL5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjAWL5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:57:39 -0500
X-Greylist: delayed 1082 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 23 Jan 2023 03:57:38 PST
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491D3113FD
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 03:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=Content-Transfer-Encoding:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:Reply-To:Content-ID:Content-Description:
        In-Reply-To:References; bh=gPxeHE23tzwpVy1+JbNy/k0yRKOwiVwjSX5YR1hlEhU=; b=QB
        O71gvsjUeB7TTHvlyWZCof0gz/oq/yce3G7IQAH6VXHM7Ng5tL8uI6LDHhfP3wp+oEgZ6MUs2gbEW
        R5JhaZjKHQHzLYa6NjfFyGNUUJREJ+WIfa3/NnRKWQyFvK0sFaIBAgessjJ6BuI8URfRlK67o+Gny
        Lxv+UzinU9f2fbUvAw5LaXoMeaQBuCmHXcSP75qlQDY/ecSKfz7EV7lkxWkIIk2hr/mw8rrUmj5Lx
        1xAaUPv529iYjf0R8SKuXNAg+i4qhetgUGmjiPnPDkcqRhpNfD/vAbaBZFcwiXuczre6lJyBGopgr
        nNUmSc8lqWb3PJenNjqP3rc9qFAznzng==;
Received: from [81.174.171.191] (helo=donbot.metanate.com)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <john@metanate.com>)
        id 1pJvAg-0003Qc-CB;
        Mon, 23 Jan 2023 11:39:30 +0000
From:   John Keeping <john@metanate.com>
To:     netdev@vger.kernel.org
Cc:     John Keeping <john@metanate.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: support CQM RSSI notification with older firmware
Date:   Mon, 23 Jan 2023 11:39:24 +0000
Message-Id: <20230123113924.2472721-1-john@metanate.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated: YES
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the BCM4339 firmware from linux-firmware (version "BCM4339/2 wl0:
Sep  5 2019 11:05:52 version 6.37.39.113 (r722271 CY)" from
cypress/cyfmac4339-sdio.bin) the RSSI respose is only 4 bytes, which
results in an error being logged.

It seems that older devices send only the RSSI field and neither SNR nor
noise is included.  Handle this by accepting a 4 byte message and
reading only the RSSI from it.

Fixes: 7dd56ea45a66 ("brcmfmac: add support for CQM RSSI notifications")
Signed-off-by: John Keeping <john@metanate.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b115902eb475..7dbb6f07d067 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6489,18 +6489,20 @@ static s32 brcmf_notify_rssi(struct brcmf_if *ifp,
 {
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	struct brcmf_rssi_be *info = data;
-	s32 rssi, snr, noise;
+	s32 rssi, snr = 0, noise = 0;
 	s32 low, high, last;
 
-	if (e->datalen < sizeof(*info)) {
+	if (e->datalen >= sizeof(*info)) {
+		rssi = be32_to_cpu(info->rssi);
+		snr = be32_to_cpu(info->snr);
+		noise = be32_to_cpu(info->noise);
+	} else if (e->datalen >= sizeof(rssi)) {
+		rssi = be32_to_cpu(*(s32 *)data);
+	} else {
 		brcmf_err("insufficient RSSI event data\n");
 		return 0;
 	}
 
-	rssi = be32_to_cpu(info->rssi);
-	snr = be32_to_cpu(info->snr);
-	noise = be32_to_cpu(info->noise);
-
 	low = vif->cqm_rssi_low;
 	high = vif->cqm_rssi_high;
 	last = vif->cqm_rssi_last;
-- 
2.39.1

