Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3831B13F29
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 13:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfEELRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 07:17:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33505 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfEELR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 07:17:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id k19so5018602pgh.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 04:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0AzFdsNr2V4ztgo4aPP5tfw1XF796VqgdOsc92I+8cc=;
        b=XA9eoTwH6FUDYttxE5dgTpTU9EvZqq4r2ZZ8PQa9Ovr4Y3HH9q4Rqwi+IKIJq2BIa6
         7TPK2ePHvxl36V/gz4cN/zS1BL8kx+wxllgOCM50bjfui9J6+d4Bv3UavvH9k0TNJiDn
         Fxb/UJ7UqQ9LCugp5kpan7kTVP3SYD2Rkeh3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0AzFdsNr2V4ztgo4aPP5tfw1XF796VqgdOsc92I+8cc=;
        b=JbaQ6rGVJtZMy3sxDZPbPScgWda0nQdFMNODJJhKxKgt8CMQOCvPYwXbuWub8IV8wL
         +G0f7mGG8l6h50RJq7adfkNdPpiWPnK5Y5kcSmyQXi4PPz8jh+hRGpAeUtHrrMqxjRcO
         1EVcrIcB332VCE2uK6KmKg2qJGtwoNBNZcWaNPwaWYTUCFi6rG7E/49/lmbj6zY08PRe
         +46UiS8CGaJf/hlWxLmybPeor1LQbMVxhw1GLTJfdpnrwtdIh/MrgkNnZ7eI1Jd7rvN2
         NhfEFy4dIT1HxC4I+c289H/Xy7k7sn2oB7X7azKoIoCw1VFGllaITNtweouW0YiiFsSV
         hkEA==
X-Gm-Message-State: APjAAAUamnGAFbqcyralIRPc5823iDN0hglb7bogYwwrOJ6VaMQVWNz7
        THoQS1+/ijyk8rftbnzJnmTNDZ6a2h4=
X-Google-Smtp-Source: APXvYqwKGkN+13+8Dd3RKqGqd5W+sOKPHNS1GQuf3ANrPk9UQIN8QpFHUyVFg/pIbV4qCzOi3zfG8Q==
X-Received: by 2002:a63:28c:: with SMTP id 134mr24208497pgc.278.1557055047478;
        Sun, 05 May 2019 04:17:27 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id 10sm9378902pfh.14.2019.05.05.04.17.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 04:17:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 08/11] bnxt_en: Improve NQ reservations.
Date:   Sun,  5 May 2019 07:17:05 -0400
Message-Id: <1557055028-14816-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
References: <1557055028-14816-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt_need_reserve_rings() determines if any resources have changed and
requires new reservation with firmware.  The NQ checking is currently
just an approximation.  Improve the NQ checking logic to make it
accurate.  NQ reservation is only needed on 57500 PFs.  This fix will
eliminate unnecessary reservations and will reduce NQ reservations
when some NQs have been released on 57500 PFs.

Fixes: c0b8cda05e1d ("bnxt_en: Fix NQ/CP rings accounting on the new 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d70320c..cdbadc6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5521,11 +5521,13 @@ static bool bnxt_need_reserve_rings(struct bnxt *bp)
 	stat = bnxt_get_func_stat_ctxs(bp);
 	if (BNXT_NEW_RM(bp) &&
 	    (hw_resc->resv_rx_rings != rx || hw_resc->resv_cp_rings != cp ||
-	     hw_resc->resv_irqs < nq || hw_resc->resv_vnics != vnic ||
-	     hw_resc->resv_stat_ctxs != stat ||
+	     hw_resc->resv_vnics != vnic || hw_resc->resv_stat_ctxs != stat ||
 	     (hw_resc->resv_hw_ring_grps != grp &&
 	      !(bp->flags & BNXT_FLAG_CHIP_P5))))
 		return true;
+	if ((bp->flags & BNXT_FLAG_CHIP_P5) && BNXT_PF(bp) &&
+	    hw_resc->resv_irqs != nq)
+		return true;
 	return false;
 }
 
-- 
2.5.1

