Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F9E90B04
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfHPWdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:33:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36552 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbfHPWdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:33:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so3835352pfi.3
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 15:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rxL5y7YaD04cP670iBmD2nywSIyet51sHNRpYeZgX2o=;
        b=SROrdmfr2Ihn29YGmK+k9cngP7EyaQA5/AuWDRLgJjPxDd7cTLBkZm2haIO/KIgshA
         RB49i2lbcaitS2Oa8nh+8sdPYGrFCMMueAhX3RbgGzmGj/Seihf7EgKAFiL/mPpbwXHF
         zV5SV/+LSQ1qlAlZaHiOLR9FQJaqEkrdja65w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rxL5y7YaD04cP670iBmD2nywSIyet51sHNRpYeZgX2o=;
        b=Zqs/3lAwbWC+fgB6Es3/QEjnaZiMMwHU4sTp6SqJwzxLGLL1/buqaUhgt7oK2HVhsg
         1vhLIGR3zME8XHOA3vCsCfug6BlYrTqCvsGKBICxMBlVwLXiJm41fVFz7YAy6N7Zd+y1
         q4PVN1sEVDtxyAZn9Qe6C+8LlhrVb1snYtCW9Fz+/jRKqXk87ToNEDWjcsDTermBTkxz
         JlrW/ljCf+JrrEk5Tnka4me9g5kwuzapKPn83mNdIy5Rgiqj8tGJu8PEQmMjmXq/JjpX
         Eo1wfZgvzhofYMHNuZjmRc82W1EOBhJdpzOgZNn8fuaA7h1DUCq9t1PsP/eNF+8wZDzw
         jFcA==
X-Gm-Message-State: APjAAAV6iVGyz7rmmf8gsGtv+G9e3rdPdv0tgVcUmjR9TcaDzSMm+nZF
        DMfhtgicD93aGOSi3POOAAhtKFs5j/M=
X-Google-Smtp-Source: APXvYqzUdEDkQWWFWOaxeDod2X+7b8JfDmw0oVWwCfr8UH+31rmADGagYJTJwRXayBYGMi3t7wLJKQ==
X-Received: by 2002:a05:6a00:c7:: with SMTP id e7mr12988578pfj.52.1565994829619;
        Fri, 16 Aug 2019 15:33:49 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o35sm5728404pgm.29.2019.08.16.15.33.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 15:33:49 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/6] bnxt_en: Fix VNIC clearing logic for 57500 chips.
Date:   Fri, 16 Aug 2019 18:33:32 -0400
Message-Id: <1565994817-6328-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
References: <1565994817-6328-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During device shutdown, the VNIC clearing sequence needs to be modified
to free the VNIC first before freeing the RSS contexts.  The current
code is doing the reverse and we can get mis-directed RX completions
to CP ring ID 0 when the RSS contexts are freed and zeroed.  These
mis-directed packets may cause the driver to crash.  The clearing
of RSS contexts is not required with the new sequence.

Refactor the VNCI clearing logic into a new function bnxt_clear_vnic()
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

