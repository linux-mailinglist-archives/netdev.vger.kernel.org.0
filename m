Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07A914A14B
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbgA0J5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46497 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:57:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id y8so3548949pll.13
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t3ltzevlkl9BqbgNXchhp8oFpYeu3ZUTIFGc0Rvwg6c=;
        b=VaCrHUOwz9QzxUXLg3itOLJTKRmUyMK6Qa3UVFkYKc1WqQecOM/DhQsFX+4F8FlVzS
         xNNnH4pQYcOAHYvpXRZk3wU6Kw6cVNF8Swd2TEOYs6OS0fDIN0u75bwrn2iy8VKqz6zy
         WkAL6Hi7ubvokhQTLHEatXkMmWHK1yfw/21dQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t3ltzevlkl9BqbgNXchhp8oFpYeu3ZUTIFGc0Rvwg6c=;
        b=l88mdZP7WJgupmQA8wJdOAqh30GR6o9m9maYYWl+G/Yk1xLl960/iA6MnFsNfdjDF2
         fHyL58br02MPfiOFFHTz/5ApfJq7CLN9dBAmdge3+s1toqpNu0LmTMmi52073ALiMIkk
         7xGt5T6Cx7kRXLEQdNW4rPMHFb3939CCyUS2D4jl33Elqq0ZW4HFiwGnJwwQa8HHHgk7
         wd5tNW9JvlCgenvDLXOdHdh8y95p4gljT5Q6xx8cYS2pqM+pmpiA2XKtszOyf2gTnhQc
         0yzptSoDyG3jvdJiTIr5bu+dpFjM5urXXvTkwllSxLCtWymnCY9kraP/La5p0JoLdi29
         77Iw==
X-Gm-Message-State: APjAAAUHcLfudnzO7mJYXuMzhI8rQ/g4h/UwyokJjBPH/DVha/Giqulm
        F4Zpuoy82oNYW+ZxtgRGB7/F8w==
X-Google-Smtp-Source: APXvYqxWVy1QldNXm1GfzGyT2fPh8C3OwcFM84k1w992S5nBYrO5pcByquOm4iPu0/MIbyiaMmYnrw==
X-Received: by 2002:a17:902:8303:: with SMTP id bd3mr17272343plb.171.1580119038171;
        Mon, 27 Jan 2020 01:57:18 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.57.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:57:17 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v2 10/15] bnxt_en: Move devlink_register before registering netdev
Date:   Mon, 27 Jan 2020 04:56:22 -0500
Message-Id: <1580118987-30052-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Latest kernels get the phys_port_name via devlink, if
ndo_get_phys_port_name is not defined. To provide the phys_port_name
correctly, register devlink before registering netdev.

Also call devlink_port_type_eth_set() after registering netdev as
devlink port updates the netdev structure and notifies user.

Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 12 ++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c |  1 -
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 676f4da..8579415 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11445,9 +11445,9 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 		bnxt_sriov_disable(bp);
 
 	bnxt_dl_fw_reporters_destroy(bp, true);
-	bnxt_dl_unregister(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_cancel_sp_work(bp);
 	bp->sp_event = 0;
@@ -11917,11 +11917,14 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bnxt_init_tc(bp);
 	}
 
+	bnxt_dl_register(bp);
+
 	rc = register_netdev(dev);
 	if (rc)
-		goto init_err_cleanup_tc;
+		goto init_err_cleanup;
 
-	bnxt_dl_register(bp);
+	if (BNXT_PF(bp))
+		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
 	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
@@ -11931,7 +11934,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-init_err_cleanup_tc:
+init_err_cleanup:
+	bnxt_dl_unregister(bp);
 	bnxt_shutdown_tc(bp);
 	bnxt_clear_int_mode(bp);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index a8cdfbdd..f2d9cd6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -561,7 +561,6 @@ int bnxt_dl_register(struct bnxt *bp)
 		netdev_err(bp->dev, "devlink_port_register failed");
 		goto err_dl_unreg;
 	}
-	devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 
 	rc = bnxt_dl_params_register(bp);
 	if (rc)
-- 
2.5.1

