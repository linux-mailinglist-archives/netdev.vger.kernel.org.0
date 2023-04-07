Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3996DA6E6
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbjDGBZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjDGBZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FEE7EFA
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 18:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757B164C39
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 01:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A37C433D2;
        Fri,  7 Apr 2023 01:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680830739;
        bh=kmYk8osuwljGbsjZRcIPn4+yay9MGE5Nwn1xvh6rI/M=;
        h=From:To:Cc:Subject:Date:From;
        b=jYVVawvsssyyvQxrgtAmBUkwa00/TzTre9JSxFc0gxYJYRJXmsNjv0mwqHCyUhGAP
         8K+B4eTQ8LMomBKXazV00lkryrd9sBXlEpBreKwfY78UzFUtOHWsunYw+Dw/b2e3AP
         2wWTel/f9PP+DewsZMiYcgEmRxBoJREFPSbqII0lm+YhNAgF9ZisGkbWvrWiqjLxXk
         eU34p4NHAk89xqZQ7VW6BAd38M4gcyMisupaYiNRgz6d3Vklqb5Mc4iQWUGUA4l2Ba
         qWmVPNio+hZi9IEFIKnoIOlVW3mafUuOyHc4OTWVBsoxBI4eAqSHKwR7wREXsPxn2V
         R0pn/zx6rGrmw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        herbert@gondor.apana.org.au, alexander.duyck@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, willemb@google.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 0/7] net: lockless stop/wake combo macros
Date:   Thu,  6 Apr 2023 18:25:29 -0700
Message-Id: <20230407012536.273382-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lot of drivers follow the same scheme to stop / start queues
without introducing locks between xmit and NAPI tx completions.
I'm guessing they all copy'n'paste each other's code.
The original code dates back all the way to e1000 and Linux 2.6.19.

v4:
 - adjust a comment in patch 4
 - use IS_ENABLED() in patch 7
v3: https://lore.kernel.org/all/20230405223134.94665-1-kuba@kernel.org/
 - render the info as part of documentation, maybe someone will
   notice and use it (patches 1, 2, 3 are new)
 - use the __after_atomic barrier
 - add last patch to avoid a barrier in the wake path
more detailed change logs in the patches.

v2: https://lore.kernel.org/all/20230401051221.3160913-2-kuba@kernel.org/
 - really flip the unlikely into a likely in __netif_tx_queue_maybe_wake()
 - convert if / else into pre-init of _ret
v1: https://lore.kernel.org/all/20230322233028.269410-1-kuba@kernel.org/
 - perdicate -> predicate
 - on race use start instead of wake and make a note of that
   in the doc / comment at the start
rfc: https://lore.kernel.org/all/20230311050130.115138-1-kuba@kernel.org/

Jakub Kicinski (7):
  docs: net: reformat driver.rst from a list to sections
  docs: net: move the probe and open/close sections of driver.rst up
  docs: net: use C syntax highlight in driver.rst
  net: provide macros for commonly copied lockless queue stop/wake code
  ixgbe: use new queue try_stop/try_wake macros
  bnxt: use new queue try_stop/try_wake macros
  net: piggy back on the memory barrier in bql when waking queues

 Documentation/networking/driver.rst           | 119 ++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  42 +----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  42 ++---
 include/linux/netdevice.h                     |   3 +-
 include/net/netdev_queues.h                   | 163 ++++++++++++++++++
 5 files changed, 262 insertions(+), 107 deletions(-)
 create mode 100644 include/net/netdev_queues.h

-- 
2.39.2

