Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2931D3EFC74
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239515AbhHRGZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239161AbhHRGYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B43C061224
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y190so1099619pfg.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pfheq8ucotkU63pWQCdudkbxUtaK+5E7fGdpUnnohcE=;
        b=bOn7B1lcs0RvnQ+JyDcBrrDHbtMIszKBFbMg36dEvOm/cxiVZauZR1pM19AHYwcUKV
         a8y/SA1b4oZfyx+I7fB2xkZ8xjkLsTtpEq4EMNm3JkMacp3b4/IpDUQxMVbVY4g6nEfW
         zLrHVXNFumWsW5ybM/sxAkeypdIu2sT+eqT4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pfheq8ucotkU63pWQCdudkbxUtaK+5E7fGdpUnnohcE=;
        b=aDh589FmqgUkLR19qNFZGM5H+0d1HRdMyc5jMPsXdm+tZowhlstyDV6dCzMQVpdt9l
         NRIaTeXYnmcOZJw2Q64VHufnfZ3vH15Y0+80vT67ksuaY+/hIJLuVULVprkAvslQv1lQ
         BUGuQaxtMIS49w/OxjxhNfkXK+5rGcfgpxGGrn3wNHZEX51IVOVz087+d9xxisAAzPph
         1m9WgyO6Ad+ykOdWx+scyQrxhsXrQngOpmFBOCUkDmYySiCVUmtYLo3PvEww43AvBWe4
         +l7pKuUxtWdnAa73AAWDWtX2kxIiFtKdmt77DcoEHQYi6sh6RYc50emlaseMQ6fSFnMq
         qyKQ==
X-Gm-Message-State: AOAM533QyOSjI/9BKU/LD3xZdorwlJL6UwqUb3HpmamQOw294NJ5Jv1n
        Lzx+7kT/gE+QEZS/yoZBpkfKVQ==
X-Google-Smtp-Source: ABdhPJydUsyn5VnHkzaXMydTCOu45RwPjXJEVv8iarwYsWIPkrbqfwKhMSfmnkkd0A09rXVQCYKrpA==
X-Received: by 2002:a62:6242:0:b029:3c6:5a66:c8f2 with SMTP id w63-20020a6262420000b02903c65a66c8f2mr7615518pfb.59.1629267856691;
        Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s16sm1923432pfd.95.2021.08.17.23.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 58/63] ethtool: stats: Use struct_group() to clear all stats at once
Date:   Tue, 17 Aug 2021 23:05:28 -0700
Message-Id: <20210818060533.3569517-59-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1971; h=from:subject; bh=E0TNBYZqVPbRitBJ5Zh/gLEgPeByfWBcEVfphcdRPN4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMrF3QPyVB5GMFoBwvbiS+bGesf32/XaWgZh6rV XXUSuGeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjKwAKCRCJcvTf3G3AJuI/EA ChJAduV9dwQnlnG3wxAW9hWJ1q1jYsNmAAW03oHPyyyn4KhoNewX3nohRktZszGSOaJbWUuapbs0QS zhzLmfVfKhD7+DDfnZKD0XnlGiqH7Qvf5Q5ntMO0/ssU3MUgRP1gtdtb5NMHkByui7zpX/5x9W/2YW raKvA1KIXU6CdJePHvujGsZ5QP8biHCDP1thhwyJfUA4XwPHO3b8i6IC1kMBzBKINuCjLSkeqN3uWD PwoL5hyTqy4UKJN0gW6vj/hdXoIY6bLL/pGtAASCMDf1ZqU/p4Jgph8esB5nghJM4B5K/afkMfJgB+ vA/vxaYQSYgK9DPmx0RcanTPpspjeL27cp7jQyYi0izLRnpEiExj2zheTEAvmAN6nqq/leBQk6MTwN uE7XQ8NliZBAE0y+b+xl4TZEDKqaf3ZQLquskbjy9INmiSPSDGgnZODLH9BjIy5eLOJ0nYrc8QLN5B D18Vfd3FY3RNXbQkdqHx6rRPcX8ywj2ipEby99d78Sf6C421sRvINJCco18C7ckUJ5KbK307TNNlzA niH2xNat1pGZwKiztnfUGK9vkqebtbw9PjWgnoloa26nxruikmIBNbDpX17yxNTtNblkMvaAIxgqlv ZbPLstx3DpgFgVYefzNXWqrNibdM/9iNuS0mCC0zQsf6ZcpjwRIHZD0WHkXA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Add struct_group() to mark region of struct stats_reply_data that should
be initialized, which can now be done in a single memset() call.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ethtool/stats.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
index ec07f5765e03..a20e0a24ff61 100644
--- a/net/ethtool/stats.c
+++ b/net/ethtool/stats.c
@@ -14,10 +14,12 @@ struct stats_req_info {
 
 struct stats_reply_data {
 	struct ethnl_reply_data		base;
-	struct ethtool_eth_phy_stats	phy_stats;
-	struct ethtool_eth_mac_stats	mac_stats;
-	struct ethtool_eth_ctrl_stats	ctrl_stats;
-	struct ethtool_rmon_stats	rmon_stats;
+	struct_group(stats,
+		struct ethtool_eth_phy_stats	phy_stats;
+		struct ethtool_eth_mac_stats	mac_stats;
+		struct ethtool_eth_ctrl_stats	ctrl_stats;
+		struct ethtool_rmon_stats	rmon_stats;
+	);
 	const struct ethtool_rmon_hist_range	*rmon_ranges;
 };
 
@@ -117,10 +119,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
 	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
 	 * from being reported to user space in case driver did not set them.
 	 */
-	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
-	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
-	memset(&data->ctrl_stats, 0xff, sizeof(data->ctrl_stats));
-	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
+	memset(&data->stats, 0xff, sizeof(data->stats));
 
 	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
 	    dev->ethtool_ops->get_eth_phy_stats)
-- 
2.30.2

