Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135081C34EA
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgEDIvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728415AbgEDIvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:51:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65CC8C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:51:17 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f8so6532193plt.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 01:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EH8UdflTRfBy2AyQLYxTrmA/gnhwcEfSvhyUrk6s5Ts=;
        b=E9SEz25xbfQ/YsSviu7dGkMi9qSnZlOSNKj9yi0CAUu86jgmfhWaIJTt8dxp7OtWNt
         ccGlCNsmH3jsswHZAVk/EukAcVhb2p23kJOrvxok4Flsy4bkHWXvgVec7s5wQV+TeDzE
         pla54icSXlbGrEL1uNWW9jC3wIX7tkm6tSZGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EH8UdflTRfBy2AyQLYxTrmA/gnhwcEfSvhyUrk6s5Ts=;
        b=HPOxHiuFZ8E9Y4L9RPN944vlNPGEtSPLWJg0XdIX81sNA7TkFHUvpYnQl0GS020wH/
         b3WaXAvKOC/PQ0NOhmQkd/dMT1X+p4hbmXPGW5cbEEy22GGuYMYq8+20kdB4rd2527sj
         FNMlYlHTJ5X1awCliSGDMhA32Upo94oTCHlLatQBHSdc+gpCxiPJ3XypC7N4mAYFRxaC
         hFzepYZnoM1xepRFHEItDlbz6WGzMlPMOYS7yCfRfLuUhmxuZxsEg7+947/P9bqj/e5m
         vnR4ev6nPUzlrZrHD3/l/G4OQmUSzwgAp2mEA4xzZDIrOkUenczEzhGgwcT/LmJvsXtn
         V3ag==
X-Gm-Message-State: AGi0PuZFLHUpYkYsuAlXgRkoCheWlNQZuI/enG2HI7DcKCS//Z0oCN0q
        pPPr+ZIOPPQjRCR8UH5vOaduWw==
X-Google-Smtp-Source: APiQypKZCPqJ098Y5j4yYjuYV+Jj4Ivo2W3gf90jusvd8fQW/Pa5Ohg2fkOOcWHEQcNARWat13gfUA==
X-Received: by 2002:a17:902:70c6:: with SMTP id l6mr15308973plt.31.1588582276935;
        Mon, 04 May 2020 01:51:16 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x193sm8754088pfd.54.2020.05.04.01.51.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 May 2020 01:51:16 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 10/15] bnxt_en: Set the db_offset on 57500 chips for the RDMA MSIX entries.
Date:   Mon,  4 May 2020 04:50:36 -0400
Message-Id: <1588582241-31066-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
References: <1588582241-31066-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver provides completion ring or NQ doorbell offset for each
MSIX entry requested by the RDMA driver.  The NQ offset on 57500
chips is different than legacy chips.  Set it correctly based on
chip type for correctness.  The RDMA driver is ignoring this field
for the 57500 chips so it is not causing any problem.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 4a316c4..4b40778 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -104,7 +104,13 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	for (i = 0; i < num_msix; i++) {
 		ent[i].vector = bp->irq_tbl[idx + i].vector;
 		ent[i].ring_idx = idx + i;
-		ent[i].db_offset = (idx + i) * 0x80;
+		if (bp->flags & BNXT_FLAG_CHIP_P5) {
+			ent[i].db_offset = DB_PF_OFFSET_P5;
+			if (BNXT_VF(bp))
+				ent[i].db_offset = DB_VF_OFFSET_P5;
+		} else {
+			ent[i].db_offset = (idx + i) * 0x80;
+		}
 	}
 }
 
-- 
2.5.1

