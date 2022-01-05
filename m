Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87909485513
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiAEOvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiAEOvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:51:22 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14581C061761;
        Wed,  5 Jan 2022 06:51:22 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id h7so45076694lfu.4;
        Wed, 05 Jan 2022 06:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vY0/qJLogBJH3Ul/Esr0RJ3V4ov1CvvFsCX6ygtZfpg=;
        b=RJnMwzmpgONLXkYczYDa6ANm4jt6I43BMc8i7htDJ/mwFdZXNZhwIrY2BpLfu3dp2z
         Meov1UZdQ25GTM49GB7Jix4Ooz/c9OtJMN3/58CQVHPZo/bXzE+RbG/sTTMkuH1cE36h
         02wNcfaTd9927RmAST58M7QzjgQo9X+EPV9KvS5r24sPxtzaB8lKP5kdTzjfXNDNfiOX
         sNeq/01ysD/4TOvywDtXfE8y/uiWbgUCzFrzdOQync/xzvOLk7YI1iWZkLXuvoAMh8A8
         CrK3pBP0knTkK8vnb4X4tT6UkhHD4Sg43fUi13i3jPn6/R9qQFHhjJNQW0khC7O5gXuq
         8I8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vY0/qJLogBJH3Ul/Esr0RJ3V4ov1CvvFsCX6ygtZfpg=;
        b=TquEZHH8X1/SjzX5LUnItGiYWGR8VgzvZ7BtMEzyPCsENT/x8ps2EsTS6b8HuNhpIz
         kWEa5xXgaSDtGwvEvTM1k+QmBVRolVCCAgETHu7Rgn6NsFEp48dSAmFo3TbLF0auivaz
         bbLporhx2v7N33R4PziFahwKKrHt2UezX/TvNYnaKotuEv53TepVJNM7PGv4zsbhIoZe
         MrOru92Xyitr+uPV9WsBgoiSocf7ivZH0ne5qrJjoNffFQxGBlEy/kIe6RdknMSdEAZw
         IBbuOy2gZN9GSSq7rzk/uruP5R+Oqyl/jegZkI89T7O0slgNtKv4q2m9gbOzAz1FQTl0
         AaiA==
X-Gm-Message-State: AOAM531n9JAjCVlwN/RpBWBzyQCe4bpiaTLhKamz2qt/rvJrdUfU27gG
        xdcEHTjnd93viMZ3DdfjKEo=
X-Google-Smtp-Source: ABdhPJzQczwI0SGN+I0ePDs9qwN40Mb3xiO0hEc2mHUumXyNzTmISQLRDt+gImvpu/aOEK4ic5Kv9g==
X-Received: by 2002:a19:6912:: with SMTP id e18mr48212282lfc.25.1641394280239;
        Wed, 05 Jan 2022 06:51:20 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id t24sm4206700lfg.168.2022.01.05.06.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 06:51:19 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     stefan@datenfreihafen.org, alex.aring@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH -next] ieee802154: atusb: move to new USB API
Date:   Wed,  5 Jan 2022 17:49:47 +0300
Message-Id: <20220105144947.12540-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Old USB API is prone to uninit value bugs if error handling is not
correct. Let's move atusb to use new USB API to

	1) Make code more simple, since new API does not require memory
	   to be allocates via kmalloc()

	2) Defend driver from usb-related uninit value bugs.

	3) Make code more modern and simple

This patch removes atusb usb wrappers as Greg suggested [0], this will make
code more obvious and easier to understand over time, and replaces old
API calls with new ones.

Also this patch adds and updates usb related error handling to prevent
possible uninit value bugs in future

Link: https://lore.kernel.org/all/YdL0GPxy4TdGDzOO@kroah.com/ [0]
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Only build tested.

---
 drivers/net/ieee802154/atusb.c | 182 ++++++++++++---------------------
 1 file changed, 65 insertions(+), 117 deletions(-)

diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
index 2f5e7b31032a..1ba057bfec45 100644
--- a/drivers/net/ieee802154/atusb.c
+++ b/drivers/net/ieee802154/atusb.c
@@ -74,81 +74,6 @@ struct atusb_chip_data {
 	int (*set_txpower)(struct ieee802154_hw*, s32);
 };
 
-/* ----- USB commands without data ----------------------------------------- */
-
-/* To reduce the number of error checks in the code, we record the first error
- * in atusb->err and reject all subsequent requests until the error is cleared.
- */
-
-static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
-			     __u8 request, __u8 requesttype,
-			     __u16 value, __u16 index,
-			     void *data, __u16 size, int timeout)
-{
-	struct usb_device *usb_dev = atusb->usb_dev;
-	int ret;
-
-	if (atusb->err)
-		return atusb->err;
-
-	ret = usb_control_msg(usb_dev, pipe, request, requesttype,
-			      value, index, data, size, timeout);
-	if (ret < size) {
-		ret = ret < 0 ? ret : -ENODATA;
-
-		atusb->err = ret;
-		dev_err(&usb_dev->dev,
-			"%s: req 0x%02x val 0x%x idx 0x%x, error %d\n",
-			__func__, request, value, index, ret);
-	}
-	return ret;
-}
-
-static int atusb_command(struct atusb *atusb, u8 cmd, u8 arg)
-{
-	struct usb_device *usb_dev = atusb->usb_dev;
-
-	dev_dbg(&usb_dev->dev, "%s: cmd = 0x%x\n", __func__, cmd);
-	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
-				 cmd, ATUSB_REQ_TO_DEV, arg, 0, NULL, 0, 1000);
-}
-
-static int atusb_write_reg(struct atusb *atusb, u8 reg, u8 value)
-{
-	struct usb_device *usb_dev = atusb->usb_dev;
-
-	dev_dbg(&usb_dev->dev, "%s: 0x%02x <- 0x%02x\n", __func__, reg, value);
-	return atusb_control_msg(atusb, usb_sndctrlpipe(usb_dev, 0),
-				 ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
-				 value, reg, NULL, 0, 1000);
-}
-
-static int atusb_read_reg(struct atusb *atusb, u8 reg)
-{
-	struct usb_device *usb_dev = atusb->usb_dev;
-	int ret;
-	u8 *buffer;
-	u8 value;
-
-	buffer = kmalloc(1, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
-	dev_dbg(&usb_dev->dev, "%s: reg = 0x%x\n", __func__, reg);
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
-				0, reg, buffer, 1, 1000);
-
-	if (ret >= 0) {
-		value = buffer[0];
-		kfree(buffer);
-		return value;
-	} else {
-		kfree(buffer);
-		return ret;
-	}
-}
-
 static int atusb_write_subreg(struct atusb *atusb, u8 reg, u8 mask,
 			      u8 shift, u8 value)
 {
@@ -158,7 +83,10 @@ static int atusb_write_subreg(struct atusb *atusb, u8 reg, u8 mask,
 
 	dev_dbg(&usb_dev->dev, "%s: 0x%02x <- 0x%02x\n", __func__, reg, value);
 
-	orig = atusb_read_reg(atusb, reg);
+	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, reg, &orig, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
 	/* Write the value only into that part of the register which is allowed
 	 * by the mask. All other bits stay as before.
@@ -167,7 +95,8 @@ static int atusb_write_subreg(struct atusb *atusb, u8 reg, u8 mask,
 	tmp |= (value << shift) & mask;
 
 	if (tmp != orig)
-		ret = atusb_write_reg(atusb, reg, tmp);
+		ret = usb_control_msg_send(usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+					   tmp, reg, NULL, 0, 1000, GFP_KERNEL);
 
 	return ret;
 }
@@ -176,9 +105,13 @@ static int atusb_read_subreg(struct atusb *lp,
 			     unsigned int addr, unsigned int mask,
 			     unsigned int shift)
 {
-	int rc;
+	int rc, ret;
+
+	ret = usb_control_msg_recv(lp->usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, addr, &rc, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	rc = atusb_read_reg(lp, addr);
 	rc = (rc & mask) >> shift;
 
 	return rc;
@@ -419,16 +352,22 @@ static int atusb_set_hw_addr_filt(struct ieee802154_hw *hw,
 		u16 addr = le16_to_cpu(filt->short_addr);
 
 		dev_vdbg(dev, "%s called for saddr\n", __func__);
-		atusb_write_reg(atusb, RG_SHORT_ADDR_0, addr);
-		atusb_write_reg(atusb, RG_SHORT_ADDR_1, addr >> 8);
+		usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+				     addr, RG_SHORT_ADDR_0, NULL, 0, 1000, GFP_KERNEL);
+
+		usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+				     addr >> 8, RG_SHORT_ADDR_1, NULL, 0, 1000, GFP_KERNEL);
 	}
 
 	if (changed & IEEE802154_AFILT_PANID_CHANGED) {
 		u16 pan = le16_to_cpu(filt->pan_id);
 
 		dev_vdbg(dev, "%s called for pan id\n", __func__);
-		atusb_write_reg(atusb, RG_PAN_ID_0, pan);
-		atusb_write_reg(atusb, RG_PAN_ID_1, pan >> 8);
+		usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+				     pan, RG_PAN_ID_0, NULL, 0, 1000, GFP_KERNEL);
+
+		usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+				     pan >> 8, RG_PAN_ID_1, NULL, 0, 1000, GFP_KERNEL);
 	}
 
 	if (changed & IEEE802154_AFILT_IEEEADDR_CHANGED) {
@@ -437,7 +376,9 @@ static int atusb_set_hw_addr_filt(struct ieee802154_hw *hw,
 		memcpy(addr, &filt->ieee_addr, IEEE802154_EXTENDED_ADDR_LEN);
 		dev_vdbg(dev, "%s called for IEEE addr\n", __func__);
 		for (i = 0; i < 8; i++)
-			atusb_write_reg(atusb, RG_IEEE_ADDR_0 + i, addr[i]);
+			usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+					     addr[i], RG_IEEE_ADDR_0 + i, NULL, 0,
+					     1000, GFP_KERNEL);
 	}
 
 	if (changed & IEEE802154_AFILT_PANC_CHANGED) {
@@ -459,7 +400,8 @@ static int atusb_start(struct ieee802154_hw *hw)
 
 	dev_dbg(&usb_dev->dev, "%s\n", __func__);
 	schedule_delayed_work(&atusb->work, 0);
-	atusb_command(atusb, ATUSB_RX_MODE, 1);
+	usb_control_msg_send(atusb->usb_dev, 0, ATUSB_RX_MODE, ATUSB_REQ_TO_DEV, 1, 0,
+			     NULL, 0, 1000, GFP_KERNEL);
 	ret = atusb_get_and_clear_error(atusb);
 	if (ret < 0)
 		usb_kill_anchored_urbs(&atusb->idle_urbs);
@@ -473,7 +415,8 @@ static void atusb_stop(struct ieee802154_hw *hw)
 
 	dev_dbg(&usb_dev->dev, "%s\n", __func__);
 	usb_kill_anchored_urbs(&atusb->idle_urbs);
-	atusb_command(atusb, ATUSB_RX_MODE, 0);
+	usb_control_msg_send(atusb->usb_dev, 0, ATUSB_RX_MODE, ATUSB_REQ_TO_DEV, 0, 0,
+			     NULL, 0, 1000, GFP_KERNEL);
 	atusb_get_and_clear_error(atusb);
 }
 
@@ -580,9 +523,11 @@ atusb_set_cca_mode(struct ieee802154_hw *hw, const struct wpan_phy_cca *cca)
 
 static int hulusb_set_cca_ed_level(struct atusb *lp, int rssi_base_val)
 {
-	unsigned int cca_ed_thres;
+	int cca_ed_thres;
 
 	cca_ed_thres = atusb_read_subreg(lp, SR_CCA_ED_THRES);
+	if (cca_ed_thres < 0)
+		return cca_ed_thres;
 
 	switch (rssi_base_val) {
 	case -98:
@@ -799,18 +744,13 @@ static int atusb_get_and_show_revision(struct atusb *atusb)
 {
 	struct usb_device *usb_dev = atusb->usb_dev;
 	char *hw_name;
-	unsigned char *buffer;
+	unsigned char buffer[3];
 	int ret;
 
-	buffer = kmalloc(3, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
 	/* Get a couple of the ATMega Firmware values */
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_ID, ATUSB_REQ_FROM_DEV, 0, 0,
-				buffer, 3, 1000);
-	if (ret >= 0) {
+	ret = usb_control_msg_recv(atusb->usb_dev, 0, ATUSB_ID, ATUSB_REQ_FROM_DEV, 0, 0,
+				   buffer, 3, 1000, GFP_KERNEL);
+	if (!ret) {
 		atusb->fw_ver_maj = buffer[0];
 		atusb->fw_ver_min = buffer[1];
 		atusb->fw_hw_type = buffer[2];
@@ -849,7 +789,6 @@ static int atusb_get_and_show_revision(struct atusb *atusb)
 		dev_info(&usb_dev->dev, "Please update to version 0.2 or newer");
 	}
 
-	kfree(buffer);
 	return ret;
 }
 
@@ -863,7 +802,6 @@ static int atusb_get_and_show_build(struct atusb *atusb)
 	if (!build)
 		return -ENOMEM;
 
-	/* We cannot call atusb_control_msg() here, since this request may read various length data */
 	ret = usb_control_msg(atusb->usb_dev, usb_rcvctrlpipe(usb_dev, 0), ATUSB_BUILD,
 			      ATUSB_REQ_FROM_DEV, 0, 0, build, ATUSB_BUILD_SIZE, 1000);
 	if (ret >= 0) {
@@ -881,14 +819,27 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 	u8 man_id_0, man_id_1, part_num, version_num;
 	const char *chip;
 	struct ieee802154_hw *hw = atusb->hw;
+	int ret;
 
-	man_id_0 = atusb_read_reg(atusb, RG_MAN_ID_0);
-	man_id_1 = atusb_read_reg(atusb, RG_MAN_ID_1);
-	part_num = atusb_read_reg(atusb, RG_PART_NUM);
-	version_num = atusb_read_reg(atusb, RG_VERSION_NUM);
+	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, RG_MAN_ID_0, &man_id_0, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	if (atusb->err)
-		return atusb->err;
+	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, RG_MAN_ID_1, &man_id_1, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, RG_PART_NUM, &atusb, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	ret = usb_control_msg_recv(usb_dev, 0, ATUSB_REG_READ, ATUSB_REQ_FROM_DEV,
+				   0, RG_VERSION_NUM, &version_num, 1, 1000, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
 	hw->flags = IEEE802154_HW_TX_OMIT_CKSUM | IEEE802154_HW_AFILT |
 		    IEEE802154_HW_PROMISCUOUS | IEEE802154_HW_CSMA_PARAMS;
@@ -969,7 +920,7 @@ static int atusb_get_and_conf_chip(struct atusb *atusb)
 static int atusb_set_extended_addr(struct atusb *atusb)
 {
 	struct usb_device *usb_dev = atusb->usb_dev;
-	unsigned char *buffer;
+	unsigned char buffer[IEEE802154_EXTENDED_ADDR_LEN];
 	__le64 extended_addr;
 	u64 addr;
 	int ret;
@@ -982,18 +933,12 @@ static int atusb_set_extended_addr(struct atusb *atusb)
 		return 0;
 	}
 
-	buffer = kmalloc(IEEE802154_EXTENDED_ADDR_LEN, GFP_KERNEL);
-	if (!buffer)
-		return -ENOMEM;
-
 	/* Firmware is new enough so we fetch the address from EEPROM */
-	ret = atusb_control_msg(atusb, usb_rcvctrlpipe(usb_dev, 0),
-				ATUSB_EUI64_READ, ATUSB_REQ_FROM_DEV, 0, 0,
-				buffer, IEEE802154_EXTENDED_ADDR_LEN, 1000);
+	ret = usb_control_msg_recv(atusb->usb_dev, 0, ATUSB_EUI64_READ, ATUSB_REQ_FROM_DEV, 0, 0,
+				   buffer, IEEE802154_EXTENDED_ADDR_LEN, 1000, GFP_KERNEL);
 	if (ret < 0) {
 		dev_err(&usb_dev->dev, "failed to fetch extended address, random address set\n");
 		ieee802154_random_extended_addr(&atusb->hw->phy->perm_extended_addr);
-		kfree(buffer);
 		return ret;
 	}
 
@@ -1009,7 +954,6 @@ static int atusb_set_extended_addr(struct atusb *atusb)
 			 &addr);
 	}
 
-	kfree(buffer);
 	return ret;
 }
 
@@ -1051,7 +995,8 @@ static int atusb_probe(struct usb_interface *interface,
 
 	hw->parent = &usb_dev->dev;
 
-	atusb_command(atusb, ATUSB_RF_RESET, 0);
+	usb_control_msg_send(atusb->usb_dev, 0, ATUSB_RF_RESET, ATUSB_REQ_TO_DEV, 0, 0,
+			     NULL, 0, 1000, GFP_KERNEL);
 	atusb_get_and_conf_chip(atusb);
 	atusb_get_and_show_revision(atusb);
 	atusb_get_and_show_build(atusb);
@@ -1076,7 +1021,9 @@ static int atusb_probe(struct usb_interface *interface,
 	 * explicitly. Any resets after that will send us straight to TRX_OFF,
 	 * making the command below redundant.
 	 */
-	atusb_write_reg(atusb, RG_TRX_STATE, STATE_FORCE_TRX_OFF);
+	usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+			     STATE_FORCE_TRX_OFF, RG_TRX_STATE, NULL, 0, 1000, GFP_KERNEL);
+
 	msleep(1);	/* reset => TRX_OFF, tTR13 = 37 us */
 
 #if 0
@@ -1104,7 +1051,8 @@ static int atusb_probe(struct usb_interface *interface,
 
 	atusb_write_subreg(atusb, SR_RX_SAFE_MODE, 1);
 #endif
-	atusb_write_reg(atusb, RG_IRQ_MASK, 0xff);
+	usb_control_msg_send(atusb->usb_dev, 0, ATUSB_REG_WRITE, ATUSB_REQ_TO_DEV,
+			     0xff, RG_IRQ_MASK, NULL, 0, 1000, GFP_KERNEL);
 
 	ret = atusb_get_and_clear_error(atusb);
 	if (!ret)
-- 
2.34.1

