Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84660118186
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfLJHtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:42 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35057 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfLJHtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:41 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so8483323pgk.2
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j6ZQjrasS2QfPeryIP11osAmVYXtBNicnE2PodT0eNg=;
        b=aqgWFvguBTxgACiou2EGZY5b+D8+lLUKznP7MIuSoxvE/lEvOCBMIAtw01i9sGrzT1
         WzKsknwcYQQVkOfb9ecznzoB4Q+rCpyPzi6itq6QzrHXilhqRgsR92i1nv5HzyHXhhi8
         2cqbLHLfkbUd8q8bWWrAm+w2CaK62nnX/LCF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j6ZQjrasS2QfPeryIP11osAmVYXtBNicnE2PodT0eNg=;
        b=skFTjjuEUb1XlzlRJ8Urfr/8o0KnKTftiBAg/1/JtJCofxMHx7tpN3u0suaA3ZkZkw
         h1r8Pymd1wcCP0l3cBN8lw39sEXgFC+X3MfUAnCpsgGBbvE66XMgbYQZH9F7zDE52lhW
         L76S5q85aIQp4RBKP3scs9afm61sgCwVyh62j4eblhoHfDIGKftSXTlUhtHKSK4grJGf
         ZR0fgzoPYaR9IiMU+BGuA7TJSXo0tzRU4r9VzZMsrNVW/cJcB2VcCLRVdoZdycnhvq6A
         nI/kW5SLt/LQs3tWx0r1iY7IHp3/VcfrsRRrQ0h99pwQD1v2or5W59T0wIbk6R1hPi7Q
         X70A==
X-Gm-Message-State: APjAAAWK6TG4i/3ayYCmN/zAg24FFUC53hxx6ziaa/k1kweC8Md7ThN6
        umIi+RsRW2LYgcn9reZxWLb3xMqVxrE=
X-Google-Smtp-Source: APXvYqxgN8HuJnyUk96ZxUzjxOBDBowsHvV+d+vstWbbqoGR1Ers4wVegLexUtoPynUflS0qZqEgkA==
X-Received: by 2002:a63:2949:: with SMTP id p70mr23525363pgp.191.1575964181186;
        Mon, 09 Dec 2019 23:49:41 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:40 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 7/7] bnxt_en: Add missing devlink health reporters for VFs.
Date:   Tue, 10 Dec 2019 02:49:13 -0500
Message-Id: <1575964153-11299-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The VF driver also needs to create the health reporters since
VFs are also involved in firmware reset and recovery.  Modify
bnxt_dl_register() and bnxt_dl_unregister() so that they can
be called by the VFs to register/unregister devlink.  Only the PF
will register the devlink parameters.  With devlink registered,
we can now create the health reporters on the VFs.

Fixes: 6763c779c2d8 ("bnxt_en: Add new FW devlink_health_reporter")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 13 +++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 23 +++++++++++++++++------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 819b7d7..a754903 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11417,12 +11417,11 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(dev);
 
-	if (BNXT_PF(bp)) {
+	if (BNXT_PF(bp))
 		bnxt_sriov_disable(bp);
-		bnxt_dl_fw_reporters_destroy(bp, true);
-		bnxt_dl_unregister(bp);
-	}
 
+	bnxt_dl_fw_reporters_destroy(bp, true);
+	bnxt_dl_unregister(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	bnxt_shutdown_tc(bp);
@@ -11899,10 +11898,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_cleanup_tc;
 
-	if (BNXT_PF(bp)) {
-		bnxt_dl_register(bp);
-		bnxt_dl_fw_reporters_create(bp);
-	}
+	bnxt_dl_register(bp);
+	bnxt_dl_fw_reporters_create(bp);
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
 		    board_info[ent->driver_data].name,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 136953a..3eedd44 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -270,6 +270,8 @@ static const struct devlink_ops bnxt_dl_ops = {
 	.flash_update	  = bnxt_dl_flash_update,
 };
 
+static const struct devlink_ops bnxt_vf_dl_ops;
+
 enum bnxt_dl_param_id {
 	BNXT_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	BNXT_DEVLINK_PARAM_ID_GRE_VER_CHECK,
@@ -483,7 +485,10 @@ int bnxt_dl_register(struct bnxt *bp)
 		return -ENOTSUPP;
 	}
 
-	dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
+	if (BNXT_PF(bp))
+		dl = devlink_alloc(&bnxt_dl_ops, sizeof(struct bnxt_dl));
+	else
+		dl = devlink_alloc(&bnxt_vf_dl_ops, sizeof(struct bnxt_dl));
 	if (!dl) {
 		netdev_warn(bp->dev, "devlink_alloc failed");
 		return -ENOMEM;
@@ -502,6 +507,9 @@ int bnxt_dl_register(struct bnxt *bp)
 		goto err_dl_free;
 	}
 
+	if (!BNXT_PF(bp))
+		return 0;
+
 	rc = devlink_params_register(dl, bnxt_dl_params,
 				     ARRAY_SIZE(bnxt_dl_params));
 	if (rc) {
@@ -551,11 +559,14 @@ void bnxt_dl_unregister(struct bnxt *bp)
 	if (!dl)
 		return;
 
-	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
-				       ARRAY_SIZE(bnxt_dl_port_params));
-	devlink_port_unregister(&bp->dl_port);
-	devlink_params_unregister(dl, bnxt_dl_params,
-				  ARRAY_SIZE(bnxt_dl_params));
+	if (BNXT_PF(bp)) {
+		devlink_port_params_unregister(&bp->dl_port,
+					       bnxt_dl_port_params,
+					       ARRAY_SIZE(bnxt_dl_port_params));
+		devlink_port_unregister(&bp->dl_port);
+		devlink_params_unregister(dl, bnxt_dl_params,
+					  ARRAY_SIZE(bnxt_dl_params));
+	}
 	devlink_unregister(dl);
 	devlink_free(dl);
 }
-- 
2.5.1

