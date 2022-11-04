Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF64619D58
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiKDQd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiKDQd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:33:57 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FB72715B;
        Fri,  4 Nov 2022 09:33:55 -0700 (PDT)
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A759F85255;
        Fri,  4 Nov 2022 17:33:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667579633;
        bh=qtep8Eq+FCsp4JjBidQAgnyXf/LI5Ei8jICPLyoJA9s=;
        h=From:To:Cc:Subject:Date:From;
        b=G42l8/2yXPYqFYjUUwm0F8giIKjoZFzVfD1cm/9R0C4FGEHh5YvNrqh4WTrZs0X69
         188nTDtq8TQL3Oc+ksQXkZ593ednSsuLhsZyBUcdfeJ3KK1WSZ8FZepv81O6Kp885I
         ASR/NU/okssUYCOBTk6ypgpv3+PYnETAHlI+Q+mGBYRuolnKXblsf7BW3qhsYkG7dA
         asrdEeumBP/f2RpDpJ3BBIyXXD7BRaWww8P6bvzpmaULrqyrxmTAGBW1n/Tkl7ccFw
         hJ2HZy33IC66k0JSzsUahh2FRfzsgyZ9BZOdjE53gJBa47/zj9AI9JaoC3JWC5dgRp
         V/iWu0I8Spx4Q==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
Date:   Fri,  4 Nov 2022 17:33:39 +0100
Message-Id: <20221104163339.227432-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using wpa_supplicant v2.10, this driver is no longer able to
associate with any AP and fails in the EAPOL 4-way handshake while
sending the 2/4 message to the AP. The problem is not present in
wpa_supplicant v2.9 or older. The problem stems from HostAP commit
144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
which changes the way EAPOL frames are sent, from them being send
at L2 frames to them being sent via nl80211 control port.

An EAPOL frame sent as L2 frame is passed to the WiFi driver with
skb->protocol ETH_P_PAE, while EAPOL frame sent via nl80211 control
port has skb->protocol set to ETH_P_802_3 . The later happens in
ieee80211_tx_control_port(), where the EAPOL frame is encapsulated
into 802.3 frame.

The rsi_91x driver handles ETH_P_PAE EAPOL frames as high-priority
frames and sends them via highest-priority transmit queue, while
the ETH_P_802_3 frames are sent as regular frames. The EAPOL 4-way
handshake frames must be sent as highest-priority, otherwise the
4-way handshake times out.

Therefore, to fix this problem, inspect the skb control flags and
if flag IEEE80211_TX_CTRL_PORT_CTRL_PROTO is set, assume this is
an EAPOL frame and transmit the frame via high-priority queue just
like other ETH_P_PAE frames.

Fixes: 0eb42586cf87 ("rsi: data packet descriptor enhancements")
Signed-off-by: Marek Vasut <marex@denx.de>
---
NOTE: I am really unsure about the method of finding out the exact
      place of ethernet header in the encapsulated packet and then
      extracting the ethertype from it. Is there maybe some sort of
      helper function for that purpose ?
---
V2: - Turn the duplicated code into common function
V3: - Simplify the TX EAPOL detection (Johannes)
V4: - Drop the double !!() from test
    - Update commit message
V5: - Inline the rsi_is_tx_eapol() again, undoes V2 change completely
---
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 4 +++-
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 6 +++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 0f3a80f66b61c..ead4d4e043280 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -466,7 +466,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 							      tid, 0);
 			}
 		}
-		if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+
+		if (IEEE80211_SKB_CB(skb)->control.flags &
+		    IEEE80211_TX_CTRL_PORT_CTRL_PROTO) {
 			q_num = MGMT_SOFT_Q;
 			skb->priority = q_num;
 		}
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index c61f83a7333b6..c7460fbba0142 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -162,12 +162,16 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	u8 header_size;
 	u8 vap_id = 0;
 	u8 dword_align_bytes;
+	bool tx_eapol;
 	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
 	vif = info->control.vif;
 	tx_params = (struct skb_info *)info->driver_data;
 
+	tx_eapol = IEEE80211_SKB_CB(skb)->control.flags &
+		   IEEE80211_TX_CTRL_PORT_CTRL_PROTO;
+
 	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
@@ -231,7 +235,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		}
 	}
 
-	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+	if (tx_eapol) {
 		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");
 
 		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
-- 
2.35.1

