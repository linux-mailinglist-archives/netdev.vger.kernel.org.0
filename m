Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1002E1643
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731240AbgLWC7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:59:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728863AbgLWCUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D290E229CA;
        Wed, 23 Dec 2020 02:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689990;
        bh=jLzGRxX7wGnjD1ePymmJU26q2mDCYyl+VD6tfsHXQjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPnh9927eb9as6I0bsMe5BtEUdl2qfUJTqlJbzvmOcp59bSpgOz/5dZuZvmGnTUMS
         20SXakHuVGiN3s2tg7247ZxUKCLDcAW3SZJ0b8SPA/uOYkN1NDxrORK2j0oOp0aMZu
         892j7G0lkpz70g0ahtq0miNt9dFxzR5Rjt0x/kEdt6QR/wy9HejRFV7t40utQbSy0c
         b1utCs3USQn/itCAO0yilEWyGFpYCGuNLMqTAMDRbO+V2XfWUfBcKU6jD3fYlsaKsI
         2ljqgKk8mfWnSsfUKKGnoCLMsausLQg7ZWgDsP6A4qo4Q6A2YAB9f85vN5yg03FI00
         od+4WQyeclp/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schiller <ms@dev.tdt.de>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 075/130] net/lapb: fix t1 timer handling for LAPB_STATE_0
Date:   Tue, 22 Dec 2020 21:17:18 -0500
Message-Id: <20201223021813.2791612-75-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 62480b992ba3fb1d7260b11293aed9d6557831c7 ]

1. DTE interface changes immediately to LAPB_STATE_1 and start sending
   SABM(E).

2. DCE interface sends N2-times DM and changes to LAPB_STATE_1
   afterwards if there is no response in the meantime.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/lapb/lapb_timer.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
index 8f5b17001a076..baa247fe4ed05 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -85,11 +85,18 @@ static void lapb_t1timer_expiry(struct timer_list *t)
 	switch (lapb->state) {
 
 		/*
-		 *	If we are a DCE, keep going DM .. DM .. DM
+		 *	If we are a DCE, send DM up to N2 times, then switch to
+		 *	STATE_1 and send SABM(E).
 		 */
 		case LAPB_STATE_0:
-			if (lapb->mode & LAPB_DCE)
+			if (lapb->mode & LAPB_DCE &&
+			    lapb->n2count != lapb->n2) {
+				lapb->n2count++;
 				lapb_send_control(lapb, LAPB_DM, LAPB_POLLOFF, LAPB_RESPONSE);
+			} else {
+				lapb->state = LAPB_STATE_1;
+				lapb_establish_data_link(lapb);
+			}
 			break;
 
 		/*
-- 
2.27.0

