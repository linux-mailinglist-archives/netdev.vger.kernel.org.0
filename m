Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E597C11D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 14:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfGaMWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 08:22:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44466 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfGaMWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 08:22:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id t16so31750573pfe.11;
        Wed, 31 Jul 2019 05:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WhRLhyHKPVlSn0ft137jcQ9Dc8L0yG6Eomi5u0Uve4=;
        b=G9Th19cXxFLEY0eWy4b36hovCKplPcpeA+XhnBXiv7QbYrVy1hzqpyo5nwK56in2hB
         C48FfFah7jyOxjLibTg7aBiJcQPSEmQX9jQHgeyWSh/rQxVFBTHZ0KfGiqrQpH3y5mLK
         XVqISWlFAY/Cwxl7l/6FmYVr0l2UfDuJRg/MzVopFXJWHFIfl4JNnL6jHc+wwK9aODjR
         II3sypJKJ0dE0tt7Fy97lUjcQEGWA26nmVYN6sspkAWHR1sU/RO7ZSe4qUi0AyMr+47p
         YZVlwd+QSlLfmMOitSlWJhalGsnvR7AZ4SQTy6+1bnd3FEZytaOy7fefGW1yFKYutpXz
         q/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/WhRLhyHKPVlSn0ft137jcQ9Dc8L0yG6Eomi5u0Uve4=;
        b=AOX/3O6nwqoNrxg+31G06izJO5xEWjas8NkeLWrJPXJ/jNLBUigXb9yfqOEO7m+jvq
         Kla91zFfZQaDa1HWeOzV/o26RmgeaQrAwscDcEXEN7bYPe8f3/VA1tlXBDpEHZeVjn+S
         6tld10wwFW8P7WlEwNLqLnFh42wd7H90P7JcusHLgDT/q3VAU5rN/8zV6Qbj5KoAASJb
         W7AvhMaxU1HJ3W5PdBba/WhcxQ9XFcfcKJ3T4CumP51bDzvsRfl088rfedhh05Vi7HZ0
         EqYiaDd926PHNuEo6Go6Qf4ExS63MQVRlTYGpZ3di5ELIEuewKOY08wYF3dwLJ/ucp/U
         2qhw==
X-Gm-Message-State: APjAAAWJI7h/0RhD+KM6j8wtKPPW8uSt4b51xvBVnkgEr/i5g1UQgRVj
        yBRjmYcXdmTJhemH41lS4mHp/geh9U8=
X-Google-Smtp-Source: APXvYqwgtYu4rJeY9ihvyr/5Pb65i1L2LtHE56XVxVG8KiloX5ApwkyUZU+AbxKtqRwd5NAdoX9CSQ==
X-Received: by 2002:a65:63c4:: with SMTP id n4mr112425132pgv.44.1564575730049;
        Wed, 31 Jul 2019 05:22:10 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id z68sm62791422pgz.88.2019.07.31.05.22.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 05:22:09 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 1/2] bnxt_en: Use refcount_t for refcount
Date:   Wed, 31 Jul 2019 20:22:03 +0800
Message-Id: <20190731122203.948-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index fc77caf0a076..eb7ed34639e2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -49,7 +49,7 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
 			return -ENOMEM;
 	}
 
-	atomic_set(&ulp->ref_count, 0);
+	refcount_set(&ulp->ref_count, 0);
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
@@ -87,7 +87,7 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 	synchronize_rcu();
 	ulp->max_async_event_id = 0;
 	ulp->async_events_bmap = NULL;
-	while (atomic_read(&ulp->ref_count) != 0 && i < 10) {
+	while (refcount_read(&ulp->ref_count) != 0 && i < 10) {
 		msleep(100);
 		i++;
 	}
@@ -246,12 +246,12 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 
 static void bnxt_ulp_get(struct bnxt_ulp *ulp)
 {
-	atomic_inc(&ulp->ref_count);
+	refcount_inc(&ulp->ref_count);
 }
 
 static void bnxt_ulp_put(struct bnxt_ulp *ulp)
 {
-	atomic_dec(&ulp->ref_count);
+	refcount_dec(&ulp->ref_count);
 }
 
 void bnxt_ulp_stop(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index cd78453d0bf0..fc4aa582d190 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -52,7 +52,7 @@ struct bnxt_ulp {
 	u16		max_async_event_id;
 	u16		msix_requested;
 	u16		msix_base;
-	atomic_t	ref_count;
+	refcount_t	ref_count;
 };
 
 struct bnxt_en_dev {
-- 
2.20.1

