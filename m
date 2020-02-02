Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5559814FC23
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 08:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgBBHmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 02:42:04 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41962 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbgBBHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 02:42:04 -0500
Received: by mail-pg1-f193.google.com with SMTP id l3so1922484pgi.8
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 23:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=heHEhZLlPAK1Kn7E7bJxfS5iagMismJ0YqkUIdApPqY=;
        b=Me70HNJxJs1eRrzUvNESpoa9uZubAmzrRLHL/XGO/S3oR2eBsv11kA/oGnUJBXYmI2
         zw0/NC0p3zasfSRU3u+ksddv0uJkq0Fcvz5S+aU72yrL0JJOXGu4V0v9bmbUin9xtave
         wvBq+XgBHzF4e6hM+2vn9Xekpm36cUZdi3H4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=heHEhZLlPAK1Kn7E7bJxfS5iagMismJ0YqkUIdApPqY=;
        b=ACjjXhJXKo9YYUmFgOSusLuvoyW5nshLHa7h66ThiV9i5AOfWto790soGoB/ktzZEb
         fN/i+1rXVa2Dii3yuMseYRlQFaV0ZEWV791Z1KcsP+hayL03xGcOXzeEt2bdiP5rIHzQ
         yrzXxBvZCMFS/8Syug82HS8klg3fg893lhjt0fW5i636hrmQh52sadj8sXWLv1KE9tdS
         A7xODvVh3IGaz44RG29OCPM/7zBvw52ZXYla1uoxzCICsaS5vL0FHHQBRD7gL78hNz0s
         0UMhAL9MEtWf/KlcrATcatOhOgnH1ycQTPhO0C0E/JLGtaBUY4NN72cicT4vDEktrPos
         UZxA==
X-Gm-Message-State: APjAAAVGnntZMZ7JboNCmtuEJIoRn3KzhRngLWo6xvfYVOIuCJOL5F+I
        Ya910OBgiVpMCBpWzMGJjWmoLA==
X-Google-Smtp-Source: APXvYqwCVemLQqO68lIinE6F3+tFpUk6EPHZwUFqOb7YMgYkRshxEENO01PoZRcDhQumi+QUf4Gm4Q==
X-Received: by 2002:a63:5ce:: with SMTP id 197mr19038506pgf.114.1580629322212;
        Sat, 01 Feb 2020 23:42:02 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm16223162pfm.136.2020.02.01.23.42.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Feb 2020 23:42:01 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/4] bnxt_en: Refactor logic to re-enable SRIOV after firmware reset detected.
Date:   Sun,  2 Feb 2020 02:41:35 -0500
Message-Id: <1580629298-20071-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
References: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put the current logic in bnxt_open() to re-enable SRIOV after detecting
firmware reset into a new function bnxt_reenable_sriov().  This call
needs to be invoked in the firmware reset path also in the next patch.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 483935b..0253a8f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9241,6 +9241,17 @@ void bnxt_half_close_nic(struct bnxt *bp)
 	bnxt_free_mem(bp, false);
 }
 
+static void bnxt_reenable_sriov(struct bnxt *bp)
+{
+	if (BNXT_PF(bp)) {
+		struct bnxt_pf_info *pf = &bp->pf;
+		int n = pf->active_vfs;
+
+		if (n)
+			bnxt_cfg_hw_sriov(bp, &n, true);
+	}
+}
+
 static int bnxt_open(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -9259,13 +9270,7 @@ static int bnxt_open(struct net_device *dev)
 		bnxt_hwrm_if_change(bp, false);
 	} else {
 		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
-			if (BNXT_PF(bp)) {
-				struct bnxt_pf_info *pf = &bp->pf;
-				int n = pf->active_vfs;
-
-				if (n)
-					bnxt_cfg_hw_sriov(bp, &n, true);
-			}
+			bnxt_reenable_sriov(bp);
 			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 				bnxt_ulp_start(bp, 0);
 		}
-- 
2.5.1

