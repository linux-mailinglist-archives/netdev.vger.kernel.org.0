Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF53357865
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhDGXUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhDGXU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:20:28 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782FFC061760
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 16:20:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so2129290pjh.1
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 16:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LEdTzzJ3gkotOUEtB+vmtqn139+yQVRGV9zURMv9zhs=;
        b=qxrLrIL9zXYnAeKsvSBpMq2f9V0/ksLJydMVqEyb4FScBJFoac2WkJplt9FkvTBsmC
         05rbRRJ7GH8lib2EmS40ehMmia7uoWVYoMUKZe6Nes00KmRDhzgDGGa2uKIUStULoGL4
         d10mgjfJKPNzZ+9oCYUdIK2TKrZU9FhF/+s9t8z0JaqNqmOuavIUmWdg+lS8kHYbw53z
         6sMWf6q8GgTUhMH19ftJ2B0TndmvbM28q0mixDSq3saXReXSWZreZXgFt5DQU4rJZvI6
         jG6P2vbX3TJYsQKqiP11wOjBI4+qrmXW+fQLrhz/TMvAjx+kM4to4J481GdxQhStWDK4
         4J4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LEdTzzJ3gkotOUEtB+vmtqn139+yQVRGV9zURMv9zhs=;
        b=YfnQAJidu4f7Jw7GtDNx52X+wZ30ecOBZ9vL0kPLRq7KBnbacWI+r9v2oKSSUUs12T
         lBHCntrxGHE18ECrYBaPvD7/IERNfVTgD1x1886kIOprURlr6uEP2uWggL55CcaT2uHs
         nm7pqvF2kItdU1S784l0fyCUwUMj1jEzfJ1+AZ0TkzoGjuHeHrCal6ec02StB7qeZXaE
         Kj5X7F2nqaXFyM75c81B5WOK22GzwL9v43UgtkC0k3Yo8ykXJ4x4wRHpZDmFCZ6GdqCi
         SapvRmTo20/h0MJI/ZBE6RjR6eKQgQyBgOi3zQ5GdcwxIGCZ5FRNktosnvCPEUm7S6uE
         T9aQ==
X-Gm-Message-State: AOAM533s6uXuGVxxuMrM3Z9tXHIr6UK6NTJVv53eQTglUWzAtf+2CeKu
        vK0QSVh3sHEO2s7MLb/Cd1wMqpMii/mQFA==
X-Google-Smtp-Source: ABdhPJyTk+jiteDhE4hG2hT+7v5qTn6FdvGvLyNLpdOagyJObzfBYediM4KEpG/cq2KZ7IdAT7R+1w==
X-Received: by 2002:a17:90a:29a5:: with SMTP id h34mr1431811pjd.158.1617837616806;
        Wed, 07 Apr 2021 16:20:16 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g3sm21422171pfk.186.2021.04.07.16.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 16:20:16 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/8] ionic: re-start ptp after queues up
Date:   Wed,  7 Apr 2021 16:19:58 -0700
Message-Id: <20210407232001.16670-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210407232001.16670-1-snelson@pensando.io>
References: <20210407232001.16670-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When returning after a firmware reset, re-start the
PTP after we've restarted the general queues.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4e22e50922cd..8cf6477b9899 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2987,14 +2987,14 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 			goto err_txrx_free;
 	}
 
-	/* restore the hardware timestamping queues */
-	ionic_lif_hwstamp_set(lif, NULL);
-
 	clear_bit(IONIC_LIF_F_FW_RESET, lif->state);
 	ionic_link_status_check_request(lif, CAN_SLEEP);
 	netif_device_attach(lif->netdev);
 	dev_info(ionic->dev, "FW Up: LIFs restarted\n");
 
+	/* restore the hardware timestamping queues */
+	ionic_lif_hwstamp_set(lif, NULL);
+
 	return;
 
 err_txrx_free:
-- 
2.17.1

