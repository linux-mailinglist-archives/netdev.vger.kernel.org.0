Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9931D25C8B3
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbgICS3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 14:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgICS3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 14:29:04 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D961C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 11:29:04 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 67so2780868pgd.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 11:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=AaLcITQx9GcpvfBgIut8d9l0IkGgLOY8hWkZaEL339Y=;
        b=B9O6xqyr8igoZd/JUUcJyOnyaCGB/oHP1oz0q1VQOHExSIKc7oIXQ53gzMnQ27z46O
         7atyvfBAp/mT1XuHkn1RDm/FtxQQLDNHfP2mN2h6/QY9/ALljqsyfnDpXpZQvMmDRxmO
         7YUvvfzj9l6sSWwdEgGsldIC3D1DuJKS2U01Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AaLcITQx9GcpvfBgIut8d9l0IkGgLOY8hWkZaEL339Y=;
        b=pIA2//k//2WTIdTlM3jzK97Pdw86FzjAUE4sbBPt8D8RWCB9ENoUyWX5RSxho0cE+o
         glACHFRlacmflcl5e66e8zlHzWdaZ0Ixv0ELiMqHEng7Q6NpQkfdxKpqxxMhLESfHxKZ
         MqWoDVRsfofENcwozQmuzpfiQyIbC+AHoMEu4mQ3JPo7F38mfZhSuma6tqz5EDd+lXd+
         9XTNB1ovdcMY5yMrEiT1yz3VZkwf7YbZZejyFOARy33Mvm2PW9P9UGT4yNgpvhPnOen1
         ctbycp2V52BeaDmQpE/TPxu3ICI5vF6Z1QoI0T5gOVB4QbCEip4GUJ5JjgQtg9NqxU6J
         ttHQ==
X-Gm-Message-State: AOAM533IvqxE7TbqXbuxSNVzJOIZFTAaLDv92dw/BuLeRdcDSNGwU7E1
        hCr8i9LWdGDaWN556Ddi8Cl4woWP2uGMlg==
X-Google-Smtp-Source: ABdhPJyUz8cAMh/gOkDcL4YX1kbAs62LyGSQl4nFiclvAJTCy/Rea6nF93Y24f+9okvgu4DViH0CSA==
X-Received: by 2002:aa7:9598:: with SMTP id z24mr5086537pfj.223.1599157743367;
        Thu, 03 Sep 2020 11:29:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q193sm3954389pfq.127.2020.09.03.11.29.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Sep 2020 11:29:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, drc@linux.vnet.ibm.com,
        baptiste@arista.com
Subject: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
Date:   Thu,  3 Sep 2020 14:28:54 -0400
Message-Id: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If tg3_reset_task() fails, the device state is left in an inconsistent
state with IFF_RUNNING still set but NAPI state not enabled.  A
subsequent operation, such as ifdown or AER error can cause it to
soft lock up when it tries to disable NAPI state.

Fix it by bringing down the device to !IFF_RUNNING state when
tg3_reset_task() fails.  tg3_reset_task() running from workqueue
will now call tg3_close() when the reset fails.  We need to
modify tg3_reset_task_cancel() slightly to avoid tg3_close()
calling cancel_work_sync() to cancel tg3_reset_task().  Otherwise
cancel_work_sync() will wait forever for tg3_reset_task() to
finish.

Reported-by: David Christensen <drc@linux.vnet.ibm.com>
Reported-by: Baptiste Covolato <baptiste@arista.com>
Fixes: db2199737990 ("tg3: Schedule at most one tg3_reset_task run")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ebff1fc..4515804 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7221,8 +7221,8 @@ static inline void tg3_reset_task_schedule(struct tg3 *tp)
 
 static inline void tg3_reset_task_cancel(struct tg3 *tp)
 {
-	cancel_work_sync(&tp->reset_task);
-	tg3_flag_clear(tp, RESET_TASK_PENDING);
+	if (test_and_clear_bit(TG3_FLAG_RESET_TASK_PENDING, tp->tg3_flags))
+		cancel_work_sync(&tp->reset_task);
 	tg3_flag_clear(tp, TX_RECOVERY_PENDING);
 }
 
@@ -11209,18 +11209,27 @@ static void tg3_reset_task(struct work_struct *work)
 
 	tg3_halt(tp, RESET_KIND_SHUTDOWN, 0);
 	err = tg3_init_hw(tp, true);
-	if (err)
+	if (err) {
+		tg3_full_unlock(tp);
+		tp->irq_sync = 0;
+		tg3_napi_enable(tp);
+		/* Clear this flag so that tg3_reset_task_cancel() will not
+		 * call cancel_work_sync() and wait forever.
+		 */
+		tg3_flag_clear(tp, RESET_TASK_PENDING);
+		dev_close(tp->dev);
 		goto out;
+	}
 
 	tg3_netif_start(tp);
 
-out:
 	tg3_full_unlock(tp);
 
 	if (!err)
 		tg3_phy_start(tp);
 
 	tg3_flag_clear(tp, RESET_TASK_PENDING);
+out:
 	rtnl_unlock();
 }
 
-- 
1.8.3.1

