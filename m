Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC39202290
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 10:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgFTISP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 04:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgFTISO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 04:18:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5A7C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so11824164wru.0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 01:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wSt8PyoA5q1rZor7Db/luhdamh92bCf4OvJWelYDTkM=;
        b=cq3Rre1jdNgV/Xuw9KwR1O9yXtVsgkZdEE8nD+1sCyBa/x9bdrRZlke1NEjz5nEtRS
         mtstB78/GaBGqhzPLFqhbkLu2PUGgdRNMgFF7hH+se+WTr/6ZxbeAKwDX5bj5IfX6DYe
         8pIESHss6KkV9sgXT5NIFYSLUMt2AldX2ngrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wSt8PyoA5q1rZor7Db/luhdamh92bCf4OvJWelYDTkM=;
        b=C9YsmjS5/EgSRsG5A7SW/cmPvxCfQfojzUW1t4ZKnelONrhGI/dYkIO5tXWRTfWjzj
         zFumVek9aurjyZlEwggr+r9H9ioOFro27rJpse/anc1c2n51SAxnzG8ON43jHjjs6mce
         xJOiIAHzuyI1ptVB2vtBAZ9vmpntMzqOu7nmI/DSNXaFprobzNrC6BXUxr32t1O2wYSf
         Sp4kTk41eh3zWy9DoHfMl4BGhBV9qLaeKkt43jQDJclKq39v2Keb4xcJT/KpgYhe6rEV
         vQvvZa7W1zEqCXr0++pJ9qqgI8riBXrU+GldXBs+ZpHVzbVRKgx6BYBMv96UdlIz0eK8
         TJIQ==
X-Gm-Message-State: AOAM533YQYAGPMXgcsA7tVCk8kpDgqWsE/4bv4FCvHz2dTb7G8F2R8o7
        YqEkhTYDzGjI5Kb6MJHrhB1aNg==
X-Google-Smtp-Source: ABdhPJxtSOhufvh8+JW9vh1DH2kMC8c2tQZJ8QWrbvAr7uWtPDu31ReS3dDGY7TkCC1T5AFx8eU9yw==
X-Received: by 2002:a5d:4611:: with SMTP id t17mr7728808wrq.243.1592641092892;
        Sat, 20 Jun 2020 01:18:12 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id b201sm9354152wmb.36.2020.06.20.01.18.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 01:18:12 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com, kuba@kernel.org,
        jiri@mellanox.com, jacob.e.keller@intel.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 2/2] bnxt_en: Add board_serial_number field to info_get cb
Date:   Sat, 20 Jun 2020 13:45:47 +0530
Message-Id: <1592640947-10421-3-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1592640947-10421-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add board_serial_number field info to info_get cb via devlink,
if driver can fetch the information from the device.

Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a812beb..16eca3b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -411,6 +411,13 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 			return rc;
 	}
 
+	if (strlen(bp->board_serialno)) {
+		rc = devlink_info_board_serial_number_put(req,
+							  bp->board_serialno);
+		if (rc)
+			return rc;
+	}
+
 	sprintf(buf, "%X", bp->chip_num);
 	rc = devlink_info_version_fixed_put(req,
 			DEVLINK_INFO_VERSION_GENERIC_ASIC_ID, buf);
-- 
1.8.3.1

