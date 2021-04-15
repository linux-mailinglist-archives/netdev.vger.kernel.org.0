Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88A43615B5
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhDOWxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237524AbhDOWxo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5F7610FC;
        Thu, 15 Apr 2021 22:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527201;
        bh=Frbck01TeTZG+fUYhmB7sA/ZzuLuN/4NakzwWwaoaCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0ckRjnLQod1mPZoN8uUj/jr5cGD2GvzKEd6h7QKRmP1g/Zxmgdvmu0yvC/IvNTsG
         FTXu/zMHiJCgsdRzNLJnLVId4/lhWLRhZoIVtVuiv+Zn8FsCkBMrqdw12wUYlInnmh
         A/CWjmOWJr5HxUDqLcDX6DD9hqUrPiIUyWTgVZKBskTvfCryqZ6LA8tWVOxoFb6Blf
         1Gs3j41kHI9sy9MS+h9Wywd2BhawnWx2aQhnFNTlJY8OLzlBKh485hm0GwTWNz16+C
         ajNaTWxrQHvUIG8itZgBEKKWxjYpaCRhoFx7q9+m691+TQfs5mOCoVEOda1tfJt5GT
         GoHbKwxHPfr1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/6] ethtool: move ethtool_stats_init
Date:   Thu, 15 Apr 2021 15:53:13 -0700
Message-Id: <20210415225318.2726095-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
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

