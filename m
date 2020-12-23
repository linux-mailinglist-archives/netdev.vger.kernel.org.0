Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E272E14F7
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLWCqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:46:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729679AbgLWCW2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB2D4225AC;
        Wed, 23 Dec 2020 02:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690130;
        bh=HfVA3vP2LuBtbMR4z27FBgM5pcDNqiAe2EtyXsfKt8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s+zbhVy9ZeicbcQHVgvUUCI8M3BZ1D4cIei5J9CNurZZs2XYEkBAGeC3vWmDKLLgs
         d9eIwsLyqapVLd1cT2AZF2izIqcXSIUlhsbOuEzvYEDzs7fh8WAN/PVU7uaYmkVorR
         5lq+Y4sBmZ+tgy5v7tscY+RJnb+MP35/fflTHsmaWH3U+PScopNKwGiIrsSxGmo2K0
         nJCInXbyIP66FD7+4X++4fq4JjRxR8LKoL2kqMqpU7h3wbEADUcfuGcX7ZioIfio/n
         R4yKtdDKq3+OtK6+Uqi9n+XrxbFXNOYgTmdJ7Wr9Ztu73zaK1sfboj99xtMSGWM0pp
         FcLg9kWZsJRxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Schiller <ms@dev.tdt.de>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 54/87] net/lapb: fix t1 timer handling for LAPB_STATE_0
Date:   Tue, 22 Dec 2020 21:20:30 -0500
Message-Id: <20201223022103.2792705-54-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index 5d4ae01951b56..51fc09fa41247 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -90,11 +90,18 @@ static void lapb_t1timer_expiry(struct timer_list *t)
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

