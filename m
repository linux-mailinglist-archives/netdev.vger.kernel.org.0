Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B21E60D2F0
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbiJYSFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiJYSFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:05:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DDD1C7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:05:49 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360b9418f64so123575597b3.7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=V0skQFdg5JnfcNFlatPVF0W08c01aatwfTpfNeiCg0c=;
        b=bbESu979VNmcxMaCMmerf8fsUVPFv8F/8OJCWMVvw2dJ4qKreBKvNRbBj0KJtZcO+q
         PycfSs1F6jpV0LhjlrRqMfNB+6pqb3rbl9iFJxD/bZfkdRNYcWryNfN6sYJwiuJEZFTc
         aHdWXzuct7WJ/CoRIsgHm0ZPLxHmDO6ErZ5VRbFOuqvmADubm4nWRj6roBkSz5NnBTjA
         M+Ahiid2yIoUDca5v0530saMM27eWqjZIv6Y1c6CRpWXG+mYDOfknFbaLrl6rFz8yzmq
         ok27CbYNvKfVUxQHT/82vXSa9SbrExQH5d9QKuaemPdGuPhA/ZAJfKw9zal3dibHFEaj
         fTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V0skQFdg5JnfcNFlatPVF0W08c01aatwfTpfNeiCg0c=;
        b=Z9+2m/Su1ZFhwGXHKhheK5m5zsRyOtX7B/gtG6TGXqUCz8+z3+DQfpr5c5kjO1j6AB
         oqoPd1PO/v8TMuVkIiz+TKdTA840/zOZSKZvMiPKulKZSyVbD0K5eO1sdvLnFUmiXqme
         4W2k4UUOu7SjLa4gD9NQTZg9Rryz7ueAcKrbWNlddeXbwcO/Trx8iBeajuc3uIEye+2g
         5nV6e4rUzt0e2Y3zs5pIkFrOGtA/S6BtllS2erqO48TQAHSCcv+VqHy2LjntQXAT6wbJ
         A1TzDL0N4eOxWi2j3RekgVbFjthY4z1XQqxoOX91F3WLb+PpU6rJu0S5fmVUIHHQyjKG
         Ivag==
X-Gm-Message-State: ACrzQf2b7nAwWmFZhbjqmKR+0C3OQ+rcw3E8qtq0YTt+DNQepgV+bpIy
        Z1vuxnxShpSJ7m2H2RvkBe+R9EaJFu9WOQ==
X-Google-Smtp-Source: AMsMyM7GG5lY+K+gn2HbdKK2vBb5NhOnmftGZR+Lgq4KiMz1g+c3OiCOejAmYRja62syi9VhPfJu0oSUIL+IKw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d6c3:0:b0:6ca:c74e:bd0b with SMTP id
 n186-20020a25d6c3000000b006cac74ebd0bmr2ybg.258.1666721148589; Tue, 25 Oct
 2022 11:05:48 -0700 (PDT)
Date:   Tue, 25 Oct 2022 18:05:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221025180546.652251-1-edumazet@google.com>
Subject: [PATCH net-next] mptcp: fix tracking issue in mptcp_subflow_create_socket()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
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

My recent patch missed that mptcp_subflow_create_socket()
was creating a 'kernel' socket, then converted it to 'user' socket.

Fixes: 0cafd77dcd03 ("net: add a refcount tracker for kernel sockets")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/mptcp/subflow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 07dd23d0fe04ac37f4cc66c0c21d4d41f50fb3f4..120f792fda9764271f020771b36d27c6e44d8618 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1595,7 +1595,9 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 
 	/* kernel sockets do not by default acquire net ref, but TCP timer
 	 * needs it.
+	 * Update ns_tracker to current stack trace and refcounted tracker.
 	 */
+	__netns_tracker_free(net, &sf->sk->ns_tracker, false);
 	sf->sk->sk_net_refcnt = 1;
 	get_net_track(net, &sf->sk->ns_tracker, GFP_KERNEL);
 	sock_inuse_add(net, 1);
-- 
2.38.0.135.g90850a2211-goog

