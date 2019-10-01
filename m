Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53FF4C2EF9
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733069AbfJAIgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:36:51 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40849 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732738AbfJAIgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 04:36:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so7390614pfb.7
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 01:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pUP1Z5QnZA/fsAy0Z6RB3AI5GrxB+cXCFQTTNVSlu/4=;
        b=JIx9Jz20p0ZIAZf7rHzJTDGqO111NFyOQaSvNxarcuZEnDVU9ZFaRCFqMIXap9U7Vl
         wvvPUkjIL6n/8hImqR93JaIzbAgwTqMXbt4BgsmCoyqntSja8MBpZ4+L0xcaTSq8EKsg
         JQ4L7t1ZNO50bzico6vv+j27rKTq4icwj20Ek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pUP1Z5QnZA/fsAy0Z6RB3AI5GrxB+cXCFQTTNVSlu/4=;
        b=hT4z1SYW+0HlfNfoeUZgSWuEE3TFMVG6fS6SASD3f/kPzLgKRgqhbF6FoVIkWerP8e
         JIxJeGcyfc0zEU11v9E+ASxCHWmP2zEnrAwH7EsLrm0z8+rzvGgkWZIF4ruo+Adttzkr
         5BrsvUAS3hv1uUGd1FXQgbhh7KdNynG0Gi6wxiYW7kSkbdagTavJ0ufpHbrNQU4+1/hi
         Dw3usTfJG/c5wFz19ClDv5z0Jhbb4W5jebxZ0w4L8ftnLewF0S/TID6K5dhyuxQAQ0ug
         OmfmqocZYPmeQ1d2Z1gKz3aR9q0r8dDFhEr461zp9KS7gRWDpBZQATXwR18mU7J9GLtC
         5oCQ==
X-Gm-Message-State: APjAAAUePDBj3gzsltOGsf+VG89d6wDl9GIOck0VhRuZulEiLiBBdn9s
        Nt1/jd2oLPaoooMNDA0A6MJOQA==
X-Google-Smtp-Source: APXvYqzoWTEKkEBdmQSkGtoWEcmCGVMrI8TClIHaMTEv6+/y8z6Bv2pqzRFFyuLL8jI2KDP3KjDELA==
X-Received: by 2002:a17:90a:d106:: with SMTP id l6mr4215588pju.85.1569919009733;
        Tue, 01 Oct 2019 01:36:49 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id z25sm14015367pfn.7.2019.10.01.01.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 01:36:49 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH net-next] r8152: Factor out OOB link list waits
Date:   Tue,  1 Oct 2019 01:35:57 -0700
Message-Id: <20191001083556.195271-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same for-loop check for the LINK_LIST_READY bit of an OOB_CTRL
register is used in several places. Factor these out into a single
function to reduce the lines of code.

Change-Id: I20e8f327045a72acc0a83e2d145ae2993ab62915
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/r8152.c | 73 ++++++++++++-----------------------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 08726090570e1..30a6df73a9552 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3377,11 +3377,23 @@ static void r8152b_hw_phy_cfg(struct r8152 *tp)
 	set_bit(PHY_RESET, &tp->flags);
 }
 
-static void r8152b_exit_oob(struct r8152 *tp)
+static void wait_oob_link_list_ready(struct r8152 *tp)
 {
 	u32 ocp_data;
 	int i;
 
+	for (i = 0; i < 1000; i++) {
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+		if (ocp_data & LINK_LIST_READY)
+			break;
+		usleep_range(1000, 2000);
+	}
+}
+
+static void r8152b_exit_oob(struct r8152 *tp)
+{
+	u32 ocp_data;
+
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
@@ -3399,23 +3411,13 @@ static void r8152b_exit_oob(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	rtl8152_nic_reset(tp);
 
@@ -3457,7 +3459,6 @@ static void r8152b_exit_oob(struct r8152 *tp)
 static void r8152b_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
 	ocp_data &= ~NOW_IS_OOB;
@@ -3469,23 +3470,13 @@ static void r8152b_enter_oob(struct r8152 *tp)
 
 	rtl_disable(tp);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
@@ -3711,7 +3702,6 @@ static void r8153b_hw_phy_cfg(struct r8152 *tp)
 static void r8153_first_init(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	r8153_mac_clk_spd(tp, false);
 	rxdy_gated_en(tp, true);
@@ -3732,23 +3722,13 @@ static void r8153_first_init(struct r8152 *tp)
 	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
@@ -3773,7 +3753,6 @@ static void r8153_first_init(struct r8152 *tp)
 static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	int i;
 
 	r8153_mac_clk_spd(tp, true);
 
@@ -3784,23 +3763,13 @@ static void r8153_enter_oob(struct r8152 *tp)
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
 	ocp_data |= RE_INIT_LL;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
-	}
+	wait_oob_link_list_ready(tp);
 
 	ocp_data = tp->netdev->mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, ocp_data);
-- 
2.23.0.444.g18eeb5a265-goog

