Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC6451F94A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiEIKI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiEIKIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:08:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862CF262731;
        Mon,  9 May 2022 03:04:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 366BE6153B;
        Mon,  9 May 2022 10:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FD6C385A8;
        Mon,  9 May 2022 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652090429;
        bh=zXwz7GBUtoYyq48DbmmQ/NhoRvUGcC7nHxrn5Jrr3fI=;
        h=From:To:Cc:Subject:Date:From;
        b=klzMUXva7x9Zm6p44Nhw472fDUXTnsMiMbDYF61/noa6xzyRAH7++5PkNpXKJ7rHR
         jJasVJRT90cbfVvGoGUbaH+qJV9Nr/PWQB2ZV9Ms0c+6UqBBtTC164Mf0bSTwyua40
         zIEqRBylGQaAQSzfu1abgkzkR2uUnAPPTG5cCCTGJ2KoxAvw3yyrQYgjZMyGVyRQkq
         uPlxXoNb0a/+7/1ba05HMJCGNd9ETJ20TUYwd1rBuCPKbhTKhaGhAsJvqEDx7yP3K/
         oc+NEOVgK7jQb+A++V0JoBGvYK/4T9QZdYGHAk+/oP/8JDLrAtZo0vlv6OMYYCHS6t
         iVcDod4APK1tA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org, jbrouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH net-next] Documentation: update networking/page_pool.rst with ethtool APIs
Date:   Mon,  9 May 2022 12:00:01 +0200
Message-Id: <2b0f8921096d45e1f279d1b7b99fe467f6f3dc6d.1652090091.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 Documentation/networking/page_pool.rst | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
index 5db8c263b0c6..ef5e18cf7cdf 100644
--- a/Documentation/networking/page_pool.rst
+++ b/Documentation/networking/page_pool.rst
@@ -146,6 +146,29 @@ The ``struct page_pool_recycle_stats`` has the following fields:
   * ``ring_full``: page released from page pool because the ptr ring was full
   * ``released_refcnt``: page released (and not recycled) because refcnt > 1
 
+The following APIs can be used to report page_pool stats through ethtool and
+avoid code duplication in each driver:
+
+* page_pool_ethtool_stats_get_strings(): reports page_pool ethtool stats
+  strings according to the ``struct page_pool_stats``
+     * ``rx_pp_alloc_fast``
+     * ``rx_pp_alloc_slow``
+     * ``rx_pp_alloc_slow_ho``
+     * ``rx_pp_alloc_empty``
+     * ``rx_pp_alloc_refill``
+     * ``rx_pp_alloc_waive``
+     * ``rx_pp_recycle_cached``
+     * ``rx_pp_recycle_cache_full``
+     * ``rx_pp_recycle_ring``
+     * ``rx_pp_recycle_ring_full``
+     * ``rx_pp_recycle_released_ref``
+
+* page_pool_ethtool_stats_get_count(): reports the number of stats defined in
+  the ethtool page_pool APIs
+
+* page_pool_ethtool_stats_get(u64 \*data, void \*stats): reports the page_pool statistics accounted in
+  the ``stats`` pointer in the ethtool ``data`` pointer provided by the caller
+
 Coding examples
 ===============
 
-- 
2.35.3

