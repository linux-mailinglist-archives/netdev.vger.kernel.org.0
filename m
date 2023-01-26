Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82DA067C1F0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 01:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjAZAp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 19:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235541AbjAZAp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 19:45:57 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5735D5D922
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 16:45:55 -0800 (PST)
Received: (Authenticated sender: schoen@loyalty.org)
        by mail.gandi.net (Postfix) with ESMTPSA id DDB04C0005;
        Thu, 26 Jan 2023 00:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=loyalty.org; s=gm1;
        t=1674693954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9SkEaIEAH/ZL6mF+tgU7UGvJXdQfBdgqI+YVik6HhUI=;
        b=m2wj6pMdh+yKBkQ4EfaT3ZVq47Z3eL8/PBUr95gqypeKUDR6y+4elvtKRwJpcUYKS+5LoW
        reLVGpxVaxRPsTddb5tcFrrRJsz+FA2UhVxV+h6zossCeELaQCl9Xzh68PPS1HTQ1WY46D
        6Z6o5qKy5z5of91M0MJN068bWutEbooLU4kmeu3xmzdd3bjgLmDPsJkV/CBOZ52UsonKwg
        Zrg68/abYHcodGSU48Z5lMqogLbViXpDme/zOI9zGdrK2+kxJXCekAdv+Vws/2D/shbHPF
        gW7SLYdfV293X2yc+Y06vC5+ZW+6X3YAKu9zyLiWgnoypO47mm91LXhyTVw75A==
Date:   Wed, 25 Jan 2023 16:45:48 -0800
From:   Seth David Schoen <schoen@loyalty.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: Backporting *ip: Treat IPv4 segment's lowest address as unicast*
 to Linux 5.10.y?
Message-ID: <20230126004548.GA510532@demorgan>
References: <ba85381a-37dc-9e61-de71-527d686d6430@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba85381a-37dc-9e61-de71-527d686d6430@molgen.mpg.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Menzel writes:

> Dear Linux folks,
> 
> 
> Seth backported commit 94c821c74bf5fe0c25e09df5334a16f98608db90 in OpenWrt
> [1]. Could we also add to the Linux LTS 5.10 series?

Thanks for suggesting this.  This would be something like the attached
version (which is against the 5.10 stable tree), perhaps with different
naming/commit message documentations for backporting.

I understand if this turns out to be too much like a functionality
change rather than a bugfix for 5.10; in that case, we could just
continue making it available on our own repo.


From 323c87d4c2de7598ac810632450816732056b111 Mon Sep 17 00:00:00 2001
From: Seth Schoen <schoen@loyalty.org>
Date: Sun, 22 Jan 2023 14:39:24 -0800
Subject: [PATCH] Backport 5.14: lowest-address is not broadcast

Allow the lowest address in a network segment to be used as an
ordinary unicast address, not a duplicate broadcast address.

Signed-off-by: Seth David Schoen <schoen@loyalty.org>
Suggested-by: John Gilmore <gnu@toad.com>
---
 net/ipv4/fib_frontend.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 5f786ef662ea..0b3fadc002d6 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1129,10 +1129,8 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 				  prefix, ifa->ifa_prefixlen, prim,
 				  ifa->ifa_rt_priority);
 
-		/* Add network specific broadcasts, when it takes a sense */
+		/* Add the network broadcast address, when it makes sense */
 		if (ifa->ifa_prefixlen < 31) {
-			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix, 32,
-				  prim, 0);
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
 			arp_invalidate(dev, prefix | ~mask, false);
-- 
2.25.1
