Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E531499BB
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgAZJDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:51 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46659 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729199AbgAZJDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:49 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so2615469pll.13
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3V5ACPgT39YvmTMTFjJwiVoP1HrgVABnVL1ahnNO+xI=;
        b=VtjGzuQn991vIJ4G0wR/nt+CdS/j/e7rX7H+DUapyd4/P0mbAyV/CYKr2i/lyPiM3Y
         5f4xQYfo2LsEkfqpyN/OMADz5HZKP9EcereXn3igf8AhsJpyeMkGN864uGor++P3roxQ
         fASCX0kkGBzWXejZqmhZi+oZosEsJu4W2NfJo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3V5ACPgT39YvmTMTFjJwiVoP1HrgVABnVL1ahnNO+xI=;
        b=JmbtwpUKpcldsJxmHTeOAtzPM0cNQxlZm9qpqbWeZSyRRPDUhcfduaQKMRjuTNfKYF
         2FSrjMY0WxO7ay/wgDVmw9XGjILrL2oo5Wxc2wEwDE9oA3cHOC5IyZ0le+3EG4rp6mV3
         CnC6bjGDHdoVMusuCbheTwCmRTDCwZTToDPyERDKj6tShxlJVHLfpl5wvT9ZU1n76aJL
         oXZ+IKqECr4CZe3BT5eErCzjb46uWtBE9e+n9BgCIuMfZJeeiHpVBB/gD5VhHeHh9Wcz
         hARasW6MfsDl0NFerSJX7Bs9/+eSXe4lpupAap2o9H2j6uNuGiuJkrX8IWoq6Z/NjIV2
         b+JA==
X-Gm-Message-State: APjAAAU6VXrJZrq4SGnXiKG6OIutTFNxxzU4XWV0zGLN1TVq/n6LEJCS
        u79nyj94ZqPylurjipYyIqvM6g==
X-Google-Smtp-Source: APXvYqx7Pxh3ks2zdFRht29ytoUJq62ZJEQbPFR6JSZXV2gbFz5tprEPmRVi2alwOhUdY42jVmuX+g==
X-Received: by 2002:a17:902:8b89:: with SMTP id ay9mr12032352plb.309.1580029428924;
        Sun, 26 Jan 2020 01:03:48 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:48 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 12/16] bnxt_en: Add support to update progress of flash update
Date:   Sun, 26 Jan 2020 04:03:06 -0500
Message-Id: <1580029390-32760-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

This patch adds status notification to devlink flash update
while flashing is in progress.

$ devlink dev flash pci/0000:05:00.0 file 103.pkg
Preparing to flash
Flashing done

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index f2d9cd6..265a68c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -21,6 +21,7 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 		     const char *region, struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
+	int rc;
 
 	if (region)
 		return -EOPNOTSUPP;
@@ -31,7 +32,18 @@ bnxt_dl_flash_update(struct devlink *dl, const char *filename,
 		return -EPERM;
 	}
 
-	return bnxt_flash_package_from_file(bp->dev, filename, 0);
+	devlink_flash_update_begin_notify(dl);
+	devlink_flash_update_status_notify(dl, "Preparing to flash", region, 0,
+					   0);
+	rc = bnxt_flash_package_from_file(bp->dev, filename, 0);
+	if (!rc)
+		devlink_flash_update_status_notify(dl, "Flashing done", region,
+						   0, 0);
+	else
+		devlink_flash_update_status_notify(dl, "Flashing failed",
+						   region, 0, 0);
+	devlink_flash_update_end_notify(dl);
+	return rc;
 }
 
 static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
-- 
2.5.1

