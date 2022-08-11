Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476A3590185
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbiHKP5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiHKP4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:56:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084DFA3458;
        Thu, 11 Aug 2022 08:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25983616FC;
        Thu, 11 Aug 2022 15:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FCC433D7;
        Thu, 11 Aug 2022 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232832;
        bh=TRK0SsbIr+CcxNg4PjQwwhHSoMWYlCPSyyU57xOdhxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogiZmUqRU8Sh3g0KWaqdQcNZNUIhQiqwLoVIdgPzpXtqSkLiizH4GJPkBOPFhJI1B
         Fh1dwPOZoVGuzfQswV7dE7A0B69oditi6QS5fx8piBMuXDXPQsbDr3kN1EIewEMXIB
         qE7wTh0JZoDJWsnIkRlOR/bwQThEawV2HIcZBfBxX/rU5KEFQ59H3MSM3i2Y53lpKE
         Mg2mxVYfTtsL1H3Eh7jr0ip4NBtB63+O/0EQMxOWqbRpQ9/KfFtxY0RWDQFSj5SodH
         G+bwb/jvF6Jhu27zOxIQcFQAmGkVP1poi0WzJRK5SbbDPRLCh5EwK6jQNJC3L66xeF
         CQVbxgQ9zB8qA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Edwards <cfsworks@gmail.com>, Sam Edwards <CFSworks@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 46/93] ipv6/addrconf: fix timing bug in tempaddr regen
Date:   Thu, 11 Aug 2022 11:41:40 -0400
Message-Id: <20220811154237.1531313-46-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
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
index 3b47c901c832..01e3900dd2f8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4522,6 +4522,39 @@ static void addrconf_verify_rtnl(struct net *net)
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
@@ -4555,35 +4588,6 @@ static void addrconf_verify_rtnl(struct net *net)
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

