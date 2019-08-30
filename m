Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBBA2DAA
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 05:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfH3Dzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 23:55:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41348 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbfH3Dzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 23:55:37 -0400
Received: by mail-pf1-f194.google.com with SMTP id 196so3664798pfz.8
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 20:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=19S0FgBRtfQKtRp0aQIQXEo34zNLxRBG3e/4JzTbSX4=;
        b=W/Go/Z3hT0DvmZc+D9vQAAa3kQt/21vZ/48fSPvUVtU821BhfGRIroQEh8e0XrBWP2
         BzIga1CussLQV3ljdhY4c9XtKtHuoxp4avkCvFQBoCu1qN+YhWK0E6XXAkM35BhSIX10
         hb9sU0b0M9MIOkL3iQE//v39UseOfPWYtxdwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=19S0FgBRtfQKtRp0aQIQXEo34zNLxRBG3e/4JzTbSX4=;
        b=WNJCupEP6FkQ5Y2MkH/1StJl1cNprgqZVOC9gxem61IVKeLMjl88o1nqeVdF4oT/h+
         CS+0rrRnRWh26lzD4aLR+LTyfpE/btEugRD9vc6KAxMYODtM3QsTvD6wEz3xPJGxsjOZ
         m2AKVTFMgvJy1nTGTo7t/OlUMIC3CmunootUE9r3iVWFfd8MVxstvyOKXyX391jIOdqp
         Ef8XQuHnWugjka2WzYfMiCPzpAyKLswgsmGpVDfvGGfiKHCcuCaF1vC5KeoxtgFyh2OA
         HUOHFAzFTnzksrzD3QxhCO8GxRo9sq5yDCOp1cGfW9nBFYkfxg/cobfFlzNDWJ42bOLb
         WKTA==
X-Gm-Message-State: APjAAAXHSLYzrH7hUps+NIXu5zOKcn50CacfyTbShrV2L2v16GEmBQpg
        N1o/r9lbrkzrxjtSny8THTVBfA==
X-Google-Smtp-Source: APXvYqxFEhpQsNiO1swTmC4z0faUQqd/tqhHfUlrhmHUV7GfI8qKV8bWc42sfk2BFGBam3QGsSVhbA==
X-Received: by 2002:a62:3887:: with SMTP id f129mr16065693pfa.245.1567137337061;
        Thu, 29 Aug 2019 20:55:37 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l3sm3658877pjq.24.2019.08.29.20.55.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 20:55:36 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        ray.jui@broadcom.com
Subject: [PATCH net-next v2 05/22] bnxt_en: Suppress all error messages in hwrm_do_send_msg() in silent mode.
Date:   Thu, 29 Aug 2019 23:54:48 -0400
Message-Id: <1567137305-5853-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the silent parameter is set, suppress all messages when there is
no response from firmware.  When polling for firmware to come out of
reset, no response may be normal and we want to suppress the error
messages.  Also, don't poll for the firmware DMA response if Bus Master
is disabled.  This is in preparation for error recovery when firmware
may be in error or reset state or Bus Master is disabled.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b9eb24e..3e48bcb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4155,6 +4155,9 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 	/* Ring channel doorbell */
 	writel(1, bp->bar0 + doorbell_offset);
 
+	if (!pci_is_enabled(bp->pdev))
+		return 0;
+
 	if (!timeout)
 		timeout = DFLT_HWRM_CMD_TIMEOUT;
 	/* convert timeout to usec */
@@ -4186,8 +4189,9 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (bp->hwrm_intr_seq_id != (u16)~seq_id) {
-			netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
-				   le16_to_cpu(req->req_type));
+			if (!silent)
+				netdev_err(bp->dev, "Resp cmpl intr err msg: 0x%x\n",
+					   le16_to_cpu(req->req_type));
 			return -EBUSY;
 		}
 		len = (le32_to_cpu(*resp_len) & HWRM_RESP_LEN_MASK) >>
@@ -4212,10 +4216,11 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (i >= tmo_count) {
-			netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
-				   HWRM_TOTAL_TIMEOUT(i),
-				   le16_to_cpu(req->req_type),
-				   le16_to_cpu(req->seq_id), len);
+			if (!silent)
+				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d\n",
+					   HWRM_TOTAL_TIMEOUT(i),
+					   le16_to_cpu(req->req_type),
+					   le16_to_cpu(req->seq_id), len);
 			return -EBUSY;
 		}
 
@@ -4230,10 +4235,12 @@ static int bnxt_hwrm_do_send_msg(struct bnxt *bp, void *msg, u32 msg_len,
 		}
 
 		if (j >= HWRM_VALID_BIT_DELAY_USEC) {
-			netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
-				   HWRM_TOTAL_TIMEOUT(i),
-				   le16_to_cpu(req->req_type),
-				   le16_to_cpu(req->seq_id), len, *valid);
+			if (!silent)
+				netdev_err(bp->dev, "Error (timeout: %d) msg {0x%x 0x%x} len:%d v:%d\n",
+					   HWRM_TOTAL_TIMEOUT(i),
+					   le16_to_cpu(req->req_type),
+					   le16_to_cpu(req->seq_id), len,
+					   *valid);
 			return -EBUSY;
 		}
 	}
-- 
2.5.1

