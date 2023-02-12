Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F2A693882
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 17:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBLQ1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 11:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjBLQ1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 11:27:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85612057
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 08:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676219206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yeYEHWIK9fjX2YX7qbSY+5zehyoXDxenOialobzaTXk=;
        b=RQO1q37mPnEmXpzNTjLUrOKxFwJZanEIPT6/0nrjavrN1Vs1m41K8bWjqhVVYXqf1dv3GO
        m7HPmksMsVSKli07xl6iMr+p/WxW0VAh2IojYRKVkpKuqpMDasjTwmVYksNoPLml6c4QJy
        ZmvzpntdQZ3SLjOzMqQ541u94NBcZjc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-ZPSeqUhFMvqOV3i02SHa0Q-1; Sun, 12 Feb 2023 11:26:45 -0500
X-MC-Unique: ZPSeqUhFMvqOV3i02SHa0Q-1
Received: by mail-pf1-f198.google.com with SMTP id ds10-20020a056a004aca00b0059c8629c220so5054587pfb.23
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 08:26:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yeYEHWIK9fjX2YX7qbSY+5zehyoXDxenOialobzaTXk=;
        b=UNuPpS8itNwKtsoFOflM6KnrEId/Yh721nh7vVoNuvjwUtwpFGstjT8W32ddCpoby+
         cg7zOUlIWuE6gHZAQbpae0HASlM6eDdyGC+X1OmygJ2rR06GR53QAcgL53CQ4BWdKrw0
         OxMg8J69HI7qHt/OvGeLifv1MIP6WlYiuKWKlyS2a0ivYM0pw6JreqfJ2qV8W2cOKdDV
         RY3r5LuEawyU7Q3K+hk1oYWz8KH1+iOFnoauVakvQk/nl3OlOFETX3N3hFvNZDvluNZ+
         PB8xuZ/tS+FXzGTT5jLwTJE1nT+LxXGbm4yApdXScW4eRjpdBVQAyD+ZNyieVjl4MXfj
         yu1g==
X-Gm-Message-State: AO0yUKVxAHHDGvESfI48cnzHs7527I1Sg5OONBtT2j4LuS2I1WbdJ7F0
        mOmsc9wcyPM++L2WNJ4ol471CIJdulzEP+WNQHY4hbeqkrONR7j93mkWGDxfHQUs5MvjBRARhx7
        K53ghyN9YtlwjRDQGe5jema1g
X-Received: by 2002:a62:2582:0:b0:593:b169:ae51 with SMTP id l124-20020a622582000000b00593b169ae51mr16074841pfl.32.1676219203927;
        Sun, 12 Feb 2023 08:26:43 -0800 (PST)
X-Google-Smtp-Source: AK7set94DFtGn5+x/foEH514GWukPtkIpzLVTSdgqa86oZciglGiTlu/I+jaW076ug5lEAO1sw66RQ==
X-Received: by 2002:a62:2582:0:b0:593:b169:ae51 with SMTP id l124-20020a622582000000b00593b169ae51mr16074826pfl.32.1676219203598;
        Sun, 12 Feb 2023 08:26:43 -0800 (PST)
Received: from localhost.localdomain ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id y4-20020aa78544000000b005a81885f342sm6352853pfn.21.2023.02.12.08.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 08:26:43 -0800 (PST)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     gnault@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH v2] l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()
Date:   Mon, 13 Feb 2023 01:26:23 +0900
Message-Id: <20230212162623.2301597-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a file descriptor of pppol2tp socket is passed as file descriptor
of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
This situation is reproduced by the following program:

int main(void)
{
	int sock;
	struct sockaddr_pppol2tp addr;

	sock = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
	if (sock < 0) {
		perror("socket");
		return 1;
	}

	addr.sa_family = AF_PPPOX;
	addr.sa_protocol = PX_PROTO_OL2TP;
	addr.pppol2tp.pid = 0;
	addr.pppol2tp.fd = sock;
	addr.pppol2tp.addr.sin_family = PF_INET;
	addr.pppol2tp.addr.sin_port = htons(0);
	addr.pppol2tp.addr.sin_addr.s_addr = inet_addr("192.168.0.1");
	addr.pppol2tp.s_tunnel = 1;
	addr.pppol2tp.s_session = 0;
	addr.pppol2tp.d_tunnel = 0;
	addr.pppol2tp.d_session = 0;

	if (connect(sock, (const struct sockaddr *)&addr, sizeof(addr)) < 0) {
		perror("connect");
		return 1;
	}

	return 0;
}

This program causes the following lockdep warning:

 ============================================
 WARNING: possible recursive locking detected
 6.2.0-rc5-00205-gc96618275234 #56 Not tainted
 --------------------------------------------
 repro/8607 is trying to acquire lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: l2tp_tunnel_register+0x2b7/0x11c0

 but task is already holding lock:
 ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(sk_lock-AF_PPPOX);
   lock(sk_lock-AF_PPPOX);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

 1 lock held by repro/8607:
  #0: ffff8880213c8130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xa82/0x1a30

 stack backtrace:
 CPU: 0 PID: 8607 Comm: repro Not tainted 6.2.0-rc5-00205-gc96618275234 #56
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x100/0x178
  __lock_acquire.cold+0x119/0x3b9
  ? lockdep_hardirqs_on_prepare+0x410/0x410
  lock_acquire+0x1e0/0x610
  ? l2tp_tunnel_register+0x2b7/0x11c0
  ? lock_downgrade+0x710/0x710
  ? __fget_files+0x283/0x3e0
  lock_sock_nested+0x3a/0xf0
  ? l2tp_tunnel_register+0x2b7/0x11c0
  l2tp_tunnel_register+0x2b7/0x11c0
  ? sprintf+0xc4/0x100
  ? l2tp_tunnel_del_work+0x6b0/0x6b0
  ? debug_object_deactivate+0x320/0x320
  ? lockdep_init_map_type+0x16d/0x7a0
  ? lockdep_init_map_type+0x16d/0x7a0
  ? l2tp_tunnel_create+0x2bf/0x4b0
  ? l2tp_tunnel_create+0x3c6/0x4b0
  pppol2tp_connect+0x14e1/0x1a30
  ? pppol2tp_put_sk+0xd0/0xd0
  ? aa_sk_perm+0x2b7/0xa80
  ? aa_af_perm+0x260/0x260
  ? bpf_lsm_socket_connect+0x9/0x10
  ? pppol2tp_put_sk+0xd0/0xd0
  __sys_connect_file+0x14f/0x190
  __sys_connect+0x133/0x160
  ? __sys_connect_file+0x190/0x190
  ? lockdep_hardirqs_on+0x7d/0x100
  ? ktime_get_coarse_real_ts64+0x1b7/0x200
  ? ktime_get_coarse_real_ts64+0x147/0x200
  ? __audit_syscall_entry+0x396/0x500
  __x64_sys_connect+0x72/0xb0
  do_syscall_64+0x38/0xb0
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

This patch fixes the issue by getting/creating the tunnel before
locking the pppol2tp socket.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
v2: Get/create the tunnel before locking the pppol2tp socket suggested
    by Guillaume Nault.
v1: https://lore.kernel.org/all/20230130154438.1373750-1-syoshida@redhat.com/

 net/l2tp/l2tp_ppp.c | 118 ++++++++++++++++++++++++--------------------
 1 file changed, 64 insertions(+), 54 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index db2e584c625e..68d02e217ca3 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -650,6 +650,65 @@ static int pppol2tp_tunnel_mtu(const struct l2tp_tunnel *tunnel)
 	return mtu - PPPOL2TP_HEADER_OVERHEAD;
 }
 
+static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
+					       struct l2tp_connect_info *info,
+					       bool *new_tunnel)
+{
+	struct l2tp_tunnel *tunnel;
+	int error;
+
+	*new_tunnel = false;
+
+	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
+
+	/* Special case: create tunnel context if session_id and
+	 * peer_session_id is 0. Otherwise look up tunnel using supplied
+	 * tunnel id.
+	 */
+	if (!info->session_id && !info->peer_session_id) {
+		if (!tunnel) {
+			struct l2tp_tunnel_cfg tcfg = {
+				.encap = L2TP_ENCAPTYPE_UDP,
+			};
+
+			/* Prevent l2tp_tunnel_register() from trying to set up
+			 * a kernel socket.
+			 */
+			if (info->fd < 0)
+				return ERR_PTR(-EBADF);
+
+			error = l2tp_tunnel_create(info->fd,
+						   info->version,
+						   info->tunnel_id,
+						   info->peer_tunnel_id, &tcfg,
+						   &tunnel);
+			if (error < 0)
+				return ERR_PTR(error);
+
+			l2tp_tunnel_inc_refcount(tunnel);
+			error = l2tp_tunnel_register(tunnel, net, &tcfg);
+			if (error < 0) {
+				kfree(tunnel);
+				return ERR_PTR(error);
+			}
+
+			*new_tunnel = true;
+		}
+	} else {
+		/* Error if we can't find the tunnel */
+		if (!tunnel)
+			return ERR_PTR(-ENOENT);
+
+		/* Error if socket is not prepped */
+		if (!tunnel->sock) {
+			l2tp_tunnel_dec_refcount(tunnel);
+			return ERR_PTR(-ENOENT);
+		}
+	}
+
+	return tunnel;
+}
+
 /* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
  */
 static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
@@ -663,7 +722,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	struct pppol2tp_session *ps;
 	struct l2tp_session_cfg cfg = { 0, };
 	bool drop_refcnt = false;
-	bool drop_tunnel = false;
 	bool new_session = false;
 	bool new_tunnel = false;
 	int error;
@@ -672,6 +730,10 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	if (error < 0)
 		return error;
 
+	tunnel = pppol2tp_tunnel_get(sock_net(sk), &info, &new_tunnel);
+	if (IS_ERR(tunnel))
+		return PTR_ERR(tunnel);
+
 	lock_sock(sk);
 
 	/* Check for already bound sockets */
@@ -689,57 +751,6 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	if (!info.tunnel_id)
 		goto end;
 
-	tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
-	if (tunnel)
-		drop_tunnel = true;
-
-	/* Special case: create tunnel context if session_id and
-	 * peer_session_id is 0. Otherwise look up tunnel using supplied
-	 * tunnel id.
-	 */
-	if (!info.session_id && !info.peer_session_id) {
-		if (!tunnel) {
-			struct l2tp_tunnel_cfg tcfg = {
-				.encap = L2TP_ENCAPTYPE_UDP,
-			};
-
-			/* Prevent l2tp_tunnel_register() from trying to set up
-			 * a kernel socket.
-			 */
-			if (info.fd < 0) {
-				error = -EBADF;
-				goto end;
-			}
-
-			error = l2tp_tunnel_create(info.fd,
-						   info.version,
-						   info.tunnel_id,
-						   info.peer_tunnel_id, &tcfg,
-						   &tunnel);
-			if (error < 0)
-				goto end;
-
-			l2tp_tunnel_inc_refcount(tunnel);
-			error = l2tp_tunnel_register(tunnel, sock_net(sk),
-						     &tcfg);
-			if (error < 0) {
-				kfree(tunnel);
-				goto end;
-			}
-			drop_tunnel = true;
-			new_tunnel = true;
-		}
-	} else {
-		/* Error if we can't find the tunnel */
-		error = -ENOENT;
-		if (!tunnel)
-			goto end;
-
-		/* Error if socket is not prepped */
-		if (!tunnel->sock)
-			goto end;
-	}
-
 	if (tunnel->peer_tunnel_id == 0)
 		tunnel->peer_tunnel_id = info.peer_tunnel_id;
 
@@ -840,8 +851,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	}
 	if (drop_refcnt)
 		l2tp_session_dec_refcount(session);
-	if (drop_tunnel)
-		l2tp_tunnel_dec_refcount(tunnel);
+	l2tp_tunnel_dec_refcount(tunnel);
 	release_sock(sk);
 
 	return error;
-- 
2.39.0

