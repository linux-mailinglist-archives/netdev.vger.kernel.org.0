Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD2F44265B
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 05:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhKBEX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 00:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232776AbhKBEX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 00:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66BCD61052;
        Tue,  2 Nov 2021 04:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635826883;
        bh=dHOzOdfqkyAMLFZFXszu/ggpeok94WQQR9iTVG3f3Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=oeqyx32JoWnbJ2q1y3b0uGkr0fB7Wd8OkTdvSKyNay0i0ujbL6doBzZkQLQiISGO+
         VkXW31iKeUhcpsYTYDSsogddi1fasc2ZFFR5RBdd2c/i30sWJdGMf8jqtcb0SeGuxT
         Hdl6c0jKFVNf3cGEX7jAzetELVn3BzZ8M0DQoJPRt+PJCiTO1AbC+XmeU4ERScMKww
         4vRnco4JBthVpMRe78d30eDznbBUKYvkQIGfi9XQa7cLsicZ3xko8w/yXId2MU2H33
         IREPV4JeDx+shvUP8NXCAvDCqop/B3PijepkatgMa15usV1iZMCeY+9Pi4RnkabFgY
         BkWsXYWo0NFaQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] ethtool: fix ethtool msg len calculation for pause stats
Date:   Mon,  1 Nov 2021 21:21:20 -0700
Message-Id: <20211102042120.3595389-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ETHTOOL_A_PAUSE_STAT_MAX is the MAX attribute id,
so we need to subtract non-stats and add one to
get a count (IOW -2+1 == -1).

Otherwise we'll see:

  ethnl cmd 21: calculated reply length 40, but consumed 52

Fixes: 9a27a33027f2 ("ethtool: add standard pause stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/pause.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 9009f412151e..c9171234130b 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -57,7 +57,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
 			nla_total_size_64bit(sizeof(u64)) *
-				(ETHTOOL_A_PAUSE_STAT_MAX - 2);
+				(ETHTOOL_A_PAUSE_STAT_MAX - 1);
 	return n;
 }
 
-- 
2.31.1

