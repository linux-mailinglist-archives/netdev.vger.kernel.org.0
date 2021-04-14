Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE48A35EB86
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346962AbhDNDpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346878AbhDNDpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 23:45:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 338A861154;
        Wed, 14 Apr 2021 03:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618371902;
        bh=Frbck01TeTZG+fUYhmB7sA/ZzuLuN/4NakzwWwaoaCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEwZoDueK1g1/E5HNLAaDFbRmY+rVwStHrGN1WSpM5IO8AOLtEDgkMyqowo3jDgBT
         yUBkfytJ5CtXbZpDEDpz0HuhcF1j3ldVk9kPOzo3BDOR4Xo9TW2ueQvH53DkP1j3z9
         Xy/v1bDxfijbasF+icz9lGHj/oWyGOEUNnuA/fVpAkK7ZHzQYGewJ5rseuozaO/uxK
         Yh/7Tck98ebTPOns82u25Ny9OI+WWcAd4kXuATLZ/DEJuYpFkYk2YqaM8XePADT3zS
         fgx+g3W3HMmWSOYbYYmou6QMwA35rGuZ6jNAIN7wc4ce9cR2mRymEWOO+2Cxg0AbWF
         gzX/bQ7YSzTwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] ethtool: move ethtool_stats_init
Date:   Tue, 13 Apr 2021 20:44:49 -0700
Message-Id: <20210414034454.1970967-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414034454.1970967-1-kuba@kernel.org>
References: <20210414034454.1970967-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need it for FEC stats as well.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h | 6 ++++++
 net/ethtool/pause.c     | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9f6f323af59a..069100b252bd 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -244,6 +244,12 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
+static inline void ethtool_stats_init(u64 *stats, unsigned int n)
+{
+	while (n--)
+		stats[n] = ETHTOOL_STAT_NOT_SET;
+}
+
 /**
  * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
  * @tx_pause_frames: transmitted pause frame count. Reported to user space
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index d4ac02718b72..9009f412151e 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -21,12 +21,6 @@ const struct nla_policy ethnl_pause_get_policy[] = {
 		NLA_POLICY_NESTED(ethnl_header_policy_stats),
 };
 
-static void ethtool_stats_init(u64 *stats, unsigned int n)
-{
-	while (n--)
-		stats[n] = ETHTOOL_STAT_NOT_SET;
-}
-
 static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
-- 
2.30.2

