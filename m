Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4042C28F0CC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgJOLQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJOLQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:16:45 -0400
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3611C061755;
        Thu, 15 Oct 2020 04:16:44 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4CBmvD5tJkz1sKwV;
        Thu, 15 Oct 2020 13:16:37 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4CBmv95DK9z1qrg8;
        Thu, 15 Oct 2020 13:16:37 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id OLsXCAXsHmhb; Thu, 15 Oct 2020 13:16:35 +0200 (CEST)
X-Auth-Info: k0ZyYsDVmrX4DrH1M24vgA5atTsx5U5lcEFJ6aD+EcU=
Received: from localhost.localdomain (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 15 Oct 2020 13:16:35 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH] rsi: Fix TX EAPOL packet handling against iwlwifi AP
Date:   Thu, 15 Oct 2020 13:16:16 +0200
Message-Id: <20201015111616.429220-1-marex@denx.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in AP mode,
the association fails. The former is using wpa_supplicant during association,
the later is set up using hostapd:

iwl$ cat hostapd.conf
interface=wlp1s0
ssid=test
country_code=DE
hw_mode=g
channel=1
wpa=2
wpa_passphrase=test
wpa_key_mgmt=WPA-PSK
iwl$ hostapd -d hostapd.conf

rsi$ wpa_supplicant -i wlan0 -c <(wpa_passphrase test test)

The problem is that the TX EAPOL data descriptor RSI_DESC_REQUIRE_CFM_TO_HOST
flag and extended descriptor EAPOL4_CONFIRM frame type are not set in case the
AP is iwlwifi, because in that case the TX EAPOL packet is 2 bytes shorter.

The downstream vendor driver has this change in place already [1], however
there is no explanation for it, neither is there any commit history from which
such explanation could be obtained.

[1] https://github.com/SiliconLabs/RS911X-nLink-OSD/blob/master/rsi/rsi_91x_hal.c#L238

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 3f7e3cfb6f00..ce9892152f4d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -248,7 +248,8 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 			rsi_set_len_qno(&data_desc->len_qno,
 					(skb->len - FRAME_DESC_SZ),
 					RSI_WIFI_MGMT_Q);
-		if ((skb->len - header_size) == EAPOL4_PACKET_LEN) {
+		if (((skb->len - header_size) == EAPOL4_PACKET_LEN) ||
+		    ((skb->len - header_size) == EAPOL4_PACKET_LEN - 2)) {
 			data_desc->misc_flags |=
 				RSI_DESC_REQUIRE_CFM_TO_HOST;
 			xtend_desc->confirm_frame_type = EAPOL4_CONFIRM;
-- 
2.28.0

