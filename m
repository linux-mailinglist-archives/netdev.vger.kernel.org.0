Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D6F443832
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 23:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhKBWFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 18:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhKBWFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 18:05:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A5FC60F5A;
        Tue,  2 Nov 2021 22:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635890561;
        bh=FsAT/ij5gcUCRgrQBdQVwz573g8DBWikwc/ijGzLfz8=;
        h=From:To:Cc:Subject:Date:From;
        b=OyN1VrtgpOFDjnHKoV0d28XzJrK/WkjQ48AIIzcHUE8CmRdwp6qQA2EHtNcFiD97S
         0PmnFHrXvbfjcDtzu1227j1qHu8iL4WZ+RmW/uJM7dbCa0tVZ/6mL8L1iG+3aRrTNE
         w8PHEzTI958TTBJXaAQWc7rXDJdRGYsV/297sSR2pxBxBl/PWwCnRfY7E3UaEzoOtt
         fCAFMWYYzmpteYqKzJBG1pAx856TC1380AerxHOrtupiuqGv2Bz6BsXg04iNc9d5vd
         10TN9snBecXRvR2R2UIyk4+zgZ68+p1pgMJHAT+2ATdpqZDwE4/wSamC2cg9QuRH5b
         C0pEYAXahqEBQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] ethtool: fix ethtool msg len calculation for pause stats
Date:   Tue,  2 Nov 2021 15:02:36 -0700
Message-Id: <20211102220236.3803742-1-kuba@kernel.org>
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
v2: add a define

 include/linux/ethtool_netlink.h      | 3 +++
 include/uapi/linux/ethtool_netlink.h | 4 +++-
 net/ethtool/pause.c                  | 3 +--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool_netlink.h b/include/linux/ethtool_netlink.h
index 1e7bf78cb382..aba348d58ff6 100644
--- a/include/linux/ethtool_netlink.h
+++ b/include/linux/ethtool_netlink.h
@@ -10,6 +10,9 @@
 #define __ETHTOOL_LINK_MODE_MASK_NWORDS \
 	DIV_ROUND_UP(__ETHTOOL_LINK_MODE_MASK_NBITS, 32)
 
+#define ETHTOOL_PAUSE_STAT_CNT	(__ETHTOOL_A_PAUSE_STAT_CNT -		\
+				 ETHTOOL_A_PAUSE_STAT_TX_FRAMES)
+
 enum ethtool_multicast_groups {
 	ETHNL_MCGRP_MONITOR,
 };
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index ca5fbb59fa42..999777d32dcf 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -411,7 +411,9 @@ enum {
 	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
 	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
 
-	/* add new constants above here */
+	/* add new constants above here
+	 * adjust ETHTOOL_PAUSE_STAT_CNT if adding non-stats!
+	 */
 	__ETHTOOL_A_PAUSE_STAT_CNT,
 	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
 };
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 9009f412151e..ee1e5806bc93 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -56,8 +56,7 @@ static int pause_reply_size(const struct ethnl_req_info *req_base,
 
 	if (req_base->flags & ETHTOOL_FLAG_STATS)
 		n += nla_total_size(0) +	/* _PAUSE_STATS */
-			nla_total_size_64bit(sizeof(u64)) *
-				(ETHTOOL_A_PAUSE_STAT_MAX - 2);
+		     nla_total_size_64bit(sizeof(u64)) * ETHTOOL_PAUSE_STAT_CNT;
 	return n;
 }
 
-- 
2.31.1

