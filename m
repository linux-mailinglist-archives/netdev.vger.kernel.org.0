Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DD166A8D0
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjANDB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjANDBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:01:54 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883A7101C6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:01:53 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-15ebfdf69adso6826438fac.0
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Swe26wQ+SPyRd0XigKtEUB9teoQvlTBIRWEdQ1ch4aI=;
        b=YDsW4tjKuWB/hpV62gYNrMGoaXXvY25dCux2sNEzcJmeMC/zHZmrubmfy8VqpFiC3L
         MsObLlELkLg/z7zcxiobQvSMKt2tzVPyUyyE6Gjc+J2AFaZAee1V3tDsbtBLZoWz8cGU
         ct5FH2ihuA9rxTuNOCREK9HhzXCrA1jNUUHynmFV4ueeeDja3NkculZgCfMVn9d9ZnF2
         6HH/hv7DUfaj2TN/trdQBNi18QqC9uiXJiFT8DUIg3zWl9127Q+6gk7igLNS3fsYz+J9
         XYd8Gcmfj9gca2DF2UHdOfGPH00OT8rBmd1gUfMjcIhJAuS7kJ5KE6VhUwB8HMWiMZck
         eF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Swe26wQ+SPyRd0XigKtEUB9teoQvlTBIRWEdQ1ch4aI=;
        b=5kY90LiSwusJJ+XxIRf+EfRPV1ikEQvqES3jj04DToOi/Axgo720MPbpa988HeV2dT
         aRAO1amxfdFDcc3fX97pafvRxrh/TyQqqDc5fQXh+zD4gqQ/jxtpduQHer9g9K2UIBh8
         tfe8QbieViScSrCrKbMU2x7R4Mz5/AQsm9qgVsJDAUMi59FgJcHvIbTBZWDcxEF6pR60
         rtIWGV9nxV1QbCNqTtCMJGSmmXSfKqXAaTfcVCqbVQXGmWb6NzPCPunSjtld1v5x9ms5
         rGrxhHeEVsqy19cjHcQo8JicVKKIBpwoAYwsmIRCXqDHTB7TgishY1xeudPdQvdAFLfC
         jhBQ==
X-Gm-Message-State: AFqh2ko4vwdHBthmxX8G7L65C2FPC/MM6co6ccwQT/JxYBKU4PJmIMdL
        x06EAuSrJ2siWo9fPREAv1HakPezQVA=
X-Google-Smtp-Source: AMrXdXvRIF3Sqjn9NI8O6MwgF7ArBfUfMn752lDYMjwej3arA5UoNjumsoZ1ZWlgyQXMO9pdHNfrnA==
X-Received: by 2002:a05:6870:79a:b0:15e:d91b:1a89 with SMTP id en26-20020a056870079a00b0015ed91b1a89mr3176206oab.5.1673665312578;
        Fri, 13 Jan 2023 19:01:52 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:dacd:7392:c8c1:daec])
        by smtp.gmail.com with ESMTPSA id m34-20020a056870562200b00143ae7d4ccesm11445568oao.45.2023.01.13.19.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:01:52 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     saeed@kernel.org, gnault@redhat.com, tparkin@katalix.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net v3 2/2] l2tp: close all race conditions in l2tp_tunnel_register()
Date:   Fri, 13 Jan 2023 19:01:37 -0800
Message-Id: <20230114030137.672706-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The code in l2tp_tunnel_register() is racy in several ways:

1. It modifies the tunnel socket _after_ publishing it.

2. It calls setup_udp_tunnel_sock() on an existing socket without
   locking.

3. It changes sock lock class on fly, which triggers many syzbot
   reports.

This patch amends all of them by moving socket initialization code
before publishing and under sock lock. As suggested by Jakub, the
l2tp lockdep class is not necessary as we can just switch to
bh_lock_sock_nested().

Fixes: 37159ef2c1ae ("l2tp: fix a lockdep splat")
Fixes: 6b9f34239b00 ("l2tp: fix races in tunnel creation")
Reported-by: syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com
Reported-by: syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Guillaume Nault <gnault@redhat.com>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Tom Parkin <tparkin@katalix.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/l2tp/l2tp_core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index e9c0ce0b7972..b6554e32bb12 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1041,7 +1041,7 @@ static int l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb, uns
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED | IPSKB_REROUTED);
 	nf_reset_ct(skb);
 
-	bh_lock_sock(sk);
+	bh_lock_sock_nested(sk);
 	if (sock_owned_by_user(sk)) {
 		kfree_skb(skb);
 		ret = NET_XMIT_DROP;
@@ -1385,8 +1385,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
 	return err;
 }
 
-static struct lock_class_key l2tp_socket_class;
-
 int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
@@ -1482,21 +1480,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	}
 
 	sk = sock->sk;
+	lock_sock(sk);
 	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
-	if (ret < 0)
+	if (ret < 0) {
+		release_sock(sk);
 		goto err_inval_sock;
+	}
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sock_hold(sk);
-	tunnel->sock = sk;
-	tunnel->l2tp_net = net;
-
-	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
-	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
-	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
@@ -1510,9 +1503,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
-	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-				   "l2tp_sock");
 	sk->sk_allocation = GFP_ATOMIC;
+	release_sock(sk);
+
+	sock_hold(sk);
+	tunnel->sock = sk;
+	tunnel->l2tp_net = net;
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	trace_register_tunnel(tunnel);
 
-- 
2.34.1

