Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897F24AC720
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiBGRSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384217AbiBGRSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:18:06 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1328C0401D8
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 09:18:05 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id t9so9431266plg.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 09:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HNqXLXBMJ9ztAmENVyIS8rmIuvKj/5kdUcrzzGJZUmc=;
        b=KmK9Fcz8I9dVkP8GTEKDmc8kiy4OmvJIqlobX6Qf3X0b6fBAiX2SPcfY4EXLJ8pXbS
         NoZmWHGhGdrw9/dFvdaGT/3GHdwbQpegCSqsG+aJxBqHlkImF9Rs3Umobv4M5CcL5qF4
         vQxNu9Usfv3PmyrSRleTVQd7Y2hgKte+To2s1ZQRt++1QOrg/d+hHfFd4jRkpCcUVCrj
         G3IyQkQY6ZZC9jURTZlh1K8LcKj9ubRtkb9ZewKAxD03W5VQdVZxL234u7Rr3IFFumqx
         PZMHMlPifep2l5vASuWtt7DVMx/FE2bcrLQHYZrY581kKP60PEfJ1CUf1cbKWrHQnIbQ
         SYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HNqXLXBMJ9ztAmENVyIS8rmIuvKj/5kdUcrzzGJZUmc=;
        b=S161S2mFuixAvrYt4IiS1LFPQkC0db2/8QR1pChua05xUiRgi408joCF16mkZyfbn0
         sRGX8BfAKUBb5c7lnPaZSAxweAAMpJkDTyiLzu78qTwnUFwaI9Ww+4mYRhe18lp67MYw
         4GzJACLiqjP5tdiRRvq3N+no+AOJ2XD5XaI++p6Y7TDzXuSXS5JmH36Sj17Jw2LFy3mO
         xmvqVfpSkaqMz+uO5A2RnP1N8neWd4s+o7MqknxnLeTiYXSbXeb4KH7TuWE9xrcmkPtc
         o/ZI/3n8tJghKmcHcXYh0oQpUNyWqlaUMu/meFA5iUiHGY7zJnqwXPuEknYSTSnV+rjh
         qPOA==
X-Gm-Message-State: AOAM532sDYcKN6PNn52aSTjjPMi9RvqN48viWkrvOnOMEiYsiF/+eyqR
        bg6hk5W7HNVxQboLMDOg9n9DQJcwoxc=
X-Google-Smtp-Source: ABdhPJwTq8Snle6/CRwoeP3LibSqyQ7VUTgQOjPxAQzhWwg/vL7sC5FHMzoCCjSfnEYwpf4u/eNYKg==
X-Received: by 2002:a17:903:1209:: with SMTP id l9mr705851plh.3.1644254285518;
        Mon, 07 Feb 2022 09:18:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id lr8sm24415156pjb.11.2022.02.07.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 09:18:05 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 01/11] ipv6/addrconf: allocate a per netns hash table
Date:   Mon,  7 Feb 2022 09:17:46 -0800
Message-Id: <20220207171756.1304544-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220207171756.1304544-1-eric.dumazet@gmail.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Add a per netns hash table and a dedicated spinlock,
first step to get rid of the global inet6_addr_lst[] one.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv6.h |  4 ++++
 net/ipv6/addrconf.c      | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 30cdfc4e1615424b1c691b53499a1987d7fd0496..755f12001c8b2a73ad1895e73c7aebcba67c6728 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -92,6 +92,10 @@ struct netns_ipv6 {
 	struct sock             *tcp_sk;
 	struct sock             *igmp_sk;
 	struct sock		*mc_autojoin_sk;
+
+	struct hlist_head	*inet6_addr_lst;
+	spinlock_t		addrconf_hash_lock;
+
 #ifdef CONFIG_IPV6_MROUTE
 #ifndef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
 	struct mr_table		*mrt6;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index ef23e7dc538ad983a28853865dd4281f7f0ea8de..cda9e59cab4343507f670e7f59e2b72fd3cded0f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7111,6 +7111,13 @@ static int __net_init addrconf_init_net(struct net *net)
 	int err = -ENOMEM;
 	struct ipv6_devconf *all, *dflt;
 
+	spin_lock_init(&net->ipv6.addrconf_hash_lock);
+	net->ipv6.inet6_addr_lst = kcalloc(IN6_ADDR_HSIZE,
+					   sizeof(struct hlist_head),
+					   GFP_KERNEL);
+	if (!net->ipv6.inet6_addr_lst)
+		goto err_alloc_addr;
+
 	all = kmemdup(&ipv6_devconf, sizeof(ipv6_devconf), GFP_KERNEL);
 	if (!all)
 		goto err_alloc_all;
@@ -7172,11 +7179,15 @@ static int __net_init addrconf_init_net(struct net *net)
 err_alloc_dflt:
 	kfree(all);
 err_alloc_all:
+	kfree(net->ipv6.inet6_addr_lst);
+err_alloc_addr:
 	return err;
 }
 
 static void __net_exit addrconf_exit_net(struct net *net)
 {
+	int i;
+
 #ifdef CONFIG_SYSCTL
 	__addrconf_sysctl_unregister(net, net->ipv6.devconf_dflt,
 				     NETCONFA_IFINDEX_DEFAULT);
@@ -7187,6 +7198,15 @@ static void __net_exit addrconf_exit_net(struct net *net)
 	net->ipv6.devconf_dflt = NULL;
 	kfree(net->ipv6.devconf_all);
 	net->ipv6.devconf_all = NULL;
+
+	/*
+	 *	Check hash table, then free it.
+	 */
+	for (i = 0; i < IN6_ADDR_HSIZE; i++)
+		WARN_ON_ONCE(!hlist_empty(&net->ipv6.inet6_addr_lst[i]));
+
+	kfree(net->ipv6.inet6_addr_lst);
+	net->ipv6.inet6_addr_lst = NULL;
 }
 
 static struct pernet_operations addrconf_ops = {
-- 
2.35.0.263.gb82422642f-goog

