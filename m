Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD82A21AB8D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 01:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGIX1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 19:27:51 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60197 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgGIX1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 19:27:50 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2093A8011F;
        Fri, 10 Jul 2020 11:27:40 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1594337260;
        bh=4uO0FQkJ2bMOYbPCP2S5T13rQBHTrhp3SnMQYNhrvdk=;
        h=From:To:Cc:Subject:Date;
        b=xKFOKNrqfHbNw21332QWpopQoe7q4ydV3nkXrvBq+WaoKQF3aN2Y5czIhKPZoxcqD
         RsVgQPKyMeiPAjoMUIDwcYTPymRkRloVA0D74RFR4cnnWs0c2Rn/r54msO9+tH5Ruw
         MOIi5zEXKUzaeGMiylmT6KTklLau6ftzWrPMXA9D+84LHfqqtFO0XUY9R5drjV7bU2
         Qh5SMFLUNrqwrxwMQBnSDzs/yYHSScAak56n2gg3AtrMTKoV/M7JuZ+angY2UTcg2W
         aK3lL9NzroMqXf9DBeP7+Itfumd2hFgAPRgwJdNoXtVIr7cMw/Te20BpFJr+t0sR4m
         7ygaPapI4yZSw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f07a7eb0000>; Fri, 10 Jul 2020 11:27:40 +1200
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 6E29F13EEAA;
        Fri, 10 Jul 2020 11:27:38 +1200 (NZST)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 134B73410D1; Fri, 10 Jul 2020 11:27:39 +1200 (NZST)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH] ipv6: Support more than 32 MIFS
Date:   Fri, 10 Jul 2020 11:27:34 +1200
Message-Id: <20200709232734.12814-1-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ip6mr_mfc_add() declared an array of ttls. If MAXMIFS is
large, this would create a large stack frame. This is fixed, and made
more efficient, by passing mf6cc_ifset to ip6mr_update_thresholds().

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
---

As background to this patch, we have MAXMIFS set to 1025 in our kernel.
This creates other issues apart from what this patch fixes, but this
change does make the IPv4 and IPv6 code look more similar, and reduces
total amount of code. Without the double handling of TTLs, I think it is
also easier to understand. Hence I thought it could still become part of
the main kernel.

 net/ipv6/ip6mr.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 1f4d20e97c07..7123849d201b 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -836,7 +836,7 @@ static void ipmr_expire_process(struct timer_list *t)
=20
 static void ip6mr_update_thresholds(struct mr_table *mrt,
 				    struct mr_mfc *cache,
-				    unsigned char *ttls)
+				    struct if_set *ifset)
 {
 	int vifi;
=20
@@ -845,9 +845,8 @@ static void ip6mr_update_thresholds(struct mr_table *=
mrt,
 	memset(cache->mfc_un.res.ttls, 255, MAXMIFS);
=20
 	for (vifi =3D 0; vifi < mrt->maxvif; vifi++) {
-		if (VIF_EXISTS(mrt, vifi) &&
-		    ttls[vifi] && ttls[vifi] < 255) {
-			cache->mfc_un.res.ttls[vifi] =3D ttls[vifi];
+		if (VIF_EXISTS(mrt, vifi) && IF_ISSET(vifi, ifset)) {
+			cache->mfc_un.res.ttls[vifi] =3D 1;
 			if (cache->mfc_un.res.minvif > vifi)
 				cache->mfc_un.res.minvif =3D vifi;
 			if (cache->mfc_un.res.maxvif <=3D vifi)
@@ -1406,21 +1405,14 @@ void ip6_mr_cleanup(void)
 static int ip6mr_mfc_add(struct net *net, struct mr_table *mrt,
 			 struct mf6cctl *mfc, int mrtsock, int parent)
 {
-	unsigned char ttls[MAXMIFS];
 	struct mfc6_cache *uc, *c;
 	struct mr_mfc *_uc;
 	bool found;
-	int i, err;
+	int err;
=20
 	if (mfc->mf6cc_parent >=3D MAXMIFS)
 		return -ENFILE;
=20
-	memset(ttls, 255, MAXMIFS);
-	for (i =3D 0; i < MAXMIFS; i++) {
-		if (IF_ISSET(i, &mfc->mf6cc_ifset))
-			ttls[i] =3D 1;
-	}
-
 	/* The entries are added/deleted only under RTNL */
 	rcu_read_lock();
 	c =3D ip6mr_cache_find_parent(mrt, &mfc->mf6cc_origin.sin6_addr,
@@ -1429,7 +1421,7 @@ static int ip6mr_mfc_add(struct net *net, struct mr=
_table *mrt,
 	if (c) {
 		write_lock_bh(&mrt_lock);
 		c->_c.mfc_parent =3D mfc->mf6cc_parent;
-		ip6mr_update_thresholds(mrt, &c->_c, ttls);
+		ip6mr_update_thresholds(mrt, &c->_c, &mfc->mf6cc_ifset);
 		if (!mrtsock)
 			c->_c.mfc_flags |=3D MFC_STATIC;
 		write_unlock_bh(&mrt_lock);
@@ -1450,7 +1442,7 @@ static int ip6mr_mfc_add(struct net *net, struct mr=
_table *mrt,
 	c->mf6c_origin =3D mfc->mf6cc_origin.sin6_addr;
 	c->mf6c_mcastgrp =3D mfc->mf6cc_mcastgrp.sin6_addr;
 	c->_c.mfc_parent =3D mfc->mf6cc_parent;
-	ip6mr_update_thresholds(mrt, &c->_c, ttls);
+	ip6mr_update_thresholds(mrt, &c->_c, &mfc->mf6cc_ifset);
 	if (!mrtsock)
 		c->_c.mfc_flags |=3D MFC_STATIC;
=20
--=20
2.27.0

