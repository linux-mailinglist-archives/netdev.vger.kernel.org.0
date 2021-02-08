Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94016313ACE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233725AbhBHRYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:34772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234412AbhBHRVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72C9F64EB1;
        Mon,  8 Feb 2021 17:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804775;
        bh=BVs2v8xagjCvnn97bRukN76ncusKjzmnp3HhoKH252c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODsTlSLzkg41TvEwz3b2VoTtd44l267xXbtWRYEBsj7EG92/tLtwhtZJbAhIPHuDs
         3dErf9/0EVIXuhK1gcn0ECNv+56ffHDncgx+J+TCedYPvYv35YsfydpjKVz0QJNaZ8
         6M9uNWZYm7IgTaWsy3HS+VYNVJDUBV1o2VJzoECtptrJsbqGG8/UKGIse/VEFrw23G
         Y0I/rt3tGwBz8+pCczArIgXh7PuzRwnHTYTqwEKpIdg+skRJG4pqg5pa9w0F6Y4SSC
         AXwUUY81tm7GIBpZ4ANUPfLWBvmfiKEHAYtfhJy+CqK27Lj1FioDKVsbQXxE1hvC25
         7ISlBizx0JMSg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 06/12] net: assert the rtnl lock is held when calling __netif_set_xps_queue
Date:   Mon,  8 Feb 2021 18:19:11 +0100
Message-Id: <20210208171917.1088230-7-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ASSERT_RTNL at the top of __netif_set_xps_queue and add a comment
about holding the rtnl lock before the function.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1f7df0bd415c..abbb2ae6b3ed 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2605,7 +2605,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 	return new_map;
 }
 
-/* Must be called under cpus_read_lock */
+/* Must be called under rtnl_lock and cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map)
 {
@@ -2617,6 +2617,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	ASSERT_RTNL();
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.29.2

