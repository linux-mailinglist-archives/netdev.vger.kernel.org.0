Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF144108197
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfKXDbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:35 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34189 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfKXDbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:34 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so4928501plr.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=utR9EvrdruK3TNnWfyhrf1uhRmZkKhzJ3Z9et02dM0E=;
        b=NZiS2cYGt8lu2TYUQov6/DsA1OFfWCH4r6U1xYMHmBlQVxRg3YShvMw9KrgQSzz6No
         67D253NPwLS6cVYLnkxvuacuPvI2YIW/VW2qsM1t1G0hSuWmMU0pEc3GKckAMSeUsiX5
         ETEHHn7ODTo6aZC4N/iSnkfI6UmnTje7W+RAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=utR9EvrdruK3TNnWfyhrf1uhRmZkKhzJ3Z9et02dM0E=;
        b=P1E/nEeChQ5jsf9wxtsYnv8zuxF4DkcZLiKHTKKy2DUOXrRSg0T2CuO/wpZIU1Uo8m
         7jDwTA6uYXH9MQzlxsEgfTXyEGO0DlcmSrf0xFsB0MpOt5vQGVP10InHqjc63+JGhAo+
         al2OCBSfyjH3ZbZXkCsun2IGjD5GpqXZ9Hhr9oKtFYtPc50VklyUWPmPTlie2JqAEDcd
         nDKYW0tVfUKpK8EkFWueQEaI/0Qmuxy6C333pu+8S58sEYo1m+QwoUDhwBJnJYUpZJbt
         q4u6BOvuuRomFuO2jNNES5oMOEo5MIU0qFu1bHOuhOSP18Sl+4MiUtVPRyDwjcRZcU1t
         W1qQ==
X-Gm-Message-State: APjAAAXHCY9lNVEM1VYUuOpBJtrv4/aRZJOc3AE2SqjAr1Lw33rshjs/
        WNULIIpd49jxuIInlthaEBSPlb0RMpM=
X-Google-Smtp-Source: APXvYqxLfkBWWrtv8g1TyWhx5B69nYU25vy43bmp5hu5pPWuMvvQ39AY0z5/cJGpmMsjUzY0+XY/qQ==
X-Received: by 2002:a17:902:a410:: with SMTP id p16mr21793750plq.184.1574566293101;
        Sat, 23 Nov 2019 19:31:33 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:32 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 10/13] bnxt_en: Refactor the initialization of the ethtool link settings.
Date:   Sat, 23 Nov 2019 22:30:47 -0500
Message-Id: <1574566250-7546-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor this logic in bnxt_probe_phy() into a separate function
bnxt_init_ethtool_link_settings().  It used to be that the settable
link settings will never be changed without going through ethtool.
So we only needed to do this once in bnxt_probe_phy().  Now, another
function sharing the port may change it and we may need to re-initialize
the ethtool settings again in run-time.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 46 +++++++++++++++++--------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9d02232..1b86ba8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10249,6 +10249,31 @@ static void bnxt_chk_missed_irq(struct bnxt *bp)
 
 static void bnxt_cfg_ntp_filters(struct bnxt *);
 
+static void bnxt_init_ethtool_link_settings(struct bnxt *bp)
+{
+	struct bnxt_link_info *link_info = &bp->link_info;
+
+	if (BNXT_AUTO_MODE(link_info->auto_mode)) {
+		link_info->autoneg = BNXT_AUTONEG_SPEED;
+		if (bp->hwrm_spec_code >= 0x10201) {
+			if (link_info->auto_pause_setting &
+			    PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE)
+				link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
+		} else {
+			link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
+		}
+		link_info->advertising = link_info->auto_link_speeds;
+	} else {
+		link_info->req_link_speed = link_info->force_link_speed;
+		link_info->req_duplex = link_info->duplex_setting;
+	}
+	if (link_info->autoneg & BNXT_AUTONEG_FLOW_CTRL)
+		link_info->req_flow_ctrl =
+			link_info->auto_pause_setting & BNXT_LINK_PAUSE_BOTH;
+	else
+		link_info->req_flow_ctrl = link_info->force_pause_setting;
+}
+
 static void bnxt_sp_task(struct work_struct *work)
 {
 	struct bnxt *bp = container_of(work, struct bnxt, sp_task);
@@ -11411,26 +11436,7 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 	if (!fw_dflt)
 		return 0;
 
-	/*initialize the ethool setting copy with NVM settings */
-	if (BNXT_AUTO_MODE(link_info->auto_mode)) {
-		link_info->autoneg = BNXT_AUTONEG_SPEED;
-		if (bp->hwrm_spec_code >= 0x10201) {
-			if (link_info->auto_pause_setting &
-			    PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE)
-				link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		} else {
-			link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		}
-		link_info->advertising = link_info->auto_link_speeds;
-	} else {
-		link_info->req_link_speed = link_info->force_link_speed;
-		link_info->req_duplex = link_info->duplex_setting;
-	}
-	if (link_info->autoneg & BNXT_AUTONEG_FLOW_CTRL)
-		link_info->req_flow_ctrl =
-			link_info->auto_pause_setting & BNXT_LINK_PAUSE_BOTH;
-	else
-		link_info->req_flow_ctrl = link_info->force_pause_setting;
+	bnxt_init_ethtool_link_settings(bp);
 	return 0;
 }
 
-- 
2.5.1

