Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9A3272C7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfEVXNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:13:13 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36409 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEVXNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:13:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id d21so1784790plr.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KkQgVdvCOoF50iyMP3OA5p0OEAkg8ZCf5G6/SJ29fD4=;
        b=XF/Ks417nTNBi/jQmc0/juPGGSORnCbOKawyRhXG1h4OWCzJ8zmoTN0PgOnhVmPQ06
         cv4J4GJt2InKA89pY1eDEKx6OJGKa67ovhV1WkFkDQF0lz/BEC2SBKlmgq/jT+xOIp8a
         sZJamonGlikNLi65E/MyG+rq3xr774O5z3Im0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KkQgVdvCOoF50iyMP3OA5p0OEAkg8ZCf5G6/SJ29fD4=;
        b=RwNo2zAE4Oazu8VK9jX9KVcyCfvVXrGxR6u39HyaoRWqOb5WausKrOPJYQvsO9w4U8
         +XqWZwT5s01RfzBH3LsLa2DD+mz/jL8Eq33G/sQSJUlxSfVaiwkeq7xOu1SEHbkuDA5b
         xz8s4WIjGquf4J7WNFu21TdijEsjkVCYjJM1PowcEwIzKyu/sG8uCtb8bMtZCKCT+FbY
         2byVebtOXjxA9BskrLbDQON240v+6QB8O1MrkCRjDsbIZWRKW1xnaHpHNfPl9XNNtrAF
         +Wu13tlD2jS5sYwSiz+75uedDF9/wqADVaULnTZK93IE+4HPvLOeYCgOBpBYn1vWuFij
         fyXg==
X-Gm-Message-State: APjAAAUcSBPsifGA+jD/f1N1iTo/FReNUuO8FIuh3xgF0CKd2HgYlyhg
        /HheCAQRYI8ehcMI8NQE8oXgmrMowuM=
X-Google-Smtp-Source: APXvYqxBuTC4dJM2apW9CWemLy1HUcnJjMByfz+uO+4liI3rY7d71kbkFcgjLjRy1UTw+GSaJL2P7Q==
X-Received: by 2002:a17:902:2aab:: with SMTP id j40mr70239910plb.238.1558566792589;
        Wed, 22 May 2019 16:13:12 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q20sm27750419pgq.66.2019.05.22.16.13.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 16:13:11 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/4] bnxt_en: Device serial number is supported only for PFs.
Date:   Wed, 22 May 2019 19:12:57 -0400
Message-Id: <1558566777-23429-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
References: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Don't read DSN on VFs that do not have the PCI capability.

Fixes: 03213a996531 ("bnxt: move bp->switch_id initialization to PF probe")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 79812da..f758b2e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10725,11 +10725,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto init_err_pci_clean;
 	}
 
-	/* Read the adapter's DSN to use as the eswitch switch_id */
-	rc = bnxt_pcie_dsn_get(bp, bp->switch_id);
-	if (rc)
-		goto init_err_pci_clean;
-
+	if (BNXT_PF(bp)) {
+		/* Read the adapter's DSN to use as the eswitch switch_id */
+		rc = bnxt_pcie_dsn_get(bp, bp->switch_id);
+		if (rc)
+			goto init_err_pci_clean;
+	}
 	bnxt_hwrm_func_qcfg(bp);
 	bnxt_hwrm_vnic_qcaps(bp);
 	bnxt_hwrm_port_led_qcaps(bp);
-- 
2.5.1

