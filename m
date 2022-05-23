Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72265316F1
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiEWU0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiEWU0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:26:45 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD53527FD5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:26:43 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-e5e433d66dso19875450fac.5
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 13:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Kt/8YJitmDk6YBuDtBcLJKiJJas6OLt15vc5dWS92g=;
        b=h444qM3jeeBbpSXp+IkBiX69tRlZw+bD4fFlf/n5SCQArcfqdEQJMX9ij7216h+r5l
         TWWPO6hqCQESI2UASdck9QXjCBRbOJBJxJM7ocWUfKsDhDjZQGXKinjn722iQFAVPECp
         pOwQz0MG1gHiau5ooQ+yU1uAuFGNbwY313RucEmJVcIMLRSx9Af/DW56rmKoFTnbkmuO
         xYy9kmOMjTi8ZaZ59FzrJSBPhgG9YE5qksz5FYWrKsF8oakmgazfv+A/0EBpoxoeSMNo
         rzsBvb3NC7NPkEDQZgOrmBxRsZg/t7veUcRen0+hvAFClSOjiORJUZ9yG1IeG3M45+DZ
         Jo2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0Kt/8YJitmDk6YBuDtBcLJKiJJas6OLt15vc5dWS92g=;
        b=tOL80D64uDbzQAZ3/iHHCcVuPNc6uN5AbSTXWu+EX9b4kByAs9iGA9reGAqWaNajda
         wjLKsLh/mYrUlCzmEhdFyr5DdA5mzCuPsDTR3GA8CrSgRbOEp22UQtrefiCEnjVjNj9H
         xq476tKJCqz3ooTA8Tg2LRVpYaCKVlCC89vATBiatJTLwA9MaOXjl3TO67PJG7skQ468
         o06iXAgg8K8gpwP0G4vL4rL5ffa7AqP8kQcYMdI5jaLtfCgrgBs9loeJ5bTr8w8VVbur
         okp9dhc1MX8OBFbPseH05qAzLnrbovgIuWQbys1N/Gwy3YtR2h00wd3Z3+/94oWQ+HDd
         j6PQ==
X-Gm-Message-State: AOAM531Kky+it7S0FJIcrckS4Ig2UgcfUlhmE2+BWgRmlVCaTMvey2TC
        FuRyxgZSWbTr1XB+O1cZZOw=
X-Google-Smtp-Source: ABdhPJwcVkHcAYIw1EGheCTvt1svvuf+xUpRsNDQzXwTz8bvuwaDGCe7Ivg10D/1GhVIdjiGi41nNA==
X-Received: by 2002:a05:6871:29a:b0:f1:b960:bdfb with SMTP id i26-20020a056871029a00b000f1b960bdfbmr490145oae.262.1653337602777;
        Mon, 23 May 2022 13:26:42 -0700 (PDT)
Received: from celestia.nettie.lan ([2001:470:42c4:101:179e:9065:1c55:ba5e])
        by smtp.gmail.com with ESMTPSA id 61-20020a9d0c43000000b0060603221245sm4353733otr.21.2022.05.23.13.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 13:26:42 -0700 (PDT)
From:   Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH] ipv6/addrconf: fix timing bug in tempaddr regen
Date:   Mon, 23 May 2022 14:25:43 -0600
Message-Id: <20220523202543.9019-1-CFSworks@gmail.com>
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
previous elseif case catches addresses that have already run out their
prefered_lft.  This means that if addrconf_verify_rtnl() fails to run in
the necessary time window (i.e. REGEN_ADVANCE time units before the end of
the prefered_lft), the temporary address will never be regenerated, and no
temporary addresses will be available until each one's valid_lft runs out
and manage_tempaddrs() begins anew.

Fix this by moving the entire temporary address regeneration case higher
up so that a temporary address cannot be deprecated until it has had an
opportunity to begin regeneration.  Note that this does not fix the
problem of addrconf_verify_rtnl() sometimes not running in time resulting
in the race condition described in RFC 4941 section 3.4 - it only ensures
that the address is regenerated.

Fixing the latter problem may require either using jiffies instead of
seconds for all time arithmetic here, or always rounding up when
regen_advance is converted to seconds.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 net/ipv6/addrconf.c | 58 ++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..5d02e4f0298b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4518,6 +4518,35 @@ static void addrconf_verify_rtnl(struct net *net)
 			} else if (ifp->prefered_lft == INFINITY_LIFE_TIME) {
 				spin_unlock(&ifp->lock);
 				continue;
+			} else if ((ifp->flags&IFA_F_TEMPORARY) &&
+				   !(ifp->flags&IFA_F_TENTATIVE) &&
+				   !ifp->regen_count && ifp->ifpub) {
+				unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
+					ifp->idev->cnf.dad_transmits *
+					max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;
+
+				if (age >= ifp->prefered_lft - regen_advance) {
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
+				spin_unlock(&ifp->lock);
 			} else if (age >= ifp->prefered_lft) {
 				/* jiffies - ifp->tstamp > age >= ifp->prefered_lft */
 				int deprecate = 0;
@@ -4540,35 +4569,6 @@ static void addrconf_verify_rtnl(struct net *net)
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

