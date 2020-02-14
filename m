Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6115EBBB
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392155AbgBNRWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391291AbgBNQJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:09:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972DC24676;
        Fri, 14 Feb 2020 16:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696591;
        bh=AxKfZmAdFXCPVhMsF/7rjFQ7ZLiEFxpynnsIU06lQ8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cby0UzXSk6AH5wccfs7GKpFXvhm28Ygr3wAMpeSo+2t82jWvPPts7VGlCsUwQk5So
         J5l/iFme2u67cBF71aJhRjUy0NWRxv60Imp7bVYYj7PEoW2ufZ1dpNYMDooVCQuBCL
         zdKLctkpMy0I8lSqjjkLaRIC7/3315cM066VGFIQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trond Myklebust <trondmy@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "J . Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 378/459] sunrpc: Fix potential leaks in sunrpc_cache_unhash()
Date:   Fri, 14 Feb 2020 11:00:28 -0500
Message-Id: <20200214160149.11681-378-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Trond Myklebust <trondmy@gmail.com>

[ Upstream commit 1d82163714c16ebe09c7a8c9cd3cef7abcc16208 ]

When we unhash the cache entry, we need to handle any pending upcalls
by calling cache_fresh_unlocked().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index f740cb51802af..7ede1e52fd812 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1888,7 +1888,9 @@ void sunrpc_cache_unhash(struct cache_detail *cd, struct cache_head *h)
 	if (!hlist_unhashed(&h->cache_list)){
 		hlist_del_init_rcu(&h->cache_list);
 		cd->entries--;
+		set_bit(CACHE_CLEANED, &h->flags);
 		spin_unlock(&cd->hash_lock);
+		cache_fresh_unlocked(h, cd);
 		cache_put(h, cd);
 	} else
 		spin_unlock(&cd->hash_lock);
-- 
2.20.1

