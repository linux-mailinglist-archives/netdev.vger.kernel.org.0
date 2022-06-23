Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2249558855
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiFWTHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 15:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbiFWTHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 15:07:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8FF506CA
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:13:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 128so295402pfv.12
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 11:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9wh05WaRqHmfx5gRya0gL25HMZgWs7rW6ZtE4LbOGY=;
        b=mCJnm77x/UMxGFxjZA+qZvLalBX/EDyba1wAalQESYqhIfC0fqk2EMlJExzho2MGk1
         XpzsW7EndVEAmSzRzXiDm75O3KHmhXDDRInetPlTikD9BRK9svnmEKl3mfqTatxyOg3t
         Z96HIIavR180Djv9FfiP10/kPrJc9V1rLQyRlfmjwVwgUC6i87Vp6Z+9Pss/uE2dmozf
         SQZ/HZKiMtZXiZgM7YBCpy0mk0rGvgNmszmTGLQiOzdA46z4IOvh5uhfuMHwkitf47e6
         cK0a9I+Y/5InLX8+UBAug6E97AXeKdD6U4rjqqYK2A+v+hp9fYvXyBOz6+twzlmE+4Fr
         sMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9wh05WaRqHmfx5gRya0gL25HMZgWs7rW6ZtE4LbOGY=;
        b=qZZI/x4v2iY/wSCt2vQnldiZKWkXtaX+GJ1pYydBNkRPVbowDcVp04aJUgKFG3y5ls
         dFfGDXu9CWSnT7G3F83GvR6Ae2utq8zfV8vdYMHQ0kxft+uGJykSmWNgmSjLtHMxNiJ5
         gHPS4fLcfOIyoSRICMK7mtGx5FREaUIKSmsTlXcg8nsANjgw8J/a+lG9DI5WOmcNMMtx
         Jqn78YB8oftGXPEEyZhp7QdUhAqCtzYUFm0Wi3PViRmAs5n53LZN9pfbwMcqTXm97nuj
         FHF6xeKLxuPy+o9MpKt33fLWlzQLiYkKUD6xtOSoItoHPe6Ld9NLLOOg5q4H6aUgLv+V
         XPlg==
X-Gm-Message-State: AJIora873DkZu8otJTWi8Q3Im9IelTIz++inGWhmoCo/Qi306MKpQMG1
        oGFxWOfj9mF9QjkqvJ7c0X1EZ1lOZ8c=
X-Google-Smtp-Source: AGRyM1tW0+kgWOJq4FZSTkDrp1eJIpD50w86kFeKrAdcF6kqq4RJnlc9CbHDPc8zmEWjy6N5R7M98w==
X-Received: by 2002:a63:9547:0:b0:408:be53:b599 with SMTP id t7-20020a639547000000b00408be53b599mr8495590pgn.463.1656007988242;
        Thu, 23 Jun 2022 11:13:08 -0700 (PDT)
Received: from celestia.. ([2602:3f:9b59:c101:d94d:ed0f:f7a8:9043])
        by smtp.gmail.com with ESMTPSA id iz19-20020a170902ef9300b0016378bfeb90sm87914plb.227.2022.06.23.11.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 11:13:06 -0700 (PDT)
From:   Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH net-next v2 resend] ipv6/addrconf: fix timing bug in tempaddr regen
Date:   Thu, 23 Jun 2022 12:11:04 -0600
Message-Id: <20220623181103.7033-1-CFSworks@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/ipv6/addrconf.c | 62 ++++++++++++++++++++++++---------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..57aa46cb85b7 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4507,6 +4507,39 @@ static void addrconf_verify_rtnl(struct net *net)
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
@@ -4540,35 +4573,6 @@ static void addrconf_verify_rtnl(struct net *net)
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

