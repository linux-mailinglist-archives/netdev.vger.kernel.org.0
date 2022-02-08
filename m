Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AED4AD104
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347441AbiBHFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347036AbiBHEux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:50:53 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773CC0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:50:52 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id v74so16837670pfc.1
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=63exI1ltBaNIjAmOFS8kkvew9jNC7V48+ebJLxT61ic=;
        b=T/B4rcSzl98VV0E6rPsjrIk9rjOUqudy0g4MJ4VLUMDf0/zI84qDaOzbgGFQD+5HkH
         nMEngmxz4nhFMnia21PSUXDQLv93RySBFnbVPhKEfVZXGvnGVUL6e5wJH5qu8R21HGR7
         FRGIXgmad6+K42Sc+myLRl/I9Eb/6NPxsY4kuG+B5JDB08BHYCyo17uU3YXzVbPOSgSK
         Jlgqm7pcNwpfWhN1qkceYn9e2ZfdAPpTHr3s6IlhR7No/FusGRpRW3onzDd4CdO8MJir
         21PsnzLHSe9ndO41yR40vJh0o9vSYCes00CRa6RH6vCVj0pSQWkOSdmcXLHEHmVcXiQt
         9CGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=63exI1ltBaNIjAmOFS8kkvew9jNC7V48+ebJLxT61ic=;
        b=KYdZCZFnmxV+d5xvKUqkYhCDYnqk9A6TGPwafAQLFxp1vfuehsaf2JX0gEwIaHjrPp
         Cx5mHoJ1yIj/eR6jZRW/f+psUJOjVa+Et2ktxiTUzqU5eH0b4TU3TS1IKxVXefF5OV6n
         VHNZLmPM6f8QCmJxuPDtlk8JrL8u4utbn1vFpCivA2kK/22qgoLqw300dcybuCZlw6rw
         sySoVxMuUbRQnCcdhixlRy//6S8sZ+5Q22I1XpP54jO2iiZgfvBgfCAuYjJi+liI/1Yo
         9TfQqlfoE2QyEuHJp0qP1JgGUnxYWfqd35eNmaqKrTgl6b/aMgs89eRxlBGlPfzHWD+U
         3p3Q==
X-Gm-Message-State: AOAM531Kfc2nnPkfd+4bC0s4PiRo5y4nEpcyrEnQYTY7BKzEe93gYC5L
        KejwvQ777sdcmWhPursr2jc=
X-Google-Smtp-Source: ABdhPJxa4pYl8F3Ybghl7uknMH8ghkUVv4roHDKfMdKFi/hPkVNGME+ueFp0JEIk7NzaMfscKvdMZA==
X-Received: by 2002:a63:5d0c:: with SMTP id r12mr1636731pgb.183.1644295852406;
        Mon, 07 Feb 2022 20:50:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id j23sm9810257pgb.75.2022.02.07.20.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 20:50:52 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 01/11] ipv6/addrconf: allocate a per netns hash table
Date:   Mon,  7 Feb 2022 20:50:28 -0800
Message-Id: <20220208045038.2635826-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
In-Reply-To: <20220208045038.2635826-1-eric.dumazet@gmail.com>
References: <20220208045038.2635826-1-eric.dumazet@gmail.com>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

