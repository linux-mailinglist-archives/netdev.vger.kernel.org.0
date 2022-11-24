Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86360637BA5
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKXOow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiKXOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:47 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0800EEC78F
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:45 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 07D5FC0021;
        Thu, 24 Nov 2022 14:44:43 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 5/7] xfrm: add extack to xfrm_do_migrate
Date:   Thu, 24 Nov 2022 15:43:42 +0100
Message-Id: <ee0d4beaf34269dbfea274f1dfa093f79a27228a.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.38.0

