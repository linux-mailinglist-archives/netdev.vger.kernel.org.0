Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD5D53697A
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355290AbiE1AuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 20:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbiE1AuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 20:50:07 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F412F5F8FF
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 17:50:05 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id k187so3392679oif.1
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 17:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9wh05WaRqHmfx5gRya0gL25HMZgWs7rW6ZtE4LbOGY=;
        b=Ohbu68OyFHkE3cDcc/psWM9xTfBBg+LexAjoc/xpREnz/LVYiDWefkthiT0VsJWMmA
         fiiC2AO15vrMYt0JdO3OsbCk5mnCxv4D/WzO5DSTfQBOhpC91XrAXFFT4BTZVkceSjZR
         1zuJBCC36nNgaxWhga2Xaly1rkuFY81MubtX5TAubekNDaDMqnLqCr9QW5YqEhZDwIK9
         qQJqawKyVsbP++ylAWsHvjyMO3QU9JBzm1rcce1tEzYgdtrCj8Z3dVnVRCXsZnbuLFVZ
         f+uqTPr1CiKXFkVi/mFxZy4T7EjFbXb4ZGpG2aOqpirG5oo1wSYsN23FKBt81a9tGCZi
         0j/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R9wh05WaRqHmfx5gRya0gL25HMZgWs7rW6ZtE4LbOGY=;
        b=CqSKf7pQXqOmZpOmAlLwTOB/t9l4/AgDbsXVTSzXocwyWbAi4A7D3NWWkId4f5hxeK
         Y+6dJc569aNI/PakECAIeofxbYWMMHtzEJr6aCu1MyvucRBqMo8uG97zX3yV4WmB+76n
         7I1MRSocK4aGqteBPqV61HnPFXJbS0smG25ZhEw4UR0vEJIaLcHDh/99Y7dlTU6aaLta
         kSxFfMyJpWYuxW1iHbio3OMcOc2XegffVxMBS7tzoSo2ZmSzVxbaN76aiIOkwTzLnWWd
         +YW6vGsDUmTdsuDdGHQYHdaEsPpvWaXPv4YvbzYO7AS/6u9OhUMWEWk+klX6TOUlnRKH
         90Tw==
X-Gm-Message-State: AOAM533bj0cW1EPWoZSCwayVTxGseruHw4e+t1fqwlZCcqJTKqnVTg52
        M0j7k0efwPORqXtBdny7gTA=
X-Google-Smtp-Source: ABdhPJzla0AKUa8FuXy8EeIBY9+x3VJ/H//I9GK+fyhz3kO1++lVI+FbGdahpS84Hy6coQoNVNfM4g==
X-Received: by 2002:a05:6808:21a5:b0:32b:2791:2cef with SMTP id be37-20020a05680821a500b0032b27912cefmr5332859oib.147.1653699005283;
        Fri, 27 May 2022 17:50:05 -0700 (PDT)
Received: from celestia.nettie.lan ([2001:470:42c4:101:72ff:344f:b812:f367])
        by smtp.gmail.com with ESMTPSA id j8-20020a544808000000b003289f51c2d7sm2389867oij.34.2022.05.27.17.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 17:50:04 -0700 (PDT)
From:   Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH v2] ipv6/addrconf: fix timing bug in tempaddr regen
Date:   Fri, 27 May 2022 18:48:21 -0600
Message-Id: <20220528004820.5916-1-CFSworks@gmail.com>
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

