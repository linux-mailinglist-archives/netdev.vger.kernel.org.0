Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE6266DBB3
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbjAQLBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbjAQLBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:01:35 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C559D2331D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:01:34 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id j10-20020a05620a288a00b0070630ecfd9bso7271264qkp.20
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:01:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zgDOisqQY4khTeREa4/mVeCS308Srl2wAqZ7Yctk2nw=;
        b=tQ4HMt/wknqmDPJcWGElO2jhZ2cPr6FKU1fCWYoal7Q1mfM8YzW4UK4qrMUpGH4Tpi
         SiuUVtTgTgEo8jAvsyeU4ffTF/f68Jmpp6It5C6Bz+N6WeSpCUL3QG/ObyEPIAZAtqjI
         h0UUd9etTFP4V2Unk2D9hUbrPnycCJdPImpa/k9K/ykmjB3HrInqrQOEub4hNPaYDuG2
         75WrofG3Br6lEaXDfiWMx1j4rULwUaf9r8vVfBKgXq8ZROjlY/+mW4DgPwZGBk1Ii8Ky
         gBHqrqHkS7xfEB0MKYCNsDDPxvYi/OKXFxj7fNg5WJqEl4ykQssQFbflVDp1YI93HUbU
         BZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zgDOisqQY4khTeREa4/mVeCS308Srl2wAqZ7Yctk2nw=;
        b=rdbagtVo0r7illkWjcCVHQktcO4AW0ObKGnDljBkHPGSostcfSEaK4j9NWn4b85HsS
         bGB5ktoGdqTff6c3rRzAR8Y84Lj7Wt30kIinnON6WOSkPvUkg3f3i6D8nB9OsXZyiODm
         pT5wR3JD1FGe9Hcntj9JP+BaTO8Ihfm7dkdS16PGNMnuF1sQ9ogBfj8wYfgH2LehIkup
         /IUgef89ONCj4zeBHQS5e9OnB7w4G+hcIM/YHwqVUPStbnGx/DjCkxRTbVw3IHOli+eR
         otgGSeXK3FhPGoPihdutFwUpw7K0tDtaR0cVtXJO6aJsXZ1u6U5OEaXbQUbfRQZhDLn3
         xCjQ==
X-Gm-Message-State: AFqh2kruWM/J9OsCQ7xEkR9Dbobh6PDTaq8xxqG1pdzEEJcospvLyV+S
        wjki68fIvkkOHu1L37GKUl+CntP6w/y4EQ==
X-Google-Smtp-Source: AMrXdXtBWu8kd7H4hqO4taf1D0FZC1lGB2NDRl3QM7nMguJBy4gK6fO/50IfigPHy8Oc++Vwf79aNXyucXUZZg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:4015:b0:3b6:3b2c:698b with SMTP
 id cf21-20020a05622a401500b003b63b2c698bmr129471qtb.29.1673953293970; Tue, 17
 Jan 2023 03:01:33 -0800 (PST)
Date:   Tue, 17 Jan 2023 11:01:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230117110131.1362738-1-edumazet@google.com>
Subject: [PATCH net] l2tp: prevent lockdep issue in l2tp_tunnel_register()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        Guillaume Nault <gnault@redhat.com>
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

lockdep complains with the following lock/unlock sequence:

     lock_sock(sk);
     write_lock_bh(&sk->sk_callback_lock);
[1]  release_sock(sk);
[2]  write_unlock_bh(&sk->sk_callback_lock);

We need to swap [1] and [2] to fix this issue.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20230114030137.672706-1-xiyou.wangcong@gmail.com/T/#m1164ff20628671b0f326a24cb106ab3239c70ce3
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Guillaume Nault <gnault@redhat.com>
---
 net/l2tp/l2tp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b6554e32bb12ae7813cc06c01e4d1380af667375..03608d3ded4b83d1e59e064e482f54cffcdf5240 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1483,10 +1483,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	lock_sock(sk);
 	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
-	if (ret < 0) {
-		release_sock(sk);
+	if (ret < 0)
 		goto err_inval_sock;
-	}
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1523,6 +1521,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 err_inval_sock:
 	write_unlock_bh(&sk->sk_callback_lock);
+	release_sock(sk);
 
 	if (tunnel->fd < 0)
 		sock_release(sock);
-- 
2.39.0.314.g84b9a713c41-goog

