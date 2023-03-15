Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8576BB82B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbjCOPmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjCOPmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:42:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A991B26C21
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z4-20020a25bb04000000b00b392ae70300so12617748ybg.21
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/xDdz+0f0G/ivmTmawwc9Slr7Ia7Vq27bOWw6FDM1hA=;
        b=q8EKH66utjDZzWeHa1rH174y5dJb6TXeM+YldCQ46m/i9V20pXeSNpsqFS7GP9f33C
         PTBMCDAFoPAYs8gwcircFjXk3GJN/1+KlvMkdUICjKu/0x8faDbtSBUwmdq+H8Xfrd8+
         9uJpT/H/hoAPAqn/YZRCoK5RK6UAu9UEfX3Y5zL0DkilT84Vg81Kx3nMsFec3yudHUOz
         utiKQgHNrFYjcAJ/8frnXrFxilgJkJ8bidmnd03ow0yTrWS4HYGCosaw0DXoaVajh9O3
         rro6M8uEnXEWwRRAItWr0AtNM1ZCYI2f7vgSgDZFiAk1viJB4ZJJcmewg9rUPAqYFIoc
         +dyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894970;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/xDdz+0f0G/ivmTmawwc9Slr7Ia7Vq27bOWw6FDM1hA=;
        b=ZSEOJOSA7bIz/mGNOFm/hdEdBKhbgGDPJCRNX8xZCmJqqtiVl9vPx+CWLnhrg0uF/D
         GkeeHWQtmwZxYwoRuM3419V6izXnkE/nDQbKKuEObYpfANdMkzUgNpCIRf9ROwejOYZ9
         NqRkXtpEEgFrvvEIxalNjJmlfj73cMExTE8gHiVhhiCw+fN3Q+MW7bqjWtH8RxQB2MNB
         EjKpKSBTc1GfYgk9hiDJBhrdfxYQZPoDcYTWeL9hmVEVwgDZUZgon0XtxCV6ZPMycYBw
         L+3PAxwg7CmpDrAnkKDlbzrQgZcSqDnzjg49vhJrJNH6eBhohweULj+0a7IPidwxs/ob
         fqdg==
X-Gm-Message-State: AO0yUKWa7T5G0qthD/xY1KXxdjJm01YH9enOvNkJy6wRk0MO5a1UmrZC
        xwxQnOxHpGPYtxlNb+khH9rZMt0XHRbYNA==
X-Google-Smtp-Source: AK7set/h9yBVEHOz+fq7oy9Hvsr329fhqaqFav/RFUkgDcRVJWuencg19GaWyjmVy2SE1fiiuxhvvJqwu7SlJA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:bc7:0:b0:b3b:6452:6a0d with SMTP id
 c7-20020a5b0bc7000000b00b3b64526a0dmr6594259ybr.1.1678894969989; Wed, 15 Mar
 2023 08:42:49 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:39 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-3-edumazet@google.com>
Subject: [PATCH net-next 2/8] ipv4: constify ip_mc_sf_allow() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies ip_mc_sf_allow() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/igmp.h | 2 +-
 net/ipv4/igmp.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index b19d3284551f083d0eec3353cd8ec1f486ae4b42..ebf4349a53af7888104e8c5fe0d7af0e5604ae69 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -122,7 +122,7 @@ extern int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 			sockptr_t optval, sockptr_t optlen);
 extern int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 			sockptr_t optval, size_t offset);
-extern int ip_mc_sf_allow(struct sock *sk, __be32 local, __be32 rmt,
+extern int ip_mc_sf_allow(const struct sock *sk, __be32 local, __be32 rmt,
 			  int dif, int sdif);
 extern void ip_mc_init_dev(struct in_device *);
 extern void ip_mc_destroy_dev(struct in_device *);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index c920aa9a62a988bf91a5420e59eb5878c271bf9a..48ff5f13e7979dc00da60b466ee2e74ddce0891b 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2638,10 +2638,10 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 /*
  * check if a multicast source filter allows delivery for a given <src,dst,intf>
  */
-int ip_mc_sf_allow(struct sock *sk, __be32 loc_addr, __be32 rmt_addr,
+int ip_mc_sf_allow(const struct sock *sk, __be32 loc_addr, __be32 rmt_addr,
 		   int dif, int sdif)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 	struct ip_mc_socklist *pmc;
 	struct ip_sf_socklist *psl;
 	int i;
-- 
2.40.0.rc1.284.g88254d51c5-goog

