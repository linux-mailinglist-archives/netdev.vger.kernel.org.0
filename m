Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB18107DBE
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfKWI0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:43 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33531 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbfKWI0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:43 -0500
Received: by mail-pj1-f65.google.com with SMTP id o14so4224864pjr.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZYpmNvjxbXfyCZqHEdGn7Jrx+pFdBX8t7L6GtZ4CRG0=;
        b=f7BTjfZxje9TbqsLeo5E/F1cypKCyK5y2IlQ/EKZ4Bra1ymNBHetVqYGCLKki8AS5A
         RfqGQ36X1N7Lko6MfRW7JpeFM/O9Ih05Da3zcM4Da4WY169/BbAlPYve3mrzcyt8Rtmm
         0svr3jTL9o9F+93IZCPnTF5KjY9exaYuAAmjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZYpmNvjxbXfyCZqHEdGn7Jrx+pFdBX8t7L6GtZ4CRG0=;
        b=uoVGeyxcXWV+qTNbV3SmSsWPC56GxB91amrNGBe2gfujhm9DyJNmw2gl8MJvomcUNk
         9o0oCEWR3CcOQiRFdN4zbqTUpjKC7uw6zzCfLSo+M375q/2vTTBwABoUB3jMBG/jMN3l
         0AN/MotTJQbCenWQ47DiJS42OqyywOuSsIk7ONp4MVgMAwQY19srJ3NCv9RgD5vrIpcF
         CJih9A/NQU1xqKKCaX0BSxg80vdtNBjhPGiMGmBKXPwAoJINON3xhc6cW3X0m/LpOeHp
         R5mcDX331n8fLGzWmo3C3yLcX/gVVbUlTKbOOhsYmrVnvw5NK9Ko2DFlphzGGUMCToTY
         EzDw==
X-Gm-Message-State: APjAAAVDYo4uOGXVtpoN7XTRMd9V75D1hAzxZBetLo5EzXNCWCPNnank
        OMiYefhIGFAw3DgUJH4+nzJYDQ==
X-Google-Smtp-Source: APXvYqxWuEDWHhKlC3jD49eQxadDXu2Gf65lUt9jzAEUrPF14Ey7JRdgfR7MvIHu4EsumF97j7z88g==
X-Received: by 2002:a17:902:b20b:: with SMTP id t11mr18578446plr.211.1574497602496;
        Sat, 23 Nov 2019 00:26:42 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:42 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 09/15] bnxt_en: Skip disabling autoneg before PHY loopback when appropriate.
Date:   Sat, 23 Nov 2019 03:26:04 -0500
Message-Id: <1574497570-22102-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New firmware allows PHY loopback to be set without disabling autoneg
first.  Check this capability and skip disabling autoneg when
it is supported by firmware.  Using this scheme, loopback will
always work even if the PHY only supports autoneg.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 7 ++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0e384c5..9d02232 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8419,7 +8419,8 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 
 	bp->flags &= ~BNXT_FLAG_EEE_CAP;
 	if (bp->test_info)
-		bp->test_info->flags &= ~BNXT_TEST_FL_EXT_LPBK;
+		bp->test_info->flags &= ~(BNXT_TEST_FL_EXT_LPBK |
+					  BNXT_TEST_FL_AN_PHY_LPBK);
 	if (bp->hwrm_spec_code < 0x10201)
 		return 0;
 
@@ -8445,6 +8446,10 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 		if (bp->test_info)
 			bp->test_info->flags |= BNXT_TEST_FL_EXT_LPBK;
 	}
+	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED) {
+		if (bp->test_info)
+			bp->test_info->flags |= BNXT_TEST_FL_AN_PHY_LPBK;
+	}
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index dbdd097..94c8a92 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1226,7 +1226,8 @@ struct bnxt_led_info {
 struct bnxt_test_info {
 	u8 offline_mask;
 	u8 flags;
-#define BNXT_TEST_FL_EXT_LPBK	0x1
+#define BNXT_TEST_FL_EXT_LPBK		0x1
+#define BNXT_TEST_FL_AN_PHY_LPBK	0x2
 	u16 timeout;
 	char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
 };
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 0641020..62ef847 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2698,7 +2698,8 @@ static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 	u16 fw_speed;
 	int rc;
 
-	if (!link_info->autoneg)
+	if (!link_info->autoneg ||
+	    (bp->test_info->flags & BNXT_TEST_FL_AN_PHY_LPBK))
 		return 0;
 
 	rc = bnxt_query_force_speeds(bp, &fw_advertising);
-- 
2.5.1

