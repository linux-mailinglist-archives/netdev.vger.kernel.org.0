Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3060843BFF1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhJ0ChG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238053AbhJ0ChG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C4616103C;
        Wed, 27 Oct 2021 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302081;
        bh=9AVlxNAWFlpRbMsM/frpCcC/ySvM8cw47hKtfXxlrDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ry7gMZQPWy4VpjIHCV3yxrHeuEafx+CPSpeiLpALTz7EVxq8vBq99bX64OgiHSwzw
         bICFdHh3cC860PBTryhl96bTwra9qv+i+tgDTvgA9tuQLnwuEEsHG2G7WwYKLJ/c3o
         UQSHrS978k4rhweXJ7AwO74T5pgTVIDHdUHwTZCVlxIxanpEdta67hSSl+Vpdpj6q9
         ecQ1GUYs+6k4qCQg7SDGY/Wan+2He9IO6uFGBB6PcwjH+7SaYvZW17QjSU8XDfulqo
         LrupK5jejH282NlB4sZ0MNnXwrXocLywOmrHBBwOT43MDYzCvTeB3oJpwzJhY3FJ7R
         fGKjsk+qLYohA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/14] lib: bitmap: Introduce node-aware alloc API
Date:   Tue, 26 Oct 2021 19:33:34 -0700
Message-Id: <20211027023347.699076-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Expose new node-aware API for bitmap allocation:
bitmap_alloc_node() / bitmap_zalloc_node().

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/bitmap.h |  2 ++
 lib/bitmap.c           | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 37f36dad18bd..a241dcf50f39 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -123,6 +123,8 @@ struct device;
  */
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags);
 unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags);
+unsigned long *bitmap_alloc_node(unsigned int nbits, gfp_t flags, int node);
+unsigned long *bitmap_zalloc_node(unsigned int nbits, gfp_t flags, int node);
 void bitmap_free(const unsigned long *bitmap);
 
 /* Managed variants of the above. */
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 663dd81967d4..926408883456 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1398,6 +1398,19 @@ unsigned long *bitmap_zalloc(unsigned int nbits, gfp_t flags)
 }
 EXPORT_SYMBOL(bitmap_zalloc);
 
+unsigned long *bitmap_alloc_node(unsigned int nbits, gfp_t flags, int node)
+{
+	return kmalloc_array_node(BITS_TO_LONGS(nbits), sizeof(unsigned long),
+				  flags, node);
+}
+EXPORT_SYMBOL(bitmap_alloc_node);
+
+unsigned long *bitmap_zalloc_node(unsigned int nbits, gfp_t flags, int node)
+{
+	return bitmap_alloc_node(nbits, flags | __GFP_ZERO, node);
+}
+EXPORT_SYMBOL(bitmap_zalloc_node);
+
 void bitmap_free(const unsigned long *bitmap)
 {
 	kfree(bitmap);
-- 
2.31.1

