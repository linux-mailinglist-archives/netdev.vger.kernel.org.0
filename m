Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5C3912EC
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 23:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfHQVF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 17:05:28 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42591 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfHQVF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 17:05:28 -0400
Received: by mail-pl1-f196.google.com with SMTP id y1so3895649plp.9
        for <netdev@vger.kernel.org>; Sat, 17 Aug 2019 14:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BZCerxlhc0Xot831kfmRRznDWF99Q5kyzBgeSvu1roA=;
        b=ZQ7H+wDnceV+FGTqehMHXzogXR4G4CqRafeerJ7FqCBe1UHcW4W91wJbmFDdfE3wH4
         Uy1/4R40sxvq+8n281EqsRG6lt94BG3TDHttg1xkjrH7gDFH0t2kucc7VbLEEE8oASXv
         txBlIWaB/QVOi0Ekd2nnY/3eeSCnHAsJibrzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BZCerxlhc0Xot831kfmRRznDWF99Q5kyzBgeSvu1roA=;
        b=Itq2tJZGRzMDa3zgiDLMHqyuY1ehKC2nKJPOECiodUWDu5uxGiRdq72kEYLcaAvF4U
         mcv2+73hzsWsFODngKMALjTMPVPTN0jn9rO5dGLeo43s8dJug4Vnas0r9uEBGN0nrDMd
         udMoZNN20nv89Y1iVBS1dkdZ7vjqwDgkBjCfI8W5xCJd53DbKKjE9JP2L77RhXIwaEDG
         oXrUiuvLJUK0943iQG+uvcCcp/lG4BLtM2gfml1eElzrW0vv1b0Wlv68dRx2/KDUT5DC
         LbAgLN7Y9fqiNIoQqS271Hi3Mqk7RmoZjzbx0Ok0OvAyBIIymj7jpArBIjU+4hkAX7KU
         pFxQ==
X-Gm-Message-State: APjAAAVh/s8fWGspbTNS2iJR8rQlLco922HHd3vpRb9qbto/AcVEHURt
        qXYbMBeTFF/EK/3RSPC6b7b54pGL5nQ=
X-Google-Smtp-Source: APXvYqxu5k1mPov74KrPUR4nDTLV2fOL8Y4J4tqvSR4Q3iZ2mmSNSIvLHH76rnIaO3Ge/kTI7HezIg==
X-Received: by 2002:a17:902:d882:: with SMTP id b2mr15307664plz.66.1566075927583;
        Sat, 17 Aug 2019 14:05:27 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e189sm9099295pgc.15.2019.08.17.14.05.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 14:05:27 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2 1/6] bnxt_en: Fix VNIC clearing logic for 57500 chips.
Date:   Sat, 17 Aug 2019 17:04:47 -0400
Message-Id: <1566075892-30064-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
References: <1566075892-30064-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During device shutdown, the VNIC clearing sequence needs to be modified
to free the VNIC first before freeing the RSS contexts.  The current
code is doing the reverse and we can get mis-directed RX completions
to CP ring ID 0 when the RSS contexts are freed and zeroed.  The clearing
of RSS contexts is not required with the new sequence.

Refactor the VNIC clearing logic into a new function bnxt_clear_vnic()
and do the chip specific VNIC clearing sequence.

Fixes: 7b3af4f75b81 ("bnxt_en: Add RSS support for 57500 chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7070349..1ef224f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7016,19 +7016,29 @@ static void bnxt_hwrm_clear_vnic_rss(struct bnxt *bp)
 		bnxt_hwrm_vnic_set_rss(bp, i, false);
 }
 
-static void bnxt_hwrm_resource_free(struct bnxt *bp, bool close_path,
-				    bool irq_re_init)
+static void bnxt_clear_vnic(struct bnxt *bp)
 {
-	if (bp->vnic_info) {
-		bnxt_hwrm_clear_vnic_filter(bp);
+	if (!bp->vnic_info)
+		return;
+
+	bnxt_hwrm_clear_vnic_filter(bp);
+	if (!(bp->flags & BNXT_FLAG_CHIP_P5)) {
 		/* clear all RSS setting before free vnic ctx */
 		bnxt_hwrm_clear_vnic_rss(bp);
 		bnxt_hwrm_vnic_ctx_free(bp);
-		/* before free the vnic, undo the vnic tpa settings */
-		if (bp->flags & BNXT_FLAG_TPA)
-			bnxt_set_tpa(bp, false);
-		bnxt_hwrm_vnic_free(bp);
 	}
+	/* before free the vnic, undo the vnic tpa settings */
+	if (bp->flags & BNXT_FLAG_TPA)
+		bnxt_set_tpa(bp, false);
+	bnxt_hwrm_vnic_free(bp);
+	if (bp->flags & BNXT_FLAG_CHIP_P5)
+		bnxt_hwrm_vnic_ctx_free(bp);
+}
+
+static void bnxt_hwrm_resource_free(struct bnxt *bp, bool close_path,
+				    bool irq_re_init)
+{
+	bnxt_clear_vnic(bp);
 	bnxt_hwrm_ring_free(bp, close_path);
 	bnxt_hwrm_ring_grp_free(bp);
 	if (irq_re_init) {
-- 
2.5.1

