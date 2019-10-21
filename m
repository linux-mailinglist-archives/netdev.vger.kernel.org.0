Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2051EDE3C4
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfJUFfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:35:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42592 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:35:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id q12so7662476pff.9
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OIrHq73h/ck34y8lyQiYV7PaDJy7NtAqAXaW1N0mX0A=;
        b=NtjVVWDW6+G9LGYMNXrdIHEgxQz9t1UZfkC9JF8c5sZvjmwu3kDEOH564siIfyRoA5
         y768vkFq5yMO9m9i0WbPAqDUpk4mNDSLo3+F1uOfOS4b9ioW29x+rnJ1ZdR1i9ETdOfG
         EgtH091Lw6C09AsCE0R1Bem+zKc6wmKE6sgfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OIrHq73h/ck34y8lyQiYV7PaDJy7NtAqAXaW1N0mX0A=;
        b=MbSFBOsd54+5WUcmU7mtxG7ZbD/K6ec0BGfZmfs/+fjVIuisopHWnbso2nbzwf3WaO
         raWULzfmZVxoSbt3tuRxaqz51wEEDDlUEH1Ui11vATSYfwP0zaeUVIgDK1eEic0mYyRB
         n2185WGL5zKnobJzcDCozhPi6M9ECFpta3BYx2a7rJaaVZsvKmV/2TL0bo70jB3mH+Gp
         ytPG5nbw8He2f5qrFk46yfVL/eHXDhxHmPFaaG587qbOMCsp0aYwMuY6mvLWiBcLkxUh
         ne7+DLPtXxGUCkfQSFkV6oiC8IFC/LXC7DiVTCk8f7QXF3+Fg+CDTiWZl0D9nd4H1v6H
         RJwg==
X-Gm-Message-State: APjAAAWShRiBSPRyxjZueGBIfZkJ3vG20GZp896VxX/Eayyt9nSQcHjU
        rSaVXswDJ3EKHPIqxmsZCkfxJYB/zJQ=
X-Google-Smtp-Source: APXvYqxXPrQeJ+dgHrZ6Cj3m74Hn72o5fSsshdUXHeMMV5R1JCIjG9DNBP5PZx0dEi+X7/FTyBAipA==
X-Received: by 2002:aa7:8583:: with SMTP id w3mr21715520pfn.182.1571636098046;
        Sun, 20 Oct 2019 22:34:58 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.34.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:34:57 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com
Subject: [PATCH net 3/5] bnxt_en: Adjust the time to wait before polling firmware readiness.
Date:   Mon, 21 Oct 2019 01:34:27 -0400
Message-Id: <1571636069-14179-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

When firmware indicates that driver needs to invoke firmware reset
which is common for both error recovery and live firmware reset path,
driver needs a different time to wait before polling for firmware
readiness.

Modify the wait time to fw_reset_min_dsecs, which is initialised to
correct timeout for error recovery and firmware reset.

Fixes: 4037eb715680 ("bnxt_en: Add a new BNXT_FW_RESET_STATE_POLL_FW_DOWN state.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b4a8cf6..8492618 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10669,14 +10669,11 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_RESET_FW;
 	}
 	/* fall through */
-	case BNXT_FW_RESET_STATE_RESET_FW: {
-		u32 wait_dsecs = bp->fw_health->post_reset_wait_dsecs;
-
+	case BNXT_FW_RESET_STATE_RESET_FW:
 		bnxt_reset_all(bp);
 		bp->fw_reset_state = BNXT_FW_RESET_STATE_ENABLE_DEV;
-		bnxt_queue_fw_reset_work(bp, wait_dsecs * HZ / 10);
+		bnxt_queue_fw_reset_work(bp, bp->fw_reset_min_dsecs * HZ / 10);
 		return;
-	}
 	case BNXT_FW_RESET_STATE_ENABLE_DEV:
 		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) &&
 		    bp->fw_health) {
-- 
2.5.1

