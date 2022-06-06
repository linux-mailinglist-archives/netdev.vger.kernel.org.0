Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586CC53EF63
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 22:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbiFFUQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 16:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiFFUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 16:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B717B7C;
        Mon,  6 Jun 2022 13:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD538B81B41;
        Mon,  6 Jun 2022 20:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121CFC34115;
        Mon,  6 Jun 2022 20:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654546572;
        bh=4ekHkjqVyQuiN7Z+qLDAIpo/+34U7jys4QWy2f3LQK0=;
        h=From:To:Cc:Subject:Date:From;
        b=GVJGRZokkZnyPOVuUnZtXg6IcvAfFLiXZeiHznuclEDLmEzGFTHej+afdF5heNDgQ
         YcMz59EoDVGUyM0WoCcO4Ki0IFW+EdQVyoNez6JMwYj4hdgLHfqgk9OTNZObxNhBFE
         OD1ddu6XYyP903U1+ZyZzh6RuhtPbUz3tLW/PzoTtlJu/WywlWvsv0xCGRrdMm7+Y1
         Q3BBffYDIzHF4yi7HlDo+zm0yhqejRU894v1XlxhzezNIdXC5xIj0Sr2yWBQbM8rkM
         BkWv0YkGEPGNIFV7LYmzRWSWMn0LlEH61BuRfpTsIoZowSUnXyXgAOE2tUIQrWCx+i
         PK3A6mCVG9QFw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org, jbrouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] Documentation: update networking/page_pool.rst with ethtool APIs
Date:   Mon,  6 Jun 2022 22:15:45 +0200
Message-Id: <8c1f582d286fd5a7406dfff895eea39bb8fedca6.1654546043.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update page_pool documentation with page_pool ethtool stats APIs.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- get rid of literal markup
---
 Documentation/networking/page_pool.rst | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 5db8c263b0c6..a40203297cd3 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -146,6 +146,29 @@ The ``struct page_pool_recycle_stats`` has the following fields:
   * ``ring_full``: page released from page pool because the ptr ring was full
   * ``released_refcnt``: page released (and not recycled) because refcnt > 1
 
+The following APIs can be used to report page_pool stats through ethtool and
+avoid code duplication in each driver:
+
+* page_pool_ethtool_stats_get_strings(): reports page_pool ethtool stats
+  strings according to the struct page_pool_stats
+     * rx_pp_alloc_fast
+     * rx_pp_alloc_slow
+     * rx_pp_alloc_slow_ho
+     * rx_pp_alloc_empty
+     * rx_pp_alloc_refill
+     * rx_pp_alloc_waive
+     * rx_pp_recycle_cached
+     * rx_pp_recycle_cache_full
+     * rx_pp_recycle_ring
+     * rx_pp_recycle_ring_full
+     * rx_pp_recycle_released_ref
+
+* page_pool_ethtool_stats_get_count(): reports the number of stats defined in
+  the ethtool page_pool APIs
+
+* page_pool_ethtool_stats_get(u64 \*data, void \*stats): reports the page_pool statistics accounted in
+  the stats pointer in the ethtool data pointer provided by the caller
+
 Coding examples
 ===============
 
-- 
2.35.3

