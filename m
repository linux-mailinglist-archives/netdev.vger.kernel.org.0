Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 141D06E05F7
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDME0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjDME0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA851715
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76A2A63712
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7010DC433D2;
        Thu, 13 Apr 2023 04:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681359976;
        bh=HPQ5Hfp32JVARejB9zNsR8sEIhNPcA57ns95gjhndPI=;
        h=From:To:Cc:Subject:Date:From;
        b=q53GqHtFjq+XycNOCci0dCtDeLNFSqyWzI52NJCKBoG4bZBzKLaHH5jHXOqNQVgr9
         X3OK7+Azjf0VK374sDTIIVTCVmr/WFkFTPXovJuahFnugkCr/J53jtF5IDx7ouDaQF
         rY+VSE8TyMcAcc5OECSV7TPdWaqlz2jmA8gy1CMc+woiR/dle8RQP22YQTu8P9KsE1
         ijKWe2mni6n1rxhwdflEo9JzTA4S45IOeyIVjEbtpGzZqERH7iq9GD2hiMe3jNvifa
         p4YYW+PwDrk6CBSpGdU4UbQbAEdqhU2/WmlwbmObF7Ewm1hxOE6Kvvlhu41J3TeW0y
         zaYXDoyoZ0cNQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        linyunsheng@huawei.com, alexander.duyck@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/3] page_pool: allow caching from safely localized NAPI
Date:   Wed, 12 Apr 2023 21:26:02 -0700
Message-Id: <20230413042605.895677-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

v2:
 - minor commit message fixes (patch 1)
v1: https://lore.kernel.org/all/20230411201800.596103-1-kuba@kernel.org/
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

