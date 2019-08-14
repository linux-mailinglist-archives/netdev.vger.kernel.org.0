Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E3B8C6CE
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfHNCTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729606AbfHNCTC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:19:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B4B20843;
        Wed, 14 Aug 2019 02:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749141;
        bh=t9nh+fDzLR+lZdA6UiSx0HNU8IeirI5p/eg+9P6Z6ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCmImOED50zP7P7cPfG8cjqXHB3RdLTNzRuzGAVS2Fa3eKQG7mUiv8TaVogKrniUt
         6LIyWVXZZxAVAW39Ms9mhQuGaFJmWXzRS1i9HDG+4sIRDWtewoJYdyTABz+Gxqlizo
         PwaLY74QlBep4Eb3t4qa+uvdvkK/8LiLnSZ1UMgY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Shijie Luo <luoshijie1@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/44] netfilter: ipset: Fix rename concurrency with listing
Date:   Tue, 13 Aug 2019 22:18:05 -0400
Message-Id: <20190814021834.16662-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 6c1f7e2c1b96ab9b09ac97c4df2bd9dc327206f6 ]

Shijie Luo reported that when stress-testing ipset with multiple concurrent
create, rename, flush, list, destroy commands, it can result

ipset <version>: Broken LIST kernel message: missing DATA part!

error messages and broken list results. The problem was the rename operation
was not properly handled with respect of listing. The patch fixes the issue.

Reported-by: Shijie Luo <luoshijie1@huawei.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a3f1dc7cf5382..dbf17d3596a69 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1128,7 +1128,7 @@ static int ip_set_rename(struct net *net, struct sock *ctnl,
 		return -ENOENT;
 
 	write_lock_bh(&ip_set_ref_lock);
-	if (set->ref != 0) {
+	if (set->ref != 0 || set->ref_netlink != 0) {
 		ret = -IPSET_ERR_REFERENCED;
 		goto out;
 	}
-- 
2.20.1

