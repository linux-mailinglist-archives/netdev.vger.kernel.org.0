Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657BD65F428
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbjAETOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjAETOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:14:05 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21ED760CCE
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:14:04 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id w72so842651vkw.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 11:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUNtFtg59XzZJZQiS78JVVHreWqIoiQajJJjQB/0S3I=;
        b=EqcL4xTFMQH/iQzpvd6KYcdSH0e4WzjEr1NO5suIzl4+lMxJxTuReLy/EqGd1AVqcX
         RSZ1nRe9+YUg2eS5lVvUnLqJwkijhUt5FtQAEQwoQkKN9uGD7rjORfNrw2TGBWAxmzEv
         6+Px8xowM8qQI60cHM8Re+d5p1BLMIhG5AfdtQ11ILSUbU8R/X1FaPIcTTGK3P5GLvfA
         i+KAZZcDaD0H6QvVm7LOp7Fm6+sPoyu+cVg2PDXoco2PsM+wROKQPPGBl1MssmZQK+a6
         nDdUVPtQ4vVBCZC9axUCtK3dEoBiriGCY5BIdMVj/MSKeKfJcZeyN7rlHhqrhVHL0KY+
         hgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUNtFtg59XzZJZQiS78JVVHreWqIoiQajJJjQB/0S3I=;
        b=s3C9Z6BTE5auovY22/vTQy5vDbWYI9ZrDjEbVqTaQ8WtkujfkzyHXt3efHpWJcJamr
         HKqYyb/AZS8vbUqsndgeXyS2UnTJhTT9swfjGRQn8X482KR+6pinKVTsBuu9d9IbPAy2
         JojdRZVRzG/hPFuL27ZGge1zWebVFagAg5Vi6Q6a8I6z1MyWESuO4vZMcW3Q/cnm5Vrq
         SQKgaxKMIF9qhg3s67tnVx6lp7phZHVzwwoIyOlwi1YCbUWpMyXpA7uLW9a/WH7xCAaU
         xVXa3GH/YSwdbb0GPzCdfNjtJ0+2I54E6BEjRWZUxm8MCCpd4tow4Q5nlgD5xNnMwQQw
         OM/Q==
X-Gm-Message-State: AFqh2koRF5OVwcHOenJi/ojGsKYYMUSlcpAT6DFS9eqdMuXFx644IYi7
        SYcz5r8+98X50NMzwcH7+jbHbMpx2Bo=
X-Google-Smtp-Source: AMrXdXv0flIjUFI7eBOOSWWqDWMyRSANbp7RN05Ish14DbYhxqnVxjW7+2dwl7irw6lxPLrwByM64g==
X-Received: by 2002:a1f:de87:0:b0:3d5:7838:1f30 with SMTP id v129-20020a1fde87000000b003d578381f30mr15376060vkg.14.1672946043257;
        Thu, 05 Jan 2023 11:14:03 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2455:1dfe:a46b:fd61])
        by smtp.gmail.com with ESMTPSA id 195-20020a370ccc000000b006fec1c0754csm25721804qkm.87.2023.01.05.11.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:14:02 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     g.nault@alphalink.fr, Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net 2/2] l2tp: close all race conditions in l2tp_tunnel_register()
Date:   Thu,  5 Jan 2023 11:13:39 -0800
Message-Id: <20230105191339.506839-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
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
Cc: Guillaume Nault <g.nault@alphalink.fr>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/l2tp/l2tp_core.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 570249a91c6c..3cb5cbfd4399 100644
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
@@ -1376,8 +1376,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
 	return err;
 }
 
-static struct lock_class_key l2tp_socket_class;
-
 void l2tp_tunnel_remove(struct l2tp_tunnel *tunnel)
 {
 	struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
@@ -1492,22 +1490,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
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
 
-	pn = l2tp_pernet(net);
-
-	sock_hold(sk);
-	tunnel->sock = sk;
-
-	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
-	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
-	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
@@ -1518,12 +1510,19 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 		setup_udp_tunnel_sock(net, sock, &udp_cfg);
 	}
-
 	tunnel->old_sk_destruct = sk->sk_destruct;
 	sk->sk_destruct = &l2tp_tunnel_destruct;
-	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
-				   "l2tp_sock");
 	sk->sk_allocation = GFP_ATOMIC;
+	release_sock(sk);
+
+	pn = l2tp_pernet(net);
+
+	sock_hold(sk);
+	tunnel->sock = sk;
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	trace_register_tunnel(tunnel);
 
-- 
2.34.1

