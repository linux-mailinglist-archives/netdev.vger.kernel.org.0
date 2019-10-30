Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC0E9782
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 09:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfJ3IAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 04:00:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35355 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJ3IAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 04:00:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id d13so1034657pfq.2
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 01:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qb+oP8mIrG5a0gYr0lRrYM6tmzsnm3k9lDLprRIuJm0=;
        b=asOLKdoqW84aSjjTXZsH1kCCz9Tp9VBpI2MUKCVmML21KU7VixHgKjnPCX10+R2UVU
         EYSrc3aEw4GdT1/acuZ5tA21Qd/OWaO/gdxl6sR1b4eexJeSfxM+kB1pNmpTrslygZcI
         +0aFSvXrFyPKXB+B6OIquY2iZOwsOhN1akgkM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qb+oP8mIrG5a0gYr0lRrYM6tmzsnm3k9lDLprRIuJm0=;
        b=PbtxRAfH1ArSZMb8ho3DIrxrxLTsU0Jg2qFBbsMKDkNrhCdGfAd4GKxVbYF5L3UQip
         MTyjEVgrB/0rLrzDZM9xhaZYP1D0P0GPVI8xAKfiEi1DUxEsIzJTe4eiYCN3V8dSoRxx
         InJ3oaHcUqeWpY3yMwJceok3iK7DJ/uxXUC8o2q8flae2nAfQUHIG/w2skOvYW2jdszS
         EZUcGrkXyOU9BCeq/4rhQKfeU6bM2ZByq3MnsviHoOx+UiKCj18JeOeMf/nRr3y5F/ok
         Un2wQ2c8jQSHR0C/ZG+ItXR2qCNx1Q8b1n3MTkQ2fZc+LSS2H9XUI4E0X4Q1/ZJ7M7Wu
         b9sA==
X-Gm-Message-State: APjAAAVYYOCdtZGD+XzeGuFZjmRFNZvC8AJUHNRuCV4h39QBg6QMWFeI
        m0LZYH+cdsHARZfekJalRN5Gzw==
X-Google-Smtp-Source: APXvYqw8qgYUz5uZ647WywqZHglsLZSMmVsgGd4F5JGyXOKsixdIh+3JajFKS6tZ66QYMQa8Bk475Q==
X-Received: by 2002:a63:4b52:: with SMTP id k18mr10058087pgl.394.1572422406267;
        Wed, 30 Oct 2019 01:00:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r21sm1960649pfc.27.2019.10.30.01.00.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 01:00:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 5/7] bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.
Date:   Wed, 30 Oct 2019 03:59:33 -0400
Message-Id: <1572422375-7269-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
References: <1572422375-7269-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

We call bnxt_ulp_stop() to notify the RDMA driver that some error or
imminent reset is about to happen.  After that we always call
some variants of bnxt_close().

In the next patch, we will integrate the recently added error
recovery with the RDMA driver.  In response to ulp_stop, the
RDMA driver may free MSIX vectors and that will also trigger
bnxt_close().  To avoid bnxt_close() from being called twice,
we set a new flag after ulp_stop is called.  If the RDMA driver
frees MSIX vectors while the new flag is set, we will not call
bnxt_close(), knowing that it will happen in due course.

With this change, we must make sure that the bnxt_close() call
after ulp_stop will reset IRQ.  Modify bnxt_reset_task()
accordingly if we call ulp_stop.

Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 ++++++++++--------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |  3 ++-
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 708d724..df843f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9927,12 +9927,15 @@ static void bnxt_reset_task(struct bnxt *bp, bool silent)
 	if (netif_running(bp->dev)) {
 		int rc;
 
-		if (!silent)
+		if (silent) {
+			bnxt_close_nic(bp, false, false);
+			bnxt_open_nic(bp, false, false);
+		} else {
 			bnxt_ulp_stop(bp);
-		bnxt_close_nic(bp, false, false);
-		rc = bnxt_open_nic(bp, false, false);
-		if (!silent && !rc)
-			bnxt_ulp_start(bp);
+			bnxt_close_nic(bp, true, false);
+			rc = bnxt_open_nic(bp, true, false);
+			bnxt_ulp_start(bp, rc);
+		}
 	}
 }
 
@@ -11996,10 +11999,9 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		if (!err && netif_running(netdev))
 			err = bnxt_open(netdev);
 
-		if (!err) {
+		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
-			bnxt_ulp_start(bp);
-		}
+		bnxt_ulp_start(bp, err);
 	}
 
 	if (result != PCI_ERS_RESULT_RECOVERED && netif_running(netdev))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index b2c1609..077fd10 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -182,7 +182,7 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
 
 	edev->ulp_tbl[ulp_id].msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
-	if (netif_running(dev)) {
+	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
 		bnxt_close_nic(bp, true, false);
 		bnxt_open_nic(bp, true, false);
 	}
@@ -266,6 +266,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 	if (!edev)
 		return;
 
+	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
 	for (i = 0; i < BNXT_MAX_ULP; i++) {
 		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
 
@@ -276,7 +277,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 	}
 }
 
-void bnxt_ulp_start(struct bnxt *bp)
+void bnxt_ulp_start(struct bnxt *bp, int err)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
@@ -285,6 +286,11 @@ void bnxt_ulp_start(struct bnxt *bp)
 	if (!edev)
 		return;
 
+	edev->flags &= ~BNXT_EN_FLAG_ULP_STOPPED;
+
+	if (err)
+		return;
+
 	for (i = 0; i < BNXT_MAX_ULP; i++) {
 		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index cd78453..9895406 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -64,6 +64,7 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_ROCE_CAP		(BNXT_EN_FLAG_ROCEV1_CAP | \
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
+	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
 	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
 };
@@ -92,7 +93,7 @@ int bnxt_get_ulp_msix_num(struct bnxt *bp);
 int bnxt_get_ulp_msix_base(struct bnxt *bp);
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp);
 void bnxt_ulp_stop(struct bnxt *bp);
-void bnxt_ulp_start(struct bnxt *bp);
+void bnxt_ulp_start(struct bnxt *bp, int err);
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs);
 void bnxt_ulp_shutdown(struct bnxt *bp);
 void bnxt_ulp_irq_stop(struct bnxt *bp);
-- 
2.5.1

