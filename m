Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8DDE5D08
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbfJZNen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:34:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727400AbfJZNRg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A11D222D1;
        Sat, 26 Oct 2019 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095856;
        bh=ujFA00CPmwDhYK78Zmsep9jkd82hTMcP1udgDVX1RKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOjf+NJ7hC5eUo0Q6YiToA5Setzn2dBn0jVdA5cB8/y85Db3O2b21Efey2ecP/JQF
         QvTfyGOM0mbGkBHyfwgPx17WWh8v0R3opvxQgPaKchxcgSjbFQIi31jVgO26KV6Pty
         zNndsr6wjlj0iM45kMYAI54QKIQKM2i4oNBjZh2g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Zhang Yu <zhangyu31@baidu.com>,
        Wang Li <wangli39@baidu.com>,
        Li RongQing <lirongqing@baidu.com>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 50/99] tun: remove possible false sharing in tun_flow_update()
Date:   Sat, 26 Oct 2019 09:15:11 -0400
Message-Id: <20191026131600.2507-50-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4ffdd22e49f47db543906d75453a0048a53071ab ]

As mentioned in https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
a C compiler can legally transform

if (e->queue_index != queue_index)
	e->queue_index = queue_index;

to :

	e->queue_index = queue_index;

Note that the code using jiffies has no issue, since jiffies
has volatile attribute.

if (e->updated != jiffies)
    e->updated = jiffies;

Fixes: 83b1bc122cab ("tun: align write-heavy flow entry members to a cache line")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Zhang Yu <zhangyu31@baidu.com>
Cc: Wang Li <wangli39@baidu.com>
Cc: Li RongQing <lirongqing@baidu.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aab0be40d4430..dd1d7dc361f1c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -526,8 +526,8 @@ static void tun_flow_update(struct tun_struct *tun, u32 rxhash,
 	e = tun_flow_find(head, rxhash);
 	if (likely(e)) {
 		/* TODO: keep queueing to old queue until it's empty? */
-		if (e->queue_index != queue_index)
-			e->queue_index = queue_index;
+		if (READ_ONCE(e->queue_index) != queue_index)
+			WRITE_ONCE(e->queue_index, queue_index);
 		if (e->updated != jiffies)
 			e->updated = jiffies;
 		sock_rps_record_flow_hash(e->rps_rxhash);
-- 
2.20.1

