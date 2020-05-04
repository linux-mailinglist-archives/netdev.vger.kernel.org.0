Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094581C34E5
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgEDIvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728266AbgEDIvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:06 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24F1C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x15so5226630pfa.1
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WHhi2iq670reydpA+UI4A9BwG0w+ggOqIFPMvs+HxkQ=;
        b=KmPWa/CNXGUzhQAnWYsSLdvSYBoY1R3lzekpABF5QS6Dh6wSzsYBRlZy09YlOcEmOG
         vvCtfnIbVqLBamG9YD0LOCBcTNtKNNKWc1L81LgbP+nOOAvlkjdPgkZ0rLZdaeYPEz9C
         fMmQrzCTUnGmQE1vgrOg9XUGPaR7bV3XU3+2o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WHhi2iq670reydpA+UI4A9BwG0w+ggOqIFPMvs+HxkQ=;
        b=df6fDnEaqR94SGDXvsCy4CDysi9As4EOZKupR0m2VMMojT66yEGgdVJ8os2qMWMVT6
         8CxkaliZv6XSoy7wJ+HpgHX8OGCzaaYUqpQiKZdq9gsPW+lqIvcXzzILePp8Q8DAzsAe
         8AdrcVJAT+1chxmBA9XvXZ+6s2+z8oj9J4FJFuZjdB46mhFzBZWx8drFzfsakNLgwf45
         LVXHhmeqJYo0iiXsuB02LQtXNrIVOpWZSKajPPbwsT+nZB6emBfslAUswPNqNHA7Hjtc
         ixQfivUD/mb/He/3lwBCm+vXA7cV0FHkQHhTxQQv5rBcgVnVzY1blaXkBItkJ/OtHOhw
         caRA==
X-Gm-Message-State: AGi0PuZcnJxJyGireTEm8gN0NAU2mwRwO/Akpn1uQ5TGZUsVpGlVeWPk
        kPHV2HH09AmO7dy3utyTMVk/fennDe8=
X-Google-Smtp-Source: APiQypJXNdmqchm9N+BiHqskk7N5CzSa1C5urYeQXoA0UfiSONrNWyxSNscWv9q7KGlNW4qFNVYljQ==
X-Received: by 2002:a63:600c:: with SMTP id u12mr15541431pgb.318.1588582266107;
        Mon, 04 May 2020 01:51:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 05/15] bnxt_en: prepare to refactor ethtool reset types
Date:   Mon,  4 May 2020 04:50:31 -0400
Message-Id: <1588582241-31066-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

Extract bnxt_hwrm_firmware_reset() for performing firmware reset
operations. This new helper function will be used in a subsequent
patch to separate unrelated reset types out of bnxt_firmware_reset().

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 46 ++++++++++++++---------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 34046a6..ed6a322 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1749,8 +1749,8 @@ static int bnxt_flash_nvram(struct net_device *dev,
 	return rc;
 }
 
-static int bnxt_firmware_reset(struct net_device *dev,
-			       u16 dir_type)
+static int bnxt_hwrm_firmware_reset(struct net_device *dev, u8 proc_type,
+				    u8 self_reset, u8 flags)
 {
 	struct hwrm_fw_reset_input req = {0};
 	struct bnxt *bp = netdev_priv(dev);
@@ -1758,48 +1758,60 @@ static int bnxt_firmware_reset(struct net_device *dev,
 
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FW_RESET, -1, -1);
 
+	req.embedded_proc_type = proc_type;
+	req.selfrst_status = self_reset;
+	req.flags = flags;
+
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc == -EACCES)
+		bnxt_print_admin_err(bp);
+	return rc;
+}
+
+static int bnxt_firmware_reset(struct net_device *dev, u16 dir_type)
+{
+	u8 self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTNONE;
+	struct bnxt *bp = netdev_priv(dev);
+	u8 proc_type, flags = 0;
+
 	/* TODO: Address self-reset of APE/KONG/BONO/TANG or ungraceful reset */
 	/*       (e.g. when firmware isn't already running) */
 	switch (dir_type) {
 	case BNX_DIR_TYPE_CHIMP_PATCH:
 	case BNX_DIR_TYPE_BOOTCODE:
 	case BNX_DIR_TYPE_BOOTCODE_2:
-		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_BOOT;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_BOOT;
 		/* Self-reset ChiMP upon next PCIe reset: */
-		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTPCIERST;
+		self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTPCIERST;
 		break;
 	case BNX_DIR_TYPE_APE_FW:
 	case BNX_DIR_TYPE_APE_PATCH:
-		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_MGMT;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_MGMT;
 		/* Self-reset APE upon next PCIe reset: */
-		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTPCIERST;
+		self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTPCIERST;
 		break;
 	case BNX_DIR_TYPE_KONG_FW:
 	case BNX_DIR_TYPE_KONG_PATCH:
-		req.embedded_proc_type =
-			FW_RESET_REQ_EMBEDDED_PROC_TYPE_NETCTRL;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_NETCTRL;
 		break;
 	case BNX_DIR_TYPE_BONO_FW:
 	case BNX_DIR_TYPE_BONO_PATCH:
-		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_ROCE;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_ROCE;
 		break;
 	case BNXT_FW_RESET_CHIP:
-		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
-		req.selfrst_status = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_CHIP;
+		self_reset = FW_RESET_REQ_SELFRST_STATUS_SELFRSTASAP;
 		if (bp->fw_cap & BNXT_FW_CAP_HOT_RESET)
-			req.flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
+			flags = FW_RESET_REQ_FLAGS_RESET_GRACEFUL;
 		break;
 	case BNXT_FW_RESET_AP:
-		req.embedded_proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP;
+		proc_type = FW_RESET_REQ_EMBEDDED_PROC_TYPE_AP;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
-	if (rc == -EACCES)
-		bnxt_print_admin_err(bp);
-	return rc;
+	return bnxt_hwrm_firmware_reset(dev, proc_type, self_reset, flags);
 }
 
 static int bnxt_flash_firmware(struct net_device *dev,
-- 
2.5.1

