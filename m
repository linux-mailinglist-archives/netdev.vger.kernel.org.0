Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3F6343E36
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhCVKoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:44:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229904AbhCVKnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:43:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CAAE61931;
        Mon, 22 Mar 2021 10:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409827;
        bh=h/7NZxyJTdtxn6ErvpBB/wUkK789lbNzLTv0zGToHNI=;
        h=From:To:Cc:Subject:Date:From;
        b=RUleBEDQbNtxr/XVMeTQB3bFCK8wL5IgFp+zAf7Q/XkDgePvbTFrcgBhLJExR6MtW
         5XdFWaD5JoJggZfhMaGXXEfCVkR6bhNKl7pSlawtXNRKZAeTP1dGZcRLbS5L6eN8Br
         loJqlQU0voQMzCKUeVLClq9+NOXy2egCF3KsG8tluTHz1TKqWB5Mmck3HQd2pBQVcb
         GOGWLAQTXP3oK1HPQXiojKhO8bS00wVpFf3xUYpV54l0g3/vdoJLet7zrWqnH+puEd
         Ds6YbxCgvhLgeOaKd6N562W/lm+SAk40FXtzXvJYCETrq3aRwtG8g6lQgLlCQq0G5l
         697DH6H7Y6Q5w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] misdn: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 11:43:31 +0100
Message-Id: <20210322104343.948660-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc warns about a pointless condition:

drivers/isdn/hardware/mISDN/hfcmulti.c: In function 'hfcmulti_interrupt':
drivers/isdn/hardware/mISDN/hfcmulti.c:2752:17: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 2752 |                 ; /* external IRQ */

Change this as suggested by gcc, which also fits the style of the
other conditions in this function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 7013a3f08429..8ab0fde758d2 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -2748,8 +2748,9 @@ hfcmulti_interrupt(int intno, void *dev_id)
 		if (hc->ctype != HFC_TYPE_E1)
 			ph_state_irq(hc, r_irq_statech);
 	}
-	if (status & V_EXT_IRQSTA)
-		; /* external IRQ */
+	if (status & V_EXT_IRQSTA) {
+		/* external IRQ */
+	}
 	if (status & V_LOST_STA) {
 		/* LOST IRQ */
 		HFC_outb(hc, R_INC_RES_FIFO, V_RES_LOST); /* clear irq! */
-- 
2.29.2

