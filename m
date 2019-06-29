Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BDD5AC22
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfF2PRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39909 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfF2PRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so4890661pls.6
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q1o5B8sm147fB43OA883b7hrWk/7oI22JsDQcm6YJkw=;
        b=VgaLEhFXgEAgeW5K3UinB/O59dR4L5mxI4JqMoEVACyXqTkEAeQPeA4UJdfltjtS69
         W/NHCclGnmn09Y4IxAn7Y+UQmpH/tdTVkIerIVr4Y5F1BziQfaxsadxGhfMheCKf6IcS
         8CMUHzpLL9aifXaQyud8AMUR1NPdcfL/xjwFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q1o5B8sm147fB43OA883b7hrWk/7oI22JsDQcm6YJkw=;
        b=hjKmOHPK5Dv4/8UPCOyxPR7/ik0lQ+aBvquGfqJgYARM24cjNHOyjozFxksJP8rnlJ
         WqJbR9tQUKG6AVO/hd0eLsWaFvubV2SRYSAeUkH62r+zJOyfUpHSyf8uRi8lqT/CdPx5
         Jlp0zpd5b6jnH/7jEtl7ca9O4DBM0cTwkaEOGJh53BE2Z3wjJXBg9vfzS06FJXQnajtM
         /AdMwx42ETe7Fs5itWO+iJkWYNA8Iaz/Nvm4vsXs9EJyMhmTQO7EjW5R2EuS1w5TwciL
         B0bijpjur2QH4xg0bHUG4UMkHHh8II/e5/sTo0VrIJvhENZWME3YQ7SKQwOJK8C1duGn
         PoGw==
X-Gm-Message-State: APjAAAUNx7PAKQivsqk8SSwUdU1cJqJk17520jwIx8Z/WYhbCNzPJjSn
        QtWTxrSsckqxvjWwTLXt8l7zEgu/WLw=
X-Google-Smtp-Source: APXvYqzgmujkOgubM2LwN5MtcdYpw3ep9/e2lCE4iSgnTiUQ4lZSDU2uVWeMtE+UgMy2gzldh6BAUg==
X-Received: by 2002:a17:902:b592:: with SMTP id a18mr18420661pls.278.1561821437316;
        Sat, 29 Jun 2019 08:17:17 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/5] bnxt_en: Disable bus master during PCI shutdown and driver unload.
Date:   Sat, 29 Jun 2019 11:16:44 -0400
Message-Id: <1561821408-17418-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some chips with older firmware can continue to perform DMA read from
context memory even after the memory has been freed.  In the PCI shutdown
method, we need to call pci_disable_device() to shutdown DMA to prevent
this DMA before we put the device into D3hot.  DMA memory request in
D3hot state will generate PCI fatal error.  Similarly, in the driver
remove method, the context memory should only be freed after DMA has
been shutdown for correctness.

Fixes: 98f04cf0f1fc ("bnxt_en: Check context memory requirements from firmware.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f758b2e..b9bc829 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10262,10 +10262,10 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 	bnxt_dcb_free(bp);
 	kfree(bp->edev);
 	bp->edev = NULL;
+	bnxt_cleanup_pci(bp);
 	bnxt_free_ctx_mem(bp);
 	kfree(bp->ctx);
 	bp->ctx = NULL;
-	bnxt_cleanup_pci(bp);
 	bnxt_free_port_stats(bp);
 	free_netdev(dev);
 }
@@ -10859,6 +10859,7 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 
 	if (system_state == SYSTEM_POWER_OFF) {
 		bnxt_clear_int_mode(bp);
+		pci_disable_device(pdev);
 		pci_wake_from_d3(pdev, bp->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
-- 
2.5.1

