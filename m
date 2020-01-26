Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7141499B5
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgAZJDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:40 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40136 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729014AbgAZJDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:38 -0500
Received: by mail-pl1-f194.google.com with SMTP id p12so2204853plr.7
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AE4i9DBZawLRA4+hTy9ux3mggfiCFx9jNJrS3dBXSuA=;
        b=ho2SndT6yYgSlgvDerJro3nKwSHYX3HHRzxEMbjevi+PLYiC/G1rXxDOyGIOUreO9N
         IkVfE/Fg9uoyWiLNtD9wn61k7BWdiNKYEfxErO1+6ACKHeS84UzgDm8fkaSXdMHfCAsZ
         FCCbfgs9pgh2D9kRQo7emQHDZn2OaKtX0taxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AE4i9DBZawLRA4+hTy9ux3mggfiCFx9jNJrS3dBXSuA=;
        b=U1SgAcvHxcvAPNIgrl7DQgCDnlqmxA+XQ3vieAHav68cbsc8xOKlVV6KzYc/CGuwlA
         oMcqDx1JMkzoTMMpwx10PdHSM7/hwr9UqkIhbSGbIqNY9RfActyVUPjK09uI6KI4bYNp
         rwVGidmkjIXJ6lGyfa6ZFIM19ETh0IVrlXoVu9AfkdNquIuaOL5NqHs7rmRf+g03UERA
         3P+qO6Tg4o4O1xzTIlZ4hpl0W6D69rlOutt+PTSlOcscoxh6Hqn5eksDrtb4b64HsM05
         Gkg64G49xk4i+goCxDrZBJcLmN++r6q+/RqeaJbE/ZVZ4E1ozQd8JtE2sf6Vic8ydSJ8
         xFKA==
X-Gm-Message-State: APjAAAUvtAOiprq2wI65DfO/NVxY6BHxDgk7uMVW1yYpufL73HW6nQO/
        6hGqt33ayV3Bromgzj1T6uvb3w==
X-Google-Smtp-Source: APXvYqxU10DPEzFU+fq7t1vghK01F+AkXhYDj3m0ASS5bATcQOOpT81xGRAghUgE7ao8emgGGLJFdA==
X-Received: by 2002:a17:90a:7781:: with SMTP id v1mr8652133pjk.108.1580029418008;
        Sun, 26 Jan 2020 01:03:38 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:37 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Pavan Chebbi <pavan.chebbi@broadcom.com>
Subject: [PATCH net-next 07/16] bnxt_en: Periodically check and remove aged-out ntuple filters
Date:   Sun, 26 Jan 2020 04:03:01 -0500
Message-Id: <1580029390-32760-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Currently the only time we check and remove expired filters is
when we are inserting new filters.
Improving the aRFS expiry handling by adding code to do the above
work periodically.

Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index fb67e66..7d53672 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10040,6 +10040,13 @@ static void bnxt_timer(struct timer_list *t)
 		bnxt_queue_sp_work(bp);
 	}
 
+#ifdef CONFIG_RFS_ACCEL
+	if ((bp->flags & BNXT_FLAG_RFS) && bp->ntp_fltr_count) {
+		set_bit(BNXT_RX_NTP_FLTR_SP_EVENT, &bp->sp_event);
+		bnxt_queue_sp_work(bp);
+	}
+#endif /*CONFIG_RFS_ACCEL*/
+
 	if (bp->link_info.phy_retry) {
 		if (time_after(jiffies, bp->link_info.phy_retry_expires)) {
 			bp->link_info.phy_retry = false;
-- 
2.5.1

