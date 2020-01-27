Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE33D14A149
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgA0J5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:15 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45164 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:14 -0500
Received: by mail-pg1-f195.google.com with SMTP id b9so4874791pgk.12
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VlCCvFWaSKzHzjSHhzAdK/BsulE2V9JYtwdqV/cpcR0=;
        b=RIfLCbqB7iqRTfK6DV2c42sNFuiHrfPwVgnEHHRIyb/g7KTny1c6tKfTGIGEFXGcTk
         Jw8OlVHrbiVyj4bEpI0wsarCUZ7OO16JQJT8ouS46TA9vlx0X0tkXTr9zhb7MlFTdb89
         YMg4m8bVXM+Xj8HKgGKAJFVELCvb+oTyNfwDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VlCCvFWaSKzHzjSHhzAdK/BsulE2V9JYtwdqV/cpcR0=;
        b=CYcPZJDbBNbKJgbrUa8+DB+7i1Mh/RmPefKx10SlpnzlURfVUkFuv4wTIdGyaQ5OyO
         CYGr4G07gotVh7OhbGRrC5lZ++aruY5UmvbfGu8Ti/b4B1dqZ0ncZ0tiypw6p3dqI0qv
         fipvcLnw7fvND0tELHCyP2rIfCfxpnf2of0PGfkQYAEjXThV0IvN7xw4qSGgcwos9Lz/
         utIRG35357MI+D7HPDX9Pt8qAdRCq6XmYATJa5JZFFU5dNZ3r+UPtbziKc3lFsHuUTT5
         qlsIqSbPYPIPRhYPr616nFzlDflM6RhZXfUWydy17he/X+l62BCWQ1EWV7aitn15rQn1
         uXXA==
X-Gm-Message-State: APjAAAU0dLW8Pq6fQJjKAq7TWhDLti67K6WwOnAuC+HQ+32iwlwXplZb
        Xv+/jJ6nvqEdV3UU8+Jk2lN6ddXO7xc=
X-Google-Smtp-Source: APXvYqxxITDCE35iH/g37McHR/EJAX/khp9S+971NsvEktLDAai2IuCUEkOYzCFYF8YrAgBR4g7bxw==
X-Received: by 2002:a65:488f:: with SMTP id n15mr19703863pgs.61.1580119033511;
        Mon, 27 Jan 2020 01:57:13 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:13 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 08/15] bnxt_en: Refactor bnxt_dl_register()
Date:   Mon, 27 Jan 2020 04:56:20 -0500
Message-Id: <1580118987-30052-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Define bnxt_dl_params_register() and bnxt_dl_params_unregister()
functions and move params register/unregister code to these newly
defined functions. This patch is in preparation to register
devlink irrespective of firmware spec. version in the next patch.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 60 ++++++++++++++---------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0c3d224..9253eed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -485,6 +485,38 @@ static const struct devlink_param bnxt_dl_params[] = {
 static const struct devlink_param bnxt_dl_port_params[] = {
 };
 
+static int bnxt_dl_params_register(struct bnxt *bp)
+{
+	int rc;
+
+	rc = devlink_params_register(bp->dl, bnxt_dl_params,
+				     ARRAY_SIZE(bnxt_dl_params));
+	if (rc) {
+		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
+			    rc);
+		return rc;
+	}
+	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
+					  ARRAY_SIZE(bnxt_dl_port_params));
+	if (rc) {
+		netdev_err(bp->dev, "devlink_port_params_register failed");
+		devlink_params_unregister(bp->dl, bnxt_dl_params,
+					  ARRAY_SIZE(bnxt_dl_params));
+		return rc;
+	}
+	devlink_params_publish(bp->dl);
+
+	return 0;
+}
+
+static void bnxt_dl_params_unregister(struct bnxt *bp)
+{
+	devlink_params_unregister(bp->dl, bnxt_dl_params,
+				  ARRAY_SIZE(bnxt_dl_params));
+	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
+				       ARRAY_SIZE(bnxt_dl_port_params));
+}
+
 int bnxt_dl_register(struct bnxt *bp)
 {
 	struct devlink *dl;
@@ -520,40 +552,24 @@ int bnxt_dl_register(struct bnxt *bp)
 	if (!BNXT_PF(bp))
 		return 0;
 
-	rc = devlink_params_register(dl, bnxt_dl_params,
-				     ARRAY_SIZE(bnxt_dl_params));
-	if (rc) {
-		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
-			    rc);
-		goto err_dl_unreg;
-	}
-
 	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
 			       bp->pf.port_id, false, 0,
 			       bp->switch_id, sizeof(bp->switch_id));
 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
 	if (rc) {
 		netdev_err(bp->dev, "devlink_port_register failed");
-		goto err_dl_param_unreg;
+		goto err_dl_unreg;
 	}
 	devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 
-	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
-					  ARRAY_SIZE(bnxt_dl_port_params));
-	if (rc) {
-		netdev_err(bp->dev, "devlink_port_params_register failed");
+	rc = bnxt_dl_params_register(bp);
+	if (rc)
 		goto err_dl_port_unreg;
-	}
-
-	devlink_params_publish(dl);
 
 	return 0;
 
 err_dl_port_unreg:
 	devlink_port_unregister(&bp->dl_port);
-err_dl_param_unreg:
-	devlink_params_unregister(dl, bnxt_dl_params,
-				  ARRAY_SIZE(bnxt_dl_params));
 err_dl_unreg:
 	devlink_unregister(dl);
 err_dl_free:
@@ -570,12 +586,8 @@ void bnxt_dl_unregister(struct bnxt *bp)
 		return;
 
 	if (BNXT_PF(bp)) {
-		devlink_port_params_unregister(&bp->dl_port,
-					       bnxt_dl_port_params,
-					       ARRAY_SIZE(bnxt_dl_port_params));
+		bnxt_dl_params_unregister(bp);
 		devlink_port_unregister(&bp->dl_port);
-		devlink_params_unregister(dl, bnxt_dl_params,
-					  ARRAY_SIZE(bnxt_dl_params));
 	}
 	devlink_unregister(dl);
 	devlink_free(dl);
-- 
2.5.1

