Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2086D639599
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiKZLDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiKZLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:12 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47DB19008
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 565E92035C;
        Sat, 26 Nov 2022 12:03:09 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YLNoe5_h4eKm; Sat, 26 Nov 2022 12:03:08 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CB02F20533;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id C636180004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3B7BC3183C53; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 08/10] xfrm: add extack to xfrm_do_migrate
Date:   Sat, 26 Nov 2022 12:03:01 +0100
Message-ID: <20221126110303.1859238-9-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  3 ++-
 net/key/af_key.c       |  2 +-
 net/xfrm/xfrm_policy.c | 28 ++++++++++++++++++++--------
 net/xfrm/xfrm_user.c   | 16 +++++++++++-----
 4 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index dbc81f5eb553..576566bd0be9 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1703,7 +1703,8 @@ struct xfrm_state *xfrm_state_migrate(struct xfrm_state *x,
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_bundles,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap, u32 if_id);
+		 struct xfrm_encap_tmpl *encap, u32 if_id,
+		 struct netlink_ext_ack *extack);
 #endif
 
 int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport);
diff --git a/net/key/af_key.c b/net/key/af_key.c
index c85df5b958d2..7f4ff5fe2257 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2626,7 +2626,7 @@ static int pfkey_migrate(struct sock *sk, struct sk_buff *skb,
 	}
 
 	return xfrm_migrate(&sel, dir, XFRM_POLICY_TYPE_MAIN, m, i,
-			    kma ? &k : NULL, net, NULL, 0);
+			    kma ? &k : NULL, net, NULL, 0, NULL);
 
  out:
 	return err;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index a049f91d4446..9b9e2765363d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4333,7 +4333,8 @@ static int migrate_tmpl_match(const struct xfrm_migrate *m, const struct xfrm_tm
 
 /* update endpoint address(es) of template(s) */
 static int xfrm_policy_migrate(struct xfrm_policy *pol,
-			       struct xfrm_migrate *m, int num_migrate)
+			       struct xfrm_migrate *m, int num_migrate,
+			       struct netlink_ext_ack *extack)
 {
 	struct xfrm_migrate *mp;
 	int i, j, n = 0;
@@ -4341,6 +4342,7 @@ static int xfrm_policy_migrate(struct xfrm_policy *pol,
 	write_lock_bh(&pol->lock);
 	if (unlikely(pol->walk.dead)) {
 		/* target policy has been deleted */
+		NL_SET_ERR_MSG(extack, "Target policy not found");
 		write_unlock_bh(&pol->lock);
 		return -ENOENT;
 	}
@@ -4372,17 +4374,22 @@ static int xfrm_policy_migrate(struct xfrm_policy *pol,
 	return 0;
 }
 
-static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
+static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate,
+			      struct netlink_ext_ack *extack)
 {
 	int i, j;
 
-	if (num_migrate < 1 || num_migrate > XFRM_MAX_DEPTH)
+	if (num_migrate < 1 || num_migrate > XFRM_MAX_DEPTH) {
+		NL_SET_ERR_MSG(extack, "Invalid number of SAs to migrate, must be 0 < num <= XFRM_MAX_DEPTH (6)");
 		return -EINVAL;
+	}
 
 	for (i = 0; i < num_migrate; i++) {
 		if (xfrm_addr_any(&m[i].new_daddr, m[i].new_family) ||
-		    xfrm_addr_any(&m[i].new_saddr, m[i].new_family))
+		    xfrm_addr_any(&m[i].new_saddr, m[i].new_family)) {
+			NL_SET_ERR_MSG(extack, "Addresses in the MIGRATE attribute's list cannot be null");
 			return -EINVAL;
+		}
 
 		/* check if there is any duplicated entry */
 		for (j = i + 1; j < num_migrate; j++) {
@@ -4393,8 +4400,10 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 			    m[i].proto == m[j].proto &&
 			    m[i].mode == m[j].mode &&
 			    m[i].reqid == m[j].reqid &&
-			    m[i].old_family == m[j].old_family)
+			    m[i].old_family == m[j].old_family) {
+				NL_SET_ERR_MSG(extack, "Entries in the MIGRATE attribute's list must be unique");
 				return -EINVAL;
+			}
 		}
 	}
 
@@ -4404,7 +4413,8 @@ static int xfrm_migrate_check(const struct xfrm_migrate *m, int num_migrate)
 int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 		 struct xfrm_migrate *m, int num_migrate,
 		 struct xfrm_kmaddress *k, struct net *net,
-		 struct xfrm_encap_tmpl *encap, u32 if_id)
+		 struct xfrm_encap_tmpl *encap, u32 if_id,
+		 struct netlink_ext_ack *extack)
 {
 	int i, err, nx_cur = 0, nx_new = 0;
 	struct xfrm_policy *pol = NULL;
@@ -4414,11 +4424,12 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	struct xfrm_migrate *mp;
 
 	/* Stage 0 - sanity checks */
-	err = xfrm_migrate_check(m, num_migrate);
+	err = xfrm_migrate_check(m, num_migrate, extack);
 	if (err < 0)
 		goto out;
 
 	if (dir >= XFRM_POLICY_MAX) {
+		NL_SET_ERR_MSG(extack, "Invalid policy direction");
 		err = -EINVAL;
 		goto out;
 	}
@@ -4426,6 +4437,7 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	/* Stage 1 - find policy */
 	pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id);
 	if (!pol) {
+		NL_SET_ERR_MSG(extack, "Target policy not found");
 		err = -ENOENT;
 		goto out;
 	}
@@ -4447,7 +4459,7 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 3 - update policy */
-	err = xfrm_policy_migrate(pol, m, num_migrate);
+	err = xfrm_policy_migrate(pol, m, num_migrate, extack);
 	if (err < 0)
 		goto restore_state;
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 13607df4f30d..c5d6a92d73cb 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2687,7 +2687,8 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 #ifdef CONFIG_XFRM_MIGRATE
 static int copy_from_user_migrate(struct xfrm_migrate *ma,
 				  struct xfrm_kmaddress *k,
-				  struct nlattr **attrs, int *num)
+				  struct nlattr **attrs, int *num,
+				  struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_MIGRATE];
 	struct xfrm_user_migrate *um;
@@ -2706,8 +2707,10 @@ static int copy_from_user_migrate(struct xfrm_migrate *ma,
 	um = nla_data(rt);
 	num_migrate = nla_len(rt) / sizeof(*um);
 
-	if (num_migrate <= 0 || num_migrate > XFRM_MAX_DEPTH)
+	if (num_migrate <= 0 || num_migrate > XFRM_MAX_DEPTH) {
+		NL_SET_ERR_MSG(extack, "Invalid number of SAs to migrate, must be 0 < num <= XFRM_MAX_DEPTH (6)");
 		return -EINVAL;
+	}
 
 	for (i = 0; i < num_migrate; i++, um++, ma++) {
 		memcpy(&ma->old_daddr, &um->old_daddr, sizeof(ma->old_daddr));
@@ -2740,8 +2743,10 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_encap_tmpl  *encap = NULL;
 	u32 if_id = 0;
 
-	if (!attrs[XFRMA_MIGRATE])
+	if (!attrs[XFRMA_MIGRATE]) {
+		NL_SET_ERR_MSG(extack, "Missing required MIGRATE attribute");
 		return -EINVAL;
+	}
 
 	kmp = attrs[XFRMA_KMADDRESS] ? &km : NULL;
 
@@ -2749,7 +2754,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = copy_from_user_migrate(m, kmp, attrs, &n);
+	err = copy_from_user_migrate(m, kmp, attrs, &n, extack);
 	if (err)
 		return err;
 
@@ -2766,7 +2771,8 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
-	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap, if_id);
+	err = xfrm_migrate(&pi->sel, pi->dir, type, m, n, kmp, net, encap,
+			   if_id, extack);
 
 	kfree(encap);
 
-- 
2.25.1

