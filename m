Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67696637BA1
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiKXOoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKXOon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:43 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C487EC0AE
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:42 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id 74671C0019;
        Thu, 24 Nov 2022 14:44:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 1/7] xfrm: a few coding style clean ups
Date:   Thu, 24 Nov 2022 15:43:38 +0100
Message-Id: <d2dcc4f0e0989e8b91e871ae991f4141af0ed531.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/xfrm/xfrm_policy.c | 9 ++++++---
 net/xfrm/xfrm_user.c   | 6 +++---
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index d80519c4e389..a049f91d4446 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4414,7 +4414,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	struct xfrm_migrate *mp;
 
 	/* Stage 0 - sanity checks */
-	if ((err = xfrm_migrate_check(m, num_migrate)) < 0)
+	err = xfrm_migrate_check(m, num_migrate);
+	if (err < 0)
 		goto out;
 
 	if (dir >= XFRM_POLICY_MAX) {
@@ -4423,7 +4424,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 1 - find policy */
-	if ((pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id)) == NULL) {
+	pol = xfrm_migrate_policy_find(sel, dir, type, net, if_id);
+	if (!pol) {
 		err = -ENOENT;
 		goto out;
 	}
@@ -4445,7 +4447,8 @@ int xfrm_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	}
 
 	/* Stage 3 - update policy */
-	if ((err = xfrm_policy_migrate(pol, m, num_migrate)) < 0)
+	err = xfrm_policy_migrate(pol, m, num_migrate);
+	if (err < 0)
 		goto restore_state;
 
 	/* Stage 4 - delete old state(s) */
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e73f9efc54c1..25de6e8faf8d 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1538,7 +1538,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 				  &p->info.saddr, 1,
 				  family);
 	err = -ENOENT;
-	if (x == NULL)
+	if (!x)
 		goto out_noput;
 
 	err = xfrm_alloc_spi(x, p->min, p->max);
@@ -2718,7 +2718,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_encap_tmpl  *encap = NULL;
 	u32 if_id = 0;
 
-	if (attrs[XFRMA_MIGRATE] == NULL)
+	if (!attrs[XFRMA_MIGRATE])
 		return -EINVAL;
 
 	kmp = attrs[XFRMA_KMADDRESS] ? &km : NULL;
@@ -2727,7 +2727,7 @@ static int xfrm_do_migrate(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
-	err = copy_from_user_migrate((struct xfrm_migrate *)m, kmp, attrs, &n);
+	err = copy_from_user_migrate(m, kmp, attrs, &n);
 	if (err)
 		return err;
 
-- 
2.38.0

