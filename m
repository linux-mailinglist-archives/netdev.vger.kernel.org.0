Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCCF679586
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjAXKnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjAXKnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:43:00 -0500
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C3CEF82;
        Tue, 24 Jan 2023 02:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=Content-Transfer-Encoding:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:Reply-To:Content-ID:Content-Description:
        In-Reply-To:References; bh=+94z0GDF0YwFoOENdLk8LueRV02gPpcPCokC9qXRlYg=; b=Xj
        I+/zScQTaOW1cJeIgcHY/CCrH9KKVg6mvlJpEDP0rxHzGTvFbWTw5Y2ZM1+Iq+Xy6Zh4UG7EmG27w
        cpbYZXECiVdWynbzF815ZKgnHXEETp1FMyaeha8LYmPBKaaYIdVM/YyXRrt3B7K7ZCxmCCihA0APV
        jK/n8mUQRh0qZuG/ApKp8K4cRIkuGEZB6zQEF+y/BLyQt8eVas716louM66kUTkUAZDCvMKmXHQS3
        GD9FFykFFd6H/CrbFqYuqae/pm8TWHaXNmqPOeJYqCJjGnLeuUVQ1oOIbOiE0zMbpSMTRB+aJBgZg
        qeXqRUSRq6wfpJ2GKP7mHcRJD9vfPiJA==;
Received: from [81.174.171.191] (helo=donbot.metanate.com)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <john@metanate.com>)
        id 1pKGlS-0008HV-J2;
        Tue, 24 Jan 2023 10:42:54 +0000
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
Subject: [PATCH v2] brcmfmac: support CQM RSSI notification with older firmware
Date:   Tue, 24 Jan 2023 10:42:48 +0000
Message-Id: <20230124104248.2917465-1-john@metanate.com>
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
v2:
- Cast to __be32* to fix a Sparse warning (kernel test robot)

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b115902eb475..43dc0faee92d 100644
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
+		rssi = be32_to_cpu(*(__be32 *)data);
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

