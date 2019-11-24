Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C68910818E
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKXDbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:15 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41444 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfKXDbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:15 -0500
Received: by mail-pf1-f196.google.com with SMTP id p26so5565247pfq.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cxms1cnLGF84v1oXuL2//iTOOqmUP7cv2MMhSewHCPM=;
        b=FHrKBOJmU2eaWdGDqWLI2lDrO5UOSZvNU1uk6jKOTrm8GfA9tOckzU9dCrHFpDP0Qh
         lcS8jWKAKoxtRzK8egWy55lUSaa+U7OKYF70thgblhLdPsZzRj8LLCnhu5j2mujCJOQ/
         4l5PMK43N9LFu0sPXwUM5BvWn/FhgqtxM0cJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cxms1cnLGF84v1oXuL2//iTOOqmUP7cv2MMhSewHCPM=;
        b=kLQpTc5RfqUo/qfEyqQiT/jp/NdeD6/OB+vz/ZudDNnPPpvZlMrST2Up6x9JTmdU8T
         P/m8teTdfpE4fH8VPZ2md1tz4AZtKV21PmiGM3lRDgK/8YySXZvN18e8HkNDG4R3/zuU
         4ZZHCjSSK9BGDQZzW5NCWYuK7a2YTodLpCJ3F6kOqF/Bk/eLrv1q73GuAduwJwXrdNPV
         WMoHY0CFGxZ5bPB86i46hr8hNxkRiPKkJL11GOAMdkkylrb/yViI9r0Sj4dbrIgIpLSx
         AmnGAhWEu/DmQ6tmqQjN0RBl+4Ns5O0zh8TzkmZqyK7S6F7rCUcbJBT6mtIrYTBr48DX
         3A8g==
X-Gm-Message-State: APjAAAW5iYEggWcuapLj1bjLk0+smJlQBkeubvVnsOtPRXt7wYqU4PgE
        T9CfIdSBJDoejocwTcHT3inl77NCgEQ=
X-Google-Smtp-Source: APXvYqy25hV7HoYqaCL91ma161eacf/g7v9htM18hlIHUyecUFB5SmlSvFWmCeDHLvL78rxiofoRdg==
X-Received: by 2002:a63:6d0c:: with SMTP id i12mr24902024pgc.202.1574566273481;
        Sat, 23 Nov 2019 19:31:13 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:13 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 02/13] bnxt_en: Disable/enable Bus master during suspend/resume.
Date:   Sat, 23 Nov 2019 22:30:39 -0500
Message-Id: <1574566250-7546-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
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

