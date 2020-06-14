Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2591F8B5F
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 01:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgFNX5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 19:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgFNX5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 19:57:37 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3DDC05BD43
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so15482098ejc.3
        for <netdev@vger.kernel.org>; Sun, 14 Jun 2020 16:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zoavvsU0jSHWhJ9DrD1KkSozYzyrIY/5183cZBKCV3E=;
        b=GNUz1DzeVzjf0yNBB63lwm7SqS5vPJMuynFmVER7XgI0tw8WGVBWnqrnHVKSfvDLWv
         roNpOroaFjdpbRxLi2GtlXY3JVPFGfIDeGc4OOILEqNccnX01d3QHNsZ/UEOm8UjnVki
         w+q67Cuiu7OFdTrAoRvAN9rRJgIWpvNmcbb5c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zoavvsU0jSHWhJ9DrD1KkSozYzyrIY/5183cZBKCV3E=;
        b=JTBxL3kptNZ0P9d3vvUPFxO5OMjhw1F1q5YLfvvDmvOCfntPgNanDu3zkbot6Tvm54
         do0irhB5/ByFMaiJ8xkAjsgcriMt9oyW1VV8Ni6m5tPY7/xwSfj+H+SVnxvqhX41iVi9
         g6O3WTy+aQcC/duEg0UBe1lU16CWlXfxs7B9wZmXOEnd5BKh7ZPzFJJVE7gMu7Htk4wH
         3Hmw5IqxQ5NwzOT1zltV4Rz/Den96sOb9tsZQ2WOxo028zfMI0XcUwSwO7XSOpPlbThS
         QTXOKWOn7vmsI5623/CGsByPQ/tVpE03a/XUC5x6MaSRk+tqZyxWHNiwDXBwrWlSaFC5
         7iZQ==
X-Gm-Message-State: AOAM532Ak4rVcsv1Aia3hjg2uw+KK/jw1/ZtX73B+VY0IjEnUkVyFuwN
        1nIFi14gVU2iLagp1D/GA4xVDQ==
X-Google-Smtp-Source: ABdhPJwxr/VaFTgpeOQ0Uh4hCFuPhOqJyNlRLHP1hCjbhmP0du0KHXZ98gUV2gvwRB/ABv/G498AZg==
X-Received: by 2002:a17:906:f6c2:: with SMTP id jo2mr11020140ejb.424.1592179055035;
        Sun, 14 Jun 2020 16:57:35 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gj10sm7891398ejb.61.2020.06.14.16.57.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jun 2020 16:57:34 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/4] bnxt_en: Simplify bnxt_resume().
Date:   Sun, 14 Jun 2020 19:57:07 -0400
Message-Id: <1592179030-4533-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
References: <1592179030-4533-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The separate steps we do in bnxt_resume() can be done more simply by
calling bnxt_hwrm_func_qcaps().  This change will add an extra
__bnxt_hwrm_func_qcaps() call which is needed anyway on older
firmware.

Fixes: f9b69d7f6279 ("bnxt_en: Fix suspend/resume path on 57500 chips")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c62589c..1dc38d9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12133,19 +12133,9 @@ static int bnxt_resume(struct device *device)
 		goto resume_exit;
 	}
 
-	if (bnxt_hwrm_queue_qportcfg(bp)) {
-		rc = -ENODEV;
+	rc = bnxt_hwrm_func_qcaps(bp);
+	if (rc)
 		goto resume_exit;
-	}
-
-	if (bp->hwrm_spec_code >= 0x10803) {
-		if (bnxt_alloc_ctx_mem(bp)) {
-			rc = -ENODEV;
-			goto resume_exit;
-		}
-	}
-	if (BNXT_NEW_RM(bp))
-		bnxt_hwrm_func_resc_qcaps(bp, false);
 
 	if (bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, false)) {
 		rc = -ENODEV;
-- 
1.8.3.1

