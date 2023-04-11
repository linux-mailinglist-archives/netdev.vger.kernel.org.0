Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8656DE58F
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjDKUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKUSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:18:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA6510E7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D255062769
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F253EC433EF;
        Tue, 11 Apr 2023 20:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681244299;
        bh=PbwvBC5De0//FRmtIuTY74F0zOqEAf1tjnY9okmf+UI=;
        h=From:To:Cc:Subject:Date:From;
        b=lAZQiMejxJHK0Mivm1iPpQJR5jlnlxyWfsT6QZTHipzyzIXLQEQyPnlJxVPy77IaU
         NkcTZ2JDFZE50Wg5AM83W6GZUNJwA7tTG9vMkEfcRwWDNvsgw8WSYVesQYmn7qrIc3
         HQwc+lw9iBkfSYl3mkTjgQMQqUaygHJGMlln54dkImx/kl2NYYDEmuEZCfPRoEw5o+
         66e78TYKgwrEUnqbZqLirM9tgQxsDPw6OzqzE2wSwV6PfNxzODpD+ttNDxdXfISCvb
         IkhRC2QygZD2B0vE0rMzwpzYLHcw5cuYGwrdPE96nUgF4jcj+QHcnPLnf45gnhkLDS
         Fw3sdAdc7YU0Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] page_pool: allow caching from safely localized NAPI
Date:   Tue, 11 Apr 2023 13:17:57 -0700
Message-Id: <20230411201800.596103-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I went back to the explicit "are we in NAPI method", mostly
because I don't like having both around :( (even tho I maintain
that in_softirq() && !in_hardirq() is as safe, as softirqs do
not nest).

Still returning the skbs to a CPU, tho, not to the NAPI instance.
I reckon we could create a small refcounted struct per NAPI instance
which would allow sockets and other users so hold a persisent
and safe reference. But that's a bigger change, and I get 90+%
recycling thru the cache with just these patches (for RR and
streaming tests with 100% CPU use it's almost 100%).

Some numbers for streaming test with 100% CPU use (from previous version,
but really they perform the same):

		HW-GRO				page=page
		before		after		before		after
recycle:
cached:			0	138669686		0	150197505
cache_full:		0	   223391		0	    74582
ring:		138551933         9997191	149299454		0
ring_full: 		0             488	     3154	   127590
released_refcnt:	0		0		0		0

alloc:
fast:		136491361	148615710	146969587	150322859
slow:		     1772	     1799	      144	      105
slow_high_order:	0		0		0		0
empty:		     1772	     1799	      144	      105
refill:		  2165245	   156302	  2332880	     2128
waive:			0		0		0		0

v1:
 - rename the arg in_normal_napi -> napi_safe
 - also allow recycling in __kfree_skb_defer()
rfcv2: https://lore.kernel.org/all/20230405232100.103392-1-kuba@kernel.org/

Jakub Kicinski (3):
  net: skb: plumb napi state thru skb freeing paths
  page_pool: allow caching from safely localized NAPI
  bnxt: hook NAPIs to page pools

 Documentation/networking/page_pool.rst    |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |  1 +
 include/linux/netdevice.h                 |  3 ++
 include/linux/skbuff.h                    | 20 +++++++----
 include/net/page_pool.h                   |  3 +-
 net/core/dev.c                            |  3 ++
 net/core/page_pool.c                      | 15 ++++++--
 net/core/skbuff.c                         | 42 ++++++++++++-----------
 8 files changed, 58 insertions(+), 30 deletions(-)

-- 
2.39.2

