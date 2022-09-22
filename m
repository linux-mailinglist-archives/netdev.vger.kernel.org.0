Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8285E6D0B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 22:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIVUdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 16:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIVUdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 16:33:06 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C965C109527;
        Thu, 22 Sep 2022 13:33:04 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.bb.vodafone.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8244284CE6;
        Thu, 22 Sep 2022 22:33:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1663878782;
        bh=bXfsTMGZaSNqpJdq4s5fnFzwsg6OYsSk6mibwNOPgWg=;
        h=From:To:Cc:Subject:Date:From;
        b=tFOvkq+XJ9sdPRucke8xW3jesXeEg/pMbs1xCc+MCugjUlw056uzVV2OKlOyBZM0e
         Y6XnH+mP7CHghFhrCTYIpH5/t7qrxWS2MYAmAQpTZsmOBmy9OLYMIxqsg2QqdSIlPj
         rPHz9FEy9QA9A2MWkKu0MENCHtoE3nLUkx7iRXKfif5eny3K5eQ5Gp1mT112N0GP0S
         U39Hz4UVo+jyC3M3OQgtkBATx9iPTtGH6VexWcUHIXY2Qig+fYFRTUJXZpONds7xYn
         sglOe4UnjX4FoP81kkSwADs7fqVVXuJJhQUIGKXVuEcNhDTpymHLzt9gU94oLYmpig
         461PMbptaZoyw==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
Date:   Thu, 22 Sep 2022 22:32:40 +0200
Message-Id: <20220922203240.108623-1-marex@denx.de>
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

Therefore, to fix this problem, inspect the ETH_P_802_3 frames in
the rsi_91x driver, check the ethertype of the encapsulated frame,
and in case it is ETH_P_PAE, transmit the frame via high-priority
queue just like other ETH_P_PAE frames.

Fixes: 0eb42586cf876 ("rsi: data packet descriptor enhancements")
Signed-off-by: Marek Vasut <marex@denx.de>
---
NOTE: I am really unsure about the method of finding out the exact
      place of ethernet header in the encapsulated packet and then
      extracting the ethertype from it. Is there maybe some sort of
      helper function for that purpose ?
---
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 14 ++++++++++++++
 drivers/net/wireless/rsi/rsi_91x_hal.c  | 15 ++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 0f3a80f66b61c..d76c9dc99cafa 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -380,6 +380,9 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_vif *vif;
 	u8 q_num, tid = 0;
 	struct rsi_sta *rsta = NULL;
+	struct ethhdr *eth_hdr;
+	bool tx_eapol = false;
+	unsigned int hdr_len;
 
 	if ((!skb) || (!skb->len)) {
 		rsi_dbg(ERR_ZONE, "%s: Null skb/zero Length packet\n",
@@ -466,7 +469,18 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 							      tid, 0);
 			}
 		}
+
 		if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+			tx_eapol = true;
+		} else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
+			hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
+				  sizeof(rfc1042_header) - ETH_HLEN + 2;
+			eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
+			if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
+				tx_eapol = true;
+		}
+
+		if (tx_eapol) {
 			q_num = MGMT_SOFT_Q;
 			skb->priority = q_num;
 		}
diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index c61f83a7333b6..d43754fff287d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -159,6 +159,9 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	struct rsi_data_desc *data_desc;
 	struct rsi_xtended_desc *xtend_desc;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
+	struct ethhdr *eth_hdr;
+	bool tx_eapol = false;
+	unsigned int hdr_len;
 	u8 header_size;
 	u8 vap_id = 0;
 	u8 dword_align_bytes;
@@ -168,6 +171,16 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 	vif = info->control.vif;
 	tx_params = (struct skb_info *)info->driver_data;
 
+	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+		tx_eapol = true;
+	} else if (skb->protocol == cpu_to_be16(ETH_P_802_3)) {
+		hdr_len = ieee80211_get_hdrlen_from_skb(skb) +
+			  sizeof(rfc1042_header) - ETH_HLEN + 2;
+		eth_hdr = (struct ethhdr *)(skb->data + hdr_len);
+		if (eth_hdr->h_proto == cpu_to_be16(ETH_P_PAE))
+			tx_eapol = true;
+	}
+
 	header_size = FRAME_DESC_SZ + sizeof(struct rsi_xtended_desc);
 	if (header_size > skb_headroom(skb)) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to send pkt\n", __func__);
@@ -231,7 +244,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		}
 	}
 
-	if (skb->protocol == cpu_to_be16(ETH_P_PAE)) {
+	if (tx_eapol) {
 		rsi_dbg(INFO_ZONE, "*** Tx EAPOL ***\n");
 
 		data_desc->frame_info = cpu_to_le16(RATE_INFO_ENABLE);
-- 
2.35.1

