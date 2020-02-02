Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4314FC24
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 08:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgBBHmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 02:42:05 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36282 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgBBHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 02:42:04 -0500
Received: by mail-pg1-f194.google.com with SMTP id k3so6029763pgc.3
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 23:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mhf+VsE3tCkoIGrtpDwt8G/tRYIsrtw5lnkkInWnm8o=;
        b=HKOo4jZ4Ee3nttc0FvoKXDu2mZJfws51+alzJYZUkN1dkJzgbbK+F0wqq6s6ay1WaH
         ueDr+NKBcUZGfwaMRhbhFGAVTIJiq1Jaj2YoCtR1+iPfwl0EyUP+628LYeRvMuq1oXmz
         2vvJHmL6qAqG4ARl2zmiyBb1RX7Zx5Qsl14oM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mhf+VsE3tCkoIGrtpDwt8G/tRYIsrtw5lnkkInWnm8o=;
        b=UmUsmmqXLZbJwzn/tHqbjMuegedjnDKi1TBfi/XhjaM5QNL4Is8Po+zXQeWiimntYG
         GYo0xt5+rRQly2yisAJ1mGnlGDGNBImvmZck0zOrqwwoU2/PTkW+018vdlvDFnxPEF1T
         anHIy8Fd2Iz/ELl9KQNnw3yKQyyQbZKr8792qV6lVCpq694pLyFrwXPX5I+PhD89/ekB
         CQ3Ud+JKcHNAT1joEcUNSfASANz4RIsZ9gX3q7yItR+EZzadYZglQQYnyuxJtr1RG3Ob
         TovMkTNDnAMnMLdyKoYHkyDKRIM3vkWLMtxDMdsRK9XMDshpMP03RECuDOBqo/EMbdPE
         T+Tw==
X-Gm-Message-State: APjAAAXj/Hfccb654ZxVhRJO09Ym0DrrslEaqG8fFmfFgu7DQNknERxa
        5wPN6AZh4AdNgv9+V+nsRLxahg==
X-Google-Smtp-Source: APXvYqyHJk5u0BaECPNtqJD6WHZMtCRfGhI/JQgk1DIRpprYejD3S/Ri6UErYe5HOB/XSuLx1H3/6w==
X-Received: by 2002:a63:5b59:: with SMTP id l25mr19784089pgm.382.1580629324229;
        Sat, 01 Feb 2020 23:42:04 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y21sm16223162pfm.136.2020.02.01.23.42.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Feb 2020 23:42:03 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/4] bnxt_en: Fix RDMA driver failure with SRIOV after firmware reset.
Date:   Sun,  2 Feb 2020 02:41:36 -0500
Message-Id: <1580629298-20071-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
References: <1580629298-20071-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt_ulp_start() needs to be called before SRIOV is re-enabled after
firmware reset.  Re-enabling SRIOV may consume all the resources and
may cause the RDMA driver to fail to get MSIX and other resources.
Fix it by calling bnxt_ulp_start() first before calling
bnxt_reenable_sriov().

We re-arrange the logic so that we call bnxt_ulp_start() and
bnxt_reenable_sriov() in proper sequence in bnxt_fw_reset_task() and
bnxt_open().  The former is the normal coordinated firmware reset sequence
and the latter is firmware reset while the function is down.  This new
logic is now more straight forward and will now fix both scenarios.

Fixes: f3a6d206c25a ("bnxt_en: Call bnxt_ulp_stop()/bnxt_ulp_start() during error recovery.")
Reported-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0253a8f..a69e4662 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9270,9 +9270,10 @@ static int bnxt_open(struct net_device *dev)
 		bnxt_hwrm_if_change(bp, false);
 	} else {
 		if (test_and_clear_bit(BNXT_STATE_FW_RESET_DET, &bp->state)) {
-			bnxt_reenable_sriov(bp);
-			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+			if (!test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
 				bnxt_ulp_start(bp, 0);
+				bnxt_reenable_sriov(bp);
+			}
 		}
 		bnxt_hwmon_open(bp);
 	}
@@ -10836,6 +10837,8 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		smp_mb__before_atomic();
 		clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 		bnxt_ulp_start(bp, rc);
+		if (!rc)
+			bnxt_reenable_sriov(bp);
 		bnxt_dl_health_recovery_done(bp);
 		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
-- 
2.5.1

