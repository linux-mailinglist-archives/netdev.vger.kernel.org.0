Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DC81D1FE5
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 22:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387996AbgEMUPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 16:15:15 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:27845 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389808AbgEMUPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 16:15:11 -0400
Received: from localhost.localdomain ([93.22.149.176])
        by mwinf5d52 with ME
        id eLEy2200C3obZW503LEzLB; Wed, 13 May 2020 22:15:07 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 13 May 2020 22:15:07 +0200
X-ME-IP: 93.22.149.176
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, pradeepc@codeaurora.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] ath11k: Fix some resource leaks in error path in 'ath11k_thermal_register()'
Date:   Wed, 13 May 2020 22:14:54 +0200
Message-Id: <20200513201454.258111-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'thermal_cooling_device_register()' fails, we must undo what has been
allocated so far. So we must go to 'err_thermal_destroy' instead of
returning directly

In case of error in 'ath11k_thermal_register()', the previous
'thermal_cooling_device_register()' call must also be undone. Move the
'ar->thermal.cdev = cdev' a few lines above in order for this to be done
in 'ath11k_thermal_unregister()' which is called in the error handling
path.

Fixes: 2a63bbca06b2 ("ath11k: add thermal cooling device support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I'm not 100% confident with this patch.

- When calling 'ath11k_thermal_unregister()', we try to release some
  resources that have not been allocated yet. I don't know if it can be an
  issue or not.
- I think that we should propagate the error code, instead of forcing
  -EINVAL.
---
 drivers/net/wireless/ath/ath11k/thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/thermal.c b/drivers/net/wireless/ath/ath11k/thermal.c
index 259dddbda2c7..5a7e150c621b 100644
--- a/drivers/net/wireless/ath/ath11k/thermal.c
+++ b/drivers/net/wireless/ath/ath11k/thermal.c
@@ -174,9 +174,12 @@ int ath11k_thermal_register(struct ath11k_base *sc)
 		if (IS_ERR(cdev)) {
 			ath11k_err(sc, "failed to setup thermal device result: %ld\n",
 				   PTR_ERR(cdev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_thermal_destroy;
 		}
 
+		ar->thermal.cdev = cdev;
+
 		ret = sysfs_create_link(&ar->hw->wiphy->dev.kobj, &cdev->device.kobj,
 					"cooling_device");
 		if (ret) {
@@ -184,7 +187,6 @@ int ath11k_thermal_register(struct ath11k_base *sc)
 			goto err_thermal_destroy;
 		}
 
-		ar->thermal.cdev = cdev;
 		if (!IS_REACHABLE(CONFIG_HWMON))
 			return 0;
 
-- 
2.25.1

