Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620BFEAA0C
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 06:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfJaFIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 01:08:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33503 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfJaFIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 01:08:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id c184so3434284pfb.0
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 22:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qb+oP8mIrG5a0gYr0lRrYM6tmzsnm3k9lDLprRIuJm0=;
        b=LXFMz7oUF88CDeDRZjAQe4ZbY97/JwatDYeC8T73trr51DUE5zAtkegAW9y2f3KhgR
         H+tEmWbolFtaKbdnYNbuxHgmzwEj4zpK+i0X6oNegw0SMiPf8ldTsjnZumFC+TAEy4QM
         5ioj2znagyZ/2hQd1MLWo2UmYeEXKLi2OOFZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qb+oP8mIrG5a0gYr0lRrYM6tmzsnm3k9lDLprRIuJm0=;
        b=gvEBXRnl+Td8SDCtseQjM0NLi9SHiHTAxrBueFhhcgSMpznur3opNwKYj5/ocAuNFo
         aTTGFVQ1TTcM3+gnir8IZWi1F3hJYMgM1g0/B3zeHC9ZG99zr1s6NoYuk3ogP2fnHqUg
         qfsOl9/XSDrShi5Uqd9rCA/yNQj2Pn7AksyBdKLwg/YRwrZlr4cXamZcHGzOVtTYSbZo
         8xsXCSP3alSrtHxDBKbCW/1W0xM/DcAd6zhsf/1xEc64hRQpcGqLjZcsYjXrOObB9Jxe
         0KiPlarCfywHkSvkLgx0MHap8fs936l1gI9eC2qO4vJhLIXefbwlHmhmOLmavkb3S6i1
         Z7nQ==
X-Gm-Message-State: APjAAAWXLz8OE62UTWG3JoqKBMwNF2Wn8pTRDEQ+HyXQ8J1YkE0BEyU2
        NbyogTRKoG/C5W1DZVk7fIAalQ==
X-Google-Smtp-Source: APXvYqzz8umCstmy427F5qqJWGnmym/n4YfmldY/wWVdSYYzvcMuZbF0AKoHyhs/IPosnTomyNxH+w==
X-Received: by 2002:a62:b419:: with SMTP id h25mr408782pfn.52.1572498501791;
        Wed, 30 Oct 2019 22:08:21 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a8sm1690899pff.5.2019.10.30.22.08.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Oct 2019 22:08:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next v2 5/7] bnxt_en: Improve bnxt_ulp_stop()/bnxt_ulp_start() call sequence.
Date:   Thu, 31 Oct 2019 01:07:49 -0400
Message-Id: <1572498471-31550-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
References: <1572498471-31550-1-git-send-email-michael.chan@broadcom.com>
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

