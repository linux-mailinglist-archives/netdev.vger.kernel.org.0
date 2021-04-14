Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8390A35EB8E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbhDNDqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232602AbhDNDqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:46:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BBB961132;
        Wed, 14 Apr 2021 03:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371983;
        bh=w4gLOkKeqB/1DEk/NXSR9EPR1Sb2PqllrqPfKtrf3uI=;
        h=From:To:Cc:Subject:Date:From;
        b=qVbGGTZO9BQN5afrYhL6Ifbkumfe4ZSl4kEiyT/hPn310mGlAeSZyc1nPS5tdJxTh
         ShViboKzN0/ZUnIPgPG3QBAOa0FSV6uKt0CGaiFM8qTmD7TQwddY9B/OxHqJnsqB0B
         meIXKrfuzrYizfMP4fRIS3nS8hWdv0TUThwhp5r/MOQY1mYMFIuB66GhqZE0ZuPjlp
         YzgPvs/dqFEAlDHxNEwuxhypufxo6Db78qOtVyYb3WC+HHUBfLvyZoarROsHE8Qwoq
         3ozbtyC+FEyClnxfNqG3fRCNFvYZLo9t6osQgAPsA5R8dpK8rRXPkXfI7Jod3fk4Y+
         LKkqjRvFaCWOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     saeedm@nvidia.com, netdev@vger.kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ethtool: pause: make sure we init driver stats
Date:   Tue, 13 Apr 2021 20:46:14 -0700
Message-Id: <20210414034614.1971597-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The intention was for pause statistics to not be reported
when driver does not have the relevant callback (only
report an empty netlink nest). What happens currently
we report all 0s instead. Make sure statistics are
initialized to "not set" (which is -1) so the dumping
code skips them.

Fixes: 9a27a33027f2 ("ethtool: add standard pause stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/pause.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 09998dc5c185..d4ac02718b72 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -38,16 +38,16 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 	if (!dev->ethtool_ops->get_pauseparam)
 		return -EOPNOTSUPP;
 
+	ethtool_stats_init((u64 *)&data->pausestat,
+			   sizeof(data->pausestat) / 8);
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
 	if (req_base->flags & ETHTOOL_FLAG_STATS &&
-	    dev->ethtool_ops->get_pause_stats) {
-		ethtool_stats_init((u64 *)&data->pausestat,
-				   sizeof(data->pausestat) / 8);
+	    dev->ethtool_ops->get_pause_stats)
 		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
-	}
 	ethnl_ops_complete(dev);
 
 	return 0;
-- 
2.30.2

