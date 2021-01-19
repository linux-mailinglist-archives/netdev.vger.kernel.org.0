Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4922FBB76
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391637AbhASPl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390471AbhASPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:33 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB95C0613C1;
        Tue, 19 Jan 2021 07:37:14 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id n11so22411441lji.5;
        Tue, 19 Jan 2021 07:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=mdkg7Xf/mF9/3YZkHh4VJhw3javsqFsQGshRJwz6KU9dL2RzX3QV37YVZ3LRm9C7m6
         uu23PZJjIy781LCgs+i2Syb16xJ3pnhNcrmkXFqFocnfVnAWEOEgasOJFGOurv13Zsyg
         KNQyGQJb3G7Z719Nd1rLNKgNg/zciqRR0wR2AlgsKuhBqdRRAW5HOiNk1iaFYDBwiXTo
         pjjwztAmSOUw91dPELL+jd3AHdXCdTe2t2405YWbg/7FvIsqt0jjmL6easZKpNjt+NTO
         wkwKuOTHiDRdQ06fzv3ody8QcXUyEpbLcJ+F9NY23D2qCXl6eaNqb8e03czvavyneAhm
         H1jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DIoaswv7B1iicUnLwGWig+2UbyTxVZWzlqhoeUIxenk=;
        b=JvTf6Nt6Bt8Rn0gMVUqA1O2oDKAGmLJENFLzarm9Mqrumq23A08CzDuZxBs/FyS+Qp
         X3WUZ6jm78NTiUFDMpH120ZYZz4HSl5yk53mWXvBbArHiDNOLbrjl0rM7ay76E/mT0Rx
         xl9vzaJLdYvon99XaLewnCjNNXgNx45xsNrWkzc/r3AQ9e9KgzWsLLIz7ypA55tE+U3d
         qSjXOH9EUwknX4wNqmTn01k2tvk/97i/k6jSgcI4W6pSlcgRzY844AGYQJOIK3Acf5y3
         RlDYsCOwhHHJU04ZOFxReDnjmkRgQ/Vck61gEOYy6Up0Aff+Fv++RQEtgIgnbhFOyWtq
         Ed+Q==
X-Gm-Message-State: AOAM531sEIaMqj1YNXyhFB13/I+tKJ/YxRaX4qJO5UCjmwdbDT55BToZ
        O0XcBbSg7e6LP+fcepJxx98=
X-Google-Smtp-Source: ABdhPJyJ/Ai9nwKCt3NL3n+W2vMm+C9wFVtVTHo+KMgTmDmjPggqJlHXeeL8SCwaDtgo0/WqInjHDg==
X-Received: by 2002:a2e:80d4:: with SMTP id r20mr2096957ljg.495.1611070631694;
        Tue, 19 Jan 2021 07:37:11 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:11 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 3/8] xsk: fold xp_assign_dev and __xp_assign_dev
Date:   Tue, 19 Jan 2021 16:36:50 +0100
Message-Id: <20210119153655.153999-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
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

