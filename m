Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70EA2C93E6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbgLAA0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbgLAA0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:26:43 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95AEC0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:57 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id t12so127830pjq.5
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dyAxNjo17ZUIGlsMvPKiZqDZ4nUH9vd0xfyYvJND1Zo=;
        b=LGN6vQ7bkbR8ogcFrs0b8eFPUFYEz8wqVeIvMY3n7jJESPtegf2OT8H6Zn5obuMxzV
         jFYP5p/QLPKToiv0PP9/KAf/4qxKRDsp5NTqGe4MHR7uXSRrL4K7jHg8C0Tat3KZPCAJ
         xeaSyK3MOUU4GurhkqRCe365g/szbR9/zFjXoF20CVSTD78htVRv9ly4E7D8Qc8ueRdU
         CxDpjzaMRj4L8IXIUt1bcsgojYnBlEH/uziEF1hB084a6MVFuc9lE+PUHn/L0QHhqm0E
         DglLuTzNstWms5D4q2dgXujGmH/qsM9nVt/2wHFeoHYxW8Jvc68LvaStfHahXFFPRml8
         itlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dyAxNjo17ZUIGlsMvPKiZqDZ4nUH9vd0xfyYvJND1Zo=;
        b=Do93kN93wRYqREMoobt1tcR477Qp6Ghp6xBPeyQ01jiiLsmB0DB7Y2G2m3nzaQvUtl
         hEV4pvi9CgXHei0+WQCckvmEsOp7ZXJ1SbGENley6xrl2CGGKVoF5H4I8ha2Ujfu+JdI
         YjF8x6Itm/DLvhHmlJtcM3tunntn2WedoZd9inw4vmLi3G762eTLZQRKXtfD/yoHzecb
         7dRbVAit2e/cTtthZv9Mdvp8z/L4UVfdRz7/btov1mDnveQKPunYEdLMO+zmvo5Us0nq
         u3pMYlfYDezYIvbLLXg/Y9/PF6AzaurZXKqha3xwPAg+HH80iImThN0SgSyUqx1QzNTR
         tnJQ==
X-Gm-Message-State: AOAM530fRwWghZiGpzv3DbiFAGXCP8ncakeHftWJTWHk6NqrfrMYQo8N
        Cwd12sjyrBQVaLaLu6p7pf/jzXo+C99asw==
X-Google-Smtp-Source: ABdhPJzazM6uJtXudQR5sOwyXp/N0nSxQ6bicSYAOSmUN6Us+uRZoTLXNwQIns2q6w9X+Z/JGCU8Hg==
X-Received: by 2002:a17:902:6bc2:b029:d6:e0ba:f2ff with SMTP id m2-20020a1709026bc2b02900d6e0baf2ffmr186568plt.10.1606782357070;
        Mon, 30 Nov 2020 16:25:57 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id q12sm172632pgv.91.2020.11.30.16.25.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 16:25:56 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/2] ionic: change mtu after queues are stopped
Date:   Mon, 30 Nov 2020 16:25:46 -0800
Message-Id: <20201201002546.4123-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201201002546.4123-1-snelson@pensando.io>
References: <20201201002546.4123-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Order of operations is slightly more correct in the driver
to change the netdev->mtu after the queues have been stopped
rather than before.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0b7f2def423c..11140915c2da 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1465,12 +1465,14 @@ static int ionic_change_mtu(struct net_device *netdev, int new_mtu)
 	if (err)
 		return err;
 
-	netdev->mtu = new_mtu;
 	/* if we're not running, nothing more to do */
-	if (!netif_running(netdev))
+	if (!netif_running(netdev)) {
+		netdev->mtu = new_mtu;
 		return 0;
+	}
 
 	ionic_stop_queues_reconfig(lif);
+	netdev->mtu = new_mtu;
 	return ionic_start_queues_reconfig(lif);
 }
 
-- 
2.17.1

