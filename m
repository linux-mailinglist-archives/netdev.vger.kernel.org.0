Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1827013F2F
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfEELRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41296 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfEELRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:25 -0400
Received: by mail-pf1-f193.google.com with SMTP id l132so260854pfc.8
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kSrAWjdLM/TIq/gO+x0ukc0BJRdNLBsulM/jluXRy3M=;
        b=TjEaWk85OjTxS74/jjJmHZ3Fu1SQYNFDZI5pIpSB3BPSh7Y/IaBrXbPs9x1pF9xHMX
         jvV2y7DX/bSZOX+Cxqt9jLjV5m0No8A7TUh4TGN9WvsLi1ukWIGC1leni69JBl1695ue
         Jf3CS2erwyaXG0oYhogZxqFZe1UHSp3RbY+YI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kSrAWjdLM/TIq/gO+x0ukc0BJRdNLBsulM/jluXRy3M=;
        b=feeME24U5AHk4DMhd7MutzjyXeWCH/kkifbO/6vVqocRU2fcnY2qszBbSdjJ0nwIwO
         SzeE2WGtcFJ9X/oqGrBxeylFjFmhJPPMahqFBfzYd3eJpYB/FtjpXnbRyYhYKNaCxTy6
         g0NBoXIGBbTkIJ0JPd4UjYAp/0wvVJlIobyS61IbxTscgatmZ/Hf+JTjK5iR3oSqzzoG
         onKLAr6YG9ss85s2ES2x0SJvH0uUTOxfqmii8TTBAAhnnK09XUH7mfJ2yaKsdUpjgmPI
         zKeCyGw8E5LHBwd/Ue6L1/gVZ1Jxo1G45E/PMZk1/p+BTwvSoXL5Y7dTS6B7mff0ztWx
         +WwQ==
X-Gm-Message-State: APjAAAXWtth/ZhYQ13fbirg1zQJryo97H5U08JlN3002LuAQzXLoHKCk
        xHw6tFJ9z/dOVq0goOhPSq9Ax11rui8=
X-Google-Smtp-Source: APXvYqyZxdJwohw7NtdnRF2qoROmYA+XOpj80Idm5kGyZHzxpt9q19kijUlu0NPIOmUREGzOzyCJPQ==
X-Received: by 2002:aa7:8054:: with SMTP id y20mr25037651pfm.108.1557055044915;
        Sun, 05 May 2019 04:17:24 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:24 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 05/11] bnxt_en: Read package version from firmware.
Date:   Sun,  5 May 2019 07:17:02 -0400
Message-Id: <1557055028-14816-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

HWRM_VER_GET firmware command returns package name that is running
actively on the adapter.  Use this version instead of parsing from
the package log in NVRAM.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
diff --git a/main/Cumulus/drivers/linux/v3/bnxt.c b/main/Cumulus/drivers/linux/v3/bnxt.c
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 9 +++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4e0fec2..256be9d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6693,6 +6693,15 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 		 resp->hwrm_fw_maj_8b, resp->hwrm_fw_min_8b,
 		 resp->hwrm_fw_bld_8b, resp->hwrm_fw_rsvd_8b);
 
+	if (strlen(resp->active_pkg_name)) {
+		int fw_ver_len = strlen(bp->fw_ver_str);
+
+		snprintf(bp->fw_ver_str + fw_ver_len,
+			 FW_VER_STR_LEN - fw_ver_len - 1, "/pkg %s",
+			 resp->active_pkg_name);
+		bp->fw_cap |= BNXT_FW_CAP_PKG_VER;
+	}
+
 	bp->hwrm_cmd_timeout = le16_to_cpu(resp->def_req_timeout);
 	if (!bp->hwrm_cmd_timeout)
 		bp->hwrm_cmd_timeout = DFLT_HWRM_CMD_TIMEOUT;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 647f7c0..2c18f08 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1481,6 +1481,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_KONG_MB_CHNL		0x00000080
 	#define BNXT_FW_CAP_OVS_64BIT_HANDLE		0x00000400
 	#define BNXT_FW_CAP_TRUSTED_VF			0x00000800
+	#define BNXT_FW_CAP_PKG_VER			0x00004000
 	#define BNXT_FW_CAP_PCIE_STATS_SUPPORTED	0x00020000
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index bdd9d16..b126382 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3305,7 +3305,8 @@ void bnxt_ethtool_init(struct bnxt *bp)
 	struct net_device *dev = bp->dev;
 	int i, rc;
 
-	bnxt_get_pkgver(dev);
+	if (!(bp->fw_cap & BNXT_FW_CAP_PKG_VER))
+		bnxt_get_pkgver(dev);
 
 	if (bp->hwrm_spec_code < 0x10704 || !BNXT_SINGLE_PF(bp))
 		return;
-- 
2.5.1

