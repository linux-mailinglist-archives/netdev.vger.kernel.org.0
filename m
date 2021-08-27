Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE06D3F9F46
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 20:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhH0S4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 14:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbhH0S4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 14:56:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0154DC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:24 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 7so6420590pfl.10
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 11:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qDj+peibpF6aWHTuweOTmL1ikJ2XXD7k5JRDbYtvR+c=;
        b=RJfuwMzNaHoYFucd2um+N7RIXTZQq7J2VH1WYGyRXTfkRYUMhewKtBmKb+RRgZMDpJ
         obVOcvjwPuFahcZwxqiF73Jl7Du0YWu9cVqullhwgegSmv+tInGNHaA4xHoNN6sD1FF8
         4vEMDc66AAkMwpjewx6QVnVfLx0rwqFa3f/3cK5yy3WTA3IZ+akMYzB1IjxD7pfpuGvT
         0AJn8L+gnWXci40M41/m5BWluoVnHYftD1g/tos0GekiL9GtyPWqftMRrHB7vKGp4vkt
         bWuV5M5rkZhsI5nJzPdzrX+HWAwrLKVFkOOt4WzsQ2U6HUSc0wRMlX/7esi8A4vKcOHs
         KF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qDj+peibpF6aWHTuweOTmL1ikJ2XXD7k5JRDbYtvR+c=;
        b=m3eIkT0dxnfs7OYILYbHXTKDNoYP54rJHZSGpcouwinPWZN69M50ytxIg44EX1TM2k
         eQaTRV2ehZNT+4qgmVdMVN9KoAZxPoPtEotgesii5Jyc67CN91RkV8KSzLD/pMMAOmzh
         221eWrFebX4WDqFV/W3VZ9ChMtsz4Np2slnOu76OezOi/reo+bQAmTBIGp5qmLYKusfJ
         Q8nqWa0xbNaZqzEa5RTjvnUeJOhXDTgrILZCeanW/9fclOMsh7oQACCR72q6pUP9pBh0
         BLuemZ0tiuFoGFDEcQJj3CRn0tmQasq9bfOPh5g+vqO8JmEXz3pJwZnZgFYh83fSaGb2
         vx+w==
X-Gm-Message-State: AOAM53027sWaVIVS7InvAk3ylhQawMdfNJdnXxoYCbV9lSG3hfuugAAt
        AU7R44gMgZ3xTR3VAD9oeAwR7w==
X-Google-Smtp-Source: ABdhPJy6wKXe42UwyoJuyYvZdm+J0IzQ57O5dBivH+w5XHHSzHqQKSssNgVJ2Hnq/ioiD3iaFMRguw==
X-Received: by 2002:aa7:8e4e:0:b029:3e0:28db:d73b with SMTP id d14-20020aa78e4e0000b02903e028dbd73bmr10371477pfr.8.1630090523566;
        Fri, 27 Aug 2021 11:55:23 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id f10sm7565975pgm.77.2021.08.27.11.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 11:55:22 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: fire watchdog again after fw_down
Date:   Fri, 27 Aug 2021 11:55:07 -0700
Message-Id: <20210827185512.50206-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210827185512.50206-1-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases of fw_down it was called because there was a
fw_generation change, and the firmware is already back up.
In order to keep the down time to a minimum, don't wait for
the next watchdog polling cycle, fire another watchdog off
as soon as we can - an out-of-cycle check won't hurt, and
may well speed up the recovery.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e494d6b909c7..df0137044c03 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -93,10 +93,17 @@ static void ionic_lif_deferred_work(struct work_struct *work)
 			ionic_link_status_check(lif);
 			break;
 		case IONIC_DW_TYPE_LIF_RESET:
-			if (w->fw_status)
+			if (w->fw_status) {
 				ionic_lif_handle_fw_up(lif);
-			else
+			} else {
 				ionic_lif_handle_fw_down(lif);
+
+				/* Fire off another watchdog to see
+				 * if the FW is already back rather than
+				 * waiting another whole cycle
+				 */
+				mod_timer(&lif->ionic->watchdog_timer, jiffies + 1);
+			}
 			break;
 		default:
 			break;
-- 
2.17.1

