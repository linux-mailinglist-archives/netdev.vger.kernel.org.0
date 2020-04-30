Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F92F1BFD7B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgD3OMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbgD3NvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF4F208D5;
        Thu, 30 Apr 2020 13:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254661;
        bh=X+8B5r+3ozNjTtxJhR0LgbtW2wp7VlQ+Pb0lz57jQmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIEMYHK8k1jV8J6Od2UQdFLxY9/epwe1j/mPxU6JGhqyhhaQagtRmol9ZqaQickAG
         IBvpneHsuHame9iz7pBkvJTeYPvJ6UCO6Lv6hmQK31ungMbv17qm8iJfDdvi61425D
         9IyEZRVOLWLhfwd7VJOA2zzQNHcZeaF6fY350PX8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihao Wu <wuyihao@linux.alibaba.com>, NeilBrown <neilb@suse.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 14/79] SUNRPC/cache: Fix unsafe traverse caused double-free in cache_purge
Date:   Thu, 30 Apr 2020 09:49:38 -0400
Message-Id: <20200430135043.19851-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yihao Wu <wuyihao@linux.alibaba.com>

[ Upstream commit 43e33924c38e8faeb0c12035481cb150e602e39d ]

Deleting list entry within hlist_for_each_entry_safe is not safe unless
next pointer (tmp) is protected too. It's not, because once hash_lock
is released, cache_clean may delete the entry that tmp points to. Then
cache_purge can walk to a deleted entry and tries to double free it.

Fix this bug by holding only the deleted entry's reference.

Suggested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Yihao Wu <wuyihao@linux.alibaba.com>
Reviewed-by: NeilBrown <neilb@suse.de>
[ cel: removed unused variable ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/cache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index bd843a81afa0b..d36cea4e270de 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -521,7 +521,6 @@ void cache_purge(struct cache_detail *detail)
 {
 	struct cache_head *ch = NULL;
 	struct hlist_head *head = NULL;
-	struct hlist_node *tmp = NULL;
 	int i = 0;
 
 	spin_lock(&detail->hash_lock);
@@ -533,7 +532,9 @@ void cache_purge(struct cache_detail *detail)
 	dprintk("RPC: %d entries in %s cache\n", detail->entries, detail->name);
 	for (i = 0; i < detail->hash_size; i++) {
 		head = &detail->hash_table[i];
-		hlist_for_each_entry_safe(ch, tmp, head, cache_list) {
+		while (!hlist_empty(head)) {
+			ch = hlist_entry(head->first, struct cache_head,
+					 cache_list);
 			sunrpc_begin_cache_remove_entry(ch, detail);
 			spin_unlock(&detail->hash_lock);
 			sunrpc_end_cache_remove_entry(ch, detail);
-- 
2.20.1

