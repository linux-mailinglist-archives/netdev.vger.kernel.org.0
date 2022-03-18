Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACDB4DE180
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbiCRS6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240289AbiCRS60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:26 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0968242212;
        Fri, 18 Mar 2022 11:57:03 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E4BB7C000A;
        Fri, 18 Mar 2022 18:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UFZnOBz8aMFd1WbMsX/Uc7Fh6yQaXNfh+zd09Zt00t4=;
        b=GPyhJ/Yx4Z2RZixPM0pVC7CScxKahmMqd0r4yp6HE/wp5fk0Oys3ZyarC2MBRH80EsLMv9
        g9oZgQ1Dy23H1J0MrJPL7GZi0sRVk2PcRwFo3mfABhnjDAVHqM0FynWsvjcletuXk2Ggk/
        1MlPYWpKxx4VR8ZGksGXAMs/X5sbG8FKHddRteJTCQLWwhsP5Bcyh3fVo75v6BaW4kYgHE
        jCNYwIHNyYijIFC/zwlp+INs3l39wOzHypYd10d8jITdCfsSLaMvwgfCEQH9OeOsQB54gH
        uKjk0LAL0XHg/llC34rXDnj6Bht+g9wnSUiIboXkA9Z3RshuZcQQbQoAFvTTPQ==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v4 10/11] net: ieee802154: ca8210: Use core return codes instead of hardcoding them
Date:   Fri, 18 Mar 2022 19:56:43 +0100
Message-Id: <20220318185644.517164-11-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318185644.517164-1-miquel.raynal@bootlin.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All the error codes defined in this driver are generic and already
defined in the ieee802154 main header. Let's just get rid of these extra
definition and switch to the core's values.

There is no functional change.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 drivers/net/ieee802154/ca8210.c | 178 ++++++++++++--------------------
 1 file changed, 68 insertions(+), 110 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index fc74fa0f1ddd..116aece191cd 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -89,48 +89,6 @@
 #define CA8210_TEST_INT_FILE_NAME "ca8210_test"
 #define CA8210_TEST_INT_FIFO_SIZE 256
 
-/* MAC status enumerations */
-#define MAC_SUCCESS                     (0x00)
-#define MAC_ERROR                       (0x01)
-#define MAC_CANCELLED                   (0x02)
-#define MAC_READY_FOR_POLL              (0x03)
-#define MAC_COUNTER_ERROR               (0xDB)
-#define MAC_IMPROPER_KEY_TYPE           (0xDC)
-#define MAC_IMPROPER_SECURITY_LEVEL     (0xDD)
-#define MAC_UNSUPPORTED_LEGACY          (0xDE)
-#define MAC_UNSUPPORTED_SECURITY        (0xDF)
-#define MAC_BEACON_LOST                 (0xE0)
-#define MAC_CHANNEL_ACCESS_FAILURE      (0xE1)
-#define MAC_DENIED                      (0xE2)
-#define MAC_DISABLE_TRX_FAILURE         (0xE3)
-#define MAC_SECURITY_ERROR              (0xE4)
-#define MAC_FRAME_TOO_LONG              (0xE5)
-#define MAC_INVALID_GTS                 (0xE6)
-#define MAC_INVALID_HANDLE              (0xE7)
-#define MAC_INVALID_PARAMETER           (0xE8)
-#define MAC_NO_ACK                      (0xE9)
-#define MAC_NO_BEACON                   (0xEA)
-#define MAC_NO_DATA                     (0xEB)
-#define MAC_NO_SHORT_ADDRESS            (0xEC)
-#define MAC_OUT_OF_CAP                  (0xED)
-#define MAC_PAN_ID_CONFLICT             (0xEE)
-#define MAC_REALIGNMENT                 (0xEF)
-#define MAC_TRANSACTION_EXPIRED         (0xF0)
-#define MAC_TRANSACTION_OVERFLOW        (0xF1)
-#define MAC_TX_ACTIVE                   (0xF2)
-#define MAC_UNAVAILABLE_KEY             (0xF3)
-#define MAC_UNSUPPORTED_ATTRIBUTE       (0xF4)
-#define MAC_INVALID_ADDRESS             (0xF5)
-#define MAC_ON_TIME_TOO_LONG            (0xF6)
-#define MAC_PAST_TIME                   (0xF7)
-#define MAC_TRACKING_OFF                (0xF8)
-#define MAC_INVALID_INDEX               (0xF9)
-#define MAC_LIMIT_REACHED               (0xFA)
-#define MAC_READ_ONLY                   (0xFB)
-#define MAC_SCAN_IN_PROGRESS            (0xFC)
-#define MAC_SUPERFRAME_OVERLAP          (0xFD)
-#define MAC_SYSTEM_ERROR                (0xFF)
-
 /* HWME attribute IDs */
 #define HWME_EDTHRESHOLD       (0x04)
 #define HWME_EDVALUE           (0x06)
@@ -551,58 +509,58 @@ static int link_to_linux_err(int link_status)
 		return link_status;
 	}
 	switch (link_status) {
-	case MAC_SUCCESS:
-	case MAC_REALIGNMENT:
+	case IEEE802154_SUCCESS:
+	case IEEE802154_REALIGNMENT:
 		return 0;
-	case MAC_IMPROPER_KEY_TYPE:
+	case IEEE802154_IMPROPER_KEY_TYPE:
 		return -EKEYREJECTED;
-	case MAC_IMPROPER_SECURITY_LEVEL:
-	case MAC_UNSUPPORTED_LEGACY:
-	case MAC_DENIED:
+	case IEEE802154_IMPROPER_SECURITY_LEVEL:
+	case IEEE802154_UNSUPPORTED_LEGACY:
+	case IEEE802154_DENIED:
 		return -EACCES;
-	case MAC_BEACON_LOST:
-	case MAC_NO_ACK:
-	case MAC_NO_BEACON:
+	case IEEE802154_BEACON_LOST:
+	case IEEE802154_NO_ACK:
+	case IEEE802154_NO_BEACON:
 		return -ENETUNREACH;
-	case MAC_CHANNEL_ACCESS_FAILURE:
-	case MAC_TX_ACTIVE:
-	case MAC_SCAN_IN_PROGRESS:
+	case IEEE802154_CHANNEL_ACCESS_FAILURE:
+	case IEEE802154_TX_ACTIVE:
+	case IEEE802154_SCAN_IN_PROGRESS:
 		return -EBUSY;
-	case MAC_DISABLE_TRX_FAILURE:
-	case MAC_OUT_OF_CAP:
+	case IEEE802154_DISABLE_TRX_FAILURE:
+	case IEEE802154_OUT_OF_CAP:
 		return -EAGAIN;
-	case MAC_FRAME_TOO_LONG:
+	case IEEE802154_FRAME_TOO_LONG:
 		return -EMSGSIZE;
-	case MAC_INVALID_GTS:
-	case MAC_PAST_TIME:
+	case IEEE802154_INVALID_GTS:
+	case IEEE802154_PAST_TIME:
 		return -EBADSLT;
-	case MAC_INVALID_HANDLE:
+	case IEEE802154_INVALID_HANDLE:
 		return -EBADMSG;
-	case MAC_INVALID_PARAMETER:
-	case MAC_UNSUPPORTED_ATTRIBUTE:
-	case MAC_ON_TIME_TOO_LONG:
-	case MAC_INVALID_INDEX:
+	case IEEE802154_INVALID_PARAMETER:
+	case IEEE802154_UNSUPPORTED_ATTRIBUTE:
+	case IEEE802154_ON_TIME_TOO_LONG:
+	case IEEE802154_INVALID_INDEX:
 		return -EINVAL;
-	case MAC_NO_DATA:
+	case IEEE802154_NO_DATA:
 		return -ENODATA;
-	case MAC_NO_SHORT_ADDRESS:
+	case IEEE802154_NO_SHORT_ADDRESS:
 		return -EFAULT;
-	case MAC_PAN_ID_CONFLICT:
+	case IEEE802154_PAN_ID_CONFLICT:
 		return -EADDRINUSE;
-	case MAC_TRANSACTION_EXPIRED:
+	case IEEE802154_TRANSACTION_EXPIRED:
 		return -ETIME;
-	case MAC_TRANSACTION_OVERFLOW:
+	case IEEE802154_TRANSACTION_OVERFLOW:
 		return -ENOBUFS;
-	case MAC_UNAVAILABLE_KEY:
+	case IEEE802154_UNAVAILABLE_KEY:
 		return -ENOKEY;
-	case MAC_INVALID_ADDRESS:
+	case IEEE802154_INVALID_ADDRESS:
 		return -ENXIO;
-	case MAC_TRACKING_OFF:
-	case MAC_SUPERFRAME_OVERLAP:
+	case IEEE802154_TRACKING_OFF:
+	case IEEE802154_SUPERFRAME_OVERLAP:
 		return -EREMOTEIO;
-	case MAC_LIMIT_REACHED:
+	case IEEE802154_LIMIT_REACHED:
 		return -EDQUOT;
-	case MAC_READ_ONLY:
+	case IEEE802154_READ_ONLY:
 		return -EROFS;
 	default:
 		return -EPROTO;
@@ -754,7 +712,7 @@ static void ca8210_rx_done(struct cas_control *cas_ctl)
 
 	ca8210_net_rx(priv->hw, buf, len);
 	if (buf[0] == SPI_MCPS_DATA_CONFIRM) {
-		if (buf[3] == MAC_TRANSACTION_OVERFLOW) {
+		if (buf[3] == IEEE802154_TRANSACTION_OVERFLOW) {
 			dev_info(
 				&priv->spi->dev,
 				"Waiting for transaction overflow to stabilise...\n");
@@ -1128,7 +1086,7 @@ static u8 tdme_setsfr_request_sync(
 	);
 	if (ret) {
 		dev_crit(&spi->dev, "cascoda_api_downstream returned %d", ret);
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	if (response.command_id != SPI_TDME_SETSFR_CONFIRM) {
@@ -1137,7 +1095,7 @@ static u8 tdme_setsfr_request_sync(
 			"sync response to SPI_TDME_SETSFR_REQUEST was not SPI_TDME_SETSFR_CONFIRM, it was %d\n",
 			response.command_id
 		);
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	return response.pdata.tdme_set_sfr_cnf.status;
@@ -1151,7 +1109,7 @@ static u8 tdme_setsfr_request_sync(
  */
 static u8 tdme_chipinit(void *device_ref)
 {
-	u8 status = MAC_SUCCESS;
+	u8 status = IEEE802154_SUCCESS;
 	u8 sfr_address;
 	struct spi_device *spi = device_ref;
 	struct preamble_cfg_sfr pre_cfg_value = {
@@ -1220,7 +1178,7 @@ static u8 tdme_chipinit(void *device_ref)
 		goto finish;
 
 finish:
-	if (status != MAC_SUCCESS) {
+	if (status != IEEE802154_SUCCESS) {
 		dev_err(
 			&spi->dev,
 			"failed to set sfr at %#03x, status = %#03x\n",
@@ -1287,7 +1245,7 @@ static u8 tdme_checkpibattribute(
 	const void   *pib_attribute_value
 )
 {
-	u8 status = MAC_SUCCESS;
+	u8 status = IEEE802154_SUCCESS;
 	u8 value;
 
 	value  = *((u8 *)pib_attribute_value);
@@ -1296,52 +1254,52 @@ static u8 tdme_checkpibattribute(
 	/* PHY */
 	case PHY_TRANSMIT_POWER:
 		if (value > 0x3F)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case PHY_CCA_MODE:
 		if (value > 0x03)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	/* MAC */
 	case MAC_BATT_LIFE_EXT_PERIODS:
 		if (value < 6 || value > 41)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_BEACON_PAYLOAD:
 		if (pib_attribute_length > MAX_BEACON_PAYLOAD_LENGTH)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_BEACON_PAYLOAD_LENGTH:
 		if (value > MAX_BEACON_PAYLOAD_LENGTH)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_BEACON_ORDER:
 		if (value > 15)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_MAX_BE:
 		if (value < 3 || value > 8)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_MAX_CSMA_BACKOFFS:
 		if (value > 5)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_MAX_FRAME_RETRIES:
 		if (value > 7)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_MIN_BE:
 		if (value > 8)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_RESPONSE_WAIT_TIME:
 		if (value < 2 || value > 64)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_SUPERFRAME_ORDER:
 		if (value > 15)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	/* boolean */
 	case MAC_ASSOCIATED_PAN_COORD:
@@ -1353,16 +1311,16 @@ static u8 tdme_checkpibattribute(
 	case MAC_RX_ON_WHEN_IDLE:
 	case MAC_SECURITY_ENABLED:
 		if (value > 1)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	/* MAC SEC */
 	case MAC_AUTO_REQUEST_SECURITY_LEVEL:
 		if (value > 7)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	case MAC_AUTO_REQUEST_KEY_ID_MODE:
 		if (value > 3)
-			status = MAC_INVALID_PARAMETER;
+			status = IEEE802154_INVALID_PARAMETER;
 		break;
 	default:
 		break;
@@ -1522,9 +1480,9 @@ static u8 mcps_data_request(
 
 	if (ca8210_spi_transfer(device_ref, &command.command_id,
 				command.length + 2))
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 
-	return MAC_SUCCESS;
+	return IEEE802154_SUCCESS;
 }
 
 /**
@@ -1553,11 +1511,11 @@ static u8 mlme_reset_request_sync(
 		&response.command_id,
 		device_ref)) {
 		dev_err(&spi->dev, "cascoda_api_downstream failed\n");
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	if (response.command_id != SPI_MLME_RESET_CONFIRM)
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 
 	status = response.pdata.status;
 
@@ -1600,7 +1558,7 @@ static u8 mlme_set_request_sync(
 	 */
 	if (tdme_checkpibattribute(
 		pib_attribute, pib_attribute_length, pib_attribute_value)) {
-		return MAC_INVALID_PARAMETER;
+		return IEEE802154_INVALID_PARAMETER;
 	}
 
 	if (pib_attribute == PHY_CURRENT_CHANNEL) {
@@ -1636,11 +1594,11 @@ static u8 mlme_set_request_sync(
 		command.length + 2,
 		&response.command_id,
 		device_ref)) {
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	if (response.command_id != SPI_MLME_SET_CONFIRM)
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 
 	return response.pdata.status;
 }
@@ -1678,11 +1636,11 @@ static u8 hwme_set_request_sync(
 		command.length + 2,
 		&response.command_id,
 		device_ref)) {
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	if (response.command_id != SPI_HWME_SET_CONFIRM)
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 
 	return response.pdata.hwme_set_cnf.status;
 }
@@ -1714,13 +1672,13 @@ static u8 hwme_get_request_sync(
 		command.length + 2,
 		&response.command_id,
 		device_ref)) {
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 	}
 
 	if (response.command_id != SPI_HWME_GET_CONFIRM)
-		return MAC_SYSTEM_ERROR;
+		return IEEE802154_SYSTEM_ERROR;
 
-	if (response.pdata.hwme_get_cnf.status == MAC_SUCCESS) {
+	if (response.pdata.hwme_get_cnf.status == IEEE802154_SUCCESS) {
 		*hw_attribute_length =
 			response.pdata.hwme_get_cnf.hw_attribute_length;
 		memcpy(
@@ -1770,7 +1728,7 @@ static int ca8210_async_xmit_complete(
 			"Link transmission unsuccessful, status = %d\n",
 			status
 		);
-		if (status != MAC_TRANSACTION_OVERFLOW) {
+		if (status != IEEE802154_TRANSACTION_OVERFLOW) {
 			dev_kfree_skb_any(priv->tx_skb);
 			ieee802154_wake_queue(priv->hw);
 			return 0;
@@ -2436,7 +2394,7 @@ static int ca8210_test_check_upstream(u8 *buf, void *device_ref)
 		if (ret) {
 			response[0]  = SPI_MLME_SET_CONFIRM;
 			response[1] = 3;
-			response[2] = MAC_INVALID_PARAMETER;
+			response[2] = IEEE802154_INVALID_PARAMETER;
 			response[3] = buf[2];
 			response[4] = buf[3];
 			if (cascoda_api_upstream)
-- 
2.27.0

