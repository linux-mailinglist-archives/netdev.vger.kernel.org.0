Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28A767B039
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbjAYKs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235742AbjAYKsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:48:41 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB4048A12
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:09 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m15so13409378wms.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1z1B/1JOxMW/1pI2Wr97ucv1iX3/JwBnig2uQUdIcTc=;
        b=5AlvuidXbJf9QcpdTpFTQ3XIvsxA6QM3J2QVvXeO2oPBk4JwRg48JkQA1aGwinnijW
         bnjnVjpYS1LMR/uISaOqqytr6izXowhbrkqZCQCXp7Td41nS1jyuIbavzAid3YdzBYYn
         R/ISuQg+LWzuTxdOvc1NLagXN2peIqRwXRV6Zufh8OcEuKVJK29wwgT9LloXkATkbl5f
         qpQ6DmcADoRfvt2XlUU3atKvuwhCViq6xzWpFL4opA9jsrUAAfh/v+5K9k2BUCqv5nOg
         +lJEeg7H4wBxy7dRbUpmtn89dE/98UQNZ53DvF58Df2Wq3MSc1is9iyfvg3+EvYu32fM
         Xg9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1z1B/1JOxMW/1pI2Wr97ucv1iX3/JwBnig2uQUdIcTc=;
        b=nBuD505WgOQN3f113iyflDVDI/0ljezHxAQERfy/V+sxrAMq3Xu53mxNetNF40htZE
         Nrmygg/aif5VRlfECUm+HodpuM/jzutp6qK4741gCjEVQwEtUM6txtCK79CY98ac0axH
         ixOeyF3AOiYKD5hQUguiJLVZO5rZi56H6oGR7VtlzdvTy7WyTmoV+u3E7DRLPpyJJWkp
         dD0WgJykZlReQn/8UyXNiRrig2VBPsqWo7wJE5sl90RO1oDbR0+0uUcLVBIKehJynTdg
         VX4CP9TpaY1PxGDkOiSPLyaeDV29oNr1F2sg8p+oZXkX7WGObkIVqDQrVEErDsblKV3a
         V52A==
X-Gm-Message-State: AFqh2kohK0kR20LTq2quZSDTvpRw3D98YpKgiXoeHTlW6XXNEt+j2Hk4
        rlGgURoOnSGTAnX37K3L0DhA8Q==
X-Google-Smtp-Source: AMrXdXuqjbPK/+LEXjfmBwGtWXg1dSi14zWHaxjHnmbQSe6swgeyMJidojtv4zBnigQIFxETLsw7jw==
X-Received: by 2002:a05:600c:3d16:b0:3d0:6a57:66a5 with SMTP id bh22-20020a05600c3d1600b003d06a5766a5mr31466298wmb.0.1674643680203;
        Wed, 25 Jan 2023 02:48:00 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:47:59 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 25 Jan 2023 11:47:21 +0100
Subject: [PATCH net-next 1/8] mptcp: let the in-kernel PM use mixed IPv4
 and IPv6 addresses
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-1-43fac502bfbf@tessares.net>
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6003;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=phB3Quqjf5qDr2/ijmhFJn3RK2f2//PZBhh2fNKOcGY=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0QjdhQO4IK1wDoBVMgenu8k8FVw5u/Xdg9QAlMfS
 i7JjdoiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc9iJD/
 99TD5UCm4XypLquMD/xCMex5l7ycoRiuRYtSMXW/9P5dhgVPcmvcqiJENb4EyOqIYvargib+B7Q5r4
 eClS38P7Q4w3JA6K+pT6ofjUX9fN0CU4B3R4ql4LRKrA9Bj0fOFNsHJal+Z+7FefXQjbYfUqwMnCHe
 tdLJ8ji6y0FLQBwjTesMEPxLDH+mwWAPtQvLes+bTaGjpUALKOpQLEs4aCrMKBH2fGY1MtOXrdWqWz
 L5ESpeMTAKEOcZUGWrgEfj/HBbCJXEtwp878jXzs6oG91hQhkAEK6DhQeUcsh4R7UHYM03zXT26jwq
 wSaxUd6VPKT7HLjTmShqy+gFkLU+CcRjbAB69QvrqgQuO3BpJIzZMyiR5Vrm8MnWr4alh2o+8EEEwY
 AOGY3OVN0lBUKciSC3ve2XjjsbREHJJUA30YNOhXF8sd0dQhvLUmzqoj1HN309hm/SI1VRVXDv4ZTY
 QH4guWqs6VuSsizRQCtYTKlNzhEhpssa1fnBGIo8Kxd1f+6pDTwGObhkjDE7Euhs9GGuDTErtptLAu
 JZXwnss96Wrprd3nrYn8/GDfoDZutI0Hruyt1J5Qv6yGaktw9Xqjeb9QVoZj/voR45RFcGs3ghO+QH
 RoyBIZpi/hnLYM4bsi0OgrciAzJ296raz7A9WsO+t1MnDJUhkiO1mqWlgxMQ==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Currently the in-kernel PM arbitrary enforces that created subflow's
family must match the main MPTCP socket while the RFC allows mixing
IPv4 and IPv6 subflows.

This patch changes the in-kernel PM logic to create subflows matching
the currently selected source (or destination) address. IPv4 sockets
can pick only IPv4 addresses (and v4 mapped in v6), while IPv6 sockets
not restricted to V6ONLY can pick either IPv4 and IPv6 addresses as
long as the source and destination matches.

A helper, previously introduced is used to ease family matching checks,
taking care of IPv4 vs IPv4-mapped-IPv6 vs IPv6 only addresses.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/269
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 58 +++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b5505b8167f9..db07cc5b4fcb 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -152,7 +152,6 @@ static struct mptcp_pm_addr_entry *
 select_local_address(const struct pm_nl_pernet *pernet,
 		     const struct mptcp_sock *msk)
 {
-	const struct sock *sk = (const struct sock *)msk;
 	struct mptcp_pm_addr_entry *entry, *ret = NULL;
 
 	msk_owned_by_me(msk);
@@ -165,16 +164,6 @@ select_local_address(const struct pm_nl_pernet *pernet,
 		if (!test_bit(entry->addr.id, msk->pm.id_avail_bitmap))
 			continue;
 
-		if (entry->addr.family != sk->sk_family) {
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-			if ((entry->addr.family == AF_INET &&
-			     !ipv6_addr_v4mapped(&sk->sk_v6_daddr)) ||
-			    (sk->sk_family == AF_INET &&
-			     !ipv6_addr_v4mapped(&entry->addr.addr6)))
-#endif
-				continue;
-		}
-
 		ret = entry;
 		break;
 	}
@@ -423,7 +412,9 @@ static bool lookup_address_in_vec(const struct mptcp_addr_info *addrs, unsigned
 /* Fill all the remote addresses into the array addrs[],
  * and return the array size.
  */
-static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullmesh,
+static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk,
+					      struct mptcp_addr_info *local,
+					      bool fullmesh,
 					      struct mptcp_addr_info *addrs)
 {
 	bool deny_id0 = READ_ONCE(msk->pm.remote_deny_join_id0);
@@ -443,6 +434,9 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 		if (deny_id0)
 			return 0;
 
+		if (!mptcp_pm_addr_families_match(sk, local, &remote))
+			return 0;
+
 		msk->pm.subflows++;
 		addrs[i++] = remote;
 	} else {
@@ -453,6 +447,9 @@ static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullm
 			if (deny_id0 && !addrs[i].id)
 				continue;
 
+			if (!mptcp_pm_addr_families_match(sk, local, &addrs[i]))
+				continue;
+
 			if (!lookup_address_in_vec(addrs, i, &addrs[i]) &&
 			    msk->pm.subflows < subflows_max) {
 				msk->pm.subflows++;
@@ -603,9 +600,11 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
 
 		msk->pm.local_addr_used++;
-		nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
-		if (nr)
-			__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
+		__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
+		nr = fill_remote_addresses_vec(msk, &local->addr, fullmesh, addrs);
+		if (nr == 0)
+			continue;
+
 		spin_unlock_bh(&msk->pm.lock);
 		for (i = 0; i < nr; i++)
 			__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
@@ -628,11 +627,11 @@ static void mptcp_pm_nl_subflow_established(struct mptcp_sock *msk)
  * and return the array size.
  */
 static unsigned int fill_local_addresses_vec(struct mptcp_sock *msk,
+					     struct mptcp_addr_info *remote,
 					     struct mptcp_addr_info *addrs)
 {
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *entry;
-	struct mptcp_addr_info local;
 	struct pm_nl_pernet *pernet;
 	unsigned int subflows_max;
 	int i = 0;
@@ -645,15 +644,8 @@ static unsigned int fill_local_addresses_vec(struct mptcp_sock *msk,
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
 			continue;
 
-		if (entry->addr.family != sk->sk_family) {
-#if IS_ENABLED(CONFIG_MPTCP_IPV6)
-			if ((entry->addr.family == AF_INET &&
-			     !ipv6_addr_v4mapped(&sk->sk_v6_daddr)) ||
-			    (sk->sk_family == AF_INET &&
-			     !ipv6_addr_v4mapped(&entry->addr.addr6)))
-#endif
-				continue;
-		}
+		if (!mptcp_pm_addr_families_match(sk, &entry->addr, remote))
+			continue;
 
 		if (msk->pm.subflows < subflows_max) {
 			msk->pm.subflows++;
@@ -666,8 +658,18 @@ static unsigned int fill_local_addresses_vec(struct mptcp_sock *msk,
 	 * 'IPADDRANY' local address
 	 */
 	if (!i) {
+		struct mptcp_addr_info local;
+
 		memset(&local, 0, sizeof(local));
-		local.family = msk->pm.remote.family;
+		local.family =
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+			       remote->family == AF_INET6 &&
+			       ipv6_addr_v4mapped(&remote->addr6) ? AF_INET :
+#endif
+			       remote->family;
+
+		if (!mptcp_pm_addr_families_match(sk, &local, remote))
+			return 0;
 
 		msk->pm.subflows++;
 		addrs[i++] = local;
@@ -706,7 +708,9 @@ static void mptcp_pm_nl_add_addr_received(struct mptcp_sock *msk)
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
 	 */
-	nr = fill_local_addresses_vec(msk, addrs);
+	nr = fill_local_addresses_vec(msk, &remote, addrs);
+	if (nr == 0)
+		return;
 
 	msk->pm.add_addr_accepted++;
 	if (msk->pm.add_addr_accepted >= add_addr_accept_max ||

-- 
2.38.1

