Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDC8461B91
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 17:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344257AbhK2QN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 11:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344237AbhK2QLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 11:11:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02550C08EA77
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:11:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id o20so72130098eds.10
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ynN37RQfo3w1GXu23FSiWbODZ6CssweCoIJBmZ7EnNg=;
        b=SwDPCaX4bFMt5rQqU+IWB4WAEAKj+cPcaX9hasPL0AU348DDOHilli1HTAnfjs3Ty6
         SM11PykkTOEZjQNbxFXelQ+m11pcHfM0/Tx2nXjiqoYQ8PWuge3nYi5hy5C7RiKN0Yhs
         qRqapXl+NBQNcd7cxMok0TT2TMdSedDQvGI2zJHPV/2zkGr/n29a1rXopPqPoiQ2CE0H
         lH0zKOt7v75Vn82+UHqpRw0DvUASkBCh4FFA9Nk05LIE4JVt70RfcHdC9gD9uX0MAsRF
         +MJCN3AivwNrTIGSOM7wb0vk0bPpSeYxDAsKS6W6x98d5NtmjWvByyt5OI17ciE/HzBr
         XhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ynN37RQfo3w1GXu23FSiWbODZ6CssweCoIJBmZ7EnNg=;
        b=W4DhcBovhaPqYquvy/5L1uu1xTlPWLdT9JKtkpyiLrcR+7dkrc91FUlZZXwHyEqDUR
         BmvTN1JK4wUlYpy0nWqoe45h/E6iCOfyiPSSZ67Qh9XnrvwhNVYRF1z5HSDR2EUCbHxu
         nbjc9dr12mA4upmQ5VSA+H8Z589gaOVcTVI3wptpJN9ZPRTKMLDHCRloEyn+Jlf52Krg
         Um4MwxqTIjX2UIVNy2unegwqR79gL0/9NiPkgjuM0HC4ZTJvJwDyZ0VbahUV+FhPPwso
         0iEUteiZhygNNTbEUAqWjsxHna6qvmMYVnTVhpK331TK/Ia6AH8oELpC/w3m64UqlwEN
         rmWg==
X-Gm-Message-State: AOAM533Y5pB63xuINckUAoT9cH8i7HBIwCpU9FkFhvdbxtVnzys0GG4s
        RzASRTx62k9XyQDU0WAF6QB5P8HgZMbPmnO5
X-Google-Smtp-Source: ABdhPJwlbns48iu39TJ+KhzVpb20hhtWqeKu6Bx/BNEX+ZehWlRCRjdyOPqgNCVte1iSfQUxp1NrQQ==
X-Received: by 2002:a05:6402:4389:: with SMTP id o9mr74817188edc.138.1638195113865;
        Mon, 29 Nov 2021 06:11:53 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id gn26sm7716605ejc.14.2021.11.29.06.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 06:11:53 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        idosch@idosch.org, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH net] net: ipv6: make fib6_nh_init properly clean after itself on error
Date:   Mon, 29 Nov 2021 16:11:51 +0200
Message-Id: <20211129141151.490533-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Currently we have different cleanup expectations by different users of
fib6_nh_init:
 1. nh_create_ipv6
 - calls fib6_nh_release manually which does full cleanup

 2. ip6_route_info_create
 - calls fib6_info_release to drop refs to 0 and schedules rcu call
   for fib6_info_destroy_rcu() which also does full cleanup

 3. fib_check_nh_v6_gw
 - doesn't do any cleanup on error, expects fib6_nh_init to clean up
   after itself fully (nhc_pcpu_rth_output per-cpu memory leak on error)

We can alter fib6_nh_init to properly cleanup after itself so
expectations would be the same for everyone and noone would have to do
anything in such case. It is safe because the route is not inserted yet
so the fib6_nh should not be visible at fib6_nh_init point, thus it
should be possible to free up all resources in its error path. The
problems (and leaks) are because it doesn't free all resources in its
error path, the nhc_pcpu_rth_output per-cpu allocation done by
fib_nh_common_init is not cleaned up and it expects its callers to clean
up if an error occurred after it, e.g. the dst per-cpu allocation
might fail. This change allows us to fix the memory leak at 3. and also
to simplify nh_create_ipv6 and remove the special error handling.

Fixes: 717a8f5b2923 ("ipv4: Add fib_check_nh_v6_gw")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
Sending as RFC to see what people think. I've tested this patch under
heavy load with replacing/traffic forwarding/nexthop add/del etc.
I've also tested error paths by adding artificial ENOMEM errors in
different fib6_nh_init stages while running kmemleak.

 net/ipv4/nexthop.c |  8 +-------
 net/ipv6/route.c   | 15 +++++++++------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5dbd4b5505eb..a7debafe8b90 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2565,14 +2565,8 @@ static int nh_create_ipv6(struct net *net,  struct nexthop *nh,
 	/* sets nh_dev if successful */
 	err = ipv6_stub->fib6_nh_init(net, fib6_nh, &fib6_cfg, GFP_KERNEL,
 				      extack);
-	if (err) {
-		/* IPv6 is not enabled, don't call fib6_nh_release */
-		if (err == -EAFNOSUPPORT)
-			goto out;
-		ipv6_stub->fib6_nh_release(fib6_nh);
-	} else {
+	if (!err)
 		nh->nh_flags = fib6_nh->fib_nh_flags;
-	}
 out:
 	return err;
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 42d60c76d30a..2107b13cc9ab 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3635,7 +3635,9 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		in6_dev_put(idev);
 
 	if (err) {
-		lwtstate_put(fib6_nh->fib_nh_lws);
+		/* check if we failed after fib_nh_common_init() was called */
+		if (fib6_nh->nh_common.nhc_pcpu_rth_output)
+			fib_nh_common_release(&fib6_nh->nh_common);
 		fib6_nh->fib_nh_lws = NULL;
 		dev_put(dev);
 	}
@@ -3822,7 +3824,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	} else {
 		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
 		if (err)
-			goto out;
+			goto out_free;
 
 		fib6_nh = rt->fib6_nh;
 
@@ -3841,7 +3843,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
 			NL_SET_ERR_MSG(extack, "Invalid source address");
 			err = -EINVAL;
-			goto out;
+			goto out_free;
 		}
 		rt->fib6_prefsrc.addr = cfg->fc_prefsrc;
 		rt->fib6_prefsrc.plen = 128;
@@ -3849,12 +3851,13 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		rt->fib6_prefsrc.plen = 0;
 
 	return rt;
-out:
-	fib6_info_release(rt);
-	return ERR_PTR(err);
+
 out_free:
 	ip_fib_metrics_put(rt->fib6_metrics);
+	if (rt->nh)
+		nexthop_put(rt->nh);
 	kfree(rt);
+out:
 	return ERR_PTR(err);
 }
 
-- 
2.31.1

