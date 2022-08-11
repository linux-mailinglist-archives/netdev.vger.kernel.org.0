Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0AD5903A2
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiHKQ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237761AbiHKQZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:25:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE4531932;
        Thu, 11 Aug 2022 09:06:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69B9A61389;
        Thu, 11 Aug 2022 16:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD5DC433D6;
        Thu, 11 Aug 2022 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233998;
        bh=3mvOJ1CHNmXUJ1Rtx6EZodCPeQuOIOAhS6IYWBmeQe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2ZZIEFs8ks3gfJ3XawoGb9brPUS8m+9MHMetUEJ0RIQwObcNNzU9ibjc31dxN2Qu
         AxnCOa/RNJ5UwjvVM5rtuyPaxX0SVWT8QPKFLwv0WG+5FU2RjZiqxm074OJz1+3Fyw
         DnGu9Hx6JXVNU6g+knTOYEMnPkmVRX9UUZmufHlPWEv5uhAx1e0sw+JxoTfIIDISzW
         8NsVifnJT6/HaaeULL1UsgM1/9zuQSzI/i9MiG91FBPtIy96Aw60rXytYWisqi19Xk
         cem73f2q21p0AhM/s3+4Z5hyDA777sRRsCaAY4LXAeMzh3qmAFppXvYnOnay/K8ehW
         YrNtiWB+XEWMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Edwards <cfsworks@gmail.com>, Sam Edwards <CFSworks@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 28/46] ipv6/addrconf: fix timing bug in tempaddr regen
Date:   Thu, 11 Aug 2022 12:03:52 -0400
Message-Id: <20220811160421.1539956-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811160421.1539956-1-sashal@kernel.org>
References: <20220811160421.1539956-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sam Edwards <cfsworks@gmail.com>

[ Upstream commit 778964f2fdf05e5d2e6ca9bc3f450b3db454ba9c ]

The addrconf_verify_rtnl() function uses a big if/elseif/elseif/... block
to categorize each address by what type of attention it needs.  An
about-to-expire (RFC 4941) temporary address is one such category, but the
previous elseif branch catches addresses that have already run out their
prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
the necessary time window (i.e. REGEN_ADVANCE time units before the end of
the prefered_lft), the temporary address will never be regenerated, and no
temporary addresses will be available until each one's valid_lft runs out
and manage_tempaddrs() begins anew.

Fix this by moving the entire temporary address regeneration case out of
that block.  That block is supposed to implement the "destructive" part of
an address's lifecycle, and regenerating a fresh temporary address is not,
semantically speaking, actually tied to any particular lifecycle stage.
The age test is also changed from `age >= prefered_lft - regen_advance`
to `age + regen_advance >= prefered_lft` instead, to ensure no underflow
occurs if the system administrator increases the regen_advance to a value
greater than the already-set prefered_lft.

Note that this does not fix the problem of addrconf_verify_rtnl() sometimes
not running in time, resulting in the race condition described in RFC 4941
section 3.4 - it only ensures that the address is regenerated.  Fixing THAT
problem may require either using jiffies instead of seconds for all time
arithmetic here, or always rounding up when regen_advance is converted to
seconds.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
Link: https://lore.kernel.org/r/20220623181103.7033-1-CFSworks@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 62 ++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 05317e6f48f8..e11ae0327731 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4513,6 +4513,39 @@ static void addrconf_verify_rtnl(void)
 			/* We try to batch several events at once. */
 			age = (now - ifp->tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
 
+			if ((ifp->flags&IFA_F_TEMPORARY) &&
+			    !(ifp->flags&IFA_F_TENTATIVE) &&
+			    ifp->prefered_lft != INFINITY_LIFE_TIME &&
+			    !ifp->regen_count && ifp->ifpub) {
+				/* This is a non-regenerated temporary addr. */
+
+				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
+					ifp->idev->cnf.dad_transmits *
+					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
+
+				if (age + regen_advance >= ifp->prefered_lft) {
+					struct inet6_ifaddr *ifpub = ifp->ifpub;
+					if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))
+						next = ifp->tstamp + ifp->prefered_lft * HZ;
+
+					ifp->regen_count++;
+					in6_ifa_hold(ifp);
+					in6_ifa_hold(ifpub);
+					spin_unlock(&ifp->lock);
+
+					spin_lock(&ifpub->lock);
+					ifpub->regen_count = 0;
+					spin_unlock(&ifpub->lock);
+					rcu_read_unlock_bh();
+					ipv6_create_tempaddr(ifpub, true);
+					in6_ifa_put(ifpub);
+					in6_ifa_put(ifp);
+					rcu_read_lock_bh();
+					goto restart;
+				} else if (time_before(ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ, next))
+					next = ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ;
+			}
+
 			if (ifp->valid_lft != INFINITY_LIFE_TIME &&
 			    age >= ifp->valid_lft) {
 				spin_unlock(&ifp->lock);
@@ -4544,35 +4577,6 @@ static void addrconf_verify_rtnl(void)
 					in6_ifa_put(ifp);
 					goto restart;
 				}
-			} else if ((ifp->flags&IFA_F_TEMPORARY) &&
-				   !(ifp->flags&IFA_F_TENTATIVE)) {
-				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
-					ifp->idev->cnf.dad_transmits *
-					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
-
-				if (age >= ifp->prefered_lft - regen_advance) {
-					struct inet6_ifaddr *ifpub = ifp->ifpub;
-					if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))
-						next = ifp->tstamp + ifp->prefered_lft * HZ;
-					if (!ifp->regen_count && ifpub) {
-						ifp->regen_count++;
-						in6_ifa_hold(ifp);
-						in6_ifa_hold(ifpub);
-						spin_unlock(&ifp->lock);
-
-						spin_lock(&ifpub->lock);
-						ifpub->regen_count = 0;
-						spin_unlock(&ifpub->lock);
-						rcu_read_unlock_bh();
-						ipv6_create_tempaddr(ifpub, true);
-						in6_ifa_put(ifpub);
-						in6_ifa_put(ifp);
-						rcu_read_lock_bh();
-						goto restart;
-					}
-				} else if (time_before(ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ, next))
-					next = ifp->tstamp + ifp->prefered_lft * HZ - regen_advance * HZ;
-				spin_unlock(&ifp->lock);
 			} else {
 				/* ifp->prefered_lft <= ifp->valid_lft */
 				if (time_before(ifp->tstamp + ifp->prefered_lft * HZ, next))
-- 
2.35.1

