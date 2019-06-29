Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483E15AC23
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 17:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfF2PRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 11:17:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44258 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbfF2PRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 11:17:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id t7so4873395plr.11
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 08:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kzxsL68qhh9R3O2+7ccN5C3ZlHChylS4TS0FRdut5mk=;
        b=GolzO7PgtzeTnrAVew3FuFaNVtGwoiWi09XoWI4kxNpz2Yeh6/XW7+Sscr8fQYvZ5F
         IHVdlwTp7AgAc+848g/Lydn6hs47cFqWR5/5YXU9vVGN2cdv93yEimbqkMdQcJgMES20
         1VRNc5Wfd7nbmpDIDu5vKg6odNLfPIqG7HlcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kzxsL68qhh9R3O2+7ccN5C3ZlHChylS4TS0FRdut5mk=;
        b=aNem4EMzHW1QaDwOM6Z89tpC70MTxTu2cxZuFprw2f9xweK2xsX2kxGdzHeoiaw5QD
         KwJyjgX+aH0pVChkGCedzHMFnQqV3BCFGvhrQUeEXWDdUuriM7TVQHNRKrbWAKFfABi5
         UK2t0lfg4oA90OqWGCDdSznOp+tCCbtaTdsVMOtLVASZvowsVyh4OcbkM38zMbM256ZW
         ghiBXhrgldsUOBsDJFyjX833hiVEYmQFepYN1CEiaiiUJdDBjFvW5PxdhVETm16SzC+u
         Z3kqrKxfDcMQvIfGSoWlAzhXuGwVcw9e/9MaimlQADnLLI/+Lj6/GRaxpMvFMTv12Tlp
         bSJA==
X-Gm-Message-State: APjAAAWP9QWNL1i7uDXbyHElSbvf4ku53intW/Zije0L8lzAg4NK1tzk
        o8ZJLnF8P4wGVCUhpBGLzPpT9q7rPjE=
X-Google-Smtp-Source: APXvYqy9uRgNQBfNrfjvqr1U1/kWE6mZPihSyhGPWy2GSnvncAfkq03fOENGN4UAv5g1jMyr+vOWWA==
X-Received: by 2002:a17:902:20ec:: with SMTP id v41mr17195033plg.142.1561821439481;
        Sat, 29 Jun 2019 08:17:19 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z14sm5048233pgs.79.2019.06.29.08.17.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 08:17:18 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 3/5] bnxt_en: Fix statistics context reservation logic for RDMA driver.
Date:   Sat, 29 Jun 2019 11:16:46 -0400
Message-Id: <1561821408-17418-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
References: <1561821408-17418-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current logic assumes that the RDMA driver uses one statistics
context adjacent to the ones used by the network driver.  This
assumption is not true and the statistics context used by the
RDMA driver is tied to its MSIX base vector.  This wrong assumption
can cause RDMA driver failure after changing ethtool rings on the
network side.  Fix the statistics reservation logic accordingly.

Fixes: 780baad44f0f ("bnxt_en: Reserve 1 stat_ctx for RDMA driver.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b9bc829..9090c79 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5508,7 +5508,16 @@ static int bnxt_cp_rings_in_use(struct bnxt *bp)
 
 static int bnxt_get_func_stat_ctxs(struct bnxt *bp)
 {
-	return bp->cp_nr_rings + bnxt_get_ulp_stat_ctxs(bp);
+	int ulp_stat = bnxt_get_ulp_stat_ctxs(bp);
+	int cp = bp->cp_nr_rings;
+
+	if (!ulp_stat)
+		return cp;
+
+	if (bnxt_nq_rings_in_use(bp) > cp + bnxt_get_ulp_msix_num(bp))
+		return bnxt_get_ulp_msix_base(bp) + ulp_stat;
+
+	return cp + ulp_stat;
 }
 
 static bool bnxt_need_reserve_rings(struct bnxt *bp)
@@ -7477,11 +7486,7 @@ unsigned int bnxt_get_avail_cp_rings_for_en(struct bnxt *bp)
 
 unsigned int bnxt_get_avail_stat_ctxs_for_en(struct bnxt *bp)
 {
-	unsigned int stat;
-
-	stat = bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_ulp_stat_ctxs(bp);
-	stat -= bp->cp_nr_rings;
-	return stat;
+	return bnxt_get_max_func_stat_ctxs(bp) - bnxt_get_func_stat_ctxs(bp);
 }
 
 int bnxt_get_avail_msix(struct bnxt *bp, int num)
-- 
2.5.1

