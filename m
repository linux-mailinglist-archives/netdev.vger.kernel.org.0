Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8F6D8B0B
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjDEXWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjDEXWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:22:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A355FCF
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7187B62B5D
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 23:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849FBC433EF;
        Wed,  5 Apr 2023 23:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680736929;
        bh=oKUCiCcmcU4gTZWvJ+bBuWD2+rF9BDrltJBGwfsBq9E=;
        h=From:To:Cc:Subject:Date:From;
        b=f2mbGFbMp4qFjF3xGPkaUWpLvOD9t1LGqd1RfL6j3v7Lwc0NF/0gm7tjPKHufu4hv
         rzRlWd8B3bWi1iJMbEzfz5SiPBCLIuG+GXy7YQ+ev5A6tkieFJo0MfZTZATD8ZPIW4
         TUgjaoLqQo8XWRShMr4XWEKs7ogvt3fzPRQaPo3Z5I3j5ol7OFzqx1GSxoOzA2MUPx
         SAFGBy8SLmUKhOb9wfwO/PUU4J43KWJP/aaFnN8iFMPvFsfpuOauq7gxkAzGyjXBmA
         nNE/JYEaqfNBas5xE6U4PJcHqSqgI8+p0HMAJN9cBrUX09FS7+aC43+CKZ3XPtEou6
         kxVGmZj6yuhqA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next v2 0/3] page_pool: allow caching from safely localized NAPI
Date:   Wed,  5 Apr 2023 16:20:57 -0700
Message-Id: <20230405232100.103392-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
 net/core/skbuff.c                         | 43 ++++++++++++-----------
 8 files changed, 59 insertions(+), 30 deletions(-)

-- 
2.39.2

