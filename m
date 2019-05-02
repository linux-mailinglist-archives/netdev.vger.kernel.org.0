Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26360110D6
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 03:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfEBBH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 21:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfEBBH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 21:07:27 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04572085A;
        Thu,  2 May 2019 01:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556759246;
        bh=eDnCcVuw6O877czZYd2o/YChmQa+wdNOS6NNA4tuGcU=;
        h=From:To:Cc:Subject:Date:From;
        b=GKnID9KpWdKTA++knJKaS+lFJS9MYwmb9lrofAdAaX8vCeYPmcGpgVzQ7g869fpP/
         3pog1fg9p7J+c4rafoS4ao1UC8W+xgLZ/PHdCjN6FTkGp/Hr82IcOgnSZk5dkS6ahl
         /pe3Ey8fuBD201fnBn2pq2IPlpsJGXDuxy2pCJKU=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ian.kumlien@gmail.com,
        alan.maguire@oracle.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] neighbor: Reset gc_entries counter if new entry is released before insert
Date:   Wed,  1 May 2019 18:08:34 -0700
Message-Id: <20190502010834.25519-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Ian and Alan both reported seeing overflows after upgrades to 5.x kernels:
  neighbour: arp_cache: neighbor table overflow!

Alan's mpls script helped get to the bottom of this bug. When a new entry
is created the gc_entries counter is bumped in neigh_alloc to check if a
new one is allowed to be created. ___neigh_create then searches for an
existing entry before inserting the just allocated one. If an entry
already exists, the new one is dropped in favor of the existing one. In
this case the cleanup path needs to drop the gc_entries counter. There
is no memory leak, only a counter leak.

Fixes: 58956317c8d ("neighbor: Improve garbage collection")
Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
Reported-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/core/neighbour.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 30f6fd8f68e0..aff051e5521d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -663,6 +663,8 @@ static struct neighbour *___neigh_create(struct neigh_table *tbl,
 out_tbl_unlock:
 	write_unlock_bh(&tbl->lock);
 out_neigh_release:
+	if (!exempt_from_gc)
+		atomic_dec(&tbl->gc_entries);
 	neigh_release(n);
 	goto out;
 }
-- 
2.11.0

