Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6042E12D
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhJNS2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:28:24 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:52544 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhJNS2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:28:23 -0400
Received: from pop-os.home ([92.140.161.106])
        by smtp.orange.fr with ESMTPA
        id b5QlmBA9UBazob5QlmY6yg; Thu, 14 Oct 2021 20:26:17 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Thu, 14 Oct 2021 20:26:17 +0200
X-ME-IP: 92.140.161.106
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     h.morris@cascoda.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ieee802154: Remove redundant 'flush_workqueue()' calls
Date:   Thu, 14 Oct 2021 20:26:14 +0200
Message-Id: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ieee802154/ca8210.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 3a2824f24caa..ece6ff6049f6 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2938,9 +2938,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
  */
 static void ca8210_dev_com_clear(struct ca8210_priv *priv)
 {
-	flush_workqueue(priv->mlme_workqueue);
 	destroy_workqueue(priv->mlme_workqueue);
-	flush_workqueue(priv->irq_workqueue);
 	destroy_workqueue(priv->irq_workqueue);
 }
 
-- 
2.30.2

