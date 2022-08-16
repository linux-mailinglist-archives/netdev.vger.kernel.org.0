Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58565595755
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiHPJ7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiHPJ6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:58:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FD15AA17
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:59:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CEC2B8166B
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9357C433D7;
        Tue, 16 Aug 2022 08:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660640394;
        bh=B5UCFQcwuKhHPA2LdVRMUzZKSJMmuLEGIFALxXTY3ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YscQsqolP/Crd2qNILsVEkJu8NFyB7v8LOliQsjz9NSKe3Z/0itg/1KUNskJWR9pi
         /5zIhvGOJpO5fC00NDISTGBOJuPYXXL+VbPMegSYYoNPAmJGPmzFSQ49/pPsRFJIHC
         H/a5+FS2UxlDL2j8DPOM2ueVxvqK8BQWtuj8kSsnWkrbjsloTywsn0bC71ggjFHGVP
         ILm0Vu4H49yze+yKBCixcRMps7WftM+vydZ0u/F5yRznptDEMJuutQUlKHyTWwAATs
         RhbWlmuV4nwt6N3d3uxSzlhyk3zui4LOK6cx9DgvdQEbZFVBfHVXMPK1cytsIbGipU
         MGAt9KoyGIOow==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next v2 6/6] xfrm: enforce separation between priorities of HW/SW policies
Date:   Tue, 16 Aug 2022 11:59:27 +0300
Message-Id: <191be9b9c0367d4554b208533f5d75f498784889.1660639789.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660639789.git.leonro@nvidia.com>
References: <cover.1660639789.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devices that implement IPsec full offload mode offload policies too.
In RX path, it causes to the situation that HW can't effectively handle
mixed SW and HW priorities unless users make sure that HW offloaded
policies have higher priorities.

In order to make sure that users have coherent picture, let's require
that HW offloaded policies have always (both RX and TX) higher priorities
than SW ones.

To do not over engineer the code, HW policies are treated as SW ones and
don't take into account netdev to allow reuse of same priorities for
different devices.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/netns/xfrm.h |   8 ++-
 net/xfrm/xfrm_policy.c   | 113 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index bd7c3be4af5d..f0cfa0faf611 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -29,6 +29,11 @@ struct xfrm_policy_hthresh {
 	u8			rbits6;
 };
 
+struct xfrm_policy_prio {
+	u32 max_sw_prio;
+	u32 min_hw_prio;
+};
+
 struct netns_xfrm {
 	struct list_head	state_all;
 	/*
@@ -52,7 +57,7 @@ struct netns_xfrm {
 	unsigned int		policy_idx_hmask;
 	struct hlist_head	policy_inexact[XFRM_POLICY_MAX];
 	struct xfrm_policy_hash	policy_bydst[XFRM_POLICY_MAX];
-	unsigned int		policy_count[XFRM_POLICY_MAX * 2];
+	unsigned int		policy_count[XFRM_POLICY_MAX * 3];
 	struct work_struct	policy_hash_work;
 	struct xfrm_policy_hthresh policy_hthresh;
 	struct list_head	inexact_bins;
@@ -67,6 +72,7 @@ struct netns_xfrm {
 	u32			sysctl_acq_expires;
 
 	u8			policy_default[XFRM_POLICY_MAX];
+	struct xfrm_policy_prio	policy_prio[XFRM_POLICY_MAX];
 
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_hdr;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 3049fdcf8411..a8a7d5fe4cd8 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1570,13 +1570,70 @@ static struct xfrm_policy *xfrm_policy_insert_list(struct hlist_head *chain,
 	return delpol;
 }
 
+static int __xfrm_policy_check_hw_priority(struct net *net,
+					   struct xfrm_policy *policy, int dir)
+{
+	int left, right;
+
+	lockdep_assert_held(&net->xfrm.xfrm_policy_lock);
+
+	if (!net->xfrm.policy_count[dir])
+		/* Adding first policy */
+		return 0;
+
+	if (policy->xdo.type != XFRM_DEV_OFFLOAD_FULL) {
+		/* SW priority */
+		if (!net->xfrm.policy_count[2 * XFRM_POLICY_MAX + dir])
+			/* Special case to allow reuse maximum priority
+			 * (U32_MAX) for SW policies, when no HW policy exist.
+			 */
+			return 0;
+
+		left = policy->priority;
+		right = net->xfrm.policy_prio[dir].min_hw_prio;
+	} else {
+		/* HW priority */
+		left = net->xfrm.policy_prio[dir].max_sw_prio;
+		right = policy->priority;
+	}
+	if (left >= right)
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __xfrm_policy_update_hw_priority(struct net *net,
+					     struct xfrm_policy *policy,
+					     int dir)
+{
+	u32 *hw_prio, *sw_prio;
+
+	lockdep_assert_held(&net->xfrm.xfrm_policy_lock);
+
+	if (policy->xdo.type != XFRM_DEV_OFFLOAD_FULL) {
+		sw_prio = &net->xfrm.policy_prio[dir].max_sw_prio;
+		*sw_prio = max(*sw_prio, policy->priority);
+		return;
+	}
+
+	hw_prio = &net->xfrm.policy_prio[dir].min_hw_prio;
+	*hw_prio = min(*hw_prio, policy->priority);
+}
+
 int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 {
 	struct net *net = xp_net(policy);
 	struct xfrm_policy *delpol;
 	struct hlist_head *chain;
+	int ret;
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
+	ret = __xfrm_policy_check_hw_priority(net, policy, dir);
+	if (ret) {
+		spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
+		return ret;
+	}
+
 	chain = policy_hash_bysel(net, &policy->selector, policy->family, dir);
 	if (chain)
 		delpol = xfrm_policy_insert_list(chain, policy, excl);
@@ -1606,6 +1663,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	policy->curlft.use_time = 0;
 	if (!mod_timer(&policy->timer, jiffies + HZ))
 		xfrm_pol_hold(policy);
+	__xfrm_policy_update_hw_priority(net, policy, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	if (delpol)
@@ -2270,6 +2328,8 @@ static void __xfrm_policy_link(struct xfrm_policy *pol, int dir)
 
 	list_add(&pol->walk.all, &net->xfrm.policy_all);
 	net->xfrm.policy_count[dir]++;
+	if (pol->xdo.type == XFRM_DEV_OFFLOAD_FULL)
+		net->xfrm.policy_count[2 * XFRM_POLICY_MAX + dir]++;
 	xfrm_pol_hold(pol);
 }
 
@@ -2289,6 +2349,8 @@ static struct xfrm_policy *__xfrm_policy_unlink(struct xfrm_policy *pol,
 	}
 
 	list_del_init(&pol->walk.all);
+	if (pol->xdo.type == XFRM_DEV_OFFLOAD_FULL)
+		net->xfrm.policy_count[2 * XFRM_POLICY_MAX + dir]--;
 	net->xfrm.policy_count[dir]--;
 
 	return pol;
@@ -2304,12 +2366,58 @@ static void xfrm_sk_policy_unlink(struct xfrm_policy *pol, int dir)
 	__xfrm_policy_unlink(pol, XFRM_POLICY_MAX + dir);
 }
 
+static void __xfrm_policy_delete_prio(struct net *net,
+				      struct xfrm_policy *policy, int dir)
+{
+	struct xfrm_policy *pol;
+	u32 sw_prio = 0;
+
+	lockdep_assert_held(&net->xfrm.xfrm_policy_lock);
+
+	if (!net->xfrm.policy_count[dir]) {
+		net->xfrm.policy_prio[dir].max_sw_prio = sw_prio;
+		net->xfrm.policy_prio[dir].min_hw_prio = U32_MAX;
+		return;
+	}
+
+	if (policy->xdo.type == XFRM_DEV_OFFLOAD_FULL &&
+	    !net->xfrm.policy_count[2 * XFRM_POLICY_MAX + dir]) {
+		net->xfrm.policy_prio[dir].min_hw_prio = U32_MAX;
+		return;
+	}
+
+	list_for_each_entry(pol, &net->xfrm.policy_all, walk.all) {
+		if (pol->walk.dead)
+			continue;
+
+		if (policy->xdo.type != XFRM_DEV_OFFLOAD_FULL) {
+			/* SW priority */
+			if (pol->xdo.type == XFRM_DEV_OFFLOAD_FULL) {
+				net->xfrm.policy_prio[dir].max_sw_prio = sw_prio;
+				return;
+			}
+			sw_prio = pol->priority;
+			continue;
+		}
+		/* HW priority */
+		if (pol->xdo.type != XFRM_DEV_OFFLOAD_FULL)
+			continue;
+
+		net->xfrm.policy_prio[dir].min_hw_prio = pol->priority;
+		return;
+	}
+
+	net->xfrm.policy_prio[dir].max_sw_prio = sw_prio;
+}
+
 int xfrm_policy_delete(struct xfrm_policy *pol, int dir)
 {
 	struct net *net = xp_net(pol);
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
 	pol = __xfrm_policy_unlink(pol, dir);
+	if (pol)
+		__xfrm_policy_delete_prio(net, pol, dir);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 	if (pol) {
 		xfrm_dev_policy_delete(pol);
@@ -4110,6 +4218,7 @@ static int __net_init xfrm_policy_init(struct net *net)
 
 		net->xfrm.policy_count[dir] = 0;
 		net->xfrm.policy_count[XFRM_POLICY_MAX + dir] = 0;
+		net->xfrm.policy_count[2 * XFRM_POLICY_MAX + dir] = 0;
 		INIT_HLIST_HEAD(&net->xfrm.policy_inexact[dir]);
 
 		htab = &net->xfrm.policy_bydst[dir];
@@ -4195,6 +4304,10 @@ static int __net_init xfrm_net_init(struct net *net)
 	net->xfrm.policy_default[XFRM_POLICY_FWD] = XFRM_USERPOLICY_ACCEPT;
 	net->xfrm.policy_default[XFRM_POLICY_OUT] = XFRM_USERPOLICY_ACCEPT;
 
+	net->xfrm.policy_prio[XFRM_POLICY_IN].min_hw_prio = U32_MAX;
+	net->xfrm.policy_prio[XFRM_POLICY_FWD].min_hw_prio = U32_MAX;
+	net->xfrm.policy_prio[XFRM_POLICY_OUT].min_hw_prio = U32_MAX;
+
 	rv = xfrm_statistics_init(net);
 	if (rv < 0)
 		goto out_statistics;
-- 
2.37.2

