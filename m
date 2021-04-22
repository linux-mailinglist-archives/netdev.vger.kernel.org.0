Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66740368786
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbhDVUAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:00:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236058AbhDVUAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 16:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E126100B;
        Thu, 22 Apr 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619121609;
        bh=f/P+1/0wMQTXhtxadIAI7KmLHWPPdlXhjk/DweX0UbQ=;
        h=Date:From:To:Cc:Subject:From;
        b=rfEbGF7maHCbOROn8ePxnwH8t94xIoe2A4oyzoJbeH0JXeGokZScZ8S757OVSfzSh
         PXMRAoY9tvwBe1iYHxaSJ7q3Djs0dQcg9jZXZJXRnSwSUvJ/QVru7y2CfIIRxN8htR
         SXpT1GUtxaq12aPNUFqCSW8Ir75dGE0GRatucZpYP97bhAQX1LlInV7bs04O/+9ipT
         p7U0caxepGRb7pZTJJqdXEDii5FuVrYRX75WC+Rvqlm0KAb2WIrWt+dgz2jg7VCgRM
         4DG+88NKuFqQ9w3ssbrBh1vu6Cu5ksApx44vHTzq4juYvV2WmuuOj9ds14di6ipf9S
         DpfU9PLAiluqQ==
Date:   Thu, 22 Apr 2021 15:00:32 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: [PATCH v2][next] wireless: wext-spy: Fix out-of-bounds warning
Message-ID: <20210422200032.GA168995@embeddedor>
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
these are just a couple of struct members, fix this by using direct
assignments, instead of memcpy().

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Use direct struct assignments instead of memcpy().
 - Fix one more instance of this same issue in function
   iw_handler_get_thrspy().
 - Update changelog text.
 - Add Kees' RB tag. 

 net/wireless/wext-spy.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/wireless/wext-spy.c b/net/wireless/wext-spy.c
index 33bef22e44e9..b379a0371653 100644
--- a/net/wireless/wext-spy.c
+++ b/net/wireless/wext-spy.c
@@ -120,8 +120,8 @@ int iw_handler_set_thrspy(struct net_device *	dev,
 		return -EOPNOTSUPP;
 
 	/* Just do it */
-	memcpy(&(spydata->spy_thr_low), &(threshold->low),
-	       2 * sizeof(struct iw_quality));
+	spydata->spy_thr_low = threshold->low;
+	spydata->spy_thr_high = threshold->high;
 
 	/* Clear flag */
 	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
@@ -147,8 +147,8 @@ int iw_handler_get_thrspy(struct net_device *	dev,
 		return -EOPNOTSUPP;
 
 	/* Just do it */
-	memcpy(&(threshold->low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
+	threshold->low = spydata->spy_thr_low;
+	threshold->high = spydata->spy_thr_high;
 
 	return 0;
 }
@@ -173,10 +173,10 @@ static void iw_send_thrspy_event(struct net_device *	dev,
 	memcpy(threshold.addr.sa_data, address, ETH_ALEN);
 	threshold.addr.sa_family = ARPHRD_ETHER;
 	/* Copy stats */
-	memcpy(&(threshold.qual), wstats, sizeof(struct iw_quality));
+	threshold.qual = *wstats;
 	/* Copy also thresholds */
-	memcpy(&(threshold.low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
+	threshold.low = spydata->spy_thr_low;
+	threshold.high = spydata->spy_thr_high;
 
 	/* Send event to user space */
 	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
-- 
2.27.0

