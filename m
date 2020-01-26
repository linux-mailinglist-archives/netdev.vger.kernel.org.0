Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5881499B7
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgAZJDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33765 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbgAZJDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:42 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so3591879pgk.0
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VlCCvFWaSKzHzjSHhzAdK/BsulE2V9JYtwdqV/cpcR0=;
        b=ZAlDtK7lE8kucRA72qvsY7wh7cqxm2NYtJ3YQYKlExbjzI4GasU0O20uDViua0n+Qx
         fDItMVue/9h8gNs5/iPWEvasryaIXmzN7rEdNT49Y0YtlmbHl+Lw9R+XM4Swp9k3vr8j
         KtGIEIXXzyLzeTWZ5iBOa2+D4IZW3fpyRyHn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VlCCvFWaSKzHzjSHhzAdK/BsulE2V9JYtwdqV/cpcR0=;
        b=Bb+QvQU9CczKXD6xdpwc9tBXrXrStZBjbHEr0F82YleretLoDWDDpbWlDLIM1lwUqc
         JkzXddcwNlMjzpOGNp9Y4d2VIhGswmt7cjRkZpJiJgYTjtlPN/0rHZu0si2p16ugJJUU
         te9Eq+O7AevsbvaN0fw7ga2Jq5XF+O3je8EzxaFO1O/+d7XRv8noP2MBEkuObpJehM8c
         nIGq8m5RK5oKI8BeAPBe4i+XCqIOiq2lDQxJbQDo7QCyQWXmFhTf2QBeKjNS3YTlD6FU
         2oxCzU9um77I/qqdwRCAmmMkEyR0QS3RLa13XbH/2bw28sf76wB9cBKm601dM5LjPFST
         yVvg==
X-Gm-Message-State: APjAAAU6d1N9a40JBGmV9/N6lgooqn0sDfRVFyoi7oVSLxd+GPcpLJDk
        EhZnKi0LM/+Qw31vt6YCxywT4Q==
X-Google-Smtp-Source: APXvYqxdqNb9a5llRHPxbGo9qDo/kKXCuv4q1qDWaA5uoa5YOIEpikzst3A6oXY5xKrMQ5I0OXm0Yg==
X-Received: by 2002:a05:6a00:5b:: with SMTP id i27mr11324187pfk.112.1580029421985;
        Sun, 26 Jan 2020 01:03:41 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:41 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 09/16] bnxt_en: Refactor bnxt_dl_register()
Date:   Sun, 26 Jan 2020 04:03:03 -0500
Message-Id: <1580029390-32760-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
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

