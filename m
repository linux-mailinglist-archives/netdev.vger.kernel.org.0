Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B69739E593
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhFGRh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhFGRh1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 13:37:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A72E61090;
        Mon,  7 Jun 2021 17:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623087336;
        bh=xoJ3SBvCoR2OnS/xwPHvxXvpvgmbVUJFOIcSTZTMJPU=;
        h=From:To:Cc:Subject:Date:From;
        b=sxbtma7b16ONwjgDqSLLD8R6TKu+gVO9gpX3JGsKZDxVo2Znlk3m3RTH0ZZhdz50X
         XnLKlZjbN71R5F/xZMohkA69F2AMj8n5VwUd1U4W1oYKM75RJxOlYofAcCRJnWdzf2
         kq/TLncNEgKdnHrw6DqrlJjBD2nPpodbMZlVp/+EuRdUYE9nWML92IZe5Wo1ltnKxQ
         UDLRKj4GZyYvcDrNi2TH+y37foeRXDQL5vMWvETJg5NHxboh3+KR1Ewww8Bb/g4jfa
         NYsWuhpmfAX1p0FOycSPrQIei8Av5uJidyCQc9DIGpZ2YgP8D9KGEx+dpUWWP9LcJi
         kW1X3nhvh+iGQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     David Ahern <dsahern@kernel.org>,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH net] neighbour: allow NUD_NOARP entries to be forced GCed
Date:   Mon,  7 Jun 2021 11:35:30 -0600
Message-Id: <20210607173530.46493-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
fill up the neighbour table with enough entries that it will overflow for
valid connections after that.

This behaviour is more prevalent after commit 58956317c8de ("neighbor:
Improve garbage collection") is applied, as it prevents removal from
entries that are not NUD_FAILED, unless they are more than 5s old.

Fixes: 58956317c8de (neighbor: Improve garbage collection)
Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
rebased to net tree

 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 98f20efbfadf..bf774575ad71 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -238,6 +238,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 
 			write_lock(&n->lock);
 			if ((n->nud_state == NUD_FAILED) ||
+			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
 			    time_after(tref, n->updated))
-- 
2.24.3 (Apple Git-128)

