Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F3114A14C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbgA0J5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39201 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727520AbgA0J5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:21 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so3558759plp.6
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3V5ACPgT39YvmTMTFjJwiVoP1HrgVABnVL1ahnNO+xI=;
        b=X3/ZyftSyj9MD1ytR00c6tRRYFqDxYoHI7VaBOtxqfJzg4EzgZ86Gq64eqi8B2mjKt
         mjdLWvan5IENws/tevPrECD9mU7eO5+oxfkFziPQDRrX9sbNxTkfhf/xDKVk1BxLwE9D
         +MaTuzlNJDowuutEqeJWZ1pSC1Yd/j/+9KW6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3V5ACPgT39YvmTMTFjJwiVoP1HrgVABnVL1ahnNO+xI=;
        b=gdpcjIuQQ7WU4PHtcfmWSC2Qh0npIqHWR6MNwSsFoEHbfVZPljTtykDDUbcXJVqrnu
         aYFOg+MGVsXNfAE0ThHVPBJdSWI6VzSl6nOW4Tqt01rwcvW0/HIra5G2h2rbdcW8poLO
         YttW6QYnIe14ruTDbcYO1HSVEdYdFUaVXov4V5WwFGp/RvO5uiB18xUTDAqbzo6iDcX/
         RDJtGnzFhWZaZmEr1oKntDVdJ914UJPqMiI9Lu/NdiSD5RYqSUTeH4YuAX+5wzGyxZIX
         apMwqxDu8/S6kVqYw7V0pfNBGQzapbyh3rwaBVPnP04JrQsVxaG8eBeU0cn/DY58Y7oN
         gMuQ==
X-Gm-Message-State: APjAAAViXCQ+J6gkiZT2JDkBgxD8fnLiYNDRrMg8dmk8YVsaj/dEmQlr
        ZKwNujtPPgkGjOWOpuxnqqldMw==
X-Google-Smtp-Source: APXvYqwo4d/E2/J1hZka0XbJGy9/lK9hIEGtbszb9HVTdoKk4AOcv2vFk8IQBUqRhVX/y/REecSspQ==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr13453537pjb.89.1580119040551;
        Mon, 27 Jan 2020 01:57:20 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:20 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 11/15] bnxt_en: Add support to update progress of flash update
Date:   Mon, 27 Jan 2020 04:56:23 -0500
Message-Id: <1580118987-30052-12-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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

