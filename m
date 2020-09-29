Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13827DB91
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgI2WUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgI2WUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:20:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513EBC0613D0
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so6161511pfd.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lto530r924fTZ9R2/barckIXJi8HbI2/fiK18OAiuAU=;
        b=rB6pBO57fbQBfmM2trAEWyfcj2PKPpf9kfsnGGCaNxbwoXm686IiHDBYRGhhqZsv6f
         8Q79XRwjhEGcENk67GCes4oaPkocbB8StqGcpWglQPxKEGoc799/YNoei1zp1EX7GInH
         b3FDowqwqBey5F3IAyqlio5L3h/oMzqiYc3q0Je+BDnvDV/3Y7ooZV5vAqRAhqTKRkra
         iDtK2/3ccu/nWhhJuautN1q6SxtCsHG0akM+8+BQOTDlkK/h0PACRSo+ONKWkidCbOkz
         7CT6VHVTgKLQb2hDm2AQcqqdmG5qDXOPwX2NJGdNay1WavNYk1lCl1YRGIpGxSw290pj
         avPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lto530r924fTZ9R2/barckIXJi8HbI2/fiK18OAiuAU=;
        b=BDpRRqCbEpGuS+deOTRT3Q1G6TIPvJaIWleMlBevJWUZTabKdVFe7N+EAWJhxDq7pL
         rNTIomqV9r4TsMUwLgDy4DP6bBJ6X3hvb7c4zRufyZjKWSUbQ3EuTOa61ttj+YRsC1OP
         3CC2MUv26V3JgEeUkjEPzYJABi8gT/l1Ot5BNfi6Pwy9foYoLAF4ECtWmNu1VOeU2HBI
         xJTYuV8MLP1eNIio2MvwJC1UBDzrbFIEAPENBBNuEZuMAqMjZu04dPVK/FmfgHXP38xc
         +Nayr6NNFxPB+1JoVZJwtBCtRPOivLA2StsVhpw0RHuBzK35tCViVyJau/pHCKqV2ywY
         atyQ==
X-Gm-Message-State: AOAM530X7TM1RtshlyK8sj24682I6b9afX2j2w6TNUv+nmwEcySlChj+
        kG/D9fKf0Wc6YDF9wLpDy9xY7VHdw91yiA==
X-Google-Smtp-Source: ABdhPJxTM/6Yu0YE9YE+dHncrixPYyqyHG4+ytWGp/IKxjMLqe4WLq/NxSStGMJEYifvY0x8WcGVQw==
X-Received: by 2002:a17:902:a713:b029:d2:6356:8761 with SMTP id w19-20020a170902a713b02900d263568761mr6608316plq.77.1601418005450;
        Tue, 29 Sep 2020 15:20:05 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id e27sm6756428pfj.62.2020.09.29.15.20.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 15:20:04 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/2] ionic: stop watchdog timer earlier on remove
Date:   Tue, 29 Sep 2020 15:19:55 -0700
Message-Id: <20200929221956.3521-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200929221956.3521-1-snelson@pensando.io>
References: <20200929221956.3521-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to be better at making sure we don't have a link check
watchdog go off while we're shutting things down, so let's stop
the timer as soon as we start the remove.

Meanwhile, since that was the only thing in
ionic_dev_teardown(), simplify and remove that function.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 5 +++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 5 -----
 drivers/net/ethernet/pensando/ionic/ionic_dev.h     | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index d1d6fb6669e5..2749ce009ebc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -350,7 +350,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
-	ionic_dev_teardown(ionic);
+	del_timer_sync(&ionic->watchdog_timer);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
@@ -378,6 +378,8 @@ static void ionic_remove(struct pci_dev *pdev)
 	if (!ionic)
 		return;
 
+	del_timer_sync(&ionic->watchdog_timer);
+
 	if (ionic->lif) {
 		ionic_devlink_unregister(ionic);
 		ionic_lif_unregister(ionic->lif);
@@ -389,7 +391,6 @@ static void ionic_remove(struct pci_dev *pdev)
 
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
-	ionic_dev_teardown(ionic);
 	pci_clear_master(pdev);
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 6068f51a11d9..306e9401b09b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -98,11 +98,6 @@ int ionic_dev_setup(struct ionic *ionic)
 	return 0;
 }
 
-void ionic_dev_teardown(struct ionic *ionic)
-{
-	del_timer_sync(&ionic->watchdog_timer);
-}
-
 /* Devcmd Interface */
 int ionic_heartbeat_check(struct ionic *ionic)
 {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 8842dc4a716f..c109cd5a0471 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -283,7 +283,6 @@ static inline bool ionic_q_has_space(struct ionic_queue *q, unsigned int want)
 
 void ionic_init_devinfo(struct ionic *ionic);
 int ionic_dev_setup(struct ionic *ionic);
-void ionic_dev_teardown(struct ionic *ionic);
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd);
 u8 ionic_dev_cmd_status(struct ionic_dev *idev);
-- 
2.17.1

