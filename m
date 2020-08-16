Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C405C245943
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgHPT1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:27:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgHPT1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:27:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OJ5-009c0o-KO; Sun, 16 Aug 2020 21:27:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        jiri@mellanox.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: devlink: Remove overzealous WARN_ON with snapshots
Date:   Sun, 16 Aug 2020 21:26:38 +0200
Message-Id: <20200816192638.2291010-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible to trigger this WARN_ON from user space by triggering a
devlink snapshot with an ID which already exists. We don't need both
-EEXISTS being reported and spamming the kernel log.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e674f0f46dc2..e5feb87beca7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4063,7 +4063,7 @@ static int __devlink_snapshot_id_insert(struct devlink *devlink, u32 id)
 {
 	lockdep_assert_held(&devlink->lock);
 
-	if (WARN_ON(xa_load(&devlink->snapshot_ids, id)))
+	if (xa_load(&devlink->snapshot_ids, id))
 		return -EEXIST;
 
 	return xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(0),
-- 
2.28.0

