Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8151B58808D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiHBQ55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHBQ54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:57:56 -0400
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [IPv6:2a01:e0c:1:1599::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF2C14D16;
        Tue,  2 Aug 2022 09:57:54 -0700 (PDT)
Received: from [44.168.19.21] (unknown [86.242.59.24])
        (Authenticated sender: f6bvp@free.fr)
        by smtp3-g21.free.fr (Postfix) with ESMTPSA id 0658E13F8A2;
        Tue,  2 Aug 2022 18:57:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1659459472;
        bh=9EC6XiKAFdMUq2xR2bAkA0JPrVEyLr7V9rtAY73Zb+s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tyU2jyi85jK/QXqSMuu2ad38y6oYfXKACfNQZ4qpn7P6tu2K7JJ29MZaV+9AVTR5q
         YJmqtLTK28behDATLc08WdM9d31kGfd+IAqgBPhJiHO8rvZIu3cir9TmHhQtlTQxuI
         rGIJAdKteckVsqa7ApgUpM+LeY3fO9ypkbkvQ9/3Wpt2QF2b8Mw+TLEDbjXi8FdoO8
         8uvPXXPpMTpKy+BLFm3K0ETA7FlP3PBIa5/GsOtHzRe/sZzFT9tKrc9c8sLR8hXE8r
         khu1HoB/1cqnA4taEq03VFyNyhmSGLMHLJIfpLBgpq/aCylGF+k5CU/ER69b/KzUYf
         uKAqBXw1z1/SA==
Message-ID: <4a9e319d-e9f1-374d-9912-c4fd125925ff@free.fr>
Date:   Tue, 2 Aug 2022 18:57:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v1 net 1/1] net: avoid overflow when rose /proc displays
 timer information.
Content-Language: en-US
To:     Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas@osterried.de, thomas@x-berg.in-berlin.de,
        linux-hams@vger.kernel.org
References: <Yuk9vq7t7VhmnOXu@electric-eye.fr.zoreil.com>
From:   Bernard f6bvp <f6bvp@free.fr>
Organization: Dimension Parabole
In-Reply-To: <Yuk9vq7t7VhmnOXu@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Tested-by: Bernard Pidoux <f6bvp@free.fr>
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


