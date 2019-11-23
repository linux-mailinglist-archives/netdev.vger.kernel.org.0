Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EE7107DB5
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfKWI03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:45816 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWI02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id m71so4198244pjb.12
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cxms1cnLGF84v1oXuL2//iTOOqmUP7cv2MMhSewHCPM=;
        b=M5kWPqWzHzij3SoR8Lqbv7g0wLK9hhzBU+RVoQ6+zGzuiJWrAOdZZHn31cMBUksaFp
         YiOdya26xKv8YxkoLf8DiFea/5ZU6AzkWp78DQAOW2Xx5K0tw8E4GYXty/EeR/3OpYqx
         lOxnQ37gWA23htdJECaGDeRffagsKHqgYkmv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cxms1cnLGF84v1oXuL2//iTOOqmUP7cv2MMhSewHCPM=;
        b=DtxDAqnn9XNq8lJegdlvsNJcEAAbuG6Njd6BDHJuCMREgKUZffGFYfPk4O37ERFQDV
         zIbzPKFTR53iM3NeXrI8hPXDTsh/gGwNvW6pNrPMpwMV/UTWIKC5Lcd7a+n4pqF96/JI
         XnVKiC9u/E8BI43zSIacvS/WAVUWsRugZM3PGlslrVsYWrqKS8oe9yorQ2yitpiF+YLw
         2CYTOauCLIvDaa1Lw6UKRUHICjBfGwENbuEMZV6wY+0pRsJVoUPETjYF2Hqfb6jIqErY
         zAyIxKTa5t5wR3aYavN1y3TIWmI4moDbu/ffiWTduIjbTHJhu1K59PIfmNfk0m/REr7q
         ezNA==
X-Gm-Message-State: APjAAAW+Pi/8TmosGOgg/Kw/2DcYYw7RBsaXFkAVDeyvjagtERG+Xqa1
        mNNboyWgwgOeGHBa0UcHZoD8VQ==
X-Google-Smtp-Source: APXvYqzjzmzTwwvel4EjFEAlVYrMuHdThgYmyskpxjP/gPVVL9DclZF12MHxNbFJygofdrrZh2/uNg==
X-Received: by 2002:a17:90a:b394:: with SMTP id e20mr25189936pjr.130.1574497587742;
        Sat, 23 Nov 2019 00:26:27 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:27 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/15] bnxt_en: Disable/enable Bus master during suspend/resume.
Date:   Sat, 23 Nov 2019 03:25:57 -0500
Message-Id: <1574497570-22102-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable Bus master during suspend to prevent DMAs after the device
goes into D3hot state.  The new 57500 devices may continue to DMA
from context memory after the system goes into D3hot state.  This
may cause some PCIe errors on some system.  Re-enable it during resume.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 35bc579..14b6104 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11921,6 +11921,7 @@ static int bnxt_suspend(struct device *device)
 		rc = bnxt_close(dev);
 	}
 	bnxt_hwrm_func_drv_unrgtr(bp);
+	pci_disable_device(bp->pdev);
 	rtnl_unlock();
 	return rc;
 }
@@ -11932,6 +11933,13 @@ static int bnxt_resume(struct device *device)
 	int rc = 0;
 
 	rtnl_lock();
+	rc = pci_enable_device(bp->pdev);
+	if (rc) {
+		netdev_err(dev, "Cannot re-enable PCI device during resume, err = %d\n",
+			   rc);
+		goto resume_exit;
+	}
+	pci_set_master(bp->pdev);
 	if (bnxt_hwrm_ver_get(bp) || bnxt_hwrm_func_drv_rgtr(bp)) {
 		rc = -ENODEV;
 		goto resume_exit;
-- 
2.5.1

