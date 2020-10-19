Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6BA2926D4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgJSL4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:56:04 -0400
Received: from m15114.mail.126.com ([220.181.15.114]:53640 "EHLO
        m15114.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSL4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 07:56:03 -0400
X-Greylist: delayed 1855 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 07:56:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=BMUY5GjtFzTai0Y5GG
        +2gzfUve2D878aEo2Z6x6PbUM=; b=aRhrEUMwSjvaH48e/J3gJul9rdWk+FIJSH
        L0HD3FYyabiPRI5bd7Z5OuUNEYSWhjqZ3A1B+kLx1zBPCETBGFrppEdQTNuplxr6
        BdvXSebeK2g9coNmT6oaFJv5hBbHoTFTX921FCISUYwVTHwW2g/nJ8uKKToqw3E7
        OIivtWrQE=
Received: from localhost.localdomain (unknown [36.112.86.14])
        by smtp7 (Coremail) with SMTP id DsmowACnrW0cd41fgBoPKQ--.45370S2;
        Mon, 19 Oct 2020 19:23:09 +0800 (CST)
From:   Defang Bo <bodefang@126.com>
To:     siva.kallam@broadcom.com, prashant@broadcom.com,
        mchan@broadcom.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Defang Bo <bodefang@126.com>
Subject: [PATCH] tg3: Avoid NULL pointer dereference in netif_device_attach()
Date:   Mon, 19 Oct 2020 19:22:47 +0800
Message-Id: <1603106567-4589-1-git-send-email-bodefang@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: DsmowACnrW0cd41fgBoPKQ--.45370S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF17trW7Jw17GFy5Kr1xZrb_yoW3Crc_KF
        1UZrZ3Cr4UGr9FkF4Ykr43Ary5Ka1qvayF9F1Iv3yaqrZFkr1UJF4kZrn3ArnrWrWUJFyD
        Jr1aqFWfJw4UKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1JGYtUUUUU==
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbitR3C11pECOj-eQAAsF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit<1b0ff89852d7>("tg3: Avoid NULL pointer dereference in tg3_io_error_detected()")
This patch avoids NULL pointer dereference add a check for netdev being NULL on tg3_resume().

Signed-off-by: Defang Bo <bodefang@126.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ebff1fc..ae756dd 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -18099,7 +18099,7 @@ static int tg3_resume(struct device *device)
 
 	rtnl_lock();
 
-	if (!netif_running(dev))
+	if (!netdev || !netif_running(dev))
 		goto unlock;
 
 	netif_device_attach(dev);
-- 
1.9.1

