Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1462FBDD8
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391198AbhASRh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 12:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391618AbhASPvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:51:21 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0927BC0613CF;
        Tue, 19 Jan 2021 07:50:29 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id m10so22459048lji.1;
        Tue, 19 Jan 2021 07:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=X9APBLhnDo/dgMmqTEdiP+aYCn+1rHjJUX5dvfgvPD+XWvVQ5o/n38cIHn8/+1JB4P
         1r51+L2s7dgWw1e6l38q+bd9gkSNrZvEr1/Zr5JHX6DE2nh4g51tihPCeDB+ybPcLMK+
         lOTKPrQ3NcbLo1Q3fTMFB/RYEnfxeha1/wqH6vCQXwe7LJuFykVpSpCTkuRgraqm/EUB
         e2b/8tNmChx3DTfGaOYDpsJxPMkvQ77A0wD/zhRsFjvrZrLDrTK1hw+0YWLrgYc4uEir
         17pI8hpXvvIvHKI7fO72yn9M46kBT7snjQ4F8JlOQrWlrWu1LrYCYp+UHn3tfK74FZxa
         wIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=OpVnw7i2LSd18I5PXUMZfdzZUnYed3VpVOOYukU0hpI3oVVqxPvguGYIe2OCYXe6G4
         j0gbwV579FKatHi/iXw0d8ni0P+VUco8Q+r0v8D5A0rmEZc41GuLryJehw0ZdvirctYs
         QPA08Gg6VNHjmAGzfQf5w7mt/d2h8KH3pcxzSCyt0Vag5loFdSESvhT8CyuyEXmRoR2I
         AitDC9T2LphSKx2AF01K7twHkyuLvtD4QZJ77GUGD33Swy0/Hom0N3XZdd4Y2xIg2iKF
         Vgs43fXvGuGCLp7lN38M5I6RW+AfbOGOzNrSYOdl4ir2TCd+CqBb/ZFtEpBNk68Nwe95
         ZfRA==
X-Gm-Message-State: AOAM531TkIAn8d4XiyS0yge7gWuFEMFwRouSNtR7zeYCq0q6cC0nCkME
        e2t7B4OeJ7MgZwBY2oYbJ5A=
X-Google-Smtp-Source: ABdhPJwuuswBjb2PVCk8Xr8GfAwenZNarsOIN+yxxQNxYn/bL0Cn3+08cZPkvhPI4UqfbD9lU0R0Zg==
X-Received: by 2002:a2e:8013:: with SMTP id j19mr2130561ljg.434.1611071427619;
        Tue, 19 Jan 2021 07:50:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id h20sm2309249lfc.239.2021.01.19.07.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:50:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next v2 3/8] xsk: fold xp_assign_dev and __xp_assign_dev
Date:   Tue, 19 Jan 2021 16:50:08 +0100
Message-Id: <20210119155013.154808-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119155013.154808-1-bjorn.topel@gmail.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Fold xp_assign_dev and __xp_assign_dev. The former directly calls the
latter.

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk_buff_pool.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 20598eea658c..8de01aaac4a0 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -119,8 +119,8 @@ static void xp_disable_drv_zc(struct xsk_buff_pool *pool)
 	}
 }
 
-static int __xp_assign_dev(struct xsk_buff_pool *pool,
-			   struct net_device *netdev, u16 queue_id, u16 flags)
+int xp_assign_dev(struct xsk_buff_pool *pool,
+		  struct net_device *netdev, u16 queue_id, u16 flags)
 {
 	bool force_zc, force_copy;
 	struct netdev_bpf bpf;
@@ -191,12 +191,6 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 	return err;
 }
 
-int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
-		  u16 queue_id, u16 flags)
-{
-	return __xp_assign_dev(pool, dev, queue_id, flags);
-}
-
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 			 struct net_device *dev, u16 queue_id)
 {
@@ -210,7 +204,7 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 	if (pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
-	return __xp_assign_dev(pool, dev, queue_id, flags);
+	return xp_assign_dev(pool, dev, queue_id, flags);
 }
 
 void xp_clear_dev(struct xsk_buff_pool *pool)
-- 
2.27.0

