Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7465D664DCE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjAJVAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbjAJVAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:00:41 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE42D59537
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:00:40 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id m7-20020a9d73c7000000b00683e2f36c18so7780504otk.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlXDpErydlpRoJ0lGxaxPSrjQGCuT4kp3aRcNvAlXd4=;
        b=mx+TGREPMyk/+d+cV1YLb5nD1lTmdXWRJnHHtXfxmB+znwFHQa+19otuteZ80X+FrW
         5c3acL8dZ0h5QDQ2dCEeBjeEXzBVa3br/fMrnP+C2KEhn1ZaT4q+pkb4jkXeW46pPWmJ
         57r6zWloIsur4OyDczZBRUOS53CXnXmeWPTqa5Nvhj9LbB+81IyxKEI7hczVQ7Hkfbrb
         DEP8HTw7S4J2FOrhyXZlnU9bTwDiEqoVCh+nI1RuIxBS4YrLcXLw19VooP5bwWRnQ/WL
         N/2YQWvafikvKKiH1wQUszYRdb+JS6QgvrmAzBSfJXSiJGxpWMmSTfOjM2Vy2FoMEzB1
         y+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlXDpErydlpRoJ0lGxaxPSrjQGCuT4kp3aRcNvAlXd4=;
        b=46y0RYoNJYS4XnCEG1KqMhxZeIHl6eo0zZKNkiN8Un+tKKyCKooF3F+rC/xnU9nde4
         yvmyTLlxb3M9WOVovpMrOvFVGTJ7qyKDhBrmu1fuT7AvVADJe88BkUamAXzUxx/1D0bt
         I7ierBP1/gzAXZ/bmIsd40TBSiaWYqrQTOerabH5Mew9Tb0uUfhuAaHs1m0bz07VZZF8
         D2fv8/d3x+TIhDLAMjswScnavQRC9vnYheGU0aTAu1C0mdCdPrus9SDqZCA6GIysrV5X
         PNys45CyuHyC2cRalDnjsFxbhEA7AbT1MXht7D12sFCMGzrrWIsdp8n7HdDcdQDYy0FR
         KoZw==
X-Gm-Message-State: AFqh2kqghkAwsR0XVrgLOhwntF6qrF8bDKu06aYCCv99+YxY/m7jyEu5
        gKD5PeWHfDSkFh5zRML6Q+QEznVeycM=
X-Google-Smtp-Source: AMrXdXtjR2alsA3yQ8GVxKxuLmkK7idms6WlzfDX19d98se2uOgo+Q0zODLd4FenlE5n1AbQ7+kcWQ==
X-Received: by 2002:a9d:6255:0:b0:676:88d1:575c with SMTP id i21-20020a9d6255000000b0067688d1575cmr6324otk.14.1673384439867;
        Tue, 10 Jan 2023 13:00:39 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:f305:c94a:147a:7bd2])
        by smtp.gmail.com with ESMTPSA id b10-20020a056830104a00b0066e93d2b858sm6518854otp.55.2023.01.10.13.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 13:00:39 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     saeed@kernel.org, gnault@redhat.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net v2 2/2] l2tp: close all race conditions in l2tp_tunnel_register()
Date:   Tue, 10 Jan 2023 13:00:30 -0800
Message-Id: <20230110210030.593083-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110210030.593083-1-xiyou.wangcong@gmail.com>
References: <20230110210030.593083-1-xiyou.wangcong@gmail.com>
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
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/l2tp/l2tp_core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 894bc9ff0e71..52a50b2f699e 100644
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

