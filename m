Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3374D107DBF
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfKWI0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:45 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:35786 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbfKWI0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:45 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so4215993pji.2
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=utR9EvrdruK3TNnWfyhrf1uhRmZkKhzJ3Z9et02dM0E=;
        b=Qn6ZWgfjv/JcuIfqlAv0ak0YGXFhr+9/44Vy7ZMo8FD351OSopumrdhCNvSNHgg41/
         6NpEsjslm3PKgr5xIkx0G6x/OT0C675lhxqbnk8rYBOWFycEMayZuVtkKTJeR5qZodBg
         8MIS2tKsHUxqfj79h/YTEljhkGiTpdV1Q1TKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=utR9EvrdruK3TNnWfyhrf1uhRmZkKhzJ3Z9et02dM0E=;
        b=BMSdrYvgaChdEukD+M6d11XFYUJV7wgyobdhEBUGvqvqqnMwBIt9QrwlhF0WimLX19
         2j1piZgdz9Zs60FumNb+pQ0P7gcHM5oIPGCacRPEGyEyVtf7YIYSa+ZMP3h/5+nHw2Mn
         Z0BTIo+sUmDtLYOWCWHZPlzwAkns5NdxNJp3Mf5UH54Azw5nNxhC0r4kFy957nRgihaa
         yw/FtVJg3J5mndsPYGSCc43ljt7KewvZpf/XZNVchSK0/FK+qoOKtzSfiX8JTWGCWtH3
         pjdnY7xuL1lJ8RFoI9DCKArexNqUtD6B4MuCmt3lIXPb2XdDWqZySMAbTzqZ8RFwBnga
         vWww==
X-Gm-Message-State: APjAAAVXXgwnGPWYPVyxqurVA64dyDsRFSMtQ/PS02YD9Yef/OnirNVj
        9GRFAcqSBN9ISk9yeheNhVyBPs9chJI=
X-Google-Smtp-Source: APXvYqwJvJzTlbEFgUIDlfr+3Rc4fpBcxj26LGwaZ74iYnURUOxIyHQp22cuUs8PHa7H+8ENOgBYog==
X-Received: by 2002:a17:902:8ec5:: with SMTP id x5mr14959828plo.201.1574497604510;
        Sat, 23 Nov 2019 00:26:44 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:44 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 10/15] bnxt_en: Refactor the initialization of the ethtool link settings.
Date:   Sat, 23 Nov 2019 03:26:05 -0500
Message-Id: <1574497570-22102-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
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

