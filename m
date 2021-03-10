Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298923347E8
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbhCJT1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhCJT1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 14:27:06 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C62C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so8057856pjg.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 11:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DG8uZxHo/gy5KMRZ/L9VunAlbH0cVegZatFW6irGEUw=;
        b=cEQDkDmeJQFZ54QaTCnzUvVaadSg2C3QpC5N/dcVszrpGTHWFJxXl2Q1d+Qw/cYwX1
         74Gk007epZ9GsPilNthUEv83VwrJFooxxO/LsdVONxHhW+GXU+rDMKoLDnlNLeYR9bjo
         Rcs+1JqNrzclUS1f+3feXoJsOSFq6Tb0OZ9PwODgWQxxyZHlqHOVkaaU+PeOEWmogVdU
         1G9vu2CiG7UeY1kNKUNUw8hXW5LTy04WykUgM5/1hHitSd8UC76Yg0P1+Chpt5N0VdB6
         Co7T1dKQGTWavR+qL8CsLuAAhvNj38OoyZlthduYp07WuMJOPBy+WTT6xFguWzHnmrM9
         E5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DG8uZxHo/gy5KMRZ/L9VunAlbH0cVegZatFW6irGEUw=;
        b=dXOX6nKIKSaxUx7PPFuevThMxEi76YZv5raMSkBD/vrf9jbl6h8rKsEWE7iNX1Djjk
         B5qJFr3TKirxfLvEI24EZbIRIjDXEwUxhdO37v3wJ1M9DRpp8hlQPORPCMZoH7tctHYm
         pmiZzd1lILmMavMI5IvRpmbmKfiSW16Rd6bILlP4KHED0g1KAn2uH2Qxf4sfDqf+7tWW
         yU4v9qiJfvJM70/P0WdmuOULFFUdE+VZghGu/+ZMYT0bz8N/+BCJ14dtVskJBniTbEgp
         YWWBckkUML1Ig33TqkE7nZ+/+3t3BXRonqJLdfZEQDSiGKn+1Z54GsQZShZpmEFr1W8v
         /KIw==
X-Gm-Message-State: AOAM531SoeUZb/wP6D9xgfIBpgKnGcaqMmRfoZvpRvIIp/IAqxRMII22
        njdMtPWIagCDJZ9ptxYPeOglPDEk84Q6eg==
X-Google-Smtp-Source: ABdhPJxwOAgtsOOsY5KWGog2W4UwIV1vob620gSOjd1gTABaZm/7pgTnjTXeBYROPPtui75wQl4eSg==
X-Received: by 2002:a17:90a:c08a:: with SMTP id o10mr5090932pjs.67.1615404425751;
        Wed, 10 Mar 2021 11:27:05 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 12sm306393pgw.18.2021.03.10.11.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 11:27:05 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 5/6] ionic: rebuild debugfs on qcq swap
Date:   Wed, 10 Mar 2021 11:26:30 -0800
Message-Id: <20210310192631.20022-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210310192631.20022-1-snelson@pensando.io>
References: <20210310192631.20022-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a reconfigure of each queue is needed a rebuild of
the matching debugfs information.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6f8a5daaadfa..48d3c7685b6c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2204,6 +2204,9 @@ static void ionic_swap_queues(struct ionic_qcq *a, struct ionic_qcq *b)
 	swap(a->cq_base,      b->cq_base);
 	swap(a->cq_base_pa,   b->cq_base_pa);
 	swap(a->cq_size,      b->cq_size);
+
+	ionic_debugfs_del_qcq(a);
+	ionic_debugfs_add_qcq(a->q.lif, a);
 }
 
 int ionic_reconfigure_queues(struct ionic_lif *lif,
-- 
2.17.1

