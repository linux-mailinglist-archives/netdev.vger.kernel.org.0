Return-Path: <netdev+bounces-9223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A950728129
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 560CB2816DA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB04512B8D;
	Thu,  8 Jun 2023 13:21:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A566947B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:21:14 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57E7210C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:21:12 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f6d7abe934so3960075e9.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1686230471; x=1688822471;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KhaoeTZksIn80amAPN23tQL1E6Mg1h/yTJF6X95xsdA=;
        b=z84ZpGUZD+SoR2l0mm/WX8KCJV1wk0b43QiO/RkCyFd50gka6DenhY2SkjvX95BTJ9
         /WyuVZmLaiSm34TCH17AS4AdNWMWEhIgVpnTw3ltoTeI+DHO39BvqbLMuY8EMAKmaaky
         paobvax5r5jrirXch9eXe4rxOg6x1K7d1m7YWmfOyOIKgdIP/+oA0TJwE6jWovzkkdX7
         pVa5BdoLcV3ix17y79ttEusCbrZeIeKth4TcZWw9Ym0SYizKWoSceJjhG2R8KGTBdBV9
         ac6EU6WW0/Vz1BSFZCj07vHK+qp4iiV8epk++pot0fCMcPU1X/gc2fzHlbOJV7vXBnQg
         UD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686230471; x=1688822471;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KhaoeTZksIn80amAPN23tQL1E6Mg1h/yTJF6X95xsdA=;
        b=PDa0x1NRlid9aAU0aRhZ1uK5pLsNV8Wcxgj9FbTLWgAoZ8NghoVhka7uK4vrhVjJ/A
         AwXmrJ+cd2YUv+b/MtfsaPEjYGh4iblDjY9zWrgKhadc/nCvD73ElhqaNKJ7w+BqLsvN
         RzzhZKdJbNJS06WZbT31Lw+aIVI/BP3L//ncAJXdeFBlyR2VZ4VkYHJ9UGoN7/IJw7xK
         uPdo0OEtIWmMWqfvxl2cnz6rC03oElFhbK+nJhfs4g8rRNMejwhPvOaifU20lgc0kpnz
         s5NJdqOuTp3+ZYIHG71o+ctrEvRg8qhF0BI3RQaaeZWUCDnfUGvlZWm0gLxO+M4yRcDa
         lhiA==
X-Gm-Message-State: AC+VfDwvm3gyLF7p/b5z273CmYgy9vKpFHyWtUWlRzHA3gY+Vd13aS15
	PJc50Courwu/skVVciR5N6+0lA==
X-Google-Smtp-Source: ACHHUZ72dlqjioyOZFlnptxRBoQkTm7II3R7lfsutEe7KQL1uH+xB/XrKBPxFMYJ5TYjmxpPVHRPYw==
X-Received: by 2002:a05:600c:2148:b0:3f6:e13:b268 with SMTP id v8-20020a05600c214800b003f60e13b268mr1466363wml.22.1686230471465;
        Thu, 08 Jun 2023 06:21:11 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id 16-20020a05600c021000b003f7f1b3aff1sm5001100wmi.26.2023.06.08.06.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:21:10 -0700 (PDT)
From: Matthieu Baerts <matthieu.baerts@tessares.net>
Date: Thu, 08 Jun 2023 15:20:49 +0200
Subject: [PATCH net-next 1/4] mptcp: export local_address
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-1-b301717c9ff5@tessares.net>
References: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
In-Reply-To: <20230608-upstream-net-next-20230608-mptcp-unify-pm-interfaces-v1-0-b301717c9ff5@tessares.net>
To: mptcp@lists.linux.dev, Mat Martineau <martineau@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Geliang Tang <geliang.tang@suse.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3955;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=l/jGQDI6Wt0DGeE+EQbUTZRRGJNBQ8M0TmciTMimsH0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkgdXF2dATrt1k6R8plFmN8YuqD23J2mPMTIU61
 TUKbXRcPKiJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZIHVxQAKCRD2t4JPQmmg
 czfBEACo7eQ0NVkbvNrezSrhGOLT4aK9BfzKo+4EB8n96i3gUZ2j++5wVPgkILBk5SIjysunUSL
 T/E+lXs0BNDicXhww6kGFQjltK66kKcCNaV5/h8z6dZof62rYRLjSKZOggD8ct3y/3JLSUvahNt
 KGbYtgVqt8q7S9R1MWkBivbFQufl9irsI6KV68uK6evPOl6wlaL4R42p7BcM2OxqFrYI/cB/ib8
 GTH3gp8vtwKdNOlknU+KzOlAkjR7amGO7FSHdki683JNae/ZK/v3vwC6ZCAtlp3WIYtM2No8fFS
 pDpiB3olHMgqzTDOvOkNdJa/DTodXX5wy8kf7jjBePHSqoGWZMniApm0heE/Ise9CREbK8ucaGC
 kQYgIbc7DcavGlIoStQjNP30IxJ7LTAWozqD8Mc5twi5YkEduXO+96F8py4y2dTjgTmPvx3J7Xj
 9VeDjiZlN59VBT8yHDDu8Wjb8zB05lO76hsL6pXCls/4eR88mggOhjY2u8/esfJjzQGqa+dLzis
 WPqRIQyBXql7TlL60VCPfCNjUp6npDVEu4V9IN2ANcD3H+3bNJF8+6VJWtnqhm/tWFNZzEYZofS
 Ecy1kkIXEEMcsvwvSb8acPhZk8rTamJuXuC3Kl0wft/QoWuDOJNa6ToQlbxaq2/Cr7lToV06Li1
 lJNm86sxNBNu+6g==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Geliang Tang <geliang.tang@suse.com>

Rename local_address() with "mptcp_" prefix and export it in protocol.h.

This function will be re-used in the common PM code (pm.c) in the
following commit.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 17 ++++++++---------
 net/mptcp/protocol.h   |  1 +
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index bc343dab5e3f..c55ed3dda0d8 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -86,8 +86,7 @@ bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 	return a->port == b->port;
 }
 
-static void local_address(const struct sock_common *skc,
-			  struct mptcp_addr_info *addr)
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr)
 {
 	addr->family = skc->skc_family;
 	addr->port = htons(skc->skc_num);
@@ -122,7 +121,7 @@ static bool lookup_subflow_by_saddr(const struct list_head *list,
 	list_for_each_entry(subflow, list, node) {
 		skc = (struct sock_common *)mptcp_subflow_tcp_sock(subflow);
 
-		local_address(skc, &cur);
+		mptcp_local_address(skc, &cur);
 		if (mptcp_addresses_equal(&cur, saddr, saddr->port))
 			return true;
 	}
@@ -263,7 +262,7 @@ bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk)
 	struct mptcp_addr_info saddr;
 	bool ret = false;
 
-	local_address((struct sock_common *)sk, &saddr);
+	mptcp_local_address((struct sock_common *)sk, &saddr);
 
 	spin_lock_bh(&msk->pm.lock);
 	list_for_each_entry(entry, &msk->pm.anno_list, list) {
@@ -541,7 +540,7 @@ static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 		struct mptcp_addr_info mpc_addr;
 		bool backup = false;
 
-		local_address((struct sock_common *)msk->first, &mpc_addr);
+		mptcp_local_address((struct sock_common *)msk->first, &mpc_addr);
 		rcu_read_lock();
 		entry = __lookup_addr(pernet, &mpc_addr, false);
 		if (entry) {
@@ -752,7 +751,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		struct mptcp_addr_info local, remote;
 
-		local_address((struct sock_common *)ssk, &local);
+		mptcp_local_address((struct sock_common *)ssk, &local);
 		if (!mptcp_addresses_equal(&local, addr, addr->port))
 			continue;
 
@@ -1070,8 +1069,8 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	/* The 0 ID mapping is defined by the first subflow, copied into the msk
 	 * addr
 	 */
-	local_address((struct sock_common *)msk, &msk_local);
-	local_address((struct sock_common *)skc, &skc_local);
+	mptcp_local_address((struct sock_common *)msk, &msk_local);
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
 	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
 		return 0;
 
@@ -1491,7 +1490,7 @@ static int mptcp_nl_remove_id_zero_address(struct net *net,
 		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
 
-		local_address((struct sock_common *)msk, &msk_local);
+		mptcp_local_address((struct sock_common *)msk, &msk_local);
 		if (!mptcp_addresses_equal(&msk_local, addr, addr->port))
 			goto next;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index c5255258bfb3..6e6cffc04ced 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -638,6 +638,7 @@ void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);
+void mptcp_local_address(const struct sock_common *skc, struct mptcp_addr_info *addr);
 
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,

-- 
2.40.1


