Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19891833C2
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 16:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732951AbfHFORf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 10:17:35 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:60488 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732881AbfHFORf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 10:17:35 -0400
Received: from localhost.localdomain ([90.33.211.207])
        by mwinf5d41 with ME
        id lqHT2000N4V2DRm03qHTd8; Tue, 06 Aug 2019 16:17:32 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 06 Aug 2019 16:17:32 +0200
X-ME-IP: 90.33.211.207
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tglx@linutronix.de, gregkh@linuxfoundation.org,
        colin.king@canonical.com, davem@davemloft.net, allison@lohutok.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] nfc: st-nci: Fix an incorrect skb_buff size in 'st_nci_i2c_read()'
Date:   Tue,  6 Aug 2019 16:16:40 +0200
Message-Id: <20190806141640.13197-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 'st_nci_i2c_read()', we allocate a sk_buff with a size of
ST_NCI_I2C_MIN_SIZE + len.

However, later on, we first 'skb_reserve()' ST_NCI_I2C_MIN_SIZE bytes, then
we 'skb_put()' ST_NCI_I2C_MIN_SIZE bytes.
Finally, if 'len' is not 0, we 'skb_put()' 'len' bytes.

So we use ST_NCI_I2C_MIN_SIZE*2 + len bytes.

This is incorrect and should already panic. I guess that it does not occur
because of extra memory allocated because of some rounding.

Fix it and allocate enough room for the 'skb_reserve()' and the 'skb_put()'
calls.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is LIKELY INCORRECT. So think twice to what is the correct
solution before applying it.
Maybe the skb_reserve should be axed or some other sizes are incorrect.
There seems to be an issue, that's all I can say.
---
 drivers/nfc/st-nci/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/i2c.c b/drivers/nfc/st-nci/i2c.c
index 55d600cd3861..12e0425131c8 100644
--- a/drivers/nfc/st-nci/i2c.c
+++ b/drivers/nfc/st-nci/i2c.c
@@ -126,7 +126,7 @@ static int st_nci_i2c_read(struct st_nci_i2c_phy *phy,
 		return -EBADMSG;
 	}
 
-	*skb = alloc_skb(ST_NCI_I2C_MIN_SIZE + len, GFP_KERNEL);
+	*skb = alloc_skb(ST_NCI_I2C_MIN_SIZE * 2 + len, GFP_KERNEL);
 	if (*skb == NULL)
 		return -ENOMEM;
 
-- 
2.20.1

