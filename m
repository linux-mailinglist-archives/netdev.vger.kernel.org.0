Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBED189CFC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCRN2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:28:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46125 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbgCRN23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:28:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id c19so13901011pfo.13
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 06:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JGzG2liTvboErTP28NU1LlzSmp20/5al6BHjA1FIOz4=;
        b=kpYIWpPuukwC1mqc3dm8206LUUuyqEdVt5GCPPgsf+9gpm7/Hm6wehUWr940J3ocvT
         uBTABS81j7KxLS7yr/WIuHPwL2zyINE/60CpDsTu+p32LbtMXMy0okXd2wSYFtgUAuH9
         VWRD0t5imYUBvx2at8+yYHrRiUEFNRtrVZexFmP1jUrQI0UkrnRnQY4hXFQgK+EHXELH
         7ZzUzfQufSiCcqkBl981kq4jjB0egJYmCDRlgCyG6TpzTy0MsNd7eym050OGPFaIqPcO
         HrJKBe6pAIwQVfydCebSD1phfQwtKZqpjQ1ESmdBFmiAA0nE59/OUd0nsMJH62dJLPDJ
         2anQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JGzG2liTvboErTP28NU1LlzSmp20/5al6BHjA1FIOz4=;
        b=drjL0hTRe4ZzUXM1epGqTulytGtBE/mJ1gplIoXX7mKRoHyjGY3GEVBTCDK3Bb1hBa
         fdkJHpjEZg+l9NSJk8r578Vb23ZwPYtVEZWi5ABNyzXeteYFwKP9H604vRNX8WyYd37f
         8AyBEDjBtxyxUh0FY32EdWiS9BNjZjqYXNqXzW71XMQXXXPprPYCZB8lQgD8fSTFzC0Y
         m5luYBhKDaWEChFX8y5XNDA/097p1iQYDu1ssWHw2+WIQnymm5f4FYBHiDfv3aNbkGhe
         AYeCwlb244wXxaGHkxpVxRhakY+7/kCJ3z0H3QZ7lTz2nufEmLltgoxyb7A5w8d+wG5o
         wIhQ==
X-Gm-Message-State: ANhLgQ3Nb/0+AJIzSb4ZuHfbsVu+8zShTK23cJogmz1n8qjOA0tr8N/c
        wu4gUYa0Dnbl3c9ibVu3pvM=
X-Google-Smtp-Source: ADFU+vvwQh+Nj01wJ3epgkNNj1cIslDUwv3KqEzXQUNlNdOSZRaPHvx/CPeJ5EO/iKO6WsVDAU/zzQ==
X-Received: by 2002:a63:fc56:: with SMTP id r22mr4615028pgk.147.1584538108392;
        Wed, 18 Mar 2020 06:28:28 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id u24sm6115710pgo.83.2020.03.18.06.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 06:28:27 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] vxlan: check return value of gro_cells_init()
Date:   Wed, 18 Mar 2020 13:28:09 +0000
Message-Id: <20200318132809.27206-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gro_cells_init() returns error if memory allocation is failed.
But the vxlan module doesn't check the return value of gro_cells_init().

Fixes: 58ce31cca1ff ("vxlan: GRO support at tunnel layer")`
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/vxlan.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index d3b08b76b1ec..45308b3350cf 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2779,10 +2779,19 @@ static void vxlan_vs_add_dev(struct vxlan_sock *vs, struct vxlan_dev *vxlan,
 /* Setup stats when device is created */
 static int vxlan_init(struct net_device *dev)
 {
+	struct vxlan_dev *vxlan = netdev_priv(dev);
+	int err;
+
 	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!dev->tstats)
 		return -ENOMEM;
 
+	err = gro_cells_init(&vxlan->gro_cells, dev);
+	if (err) {
+		free_percpu(dev->tstats);
+		return err;
+	}
+
 	return 0;
 }
 
@@ -3043,8 +3052,6 @@ static void vxlan_setup(struct net_device *dev)
 
 	vxlan->dev = dev;
 
-	gro_cells_init(&vxlan->gro_cells, dev);
-
 	for (h = 0; h < FDB_HASH_SIZE; ++h) {
 		spin_lock_init(&vxlan->hash_lock[h]);
 		INIT_HLIST_HEAD(&vxlan->fdb_head[h]);
-- 
2.17.1

