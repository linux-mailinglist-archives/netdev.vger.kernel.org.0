Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776245269A7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377285AbiEMS4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383444AbiEMS4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB616B7EE
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id n10so8813830pjh.5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kshGRh47Lv/RpWJVN8MRf307VuzALDrIBwl//zwEEZU=;
        b=Qxy73m+rmcukqNo/rc1h9c+6dwBct8LqvXAM/9mQxCNWC9Fmj/5P31QRlfHflzI8On
         swjmO4z3nQsDVlm6i0Cl8FohyNqx9BtlO6VFowJmCS7eU1MJXQtRUcMn2cH5Jrk0Lxcw
         8nMkOL5oX4KcXA3Qy1c90lCBBZqtNqZ6nWYXcXDwZPRnDHdsv2tVn3vRv+F5QdUxc4UJ
         K9JsIPc/9dBHOrPrTjawM0o2FtbJ0xGR1wNXXIgMjPHxrHKWVSSEnFiMakLUUq6VmCnE
         jZhJqLpNGPtrIwDprfOP4E8yNW+7gB79+/SXGwVUuRrLR84oXJ9MQWEkVptJPQ9Yi7mJ
         z35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kshGRh47Lv/RpWJVN8MRf307VuzALDrIBwl//zwEEZU=;
        b=HUKStaPhno9DAbDvfLYFvEgBaR7uYj6XpF4pfwXxQQ3EDadfmQM1/5Sw/kn0IvA0pA
         puAuRI953P+l8tOwfyu2ErA+oPt7pGmLDrX2xHRoikXGA50v4pjANlTbezVWvPPGbJTD
         YAWPK+PoxyBHN5nzWrG3yA2hRKxSOoOR/hh7txYbn53UPhWKyonfaUa047lSALX90DYz
         dTlreyxQwPvaUfxxp8IRnjoPGix9f1yq0JuzWi4Pru5xPXJnNsREtoCbxwbgXb8j0201
         zRukusNavqi5HE1t35RbJtY7fAu4E/otoZfU03nLzcN9pqS8TAWN0WT/tzKaPqpEimDD
         S6wQ==
X-Gm-Message-State: AOAM530AZwRb1NwXAFCFw1F6KnafEC0xAMnddsDRLRh4YBR4DHw5yrHm
        EwPm5al5i4zgOR2UK+EDBuQ=
X-Google-Smtp-Source: ABdhPJzyGmqKo3Y7RFt6ZikUmtGYtIbafKUlctgsFLVxsFDP/VsCrzTdRlqKdbqkVT1jUsgnKt2WlQ==
X-Received: by 2002:a17:90b:3812:b0:1dc:8502:2479 with SMTP id mq18-20020a17090b381200b001dc85022479mr6287668pjb.97.1652468159802;
        Fri, 13 May 2022 11:55:59 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:55:59 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 04/10] net: core: add READ_ONCE/WRITE_ONCE annotations for sk->sk_bound_dev_if
Date:   Fri, 13 May 2022 11:55:44 -0700
Message-Id: <20220513185550.844558-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
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

sock_bindtoindex_locked() needs to use WRITE_ONCE(sk->sk_bound_dev_if, val),
because other cpus/threads might locklessly read this field.

sock_getbindtodevice(), sock_getsockopt() need READ_ONCE()
because they run without socket lock held.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6b287eb5427b32865d25fc22122fefeff3a4ccf5..2500f9989117441a67ce2c457af25bf8f780b110 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -635,7 +635,9 @@ static int sock_bindtoindex_locked(struct sock *sk, int ifindex)
 	if (ifindex < 0)
 		goto out;
 
-	sk->sk_bound_dev_if = ifindex;
+	/* Paired with all READ_ONCE() done locklessly. */
+	WRITE_ONCE(sk->sk_bound_dev_if, ifindex);
+
 	if (sk->sk_prot->rehash)
 		sk->sk_prot->rehash(sk);
 	sk_dst_reset(sk);
@@ -713,10 +715,11 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 {
 	int ret = -ENOPROTOOPT;
 #ifdef CONFIG_NETDEVICES
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 	struct net *net = sock_net(sk);
 	char devname[IFNAMSIZ];
 
-	if (sk->sk_bound_dev_if == 0) {
+	if (bound_dev_if == 0) {
 		len = 0;
 		goto zero;
 	}
@@ -725,7 +728,7 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 	if (len < IFNAMSIZ)
 		goto out;
 
-	ret = netdev_get_name(net, devname, sk->sk_bound_dev_if);
+	ret = netdev_get_name(net, devname, bound_dev_if);
 	if (ret)
 		goto out;
 
@@ -1861,7 +1864,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BINDTOIFINDEX:
-		v.val = sk->sk_bound_dev_if;
+		v.val = READ_ONCE(sk->sk_bound_dev_if);
 		break;
 
 	case SO_NETNS_COOKIE:
-- 
2.36.0.550.gb090851708-goog

