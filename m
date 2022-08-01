Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB24158620E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 02:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiHAAjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 20:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHAAjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 20:39:12 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC532AEA
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 17:39:09 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2710d2S42336390;
        Mon, 1 Aug 2022 02:39:02 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2710d2S42336390
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1659314342;
        bh=Zxv04oT1Cg4jN72m0ayc33xrbu48Tl96Y3zZxHd+yR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSyI+AUBfRVw5UjMTX0g9/HhOzc/DxiAb0Oy1ruUwgx2MNTkiWHLsmm3bWkSemlls
         pIRTkoltGcLYch6yIVXNPuEv+tu451qsXFzGjNmzONu4eifUxkG2KodrYncb8zHBn6
         L/qsj3tXw7Lb05wQ9qy0NwFBFtSltT768AHVwV7k=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2710d1sL2336389;
        Mon, 1 Aug 2022 02:39:01 +0200
Date:   Mon, 1 Aug 2022 02:39:01 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Bernard f6bvp <f6bvp@free.fr>
Cc:     Eric Dumazet <edumazet@google.com>, linux-hams@vger.kernel.org,
        Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>,
        netdev@vger.kernel.org
Subject: Re: rose timer t error displayed in /proc/net/rose
Message-ID: <YucgpeXpqwZuievg@electric-eye.fr.zoreil.com>
References: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5e93cc7-a91f-13d3-49a1-b50c11f0f811@free.fr>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard f6bvp <f6bvp@free.fr> :
> Rose proc timer t error
> 
> Timer t is decremented one by one during normal operations.
> 
> When decreasing from 1 to 0 it displays a very large number until next clock
> tic as demonstrated below.
> 
> t1, t2 and t3 are correctly handled.

"t" is ax25_display_timer(&rose->timer) / HZ whereas "tX" are rose->tX / HZ.

ax25_display_timer() does not like jiffies > timer->expires (and it should
probably return plain seconds btw).

You may try the hack below.

diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index 85865ebfdfa2..b77433fff0c9 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -108,10 +108,9 @@ int ax25_t1timer_running(ax25_cb *ax25)
 
 unsigned long ax25_display_timer(struct timer_list *timer)
 {
-	if (!timer_pending(timer))
-		return 0;
+	long delta = timer->expires - jiffies;
 
-	return timer->expires - jiffies;
+	return jiffies_delta_to_clock_t(delta) * HZ;
 }
 
 EXPORT_SYMBOL(ax25_display_timer);
