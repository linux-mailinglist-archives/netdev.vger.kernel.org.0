Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D4817D6DD
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 23:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCHWqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 18:46:18 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41166 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgCHWqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 18:46:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id b1so3826486pgm.8
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 15:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sIhLz3JqshierJBCPK3n6bnAOk/E9mLpFiyDts6FU0Y=;
        b=ZUBkhBqgBnO2XTup3rb5q99OJFU8+xKN1O0PZaaFNnBKVEoDSgurGH+njONR2rW6Gf
         JnYOenZlemca0LpLylAvRhN6BFksFPK83FG81Tr5gsVzcEkfWSPrZobeiVvCe5RFwn0I
         xlz/yNYqY0gsTrP7UTNS258l1H1w9EF7sGUkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sIhLz3JqshierJBCPK3n6bnAOk/E9mLpFiyDts6FU0Y=;
        b=YJRnr8Xoe1AOVYQ8xINu2YDYe4W7ep1CFomrRArBjdaJ5YJXvPbp4XnXQrKg24FYXI
         UHOaFLIPS20no6+S9E5JqhfViyzleR5K7dZthJREBkJLIGtWjtLe6iyx0d+RFW+zGb7q
         nbxpVehFEBPAOhVW9jYh3+d12sQEruuMh5PeoTpyb8xZp6YlfUcPvyOlsTq7bjyTdIDy
         uQB+eTYvcGe3udxyQK8gQMwdjB810yqfPCUkX17gAsexcrQHDpb2156iwrZ0s2Ylh6oO
         namrjEXTjt0CLmmSvvb80BWNLwl4STKtEEfraMVn7tgO0QaKfPcsUflDy6KZ+eKgQHZa
         G+OA==
X-Gm-Message-State: ANhLgQ3MaSjgVijvCeODgrh0jhDwJBQLuXejPWYQvyDWd7V8/5C92PYb
        HnActh/QXVxD8f4fYXFCJCeKlw==
X-Google-Smtp-Source: ADFU+vsmf/8SGOASn9KcEHTNkoe1ori5kGb6LF8xLkZabSnpvEPZrJXm72SRMJicQcgzGitdkYmJRw==
X-Received: by 2002:aa7:84c6:: with SMTP id x6mr13412022pfn.181.1583707576372;
        Sun, 08 Mar 2020 15:46:16 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x66sm31241397pgb.9.2020.03.08.15.46.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Mar 2020 15:46:15 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 4/8] bnxt_en: Clear DCB settings after firmware reset.
Date:   Sun,  8 Mar 2020 18:45:50 -0400
Message-Id: <1583707554-1163-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
References: <1583707554-1163-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver stores a copy of the DCB settings that have been applied to
the firmware.  After firmware reset, the firmware settings are gone and
will revert back to default.  Clear the driver's copy so that if there
is a DCBNL request to get the settings, the driver will retrieve the
current settings from the firmware.  lldpad keeps the DCB settings in
userspace and will re-apply the settings if it is running.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 634b1bd..500d4c8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8787,6 +8787,7 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 			bnxt_free_ctx_mem(bp);
 			kfree(bp->ctx);
 			bp->ctx = NULL;
+			bnxt_dcb_free(bp);
 			rc = bnxt_fw_init_one(bp);
 			if (rc) {
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
-- 
2.5.1

