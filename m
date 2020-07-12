Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB6121C6DD
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 02:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgGLAtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 20:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGLAtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 20:49:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F625C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:49:01 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d194so4357333pga.13
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 17:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TaraxO712legrO0jCAXwQtlsZcSrDSJ3CJRqy7pd4tc=;
        b=Bh/hNQEr1tZukblkMn7P5/7ybZqj1HgvnkDbF2LKGrWscQxP+5vsBYJYKPn+jHhAbC
         4fXOOSojsybSJEIdMLbXSciWA6zySQl9LtkANHa7R4mb6xczthG0jzQkg4XVsa8Yd/EU
         64czOzVxMy8ESrfa5V3pTNVfCWLfhso+XnPL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TaraxO712legrO0jCAXwQtlsZcSrDSJ3CJRqy7pd4tc=;
        b=r5tnno0iDUka6tkeR7cR/Tswf1FQGkfQg89aQzWZwsyNBTyEZppNFbCJM7oOLzysHB
         HHYHbD9Y0ICjnVJFApwHkfaBZIj4yfCJ3ZxDiz51QGlNbDdQMSLN6yWS66p8TkkT7Pzi
         thlxNvE0o2UVdnciZYP07QScoh/fcGP0qisLsrEvcEkqZrJHXO+yN1dcdlH9URa8ufGW
         b+2umozQ5I4mlZjdmDN6yiVnS1Tcrbpxi5fQBrzsKaVxlGq+x/G6ghEFAJYZgQ0x3wX1
         AbF4dkBejzb1dLeLe1TX2219Om9HK8BTlDi6o3jHG+6g2gobKK0bqRfmnbQRaePgI4Jr
         Ax4w==
X-Gm-Message-State: AOAM5320n58cWwLvJB2TKj1FWCCkbdmVJrwFePs5EBrM/+GIUYh89of4
        D2Fpkd6PygadsvDyg4LmbTq3mg==
X-Google-Smtp-Source: ABdhPJxiqrQ/sSBWbBCzBrckkWTKCEM0dnclFQlT2FvsxtzQDJQyuOvO7IbMR6Gx6zsGc521LVU3pg==
X-Received: by 2002:a05:6a00:2286:: with SMTP id f6mr66309646pfe.303.1594514940513;
        Sat, 11 Jul 2020 17:49:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q6sm10157589pfg.76.2020.07.11.17.48.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jul 2020 17:49:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] bnxt_en: Init ethtool link settings after reading updated PHY configuration.
Date:   Sat, 11 Jul 2020 20:48:24 -0400
Message-Id: <1594514905-688-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
References: <1594514905-688-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

In a shared port PHY configuration, async event is received when any of the
port modifies the configuration. Ethtool link settings should be
initialised after updated PHY configuration from firmware.

Fixes: b1613e78e98d ("bnxt_en: Add async. event logic for PHY configuration changes.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6a884df..28147e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10385,15 +10385,15 @@ static void bnxt_sp_task(struct work_struct *work)
 				       &bp->sp_event))
 			bnxt_hwrm_phy_qcaps(bp);
 
-		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
-				       &bp->sp_event))
-			bnxt_init_ethtool_link_settings(bp);
-
 		rc = bnxt_update_link(bp, true);
-		mutex_unlock(&bp->link_lock);
 		if (rc)
 			netdev_err(bp->dev, "SP task can't update link (rc: %x)\n",
 				   rc);
+
+		if (test_and_clear_bit(BNXT_LINK_CFG_CHANGE_SP_EVENT,
+				       &bp->sp_event))
+			bnxt_init_ethtool_link_settings(bp);
+		mutex_unlock(&bp->link_lock);
 	}
 	if (test_and_clear_bit(BNXT_UPDATE_PHY_SP_EVENT, &bp->sp_event)) {
 		int rc;
-- 
1.8.3.1

