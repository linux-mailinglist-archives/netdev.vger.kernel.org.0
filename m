Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD5F587E95
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 17:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiHBPIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 11:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiHBPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 11:08:20 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360D826AC9;
        Tue,  2 Aug 2022 08:08:19 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 272F7g5t2380071;
        Tue, 2 Aug 2022 17:07:42 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 272F7g5t2380071
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1659452862;
        bh=2oD14gOZO93tqzNZQjZFooIHsA19Pom4E2LBsvbbNMk=;
        h=Date:From:To:Cc:Subject:From;
        b=jJZhLnZ/lG173aiPYJfjoqNgC2+Hp9y2Hoyocxz+Ze90D9tr/9uAp9QaD5SAADs/+
         P5tndqCCSnO7QKJGk9RCZbmz9HEGB4bOpSMcj4SEp8UB86FXuuub48/bhJ0Kl/N/Sp
         0/OK1RMwWLz+ZLnXs+Iaq3wvwartlGjc0HSrJf5U=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 272F7god2380070;
        Tue, 2 Aug 2022 17:07:42 +0200
Date:   Tue, 2 Aug 2022 17:07:42 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, f6bvp@free.fr, thomas@osterried.de,
        thomas@x-berg.in-berlin.de, linux-hams@vger.kernel.org
Subject: [PATCH v1 net 1/1] net: avoid overflow when rose /proc displays
 timer information.
Message-ID: <Yuk9vq7t7VhmnOXu@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rose /proc code does not serialize timer accesses.

Initial report by Bernard F6BVP Pidoux exhibits overflow amounting
to 116 ticks on its HZ=250 system.

Full timer access serialization would imho be overkill as rose /proc
does not enforce consistency between displayed ROSE_STATE_XYZ and
timer values during changes of state.

The patch may also fix similar behavior in ax25 /proc, ax25 ioctl
and netrom /proc as they all exhibit the same timer serialization
policy. This point has not been reported though.

The sole remaining use of ax25_display_timer - ax25 rtt valuation -
may also perform marginally better but I have not analyzed it too
deeply.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Thomas DL9SAU Osterried <thomas@osterried.de>
Link: https://lore.kernel.org/all/d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr/
---
 net/ax25/ax25_timer.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Bernard, can you formally test and add your "Tested-by:" on this one ?

diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index 85865ebfdfa2..9f7cb0a7c73f 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -108,10 +108,12 @@ int ax25_t1timer_running(ax25_cb *ax25)
 
 unsigned long ax25_display_timer(struct timer_list *timer)
 {
+	long delta = timer->expires - jiffies;
+
 	if (!timer_pending(timer))
 		return 0;
 
-	return timer->expires - jiffies;
+	return max(0L, delta);
 }
 
 EXPORT_SYMBOL(ax25_display_timer);
-- 
2.37.1

