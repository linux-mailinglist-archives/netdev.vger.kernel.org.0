Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95457E5A9D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfJZNQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726813AbfJZNQe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:16:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75135222BE;
        Sat, 26 Oct 2019 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095794;
        bh=grgpAxtUB4xIGMyjFZyp1n+8/BUm3kbhNeTqFmwWZoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWUpnamx2zNdam3uFVVcGl9p93l+I7w8tW2jk9hU4mdgsLgo0lBfUhKmHNUN1wquN
         NZqvOLKuiGc7bMMXjiAMn7JJmJd611RgGVUHJPI30I+l3Z2VlFX4Et99YVn1V4tuw6
         XQoexIjD7VxrY7HYsjbpyfbjxmj+esxTTtM+Ry3Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 21/99] nl80211: fix memory leak in nl80211_get_ftm_responder_stats
Date:   Sat, 26 Oct 2019 09:14:42 -0400
Message-Id: <20191026131600.2507-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 1399c59fa92984836db90538cf92397fe7caaa57 ]

In nl80211_get_ftm_responder_stats, a new skb is created via nlmsg_new
named msg. If nl80211hdr_put() fails, then msg should be released. The
return statement should be replace by goto to error handling code.

Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Link: https://lore.kernel.org/r/20191004194220.19412-1-navid.emamdoost@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f03459ddc840a..ae937543518ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13518,7 +13518,7 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_GET_FTM_RESPONDER_STATS);
 	if (!hdr)
-		return -ENOBUFS;
+		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
-- 
2.20.1

