Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22600433C71
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 18:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhJSQiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 12:38:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234395AbhJSQiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 12:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A186135E;
        Tue, 19 Oct 2021 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634661368;
        bh=KEaicjxGeuadgklFpNbWZeZRDyBkRw1vx/Jj1oF5vyE=;
        h=From:To:Cc:Subject:Date:From;
        b=qPQa221tIWtK655KEzo6DSxZ7hMzKhq3ZP8YZtKH4B/MAXYsZ8yjkRIvomJrdUR23
         2NKS4lVpeV6aSlQFGNzT6JHGF/GLuEUfw0gm9hu+5aKNfl+i6rJgd6q6t+wzFfGFyo
         ++ug/jkk1W0Fa24umGiYuXUjjmFxva27k3Di/ACojaumRpoOwYdXF6iZajeKfcAT0d
         5Y3J6DAoPlzfsNOL2rxmGp+7MX424GXfFqqqnrflBwrGurzT0OF/WBIQqYft9eLMAl
         DdByVUGfJRJ2DfiF+XkOzJ0Kegir9YbgEV6yijLuATy4b7/jRsUZtTeWlYWQ2b6k9u
         ZJCunaxXZb0pQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/2] mac802154: use dev_addr_set()
Date:   Tue, 19 Oct 2021 09:36:05 -0700
Message-Id: <20211019163606.1385399-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/mac802154/iface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/iface.c b/net/mac802154/iface.c
index 323d3d2d986f..3210dec64a6a 100644
--- a/net/mac802154/iface.c
+++ b/net/mac802154/iface.c
@@ -129,7 +129,7 @@ static int mac802154_wpan_mac_addr(struct net_device *dev, void *p)
 	if (!ieee802154_is_valid_extended_unicast_addr(extended_addr))
 		return -EINVAL;
 
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	dev_addr_set(dev, addr->sa_data);
 	sdata->wpan_dev.extended_addr = extended_addr;
 
 	/* update lowpan interface mac address when
-- 
2.31.1

