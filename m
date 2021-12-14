Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959F4473A56
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhLNBjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:39:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244786AbhLNBjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 20:39:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34078B81749
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 01:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23F6C34600;
        Tue, 14 Dec 2021 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639445948;
        bh=C6Wj/9580N917wjVQ+sNukw1SoqmDfLu08zJxl38cfg=;
        h=From:To:Cc:Subject:Date:From;
        b=HfGBngxbvkr8u9uxWOuIjEaZcLbp+BEdcBPaCzyNr440QXEBj9+LdhSSmz5FdH/+Y
         AOvrZOuzP6mo522NSIJCzs4sT8SwVlGfQFbAY23rNAMF8PGAMoe7XIMg89Tvt+8Hbj
         QN8GP/3kCezh3dsdcpJlbNjvYV9luXr0k7JLqw5HrIPzobO+7a64KN6Q3DJ8RYT8au
         8GE3JFWMdP1N3DImnYJn8NIaN7V2ypd9wSAliasxGp3Lo1+mfItPxs/5vJ/VH8DMBk
         hMBqCqLIv627Y+rQtR/4XhhkoSrzL1UVCf5pgF5f+z2/XTQ+GhW/AmBDimDV7JOAUE
         NUc+1tR95BO5A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ethtool: fix null-ptr-deref on ref tracker
Date:   Mon, 13 Dec 2021 17:39:02 -0800
Message-Id: <20211214013902.386186-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev can be a NULL here, not all requests set require_dev.

Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 23f32a995099..767fb3f17267 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -141,8 +141,10 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		return -EINVAL;
 	}
 
-	req_info->dev = dev;
-	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
+	if (dev) {
+		req_info->dev = dev;
+		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
+	}
 	req_info->flags = flags;
 	return 0;
 }
-- 
2.31.1

