Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CE034409B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 13:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhCVMPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 08:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhCVMPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 08:15:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73A016196F;
        Mon, 22 Mar 2021 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616415300;
        bh=9XRfjBpAAKr1LuYTDPxAQk/Vc1HEIU4R46I0OKcvdyA=;
        h=From:To:Cc:Subject:Date:From;
        b=kWrFeu94yiks68xf9Su1xbk0lhpBE2tdzQhBZCjDfmibnTj7S8BNNPFioYPsgTJxX
         ZqG15QgONoDZCsHAq7x1CX4S2PsWZyEGHbFpaINZ0UqSaOLCmRkURQFIZPy0XxwWc7
         zronma+/2bvp48sGebVqG7k8NdkQFqwVJWpFnmjWj04ResVi+Fx9dRhpGLnDdO32vh
         cbcP/xvg4vwGPBrG+k1zNRZIgE4ms1McyAGib5eGDzj1I3fIlG7p0XTmdWh27A9ISk
         Lw9kfTYpQlVcwZ/D2CiF7ivFhXIZ30/HMIrILQh5XEvUalbiq6XOd4AxnMNIENS1Fm
         tHR+u450YvznA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Leon Romanovsky <leon@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] [v2] misdn: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 13:14:47 +0100
Message-Id: <20210322121453.653228-1-arnd@kernel.org>
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

As the check has no effect, just remove it.

Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: remove the line instead of adding {}
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 7013a3f08429..14092152b786 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -2748,8 +2748,6 @@ hfcmulti_interrupt(int intno, void *dev_id)
 		if (hc->ctype != HFC_TYPE_E1)
 			ph_state_irq(hc, r_irq_statech);
 	}
-	if (status & V_EXT_IRQSTA)
-		; /* external IRQ */
 	if (status & V_LOST_STA) {
 		/* LOST IRQ */
 		HFC_outb(hc, R_INC_RES_FIFO, V_RES_LOST); /* clear irq! */
-- 
2.29.2

