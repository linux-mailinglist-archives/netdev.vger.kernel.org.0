Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D27F118181
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLJHtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:49:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42861 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727143AbfLJHta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:49:30 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so8619748pfz.9
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 23:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KCSuzoERbC3uvEUQ55g93RZdtMRnq0f45xEFeCZ97rQ=;
        b=GV7gD80bSIJV5qkl4JE0rLIltdjNPR4LpDuBMXqn82itvceMchuXspV9TLv3YD14iV
         e36D2fHsFA2nHHMUQOqGo1xb5Jc6PC9fliQnHC+bh/ijEGI0o4EebDXbXi5WKojyJ40T
         qVtJWC4a3yr2ACHGsvBVsJIEu9OvcABCG38dM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KCSuzoERbC3uvEUQ55g93RZdtMRnq0f45xEFeCZ97rQ=;
        b=JNOIb2RZQlF0GjKsBpRgpQXEevuWtoW1fquxdpQq6yMETIdYzxnnPvl1BCrv3r23Qm
         55EzHYuyAWGA7MVwvhsrlkA6y91xm+srHyUXEelUC0RvLmbXEj5VX8Y6pLwuaCe1N3b5
         IfdOhYV09rOT69lTHFezKuNG7NiSyKG0S0jOZQSfU39iC43w47xCMJzf+kfyXeAyzhfQ
         VWuqSpglCsCJh2PD6jwyOwuBk2FUVLKZZt3c7anDcvabJa2oEySEMY6oV61jtQChFyWL
         BNsKpNjZS0/RwcXn42YDfyT5B650d4axZXSmnzFYIngWHF+xfQ10kSF6UkGhTnOHEK9U
         wIZQ==
X-Gm-Message-State: APjAAAWmWGCYbABp85BJjjiyPnp9K2TXH3DPqcgbLBrV41vaDSBr27JW
        +Ed66YEgin4eWaovsbvkVRWmVvW3F4w=
X-Google-Smtp-Source: APXvYqwrKMxznEHVvCbWrTbN5h5rZO2gzSX0CO6QCwpMpp0rwWBSqNG6DmAHvXdmhrkv1zG7CanYng==
X-Received: by 2002:a63:4723:: with SMTP id u35mr22457500pga.194.1575964169954;
        Mon, 09 Dec 2019 23:49:29 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm2108101pge.21.2019.12.09.23.49.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 23:49:29 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/7] bnxt_en: Free context memory in the open path if firmware has been reset.
Date:   Tue, 10 Dec 2019 02:49:08 -0500
Message-Id: <1575964153-11299-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
References: <1575964153-11299-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will trigger new context memory to be rediscovered and allocated
during the re-probe process after a firmware reset.  Without this, the
newly reset firmware does not have valid context memory and the driver
will eventually fail to allocate some resources.

Fixes: ec5d31e3c15d ("bnxt_en: Handle firmware reset status during IF_UP.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 85983f0..65c1c4e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8796,6 +8796,9 @@ static int bnxt_hwrm_if_change(struct bnxt *bp, bool up)
 		if (fw_reset) {
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 				bnxt_ulp_stop(bp);
+			bnxt_free_ctx_mem(bp);
+			kfree(bp->ctx);
+			bp->ctx = NULL;
 			rc = bnxt_fw_init_one(bp);
 			if (rc) {
 				set_bit(BNXT_STATE_ABORT_ERR, &bp->state);
-- 
2.5.1

