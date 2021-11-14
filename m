Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB044FA0B
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 20:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236153AbhKNTFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 14:05:48 -0500
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:64516 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbhKNTFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 14:05:47 -0500
Received: from pop-os.home ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id mKlwmkSLSUGqlmKlxmi68i; Sun, 14 Nov 2021 20:02:38 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 14 Nov 2021 20:02:38 +0100
X-ME-IP: 86.243.171.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: bridge: Slightly optimize 'find_portno()'
Date:   Sun, 14 Nov 2021 20:02:35 +0100
Message-Id: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'inuse' bitmap is local to this function. So we can use the
non-atomic '__set_bit()' to save a few cycles.

While at it, also remove some useless {}.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/bridge/br_if.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index c1183fef1f21..64b2d4fb50f5 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -397,10 +397,10 @@ static int find_portno(struct net_bridge *br)
 	if (!inuse)
 		return -ENOMEM;
 
-	set_bit(0, inuse);	/* zero is reserved */
-	list_for_each_entry(p, &br->port_list, list) {
-		set_bit(p->port_no, inuse);
-	}
+	__set_bit(0, inuse);	/* zero is reserved */
+	list_for_each_entry(p, &br->port_list, list)
+		__set_bit(p->port_no, inuse);
+
 	index = find_first_zero_bit(inuse, BR_MAX_PORTS);
 	bitmap_free(inuse);
 
-- 
2.30.2

