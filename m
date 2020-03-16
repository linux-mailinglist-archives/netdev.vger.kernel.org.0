Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1D186177
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729387AbgCPCOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:39 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42165 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729348AbgCPCOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id h8so8816212pgs.9
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yaEX+FGy9GXeskMa2/UfB7yhE2OWk5HiZrR+Tw6T+vA=;
        b=ZWlgNV/cXy5FujfckkixBhnC7OJYt2tptQrLuDdYGlnaf3ipnD1YkPyzTIfjD6b7cj
         Ok1gGuuj7EpsPb3pQcrL5+ooV8Sy2sFcabGO5Vcx/NjWBSSUJzvW5QKh8ffENiOnwRPK
         2HHqOcdZlo+xo5q0pFCodywotfkfm/Make2BEipoVOGGSI6lnHAFuDADJrkst8ZFBITL
         T5mj5HA15ZokP4DLXcBppmAiLfpFEtJ36zHwHf4xn9ZzBInnJZuE6r2Mg4PmC1Cz/tB8
         VqO9p6AZCC+bzSwgb6JCai9NcpSxPZQ5YYmhXn/GRDhT1CswKTd5acmJEC50WtaXIPUh
         Nd0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yaEX+FGy9GXeskMa2/UfB7yhE2OWk5HiZrR+Tw6T+vA=;
        b=FYqn9YkTV9p+0W7tkmNVRSu12hnzTL5G60VrO45SDQjzSK5Suhdjfy8colSslpR1Ga
         4r+Xetk6q5zJ5TvMXZVBizjf3ipOpQ313DP4dql23SBZ6Svp4ozk9x5HFa8bck/dz01N
         fYDEO+iBDIodgGbYXtF4ckFyNY4FsFOa8h0RXK3BzUgHldKrq3BzfTxDm9cF8P9Tg/z1
         fsZGmX/gMU5rgcUaClEJKAak/T8hf5qcZST4Bg4vANwFH0Qy+ezzougYdAu8Q4xAIOpg
         rnSmvd4SeXiqgpC7mYeI9hrNr9wLWeo0ONmneCzfypnCo+8T9EWnmZpVlSTH/iTa2qWJ
         SgDQ==
X-Gm-Message-State: ANhLgQ0FAClInAGkJDQLwH+UcqnxvXgmSPt6OnXWL+G/do5Wjq5ThMrN
        cyBWsQZp9jIRUM8gb2vy7/pBo1gCrA4=
X-Google-Smtp-Source: ADFU+vv+VK3019V5gkT11VG+BK2Pnyo1aSp1gMPIEjXJVUViX5cVJ/+7+UXWuKGoHoaSH1fDOu0gBQ==
X-Received: by 2002:a62:bd16:: with SMTP id a22mr14288882pff.202.1584324877617;
        Sun, 15 Mar 2020 19:14:37 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:37 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/5] ionic: don't register mgmt device as devlink port
Date:   Sun, 15 Mar 2020 19:14:24 -0700
Message-Id: <20200316021428.48919-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316021428.48919-1-snelson@pensando.io>
References: <20200316021428.48919-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't set a port type, the devlink code will eventually
print a WARN in the kernel log.  Because the mgmt device is
not really a useful port, don't register it as a devlink port.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index ed14164468a1..273c889faaad 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -77,12 +77,16 @@ int ionic_devlink_register(struct ionic *ionic)
 		return err;
 	}
 
+	/* don't register the mgmt_nic as a port */
+	if (ionic->is_mgmt_nic)
+		return 0;
+
 	devlink_port_attrs_set(&ionic->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
 			       0, false, 0, NULL, 0);
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err)
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-	else if (!ionic->is_mgmt_nic)
+	else
 		devlink_port_type_eth_set(&ionic->dl_port,
 					  ionic->master_lif->netdev);
 
@@ -93,6 +97,7 @@ void ionic_devlink_unregister(struct ionic *ionic)
 {
 	struct devlink *dl = priv_to_devlink(ionic);
 
-	devlink_port_unregister(&ionic->dl_port);
+	if (ionic->dl_port.registered)
+		devlink_port_unregister(&ionic->dl_port);
 	devlink_unregister(dl);
 }
-- 
2.17.1

