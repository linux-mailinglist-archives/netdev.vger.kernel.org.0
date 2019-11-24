Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3223108192
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfKXDbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37230 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfKXDbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so5579963pfn.4
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D8xEbQZ+IOLV2uefkd0EqzXQTKGdY3oW8wEMZbOscGI=;
        b=OrdMMgc/11jI4rP7gtRzMeEsgDZQJce4YV04cyQIkSzVk8MYzl7A3J4Ml3uIhO20kt
         5N4WxjYsSNO63ESzFjpLqqp6Oik/3TH0gi0/gH4AZ6dj5n/Qw+U0MYeCiPoGQffZ73CT
         22URoMW0NfZbAc0LCgpnIi0JgXK3qvrRcMtUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D8xEbQZ+IOLV2uefkd0EqzXQTKGdY3oW8wEMZbOscGI=;
        b=DeQ2sRztmqF2K4bMQPRmRj6BPN5D2s0Gyb8ExF84tI0PUsU9gw7pZvGLE/W1h6rKGo
         CZPND9XWWF9UofBqJMRfO/mQJeHe2mLBFF7mYOKCWNG5JuV+Xf5+qFkEcUf4uX0DD4OY
         D9ihaojRublcZClsN/jDCmSvThX+AQYC263O0D3ehDA31IH4wIw3CtV5cF+c0kiqxApP
         jy7CrkYZsNlBbROuykb6VDEV/SrzJxGNuimD+Vu/3sc90E6zPaK5ap5EgUdaGKbxFZ7n
         o27DREXMFJ+aaAVDx3KDhnnNG1n8NE0b7yCvdjD+yVDm5gu41I1E3+/VDfR8jaCopulR
         VZag==
X-Gm-Message-State: APjAAAWC2/W/9BArAjusIkuMwhHA37jmZNfQB4wJHstrnYl8VOLLdAjd
        K8lxgkwducQKff07wmJbmhoqpA==
X-Google-Smtp-Source: APXvYqyHhB+lUZSobzoC1SvOK2qapV8R4YaV9L8dn+q2ZN1lv5UY3ft8FZYOD5ynjHddYnDwfBtmOw==
X-Received: by 2002:a62:31c1:: with SMTP id x184mr27456828pfx.255.1574566281569;
        Sat, 23 Nov 2019 19:31:21 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:21 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 05/13] bnxt_en: Send FUNC_RESOURCE_QCAPS command in bnxt_resume()
Date:   Sat, 23 Nov 2019 22:30:42 -0500
Message-Id: <1574566250-7546-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

After driver unregister, firmware is erasing the information that
driver supports new resource management. Send FUNC_RESOURCE_QCAPS
command to inform the firmware that driver supports new resource
management while resuming from hibernation.  Otherwise, we fallback
to the older resource allocation scheme.

Also, move driver register after sending FUNC_RESOURCE_QCAPS command
to be consistent with the normal initialization sequence.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f627741..69d7ab1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11934,8 +11934,7 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 	pci_set_master(bp->pdev);
-	if (bnxt_hwrm_ver_get(bp) ||
-	    bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
+	if (bnxt_hwrm_ver_get(bp)) {
 		rc = -ENODEV;
 		goto resume_exit;
 	}
@@ -11944,6 +11943,15 @@ static int bnxt_resume(struct device *device)
 		rc = -EBUSY;
 		goto resume_exit;
 	}
+
+	if (BNXT_NEW_RM(bp))
+		bnxt_hwrm_func_resc_qcaps(bp, false);
+
+	if (bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
+		rc = -ENODEV;
+		goto resume_exit;
+	}
+
 	bnxt_get_wol_settings(bp);
 	if (netif_running(dev)) {
 		rc = bnxt_open(dev);
-- 
2.5.1

