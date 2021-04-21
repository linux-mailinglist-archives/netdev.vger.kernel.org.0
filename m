Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E343675DD
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343758AbhDUXnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237964AbhDUXnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 19:43:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63266613DC;
        Wed, 21 Apr 2021 23:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619048597;
        bh=RBahKrZRpdTopHgPiuzI27MUkFSEAGAZ67SmGWh+3DA=;
        h=Date:From:To:Cc:Subject:From;
        b=HawRR0EyA/J/BBKRnMqHS/rwp9157ZqRy672M3zIdn6osTREHRUTyUsOztuIeNBwv
         18dVY+LiqGuiI6AqZST9T6JOZ7QQu/uhWVN0fsYdgJO2pWLVcDloFfyxSzEBJrlYyZ
         jg8IWKZAbPuzuRKpPOlw3fjom97UiZcNZgbg88dvWMSt7qlwJGgiaPUCQjW6SeTcs3
         s8yHOCIAwbIEGIwRWAoMKsfM0u4tIqC5+CS5tJyONUWL9MfSlcDsr2LMX4J7Kon4fx
         SCPzStU6jeK88OIqA9fZRKIV1RXlpoLO8bjDGVReUYM5FhP0X7eo6oJbvili+iYrIZ
         Ue5CLedEeWV5Q==
Date:   Wed, 21 Apr 2021 18:43:37 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH][next] wireless: wext-spy: Fix out-of-bounds warning
Message-ID: <20210421234337.GA127225@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning:

net/wireless/wext-spy.c:178:2: warning: 'memcpy' offset [25, 28] from the object at 'threshold' is out of the bounds of referenced subobject 'low' with type 'struct iw_quality' at offset 20 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
couple of struct members adjacent to each other in a single call to
memcpy(). This causes a legitimate compiler warning because memcpy()
overruns the length of &threshold.low and &spydata->spy_thr_low. As
these are just a couple of members, fix this by copying each one of
them in separate calls to memcpy().

Also, while there, use sizeof(threshold.qual) instead of
sizeof(struct iw_quality)) in another call to memcpy()
above.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/wireless/wext-spy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/wext-spy.c b/net/wireless/wext-spy.c
index 33bef22e44e9..bb2de7c6bee4 100644
--- a/net/wireless/wext-spy.c
+++ b/net/wireless/wext-spy.c
@@ -120,8 +120,8 @@ int iw_handler_set_thrspy(struct net_device *	dev,
 		return -EOPNOTSUPP;
 
 	/* Just do it */
-	memcpy(&(spydata->spy_thr_low), &(threshold->low),
-	       2 * sizeof(struct iw_quality));
+	memcpy(&spydata->spy_thr_low, &threshold->low, sizeof(threshold->low));
+	memcpy(&spydata->spy_thr_high, &threshold->high, sizeof(threshold->high));
 
 	/* Clear flag */
 	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
@@ -173,10 +173,10 @@ static void iw_send_thrspy_event(struct net_device *	dev,
 	memcpy(threshold.addr.sa_data, address, ETH_ALEN);
 	threshold.addr.sa_family = ARPHRD_ETHER;
 	/* Copy stats */
-	memcpy(&(threshold.qual), wstats, sizeof(struct iw_quality));
+	memcpy(&threshold.qual, wstats, sizeof(threshold.qual));
 	/* Copy also thresholds */
-	memcpy(&(threshold.low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
+	memcpy(&threshold.low, &spydata->spy_thr_low, sizeof(threshold.low));
+	memcpy(&threshold.high, &spydata->spy_thr_high, sizeof(threshold.high));
 
 	/* Send event to user space */
 	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
-- 
2.27.0

